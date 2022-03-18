Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9180C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiCRMVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiCRMVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C255119BFC9
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647605991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rG03QF6+Vdcj0yZJist13j7mWcWqF4bFKvifKmAvZ+o=;
        b=gts9RXpqGi4oEGZ3MdMPnRh1oiYbV807MYHKhdoLsSYHDIqI/2A+Xp12xaE/Kh1+tFxL0n
        OCNW19oa6ytJBZ851sTPm/k+2kJ81GTD/GFHOdtwAxz6SYZlvv/9vk9omJWt9iHQguNylZ
        SZpk69vduULvamMotdTpKqVEmLfd/JA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-Od9WEBpiN3eCSf_NnJUpTA-1; Fri, 18 Mar 2022 08:19:50 -0400
X-MC-Unique: Od9WEBpiN3eCSf_NnJUpTA-1
Received: by mail-qv1-f72.google.com with SMTP id z7-20020ad44147000000b004354c61c2a1so6130801qvp.7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rG03QF6+Vdcj0yZJist13j7mWcWqF4bFKvifKmAvZ+o=;
        b=01SQCStjJedsDBC/PIH6ahuy8NBYI9AY2UOvxGnwBQUghFjseClULijYVWtbC/KEN5
         4inZZJmZ1Oj+wjDnkxvVQRpp6QYVVQC29DUSCmKp8z3GlH/pCEkRx5WaNCZqfUkA5dgE
         PZ1vtsMg5Bp+dvsq1BM6DfRQp36ylN7Tch01AudxTsPNUH8PTOPsVubjbV0SxCkJtBiW
         VwUb10aXr/Zw5dL2o6QzDOqmCdaQtuqCJPGlgh7xJuACKuqz0lW0dXGTaePPmRO2ZEg2
         +670TBZb/STOhmCEPETmipdUUFWoxz9iCBSgWGQQxj5yMw9ad3jiQFBzuuXDB1HOSiDK
         giNA==
X-Gm-Message-State: AOAM533eUOkKQ2yN/T6OqFphrS0Cem/Ojd9T9H9rlJu+TqRV4C2ShlRx
        DlelprCelztpe5LPmh3xm2IZlHUBNyCNEgQ5zi7mew30xdnJ3bEdiiC9lwKS1BSUeRg4QMOqaLO
        MhMFu2GWQUTOg/TOzJLmv
X-Received: by 2002:a05:6214:da5:b0:437:6669:20e5 with SMTP id h5-20020a0562140da500b00437666920e5mr6748298qvh.9.1647605990152;
        Fri, 18 Mar 2022 05:19:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvdns+iqiZU6MtBbyXH6msC0q/JA/lBxOxagpbvdoIo6QhQ84eUZifalj/TbKXVF4936sbjQ==
X-Received: by 2002:a05:6214:da5:b0:437:6669:20e5 with SMTP id h5-20020a0562140da500b00437666920e5mr6748285qvh.9.1647605989901;
        Fri, 18 Mar 2022 05:19:49 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id s15-20020a05620a080f00b0067dff16a0b1sm3741475qks.116.2022.03.18.05.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:19:49 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:19:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: don't report reserved bnobt space as available
Message-ID: <YjR45Cocvq23N157@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755208338.4194202.6258724683699525828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755208338.4194202.6258724683699525828.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a modern filesystem, we don't allow userspace to allocate blocks for
> data storage from the per-AG space reservations, the user-controlled
> reservation pool that prevents ENOSPC in the middle of internal
> operations, or the internal per-AG set-aside that prevents ENOSPC.
> Since we now consider free space btree blocks as unavailable for
> allocation for data storage, we shouldn't report those blocks via statfs
> either.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |    3 +--
>  fs/xfs/xfs_mount.h |   13 +++++++++++++
>  fs/xfs/xfs_super.c |    4 +---
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 998b54c3c454..74e9b8558162 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -508,6 +508,19 @@ xfs_fdblocks_available(
>  	return free;
>  }
>  
> +/* Same as above, but don't take the slow path. */
> +static inline int64_t
> +xfs_fdblocks_available_fast(
> +	struct xfs_mount	*mp)
> +{
> +	int64_t			free;
> +
> +	free = percpu_counter_read_positive(&mp->m_fdblocks);
> +	free -= mp->m_alloc_set_aside;
> +	free -= atomic64_read(&mp->m_allocbt_blks);
> +	return free;
> +}
> +

No objection to the behavior change, but the point of the helper should
be to simplify things and reduce duplication. Here it seems we're going
to continue duplicating the set aside calculation, just in separate
helpers because different contexts apparently have different ways of
reading the free space counters (?).

If that's the case and we want an _available() helper, can we create a
single helper that takes the fdblocks count as a parameter and returns
the final "available" value so the helper can be used more broadly and
consistently? (Or factor out the common bits into an internal helper and
turn these two into simple parameter passing wrappers if you really want
to keep the api as such).

Brian

>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d84714e4e46a..7b6c147e63c4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -791,7 +791,6 @@ xfs_fs_statfs(
>  	uint64_t		fakeinos, id;
>  	uint64_t		icount;
>  	uint64_t		ifree;
> -	uint64_t		fdblocks;
>  	xfs_extlen_t		lsize;
>  	int64_t			ffree;
>  
> @@ -806,7 +805,6 @@ xfs_fs_statfs(
>  
>  	icount = percpu_counter_sum(&mp->m_icount);
>  	ifree = percpu_counter_sum(&mp->m_ifree);
> -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
>  
>  	spin_lock(&mp->m_sb_lock);
>  	statp->f_bsize = sbp->sb_blocksize;
> @@ -815,7 +813,7 @@ xfs_fs_statfs(
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	/* make sure statp->f_bfree does not underflow */
> -	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
> +	statp->f_bfree = max_t(int64_t, xfs_fdblocks_available(mp), 0);
>  	statp->f_bavail = statp->f_bfree;
>  
>  	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> 

