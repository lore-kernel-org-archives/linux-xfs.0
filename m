Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F972C7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 14:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjFAOu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbjFAOu2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 10:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA651A7
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 07:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124A964621
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65805C433D2;
        Thu,  1 Jun 2023 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685631024;
        bh=oo1YcKR2TPep7CeMZO5Hh/Nzn227/YiH4upVUpsgvmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dQwd7lPxXYx6l/qbTMUcuhQXxDeCiYwWvA2r4UZOxX+RvouG6ffOkBfcHKM0/vkeQ
         tslEqtZIK7j8NS4vIV1rzO3h22ZuwpTTSziFQATDCpMioIgCSiPK+gMHfGC5FaueZK
         48RXkgQ/oin5kZI1WPiAacHBycbZnMl5FdhtNPQ24bggNzWidc2mGtG6VokkZCpo0y
         qkEUR2r5/9FDJj4lwBao7UZssZHgPZJCT0rnopbgyHWk8wzdzZTvFUQ19ckhY1rmGC
         9BwhaA/SVzI0G1k2WeT4SwemAgjA8y3tViwH1eE6Tg95RWy2bJxU7ZgJ/Ye0VwpuiV
         wOYUuG4lylZIQ==
Date:   Thu, 1 Jun 2023 07:50:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix agf/agfl verification on v4 filesystems
Message-ID: <20230601145023.GC16865@frogsfrogsfrogs>
References: <20230529000825.2325477-1-david@fromorbit.com>
 <20230529000825.2325477-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529000825.2325477-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 29, 2023 at 10:08:23AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a v4 filesystem has fl_last - fl_first != fl_count, we do not
> not detect the corruption and allow the AGF to be used as it if was
> fully valid. On V5 filesystems, we reset the AGFL to empty in these
> cases and avoid the corruption at a small cost of leaked blocks.
> 
> If we don't catch the corruption on V4 filesystems, bad things
> happen later when an allocation attempts to trim the free list
> and either double-frees stale entries in the AGFl or tries to free
> NULLAGBNO entries.
> 
> Either way, this is bad. Prevent this from happening by using the
> AGFL_NEED_RESET logic for v4 filesysetms, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems logical,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 59 ++++++++++++++++++++++++++++-----------
>  1 file changed, 42 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 61eb65be17f3..fd3293a8c659 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -628,6 +628,25 @@ xfs_alloc_fixup_trees(
>  	return 0;
>  }
>  
> +/*
> + * We do not verify the AGFL contents against AGF-based index counters here,
> + * even though we may have access to the perag that contains shadow copies. We
> + * don't know if the AGF based counters have been checked, and if they have they
> + * still may be inconsistent because they haven't yet been reset on the first
> + * allocation after the AGF has been read in.
> + *
> + * This means we can only check that all agfl entries contain valid or null
> + * values because we can't reliably determine the active range to exclude
> + * NULLAGBNO as a valid value.
> + *
> + * However, we can't even do that for v4 format filesystems because there are
> + * old versions of mkfs out there that does not initialise the AGFL to known,
> + * verifiable values. HEnce we can't tell the difference between a AGFL block
> + * allocated by mkfs and a corrupted AGFL block here on v4 filesystems.
> + *
> + * As a result, we can only fully validate AGFL block numbers when we pull them
> + * from the freelist in xfs_alloc_get_freelist().
> + */
>  static xfs_failaddr_t
>  xfs_agfl_verify(
>  	struct xfs_buf	*bp)
> @@ -637,12 +656,6 @@ xfs_agfl_verify(
>  	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
>  	int		i;
>  
> -	/*
> -	 * There is no verification of non-crc AGFLs because mkfs does not
> -	 * initialise the AGFL to zero or NULL. Hence the only valid part of the
> -	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
> -	 * can't verify just those entries are valid.
> -	 */
>  	if (!xfs_has_crc(mp))
>  		return NULL;
>  
> @@ -2321,12 +2334,16 @@ xfs_free_agfl_block(
>  }
>  
>  /*
> - * Check the agfl fields of the agf for inconsistency or corruption. The purpose
> - * is to detect an agfl header padding mismatch between current and early v5
> - * kernels. This problem manifests as a 1-slot size difference between the
> - * on-disk flcount and the active [first, last] range of a wrapped agfl. This
> - * may also catch variants of agfl count corruption unrelated to padding. Either
> - * way, we'll reset the agfl and warn the user.
> + * Check the agfl fields of the agf for inconsistency or corruption.
> + *
> + * The original purpose was to detect an agfl header padding mismatch between
> + * current and early v5 kernels. This problem manifests as a 1-slot size
> + * difference between the on-disk flcount and the active [first, last] range of
> + * a wrapped agfl.
> + *
> + * However, we need to use these same checks to catch agfl count corruptions
> + * unrelated to padding. This could occur on any v4 or v5 filesystem, so either
> + * way, we need to reset the agfl and warn the user.
>   *
>   * Return true if a reset is required before the agfl can be used, false
>   * otherwise.
> @@ -2342,10 +2359,6 @@ xfs_agfl_needs_reset(
>  	int			agfl_size = xfs_agfl_size(mp);
>  	int			active;
>  
> -	/* no agfl header on v4 supers */
> -	if (!xfs_has_crc(mp))
> -		return false;
> -
>  	/*
>  	 * The agf read verifier catches severe corruption of these fields.
>  	 * Repeat some sanity checks to cover a packed -> unpacked mismatch if
> @@ -2889,6 +2902,19 @@ xfs_alloc_put_freelist(
>  	return 0;
>  }
>  
> +/*
> + * Verify the AGF is consistent.
> + *
> + * We do not verify the AGFL indexes in the AGF are fully consistent here
> + * because of issues with variable on-disk structure sizes. Instead, we check
> + * the agfl indexes for consistency when we initialise the perag from the AGF
> + * information after a read completes.
> + *
> + * If the index is inconsistent, then we mark the perag as needing an AGFL
> + * reset. The first AGFL update performed then resets the AGFL indexes and
> + * refills the AGFL with known good free blocks, allowing the filesystem to
> + * continue operating normally at the cost of a few leaked free space blocks.
> + */
>  static xfs_failaddr_t
>  xfs_agf_verify(
>  	struct xfs_buf		*bp)
> @@ -2962,7 +2988,6 @@ xfs_agf_verify(
>  		return __this_address;
>  
>  	return NULL;
> -
>  }
>  
>  static void
> -- 
> 2.40.1
> 
