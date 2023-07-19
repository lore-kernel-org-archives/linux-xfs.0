Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB96EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 02:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjGSCIO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 22:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGSCIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 22:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1427412F
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 19:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B913616AE
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 02:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2135C433C8;
        Wed, 19 Jul 2023 02:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689732492;
        bh=ijPlQ2WVC1aTP1Jk1JtdpY4ulihNdu7KQUUj+dcQSTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GY+rv2aP8X5WBKGmyqppmK/4IK2LXbMMV9yWnBd1NA6tAANMvKMCg2JRSddL1VfhZ
         GZzcJvMC5sCfU/EPDN71oF3qWvHawZB7wAqXU1Rmp+vGVHEJh2uKJi017TPvlaPv56
         b49qmgHuIArUfAYQ1yvvMR9IqSDNXKj4IvD3H/E9r4lgkT3OFwCXuBdeX3f5apWbGI
         dQPu6NYHnA6ttMw3jaGt6ObUrmIr9VWaIpwQo1Z86WehHnevQ77gQu5iSvC3FbuTMo
         VLxRV4fwrktOaQ4GrsS4hFZACrKspAN54ugJCbzQpjpikqcO2IiNnYt1EXi8G5ZXln
         mb8nGimn/MB8A==
Date:   Tue, 18 Jul 2023 19:08:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/3] xfs: factor out xfs_defer_pending_abort
Message-ID: <20230719020811.GE11352@frogsfrogsfrogs>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-2-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230715063647.2094989-2-leo.lilong@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 15, 2023 at 02:36:45PM +0800, Long Li wrote:
> Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
> not use transaction parameter, so it can be used after the transaction
> life cycle.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Pretty straightforward slicing and dicing, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index bcfb6a4203cd..88388e12f8e7 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -245,21 +245,18 @@ xfs_defer_create_intents(
>  	return ret;
>  }
>  
> -/* Abort all the intents that were committed. */
>  STATIC void
> -xfs_defer_trans_abort(
> -	struct xfs_trans		*tp,
> -	struct list_head		*dop_pending)
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
