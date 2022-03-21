Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A850C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 15:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242569AbiCUPYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 11:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241448AbiCUPY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 11:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 270B5220D3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 08:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647876182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4THXk0X9P5I6GZ8Lfo//KYYd2L2RliR0JJGzYXpZx/E=;
        b=aGhD2lxY1/+DUDpqzmKoiJ2hcRgZphjeBQfyRyOdYNhX1lGP5aPzDDJw2I9bsYNPsORhen
        qw2c1veg6xZLwth9BoHQ3SteY7VbtYpML3wS0lo0fMDvXh6XLgBLELe9UrYDotl4AcZ5Ms
        5ZrV3t+RXuXltAVo/niv78rY+QOIskQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-dDiHsbMbNCyE0bDDG5nGSA-1; Mon, 21 Mar 2022 11:23:00 -0400
X-MC-Unique: dDiHsbMbNCyE0bDDG5nGSA-1
Received: by mail-qt1-f200.google.com with SMTP id b10-20020ac801ca000000b002e1cfb25db9so9534146qtg.1
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 08:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4THXk0X9P5I6GZ8Lfo//KYYd2L2RliR0JJGzYXpZx/E=;
        b=Hp9MhRwsgyosa0eXV9Sye4ZicK+WIT+vkAETPjIGubvNJi7K2bbPmaZpw2Oe1mHwOO
         mTHOyulZW/S6zSGwCU0l8g8+VkQa5yUhTeE/a4lA64qkYe3/KS7Q4Z0IEsI4ypNZuUDV
         8CppMlCNqQfvHTZ2obMHVrz9iHx9i/6lk7yAb8axeyAUOnecu6zLUZRZpMdhEMJi00rk
         ZdNddKac5uQpjAYllPw4gVrVJQ+0zvz7on1R60ZedfQKWU0qs/X+/yAh6B4QfQf5T6DR
         Dj8DHxBw2gMLdITQIp1pARH1UkUoEWwjqkhXTbFpNmGmkjX6b+uFepy6J+qqwIsB3JdB
         YMPg==
X-Gm-Message-State: AOAM532DxMFeusu6Rf8ViE584trWmA9DJhRKmu5eU0s+Drf+2Skiwp+E
        xT8/yZptZuLRIYT+LB1341aRI/f78YzWc0o0A09ioXfD4q0BPx48VVuECTw2RJayE8unOrOUyWo
        R0s538xAABbdDb/A16/lK
X-Received: by 2002:a37:9b8d:0:b0:67d:43f3:8d6 with SMTP id d135-20020a379b8d000000b0067d43f308d6mr13145150qke.541.1647876180195;
        Mon, 21 Mar 2022 08:23:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpAFQdnJv+CV+90f+pW3ZhnTbKzYK9+VQopaRAbVY/3gAVWKBd6uaUPK9sOJ6KkMiggCT09w==
X-Received: by 2002:a37:9b8d:0:b0:67d:43f3:8d6 with SMTP id d135-20020a379b8d000000b0067d43f308d6mr13145135qke.541.1647876179901;
        Mon, 21 Mar 2022 08:22:59 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id l126-20020a37bb84000000b0067b3c2bcc0dsm8102084qkf.1.2022.03.21.08.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 08:22:59 -0700 (PDT)
Date:   Mon, 21 Mar 2022 11:22:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] xfs: don't report reserved bnobt space as available
Message-ID: <YjiYUtamN6db+hFa@bfoster>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779463505.550479.1031616651852906518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779463505.550479.1031616651852906518.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a modern filesystem, we don't allow userspace to allocate blocks for
> data storage from the per-AG space reservations, the user-controlled
> reservation pool that prevents ENOSPC in the middle of internal
> operations, or the internal per-AG set-aside that prevents ENOSPC.

We can prevent -ENOSPC now? Neat! :)

> Since we now consider free space btree blocks as unavailable for
> allocation for data storage, we shouldn't report those blocks via statfs
> either.
> 

Might be worth a sentence or two that document the (intentional) side
effects of this from a user perspective. I.e., that technically the
presented free space will be a conservative estimate of actual free
space (since allocbt blocks free up as free extents are consumed, etc.).

Otherwise with that sort of commit log tweak:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |    2 +-
>  fs/xfs/xfs_super.c |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 615334e4f689..863e6389c6ff 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -347,7 +347,7 @@ xfs_fs_counts(
>  	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
>  	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
>  	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> -						mp->m_alloc_set_aside;
> +						xfs_fdblocks_unavailable(mp);
>  
>  	spin_lock(&mp->m_sb_lock);
>  	cnt->freertx = mp->m_sb.sb_frextents;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d84714e4e46a..54be9d64093e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -815,7 +815,8 @@ xfs_fs_statfs(
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	/* make sure statp->f_bfree does not underflow */
> -	statp->f_bfree = max_t(int64_t, fdblocks - mp->m_alloc_set_aside, 0);
> +	statp->f_bfree = max_t(int64_t, 0,
> +				fdblocks - xfs_fdblocks_unavailable(mp));
>  	statp->f_bavail = statp->f_bfree;
>  
>  	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> 

