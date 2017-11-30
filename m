Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46782 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdK3Rz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 12:55:26 -0500
Date: Thu, 30 Nov 2017 09:55:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20171130175514.GI21412@magnolia>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <1757414.A5ytRCBscU@libor-nb>
 <20171121162428.GA6004@bfoster.bfoster>
 <20171121185018.GB2135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171121185018.GB2135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>, alex@zadarastorage.com, linux-xfs@vger.kernel.org, david@fromorbit.com

On Tue, Nov 21, 2017 at 10:50:18AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 21, 2017 at 11:24:29AM -0500, Brian Foster wrote:
> > On Tue, Nov 21, 2017 at 04:31:20PM +0100, Libor Klepáč wrote:
> > > Hello again,
> > > i'm sorry to bug you, but i would like to ask, if this patch made it to kernel 
> > > yet?
> > > I was looking on pull request messages and did not see it.
> > > 
> > > We were struck by "Metadata corruption detected at 
> > > xfs_attr3_leaf_write_verify" under high load, after months without problem.
> > > 
> > > But we are still on 4.9.30 on this server, there is possibility to upgrade to 
> > > 4.9.51 from backports.
> > > 
> > 
> > IIRC, the issue that prevented this patch from being merged was that the
> > buffer needed to be joined and relogged across deferred operations. That
> > had a dependency on some rectoring of the buffer logging code, which has
> > since been merged, but I don't recall seeing anything regarding a
> > deferred op buffer relogging mechanism and using it here. Alex?
> 
> Correct, there's no such thing as deferred op buffer relogging.  If I
> have time this week or next I can try to revisit what exactly we needed
> to do to retain the buffer lock across transaction rolls in
> defer_finish and try to cough up a patch, after which the original attr
> fix from Alex should be refactored to use that mechanism.
> 
> (Not sure what we do about backporting to pre-defer_ops kernels...)

FWIW I will be sending some RFC patches to the list shortly that fix
this problem on 4.15 kernels.  The new xfs_defer_bjoin code could use
some careful scrutiny to make sure that I captured the gist of this
thread accurately with regard to bhold/join/dirty'ing the bjoin'd buffer
across the transaction roll in xfs_defer_finish.

It doesn't blow up on any of the attr fstests, but that doesn't mean
much. :)

--D

> 
> --D
> 
> > Brian
> > 
> > > With regards,
> > > Libor
> > > 
> > > 
> > > On středa 9. srpna 2017 13:06:12 CET alex@zadarastorage.com wrote:
> > > > From: Alex Lyakas <alex@zadarastorage.com>
> > > > 
> > > > The new attribute leaf buffer is not held locked across
> > > > the transaction roll between the shortform->leaf modification
> > > > and the addition of the new entry. As a result, the attribute
> > > > buffer modification being made is not atomic from
> > > > an operational perspective. Hence the AIL push can grab it in
> > > > the transient state of "just created" after the initial
> > > > transaction is rolled, because the buffer has been released.
> > > > This leads to xfs_attr3_leaf_verify() asserting that
> > > > hdr.count is zero, treating this as in-memory corruption,
> > > > and shutting down the filesystem.
> > > > 
> > > > Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_attr.c      | 19 ++++++++++++++++++-
> > > >  fs/xfs/libxfs/xfs_attr_leaf.c |  4 +++-
> > > >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
> > > >  3 files changed, 23 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index de7b9bd..982e322 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -216,10 +216,11 @@
> > > >  	struct xfs_defer_ops	dfops;
> > > >  	struct xfs_trans_res	tres;
> > > >  	xfs_fsblock_t		firstblock;
> > > >  	int			rsvd = (flags & ATTR_ROOT) != 0;
> > > >  	int			error, err2, local;
> > > > +	struct xfs_buf		*leaf_bp = NULL;
> > > >  
> > > >  	XFS_STATS_INC(mp, xs_attr_set);
> > > >  
> > > >  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> > > >  		return -EIO;
> > > > @@ -325,11 +326,17 @@
> > > >  		/*
> > > >  		 * It won't fit in the shortform, transform to a leaf block.
> > > >  		 * GROT: another possible req'mt for a double-split btree op.
> > > >  		 */
> > > >  		xfs_defer_init(args.dfops, args.firstblock);
> > > > -		error = xfs_attr_shortform_to_leaf(&args);
> > > > +		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
> > > > +		/*
> > > > +		 * Prevent the leaf buffer from being unlocked
> > > > +		 * when "args.trans" transaction commits.
> > > > +		 */
> > > > +		if (leaf_bp)
> > > > +			xfs_trans_bhold(args.trans, leaf_bp);
> > > >  		if (!error)
> > > >  			error = xfs_defer_finish(&args.trans, args.dfops, dp);
> > > >  		if (error) {
> > > >  			args.trans = NULL;
> > > >  			xfs_defer_cancel(&dfops);
> > > > @@ -343,10 +350,18 @@
> > > >  
> > > >  		error = xfs_trans_roll(&args.trans, dp);
> > > >  		if (error)
> > > >  			goto out;
> > > >  
> > > > +		/*
> > > > +		 * Rejoin the leaf buffer to the new transaction.
> > > > +		 * This allows a subsequent read to find the buffer in the
> > > > +		 * transaction (and avoid a deadlock).
> > > > +		 */
> > > > +		xfs_trans_bjoin(args.trans, leaf_bp);
> > > > +		/* Prevent from being released at the end of the function */
> > > > +		leaf_bp = NULL;
> > > >  	}
> > > >  
> > > >  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > > >  		error = xfs_attr_leaf_addname(&args);
> > > >  	else
> > > > @@ -374,10 +389,12 @@
> > > >  	return error;
> > > >  
> > > >  out:
> > > >  	if (args.trans)
> > > >  		xfs_trans_cancel(args.trans);
> > > > +	if (leaf_bp)
> > > > +		xfs_buf_relse(leaf_bp);
> > > >  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > > >  	return error;
> > > >  }
> > > >  
> > > >  /*
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > index c6c15e5..ab73e4b 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > @@ -738,13 +738,14 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args 
> > > *args,
> > > >  	return -ENOATTR;
> > > >  }
> > > >  
> > > >  /*
> > > >   * Convert from using the shortform to the leaf.
> > > > + * Upon success, return the leaf buffer.
> > > >   */
> > > >  int
> > > > -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> > > > +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, struct xfs_buf **bpp)
> > > >  {
> > > >  	xfs_inode_t *dp;
> > > >  	xfs_attr_shortform_t *sf;
> > > >  	xfs_attr_sf_entry_t *sfe;
> > > >  	xfs_da_args_t nargs;
> > > > @@ -820,10 +821,11 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args 
> > > *args,
> > > >  		if (error)
> > > >  			goto out;
> > > >  		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > > >  	}
> > > >  	error = 0;
> > > > +	*bpp = bp;
> > > >  
> > > >  out:
> > > >  	kmem_free(tmpbuffer);
> > > >  	return error;
> > > >  }
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > > index f7dda0c..2b3c69df 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> > > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > > @@ -46,11 +46,12 @@
> > > >   */
> > > >  void	xfs_attr_shortform_create(struct xfs_da_args *args);
> > > >  void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> > > >  int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
> > > >  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> > > > -int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
> > > > +int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
> > > > +					struct xfs_buf **bpp);
> > > >  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> > > >  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> > > >  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
> > > >  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
> > > >  
> > > > 
> > > 
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
