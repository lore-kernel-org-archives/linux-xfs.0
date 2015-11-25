Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF3817F5D
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:18:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EF43AC006
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:18:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1jsnWAozvPBAPjeu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:17:59 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 100FE71
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:17:59 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-225.bos.redhat.com [10.18.41.225])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAPKHw0v006972
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:17:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] libxfs: format the log with valid log record headers
Date: Wed, 25 Nov 2015 15:17:55 -0500
Message-Id: <1448482677-44364-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
References: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfsprogs supports the ability to clear or reformat the log to an
arbitrary cycle number. This functionality is invoked in mkfs,
xfs_repair, etc. The code currently fills the log with unmount records
sized based on the specified log stripe unit alignment. When the stripe
unit is sufficiently larger, however, the resulting log records are
technically invalid. For example, the log buffer size (h_size) field is
always hardcoded to 32k even when the particular record length is
larger.

This has not traditionally been a problem because the kernel does not
fully process the log record when the log is clean. Recent changes to
unconditionally CRC verify the head of the log changes this behavior,
however, which means the log should be valid. Technically, the records
written from userspace are not written with a CRC, but this also helps
support unit testing by writing a log that can be verified with
logprint.

Update libxfs_log_header() to write a valid log record based on the
specified log stripe unit. h_size is updated to the log buffer size
based on the stripe unit and the expected number of extended record
headers are written out based on the log buffer size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/rdwr.c | 74 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 17 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0804285..16904d0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -279,6 +279,7 @@ libxfs_log_header(
 	char			*p = caddr;
 	__be32			cycle_lsn;
 	int			i, len;
+	int			hdrs = 1;
 
 	if (lsn == NULLCOMMITLSN)
 		lsn = xlog_assign_lsn(XLOG_INIT_CYCLE, 0);
@@ -291,41 +292,80 @@ libxfs_log_header(
 	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 	head->h_cycle = cpu_to_be32(CYCLE_LSN(lsn));
 	head->h_version = cpu_to_be32(version);
-	if (len != 1)
-		head->h_len = cpu_to_be32(sunit - BBSIZE);
-	else
-		head->h_len = cpu_to_be32(20);
 	head->h_crc = cpu_to_le32(0);
 	head->h_prev_block = cpu_to_be32(-1);
 	head->h_num_logops = cpu_to_be32(1);
 	head->h_fmt = cpu_to_be32(fmt);
-	head->h_size = cpu_to_be32(XLOG_HEADER_CYCLE_SIZE);
+	head->h_size = cpu_to_be32(MAX(sunit, XLOG_BIG_RECORD_BSIZE));
 
 	head->h_lsn = cpu_to_be64(lsn);
 	head->h_tail_lsn = cpu_to_be64(tail_lsn);
 
 	memcpy(&head->h_fs_uuid, fs_uuid, sizeof(uuid_t));
 
-	p = nextfunc(p, BBSIZE, private);
-	unmount_record(p);
-
 	/*
-	 * The kernel expects to see either a log record header magic or the LSN
-	 * cycle at the top of every log block (for example, see
-	 * xlog_[un]pack_data() and xlog_get_cycle()). Pack the unmount record
-	 * block appropriately here.
+	 * The kernel expects to see either a log record header magic value or
+	 * the LSN cycle at the top of every log block. The first word of each
+	 * non-header block is copied to the record headers and replaced with
+	 * the cycle value (see xlog_[un]pack_data() and xlog_get_cycle() for
+	 * details).
+	 *
+	 * Even though we only ever write an unmount record (one block), we
+	 * support writing log records up to the max log buffer size of 256k to
+	 * improve log format performance. This means a record can require up
+	 * to 8 headers (1 rec. header + 7 ext. headers) for the packed cycle
+	 * data (each header supports 32k of data).
 	 */
 	cycle_lsn = CYCLE_LSN_DISK(head->h_lsn);
+	if (version == 2 && sunit > XLOG_HEADER_CYCLE_SIZE) {
+		hdrs = sunit / XLOG_HEADER_CYCLE_SIZE;
+		if (sunit % XLOG_HEADER_CYCLE_SIZE)
+			hdrs++;
+	}
+
+	/*
+	 * A fixed number of extended headers is expected based on h_size. If
+	 * required, format those now so the unmount record is located
+	 * correctly.
+	 *
+	 * Since we only write an unmount record, we only need one h_cycle_data
+	 * entry for the unmount record block. The subsequent record data
+	 * blocks are zeroed, which means we can stamp them directly with the
+	 * cycle and zero the rest of the cycle data in the extended headers.
+	 */
+	if (hdrs > 1) {
+		for (i = 1; i < hdrs; i++) {
+			p = nextfunc(p, BBSIZE, private);
+			memset(p, 0, BBSIZE);
+			/* xlog_rec_ext_header.xh_cycle */
+			*(__be32 *)p = cycle_lsn;
+		}
+	}
+
+	/*
+	 * The total length is the max of the stripe unit or 2 basic block
+	 * minimum (1 hdr blk + 1 data blk). The record length is the total
+	 * minus however many header blocks are required.
+	 */
+	head->h_len = cpu_to_be32(MAX(BBTOB(2), sunit) - hdrs * BBSIZE);
+
+	/*
+	 * Write out the unmount record, pack the first word into the record
+	 * header and stamp the block with the cycle.
+	 */
+	p = nextfunc(p, BBSIZE, private);
+	unmount_record(p);
+
 	head->h_cycle_data[0] = *(__be32 *)p;
 	*(__be32 *)p = cycle_lsn;
 
 	/*
-	 * Now zero any remaining blocks in the record and stamp with the cycle.
-	 * Note that we don't need to swap into h_cycle_data because it has
-	 * already been initialized to zero.
+	 * Finally, zero all remaining blocks in the record and stamp each with
+	 * the cycle. We don't need to pack any of these blocks because the
+	 * cycle data in the headers has already been zeroed.
 	 */
-	len = MAX(len, 2);
-	for (i = 2; i < len; i++) {
+	len = MAX(len, hdrs + 1);
+	for (i = hdrs + 1; i < len; i++) {
 		p = nextfunc(p, BBSIZE, private);
 		memset(p, 0, BBSIZE);
 		*(__be32 *)p = cycle_lsn;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
