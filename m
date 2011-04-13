Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DM0K8l214056 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 17:00:20 -0500
Subject: [PATCH, v2] xfs: cleanup duplicate initializations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1301338370.2622.10.camel@doink>
References: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
	<1301338370.2622.10.camel@doink>
Date: Wed, 13 Apr 2011 17:03:28 -0500
Message-ID: <1302732208.2023.146.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Mon, 2011-03-28 at 13:52 -0500, Alex Elder wrote:
> On Mon, 2011-03-28 at 19:12 +0200, David Sterba wrote:
> > follow these guidelines:
> > - leave initialization in the declaration block if it fits the line
> > - move to the code where it's more suitable ('for' init block)
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> 
> Looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

I retract this.  The last chunk in the patch is erroneous.

Below is the original proposed patch, except I have
modified the last chunk to be a correct fix for what
appears to be a duplicate initialization.  (It was not,
really, but I've changed it so only one assignment is
made, and the result makes it more obvious what's
going on.)

David, perhaps you could sign off on this version.
Meanwhile, another reviewer might make sense.

					-Alex

follow these guidelines:
- leave initialization in the declaration block if it fits the line
- move to the code where it's more suitable ('for' init block)

Originally proposed by David Sterba <dsterba@suse.cz>

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dfrag.c      |    6 +-----
 fs/xfs/xfs_inode_item.c |    1 -
 fs/xfs/xfs_mount.c      |    4 ++--
 3 files changed, 3 insertions(+), 8 deletions(-)

Index: b/fs/xfs/xfs_dfrag.c
===================================================================
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -202,7 +202,7 @@ xfs_swap_extents(
        xfs_inode_t     *tip,   /* tmp inode */
        xfs_swapext_t   *sxp)
 {
-       xfs_mount_t     *mp;
+       xfs_mount_t     *mp = ip->i_mount;
        xfs_trans_t     *tp;
        xfs_bstat_t     *sbp = &sxp->sx_stat;
        xfs_ifork_t     *tempifp, *ifp, *tifp;
@@ -212,16 +212,12 @@ xfs_swap_extents(
        int             taforkblks = 0;
        __uint64_t      tmp;
 
-       mp = ip->i_mount;
-
        tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
        if (!tempifp) {
                error = XFS_ERROR(ENOMEM);
                goto out;
        }
 
-       sbp = &sxp->sx_stat;
-
        /*
         * we have to do two separate lock calls here to keep lockdep
         * happy. If we try to get all the locks in one call, lock will
Index: b/fs/xfs/xfs_inode_item.c
===================================================================
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -970,7 +970,6 @@ xfs_iflush_abort(
 {
        xfs_inode_log_item_t    *iip = ip->i_itemp;
 
-       iip = ip->i_itemp;
        if (iip) {
                struct xfs_ail  *ailp = iip->ili_item.li_ailp;
                if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1900,7 +1900,7 @@ xfs_mod_incore_sb_batch(
        uint                    nmsb,
        int                     rsvd)
 {
-       xfs_mod_sb_t            *msbp = &msb[0];
+       xfs_mod_sb_t            *msbp;
        int                     error = 0;
 
        /*
@@ -1910,7 +1910,7 @@ xfs_mod_incore_sb_batch(
         * changes will be atomic.
         */
        spin_lock(&mp->m_sb_lock);
-       for (msbp = &msbp[0]; msbp < (msb + nmsb); msbp++) {
+       for (msbp = msb; msbp < (msb + nmsb); msbp++) {
                ASSERT(msbp->msb_field < XFS_SBS_ICOUNT ||
                       msbp->msb_field > XFS_SBS_FDBLOCKS);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
