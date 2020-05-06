Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1DFC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 05:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6616720747
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 05:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2iXUCHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEFFem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 01:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFFem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 01:34:42 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED6AC061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 22:34:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b8so281280pgi.11
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 22:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yuuyPda0amNhItrx1qMaJCvDY0ULCuYJRYACpFCgoDU=;
        b=F2iXUCHQPSQijMM/7WszVjJF+zislXavLjHi8jywAMVXlAmpNvfOaT4Vuu4YLmZLye
         c2Z37qMYMsjm/h50iTuWgscDs6IUy+T4MMB6hHMy4/rq2XJDqN4g9R/25hq9vpwTRCZi
         pNdaj8HJ4yhmVi7FHs35cRDa9bH3tdKjxst/iOz72GcPfmBY2NxJCFY3y60vR7dBHWXt
         17X5Gff7fzpeqPyWUv66ND95i6OOtmCHwvkQfWWD6XxgdNTeDlYxMk3ElCNyJQrKaD6A
         DlJMY50Em3GL4jhc67DQwZN9H0wVQ4Hnfz/RyJk+E9L9aJl9W/1gVO95UxgM8Z0+Yirh
         +WxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yuuyPda0amNhItrx1qMaJCvDY0ULCuYJRYACpFCgoDU=;
        b=CF6pCweZAcu+BpboAgpQp42AI0xNan09Xa2VvirO8zzg9QEXsfftwMEVi6OdlUDE0U
         nIXKGAME9UPqYLrmBhVzv5cafoMsCc8ILQA8dd2He6f4+v9q2NCJ6+zPAx56z0G/Z4r/
         n9KmXVRhuLg3fXMtdZc93e1KtLzEq0NRwVRgkJYX4zFrL+EEhGJRvKDzrZxRt/hQ6A5s
         WjDIYfbEKaoTKMiF1wMji2qPkily3aBVF4sNnyRX9DKQ6CbLR95i3fNciraJlG1wTvkH
         14Wv5a1/m29CRhqvT0h+RUg7c6AWCQuHJVjYb/RSmZU9/LdlXrwWKRpnVwH1aqL4VkzP
         5xDA==
X-Gm-Message-State: AGi0PubY+mld9yqTfhsSgveyrbZb+Q5Chr/D/7LMsHpgmSfUeNrFWsPz
        2e6o3t2Rf0UvQ6J5KdNKgbc=
X-Google-Smtp-Source: APiQypLstFWGoXGgSXvB23+kJOlD7Z3d4iCPIHiRYeQ9WH/g8r/xsvqBtCzNV9mJqzcO3fQHJCSIqQ==
X-Received: by 2002:a63:b913:: with SMTP id z19mr5481358pge.187.1588743281861;
        Tue, 05 May 2020 22:34:41 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id a22sm585125pfg.169.2020.05.05.22.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 22:34:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/28] xfs: hoist setting of XFS_LI_RECOVERED to caller
Date:   Wed, 06 May 2020 11:04:38 +0530
Message-ID: <1792910.QcBXxfvSBa@garuda>
In-Reply-To: <158864119233.182683.339682087935092440.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864119233.182683.339682087935092440.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:43:12 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The only purpose of XFS_LI_RECOVERED is to prevent log recovery from
> trying to replay recovered intents more than once.  Therefore, we can
> move the bit setting up to the ->iop_recover caller.
>

