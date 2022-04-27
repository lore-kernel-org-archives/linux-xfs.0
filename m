Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A778C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 03:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiD0DW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiD0DW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 23:22:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BA226133
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 20:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D1A061C64
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 03:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CB2C385A4;
        Wed, 27 Apr 2022 03:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651029555;
        bh=4RRel/p2+/UJw0mDa/9b1NmDY3khlCVAayiaknUt59E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZ+IYeCaeG89bbNXV1auJ7rWNxHygZmuH0sE0ZDPJ0R/XxI6KO69jmtdLrSF0EQNC
         PNL9SqdiEE2DjzR2hbMNa+u7RmTWGZZ62ph2/Fly7GhC7WWlRmkFJ3nMsaSVsZ7jKE
         Dixa8WetrbPu/DOzqV3dLw+XZXb3otHTLPN7JK2n5ITFRYTUaQLg7MePnGMYfgjdKD
         JqbV/7Q5LFHENGxu9BY0+Dvz/7sdBGTZhlwn0PvjZV2eEGFMXoTtzP7QoivChP7PzA
         mWjOEk9dbnsoERKhWnegN/r47y49lJFGxClKMi0sBZeyDRBmbnv1Fd0oUCrkMabFl4
         Gj0Hseu1TYUZQ==
Date:   Tue, 26 Apr 2022 20:19:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: whiteouts release intents that are not in the
 AIL
Message-ID: <20220427031915.GG17025@magnolia>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 12:22:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we release an intent that a whiteout applies to, it will not
> have been committed to the journal and so won't be in the AIL. Hence
> when we drop the last reference to the intent, we do not want to try
> to remove it from the AIL as that will trigger a filesystem
> shutdown. Hence make the removal of intents from the AIL conditional
> on them actually being in the AIL so we do the correct thing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Same provisional RVB as the last patch.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_item.c     | 8 +++++---
>  fs/xfs/xfs_extfree_item.c  | 8 +++++---
>  fs/xfs/xfs_refcount_item.c | 8 +++++---
>  fs/xfs/xfs_rmap_item.c     | 8 +++++---
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e1b0e321d604..59aa5f9bf769 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -54,10 +54,12 @@ xfs_bui_release(
>  	struct xfs_bui_log_item	*buip)
>  {
>  	ASSERT(atomic_read(&buip->bui_refcount) > 0);
> -	if (atomic_dec_and_test(&buip->bui_refcount)) {
> +	if (!atomic_dec_and_test(&buip->bui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &buip->bui_item.li_flags))
>  		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_bui_item_free(buip);
> -	}
> +	xfs_bui_item_free(buip);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 032db5269e97..893a7dd15cbb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -58,10 +58,12 @@ xfs_efi_release(
>  	struct xfs_efi_log_item	*efip)
>  {
>  	ASSERT(atomic_read(&efip->efi_refcount) > 0);
> -	if (atomic_dec_and_test(&efip->efi_refcount)) {
> +	if (!atomic_dec_and_test(&efip->efi_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &efip->efi_item.li_flags))
>  		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_efi_item_free(efip);
> -	}
> +	xfs_efi_item_free(efip);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index a2213b5ee344..1b82b818f515 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -53,10 +53,12 @@ xfs_cui_release(
>  	struct xfs_cui_log_item	*cuip)
>  {
>  	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
> -	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> +	if (!atomic_dec_and_test(&cuip->cui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &cuip->cui_item.li_flags))
>  		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_cui_item_free(cuip);
> -	}
> +	xfs_cui_item_free(cuip);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 053eb135380c..99dfb3ae7e9c 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -53,10 +53,12 @@ xfs_rui_release(
>  	struct xfs_rui_log_item	*ruip)
>  {
>  	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
> -	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> +	if (!atomic_dec_and_test(&ruip->rui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &ruip->rui_item.li_flags))
>  		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_rui_item_free(ruip);
> -	}
> +	xfs_rui_item_free(ruip);
>  }
>  
>  STATIC void
> -- 
> 2.35.1
> 
