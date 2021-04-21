Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB276C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4AEB6144C
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 15:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhDUPyC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243606AbhDUPyB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120526144B;
        Wed, 21 Apr 2021 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619020408;
        bh=/GU63+RucZWT47UBM5i496uh/Ap71Nif2xPJQmcmxRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=roDWiXsv8Pxky+T3qyl/0OXj2Tt2NzfJzw99P1s5r8KxgoicqhFDzfktTk02UQIdP
         k/YR5/7C/1ZjSIKttRQL+FBtAXnMJZyrv183sCxVhVXOgndgMkRrXBhTUHjvsLulTG
         XG9LzP2nZwJWOASG8CpGYt54gNqdu8I1VsB3yBvoZ3XdyRPi6ekmvF9rGsDs8oakpL
         Hj+m/37GsSrsRtjBKgheODp9Z+dN1BFFPXrBKI1jN9YLs0vWNQHSdpE0zjDvzqhe2q
         +frBgo3UDPuGXH5QcUfvn6eZYRRR2PHNo2fXEV49TINxck/jlraCIbIwhRk7XjphCh
         l8Mos5SfcDMjA==
Date:   Wed, 21 Apr 2021 08:53:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix an uninitialized variable issue
Message-ID: <20210421155327.GR3122264@magnolia>
References: <20210421144135.3188137-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421144135.3188137-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 10:41:35PM +0800, Gao Xiang wrote:
> An uninitialized variable issue reported by Coverity, it seems

Minor nit: we often include the coverity id for things it finds.
Links to a semi-private corporate bug tracker aren't necessarily
generally useful, but I guess they did find a legit bug so we could
throw them one crumb.

> the following for-loop can be exited in advance with isblock == 1,
> and bp is still uninitialized.
> 
> In case of that, initialize bp as NULL in advance to avoid this.
> 
> Fixes: 1f7c7553489c ("repair: don't duplicate names in phase 6")
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Either way, it's not worth holding up this patch, so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/phase6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 72287b5c..6bddfefa 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2195,7 +2195,7 @@ longform_dir2_entry_check(
>  	int			ino_offset,
>  	struct dir_hash_tab	*hashtab)
>  {
> -	struct xfs_buf		*bp;
> +	struct xfs_buf		*bp = NULL;
>  	xfs_dablk_t		da_bno;
>  	freetab_t		*freetab;
>  	int			i;
> -- 
> 2.27.0
> 
