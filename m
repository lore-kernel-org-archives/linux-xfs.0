Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB46wmLH031041 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 00:58:48 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 37B6830408C
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 22:58:46 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id RAA21190 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 17:58:44 +1100
Message-ID: <49377FBC.5020501@sgi.com>
Date: Thu, 04 Dec 2008 17:59:08 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Use the incore inode size in xfs_file_readdir()
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

We should be using the incore inode size here not the linux inode
size.  The incore inode size is always up to date for directories
whereas the linux inode size is not updated for directories.

We've hit assertions in xfs_bmap() and traced it back to the linux
inode size being zero here but the incore size being correct.

--- xfs-fix.orig/fs/xfs/linux-2.6/xfs_file.c
+++ xfs-fix/fs/xfs/linux-2.6/xfs_file.c
@@ -254,7 +254,7 @@ xfs_file_readdir(
  	 * point we can change the ->readdir prototype to include the
  	 * buffer size.
  	 */
-	bufsize = (size_t)min_t(loff_t, PAGE_SIZE, inode->i_size);
+	bufsize = (size_t)min_t(loff_t, PAGE_SIZE, ip->i_d.di_size);

  	error = xfs_readdir(ip, dirent, bufsize,
  				(xfs_off_t *)&filp->f_pos, filldir);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
