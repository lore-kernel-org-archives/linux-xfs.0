Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdISOwI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Sep 2017 10:52:08 -0400
Date: Tue, 19 Sep 2017 10:52:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/12] xfs: create a new buf_ops pointer to verify
 structure metadata
Message-ID: <20170919145206.GC3487@bfoster.bfoster>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
 <150394426502.24826.9176393746863067568.stgit@magnolia>
 <20170906164751.GG55280@bfoster.bfoster>
 <20170918203201.GU6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918203201.GU6540@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 01:32:01PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 06, 2017 at 12:47:51PM -0400, Brian Foster wrote:
> > On Mon, Aug 28, 2017 at 11:17:45AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Expose all metadata structure buffer verifier functions via buf_ops.
> > > These will be used by the online scrub mechanism to look for problems
> > > with buffers that are already sitting around in memory.
> > > 
> > 
...
> > > @@ -2492,6 +2493,7 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
> > >  	.name = "xfs_agf",
> > >  	.verify_read = xfs_agf_read_verify,
> > >  	.verify_write = xfs_agf_write_verify,
> > > +	.verify_struct = xfs_agf_verify,
> > >  };
> > 
> > If we expose the core verifier function of each structure through the
> > ops table and the read/write verifiers mostly call that function and do
> > some CRC processing based on read or write, I'm wondering how many of
> > the unique read/write verifiers could be condensed into a generic buffer
> > read and generic buffer write function that invokes the
> > ->verify_struct() function and does the CRC/LSN check or updates
> > appropriately. We'd have to at least include the CRC offset in the
> > buf_ops for read verifiers and additionally the lsn offset for write
> > verifiers. Thoughts?
> 
> That would be difficult -- while btree blocks have a statically defined
> crc offset, inodes and dquots have multiple objects per buffer, each
> with their own crc, so you'd have to make both variants work.  It's not
> impossible, but it seemed like a lot of change for not a lot of gain.
> 

Yes, I wouldn't expect to convert all verifiers of course. But I don't
see what would make it so difficult to support both. The common case
would just be a set of generic read/write buf verifier functions that
each buffer type that follows the associated verification pattern can
reuse. Other verifiers continue to set their own custom functions.

I've swapped out a lot of the details/context set by this patch by now,
but IIRC generic use would look something like the following:

const struct xfs_buf_ops xfs_agf_buf_ops = {
        .name = "xfs_agf",
        .verify_read = xfs_buf_read_verify,
        .verify_write = xfs_buf_write_verify,
	.verify_struct = xfs_agf_verify,
	.crc_off = XFS_AGF_CRC_OFF,
	.lsn_off = ...,
};

Otherwise the offset values can be ignored.

I recall that there were some that wouldn't follow this pattern (one of
the superblock verifiers also looked unique, iirc). If we assume that is
true for inodes/dquots as well... that's still only three sets out of
the 25 or so .verify_read assignments I see in the tree. ISTM if we
could delete a decent amount of boilerplate code if we could convert
even half of those.

Brian

