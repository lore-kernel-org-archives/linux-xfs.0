Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60E9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 04:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACBA561186
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 04:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhKJE0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 23:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhKJE0l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Nov 2021 23:26:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 630006117A;
        Wed, 10 Nov 2021 04:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636518234;
        bh=WpS/1ieLdi53G+0nE74ff5IYhREHzI/c9t0t6gUgiT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmAfNSRL+m8tzhTW2vwytQRlm8S5YiisbWs2iurt589QYc9wJGq3GkZQSnL6v7oz0
         gDMXoPkzaFGn0O4NL+EwWL+FQwBQftPcLO3Kf7SgUjBb6e7OCCBJOmT1oNpLCoi7LX
         KwfIpSpC9u3iiTmaSiTFeRhYFUx8EIC5FqK/XjxEySMDoQghp53sgFKMS9aRL7t2Sw
         vW8KZSTntuj/UyI3prscLqnbpOqAOXPbD3xLt2UtMENumvWHdPHsoU/Qz6ny0ZT7Eg
         6Dq4NlHx6esdqn+1ZXcA8E1TVNFCvvB0z21YQYZTJAD+nc5uxHRvci+b3toZg9u42H
         6bUOn+cBoE9mg==
Date:   Tue, 9 Nov 2021 20:23:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] libxfs: #ifdef out perag code for userspace
Message-ID: <20211110042353.GZ24307@magnolia>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
 <7e8a7998-5915-a9a4-e3db-50932781aee3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8a7998-5915-a9a4-e3db-50932781aee3@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 07:58:34PM -0600, Eric Sandeen wrote:
> The xfs_perag structure and initialization is unused in userspace,
> so #ifdef it out with __KERNEL__ to facilitate the xfsprogs sync
> and build.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks severely whitespace damaged, but /me has gotten tired of dealing
with all the navel gazing around #ifdef __KERNEL__.  I want to move on
to more difficult topics like grokking and evaluating online repair, and
get us away from arguing about how to preprocessor.

This gets us closer to parity between the two libxfses, and reflects
what the two libxfs maintainers more or less agree upon, so with patch
4/3 added in and the whitespace fixed...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 005abfd9fd34..ecfb213d8fa3 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -248,6 +248,7 @@ xfs_initialize_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
> +#ifdef __KERNEL__
>  		/* Place kernel structure only init below this point. */
>  		spin_lock_init(&pag->pag_ici_lock);
>  		spin_lock_init(&pag->pagb_lock);
> @@ -257,6 +258,7 @@ xfs_initialize_perag(
>  		init_waitqueue_head(&pag->pagb_wait);
>  		pag->pagb_count = 0;
>  		pag->pagb_tree = RB_ROOT;
> +#endif	/* __KERNEL_ */
>  		error = xfs_buf_hash_init(pag);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4c6f9045baca..01c36cfe6909 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -64,6 +64,10 @@ struct xfs_perag {
>  	/* Blocks reserved for the reverse mapping btree. */
>  	struct xfs_ag_resv	pag_rmapbt_resv;
> +	/* for rcu-safe freeing */
> +	struct rcu_head	rcu_head;
> +
> +#ifdef __KERNEL__
>  	/* -- kernel only structures below this line -- */
>  	/*
> @@ -90,9 +94,6 @@ struct xfs_perag {
>  	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
>  	struct rhashtable pag_buf_hash;
> -	/* for rcu-safe freeing */
> -	struct rcu_head	rcu_head;
> -
>  	/* background prealloc block trimming */
>  	struct delayed_work	pag_blockgc_work;
> @@ -102,6 +103,7 @@ struct xfs_perag {
>  	 * or have some other means to control concurrency.
>  	 */
>  	struct rhashtable	pagi_unlinked_hash;
> +#endif	/* __KERNEL__ */
>  };
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
> 
