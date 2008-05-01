Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 15:08:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m41M7oMr002380
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 15:07:53 -0700
Date: Fri, 2 May 2008 08:08:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Don't allow memory reclaim to wait on the filesystem in inode writeback
Message-ID: <20080501220825.GN108924158@sgi.com>
References: <20080501122611.GK108924158@sgi.com> <20080501131521.GA7435@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501131521.GA7435@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 01, 2008 at 09:15:21AM -0400, Christoph Hellwig wrote:
> On Thu, May 01, 2008 at 10:26:11PM +1000, David Chinner wrote:
> > Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
> > ===================================================================
> > --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-04-28 16:35:23.000000000 +1000
> > +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-05-01 20:04:55.151880341 +1000
> > @@ -2986,7 +2986,7 @@ xfs_iflush_cluster(
> >  	ASSERT(pag->pag_ici_init);
> >  
> >  	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
> > -	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
> > +	ilist = kmem_alloc(ilist_size, KM_NOFS);
> >  	if (!ilist)
> >  		return 0;
> 
> This should be KM_MAYFAIL | KM_NOFS, because KM_NOFS doesn't imply that
> the allocation may fail.

Yes, right you are - I only looked at the effect of __GFP_FS, not
what kmem_alloc does. i.e. kmem_flags_convert() doesn't do anything
with KM_MAYFAIL, forgetting that it's kmem_alloc() that uses it...

New patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
Don't allow memory reclaim to wait on the filesystem in inode writeback

If we allow memory reclaim to wait on the pages under writeback in
inode cluster writeback we could deadlock because we are currently
holding the ILOCK on the initial writeback inode which is needed in
data I/O completion to change the file size or do unwritten extent
conversion before the pages are taken out of writeback state.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-04-28 16:35:23.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-05-02 08:03:30.071824780 +1000
@@ -2986,7 +2986,7 @@ xfs_iflush_cluster(
 	ASSERT(pag->pag_ici_init);
 
 	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
-	ilist = kmem_alloc(ilist_size, KM_MAYFAIL);
+	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
 		return 0;
 
