Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D103D7CEC
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 19:14:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A28018F8033
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2016 17:14:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id x1ZLhlELG1NnwGxJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jul 2016 17:14:39 -0700 (PDT)
Date: Fri, 8 Jul 2016 17:14:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 033/119] xfs: support overlapping intervals in the rmap
	btree
Message-ID: <20160709001428.GB30604@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612648418.12839.17068915263834486145.stgit@birch.djwong.org>
	<20160708183355.GE59278@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160708183355.GE59278@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Fri, Jul 08, 2016 at 02:33:55PM -0400, Brian Foster wrote:
> On Thu, Jun 16, 2016 at 06:21:24PM -0700, Darrick J. Wong wrote:
> > Now that the generic btree code supports overlapping intervals, plug
> > in the rmap btree to this functionality.  We will need it to find
> > potential left neighbors in xfs_rmap_{alloc,free} later in the patch
> > set.
> > 
> > v2: Fix bit manipulation bug when generating high key offset.
> > v3: Move unwritten bit to rm_offset.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_rmap_btree.c |   59 +++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_rmap_btree.h |   10 +++++--
> >  2 files changed, 66 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > index c50c725..9adb930 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > @@ -181,6 +181,28 @@ xfs_rmapbt_init_key_from_rec(
> >  }
> >  
> >  STATIC void
> > +xfs_rmapbt_init_high_key_from_rec(
> > +	union xfs_btree_key	*key,
> > +	union xfs_btree_rec	*rec)
> > +{
> > +	__uint64_t		off;
> > +	int			adj;
> > +
> > +	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
> > +
> 
> Comments please. I had to stare at this for too long than I care to
> admit to grok why it is modifying values. :) One liners along the lines
> of "shift the startblock/offset to the highest value to form the high
> key" or "don't convert offset for non-inode owners because ..." go a
> long way for those not familiar with the code.

Fair enough.

/*
 * The high key for a reverse mapping record can be computed by shifting
 * the startblock and offset to the highest value that would still map
 * to that record.  In practice this means that we add blockcount-1 to
 * the startblock for all records, and if the record is for a data/attr
 * fork mapping, we add blockcount-1 to the offset too.
 */

> With regard to rm_offset, could we just copy it unconditionally here
> (should it not be 0)?

No, because one of the rmap operations (once we get to reflink) is to
find any potential left-mappings that we could extend in order to map
in an extent (pblk, owner, lblk) by searching for (pblk-1, owner,
lblk-1).

If the extent we're trying to map is, say, (15, 128, 5) and there's an
existing mapping (10, 128, 0, len=5), we have to be able to compute
the high key of that existing mapping as (14, 128, 4).  We can't
decrement the cursor here because the next record to the left might
be (12, 150, 2, len=1).

(Making that one search reasonably quick is the reason behind the entire
overlapping btree thing.)

