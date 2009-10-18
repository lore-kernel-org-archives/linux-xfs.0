Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9INvdMd011645 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 18:57:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A978F133514D
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 16:59:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mUxpVw5w2Ohdgep3 for
	<xfs@oss.sgi.com>; Sun, 18 Oct 2009 16:59:11 -0700 (PDT)
Date: Sun, 18 Oct 2009 19:59:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091018235910.GA30045@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<89c4f90c0910150806g49c64037re550b478a7cf85e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <89c4f90c0910150806g49c64037re550b478a7cf85e@mail.gmail.com>
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
To: Tommy van Leeuwen <tommy@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Thu, Oct 15, 2009 at 05:06:57PM +0200, Tommy van Leeuwen wrote:
> > Thanks. ?The patch below should fix the inode reclaim race that could
> > lead to the double free you're seeing. ?To be applied ontop of all
> > the other patches I sent you.
> 
> Hi Christoph,
> 
> Here are 2 more crashes with this patch applied, both having xfs_debug
> on and showing different traces (not inode reclaim related?). Hope
> it's usefull.

Can't make too much sense of it, but the dir2 is something you reported
earlier already.  We must be stomping over inodes somewhere, but I'm
not too sure where exactly.  Can you try throwing the patch below ontop
of your stack?  It fixes an area where we could theoretically corrupt
inode state.

Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-10-16 22:54:41.513254291 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-10-16 22:57:10.451256293 +0200
@@ -180,6 +180,11 @@ xfs_sync_inode_valid(
 		return EFSCORRUPTED;
 	}
 
+	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)) {
+		read_unlock(&pag->pag_ici_lock);
+		return ENOENT;
+	}
+
 	/*
 	 * If we can't get a reference on the inode, it must be in reclaim.
 	 * Leave it for the reclaim code to flush. Also avoid inodes that
@@ -191,7 +196,7 @@ xfs_sync_inode_valid(
 	}
 	read_unlock(&pag->pag_ici_lock);
 
-	if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+	if (is_bad_inode(inode)) {
 		IRELE(ip);
 		return ENOENT;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
