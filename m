Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T1nAeP234704 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 19:49:10 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vQaBD8rRCcN2rbyA for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 17:49:08 -0800 (PST)
Date: Wed, 29 Feb 2012 12:49:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120229014906.GX3592@dastard>
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
	<20120229005351.GV3592@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229005351.GV3592@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Feb 29, 2012 at 11:53:51AM +1100, Dave Chinner wrote:
> On Tue, Feb 28, 2012 at 03:34:44AM -0500, Christoph Hellwig wrote:
> > On Wed, Feb 22, 2012 at 11:01:37PM +0100, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   while running fsstress on XFS partition with 3.3-rc4 kernel + my freeze
> > > fixes (they do not touch anything relevant AFAICT) I've got the following
> > > warning:
> > 
> > That's stressing including freezes or without?  Do you have a better
> > description of te workload?
> > 
> > Either way it's an odd one, I can't see any obvious way how this would
> > happen.
> 
> FWIW, I'm trying to track down exactly the same warning on a RHEL6.2
> kernel being triggered by NFS filehandle lookup. The problem is
> being being reproduced reliably by a well known NFS benchmark, but
> this gives more a bit more information on where a race condition in
> the inode lookup may exist.
> 
> That is, the only common element here in these two lookup paths is
> that they are the only two calls to xfs_iget() with
> XFS_IGET_UNTRUSTED set in the flags. I doubt this is a coincidence.

And it isn't.

Jan, can you try the (untested) patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix inode lookup race

From: Dave Chinner <dchinner@redhat.com>

When we get concurrent lookups of the same inode that is not in the
per-AG inode cache, there is a race condition that triggers warnings
in unlock_new_inode() indicating that we are initialising an inode
that isn't in a the correct state for a new inode.

When we do an inode lookup via a file handle or a bulkstat, we don't
serialise lookups at a higher level through the dentry cache (i.e.
pathless lookup), and so we can get concurrent lookups of the same
inode.

The race condition is between the insertion of the inode into the
cache in the case of a cache miss and a concurrently lookup:

Thread 1			Thread 2
xfs_iget()
  xfs_iget_cache_miss()
    xfs_iread()
    lock radix tree
    radix_tree_insert()
    				rcu_read_lock
				radix_tree_lookup
				lock inode flags
				XFS_INEW not set
				igrab()
				unlock inode flags
				rcu_read_unlock
				use uninitialised inode
				.....
    lock inode flags
    set XFS_INEW
    unlock inode flags
    unlock radix tree
  xfs_setup_inode()
    inode flags = I_NEW
    unlock_new_inode()
      WARNING as inode flags != I_NEW

This can lead to inode corruption, inode list corruption, etc, and
is generally a bad thing to occur.

Fix this by setting XFS_INEW before inserting the inode into the
radix tree. This will ensure any concurrent lookup will find the new
inode with XFS_INEW set and that forces the lookup to wait until the
XFS_INEW flag is removed before allowing the lookup to succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 05bed2b..2467ab7 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -350,9 +350,19 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	spin_lock(&pag->pag_ici_lock);
+	/* These values _must_ be set before inserting the inode into the radix
+	 * tree as the moment it is inserted a concurrent lookup (allowed by the
+	 * RCU locking mechanism) can find it and that lookup must see that this
+	 * is an inode currently under construction (i.e. that XFS_INEW is set).
+	 * The ip->i_flags_lock that protects the XFS_INEW flag forms the
+	 * memory barrier that ensures this detection works correctly at lookup
+	 * time.
+	 */
+	xfs_iflags_set(ip, XFS_INEW);
+	ip->i_udquot = ip->i_gdquot = NULL;
 
 	/* insert the new inode */
+	spin_lock(&pag->pag_ici_lock);
 	error = radix_tree_insert(&pag->pag_ici_root, agino, ip);
 	if (unlikely(error)) {
 		WARN_ON(error != -EEXIST);
@@ -360,11 +370,6 @@ xfs_iget_cache_miss(
 		error = EAGAIN;
 		goto out_preload_end;
 	}
-
-	/* These values _must_ be set before releasing the radix tree lock! */
-	ip->i_udquot = ip->i_gdquot = NULL;
-	xfs_iflags_set(ip, XFS_INEW);
-
 	spin_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
