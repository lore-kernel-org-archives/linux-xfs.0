Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C4CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD52B64F0A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhBXVvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:51:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhBXVvf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:51:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA02B64EFA;
        Wed, 24 Feb 2021 21:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614203454;
        bh=am0wDRF5c6THo51SHFAe+2ZR3JbSyX7M31RI1OMYTDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SuukT7mzFhJzUTGAHGITA3HT1l0k71zYjxMZFpOhhD+S4JUqHvilDj8OxmiaM+Iga
         d5l0kpBcQyR+bnGNdgozPSlh6NsKvxgyTqZ6gZiFXE1QnoS4s5LZoNr2gIRFXSRce3
         o9/4b997ghIX70v15RKQWNU99O70Q9nbtawI+DEKtV0yV9TbMVRLHn96gOEo/+46aV
         X1pVb935WCGJG7cKGGexi4PyeDKGEOZG1gwRMrDfJv74XqoYutGn58++TM+ki3eEdv
         XK+vb8QnaY1xymCg3yjRrA33bhwO79YSfDQ6NDMnrJ+PCPx5T34oES+Hwvp8r4Vfmx
         HUkmaO0zGxOHA==
Date:   Wed, 24 Feb 2021 13:50:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: reduce debug overhead of dir leaf/node checks
Message-ID: <20210224215053.GE7272@magnolia>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 04:47:48PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On debug kernels, we call xfs_dir3_leaf_check_int() multiple times
> on every directory modification. The robust hash ordering checks it
> does on every entry in the leaf on every call results in a massive
> CPU overhead which slows down debug kernels by a large amount.
> 
> We use xfs_dir3_leaf_check_int() for the verifiers as well, so we
> can't just gut the function to reduce overhead. What we can do,
> however, is reduce the work it does when it is called from the
> debug interfaces, just leaving the high level checks in place and
> leaving the robust validation to the verifiers. This means the debug
> checks will catch gross errors, but subtle bugs might not be caught
> until a verifier is run.
> 
> It is easy enough to restore the existing debug behaviour if the
> developer needs it (just change a call parameter in the debug code),
> but overwise the overhead makes testing large directory block sizes
> on debug kernels very slow.
> 
> Profile at an unlink rate of ~80k file/s on a 64k block size
> filesystem before the patch:
> 
>   40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.98%  [kernel]  [k] __xfs_dir3_data_check
>    8.10%  [kernel]  [k] xfs_verify_dir_ino
>    4.42%  [kernel]  [k] memcpy
>    2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
>    1.52%  [kernel]  [k] do_raw_spin_lock
> 
> Profile after, at an unlink rate of ~125k files/s (+50% improvement)
> has largely dropped the leaf verification debug overhead out of the
> profile.
> 
>   16.53%  [kernel]  [k] __xfs_dir3_data_check
>   12.53%  [kernel]  [k] xfs_verify_dir_ino
>    7.97%  [kernel]  [k] memcpy
>    3.36%  [kernel]  [k] xfs_dir2_data_get_ftype
>    2.86%  [kernel]  [k] __pv_queued_spin_lock_slowpath
> 
> Create shows a similar change in profile and a +25% improvement in
> performance.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 10 +++++++---
>  fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h |  3 ++-
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 95d2a3f92d75..ccd8d0aa62b8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -113,7 +113,7 @@ xfs_dir3_leaf1_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf, false);
>  }
>  
>  static inline void
> @@ -139,7 +139,8 @@ xfs_failaddr_t
>  xfs_dir3_leaf_check_int(
>  	struct xfs_mount		*mp,
>  	struct xfs_dir3_icleaf_hdr	*hdr,
> -	struct xfs_dir2_leaf		*leaf)
> +	struct xfs_dir2_leaf		*leaf,
> +	bool				expensive_checking)
>  {
>  	struct xfs_da_geometry		*geo = mp->m_dir_geo;
>  	xfs_dir2_leaf_tail_t		*ltp;
> @@ -162,6 +163,9 @@ xfs_dir3_leaf_check_int(
>  	    (char *)&hdr->ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
>  		return __this_address;
>  
> +	if (!expensive_checking)
> +		return NULL;
> +
>  	/* Check hash value order, count stale entries.  */
>  	for (i = stale = 0; i < hdr->count; i++) {
>  		if (i + 1 < hdr->count) {
> @@ -195,7 +199,7 @@ xfs_dir3_leaf_verify(
>  		return fa;
>  
>  	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, bp->b_addr);
> -	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr);
> +	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr, true);
>  }
>  
>  static void
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 5d51265d29d6..80a64117b460 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -73,7 +73,7 @@ xfs_dir3_leafn_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(dp->i_mount, &leafhdr, leaf, false);
>  }
>  
>  static inline void
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 44c6a77cba05..94943ce49cab 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -127,7 +127,8 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
>  extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
>  
>  extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
> -		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
> +		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf,
> +		bool expensive_checks);
>  
>  /* xfs_dir2_node.c */
>  void xfs_dir2_free_hdr_from_disk(struct xfs_mount *mp,
> -- 
> 2.28.0
> 
