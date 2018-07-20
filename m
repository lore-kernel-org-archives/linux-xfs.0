Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTP3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:29:46 -0400
Date: Fri, 20 Jul 2018 10:41:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/14] xfs: embed dfops in the transaction
Message-ID: <20180720144106.GB34727@bfoster>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719200557.GK6558@infradead.org>
 <20180719203643.GJ29404@bfoster>
 <20180719213634.GN4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719213634.GN4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 02:36:34PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 19, 2018 at 04:36:43PM -0400, Brian Foster wrote:
> > On Thu, Jul 19, 2018 at 01:05:57PM -0700, Christoph Hellwig wrote:
> > > On Thu, Jul 19, 2018 at 09:49:05AM -0400, Brian Foster wrote:
> > > > return a clean transaction. Other things to consider might be to do away
> > > > with support for external dfops and the ->t_dfops pointer indirection,
> > > > or perhaps even consider going the other direction: allocate dfops from
> > > > a separate zone to save some memory on non-permanent transactions (note
> > > > that 16 of 28 transactions use a permanent log res. last I looked, so it
> > > > may not be worth it atm).
> > > 
> > > The defer_ops aren't really that big, and allocations are relatively
> > > costly, so I don't think a separate allocation is a good idea.  If we
> > > really want to optimize the non-permanent transaction case we could do
> > > something like:
> > > 
> > > struct xfs_trans {
> > > 	...
> > > 	struct xfs_defer_ops dfops[];
> > > };
> > > 
> > > and then have two caches for the with an without dfops case.  But
> > > I can't believe that would be worth it, especially in face of...
> > > 
> > > 
> > > > I know Christoph also had thoughts around condensing some of the items
> > > > joined to the dfops to those with the transaction.
> > > 
> > > ... this.
> > > 
> > 
> > Yeah. I was actually poking around today after writing this up and
> > thought that we might be able to replace both dop_inodes/dop_bufs with
> > checks in the transaction item list for either held buffers or inode
> > items where lock_flags == 0. I _think_ both of those states may be
> > essentially equivalent to joined dfops items, but I have to verify that.
> > If so, we can probably make the dfops inode/buf relogging "automatic,"
> > drop both pointer lists and the whole memory thing becomes kind of moot.
> 
> <nod>
> 

Ok.. on this one, running some tests shows that pretty much all dfops
joined bufs/inodes are essentially held in the transaction (which would
probably be a bug if that were not the case). The opposite is also true
for buffers, because a held buffers must also be held in subsequent
transactions to ensure the caller still has a reference after dfops
completion. OTOH, there are some places where inodes are joined to a
transaction with lock_flags == 0 and dfops are run without the inode
joined to the dfops. I don't necessarily think this is a bug for the
inode case because the caller still owns the inode lock, we just don't
relog it across the series of transactions required for dfops
completion.

I don't think it would necessarily be a problem if we did relog the
inode in these cases, however. In fact I think the argument has been
made in the past to do that explicitly (with xfs_defer_[i|b]join()) in
one or two cases. So given that, the overall approach still seems
reasonable enough to me. FWIW, the appended patch shows the cases I've
caught on a quick xfstests run that would be affected (i.e., where we
don't currently defer_ijoin() but implicitly would with an "automatic"
relog mechanism). I'm running a longer test to try and catch any others,
but let me know if anybody sees problems with this or has other ideas...

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 60138514ea86..c3cbe05cdb1b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1120,6 +1120,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
+	xfs_defer_ijoin(tp->t_dfops, ip);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7b40e9fef381..e63712e67fd8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -979,6 +979,7 @@ xfs_alloc_file_space(
 		/*
 		 * Complete the transaction
 		 */
+		xfs_defer_ijoin(tp->t_dfops, ip);
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0e4bd559a6a7..24fdca90b588 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1810,6 +1810,7 @@ xfs_inactive_ifree(
 	 * Just ignore errors at this point.  There is nothing we can do except
 	 * to try to keep going. Make sure it's not a silent error.
 	 */
+	xfs_defer_ijoin(tp->t_dfops, ip);
 	error = xfs_trans_commit(tp);
 	if (error)
 		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8e8ca9f03f0e..464b4b3225bb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -261,6 +261,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Complete the transaction
 	 */
+	xfs_defer_ijoin(tp->t_dfops, ip);
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_unlock;
@@ -762,6 +763,7 @@ xfs_iomap_write_allocate(
 			if (error)
 				goto trans_cancel;
 
+			xfs_defer_ijoin(tp->t_dfops, ip);
 			error = xfs_trans_commit(tp);
 			if (error)
 				goto error0;
@@ -879,6 +881,7 @@ xfs_iomap_write_unwritten(
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
+		xfs_defer_ijoin(tp->t_dfops, ip);
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cddde219630a..8984f283da7b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -435,6 +435,7 @@ xfs_reflink_allocate_cow(
 	xfs_inode_set_cowblocks_tag(ip);
 
 	/* Finish up. */
+	xfs_defer_ijoin(tp->t_dfops, ip);
 	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
