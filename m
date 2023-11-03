Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2CBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Nov 2023 20:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjKCUiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKCUiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 16:38:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648E8A2
        for <linux-xfs@vger.kernel.org>; Fri,  3 Nov 2023 13:38:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D50C433C8;
        Fri,  3 Nov 2023 20:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699043895;
        bh=w9Rgm7oRi/eGCRawfiJmmWmroQDvWmBGRNFHQb2zVA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mIdaH8w0dFSuxQoogU42FPPRX6KDhrC7HUMw341zaGH8BYo8s0APbOZW5nnEbRCbI
         ClKB5F+pyF2f9hif2AzoV6fvGUAJ8fBJLnP/+1wfFjFi/nZHIZekCpefs/MlEVhatN
         O5JlvwFE6vywzAKIfEHU1ksNCIaibu/zA33qie82fwd7lDG87dxNv8iU1sj9K1zz4N
         CBatcm/ZJ/EyI4Zs7CJ0uemfaMzbuXPxjtXOxaPJXh6mXNiBml2yU2e4LCgbnNnwFm
         WKuGxhmsQQ4tyzXGF9BTTj7JmNioRewMJC0C+2/uCsAuCZ3ct0Hu6cKjq2MoqEHpb+
         7UB30qU00jpww==
Date:   Fri, 3 Nov 2023 13:38:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] db: fix unsigned char related warnings
Message-ID: <20231103203813.GG1205143@frogsfrogsfrogs>
References: <20231103160210.548636-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103160210.548636-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2023 at 05:02:10PM +0100, Christoph Hellwig wrote:
> Clean up the code in hash.c to use the normal char type for all
> high-level code, only casting to uint8_t when calling into low-level
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The problem is deeper than just this, but we gotta start somewhere...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/hash.c | 45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/db/hash.c b/db/hash.c
> index 716da88ba..05a94f249 100644
> --- a/db/hash.c
> +++ b/db/hash.c
> @@ -65,16 +65,15 @@ hash_f(
>  	}
>  
>  	for (c = optind; c < argc; c++) {
> -		if (use_dir2_hash) {
> -			struct xfs_name	xname = {
> -				.name	= (uint8_t *)argv[c],
> -				.len	= strlen(argv[c]),
> -			};
> +		struct xfs_name	xname = {
> +			.name	= (uint8_t *)argv[c],
> +			.len	= strlen(argv[c]),
> +		};
>  
> +		if (use_dir2_hash)
>  			hashval = libxfs_dir2_hashname(mp, &xname);
> -		} else {
> -			hashval = libxfs_da_hashname(argv[c], strlen(argv[c]));
> -		}
> +		else
> +			hashval = libxfs_da_hashname(xname.name, xname.len);
>  		dbprintf("0x%x\n", hashval);
>  	}
>  
> @@ -103,7 +102,7 @@ struct name_dup {
>  	struct name_dup	*next;
>  	uint32_t	crc;
>  	uint8_t		namelen;
> -	uint8_t		name[];
> +	char		name[];
>  };
>  
>  static inline size_t
> @@ -175,7 +174,7 @@ dup_table_free(
>  static struct name_dup *
>  dup_table_find(
>  	struct dup_table	*tab,
> -	unsigned char		*name,
> +	char			*name,
>  	size_t			namelen)
>  {
>  	struct name_dup		*ent;
> @@ -197,7 +196,7 @@ dup_table_find(
>  static int
>  dup_table_store(
>  	struct dup_table	*tab,
> -	unsigned char		*name,
> +	char			*name,
>  	size_t			namelen)
>  {
>  	struct name_dup		*dup;
> @@ -209,7 +208,7 @@ dup_table_store(
>  		int		ret;
>  
>  		do {
> -			ret = find_alternate(namelen, name, seq++);
> +			ret = find_alternate(namelen, (uint8_t *)name, seq++);
>  		} while (ret == 0);
>  		if (ret < 0)
>  			return EEXIST;
> @@ -231,15 +230,15 @@ dup_table_store(
>  static int
>  collide_dirents(
>  	unsigned long		nr,
> -	const unsigned char	*name,
> +	char			*name,
>  	size_t			namelen,
>  	int			fd)
>  {
>  	struct xfs_name		dname = {
> -		.name		= name,
> +		.name		= (uint8_t *)name,
>  		.len		= namelen,
>  	};
> -	unsigned char		direntname[MAXNAMELEN + 1];
> +	char			direntname[MAXNAMELEN + 1];
>  	struct dup_table	*tab = NULL;
>  	xfs_dahash_t		old_hash;
>  	unsigned long		i;
> @@ -268,10 +267,10 @@ collide_dirents(
>  			return error;
>  	}
>  
> -	dname.name = direntname;
> +	dname.name = (uint8_t *)direntname;
>  	for (i = 0; i < nr; i++) {
>  		strncpy(direntname, name, MAXNAMELEN);
> -		obfuscate_name(old_hash, namelen, direntname, true);
> +		obfuscate_name(old_hash, namelen, (uint8_t *)direntname, true);
>  		ASSERT(old_hash == libxfs_dir2_hashname(mp, &dname));
>  
>  		if (fd >= 0) {
> @@ -297,17 +296,17 @@ collide_dirents(
>  static int
>  collide_xattrs(
>  	unsigned long		nr,
> -	const unsigned char	*name,
> +	char			*name,
>  	size_t			namelen,
>  	int			fd)
>  {
> -	unsigned char		xattrname[MAXNAMELEN + 5];
> +	char			xattrname[MAXNAMELEN + 5];
>  	struct dup_table	*tab = NULL;
>  	xfs_dahash_t		old_hash;
>  	unsigned long		i;
>  	int			error;
>  
> -	old_hash = libxfs_da_hashname(name, namelen);
> +	old_hash = libxfs_da_hashname((uint8_t *)name, namelen);
>  
>  	if (fd >= 0) {
>  		/*
> @@ -330,8 +329,10 @@ collide_xattrs(
>  
>  	for (i = 0; i < nr; i++) {
>  		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
> -		obfuscate_name(old_hash, namelen, xattrname + 5, false);
> -		ASSERT(old_hash == libxfs_da_hashname(xattrname + 5, namelen));
> +		obfuscate_name(old_hash, namelen, (uint8_t *)xattrname + 5,
> +				false);
> +		ASSERT(old_hash == libxfs_da_hashname((uint8_t *)xattrname + 5,
> +				namelen));
>  
>  		if (fd >= 0) {
>  			error = fsetxattr(fd, xattrname, "1", 1, 0);
> -- 
> 2.39.2
> 