> --D
> 
> > Brian
> > 
> > >  
> > >  /*
> > > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > index 8d4c004..eb79f6c 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > @@ -397,6 +397,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
> > >  	.name = "xfs_allocbt",
> > >  	.verify_read = xfs_allocbt_read_verify,
> > >  	.verify_write = xfs_allocbt_write_verify,
> > > +	.verify_struct = xfs_allocbt_verify,
> > >  };
> > >  
> > >  
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index bde5269..3a563c5 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -339,6 +339,7 @@ const struct xfs_buf_ops xfs_attr3_leaf_buf_ops = {
> > >  	.name = "xfs_attr3_leaf",
> > >  	.verify_read = xfs_attr3_leaf_read_verify,
> > >  	.verify_write = xfs_attr3_leaf_write_verify,
> > > +	.verify_struct = xfs_attr3_leaf_verify,
> > >  };
> > >  
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index d33a4d3..164c366 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -203,10 +203,42 @@ xfs_attr3_rmt_write_verify(
> > >  	ASSERT(len == 0);
> > >  }
> > >  
> > > +static void *
> > > +xfs_attr3_rmt_verify_struct(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	struct xfs_mount *mp = bp->b_target->bt_mount;
> > > +	char		*ptr;
> > > +	void		*failed_at;
> > > +	int		len;
> > > +	xfs_daddr_t	bno;
> > > +	int		blksize = mp->m_attr_geo->blksize;
> > > +
> > > +	/* no verification of non-crc buffers */
> > > +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> > > +		return NULL;
> > > +
> > > +	ptr = bp->b_addr;
> > > +	bno = bp->b_bn;
> > > +	len = BBTOB(bp->b_length);
> > > +	ASSERT(len >= blksize);
> > > +
> > > +	while (len > 0) {
> > > +		if ((failed_at = xfs_attr3_rmt_verify(mp, ptr, blksize, bno)))
> > > +			return failed_at;
> > > +		len -= blksize;
> > > +		ptr += blksize;
> > > +		bno += BTOBB(blksize);
> > > +	}
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > >  const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
> > >  	.name = "xfs_attr3_rmt",
> > >  	.verify_read = xfs_attr3_rmt_read_verify,
> > >  	.verify_write = xfs_attr3_rmt_write_verify,
> > > +	.verify_struct = xfs_attr3_rmt_verify_struct,
> > >  };
> > >  
> > >  STATIC int
> > > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > > index d613080..0d5dd7b 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > > @@ -692,6 +692,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
> > >  	.name = "xfs_bmbt",
> > >  	.verify_read = xfs_bmbt_read_verify,
> > >  	.verify_write = xfs_bmbt_write_verify,
> > > +	.verify_struct = xfs_bmbt_verify,
> > >  };
> > >  
> > >  
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index f3544fb..af738bf 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -247,10 +247,35 @@ xfs_da3_node_read_verify(
> > >  	xfs_verifier_error(bp, failed_at);
> > >  }
> > >  
> > > +/* Verify the structure of a da3 block. */
> > > +static void *
> > > +xfs_da3_node_verify_struct(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_da_blkinfo	*info = bp->b_addr;
> > > +
> > > +	switch (be16_to_cpu(info->magic)) {
> > > +	case XFS_DA3_NODE_MAGIC:
> > > +	case XFS_DA_NODE_MAGIC:
> > > +		return xfs_da3_node_verify(bp);
> > > +	case XFS_ATTR_LEAF_MAGIC:
> > > +	case XFS_ATTR3_LEAF_MAGIC:
> > > +		bp->b_ops = &xfs_attr3_leaf_buf_ops;
> > > +		return bp->b_ops->verify_struct(bp);
> > > +	case XFS_DIR2_LEAFN_MAGIC:
> > > +	case XFS_DIR3_LEAFN_MAGIC:
> > > +		bp->b_ops = &xfs_dir3_leafn_buf_ops;
> > > +		return bp->b_ops->verify_struct(bp);
> > > +	default:
> > > +		return __this_address;
> > > +	}
> > > +}
> > > +
> > >  const struct xfs_buf_ops xfs_da3_node_buf_ops = {
> > >  	.name = "xfs_da3_node",
> > >  	.verify_read = xfs_da3_node_read_verify,
> > >  	.verify_write = xfs_da3_node_write_verify,
> > > +	.verify_struct = xfs_da3_node_verify_struct,
> > >  };
> > >  
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> > > index 6c54d03..6dce935 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_block.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> > > @@ -126,6 +126,7 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
> > >  	.name = "xfs_dir3_block",
> > >  	.verify_read = xfs_dir3_block_read_verify,
> > >  	.verify_write = xfs_dir3_block_write_verify,
> > > +	.verify_struct = xfs_dir3_block_verify,
> > >  };
> > >  
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> > > index 5e27b71..d08a7ac 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_data.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> > > @@ -318,6 +318,7 @@ const struct xfs_buf_ops xfs_dir3_data_buf_ops = {
> > >  	.name = "xfs_dir3_data",
> > >  	.verify_read = xfs_dir3_data_read_verify,
> > >  	.verify_write = xfs_dir3_data_write_verify,
> > > +	.verify_struct = xfs_dir3_data_verify,
> > >  };
> > >  
> > >  static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > index 00dcfef..792fd98 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > @@ -218,6 +218,13 @@ __write_verify(
> > >  	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
> > >  }
> > >  
> > > +static void *
> > > +xfs_dir3_leaf1_verify(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> > > +}
> > > +
> > >  static void
> > >  xfs_dir3_leaf1_read_verify(
> > >  	struct xfs_buf	*bp)
> > > @@ -232,6 +239,13 @@ xfs_dir3_leaf1_write_verify(
> > >  	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> > >  }
> > >  
> > > +static void *
> > > +xfs_dir3_leafn_verify(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> > > +}
> > > +
> > >  static void
> > >  xfs_dir3_leafn_read_verify(
> > >  	struct xfs_buf	*bp)
> > > @@ -250,12 +264,14 @@ const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
> > >  	.name = "xfs_dir3_leaf1",
> > >  	.verify_read = xfs_dir3_leaf1_read_verify,
> > >  	.verify_write = xfs_dir3_leaf1_write_verify,
> > > +	.verify_struct = xfs_dir3_leaf1_verify,
> > >  };
> > >  
> > >  const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
> > >  	.name = "xfs_dir3_leafn",
> > >  	.verify_read = xfs_dir3_leafn_read_verify,
> > >  	.verify_write = xfs_dir3_leafn_write_verify,
> > > +	.verify_struct = xfs_dir3_leafn_verify,
> > >  };
> > >  
> > >  int
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > > index a11585b..1a5e383 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > > @@ -155,6 +155,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
> > >  	.name = "xfs_dir3_free",
> > >  	.verify_read = xfs_dir3_free_read_verify,
> > >  	.verify_write = xfs_dir3_free_write_verify,
> > > +	.verify_struct = xfs_dir3_free_verify,
> > >  };
> > >  
> > >  /* Everything ok in the free block header? */
> > > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > > index 5561011..8ce5239 100644
> > > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > > @@ -242,6 +242,17 @@ xfs_dquot_buf_verify(
> > >  	return true;
> > >  }
> > >  
> > > +static void *
> > > +xfs_dquot_buf_verify_struct(
> > > +	struct xfs_buf	*bp)
> > > +{
> > > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > +
> > > +	if (!xfs_dquot_buf_verify(mp, bp, 0))
> > > +		return __this_address;
> > > +	return NULL;
> > > +}
> > > +
> > >  static void
> > >  xfs_dquot_buf_read_verify(
> > >  	struct xfs_buf	*bp)
> > > @@ -298,6 +309,7 @@ const struct xfs_buf_ops xfs_dquot_buf_ops = {
> > >  	.name = "xfs_dquot",
> > >  	.verify_read = xfs_dquot_buf_read_verify,
> > >  	.verify_write = xfs_dquot_buf_write_verify,
> > > +	.verify_struct = xfs_dquot_buf_verify_struct,
> > >  };
> > >  
> > >  const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > index c63b708..a2c8c1d 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -2586,6 +2586,7 @@ const struct xfs_buf_ops xfs_agi_buf_ops = {
> > >  	.name = "xfs_agi",
> > >  	.verify_read = xfs_agi_read_verify,
> > >  	.verify_write = xfs_agi_write_verify,
> > > +	.verify_struct = xfs_agi_verify,
> > >  };
> > >  
> > >  /*
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > index 38d6a50..f920ca6 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > @@ -327,6 +327,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
> > >  	.name = "xfs_inobt",
> > >  	.verify_read = xfs_inobt_read_verify,
> > >  	.verify_write = xfs_inobt_write_verify,
> > > +	.verify_struct = xfs_inobt_verify,
> > >  };
> > >  
> > >  STATIC int
> > > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> > > index 8d6c0fc..a151b4d 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> > > @@ -288,6 +288,7 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
> > >  	.name			= "xfs_refcountbt",
> > >  	.verify_read		= xfs_refcountbt_read_verify,
> > >  	.verify_write		= xfs_refcountbt_write_verify,
> > > +	.verify_struct		= xfs_refcountbt_verify,
> > >  };
> > >  
> > >  STATIC int
> > > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > index 4fd77e7..ec7b216 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > @@ -380,6 +380,7 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
> > >  	.name			= "xfs_rmapbt",
> > >  	.verify_read		= xfs_rmapbt_read_verify,
> > >  	.verify_write		= xfs_rmapbt_write_verify,
> > > +	.verify_struct		= xfs_rmapbt_verify,
> > >  };
> > >  
> > >  STATIC int
> > > diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> > > index ef5e754..53732f4 100644
> > > --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> > > @@ -173,6 +173,7 @@ const struct xfs_buf_ops xfs_symlink_buf_ops = {
> > >  	.name = "xfs_symlink",
> > >  	.verify_read = xfs_symlink_read_verify,
> > >  	.verify_write = xfs_symlink_write_verify,
> > > +	.verify_struct = xfs_symlink_verify,
> > >  };
> > >  
> > >  void
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 2072126..094e3e7 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -139,6 +139,7 @@ struct xfs_buf_ops {
> > >  	char *name;
> > >  	void (*verify_read)(struct xfs_buf *);
> > >  	void (*verify_write)(struct xfs_buf *);
> > > +	void *(*verify_struct)(struct xfs_buf *);
> > >  };
> > >  
> > >  typedef struct xfs_buf {
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
