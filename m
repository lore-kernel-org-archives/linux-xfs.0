Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C12C3AF667;
	Sun,  9 Aug 2026 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786302152; cv=none; b=W26kLKmyMYml8Tjnc+NjfWdcgHsUedlf08Fs5+l/ceS+6Scdh7Gamv2/qBp2h7MPLGUnYBWGANnK0rRT4i3z9a9qjNP4XwzxCaJ2i+9OjivQ0v5d/iyFSfGfOwbUtP5PG9gy5ST1S+R1NxotxNdmqBCdkqmae8veiC+hoT73fzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786302152; c=relaxed/simple;
	bh=6RCNjbnuJr/igyL+cII7GCIlgyFU36LGZrII1zbImYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVpx8KpOpfL7uWAJ7+XU85P6puiP+7t8Oft/tjvcf+hWualn5j06Gso1WW6TfA8AV4YdkHEqT+TWNhPMfg4CyMZP6ujbO1ThQtRtELwVVZ3fiOdYK55RS4vI02k9LqA+S2tGETnVUgm0xEd9muzgm6cFXGngETZ9COVsKyqP+7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNT32Wlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNT32Wlk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 646881F000E9;
	Sun,  9 Aug 2026 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786302132;
	bh=vqOIuusTK+UEr2OlfGinDD0QO662jwpK7FMg+rnpWfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oNT32WlkiMmqqM8MELqPXQ/+TwoRVUKU8cCGhoVmnlKyq6LJmfHWNTdiVpn4wPwN/
	 vp0Qu9Wkul7pTO/F0KsApEc0uieXSqoHDL2FMS0D2drpBBgbK5SxYklEdVksGm+TBg
	 Joksj5sIGnx/7cRGAhrzzZZiJyN1MsPcxFj27PoJxt5/6jzQ5yOHzuymiusQza3OZL
	 lkT3U6oZj2OHdsqxV4BvFfbe4qcgY0GdDZrd1KOOEOOY7yOt4gbCkkNqQsZb34DADJ
	 JjzatcUDmjt6MLB978gkPBKjQTX2lJ/2MY6LKiVrpalTRmixue4LTvqcXXGm/3xIZx
	 kMpQTTiPFsufw==
Date: Sun, 9 Aug 2026 12:02:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: initialise args->total for parent pointer
 updates
Message-ID: <20260809190212.GT7398@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260808234016.246054-12-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808234016.246054-12-floss@jetm.me>

On Sat, Aug 08, 2026 at 05:40:22PM -0600, Javier Tia wrote:
> xfs_parent_da_args_init() fills in every field of its xfs_da_args except
> total, and the containing struct xfs_parent_args is allocated with
> kmem_cache_zalloc() (xfs_parent.h:66), so runtime parent pointer updates
> reach the block allocator with args->total == 0.
> 
> The log recovery path already gets this right, which is the clearest
> statement of the bug.  xfs_attri_recover_work() reconstructs the same
> operation from a recovered intent and does
> 
> 	args->total = xfs_attr_calc_size(args, &local);	/* xfs_attr_item.c:706 */
> 
> for PPTR_SET and PPTR_REPLACE, and deliberately not for PPTR_REMOVE.  So
> replaying a parent pointer insert from the log runs with a correct total
> while performing the same insert at runtime runs with zero.
> 
> That field is not a constant.  xfs_da_grow_inode_int() treats it as a
> running remainder:
> 
> 	args->total -= dp->i_nblocks - nblks;		/* xfs_da_btree.c:2388 */

Should there be an assert to check that args->total is never zero in a
place where it gets subtracted?

> xfs_da_args.total is an xfs_extlen_t, i.e. uint32_t (xfs_types.h:14), so
> subtracting the first block the attr fork gains wraps it to 0xffffffff.
> It is passed down as xfs_bmapi_write()'s total argument
> (xfs_da_btree.c:2348), stored as xfs_bmalloca.total, copied to
> xfs_alloc_arg.total (xfs_bmap.c:3214, 3379) and finally reaches
> 
> 	if (available < (int)max(args->total, alloc_len))
> 
> in xfs_alloc_space_available() (xfs_alloc.c:2525), where the cast turns
> ~0U back into -1 and the minimum-free-space test can no longer fail.
> Parent pointer allocations therefore skip a check that every other xattr
> allocation observes.

