Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19041 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdFHPyF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2017 11:54:05 -0400
Date: Thu, 8 Jun 2017 08:53:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/13] xfs: return the hash value of a leaf1 directory
 block
Message-ID: <20170608155359.GI4530@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870873.23065.5974641750134566189.stgit@birch.djwong.org>
 <20170608130224.GA5244@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608130224.GA5244@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 09:02:26AM -0400, Brian Foster wrote:
> On Fri, Jun 02, 2017 at 02:25:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Provide a way to calculate the highest hash value of a leaf1 block.
> > This will be used by the directory scrubbing code to check the sanity
> > of hashes in leaf1 directory blocks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_node.c |   28 ++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_dir2_priv.h |    2 ++
> >  2 files changed, 30 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index bbd1238..15c1881 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -524,6 +524,34 @@ xfs_dir2_free_hdr_check(
> >  #endif	/* DEBUG */
> >  
> >  /*
> > + * Return the last hash value in the leaf1.
> > + * Stale entries are ok.
> > + */
> > +xfs_dahash_t					/* hash value */
> > +xfs_dir2_leaf1_lasthash(
> > +	struct xfs_inode	*dp,
> > +	struct xfs_buf		*bp,		/* leaf buffer */
> > +	int			*count)		/* count of entries in leaf */
> > +{
> > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > +	struct xfs_dir2_leaf_entry *ents;
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > +
> > +	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
> > +
> > +	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> > +	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
> > +
> 
> It looks like the assert is the only difference between this function
> and xfs_dir2_leafn_lasthash(). It seems like overkill to me to duplicate
> just for that. How about we fix up the assert to cover the additional
> magics (and maybe rename _leafn_lasthash() to _leaf_lasthash() if
> appropriate)?
> 
> Actually, taking a closer look, ->leaf_hdr_from_disk() already asserts
> on the appropriate LEAF1/LEAFN magic based on the callback that is
> specified. ISTM that we could also just kill the _lasthash() assert.

The ASSERTs in the _lasthash functions and in leaf_hdr_from_disk aren't
testing quite the same things.  The asserts in _dir2_leaf[1n]_lasthash
check that we actually passed it a leaf1 or leafn block, respectively.
The asserts in _dir[23]_leaf_hdr_from_disk check that we actually fed it
a dir2 or dir3 leaf* block without caring whether it's leaf1 or leafn.
That's why I didn't just get rid of the assert and rename the function
xfs_dir2_leaf_lasthash().

I suppose we could just make a single parent function that takes the two
magics it wants to see and have _dir2_leaf[1n]_lasthash call the parent
function with the magic numbers they want to check.  How does that
sound?

--D

> 
> Brian
> 
> > +	if (count)
> > +		*count = leafhdr.count;
> > +	if (!leafhdr.count)
> > +		return 0;
> > +
> > +	ents = dp->d_ops->leaf_ents_p(leaf);
> > +	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
> > +}
> > +
> > +/*
> >   * Return the last hash value in the leaf.
> >   * Stale entries are ok.
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> > index 576f2d2..c09bca1 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> > +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> > @@ -95,6 +95,8 @@ extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
> >  /* xfs_dir2_node.c */
> >  extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
> >  		struct xfs_buf *lbp);
> > +extern xfs_dahash_t xfs_dir2_leaf1_lasthash(struct xfs_inode *dp,
> > +		struct xfs_buf *bp, int *count);
> >  extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
> >  		struct xfs_buf *bp, int *count);
> >  extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
