Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10086C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35A560D42
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhJMQbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhJMQbq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 12:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F7D960E0C;
        Wed, 13 Oct 2021 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634142582;
        bh=5jgcnEb+nur4JCi9vPjU8nmuW2vs9XtJboP9uwT4oOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iwxD3JqlOg0IsyLOtIPi7w4Y/nzbNhGMOvF0EzTqckrzUk+ZTFmNaYYCraNYSysLq
         tgG0I8oP17m0wOaPaJNqHiNDvVMkL86K/8kny0m7GQdo2Ql0n0k8vUEReT7ottzs8e
         so1fFE6n/KiCjm2TYoFAcuk6J1hc/PtHSGLyaGh+VKMqXoXmXPd0B1q7V9CK/MHE8s
         QAG0jHPFSEjw960zVCVK/xGQINJmqctcBwJ8wKYtmpaL6XeGqUCPcRez2DilnCEQxF
         XjdaiuTl9pXkDGJyYfpP491GOuXvWDnUOFen9q69EoiLPphnVR+uGSg4P8whIdzWoI
         YaffIAmmNsx2w==
Date:   Wed, 13 Oct 2021 09:29:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 04/15] xfs: dynamically allocate btree scrub context
 structure
Message-ID: <20211013162941.GU24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408157576.4151249.1044656167414078424.stgit@magnolia>
 <20211013045738.GW2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013045738.GW2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 03:57:38PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:32:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Reorganize struct xchk_btree so that we can dynamically size the context
> > structure to fit the type of btree cursor that we have.  This will
> > enable us to use memory more efficiently once we start adding very tall
> > btree types.  Right-size the lastkey array so that we stop wasting the
> > first array element.
> 
> "right size"?
> 
> I'm assuming this is the "nlevels - 1" bit?

Yep.  I'll change the last sentence to:

"Right-size the lastkey array to match the number of node levels in the
btree so that we stop wasting space."

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/btree.c |   23 ++++++++++++-----------
> >  fs/xfs/scrub/btree.h |   11 ++++++++++-
> >  2 files changed, 22 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index d5e1ca521fc4..6d4eba85ef77 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -189,9 +189,9 @@ xchk_btree_key(
> >  
> >  	/* If this isn't the first key, are they in order? */
> >  	if (cur->bc_ptrs[level] > 1 &&
> > -	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
> > +	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1], key))
> >  		xchk_btree_set_corrupt(bs->sc, cur, level);
> > -	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
> > +	memcpy(&bs->lastkey[level - 1], key, cur->bc_ops->key_len);
> >  
> >  	if (level + 1 >= cur->bc_nlevels)
> >  		return;
> > @@ -631,17 +631,24 @@ xchk_btree(
> >  	union xfs_btree_ptr		*pp;
> >  	union xfs_btree_rec		*recp;
> >  	struct xfs_btree_block		*block;
> > -	int				level;
> >  	struct xfs_buf			*bp;
> >  	struct check_owner		*co;
> >  	struct check_owner		*n;
> > +	size_t				cur_sz;
> > +	int				level;
> >  	int				error = 0;
> >  
> >  	/*
> >  	 * Allocate the btree scrub context from the heap, because this
> > -	 * structure can get rather large.
> > +	 * structure can get rather large.  Don't let a caller feed us a
> > +	 * totally absurd size.
> >  	 */
> > -	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
> > +	cur_sz = xchk_btree_sizeof(cur->bc_nlevels);
> > +	if (cur_sz > PAGE_SIZE) {
> > +		xchk_btree_set_corrupt(sc, cur, 0);
> > +		return 0;
> > +	}
> > +	bs = kmem_zalloc(cur_sz, KM_NOFS | KM_MAYFAIL);
> >  	if (!bs)
> >  		return -ENOMEM;
> >  	bs->cur = cur;
> > @@ -653,12 +660,6 @@ xchk_btree(
> >  	/* Initialize scrub state */
> >  	INIT_LIST_HEAD(&bs->to_check);
> >  
> > -	/* Don't try to check a tree with a height we can't handle. */
> > -	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
> > -		xchk_btree_set_corrupt(sc, cur, 0);
> > -		goto out;
> > -	}
> > -
> >  	/*
> >  	 * Load the root of the btree.  The helper function absorbs
> >  	 * error codes for us.
> > diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> > index 7671108f9f85..62c3091ef20f 100644
> > --- a/fs/xfs/scrub/btree.h
> > +++ b/fs/xfs/scrub/btree.h
> > @@ -39,9 +39,18 @@ struct xchk_btree {
> >  
> >  	/* internal scrub state */
> >  	union xfs_btree_rec		lastrec;
> > -	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
> >  	struct list_head		to_check;
> > +
> > +	/* this element must come last! */
> > +	union xfs_btree_key		lastkey[];
> >  };
> > +
> > +static inline size_t
> > +xchk_btree_sizeof(unsigned int nlevels)
> > +{
> > +	return struct_size((struct xchk_btree *)NULL, lastkey, nlevels - 1);
> > +}
> 
> I'd like a comment here indicating that the max number of keys is
> "nlevels - 1" because the last level of the tree is records and
> that's held in a separate lastrec field...
> 
> That way there's a reminder of why there's a "- 1" here without
> having work it out from first principles every time we look at this
> code...

Ok; I've added the comment:

/*
 * Calculate the size of a xchk_btree structure.  There are nlevels-1
 * slots for keys because we track leaf records separately in lastrec.
 */

> Otherwise it seems reasonable.

<nod>

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
