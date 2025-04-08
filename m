Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCF44A21
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 23:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744154000; cv=none; b=qDXcJlzoIUvOnhOOApbPNr9uByqRoFOapPT8HSQMKk6Czpkx0D2L2tZXP2Y3CMWqRDjddrLtzqHC4HaygefQycrMJnzuNm+WqvLVcSitPxO6+AwrhHgGlWdXP8+cNANgloVuQiZ1kww9jzQUKMT8AOfMm/g229Kj3ohaMfrbOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744154000; c=relaxed/simple;
	bh=Uvrue3Dn5UM15yw0W2qGKfUxksBIuJN8mjeilkVRJWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ja2wgbyXdaYLVN4TXBdQQyg7NVDEgBTPqWZcNAVn0UspYSKA+s/mFwIqKNzR7GEHmXD20dRHWzK6YxsFMaH4QxKvXO3SghW5NkTX9KTc7hHCGFSBetHmqqL/CfyHBZUVc42L9JUn4ADj3IYSXhKynRzbuCPxhh7iVurANS9MldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pk0vKDNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pk0vKDNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A65C4CEE5;
	Tue,  8 Apr 2025 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744153998;
	bh=Uvrue3Dn5UM15yw0W2qGKfUxksBIuJN8mjeilkVRJWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pk0vKDNbEu/BT/CDX9hQZCKfZjN10guq+wls08Uu2Z5sIpZ8gh+8eg5/hnczZZQkh
	 C4o4y2SfL6f3kZ8hmeZPJ/SqL3FRIzVzjBOB76w+w4Z0HfG6TyqVOQQ1paWDL/cy06
	 1I7m+EoFptflAmRo1jfSXhTPFnc9fCrcS1ggJZAVEwdp4n1MbKpGQczr0lPx6qGHKt
	 Bkzzlo4l+nkaNszMFuZcv9Oc1aobFUW2Yi5wpB4sveTyrrEOUBT4z7I0I6YUuG3dBB
	 1xozidIgY+/XvzoxBLwXWzoZ2qvKMMIaCw5eMaAJ5j7DUmgyB4zRlY9gmqSfhUtI6d
	 sGeTAbf7vDteA==
Date: Tue, 8 Apr 2025 16:13:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: compute the maximum repair reaping defer intent
 chain length
Message-ID: <20250408231317.GJ6307@frogsfrogsfrogs>
References: <20250403191244.GB6283@frogsfrogsfrogs>
 <Z_Wfx79a6gDNoaAD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_Wfx79a6gDNoaAD@dread.disaster.area>

On Wed, Apr 09, 2025 at 08:14:31AM +1000, Dave Chinner wrote:
> On Thu, Apr 03, 2025 at 12:12:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Actually compute the log overhead of log intent items used in reap
> > operations and use that to compute the thresholds in reap.c instead of
> > assuming 2048 works.  Note that there have been no complaints because
> > tr_itruncate has a very large logres.
> > 
> > Cc: <stable@vger.kernel.org> # v6.6
> > Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

/me notes this is an RFC patch and I just finished writing a more
expansive patchset that breaks up the pieces and computes limits for
each usecase separately.

> > ---
> >  fs/xfs/scrub/trace.h       |   29 ++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.h     |    3 +++
> >  fs/xfs/xfs_extfree_item.h  |    3 +++
> >  fs/xfs/xfs_log_priv.h      |   13 +++++++++++
> >  fs/xfs/xfs_refcount_item.h |    3 +++
> >  fs/xfs/xfs_rmap_item.h     |    3 +++
> >  fs/xfs/scrub/reap.c        |   50 +++++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/scrub/trace.c       |    1 +
> >  fs/xfs/xfs_bmap_item.c     |   10 +++++++++
> >  fs/xfs/xfs_extfree_item.c  |   10 +++++++++
> >  fs/xfs/xfs_log_cil.c       |    4 +---
> >  fs/xfs/xfs_refcount_item.c |   10 +++++++++
> >  fs/xfs/xfs_rmap_item.c     |   10 +++++++++
> >  13 files changed, 140 insertions(+), 9 deletions(-)

<snip>