> > +	key->rmap.rm_startblock = rec->rmap.rm_startblock;
> > +	be32_add_cpu(&key->rmap.rm_startblock, adj);
> > +	key->rmap.rm_owner = rec->rmap.rm_owner;
> > +	key->rmap.rm_offset = rec->rmap.rm_offset;
> > +	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
> > +	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rmap.rm_offset)))
> > +		return;
> > +	off = be64_to_cpu(key->rmap.rm_offset);
> > +	off = (XFS_RMAP_OFF(off) + adj) | (off & ~XFS_RMAP_OFF_MASK);
> > +	key->rmap.rm_offset = cpu_to_be64(off);
> > +}
> > +
> > +STATIC void
> >  xfs_rmapbt_init_rec_from_cur(
> >  	struct xfs_btree_cur	*cur,
> >  	union xfs_btree_rec	*rec)
> > @@ -235,6 +257,38 @@ xfs_rmapbt_key_diff(
> >  	return 0;
> >  }
> >  
> > +STATIC __int64_t
> > +xfs_rmapbt_diff_two_keys(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_key	*k1,
> > +	union xfs_btree_key	*k2)
> > +{
> > +	struct xfs_rmap_key	*kp1 = &k1->rmap;
> > +	struct xfs_rmap_key	*kp2 = &k2->rmap;
> > +	__int64_t		d;
> > +	__u64			x, y;
> > +
> > +	d = (__int64_t)be32_to_cpu(kp2->rm_startblock) -
> > +		       be32_to_cpu(kp1->rm_startblock);
> > +	if (d)
> > +		return d;
> > +
> > +	x = be64_to_cpu(kp2->rm_owner);
> > +	y = be64_to_cpu(kp1->rm_owner);
> > +	if (x > y)
> > +		return 1;
> > +	else if (y > x)
> > +		return -1;
> > +
> > +	x = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
> > +	y = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
> > +	if (x > y)
> > +		return 1;
> > +	else if (y > x)
> > +		return -1;
> > +	return 0;
> > +}
> > +
> >  static bool
> >  xfs_rmapbt_verify(
> >  	struct xfs_buf		*bp)
> > @@ -350,6 +404,7 @@ xfs_rmapbt_recs_inorder(
> >  static const struct xfs_btree_ops xfs_rmapbt_ops = {
> >  	.rec_len		= sizeof(struct xfs_rmap_rec),
> >  	.key_len		= sizeof(struct xfs_rmap_key),
> > +	.flags			= XFS_BTREE_OPS_OVERLAPPING,
> >  
> >  	.dup_cursor		= xfs_rmapbt_dup_cursor,
> >  	.set_root		= xfs_rmapbt_set_root,
> > @@ -358,10 +413,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
> >  	.get_minrecs		= xfs_rmapbt_get_minrecs,
> >  	.get_maxrecs		= xfs_rmapbt_get_maxrecs,
> >  	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
> > +	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
> >  	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
> >  	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
> >  	.key_diff		= xfs_rmapbt_key_diff,
> >  	.buf_ops		= &xfs_rmapbt_buf_ops,
> > +	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	.keys_inorder		= xfs_rmapbt_keys_inorder,
> >  	.recs_inorder		= xfs_rmapbt_recs_inorder,
> > @@ -410,7 +467,7 @@ xfs_rmapbt_maxrecs(
> >  	if (leaf)
> >  		return blocklen / sizeof(struct xfs_rmap_rec);
> >  	return blocklen /
> > -		(sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
> > +		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
> 
> Same here.. one-liner comment that reminds why we have the 2x please.

/*
 * Each btree pointer has two keys representing the lowest and highest
 * keys of all records in the subtree.
 */

> >  }
> >  
> >  /* Compute the maximum height of an rmap btree. */
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> > index 17fa383..796071c 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> > @@ -38,12 +38,18 @@ struct xfs_mount;
> >  #define XFS_RMAP_KEY_ADDR(block, index) \
> >  	((struct xfs_rmap_key *) \
> >  		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
> > -		 ((index) - 1) * sizeof(struct xfs_rmap_key)))
> > +		 ((index) - 1) * 2 * sizeof(struct xfs_rmap_key)))
> > +
> > +#define XFS_RMAP_HIGH_KEY_ADDR(block, index) \
> > +	((struct xfs_rmap_key *) \
> > +		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
> > +		 sizeof(struct xfs_rmap_key) + \
> > +		 ((index) - 1) * 2 * sizeof(struct xfs_rmap_key)))
> >  
> 
> Could this just be 'XFS_RMAP_KEY_ADDR(block, index) + sizeof(struct
> xfs_rmap_key)'?

Yes.

--D

> 
> Brian
> 
> >  #define XFS_RMAP_PTR_ADDR(block, index, maxrecs) \
> >  	((xfs_rmap_ptr_t *) \
> >  		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
> > -		 (maxrecs) * sizeof(struct xfs_rmap_key) + \
> > +		 (maxrecs) * 2 * sizeof(struct xfs_rmap_key) + \
> >  		 ((index) - 1) * sizeof(xfs_rmap_ptr_t)))
> >  
> >  struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
