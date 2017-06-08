Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47825 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdFHQnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2017 12:43:12 -0400
Date: Thu, 8 Jun 2017 09:43:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/13] xfs: return the hash value of a leaf1 directory
 block
Message-ID: <20170608164307.GK4530@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870873.23065.5974641750134566189.stgit@birch.djwong.org>
 <20170608130224.GA5244@bfoster.bfoster>
 <20170608155359.GI4530@birch.djwong.org>
 <20170608163147.GG5244@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608163147.GG5244@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 12:31:50PM -0400, Brian Foster wrote:
> On Thu, Jun 08, 2017 at 08:53:59AM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 08, 2017 at 09:02:26AM -0400, Brian Foster wrote:
> > > On Fri, Jun 02, 2017 at 02:25:08PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Provide a way to calculate the highest hash value of a leaf1 block.
> > > > This will be used by the directory scrubbing code to check the sanity
> > > > of hashes in leaf1 directory blocks.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_dir2_node.c |   28 ++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_dir2_priv.h |    2 ++
> > > >  2 files changed, 30 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > > > index bbd1238..15c1881 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > > > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > > > @@ -524,6 +524,34 @@ xfs_dir2_free_hdr_check(
> > > >  #endif	/* DEBUG */
> > > >  
> > > >  /*
> > > > + * Return the last hash value in the leaf1.
> > > > + * Stale entries are ok.
> > > > + */
> > > > +xfs_dahash_t					/* hash value */
> > > > +xfs_dir2_leaf1_lasthash(
> > > > +	struct xfs_inode	*dp,
> > > > +	struct xfs_buf		*bp,		/* leaf buffer */
> > > > +	int			*count)		/* count of entries in leaf */
> > > > +{
> > > > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > > > +	struct xfs_dir2_leaf_entry *ents;
> > > > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > > > +
> > > > +	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
> > > > +
> > > > +	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> > > > +	       leafhdr.magic == XFS_DIR3_LEAF1_MAGIC);
> > > > +
> > > 
> > > It looks like the assert is the only difference between this function
> > > and xfs_dir2_leafn_lasthash(). It seems like overkill to me to duplicate
> > > just for that. How about we fix up the assert to cover the additional
> > > magics (and maybe rename _leafn_lasthash() to _leaf_lasthash() if
> > > appropriate)?
> > > 
> > > Actually, taking a closer look, ->leaf_hdr_from_disk() already asserts
> > > on the appropriate LEAF1/LEAFN magic based on the callback that is
> > > specified. ISTM that we could also just kill the _lasthash() assert.
> > 
> > The ASSERTs in the _lasthash functions and in leaf_hdr_from_disk aren't
> > testing quite the same things.  The asserts in _dir2_leaf[1n]_lasthash
> > check that we actually passed it a leaf1 or leafn block, respectively.
> > The asserts in _dir[23]_leaf_hdr_from_disk check that we actually fed it
> > a dir2 or dir3 leaf* block without caring whether it's leaf1 or leafn.
> > That's why I didn't just get rid of the assert and rename the function
> > xfs_dir2_leaf_lasthash().
> > 
> 
> Yeah, I'm aware they are not exactly equivalent. I was more thinking
> that we still have some assert protection if something is blatantly
> wrong (i.e., corruption, some non dir block, etc.). As it is, if the
> _leaf1_lasthash() assert fails because we passed a leafn block to the
> function, the solution presumably is to use the leafn function that
> basically does the same thing (modulo the assert), right?

Certainly that seems like the correct caller code fix.

> In other words, what's the value of asserting on the magics between two
> functions that handle either format in the exact same way? If there is
> value somewhere, it sounds like perhaps it's to the benefit of the
> caller than for the helper itself (which is reasonable, I think, but
> still doesn't justify the duplication IMO).

I wanted to be cautious about removing ASSERTs from functions.  Having
talked about this with you, I now feel emboldened enough to take your
original suggestion to simply combine the two functions. :)

> > I suppose we could just make a single parent function that takes the two
> > magics it wants to see and have _dir2_leaf[1n]_lasthash call the parent
> > function with the magic numbers they want to check.  How does that
> > sound?
> > 
> 
> Do I understand correctly that you mean an "internal" function that
> receives the expected magic as a param (for the assert) and a couple
> leaf[1|n]_lasthash() wrappers that pass the associated LEAF[1|N] magics?
> If so, that sounds reasonable to me if you'd really prefer to keep the
> isolated asserts. I'm more just trying to avoid the code duplication.

<nod> Eh, I'll just collapse both of them into a single _lasthash
function that doesn't care if it's passed a leaf1 or a leafn.

--D
> 
> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > +	if (count)
> > > > +		*count = leafhdr.count;
> > > > +	if (!leafhdr.count)
> > > > +		return 0;
> > > > +
> > > > +	ents = dp->d_ops->leaf_ents_p(leaf);
> > > > +	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
> > > > +}
> > > > +
> > > > +/*
> > > >   * Return the last hash value in the leaf.
> > > >   * Stale entries are ok.
> > > >   */
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> > > > index 576f2d2..c09bca1 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> > > > +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> > > > @@ -95,6 +95,8 @@ extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
> > > >  /* xfs_dir2_node.c */
> > > >  extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
> > > >  		struct xfs_buf *lbp);
> > > > +extern xfs_dahash_t xfs_dir2_leaf1_lasthash(struct xfs_inode *dp,
> > > > +		struct xfs_buf *bp, int *count);
> > > >  extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
> > > >  		struct xfs_buf *bp, int *count);
> > > >  extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
