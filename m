Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FD4C7F54
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 508E9304039
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qtmwuMOvKfGiPI1s (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:44 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 3F367C0B2B6D
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIth23020210
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 03/12] libxfs: don't hardcode cycle 1 into unmount op header
Date: Fri, 11 Sep 2015 14:55:33 -0400
Message-Id: <1441997742-37160-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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

The libxfs helper to write a log record after zeroing the log fills much
of the record header and unmount record with dummy data. It also
hardcodes the cycle number into the transaction oh_tid field as the
kernel expects to find the cycle stamped at the top of each block and
the original oh_tid value packed into h_cycle_data of the record header.

The log clearing code requires the ability to format the log to an
arbitrary cycle number to fix v5 superblock log recovery ordering
problems. As a result, the unmount record helper must not hardcode a
cycle of 1.

Fix up libxfs_log_header() to pack the unmount record appropriately, as
is already done for extra blocks that might exist beyond the record. Use
h_cycle_data for the original 32-bit word of the log record data block
and stamp the cycle number in its place. This allows unmount_record() to
work for arbitrary cycle numbers and libxfs_log_header() to pack a cycle
value that matches the lsn used in the record header. Note that this
patch does not change behavior as the lsn is still hardcoded to (1:0).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/rdwr.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index bc77699..ef18749 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -122,7 +122,7 @@ static void unmount_record(void *p)
 	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
 
 	memset(p, 0, BBSIZE);
-	op->oh_tid = cpu_to_be32(1);
+	op->oh_tid = cpu_to_be32(0xb0c0d0d0);
 	op->oh_len = cpu_to_be32(sizeof(magic));
 	op->oh_clientid = XFS_LOG;
 	op->oh_flags = XLOG_UNMOUNT_TRANS;
@@ -188,10 +188,6 @@ libxfs_log_header(
 
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
 
-	/* note that oh_tid actually contains the cycle number
-	 * and the tid is stored in h_cycle_data[0] - that's the
-	 * way things end up on disk.
-	 */
 	memset(p, 0, BBSIZE);
 	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 	head->h_cycle = cpu_to_be32(1);
@@ -203,7 +199,6 @@ libxfs_log_header(
 	head->h_crc = cpu_to_le32(0);
 	head->h_prev_block = cpu_to_be32(-1);
 	head->h_num_logops = cpu_to_be32(1);
-	head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
 	head->h_fmt = cpu_to_be32(fmt);
 	head->h_size = cpu_to_be32(XLOG_HEADER_CYCLE_SIZE);
 
@@ -212,11 +207,25 @@ libxfs_log_header(
 
 	memcpy(&head->h_fs_uuid, fs_uuid, sizeof(uuid_t));
 
-	len = MAX(len, 2);
 	p = nextfunc(p, BBSIZE, private);
 	unmount_record(p);
 
+	/*
+	 * The kernel expects to see either a log record header magic or the LSN
+	 * cycle at the top of every log block (for example, see
+	 * xlog_[un]pack_data() and xlog_get_cycle()). Pack the unmount record
+	 * block appropriately here.
+	 */
 	cycle_lsn = CYCLE_LSN_DISK(head->h_lsn);
+	head->h_cycle_data[0] = *(__be32 *)p;
+	*(__be32 *)p = cycle_lsn;
+
+	/*
+	 * Now zero any remaining blocks in the record and stamp with the cycle.
+	 * Note that we don't need to swap into h_cycle_data because it has
+	 * already been initialized to zero.
+	 */
+	len = MAX(len, 2);
 	for (i = 2; i < len; i++) {
 		p = nextfunc(p, BBSIZE, private);
 		memset(p, 0, BBSIZE);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
