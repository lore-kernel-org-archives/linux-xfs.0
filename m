Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D009572626
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746652074; cv=none; b=Cz9s19VD/i6NcrTH//t3Ex0HBoN3UPIlG627+s9pTFRZLRDeuPMHsZ3NDhWRuK0C83GDV3y+DdND8y6LqJZETliMhuwuIc5jvxsR9JpvMKJkYCXMDAsmEI+6ohUzoTgZxV0UAlFKgrESmI1P5O11lDbJgIfhhA0DiM2C3PCqj60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746652074; c=relaxed/simple;
	bh=TIzaWb3IdYU0RbQ8ko2EefilAeWvzdePM2W7yOXzePY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBaMBTF7AWf17EBUhNqSWwk8UQGE86mAiWibP0Ltyt+1PzbrBwLvQXtm+/c3UHMyaU/MLHVBThmH8atfj4xoU9BkcFPK6vV6JQhpQeoD1+Unu4crh9KApx5WgOI/cyC2UPUUD9/FRJiTDqmmUVdkN7HMbWPWWcIalXEn5PxpET4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwJVn33p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwJVn33p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D43C4CEE2;
	Wed,  7 May 2025 21:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746652074;
	bh=TIzaWb3IdYU0RbQ8ko2EefilAeWvzdePM2W7yOXzePY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fwJVn33pSdwW1rP8H2jcr3SsrBZCJVqIIIgC5dnPUvRgSlhPn2DD0ktGrCbL33l8c
	 DZIdUO8QQeEKNC+ZRbsMeDp+t0spj8FJ5qyWcXalSCzTPkY+WI3yIdFPeLoqzNJV3d
	 X4TSl+TetY9kjrTLPDqd4PHU+DiYyeY3xKF7NmgSdgKzMIdwseJUzG5S+KaPfYh9zx
	 uWkUfk3fFI6mxjNWIsu4ifuk7DPldltK9/bmiPcr3cVMOvs5W7lYz2mj4lJgZSjv9+
	 /tr/dtehzvn4jNQWh7AWK7VfxcPRn621qYziURwS1HU8K0CD4J0wGlJvk/IPzmos9T
	 IxipiCgm/5pug==
Date: Wed, 7 May 2025 14:07:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
Message-ID: <20250507210753.GJ25675@frogsfrogsfrogs>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507095239.477105-3-cem@kernel.org>

On Wed, May 07, 2025 at 11:52:31AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This function doesn't take the AIL lock, but should be called
> with AIL lock held. Also (hopefuly) simplify the comment.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 7d327a3e5a73..ea092368a5c7 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -777,26 +777,28 @@ xfs_ail_update_finish(
>  }
>  
>  /*
> - * xfs_trans_ail_update - bulk AIL insertion operation.
> + * xfs_trans_ail_update_bulk - bulk AIL insertion operation.
>   *
> - * @xfs_trans_ail_update takes an array of log items that all need to be
> + * @xfs_trans_ail_update_bulk takes an array of log items that all need to be
>   * positioned at the same LSN in the AIL. If an item is not in the AIL, it will
> - * be added.  Otherwise, it will be repositioned  by removing it and re-adding
> - * it to the AIL. If we move the first item in the AIL, update the log tail to
> - * match the new minimum LSN in the AIL.
> + * be added. Otherwise, it will be repositioned by removing it and re-adding
> + * it to the AIL.
>   *
> - * This function takes the AIL lock once to execute the update operations on
> - * all the items in the array, and as such should not be called with the AIL
> - * lock held. As a result, once we have the AIL lock, we need to check each log
> - * item LSN to confirm it needs to be moved forward in the AIL.
> + * If we move the first item in the AIL, update the log tail to match the new
> + * minimum LSN in the AIL.
>   *
> - * To optimise the insert operation, we delete all the items from the AIL in
> - * the first pass, moving them into a temporary list, then splice the temporary
> - * list into the correct position in the AIL. This avoids needing to do an
> - * insert operation on every item.
> + * This function should be called with the AIL lock held.
>   *
> - * This function must be called with the AIL lock held.  The lock is dropped
> - * before returning.
> + * To optimise the insert operation, we add all items to a temporary list, then
> + * splice this list into the correct position in the AIL.
> + *
> + * Items that are already in the AIL are first deleted from their current location
> + * before being added to the temporary list.
> + *
> + * This avoids needing to do an insert operation on every item.
> + *
> + * The AIL lock is dropped by xfs_ail_update_finish() before returning to
> + * the caller.

/me thinks this sounds right, but maybe check with dchinner...

>   */
>  void
>  xfs_trans_ail_update_bulk(
> @@ -817,7 +819,7 @@ xfs_trans_ail_update_bulk(
>  	for (i = 0; i < nr_items; i++) {
>  		struct xfs_log_item *lip = log_items[i];
>  		if (test_and_set_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> -			/* check if we really need to move the item */
> +			* check if we really need to move the item */

                        ^busted comment marker?

--D

>  			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
>  				continue;
>  
> -- 
> 2.49.0
> 
> 
