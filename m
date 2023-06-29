Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2083EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 15:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjF2PKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjF2PKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 11:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A30810CE
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 08:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08F7861572
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 15:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0C0C433C9;
        Thu, 29 Jun 2023 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688051408;
        bh=630E4uUWCe182KMKhf8JiyyW9ORJqcxBFdG0cl1ScaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uu5/KCvdMVrh/21anuMPACUHWj9Tny3TPNo+HEnbScRj3FEjaY/Nl5u4OsMHkgeoZ
         0opbRKNC/LaRIcUSlrp5ZDXGr46HME+vceAMrU4dSgJSbmoK8KCB2DE0Jxu3MdWWWe
         Ay+Ijt0gqz7fgw7g02OGulizZtTlPeedHJRJt45LaGttW41DnR24nxEQF1QLpsue+F
         3Z+puye5rhvJfkR5dP43MWc5HiaZjIgbAosSPj8Sur7dL5ZwdMI9wqsl1YDs1u1mAx
         g01DdLFZUfYPC9eTO2o6tma0BAVEc+aN5/TqivOEUJ0Ai99TaEXUh4s+XrjMGd62Sk
         MdZc4Nh+77ZYQ==
Date:   Thu, 29 Jun 2023 08:10:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 1/3] xfs: factor out xfs_defer_pending_abort
Message-ID: <20230629151007.GF11441@frogsfrogsfrogs>
References: <20230629131725.945004-1-leo.lilong@huawei.com>
 <20230629131725.945004-2-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629131725.945004-2-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 09:17:23PM +0800, Long Li wrote:
> Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
> not use transaction parameter, so it can be used after the transaction
> life cycle.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index bcfb6a4203cd..7ec6812fa625 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -245,21 +245,18 @@ xfs_defer_create_intents(
>  	return ret;
>  }
>  
> -/* Abort all the intents that were committed. */
> -STATIC void
> -xfs_defer_trans_abort(
> -	struct xfs_trans		*tp,
> -	struct list_head		*dop_pending)
> +void
> +xfs_defer_pending_abort(
> +	struct xfs_mount		*mp,
> +	struct list_head		*dop_list)
>  {
>  	struct xfs_defer_pending	*dfp;
>  	const struct xfs_defer_op_type	*ops;
>  
> -	trace_xfs_defer_trans_abort(tp, _RET_IP_);
> -
>  	/* Abort intent items that don't have a done item. */
> -	list_for_each_entry(dfp, dop_pending, dfp_list) {
> +	list_for_each_entry(dfp, dop_list, dfp_list) {
>  		ops = defer_op_types[dfp->dfp_type];
> -		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
> +		trace_xfs_defer_pending_abort(mp, dfp);
>  		if (dfp->dfp_intent && !dfp->dfp_done) {
>  			ops->abort_intent(dfp->dfp_intent);
>  			dfp->dfp_intent = NULL;
> @@ -267,6 +264,16 @@ xfs_defer_trans_abort(
>  	}
>  }
>  
> +/* Abort all the intents that were committed. */
> +STATIC void
> +xfs_defer_trans_abort(
> +	struct xfs_trans		*tp,
> +	struct list_head		*dop_pending)
> +{
> +	trace_xfs_defer_trans_abort(tp, _RET_IP_);
> +	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
> +}
> +
>  /*
>   * Capture resources that the caller said not to release ("held") when the
>   * transaction commits.  Caller is responsible for zero-initializing @dres.
> -- 
> 2.31.1
> 
