Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7243D5679;
	Thu, 10 Sep 2026 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025933; cv=none; b=QKrWbu+Q8rgDf7VRCwW61jQ5k69KDW6v3auYLKa8p76Qim3DHYyunz0Z0PwNKIPYmZJl825LP6yBNr97ILDqB8nTjH6Y/HX5QESInOGa2rGrBDC0FCJoRY155qtYYSKdvYVnMEh/DcnwQkc/0gb0C8slyXCufnjSwrh8JTOIy00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025933; c=relaxed/simple;
	bh=N5vgE2eXxhnSgGF1G7k4lIhNz5imuwoxv/3MbhVnOdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhuG17a5/DkBShqIkRIG4522MP88lRu27QAOZQfvS3pdVQuGnVEVzQ/UMRMpoRsL+9SOSjL6wwW3p16aJR/axFbAghM/GS9AqXUZPSRHfOSvM/fKKqrisAOGIwbvFRRaOwt5SbOI/0vmLmN0Q875mnCIt0IdibpLahlVs+Ihxc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcAu2Spb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcAu2Spb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CFB1F00893;
	Thu, 10 Sep 2026 07:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025921;
	bh=Ou0W7JDNts9gSJnER4NrmoGHsbPwgl18iiFmxq+cYCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GcAu2SpbRJePVbTirKHvhRd3hMjbXonkWbNTm9qzLUcDIlPSp3QMahJponABilIFr
	 thC97Sqb1/pisjM4gipSR/UWDi778R5KATls5q00BcmmAHrav02izT2x5CTenhhOsW
	 GAtjwByox4EHAtpqCGWiqcpGbQqoFGb0+J4r7dBBzjgh/EsYibn67VQOgkUfp6Bwoj
	 T/8OMX//G8+IeJd9QegwvG5xgANg1Vi19nn4+oceROG2QJvBIxZL5t5qPTeeLEon7b
	 A8/ldA0/6e+bClHxy1GBKEVajt19XUC6CPy5Dc5Tr/twTlzB1mU8O7SLRFaryS6De7
	 PV91SFMieIe3Q==
Date: Thu, 10 Sep 2026 09:38:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix typos and repeated words in comments
Message-ID: <aqJeJhiifqGhrDzo@andromeda.toxiclabs.cc>
References: <20260910045550.54432-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910045550.54432-1-hemanth.selam@gmail.com>

On Thu, Sep 10, 2026 at 10:25:50AM +0530, Hemanth Selam wrote:
> Correct ten misspellings and eight accidentally doubled words in
> comments.  No code changes.
> 
> The doubled word in xfs_zone_alloc.c was not a duplicate: "so that is is
> reused" is "it is" misspelt, so that one reads "so that it is reused"
> rather than dropping a word.
> 
> Assisted-by: Cursor:claude-opus-5

I told you before to get rid of this, please re-send it without the
model here. We are not accepting mention of models. You can either use

Assisted-by: LLM

or get rid of it completely. You are responsible for the code
independent of the tooling you used to write it.

> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v2:
>  - fold the two patches into one, as Carlos and Darrick asked
>  - xfs_zone_alloc.c: "so that it is reused"; v1 dropped the second "is",
>    which left the sentence with no subject
>  - Darrick's Reviewed-by was given on v1; the xfs_zone_alloc.c hunk
>    changed after that review, so please re-check that one line
> 
> v1: https://lore.kernel.org/all/20260904112909.8197-1-hemanth.selam@gmail.com/
> 
>  fs/xfs/libxfs/xfs_ag.h         | 2 +-
>  fs/xfs/libxfs/xfs_alloc.c      | 4 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 2 +-
>  fs/xfs/libxfs/xfs_errortag.h   | 2 +-
>  fs/xfs/libxfs/xfs_exchmaps.c   | 2 +-
>  fs/xfs/libxfs/xfs_format.h     | 2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
>  fs/xfs/scrub/agheader_repair.c | 2 +-
>  fs/xfs/scrub/alloc_repair.c    | 2 +-
>  fs/xfs/scrub/dirtree.c         | 2 +-
>  fs/xfs/scrub/reap.c            | 2 +-
>  fs/xfs/xfs_bmap_item.c         | 2 +-
>  fs/xfs/xfs_inode.c             | 2 +-
>  fs/xfs/xfs_log_cil.c           | 2 +-
>  fs/xfs/xfs_platform.h          | 2 +-
>  fs/xfs/xfs_zone_alloc.c        | 2 +-
>  fs/xfs/xfs_zone_gc.c           | 2 +-
>  17 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index fd22fe598931..ee636b66a72f 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -207,7 +207,7 @@ xfs_perag_next(
>  }
>  
>  /*
> - * Per-ag geometry infomation and validation
> + * Per-ag geometry information and validation
>   */
>  xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
>  void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d99602bcc16f..f762dcce8d13 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3487,7 +3487,7 @@ xfs_alloc_read_agf(
>  }
>  
>  /*
> - * Pre-proces allocation arguments to set initial state that we don't require
> + * Pre-process allocation arguments to set initial state that we don't require
>   * callers to set up correctly, as well as bounds check the allocation args
>   * that are set up.
>   */
> @@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
>  	 * ABBA AGF deadlocks because a future allocation attempt in this
>  	 * transaction may attempt to lock a lower number AGF.
>  	 *
> -	 * We can't release the AGF until the transaction is commited, so at
> +	 * We can't release the AGF until the transaction is committed, so at
>  	 * this point we must update the "first allocation" tracker to point at
>  	 * this AG if the tracker is empty or points to a lower AG. This allows
>  	 * the next allocation attempt to be modified appropriately to avoid
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b6288395f853..2c80f4fd0b78 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1715,7 +1715,7 @@ xfs_attr3_leaf_add_work(
>  			/*
>  			 * This freemap entry starts at the old end of the
>  			 * leaf entry array, so we need to adjust its base
> -			 * upward to accomodate the larger array.
> +			 * upward to accommodate the larger array.
>  			 */
>  			diff = sizeof(struct xfs_attr_leaf_entry);
>  		} else if (ichdr->freemap[i].size > 0 &&
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6de207fed2d8..f0c83f1f0b3b 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -83,7 +83,7 @@
>  #define XFS_RANDOM_DEFAULT				100
>  
>  /*
> - * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
> + * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
>   *   1. The XFS_ERRTAG_ flag but without the prefix;
>   *   2. The name of the sysfs knob; and
>   *   3. The default value for the knob.
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index 3efed37cb98a..6a66b6075e0a 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -395,7 +395,7 @@ xfs_exchmaps_one_step(
>  	/*
>  	 * Re-add both mappings.  We exchange the file offsets between the two
>  	 * maps and add the opposite map, which has the effect of filling the
> -	 * logical offsets we just unmapped, but with with the physical mapping
> +	 * logical offsets we just unmapped, but with the physical mapping
>  	 * information exchanged.
>  	 */
>  	swap(irec1->br_startoff, irec2->br_startoff);
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd0ed046fbe9..1a7a7e60a170 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
>   * block is 1KB in size.
>   *
>   * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
> - * with 1KB sized blocks, a file can reach upto,
> + * with 1KB sized blocks, a file can reach up to,
>   * 1KB * (2^31) = 2TB
>   *
>   * This is much larger than the theoretical maximum size of a directory
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index e4c3f7b24e95..0340e2189921 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -626,7 +626,7 @@ xfs_dinode_verify(
>  	 * have di_nlink track the link count, even if the actual filesystem
>  	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
>  	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
> -	 * the the incore di_nlink value, which is why we cannot check for
> +	 * the incore di_nlink value, which is why we cannot check for
>  	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
>  	 * di_onlink==0, so we can check that.
>  	 */
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2104512f1ee1..493efa2b2f0d 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1352,7 +1352,7 @@ xrep_iunlink_mark_ondisk(
>  
>  /*
>   * Walk an iunlink bucket's inode list.  For each inode that should be on this
> - * chain, clear its entry in in iunlink_bmp because it's ok and we don't need
> + * chain, clear its entry in iunlink_bmp because it's ok and we don't need
>   * to touch it further.
>   */
>  STATIC int
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> index dce6ab0429dc..84ae88ca027a 100644
> --- a/fs/xfs/scrub/alloc_repair.c
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -338,7 +338,7 @@ xrep_cntbt_extent_cmp(
>  }
>  
>  /*
> - * Sort the free extents by length so so that we can put the records into the
> + * Sort the free extents by length so that we can put the records into the
>   * cntbt in the correct order.  Don't let userspace kill us if we're resorting
>   * after allocating btree blocks.
>   */
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index b2cf6e5439d9..469ba30670f0 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -994,7 +994,7 @@ xchk_dirtree(
>  	return error;
>  }
>  
> -/* Does the directory targetted by this scrub have no parents? */
> +/* Does the directory targeted by this scrub have no parents? */
>  bool
>  xchk_dirtree_parentless(const struct xchk_dirtree *dl)
>  {
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index fcd14c1703ea..d1f4b7159af2 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -172,7 +172,7 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
>  }
>  
>  /*
> - * Decide if we need to roll the transaction to clear out the the log
> + * Decide if we need to roll the transaction to clear out the log
>   * reservation that we allocated to buffer invalidations.
>   */
>  static inline bool xreap_want_binval_roll(const struct xreap_state *rs)
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 89f6e79a955f..aa5b41629747 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -339,7 +339,7 @@ xfs_bmap_update_get_group(
>  
>  	/*
>  	 * Bump the intent count on behalf of the deferred rmap and refcount
> -	 * intent items that that we can queue when we finish this bmap work.
> +	 * intent items that we can queue when we finish this bmap work.
>  	 * This new intent item will bump the intent count before the bmap
>  	 * intent drops the intent count, ensuring that the intent count
>  	 * remains nonzero across the transaction roll.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 030a7c8f2c12..621513d7215e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2669,7 +2669,7 @@ xfs_irele(
>  }
>  
>  /*
> - * Ensure all commited transactions touching the inode are written to the log.
> + * Ensure all committed transactions touching the inode are written to the log.
>   */
>  int
>  xfs_log_force_inode(
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 639f875a8fb2..defd121690f5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
>   * allocation context. However, we do not want to block on memory reclaim
>   * recursing back into the filesystem because this push may have been triggered
>   * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
> - * contraints here.
> + * constraints here.
>   */
>  static void
>  xlog_cil_push_work(
> diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
> index 5d542e95fe44..745d715b4c64 100644
> --- a/fs/xfs/xfs_platform.h
> +++ b/fs/xfs/xfs_platform.h
> @@ -153,7 +153,7 @@ static inline void delay(long ticks)
>  /*
>   * XFS wrapper structure for sysfs support. It depends on external data
>   * structures and is embedded in various internal data structures to implement
> - * the XFS sysfs object heirarchy. Define it here for broad access throughout
> + * the XFS sysfs object hierarchy. Define it here for broad access throughout
>   * the codebase.
>   */
>  struct xfs_kobj {
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bdbb60cc5d5b..b8230b5bf4e3 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -826,7 +826,7 @@ xfs_get_cached_zone(
>  }
>  
>  /*
> - * Stash our zone in the inode so that is is reused for future allocations.
> + * Stash our zone in the inode so that it is reused for future allocations.
>   *
>   * The open_zone structure will be pinned until either the inode is freed or
>   * until the cached open zone is replaced with a different one because the
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 5fdcf98a2133..54b70ed2922f 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -46,7 +46,7 @@
>   * before remapping.
>   *
>   * Once a zone does not contain any valid data, be that through GC or user
> - * block removal, it is queued for for a zone reset.  The reset operation
> + * block removal, it is queued for a zone reset.  The reset operation
>   * carefully ensures that the RT device cache is flushed and all transactions
>   * referencing the rmap have been committed to disk.
>   */
> -- 
> 2.48.1
> 
> 
