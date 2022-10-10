Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D321BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 15:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJJPaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 11:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJJPaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 11:30:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8599B23BC3;
        Mon, 10 Oct 2022 08:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47750B80D84;
        Mon, 10 Oct 2022 15:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D561CC433C1;
        Mon, 10 Oct 2022 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665415801;
        bh=xcnH61eTn1TVuj0oJVhLHyFXph2kYEMmECjczq4PB34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtWE8Uifv13Qudm5jiAB9FaT+Z8dSRcFMS6hElfYm/QUW3XINboR9Jn3TfZCoih/4
         ugTiULEgK101llwSFnOZInlSwUo/tZIxyxnFBh6pHDUazv6XXJGYCaatsb0memBy/r
         /fUoxy0ZXc49vV8oFbgZzJQaaxt8tVsT2L+X78SGdoTvYZAWnuR3ltEPsivmC2f6uy
         QN5RhlEl0T+Vr/7cV4ddNkUEcLf0P0wTUVxhx2sJVBy8bM0AGzBrGq5aqtYaquNZtr
         Wqwbp97+ic+TFaO7UxEbV+pGbPnnmu+OsnCjLrkG2wjYXBsi3ZHRlx/ny0oFtOd4Xj
         c0rE2eCiQSIvQ==
Date:   Mon, 10 Oct 2022 08:30:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        bllvm@lists.linux.dev
Subject: Re: [PATCH] xfs: remove redundant pointer lip
Message-ID: <Y0Q6eY8dYKxINS6G@magnolia>
References: <20221010143119.3191249-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010143119.3191249-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2022 at 03:31:19PM +0100, Colin Ian King wrote:
> The assignment to pointer lip is not really required, the pointer lip
> is redundant and can be removed.
> 
> Cleans up clang-scan warning:
> warning: Although the value stored to 'lip' is used in the enclosing
> expression, the value is never actually read from 'lip'
> [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 16fbf2a1144c..87db72758d1f 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -730,11 +730,10 @@ void
>  xfs_ail_push_all_sync(
>  	struct xfs_ail  *ailp)
>  {
> -	struct xfs_log_item	*lip;
>  	DEFINE_WAIT(wait);
>  
>  	spin_lock(&ailp->ail_lock);
> -	while ((lip = xfs_ail_max(ailp)) != NULL) {
> +	while (xfs_ail_max(ailp)) {

I've a slight stylistic preference for leaving the pointer comparison
explicit here, but I agree that @lip is no longer needed.

	while (xfs_ail_max(ailp) != NULL) {

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
>  		wake_up_process(ailp->ail_task);
>  		spin_unlock(&ailp->ail_lock);
> -- 
> 2.37.3
> 