Not reading the rest of this, you've already made your point.
Moving on to the diff...

> Growing the fork twice in one operation is ordinary, not a corner case:
> XFS_DAS_LEAF_ADD calls xfs_attr3_leaf_to_node(), which grows the fork
> (xfs_attr_leaf.c:1319), then sets XFS_DAS_NODE_ADD and returns -EAGAIN;
> the next cycle can reach xfs_attr3_leaf_split() (xfs_attr_leaf.c:1462),
> and a node split reaches xfs_da_grow_inode() again by way of
> xfs_da3_split() (xfs_da_btree.c:748, 866).  The xfs_da_args lives across
> that roll, so the later allocations are the ones that see the wrapped
> value.
> 
> Set the field from xfs_attr_calc_size(), matching both the recovery path
> above and xfs_attr_set() (xfs_attr.c:1150), rather than clamping the
> subtraction, which would leave total meaningless for parent pointers and
> hide the omission.
> 
> The initialiser is shared with five other callers and the value is inert
> on all of them.  Every reader of args->total in the attr code needs
> xfs_da_grow_inode(), whose only attr-fork callers are the three growth
> functions in xfs_attr_leaf.c and the two split functions in
> xfs_da_btree.c, and the state machine cannot reach any of them from a
> remove: each remove state completes with
> xfs_attr_complete_op(attr, xfs_attr_init_add_state(args)), and
> xfs_attr_complete_op() replaces that add state with XFS_DAS_DONE unless
> XFS_DA_OP_REPLACE is set (xfs_attr.c:497), which only the two replace
> helpers ever set.  xfs_parent_lookup() never allocates at all, and on
> xfs_parent_set() the assignment is immediately overwritten by
> xfs_attr.c:1150, so it is dead there rather than merely unused.  Setting
> it unconditionally is simpler than mirroring
> xfs_attri_recover_work()'s switch.
> 
> This makes the allocator stricter for parent pointers rather than only
> more correct: where total was 0 the test reduced to
> available < alloc_len, and it now asks for the whole remaining
> reservation, 25 blocks on a 4k-block filesystem.  That changes which AG
> is chosen and can cost an extra allocator pass, but it does not
> introduce a new failure.  xfs_bmap_btalloc_low_space() retries with
> args->minlen and sweeps every AG before declaring ENOSPC
> (xfs_bmap.c:3511-3532), and a parent-pointer link never runs
> reservationless in the first place - xfs_link() refuses the resblks == 0
> fallback while pptrs are enabled, precisely because it cannot back out if
> the xattrs must grow (xfs_inode.c:948-954).
> 
> Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
> Signed-off-by: Javier Tia <floss@jetm.me>

Cc: <stable@vger.kernel.org> # v6.10

> ---
>  fs/xfs/libxfs/xfs_parent.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 3509cc4b2175..d6588d0a9286 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -156,6 +156,8 @@ xfs_parent_da_args_init(
>  	xfs_ino_t		owner,
>  	const struct xfs_name	*parent_name)
>  {
> +	int			local;
> +
>  	args->geo = child->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->attr_filter = XFS_ATTR_PARENT;
> @@ -168,6 +170,17 @@ xfs_parent_da_args_init(
>  	args->value = rec;
>  	args->valuelen = sizeof(struct xfs_parent_rec);
>  	xfs_attr_sethash(args);
> +
> +	/*
> +	 * xfs_da_grow_inode_int() subtracts every block it allocates from
> +	 * args->total, which is unsigned, so the zero left here by
> +	 * kmem_cache_zalloc() wraps to ~0U as soon as the attr fork grows once.
> +	 * Derive it the way xfs_attr_set() does instead.  A parent pointer's
> +	 * value is a struct xfs_parent_rec, so the entry is always local, which
> +	 * is what the ASSERT records
> +	 */
> +	args->total = xfs_attr_calc_size(args, &local);

Didn't you say that this shouldn't be done for removals?
This would seem to set total for those operations.

--D

> +	ASSERT(local);
>  }
>  
>  /* Make sure the incore state is ready for a parent pointer query/update. */
> -- 
> Javier Tia
> 
