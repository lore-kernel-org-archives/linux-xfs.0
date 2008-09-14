Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 06:15:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8EDEntA001289
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:14:51 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AF2D12967CA
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:16:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id RJuU6GTLsUGcHsfx for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:16:19 -0700 (PDT)
Date: Sun, 14 Sep 2008 09:16:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: remove i_gen from incore inode
Message-ID: <20080914131617.GA14266@infradead.org>
References: <1221313631-27727-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221313631-27727-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 11:47:11PM +1000, Dave Chinner wrote:
> i_gen is incremented in directory operations when the
> directory is changed. It is never read or otherwise used
> so it should be removed to help reduce the size of the
> struct xfs_inode.
> 
> The patch also removes a duplicate logging of the directory
> inode core. We only need to do this once per transaction
> so kill the one associated with the i_gen increment.

Still looks as good as when you posted it first month ago :)

And for reference here's the required fixup for xfsidbg:

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-08-11 13:02:32.000000000 -0300
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-08-11 13:36:50.000000000 -0300
@@ -3633,7 +3633,6 @@ xfs_prdinode_incore(xfs_icdinode_t *dip)
 		xfs_fmtformat((xfs_dinode_fmt_t)dip->di_aformat),
 		dip->di_dmevmask, dip->di_dmstate);
 	printflags(dip->di_flags, diflags, "flags");
-	kdb_printf("gen 0x%x\n", dip->di_gen);
 }
 
 #ifdef XFS_RW_TRACE
@@ -6385,11 +6384,8 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	kdb_printf("\n");
 	kdb_printf("update_core %d update size %d\n",
 		(int)(ip->i_update_core), (int) ip->i_update_size);
-	kdb_printf("gen 0x%x delayed blks %d",
-		ip->i_gen,
-		ip->i_delayed_blks);
-	kdb_printf("size %lld\n",
-		ip->i_size);
+	kdb_printf("delayed blks %d size %lld\n",
+		ip->i_delayed_blks, ip->i_size);
 
 #ifdef	XFS_INODE_TRACE
 	qprintf(" trace 0x%p\n", ip->i_trace);
