Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EA2C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 420472371F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RxrCqnju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIWHxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:53:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgIWHxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600847587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z4Pc0SW1EFetSfyVj8B59FKepVEB+MWX0b+AbTXh7z8=;
        b=RxrCqnjud9PXanPy2iU+ap5k/iA+soE+0kVuCIGPAZgAa4ScA4m0OD2qmFCJIKnSc/kEGo
        TFRrYvHnVOux1tG+etNm/uhgaQJySRbtjVXOqaLdaIGK4516Xs/wo94xlXW4eJK+cdGYKE
        W1vWD3q2xRwG299GrhgQvQD6i93KIAo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-KgI3ZhuvNaeNLZPNbHiZeg-1; Wed, 23 Sep 2020 03:53:05 -0400
X-MC-Unique: KgI3ZhuvNaeNLZPNbHiZeg-1
Received: by mail-wm1-f72.google.com with SMTP id c200so1885498wmd.5
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=z4Pc0SW1EFetSfyVj8B59FKepVEB+MWX0b+AbTXh7z8=;
        b=T5OvD3xZEGsYplZWD0ZF0qFIuoTrSGGVvtpXxNgIxVBceVW1Er+UVh1kEFneIvlKlP
         4EuEn1RRW8xbIs8nJmS1nKSy0xQLP98Qm8NSzlQCDG/d7+KuQZgKYphDiNwKQ3jKc//I
         YX0YvfspvdZMujx+fzs7mcn0JwVSAziyti04zNzzKa+PgsX2Ac8/KTT64Xg3g6Opx9bV
         tR4TraO1AJVglz6XTFdQQY6838efTeoDNrRXbGJqAIzgF3ItvNgsBo9IeEtMefknmPCD
         DzXCbY3R0DDJb8+Qa7wpc/pWaodrdxkKcGMa7NQKCzGJq3/YLayQVAU8+BuBavuosYwJ
         ga6Q==
X-Gm-Message-State: AOAM530VjfOgxhGuzn1j4MOWQm3uunU06GAX/Rnd03QccoIJBXhzbK1e
        VsSyzBCf/+jDdhwgymtLIr8d7bLYRJprZiriPVt4wCMkxqmNTRI9X0Xa4zy3FWNMOVwEEdnqRml
        c4wSPh2tc34CWIVMhm10s
X-Received: by 2002:adf:e481:: with SMTP id i1mr9529113wrm.391.1600847584591;
        Wed, 23 Sep 2020 00:53:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnpXuZCdGWS0XO547uloKzUjNS+W0+njlVeITL6Tkd2s0r9XQ+9kKEA31ON2n1iW5Hb0ppww==
X-Received: by 2002:adf:e481:: with SMTP id i1mr9529092wrm.391.1600847584402;
        Wed, 23 Sep 2020 00:53:04 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id n4sm6936177wmc.48.2020.09.23.00.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 00:53:03 -0700 (PDT)
Date:   Wed, 23 Sep 2020 09:53:01 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <20200923075301.kriakz7ivnwhejje@eorzea>
Mail-Followup-To: Pavel Reichl <preichl@redhat.com>,
        linux-xfs@vger.kernel.org
References: <20200916204056.29247-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916204056.29247-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 10:40:56PM +0200, Pavel Reichl wrote:
> When a too-small device is created with stripe geometry, we hit an
> assert in align_ag_geometry():
> 
> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
> 
> This is because align_ag_geometry() finds that the size of the last
> (only) AG is too small, and attempts to trim it off.  Obviously 0
> AGs is invalid, and we hit the ASSERT.
> 

Patch looks good, next time please keep the Changelog :)
Cheers.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  include/xfs_multidisk.h | 14 +++++++-------
>  mkfs/xfs_mkfs.c         |  6 +++---
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index 1b9936ec..abfb50ce 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -14,7 +14,6 @@
>  #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
>  #define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
>  #define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
> -#define	XFS_MIN_DATA_BLOCKS	100
>  #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
>  #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
>  #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
> @@ -25,13 +24,14 @@
>  						 * accept w/o warnings
>  						 */
>  
> -#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
> -#define	XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
> -#define	XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
> -#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
> -#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
> +#define XFS_AG_BYTES(bblog)		((long long)BBSIZE << (bblog))
> +#define	XFS_MIN_DATA_BLOCKS(cfg)	(XFS_AG_MIN_BLOCKS((cfg)->blocklog))
> +#define	XFS_AG_MIN_BYTES		((XFS_AG_BYTES(15)))	/* 16 MB */
> +#define	XFS_AG_MAX_BYTES		((XFS_AG_BYTES(31)))	/* 1 TB */
> +#define XFS_AG_MIN_BLOCKS(blog)		(XFS_AG_MIN_BYTES >> (blog))
> +#define XFS_AG_MAX_BLOCKS(blog)		((XFS_AG_MAX_BYTES - 1) >> (blog))
>  
> -#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
> +#define XFS_MAX_AGNUMBER		((xfs_agnumber_t)(NULLAGNUMBER - 1))
>  
>  /*
>   * These values define what we consider a "multi-disk" filesystem. That is, a
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..204dfff1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2530,10 +2530,10 @@ _("size %s specified for data subvolume is too large, maximum is %lld blocks\n")
>  		cfg->dblocks = DTOBT(xi->dsize, cfg->blocklog);
>  	}
>  
> -	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS) {
> +	if (cfg->dblocks < XFS_MIN_DATA_BLOCKS(cfg)) {
>  		fprintf(stderr,
> -_("size %lld of data subvolume is too small, minimum %d blocks\n"),
> -			(long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS);
> +_("size %lld of data subvolume is too small, minimum %lld blocks\n"),
> +			(long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS(cfg));
>  		usage();
>  	}
>  
> -- 
> 2.26.2
> 

-- 
Carlos

