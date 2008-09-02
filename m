Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 22:16:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m825FpBq008894
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 22:15:51 -0700
Message-ID: <48BCCE29.3070707@sgi.com>
Date: Tue, 02 Sep 2008 15:24:57 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Don't do I/O beyond eof when unreserving space
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
go through xfs_zero_eof() to zero them anyway.

--- a/fs/xfs/xfs_vnodeops.c	2008-09-02 14:54:24.000000000 +1000
+++ b/fs/xfs/xfs_vnodeops.c	2008-09-02 14:51:03.000000000 +1000
@@ -3176,6 +3176,12 @@ xfs_zero_remaining_bytes(
 	int			nimap;
 	int			error = 0;
 
+	if (startoff >= ip->i_size)
+		return 0;
+
+	if (endoff > ip->i_size)
+		endoff = ip->i_size;
+
 	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
 				XFS_IS_REALTIME_INODE(ip) ?
 				mp->m_rtdev_targp : mp->m_ddev_targp);
