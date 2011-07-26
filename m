Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QF7CX4131519 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 10:07:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68F8D984A2
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 08:07:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MOCMv2DFSCTKkoh1 for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 08:07:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QljDz-0004ic-Ub
	for xfs@oss.sgi.com; Tue, 26 Jul 2011 15:07:11 +0000
Date: Tue, 26 Jul 2011 11:07:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: prevent against ioend livelocks in xfs_file_fsync
Message-ID: <20110726150711.GB18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110726150633.GA17400@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com

We need to take some locks to prevent new ioends from coming in when we wait
for all existing ones to go away.  Up to Linux 3.0 that was done using the
i_mutex held by the VFS fsync code, but now that we are called without
it we need to take care of it ourselves.  Use the I/O lock instead of
i_mutex just like we do in other places.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2011-07-25 23:50:35.081563423 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2011-07-25 23:51:18.098229833 +0200
@@ -149,7 +149,9 @@ xfs_file_fsync(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	xfs_ioend_wait(ip);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER) {
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
