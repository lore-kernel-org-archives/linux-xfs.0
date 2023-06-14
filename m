Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232B1EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jun 2023 11:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbjFNLKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbjFNLKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 07:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A753ADF
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 04:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32B2C62820
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 11:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790BAC433CA;
        Wed, 14 Jun 2023 11:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686741008;
        bh=LEULcDUB5PUStN8RXClGxXvwP+VaG1zhzwh51mYZ3ME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgcQmyc1squMuSPWtIZ+KoulVG52BbgAqAPluwrTZQM8nTAVTm2zw4JgRwrediMck
         XL3sfjcZkRNBJvjSiZla9nYYqEJjJWQ09Wz2RbMvR7F2wGnIlZM2+ueRsJ06+5nEtL
         qgasiJYdcitx1EIVAXjWMXpZsphIbK0rAXWnuXVhn/BMbZq/+F4cX5ZA5/9aewfyLc
         guY74TrHKj3Bu1wzLou/9fBKNpHuf5Fr41yj1T6/1Vphl5HT7OCbsWj3DJeHQISI7q
         FwRviJmpOBsX4jMq2ptka/hzke21lBBn0kKlK8iQpkT88OqOUO7gDgc1BewBlScjb+
         z1hPIo3ceaLdw==
Date:   Wed, 14 Jun 2023 13:10:04 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <20230614111004.4g22b3niuwma6d4l@andromeda>
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <fxgEi89EJu9vB1-1hI3jTLfGoFixvgK3AezC99fR6jNL67jTEO-wHMnGYkaHKh-W2Z6VDiRUwx1pz5q_9shHNw==@protonmail.internalid>
 <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:36:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've stabilized the dirent hash function for ascii-ci
