Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 16:38:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HNcQoW016615
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 16:38:28 -0700
Date: Sat, 17 May 2008 19:39:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Message-ID: <20080517233908.GA15279@infradead.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805171922.56272.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org> <200805172109.59244.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, dgc@sgi.com

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 17, 2008 at 02:17:37PM -0700, Linus Torvalds wrote:
> > [4294293.003500]  [<ffffffff8028106a>] __kmalloc+0x3e/0xe6
> > [4294293.003500]  [<ffffffff803067fc>] ? xfs_iflush_int+0x272/0x2fb
> > [4294293.003500]  [<ffffffff80320552>] kmem_alloc+0x6a/0xd1
> > [4294293.003500]  [<ffffffff80307a9c>] xfs_iflush_cluster+0x4b/0x33f
> > [4294293.003500]  [<ffffffff8030681e>] ? xfs_iflush_int+0x294/0x2fb
> > [4294293.003500]  [<ffffffff80307f4b>] xfs_iflush+0x1bb/0x29d
> > [4294293.003500]  [<ffffffff8031bc30>] xfs_inode_flush+0xb8/0xdd
> > [4294293.003500]  [<ffffffff80328b1f>] xfs_fs_write_inode+0x30/0x4c
> 
> And as a result, all the XFS stuff is then waiting for that lock which is 
> held by pdflush above:

Btw, just that function has a missing GFP_NOFS and a too large
allocation which were fixed by Dave Chinner but aren't in mainline
yet.  Can you check whether it still happens with the patch below?


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-icluster-add-nofs

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
 



--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-fix-icluster-alloc-size

We only need to allocate space for the number of inodes in
the cluster when writing back inodes, not every byte in the
inode cluster. This reduces the amount of memory needing to
be allocated to 256 bytes instead of 64k.

Somebody pass me the brown paper bag, please.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-05-16 19:43:55.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-05-16 19:47:47.778141722 +1000
@@ -2913,6 +2913,7 @@ xfs_iflush_cluster(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_perag_t		*pag = xfs_get_perag(mp, ip->i_ino);
 	unsigned long		first_index, mask;
+	unsigned long		inodes_per_cluster;
 	int			ilist_size;
 	xfs_inode_t		**ilist;
 	xfs_inode_t		*iq;
@@ -2924,7 +2925,8 @@ xfs_iflush_cluster(
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pag_ici_init);
 
-	ilist_size = XFS_INODE_CLUSTER_SIZE(mp) * sizeof(xfs_inode_t *);
+	inodes_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog;
+	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
 	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
 	if (!ilist)
 		return 0;
@@ -2934,8 +2936,7 @@ xfs_iflush_cluster(
 	read_lock(&pag->pag_ici_lock);
 	/* really need a gang lookup range call here */
 	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
-					first_index,
-					XFS_INODE_CLUSTER_SIZE(mp));
+					first_index, inodes_per_cluster);
 	if (nr_found == 0)
 		goto out_free;
 



--IJpNTDwzlM2Ie8A6--
