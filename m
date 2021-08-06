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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809F0C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6032260BD3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243580AbhHFHTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243578AbhHFHTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 03:19:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4142BC061799
        for <linux-xfs@vger.kernel.org>; Fri,  6 Aug 2021 00:18:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ca5so15055137pjb.5
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 00:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=N1XjWEt31ueftoDZ3GLf5r6u3z2uBwluwT2qNHHjR7A=;
        b=WT6xssIV3Y/WPcePbuLeXjiobBO1ZkeeosjScZe2RfAXEQLj3BUAqC8FqD6eeX6r6A
         vhJvbB4crC5ULHv9B//dJcwRwWa1SWyEnWfQ0yl8vkSp3qK51cVDsaQlZ/y7LO5euaqE
         ATy9+Bw7L0kcUFDtMCRMiy1lwm8Jq+xHUz/KNBU7AnfEWcGzH1w9rjGPbDECCIocH4pu
         nFvglxlH63geazNdlmOjxif9/R5g8tkGCUbvT0I+sqg0G9ZlhKVx4B91NsE06OMaFJkz
         RjoKYqMyVjquID8AixcYxO8qCyyYhNVwsezUoE6X3cODZWHql+V/EZcwqQEdmhCu5mNe
         jEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=N1XjWEt31ueftoDZ3GLf5r6u3z2uBwluwT2qNHHjR7A=;
        b=lx6IQXLor+LzQWBtCrQCEZGdcaxWpWFSL8u2eClSWJyhHPGG7FXHoEMbn3+hI3MElm
         APAMQs1A8fULGBF+h59+1os1otgJ4HY49XrsbzigtAVatB5UO/udtb+mMJ9HUUVHkTJQ
         +9h5SFzovI5np9/kN/2q9zXhvrfj9q8gJzUU4kIqglyZA1QAWTrgXWQrIROjMOm+U42c
         w/qp7Sb9S1njOi9jfriAxX2s3ZYlj0EPrZpbfWcVdFzFga0qxU89oOHm1tpWyGQrYtyF
         ITCI9vlV0Mey2AUC1G5TSYKgyAdxHNBhffP1QOM7c2kfpZjCrwVRdT8/1AokCBTdrspz
         4frA==
X-Gm-Message-State: AOAM531HAMRWnXXGKHidYKbbMTYBqWtChF9LXhE0EO3vLS0kVWZXJ2gq
        g4xDRZHc36mpeJyq3dQuzLTKUB0LVE8=
X-Google-Smtp-Source: ABdhPJzwV8t3WbaKoEdwrURwqMaDmZ3zOdT3myNHONJS2P07X5nIAbbTiFd0Stooi5zDqkpBlTfq/A==
X-Received: by 2002:a65:4103:: with SMTP id w3mr1135982pgp.95.1628234327681;
        Fri, 06 Aug 2021 00:18:47 -0700 (PDT)
Received: from garuda ([122.179.62.73])
        by smtp.gmail.com with ESMTPSA id l6sm9083066pff.74.2021.08.06.00.18.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 00:18:47 -0700 (PDT)
References: <162814684332.2777088.14593133806068529811.stgit@magnolia> <162814684894.2777088.8991564362005574305.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: fix silly whitespace problems with kernel libxfs
Date:   Fri, 06 Aug 2021 11:15:02 +0530
Message-ID: <877dgzjfde.fsf@garuda>
In-reply-to: <162814684894.2777088.8991564362005574305.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Aug 2021 at 00:00, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix a few whitespace errors such as spaces at the end of the line, etc.
> This gets us back to something more closely resembling parity.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +-
>  fs/xfs/libxfs/xfs_format.h     |    2 +-
>  fs/xfs/libxfs/xfs_ialloc.c     |    2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.h |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b910bd209949..b277e0511cdd 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -576,7 +576,7 @@ xfs_attr_shortform_bytesfit(
>  	switch (dp->i_df.if_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
>  		/*
> -		 * If there is no attr fork and the data fork is extents, 
> +		 * If there is no attr fork and the data fork is extents,
>  		 * determine if creating the default attr fork will result
>  		 * in the extents form migrating to btree. If so, the
>  		 * minimum offset only needs to be the space required for
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 76e2461b9e66..37570cf0537e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -9,7 +9,7 @@
>  /*
>   * XFS On Disk Format Definitions
>   *
> - * This header file defines all the on-disk format definitions for 
> + * This header file defines all the on-disk format definitions for
>   * general XFS objects. Directory and attribute related objects are defined in
>   * xfs_da_format.h, which log and log item formats are defined in
>   * xfs_log_format.h. Everything else goes here.
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index aaf8805a82df..19eb7ec0103f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1994,7 +1994,7 @@ xfs_difree_inobt(
>  			goto error0;
>  		}
>  
> -		/* 
> +		/*
>  		 * Change the inode free counts and log the ag/sb changes.
>  		 */
>  		be32_add_cpu(&agi->agi_freecount, 1);
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 88d8d18788a2..f2eee6572af4 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -59,4 +59,4 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
>  extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
>  		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
>  
> -#endif	/* __XFS_RMAP_BTREE_H__ */
> +#endif /* __XFS_RMAP_BTREE_H__ */


-- 
chandan
