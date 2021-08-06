Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3401C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 11:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C8F60560
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 11:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhHFLmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240746AbhHFLmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 07:42:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2CBC061798
        for <linux-xfs@vger.kernel.org>; Fri,  6 Aug 2021 04:42:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so12182939pjz.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 04:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=v3+Cf0j01SlYM3CEZGq5s0iHR7+ITn8+pXox87z+vDk=;
        b=ewRFEmWVGQJs0PpNY4pBEsIAgBYAP7ELVcdHEScKZ7E46lcTT4XOWgsg7eMx2XgxgA
         Bwf98wT8Z1h231NW64Priu90Dg0DMKlwDzB/VretZw/1eqtru8ZHjqSguJw6cfwiIvIL
         p24FNtxvu6YD0z7ZetL+Djh0zlJ4K6MVYcjQqvo5fvq8jN0PbLY9l6yVIy3jy+xhi++5
         STbo0LqBg3BwAdY8c8GNKoFZZUrLr7GqIdaQ3YIPljA/vZ6xwnhCmkiUunhV41KVMIrV
         Rm9ASVjcWIzjV/JaxyD/U8h0crB4JGXPHq7S2kGzjqJuG7ThJLIyu1xxC2baxXbPaT1D
         5LWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=v3+Cf0j01SlYM3CEZGq5s0iHR7+ITn8+pXox87z+vDk=;
        b=NfYkfxZKtHRZqCTqG76aFp5Odwv9gLOp1GfsSeznPI/rixiHc+8znyKTef5kfsZ3os
         4Us6A5NrUgPa5mH0PTPUtTvlsKP2KuZgNxSNPm2kR4lsGY/XbCLayvCChxpQaX5N4r46
         dD3MpF6PGC7uAwmHvDcr9xIeE1fIxMRPYGzNbiJdJX7H1QVRIv/WtO7sbdDm8E+vIxZY
         study2nrpkQ+pQgwaszKv/jcvCNhQAgO5wTEUCHvXVj+dpkc1G2Lyuabz3LiIje656Ib
         xq9OJF8FS3y0mV54B3sUKiYiMe/KeYERRPPFWKl8zpjVVdxx5i6q8VqQbzehkdmxVSYY
         blxQ==
X-Gm-Message-State: AOAM530fkjwsTWz6qxLaoEKaHf4IpfvQGfCUiPI+0E9RP2srMVKEZIqe
        0nwE8YOKpHR6HEwaxhG1KcpRTiLPviA=
X-Google-Smtp-Source: ABdhPJw4jdVg8JdWQabpq7ztgCjb9EcpUad1dYSsuDrUQp2QOe7giOVjXu5JKtfDi2d0xCLpkKs+RA==
X-Received: by 2002:a63:5506:: with SMTP id j6mr1473891pgb.19.1628250122135;
        Fri, 06 Aug 2021 04:42:02 -0700 (PDT)
Received: from garuda ([122.179.62.73])
        by smtp.gmail.com with ESMTPSA id u16sm11894965pgh.53.2021.08.06.04.42.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 04:42:01 -0700 (PDT)
References: <162814684332.2777088.14593133806068529811.stgit@magnolia> <162814687097.2777088.3937845877884086271.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: dump log intent items that cannot be recovered due to corruption
Date:   Fri, 06 Aug 2021 17:11:46 +0530
In-reply-to: <162814687097.2777088.3937845877884086271.stgit@magnolia>
Message-ID: <87v94iiyuw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Aug 2021 at 00:01, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> If we try to recover a log intent item and the operation fails due to
> filesystem corruption, dump the contents of the item to the log for
> further analysis.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_item.c     |    3 +++
>  fs/xfs/xfs_extfree_item.c  |    3 +++
>  fs/xfs/xfs_refcount_item.c |    3 +++
>  fs/xfs/xfs_rmap_item.c     |    3 +++
>  4 files changed, 12 insertions(+)
>
>
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e3a691937e92..3d6f70da8820 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -522,6 +522,9 @@ xfs_bui_item_recover(
>  	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
>  			whichfork, bmap->me_startoff, bmap->me_startblock,
>  			&count, state);
> +	if (error == -EFSCORRUPTED)
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bmap,
> +				sizeof(*bmap));
>  	if (error)
>  		goto err_cancel;
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 2424230ca2c3..3f8a0713573a 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -629,6 +629,9 @@ xfs_efi_item_recover(
>  		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
>  					      extp->ext_len,
>  					      &XFS_RMAP_OINFO_ANY_OWNER, false);
> +		if (error == -EFSCORRUPTED)
> +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> +					extp, sizeof(*extp));
>  		if (error)
>  			goto abort_error;
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 746f4eda724c..163615285b18 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -522,6 +522,9 @@ xfs_cui_item_recover(
>  			error = xfs_trans_log_finish_refcount_update(tp, cudp,
>  				type, refc->pe_startblock, refc->pe_len,
>  				&new_fsb, &new_len, &rcur);
> +		if (error == -EFSCORRUPTED)
> +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> +					refc, sizeof(*refc));
>  		if (error)
>  			goto abort_error;
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index dc4f0c9f0897..9b91a788722a 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -578,6 +578,9 @@ xfs_rui_item_recover(
>  				rmap->me_owner, whichfork,
>  				rmap->me_startoff, rmap->me_startblock,
>  				rmap->me_len, state, &rcur);
> +		if (error == -EFSCORRUPTED)
> +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> +					rmap, sizeof(*rmap));
>  		if (error)
>  			goto abort_error;
>  


-- 
chandan