> > @@ -495,6 +499,37 @@ xreap_agextent_iter(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Compute the worst case log overhead of the intent items needed to reap a
> > + * single per-AG space extent.
> > + */
> > +STATIC unsigned int
> > +xreap_agextent_max_deferred_reaps(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	const unsigned int	efi = xfs_efi_item_overhead(1);
> > +	const unsigned int	rui = xfs_rui_item_overhead(1);
> 
> These wrappers don't return some "overhead" - they return the amount of
> log space the intent will consume. Can we please call them
> xfs_<intent_type>_log_space()?

Ok.

> > +
> > +	/* unmapping crosslinked metadata blocks */
> > +	const unsigned int	t1 = rui;
> > +
> > +	/* freeing metadata blocks */
> > +	const unsigned int	t2 = rui + efi;
> > +
> > +	/* worst case of all four possible scenarios */
> > +	const unsigned int	per_intent = max(t1, t2);
> 
> When is per_intent going to be different to t2? i.e. rui + efi > rui
> will always be true, so we don't need to calculate it at runtime.

Any decent compiler will combine this into:

	const unsigned int      per_intent = rui + efi;

> i.e. what "four scenarios" is this actually handling? I can't work
> out what they are from the code or the description...

The five things that xreap_agextent_iter() does.  One of them
(XFS_AG_RESV_AGFL) doesn't use intents so I only listed four.

> > +	/*
> > +	 * tr_itruncate has enough logres to unmap two file extents; use only
> > +	 * half the log reservation for intent items so there's space to do
> > +	 * actual work and requeue intent items.
> > +	 */
> > +	const unsigned int	ret = sc->tp->t_log_res / (2 * per_intent);
> 
> So we are assuming only a single type of log reservation is used for
> these reaping transactions?

Well it's *currently* tr_itruncate, but some day we could add a
bigger/separate repair transaction type.

> If so, this is calculating a value that is constant for the life of
> the mount and probably should be moved to all the other log
> reservation calculation functions that are run at mount time and
> stored with them.
> 
> i.e. this calculation is effectively:
> 
> 	return (xfs_calc_itruncate_reservation(mp, false) >> 1) /
> 		(xfs_efi_log_space(1) + xfs_rui_log_space(1));
> 
> Also, I think that the algorithm used to calculate the number of
> intents we can fit in such a transaction should be described in
> the comment above the function, then implement the algorithm as

I don't like  ^^^^^^^^^^^^^^^^^^ this style of putting the comment at
some distance from the actual computation code.  Look at
xfs_calc_link_reservation:

/*
 * For creating a link to an inode:
 *    the parent directory inode: inode size
 *    the linked inode: inode size
 *    the directory btree could split: (max depth + v2) * dir block size
 *    the directory bmap btree could join or split: (max depth + v2) * blocksize
 * And the bmap_finish transaction can free some bmap blocks giving:
 *    the agf for the ag in which the blocks live: sector size
 *    the agfl for the ag in which the blocks live: sector size
 *    the superblock for the free block count: sector size
 *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
 */
STATIC uint
xfs_calc_link_reservation(
	struct xfs_mount	*mp)
{
	overhead += xfs_calc_iunlink_remove_reservation(mp);
	t1 = xfs_calc_inode_res(mp, 2) +
	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
			      XFS_FSB_TO_B(mp, 1));

	if (xfs_has_parent(mp)) {
		t3 = resp->tr_attrsetm.tr_logres;
		overhead += xfs_calc_pptr_link_overhead();
	}

Does t1 correspond to "For creating a link"?  Does t2 correspond to "And
the bmap_finish..." ?  t3 isn't even in the comment.  To me it'd be much
clearer to write:

	/* Linking an unlinked inode into the directory tree */
	overhead += xfs_calc_iunlink_remove_reservation(mp);

	/*
	 * For creating a link to an inode:
	 *    the parent directory inode: inode size
	 *    the linked inode: inode size
	 *    the directory btree could split: (max depth + v2) * dir block size
	 *    the directory bmap btree could join or split: (max depth + v2) * blocksize
	 */
	t1 = xfs_calc_inode_res(mp, 2) +
	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));

	/*
	 * And the bmap_finish transaction can free some bmap blocks giving:
	 *    the agf for the ag in which the blocks live: sector size
	 *    the agfl for the ag in which the blocks live: sector size
	 *    the superblock for the free block count: sector size
	 *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
	 */
	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),

	/*
	 * If parent pointers are enabled, save space to add a pptr
	 * xattr and the space to log the pptr items.
	 */
	if (xfs_has_parent(mp)) {
		t3 = resp->tr_attrsetm.tr_logres;
		overhead += xfs_calc_pptr_link_overhead();
	}

	return overhead + max3(t1, t2, t3);

calc_link isn't too bad, but truncate is more difficult to figure out.

> efficiently as possible (as we already do in xfs_trans_resv.c).

The downside of moving it to xfs_trans_resv.c is that now you've
separated the code that actually does the reaping from the code that
figures out the dynamic limits based on how reaping can happen.

> > +	trace_xreap_agextent_max_deferred_reaps(sc->tp, per_intent, ret);
> 
> If it is calculated at mount time, this can be emitted along with
> all the other log reservations calculated at mount time.
> 
> > +	return max(1, ret);
> 
> Why? tp->t_logres should always be much greater than the intent
> size. How will this ever evaluate as zero without there being some
> other serious log/transaction reservation bug elsewhere in the code?
> 
> i.e. if we can get zero here, that needs ASSERTS and/or WARN_ON
> output and a filesystem shutdown because there is something
> seriously wrong occurring in the filesystem.

Ok.  I'll just shut down the fs then.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
