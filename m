Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A208CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 17:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbiCHR0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 12:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349121AbiCHR0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 12:26:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFA4554BB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 09:25:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 183DF60C82
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79943C340F4
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646760338;
        bh=HpKQnWiZSYPN2fLzdRVBosncC6Jn3JjClAPbYb4V6V0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=IV8DNIn3wk79LpAqoIqlVWWTh5BAwB2bHIAJkgrULE3H1ykaX3wVo92BH8EXajXWa
         lMsxMdH/ACnWjfaerSiyLz00KIKa9fMY3oYLVmSpYznFaoOv7m9Np+kl32a8+hsKRm
         1BbLKrJDl8tbGMVsQwdXQG4g0GDiBBaTx2cEhNShF2FPnMVNnToVN+mnQfO27u3KcJ
         XzG6Qxts1WTnkV1MNLY4N+Hl6edl6XF6qULmZBWB1C0Pq0U7heInuvs1dMiyCUFn7Y
         r3R6D+OLHzxBt/McaxH13K3sCX4WfRUhWTS4OaAyDx3/9zQSmgvTiujdiOFNNo4Zti
         /BYoCn53QefzA==
Date:   Tue, 8 Mar 2022 09:25:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reserve quota for directory expansion when
 hardlinking files
Message-ID: <20220308172538.GN117732@magnolia>
References: <20220301025118.GG117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301025118.GG117732@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 06:51:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The XFS implementation of the linkat call does not reserve quota for the
> potential directory expansion.  This means that we don't reject the
> expansion with EDQUOT when we're at or near a hard limit, which means
> that one can use linkat() to exceed quota.  Fix this by adding a quota
> reservation.

Could someone review this, please?  I'd like to get a 5.18-fixes branch
rolling along with the other patches that have already been sent.

--D

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 04bf467b1090..6e556c9069e8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1249,6 +1249,10 @@ xfs_link(
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
> +	error = xfs_trans_reserve_quota_nblks(tp, tdp, resblks, 0, false);
> +	if (error)
> +		goto error_return;
> +
>  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
>  			XFS_IEXT_DIR_MANIP_CNT(mp));
>  	if (error)
