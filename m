Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA78C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbiCRMTC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiCRMTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C933F210B
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647605861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aoILHcjKWfk2N3rTcuZlVKnU6GFXPk+OXuhDe7JyqFQ=;
        b=MxUYkwpM99FK+uAGoPvlSur/PKpWna5u8hvzDZgBhJTfIUma6K9qOSz3uuLT6A41BiWIyL
        EnsiVtriXIzVGREoTunq+XL5dAjKlp1RedRB28fiuaSpoomupy+obzalEn/JjsFQeayz37
        eFhdiv49R7OKeIS17hQVdIY60qhRNJ4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-TJY3fv_4MiG_2p3CR3nkFA-1; Fri, 18 Mar 2022 08:17:40 -0400
X-MC-Unique: TJY3fv_4MiG_2p3CR3nkFA-1
Received: by mail-qk1-f197.google.com with SMTP id h68-20020a376c47000000b0067e05dade89so5246834qkc.2
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aoILHcjKWfk2N3rTcuZlVKnU6GFXPk+OXuhDe7JyqFQ=;
        b=XkuyZSAmcc7y7SyX/sQ3fcH5RNYleEUDSUfU4sg3gi9zN+BOLpFesXw6LveEWJ3oYV
         GcjZPmyVFI2jzefFFdGQyxf3WnL2E3LanYnGf/MxZRhmbHaPpCKy4IVNX7arWt0jsEDx
         JpYyGEoc5mQoM4BMdWIw0ilW2aUWlV4mZjzX6G+glGSRH7XlTPTNv5PvGRBvxvQyMB9o
         Obqy4M6SWNJafjU3NSwo16Lds3FovCcyz+cC6GqpdVnNcE1G7sonNBFSWaTg4Z6Rlw8Y
         lShrAUlX28lCkyUePsgbUcqJp2ZJyEoNMBbD5OPrgRmXzk9aEpG9FCejrAR1yMxwpMCu
         R2mA==
X-Gm-Message-State: AOAM531JYOhwo149TDzYoUs9A5xQf+sN23NyLQz78IRNvAzZrPicuyz+
        lO2ko5q4ykNTK3OI0dEppTCciFzzpEgBkgluJkSUiXmTSPeZOXawzJ5FHpxpbO7Kd7NIN6Ujoz7
        7isZDGc90oHRhFwdS3vYv
X-Received: by 2002:ac8:5906:0:b0:2e1:a2fb:f73e with SMTP id 6-20020ac85906000000b002e1a2fbf73emr7223104qty.129.1647605859186;
        Fri, 18 Mar 2022 05:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTwcNi/5axvwi5ez2GFZQ0iJnPIhp18b4ObGJ8lZ/c0LoLVkiKPK4H04DY68OCD52OTUx1ow==
X-Received: by 2002:ac8:5906:0:b0:2e1:a2fb:f73e with SMTP id 6-20020ac85906000000b002e1a2fbf73emr7223084qty.129.1647605858899;
        Fri, 18 Mar 2022 05:17:38 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id o3-20020a05622a008300b002e06a103476sm5694429qtw.55.2022.03.18.05.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:17:38 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:17:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/6] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
Message-ID: <YjR4YCEznqWstkG8@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755206098.4194202.17244831596965430593.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755206098.4194202.17244831596965430593.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, we use this undocumented macro to encode the minimum number
> of blocks needed to replenish a completely empty AGFL when an AG is
> nearly full.  This has lead to confusion on the part of the maintainers,
> so let's document what the value actually means, and move it to
> xfs_alloc.c since it's not used outside of that module.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |   23 ++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_alloc.h |    1 -
>  2 files changed, 18 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 353e53b892e6..b0678e96ce61 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -82,6 +82,19 @@ xfs_prealloc_blocks(
>  }
>  
>  /*
> + * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
> + * guarantee that we can refill the AGFL prior to allocating space in a nearly
> + * full AG.  We require two blocks per free space btree because free space
> + * btrees shrink to a single block as the AG fills up, and any allocation can
> + * cause a btree split.  The rmap btree uses a per-AG reservation to withhold
> + * space from xfs_mod_fdblocks, so we do not account for that here.
> + */
> +#define XFS_ALLOCBT_AGFL_RESERVE	4
> +
> +/*
> + * Compute the number of blocks that we set aside to guarantee the ability to
> + * refill the AGFL and handle a full bmap btree split.
> + *
>   * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
>   * AGF buffer (PV 947395), we place constraints on the relationship among
>   * actual allocations for data blocks, freelist blocks, and potential file data
> @@ -93,14 +106,14 @@ xfs_prealloc_blocks(
>   * extents need to be actually allocated. To get around this, we explicitly set
>   * aside a few blocks which will not be reserved in delayed allocation.
>   *
> - * We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to handle a
> - * potential split of the file's bmap btree.
> + * For each AG, we need to reserve enough blocks to replenish a totally empty
> + * AGFL and 4 more to handle a potential split of the file's bmap btree.
>   */
>  unsigned int
>  xfs_alloc_set_aside(
>  	struct xfs_mount	*mp)
>  {
> -	return mp->m_sb.sb_agcount * (XFS_ALLOC_AGFL_RESERVE + 4);
> +	return mp->m_sb.sb_agcount * (XFS_ALLOCBT_AGFL_RESERVE + 4);
>  }
>  
>  /*
> @@ -124,12 +137,12 @@ xfs_alloc_ag_max_usable(
>  	unsigned int		blocks;
>  
>  	blocks = XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)); /* ag headers */
> -	blocks += XFS_ALLOC_AGFL_RESERVE;
> +	blocks += XFS_ALLOCBT_AGFL_RESERVE;
>  	blocks += 3;			/* AGF, AGI btree root blocks */
>  	if (xfs_has_finobt(mp))
>  		blocks++;		/* finobt root block */
>  	if (xfs_has_rmapbt(mp))
> -		blocks++; 		/* rmap root block */
> +		blocks++;		/* rmap root block */
>  	if (xfs_has_reflink(mp))
>  		blocks++;		/* refcount root block */
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 1c14a0b1abea..d4c057b764f9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -88,7 +88,6 @@ typedef struct xfs_alloc_arg {
>  #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
>  
>  /* freespace limit calculations */
> -#define XFS_ALLOC_AGFL_RESERVE	4
>  unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
>  unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
>  
> 

