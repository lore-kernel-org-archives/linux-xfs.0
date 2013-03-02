Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F268B8006
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 14:20:08 -0600 (CST)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDE48304059
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 12:20:05 -0800 (PST)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r22KK6GY002665
	for <xfs@oss.sgi.com>; Sat, 2 Mar 2013 14:20:06 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130302201452.236378200@sgi.com>
Date: Sat, 02 Mar 2013 14:14:47 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: logsunit rounding causes iclog corruption/crash
References: <20130302201446.854313570@sgi.com>
Content-Disposition: inline;
	filename=xfs-limit-round-log-buffer-size-to-lsunit.patch
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

When the iclog buffer size and log stripe unit are both defined and
the log stripe unit is less the log buffer size then the buffer is
rounded up to the log stripe unit size during the xlog_sync().

This rounding can exceed the iclog buffer length and in xlog_data_pack():
 1) Cause corruption inside the iclog buffer because there will not be
    enough space for the headers in the front of the iclog buffer for
    the rounding.
 2) Cause corruption in memory that follows the iclog buffer when
    stamping the lsn in each of the rounded blocks.
 3) If CONFIG_XFS_DEBUG is defined will cause a crash in xlog_verify_iclog().
 4) Cause page fault crash if the memory after the buffer is not mapped.

This has been found in XFS versions at least as far back as
Linux 2.6.32.

This patch forces the iclog buffer to be a multiple of the log stripe
unit when they are both defined.

Example:
  # mkfs.xfs -l su=192k -f /dev/sda2
  # mount -o logbsize=256k /dev/sda3 /scratch
  # io such as fsstress in /scratch will immediately crash a debug xfs
    kernel and most like a non-debug xfs kernel.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_super.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: b/fs/xfs/xfs_super.c
===================================================================
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1357,11 +1357,23 @@ xfs_finish_flags(
 		if (mp->m_logbsize <= 0 &&
 		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
 			mp->m_logbsize = mp->m_sb.sb_logsunit;
-		} else if (mp->m_logbsize > 0 &&
-			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
-			xfs_warn(mp,
+		} else if (mp->m_logbsize > 0) {
+			if (mp->m_logbsize > mp->m_sb.sb_logsunit) {
+				int	logbsize;
+				/* round up to the next multiple of logsunit */
+				logbsize = roundup(mp->m_logbsize,
+							 mp->m_sb.sb_logsunit);
+				if (logbsize > XLOG_MAX_RECORD_BSIZE)
+					/* buffer size too large. round down. */
+					logbsize -= mp->m_sb.sb_logsunit;
+				xfs_warn(mp, "log bufsize rounded from %d to %d",
+					 mp->m_logbsize, logbsize);
+				mp->m_logbsize = logbsize;
+			} else if (mp->m_logbsize < mp->m_sb.sb_logsunit) {
+				xfs_warn(mp,
 		"logbuf size must be greater than or equal to log stripe size");
-			return XFS_ERROR(EINVAL);
+				return XFS_ERROR(EINVAL);
+			}
 		}
 	} else {
 		/* Fail a mount if the logbuf is larger than 32K */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
