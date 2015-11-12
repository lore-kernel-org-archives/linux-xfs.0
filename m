Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECCD17F6C
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A341CAC001
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dcw20R1TNP5aQgG5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 451B14AD67
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbS55032666
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/8] xfs: detect and handle invalid iclog size set by mkfs
Date: Thu, 12 Nov 2015 10:37:21 -0500
Message-Id: <1447342648-40012-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
References: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

XFS log records have separate fields for the record size and the iclog
size used to write the record. mkfs.xfs zeroes the log and writes an
unmount record to generate a clean log for the subsequent mount. The
userspace record logging code has a bug where the iclog size (h_size)
field of the log record is hardcoded to 32k, even if a log stripe unit
is specified. The log record length is correctly extended to the stripe
unit. Since the kernel log recovery code uses the h_size field to
determine the log buffer size, this means that the kernel can attempt to
read/process records larger than the buffer size and overrun the buffer.

This has historically not been a problem because the kernel doesn't
actually run through log recovery in the clean unmount case. Instead,
the kernel detects that a single unmount record exists between the head
and tail and pushes the tail forward such that the log is viewed as
clean (head == tail). Once CRC verification is enabled, however, all
records at the head of the log are verified for CRC errors and thus we
are susceptible to overrun problems if the iclog field is not correct.

While the core problem must be fixed in userspace, this is historical
behavior that must be detected in the kernel to avoid severe side
effects such as memory corruption and crashes. Update the log buffer
size calculation code to detect this condition, warn the user and resize
the log buffer based on the log stripe unit. Return a corruption error
in cases where this does not look like a clean filesystem (i.e., the log
record header indicates more than one operation).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c5ecaac..4f880d6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4245,7 +4245,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		blk_no;
 	char			*offset;
 	xfs_buf_t		*hbp, *dbp;
-	int			error = 0, h_size;
+	int			error = 0, h_size, h_len;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
@@ -4274,7 +4274,31 @@ xlog_do_recovery_pass(
 		error = xlog_valid_rec_header(log, rhead, tail_blk);
 		if (error)
 			goto bread_err1;
+
+		/*
+		 * xfsprogs has a bug where record length is based on lsunit but
+		 * h_size (iclog size) is hardcoded to 32k. Now that we
+		 * unconditionally CRC verify the unmount record, this means the
+		 * log buffer can be too small for the record and cause an
+		 * overrun.
+		 *
+		 * Detect this condition here. Use lsunit for the buffer size as
+		 * long as this looks like the mkfs case. Otherwise, return an
+		 * error to avoid a buffer overrun.
+		 */
 		h_size = be32_to_cpu(rhead->h_size);
+		h_len = be32_to_cpu(rhead->h_len);
+		if (h_len > h_size) {
+			if (h_len <= log->l_mp->m_logbsize &&
+			    be32_to_cpu(rhead->h_num_logops) == 1) {
+				xfs_warn(log->l_mp,
+		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
+					 h_size, log->l_mp->m_logbsize);
+				h_size = log->l_mp->m_logbsize;
+			} else
+				return -EFSCORRUPTED;
+		}
+
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
