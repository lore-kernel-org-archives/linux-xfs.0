Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B26C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F9E61985
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhC3Sqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhC3SqK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F3A61924;
        Tue, 30 Mar 2021 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617129969;
        bh=dX6AouI3FPRUGXpDiEuFSgCNeHQdFrwYrTsY0m0+IYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujYjYMMpM0r6TcMOLd2kW5jZCisBm3Yl7lb5RGiLahkYeWEDb69m6Soku7M7mWkJR
         GA4Q4b7p7MJWTXipjIjpCtq0dzMM/OMKqrRiXmqRd92BVi0Y238YytSFPFNW93ymct
         0voctoCL30pjz4pyh7ZEoDXscHXroQk3rRU8AYe9IBdO+jD7miFRoej7TduBUNP8GU
         0pIqel+IBK8i4YpbeaLJmoVrjndX19+QkeSEPJ8pARGkqQyij8FqyEDMCaFwAxGz43
         3lqH7H75fxqsk/n8xpOl+OK/ZajH72RD649X/bbmmYqD/ynm2gOOq+n55BnKTyrYAu
         0psEfQVzo77jw==
Date:   Tue, 30 Mar 2021 11:46:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v3 1/8] repair: turn bad inode list into array
Message-ID: <20210330184608.GY4090233@magnolia>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-2-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330142531.19809-2-hsiangkao@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:25:24PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Just use array and reallocate one-by-one here (not sure if bulk
> allocation is more effective or not.)

I'm not sure either.  The list of bad directories is likely to be
sparse, so perhaps the libfrog bitmap isn't going to beat a realloc
array for space efficiency... and reusing the slab array might be
overkill for an array-backed bitmap?

Eh, you know what?  I don't think the bad directory bitmap is hot enough
to justify broadening this into an algorithmic review of data
structures.  Incremental space efficiency is good enough for me.

> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  repair/dir2.c | 34 +++++++++++++++++-----------------
>  repair/dir2.h |  2 +-
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index eabdb4f2d497..b6a8a5c40ae4 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -20,40 +20,40 @@
>   * Known bad inode list.  These are seen when the leaf and node
>   * block linkages are incorrect.
>   */
> -typedef struct dir2_bad {
> -	xfs_ino_t	ino;
> -	struct dir2_bad	*next;
> -} dir2_bad_t;
> +struct dir2_bad {
> +	unsigned int	nr;

We could have more than 4 billion bad directories.

> +	xfs_ino_t	*itab;
> +};
>  
> -static dir2_bad_t *dir2_bad_list;
> +static struct dir2_bad	dir2_bad;
>  
>  static void
>  dir2_add_badlist(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	xfs_ino_t	*itab;
>  
> -	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
> +	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));

Minor quibble: you could improve the efficiency of this by tracking both
the array size and fill count so that you only have to expand the array
by powers of two at a time.  The glibc heap is faster than it once was,
but you could help it along by only asking for memory in MMAP_THRESHOLD
chunks.  Or possibly even pagesize chunks.

--D

> +	if (!itab) {
>  		do_error(
>  _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> -			sizeof(dir2_bad_t), ino);
> +			sizeof(xfs_ino_t), ino);
>  		exit(1);
>  	}
> -	l->next = dir2_bad_list;
> -	dir2_bad_list = l;
> -	l->ino = ino;
> +	itab[dir2_bad.nr++] = ino;
> +	dir2_bad.itab = itab;
>  }
>  
> -int
> +bool
>  dir2_is_badino(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	unsigned int i;
>  
> -	for (l = dir2_bad_list; l; l = l->next)
> -		if (l->ino == ino)
> -			return 1;
> -	return 0;
> +	for (i = 0; i < dir2_bad.nr; ++i)
> +		if (dir2_bad.itab[i] == ino)
> +			return true;
> +	return false;
>  }
>  
>  /*
> diff --git a/repair/dir2.h b/repair/dir2.h
> index 5795aac5eaab..af4cfb1da329 100644
> --- a/repair/dir2.h
> +++ b/repair/dir2.h
> @@ -27,7 +27,7 @@ process_sf_dir2_fixi8(
>  	struct xfs_dir2_sf_hdr	*sfp,
>  	xfs_dir2_sf_entry_t	**next_sfep);
>  
> -int
> +bool
>  dir2_is_badino(
>  	xfs_ino_t	ino);
>  
> -- 
> 2.20.1
> 