The functionality is the same as was before applying this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c     |    5 -----
>  fs/xfs/xfs_extfree_item.c  |    4 ----
>  fs/xfs/xfs_log_recover.c   |    2 +-
>  fs/xfs/xfs_refcount_item.c |    4 ----
>  fs/xfs/xfs_rmap_item.c     |    4 ----
>  5 files changed, 1 insertion(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 8f0dc6d550d1..0793c317defb 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -442,11 +442,8 @@ xfs_bui_item_recover(
>  	int				whichfork;
>  	int				error = 0;
>  
> -	ASSERT(!test_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags));
> -
>  	/* Only one mapping operation per BUI... */
>  	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
> -		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
>  		xfs_bui_release(buip);
>  		return -EFSCORRUPTED;
>  	}
> @@ -480,7 +477,6 @@ xfs_bui_item_recover(
>  		 * This will pull the BUI from the AIL and
>  		 * free the memory associated with it.
>  		 */
> -		set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
>  		xfs_bui_release(buip);
>  		return -EFSCORRUPTED;
>  	}
> @@ -538,7 +534,6 @@ xfs_bui_item_recover(
>  		xfs_bmap_unmap_extent(tp, ip, &irec);
>  	}
>  
> -	set_bit(XFS_LI_RECOVERED, &buip->bui_item.li_flags);
>  	xfs_defer_move(parent_tp, tp);
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index ec8a79fe6cab..b92678bede24 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -594,8 +594,6 @@ xfs_efi_item_recover(
>  	int				i;
>  	int				error = 0;
>  
> -	ASSERT(!test_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags));
> -
>  	/*
>  	 * First check the validity of the extents described by the
>  	 * EFI.  If any are bad, then assume that all are bad and
> @@ -613,7 +611,6 @@ xfs_efi_item_recover(
>  			 * This will pull the EFI from the AIL and
>  			 * free the memory associated with it.
>  			 */
> -			set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
>  			xfs_efi_release(efip);
>  			return -EFSCORRUPTED;
>  		}
> @@ -634,7 +631,6 @@ xfs_efi_item_recover(
>  
>  	}
>  
> -	set_bit(XFS_LI_RECOVERED, &efip->efi_item.li_flags);
>  	error = xfs_trans_commit(tp);
>  	return error;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 8ff957da2845..a49435db3be0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2717,7 +2717,7 @@ xlog_recover_process_intents(
>  		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
> -		if (!test_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
> +		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
>  			spin_unlock(&ailp->ail_lock);
>  			error = lip->li_ops->iop_recover(lip, parent_tp);
>  			spin_lock(&ailp->ail_lock);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index fab821fce76b..e6d355a09bb3 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -442,8 +442,6 @@ xfs_cui_item_recover(
>  	int				i;
>  	int				error = 0;
>  
> -	ASSERT(!test_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags));
> -
>  	/*
>  	 * First check the validity of the extents described by the
>  	 * CUI.  If any are bad, then assume that all are bad and
> @@ -473,7 +471,6 @@ xfs_cui_item_recover(
>  			 * This will pull the CUI from the AIL and
>  			 * free the memory associated with it.
>  			 */
> -			set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
>  			xfs_cui_release(cuip);
>  			return -EFSCORRUPTED;
>  		}
> @@ -557,7 +554,6 @@ xfs_cui_item_recover(
>  	}
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	set_bit(XFS_LI_RECOVERED, &cuip->cui_item.li_flags);
>  	xfs_defer_move(parent_tp, tp);
>  	error = xfs_trans_commit(tp);
>  	return error;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c9233a220551..4a5e2b1cf75a 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -482,8 +482,6 @@ xfs_rui_item_recover(
>  	int				whichfork;
>  	int				error = 0;
>  
> -	ASSERT(!test_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags));
> -
>  	/*
>  	 * First check the validity of the extents described by the
>  	 * RUI.  If any are bad, then assume that all are bad and
> @@ -517,7 +515,6 @@ xfs_rui_item_recover(
>  			 * This will pull the RUI from the AIL and
>  			 * free the memory associated with it.
>  			 */
> -			set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
>  			xfs_rui_release(ruip);
>  			return -EFSCORRUPTED;
>  		}
> @@ -575,7 +572,6 @@ xfs_rui_item_recover(
>  	}
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	set_bit(XFS_LI_RECOVERED, &ruip->rui_item.li_flags);
>  	error = xfs_trans_commit(tp);
>  	return error;
>  
> 
> 


-- 
chandan



