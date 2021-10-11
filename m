Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2874C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Oct 2021 22:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3D860E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Oct 2021 22:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhJKXAj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235610AbhJKXAj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Oct 2021 19:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D3360E9C;
        Mon, 11 Oct 2021 22:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633993118;
        bh=C7TM3EmPN6DorfUEVOLqh8TJscFvq9jGaAVd0ARsT1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oOAawjLPgc6W09z6cqLCC04LuJz+rEeKqmk+zYRPRu2oUVyJNHjXNKpnxA8H3PHxh
         IAd8Vz0/ehIs3ZXxFiUenpmaR1RLiPh1P4GxD6raXoPXTBmgZMRnA0IF5QX9M+j9WX
         dsTSIoVWuQcGKZcVg1Jru1fOpLw9sGyaOBf44C9NfTTNv6NMZzKeuaoMzzveYe3VZq
         FGfSC4zE+4CAwEfYUp/4pFCdfd6oOG4kxl/UmONFl1xVy70mwRrl4pyrPMSk1pyHdj
         8E+B4uvo1J9jgFYNKBJ2+jXEUDdkML8CKZaLWY65FbMaRkBSvBUkSdLzusyky49Z5T
         t7RhldW9YPb+g==
Date:   Mon, 11 Oct 2021 15:58:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] xfs: Use kvcalloc() instead of kvzalloc()
Message-ID: <20211011225838.GJ24307@magnolia>
References: <20210928223307.GA295934@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928223307.GA295934@embeddedor>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 28, 2021 at 05:33:07PM -0500, Gustavo A. R. Silva wrote:
> Use 2-factor argument multiplication form kvcalloc() instead of
> kvzalloc().
> 
> Link: https://github.com/KSPP/linux/issues/162
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Oooh, fun, checks for multiplication overflows.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0c795dc093ef..174cd8950cb6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1547,7 +1547,7 @@ xfs_ioc_getbmap(
>  	if (bmx.bmv_count > ULONG_MAX / recsize)
>  		return -ENOMEM;
>  
> -	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
> +	buf = kvcalloc(bmx.bmv_count, sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> @@ -1601,11 +1601,11 @@ xfs_ioc_getfsmap(
>  	 */
>  	count = min_t(unsigned int, head.fmh_count,
>  			131072 / sizeof(struct fsmap));
> -	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
> +	recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
>  	if (!recs) {
>  		count = min_t(unsigned int, head.fmh_count,
>  				PAGE_SIZE / sizeof(struct fsmap));
> -		recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
> +		recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
>  		if (!recs)
>  			return -ENOMEM;
>  	}
> -- 
> 2.27.0
> 
