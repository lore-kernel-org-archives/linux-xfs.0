Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A6AC07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIWVsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AC51438E3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F1C4B80E29
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD06C433D6;
        Fri, 23 Sep 2022 21:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663969730;
        bh=8iBfvtAeceJFpt7ppfo/UOjFq+p96RvyUVvjaFUWzyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dhD+FcgSU/1SkLfyKuvtJ89mvAshpUFL+bj43ynEcmc/fI8dLjHKyN/Gad9XRW272
         OxIt1RixYqEMiKtd6OqHEOlS6364sOs9T8Eb2IoWy+YBACLm+Fe50pwVNkqcNKnZua
         h/xlxAFupjyB9udjgOO/Z9nFVevzFKghGEkaFK0IMjnCMqYyFqoY63UyrK5E66c1jz
         xtlDrIHmz+N9Lr04LR70T7DBd/uNDTm5Ebz7JCJ89+Z6mQZga5TF3DrnRMtUGfJNLI
         yFE9CIRF9LbpNqrTR6QMtNXE7OTjQ4beVu6F3LNiJJDm0G2l4357SXZwUsfYPoqipM
         I9ZPNk0S+QVUg==
Date:   Fri, 23 Sep 2022 14:48:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 26/26] xfs: drop compatibility minimum log size
 computations for reflink
Message-ID: <Yy4pwbVagkxMXvCf@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-27-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-27-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:58PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>

This one is totally unchanged from when I sent it.  So:

From: Darrick J. Wong <djwong@kernel.org>

> Having established that we can reduce the minimum log size computation
> for filesystems with parent pointers or any newer feature, we should
> also drop the compat minlogsize code that we added when we reduced the
> transaction reservation size for rmap and reflink.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Change this to

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

and this patch is also done.

--D

> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index e5c606fb7a6a..74821c7fd0cc 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
>  {
>  	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
>  
> +	/*
> +	 * Starting with the parent pointer feature, every new fs feature
> +	 * drops the oversized minimum log size computation introduced by the
> +	 * original reflink code.
> +	 */
> +	if (xfs_has_parent_or_newer_feature(mp)) {
> +		xfs_trans_resv_calc(mp, resv);
> +		return;
> +	}
> +
>  	/*
>  	 * In the early days of rmap+reflink, we always set the rmap maxlevels
>  	 * to 9 even if the AG was small enough that it would never grow to
> -- 
> 2.25.1
> 
