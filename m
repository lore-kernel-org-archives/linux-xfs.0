Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04609C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 15:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350124AbiCUPYE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 11:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348926AbiCUPYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 11:24:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80D30111DF5
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 08:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647876151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ue5sFx3kgn4KbBlrKR5bimlTLmfnSBCDH9OOCKRo1Jg=;
        b=V5qpFEwkbUsa1NZLtCcBIkQ3ryD9eC33ObxmM3uoIRe6Zj6Iy5cMlrjdgCT44SS+v9xwk3
        /ZYCoRwSRsokenu5kKio/DNHEiK8SFvJeKTXSID0s2exDuqPTMCiw+Wux15brrMTzn5wYO
        TL1idrM3v0WUexdHW73wBwN5sjkqo98=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-fZSEbPiCMsKoFtsleV5TtA-1; Mon, 21 Mar 2022 11:22:30 -0400
X-MC-Unique: fZSEbPiCMsKoFtsleV5TtA-1
Received: by mail-qt1-f197.google.com with SMTP id k11-20020ac8604b000000b002e1a4109edeso9499331qtm.15
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 08:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ue5sFx3kgn4KbBlrKR5bimlTLmfnSBCDH9OOCKRo1Jg=;
        b=WfiQyWPlLLLC0NVyKJwdYI8ifu3+G2ULqsIhHCCmKAEQdpt34c2LBV8AW6McqmPL6A
         IfoHMWOCm/oU2ZUtMZav/uTfPbnVFQ5WoZpAKGxV9Y75Dxx1IcQhzto7b9xyoYWS3Kix
         a8j5uZ4tWhQks6GyjB7f02xNI4moE2dFOSPd0e/B/ZDR2wUuFYiarhWad7rr2QFKMjlT
         h72zMatvLFr4lAN4rmTytYAQmMwFmO0HyjYtnW2jLw+l/CQDQMza87ucubCxB1ObELx9
         i89JMLKq6lGcrn2vsD6PAWCykySyjSmitRe/nIyTN+1/6NkUsa60eyYsQRDnxh2sgJMC
         DELg==
X-Gm-Message-State: AOAM532TALgkQJkIV4uHfmzSDFoToh5D8L23CcR/9QgphnPfKQq3zN9n
        WkDBArScq4+SoZ2yhYUtjB0C3dy8Lvur5cRTE5J1uvrLvzDWGSwpgk4x0iwzTU/a/LIvnPG76xI
        o/9hLqmD1mX23pQOLQMiv
X-Received: by 2002:a05:622a:48e:b0:2e0:706f:1d4 with SMTP id p14-20020a05622a048e00b002e0706f01d4mr16328816qtx.326.1647876149810;
        Mon, 21 Mar 2022 08:22:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsYDJEnWxAwIxkFe2oIu7AD6Ym47aTsjSoEan08vePVBCo6uXe9ym8f0DJR0j5XJ2oAVtc0g==
X-Received: by 2002:a05:622a:48e:b0:2e0:706f:1d4 with SMTP id p14-20020a05622a048e00b002e0706f01d4mr16328795qtx.326.1647876149564;
        Mon, 21 Mar 2022 08:22:29 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b0067afe7dd3ffsm8291241qki.49.2022.03.21.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 08:22:29 -0700 (PDT)
Date:   Mon, 21 Mar 2022 11:22:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <YjiYM2uxEHAfWFmz@bfoster>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462392.550479.11627083041484347485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779462392.550479.11627083041484347485.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:43AM -0700, Darrick J. Wong wrote:
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
>  fs/xfs/xfs_fsops.c |    2 +-
>  fs/xfs/xfs_mount.c |    2 +-
>  fs/xfs/xfs_mount.h |   15 +++++++++++++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 00720a02e761..da1b7056e743 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -479,6 +479,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
>   */
>  #define XFS_FDBLOCKS_BATCH	1024
>  
> +/*
> + * Estimate the amount of free space that is not available to userspace and is
> + * not explicitly reserved from the incore fdblocks:
> + *
> + * - Space reserved to ensure that we can always split a bmap btree
> + * - Free space btree blocks that are not available for allocation due to
> + *   per-AG metadata reservations
> + */

What does this mean by "due to" perag res? That sounds like a separate
thing to me. Perhaps this could just say something like:

"Estimate the amount of accounted free space that is not available to
userspace. This includes the minimum number of blocks to support a bmbt
split (calculated at mount time) and the blocks currently in-use by the
allocation btrees."

Comment nit aside, this LGTM. Thanks for the rework..

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +static inline uint64_t
> +xfs_fdblocks_unavailable(
> +	struct xfs_mount	*mp)
> +{
> +	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +}
> +
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
>  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> 

