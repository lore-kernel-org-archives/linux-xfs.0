Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 04:39:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5NBcvSP024353
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 04:38:58 -0700
Date: Mon, 23 Jun 2008 13:39:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] check for invalid flags in xfs_attrlist_by_handle
Message-ID: <20080623113946.GA32665@lst.de>
References: <20080531075829.GA5424@lst.de> <485B431F.2070905@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485B431F.2070905@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 20, 2008 at 03:41:51PM +1000, Timothy Shimmin wrote:
> Fair enough.
> Actually, I think we only use ATTR_ROOT and ATTR_SECURE for the
> namespace flags.
> So you could probably use: XFS_ATTR_NSP_ARGS
> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS_MASK	 (ATTR_ROOT | ATTR_SECURE)
> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS(flags) ((flags) & XFS_ATTR_NSP_ARGS_MASK)
> and something like:
> 
> if (!XFS_ATTR_NSP_ARGS(al_hreq.flags))
>          return -XFS_ERROR(EINVAL);

Actually a zero flags is of course valid too.

So the check should be & ~(ATTR_ROOT | ATTR_SECURE).  I could use
XFS_ATTR_NSP_ARGS_MASK but that would pull in not just xfs_attr_leaf.h
but also xfs_da_btree.h and that needs even more headers..

So I propose this simple version:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-20 08:17:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-23 13:38:17.000000000 +0200
@@ -470,6 +470,12 @@ xfs_attrlist_by_handle(
 	if (al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -XFS_ERROR(EINVAL);
+
 	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
 	if (error)
 		goto out;
