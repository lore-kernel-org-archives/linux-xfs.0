Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2CAC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiCRMUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiCRMUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E37E11BCCE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647605921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Ne47amcfrH2oQNwvr6xBx0bzYOqm2z/YQ2voLon/2M=;
        b=UFbkfBbfqIWaDbm/AfooeHrOiREnfP2L4eLrUD/eEA5q9Xyji7L0zJ8Q5FdGA58OJTnroH
        ycCFVAd/vQY9JoDm/svFibQ336JLC0LuxJGY+nZvj1FvudNbf66Utw29GwLwbS4ghrbQ+B
        E6z+Nt2Cnfxqj+D2jUj+cSY1hnr7F3k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-v2ymo72jNEC1AQqiiaqHWA-1; Fri, 18 Mar 2022 08:18:40 -0400
X-MC-Unique: v2ymo72jNEC1AQqiiaqHWA-1
Received: by mail-qv1-f70.google.com with SMTP id s14-20020ad4446e000000b00440d3810126so5727181qvt.5
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Ne47amcfrH2oQNwvr6xBx0bzYOqm2z/YQ2voLon/2M=;
        b=Yny1C/I57uP7D0UzMdz2lYdTT1QEeHgID/qNmfIV126EPCuXo+Z0XU8+lPJeSqnNaI
         aNpxdSFKe2pTrhWNGeJQBWznsxlhOHrY06GK+U9xHN+N6AJTQvg6oKBv+SUQn2pMDCNx
         lPWjskSmAjPgD/W+w8zWF4rcXIxhqGlN606p2as8P5IFc19EY/nbHErJ2aVpOTFrCYgI
         JU0WBJ8KNr+xIGP09HI383GfE950vSYGUs+aerwIbLs5Xp3SlKOQkMRFRBnkG6NmtjvQ
         uw24eFdXJU/ifh+caPn813wp9ivqmjT22GzclIlOj9crdA8INF4NEZ1I1fdxCiBWA8+n
         pGyQ==
X-Gm-Message-State: AOAM531CdqnNRwdtyE3kZunw1pGXYYzfkdFjjv9pvfNnzJQSyY7qC8fj
        k9YTEUs3lLz7wOGDoeDTzkmnWDDozP1NAtuHF9q7Pu7fKLDyOLRZC8RXYQh+L0FbTtyCwnTsnBe
        /13E4wpqZaWgA5W5HALw8
X-Received: by 2002:a05:622a:58f:b0:2e1:eb89:60b5 with SMTP id c15-20020a05622a058f00b002e1eb8960b5mr7098367qtb.166.1647605919743;
        Fri, 18 Mar 2022 05:18:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+oPlU1XTUoe+tlqJbLg4mli0pOBKWlCvV1FRNPWKiso0gmigumKi6brmHpm5ztqHbipXL+w==
X-Received: by 2002:a05:622a:58f:b0:2e1:eb89:60b5 with SMTP id c15-20020a05622a058f00b002e1eb8960b5mr7098335qtb.166.1647605919287;
        Fri, 18 Mar 2022 05:18:39 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id m19-20020a05620a13b300b0067b4cc3041fsm3664469qki.115.2022.03.18.05.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:18:39 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:18:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <YjR4nWL9RXOq1mDi@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755207216.4194202.19795257360716142.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755207216.4194202.19795257360716142.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_reserve_blocks controls the size of the user-visible free space
> reserve pool.  Given the difference between the current and requested
> pool sizes, it will try to reserve free space from fdblocks.  However,
> the amount requested from fdblocks is also constrained by the amount of
> space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> 
> In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> out the "free space" used by the free space btrees, because some portion
> of the free space btrees hold in reserve space for future btree
> expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> of blocks that it could request from xfs_mod_fdblocks was not updated to
> include m_allocbt_blks, so if space is extremely low, the caller hangs.
> 
> Fix this by creating a function to estimate the number of blocks that
> can be reserved from fdblocks, which needs to exclude the set-aside and
> m_allocbt_blks.
> 
> Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> with an fstests configuration that specifies a 1k blocksize and a
> specially crafted log size that will consume 7/8 of the space (17920
> blocks, specifically) in that AG.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |    7 +++++--
>  fs/xfs/xfs_mount.h |   29 +++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 33e26690a8c4..b71799a3acd3 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -433,8 +433,11 @@ xfs_reserve_blocks(
>  	 */
>  	error = -ENOSPC;
>  	do {
> -		free = percpu_counter_sum(&mp->m_fdblocks) -
> -						mp->m_alloc_set_aside;
> +		/*
> +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> +		 * will not give us.
> +		 */

This comment seems unnecessary. I'm not sure what this is telling that
the code doesn't already..?

> +		free = xfs_fdblocks_available(mp);
>  		if (free <= 0)
>  			break;
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 00720a02e761..998b54c3c454 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -479,6 +479,35 @@ extern void	xfs_unmountfs(xfs_mount_t *);
>   */
>  #define XFS_FDBLOCKS_BATCH	1024
>  
> +/*
> + * Estimate the amount of space that xfs_mod_fdblocks might give us without
> + * drawing from the reservation pool.  In other words, estimate the free space
> + * that is available to userspace.
> + *
> + * This quantity is the amount of free space tracked in the on-disk metadata
> + * minus:
> + *
> + * - Delayed allocation reservations
> + * - Per-AG space reservations to guarantee metadata expansion
> + * - Userspace-controlled free space reserve pool
> + *
> + * - Space reserved to ensure that we can always split a bmap btree
> + * - Free space btree blocks that are not available for allocation due to
> + *   per-AG metadata reservations
> + *
> + * The first three are captured in the incore fdblocks counter.
> + */

Hm. Sometimes I wonder if we overdocument things to our own detriment
(reading back my own comments at times suggests I'm terrible at this).
So do we really need to document what other internal reservations are or
are not taken out of ->m_fdblocks here..? I suspect we already have
plenty of sufficient documentation for things like perag res colocated
with the actual code, such that this kind of thing just creates an
external reference that will probably just bitrot as years go by. Can we
reduce this down to just explain how/why this helper has to calculate a
block availability value for blocks that otherwise haven't been
explicitly allocated out of the in-core free block counters?

> +static inline int64_t
> +xfs_fdblocks_available(
> +	struct xfs_mount	*mp)
> +{
> +	int64_t			free = percpu_counter_sum(&mp->m_fdblocks);
> +
> +	free -= mp->m_alloc_set_aside;
> +	free -= atomic64_read(&mp->m_allocbt_blks);
> +	return free;
> +}
> +

FWIW the helper seems fine in context, but will this help us avoid the
duplicate calculation in xfs_mod_fdblocks(), for instance?

Brian

>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> 