> filesystems, adapt the metadump name obfuscation code to detect when
> it's obfuscating a directory entry name on an ascii-ci filesystem and
> spit out names that actually have the same hash.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/metadump.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 68 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 317ff72802d..4f8b3adb163 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -817,13 +817,17 @@ static void
>  obfuscate_name(
>  	xfs_dahash_t	hash,
>  	size_t		name_len,
> -	unsigned char	*name)
> +	unsigned char	*name,
> +	bool		is_dirent)
>  {
> -	unsigned char	*newp = name;
> +	unsigned char	*oldname = NULL;
> +	unsigned char	*newp;
>  	int		i;
> -	xfs_dahash_t	new_hash = 0;
> +	xfs_dahash_t	new_hash;
>  	unsigned char	*first;
>  	unsigned char	high_bit;
> +	int		tries = 0;
> +	bool		is_ci_name = is_dirent && xfs_has_asciici(mp);
>  	int		shift;
> 
>  	/*
> @@ -836,6 +840,24 @@ obfuscate_name(
>  	if (name_len < 5)
>  		return;
> 
> +	if (is_ci_name) {
> +		oldname = alloca(name_len);

			  ^^^ This is triggering a warning on build time because
			      the alloca() call is unbounded:

metadump.c: In function ‘obfuscate_name’:
metadump.c:844:13: warning: argument to ‘alloca’ may be too large
[-Walloca-larger-than=]
  844 |   oldname = alloca(name_len);
      |             ^~~~~~

Maybe just use malloc() here, instead of using stack space? We probably can use
MAXNAMELEN here to bound it, something like:

if (is_ci_name && name_len <= MAXNAMELEN) {
	oldname = alloca(name_len);
	memcpy(oldname, name, name_len);
} else {
	return;
}

-- 
Carlos
> +		memcpy(oldname, name, name_len);
> +	}
> +
> +again:
> +	newp = name;
> +	new_hash = 0;
> +
> +	/*
> +	 * If we cannot generate a ci-compatible obfuscated name after 1000
> +	 * tries, don't bother obfuscating the name.
> +	 */
> +	if (tries++ > 1000) {
> +		memcpy(name, oldname, name_len);
> +		return;
> +	}
> +
>  	/*
>  	 * The beginning of the obfuscated name can be pretty much
>  	 * anything, so fill it in with random characters.
> @@ -843,7 +865,11 @@ obfuscate_name(
>  	 */
>  	for (i = 0; i < name_len - 5; i++) {
>  		*newp = random_filename_char();
> -		new_hash = *newp ^ rol32(new_hash, 7);
> +		if (is_ci_name)
> +			new_hash = xfs_ascii_ci_xfrm(*newp) ^
> +							rol32(new_hash, 7);
> +		else
> +			new_hash = *newp ^ rol32(new_hash, 7);
>  		newp++;
>  	}
> 
> @@ -867,6 +893,17 @@ obfuscate_name(
>  			high_bit = 0x80;
>  		} else
>  			high_bit = 0;
> +
> +		/*
> +		 * If ascii-ci is enabled, uppercase characters are converted
> +		 * to lowercase characters while computing the name hash.  If
> +		 * any of the necessary correction bytes are uppercase, the
> +		 * hash of the new name will not match.  Try again with a
> +		 * different prefix.
> +		 */
> +		if (is_ci_name && xfs_ascii_ci_need_xfrm(*newp))
> +			goto again;
> +
>  		ASSERT(!is_invalid_char(*newp));
>  		newp++;
>  	}
> @@ -880,6 +917,10 @@ obfuscate_name(
>  	 */
>  	if (high_bit) {
>  		*first ^= 0x10;
> +
> +		if (is_ci_name && xfs_ascii_ci_need_xfrm(*first))
> +			goto again;
> +
>  		ASSERT(!is_invalid_char(*first));
>  	}
>  }
> @@ -1177,6 +1218,24 @@ handle_duplicate_name(xfs_dahash_t hash, size_t name_len, unsigned char *name)
>  	return 1;
>  }
> 
> +static inline xfs_dahash_t
> +dirattr_hashname(
> +	bool		is_dirent,
> +	const uint8_t	*name,
> +	int		namelen)
> +{
> +	if (is_dirent) {
> +		struct xfs_name	xname = {
> +			.name	= name,
> +			.len	= namelen,
> +		};
> +
> +		return libxfs_dir2_hashname(mp, &xname);
> +	}
> +
> +	return libxfs_da_hashname(name, namelen);
> +}
> +
>  static void
>  generate_obfuscated_name(
>  	xfs_ino_t		ino,
> @@ -1205,9 +1264,9 @@ generate_obfuscated_name(
> 
>  	/* Obfuscate the name (if possible) */
> 
> -	hash = libxfs_da_hashname(name, namelen);
> -	obfuscate_name(hash, namelen, name);
> -	ASSERT(hash == libxfs_da_hashname(name, namelen));
> +	hash = dirattr_hashname(ino != 0, name, namelen);
> +	obfuscate_name(hash, namelen, name, ino != 0);
> +	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
> 
>  	/*
>  	 * Make sure the name is not something already seen.  If we
> @@ -1320,7 +1379,7 @@ obfuscate_path_components(
>  			/* last (or single) component */
>  			namelen = strnlen((char *)comp, len);
>  			hash = libxfs_da_hashname(comp, namelen);
> -			obfuscate_name(hash, namelen, comp);
> +			obfuscate_name(hash, namelen, comp, false);
>  			ASSERT(hash == libxfs_da_hashname(comp, namelen));
>  			break;
>  		}
> @@ -1332,7 +1391,7 @@ obfuscate_path_components(
>  			continue;
>  		}
>  		hash = libxfs_da_hashname(comp, namelen);
> -		obfuscate_name(hash, namelen, comp);
> +		obfuscate_name(hash, namelen, comp, false);
>  		ASSERT(hash == libxfs_da_hashname(comp, namelen));
>  		comp += namelen + 1;
>  		len -= namelen + 1;
> 
