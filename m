Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 21:29:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m834TDf0004376
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 21:29:13 -0700
Message-ID: <48BE14BF.2010906@sgi.com>
Date: Wed, 03 Sep 2008 14:38:23 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Don't do I/O beyond eof when unreserving space
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

When unreserving space with boundaries that are not block aligned we round
up the start and round down the end boundaries and then use this function,
xfs_zero_remaining_bytes(), to zero the parts of the blocks that got dropped
during the rounding.  The problem is we don't consider if these blocks are
beyond eof.  Worse still is if we encounter delayed allocations beyond eof
we will try to use the magic delayed allocation block number as a real block
number.  If the file size is ever extended to expose these blocks then we'll
go through xfs_zero_eof() to zero them anyway.  Version 2 adds some comments.

--- a/fs/xfs/xfs_vnodeops.c	2008-09-03 14:28:09.000000000 +1000
+++ b/fs/xfs/xfs_vnodeops.c	2008-09-03 14:20:10.000000000 +1000
@@ -3160,6 +3162,13 @@ error1:	/* Just cancel transaction */
 /*
  * Zero file bytes between startoff and endoff inclusive.
  * The iolock is held exclusive and no blocks are buffered.
+ *
+ * This function is used by xfs_free_file_space() to zero
+ * partial blocks when the range to free is not block aligned.
+ * When unreserving space with boundaries that are not block
+ * aligned we round up the start and round down the end
+ * boundaries and then use this function to zero the parts of
+ * the blocks that got dropped during the rounding.
  */
 STATIC int
 xfs_zero_remaining_bytes(
@@ -3176,6 +3185,17 @@ xfs_zero_remaining_bytes(
 	int			nimap;
 	int			error = 0;
 
+	/*
+	 * Avoid doing I/O beyond eof - it's not necessary
+	 * since nothing can read beyond eof.  The space will
+	 * be zeroed when the file is extended anyway.
+	 */
+	if (startoff >= ip->i_size)
+		return 0;
+
+	if (endoff > ip->i_size)
+		endoff = ip->i_size;
+
 	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
 				XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp);
