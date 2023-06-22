Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C17EEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 11:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjFVLqF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjFVLqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 07:46:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38B0D3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 04:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AF860905
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 11:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F00EC433C8;
        Thu, 22 Jun 2023 11:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687434362;
        bh=0/0aMYH+IhnfLX9DoTkTS8L1eujRciO2WO1EYcPlrmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SA0KwLZnRoZ1ws36atp3LvRAP4S/0nT+uBX8hUByCoaGINaufIiy9wu+9RiuLBYiK
         FIAu+psS/XydtAZTMcMAhUI2LaYA3WKDY9NN4iuqMXye80HPHGitI+41bspGB3ks4a
         +a9+HgEEblTN9gu65eQw1NGa7H/FWlqjB3m/jQCNgILwY8pVQVJvOVy3IItZ+Ele6b
         2VvTChfDW4VT2C4PIaq+gpPip3evYGg5EdJWt/iYpOzZ1ewUwxYXgD9qJPPhCrx8pI
         73WpKpLDJR/UC9t4Ylgt8v6ER02pSnBvHglHQSTJcp8WnAcmpHfhzVcs8kULuxyyLU
         KfaP5MQ/6DI8Q==
Date:   Thu, 22 Jun 2023 13:45:58 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH v2 3/5] xfs_db: fix metadump name obfuscation for
 ascii-ci filesystems
Message-ID: <20230622114558.gcpczbdcdhb5h6yu@andromeda>
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
 <168597940416.1226098.14610650380180437820.stgit@frogsfrogsfrogs>
 <QC3hxVYr7-4z00FDKMApZIGYoHxcG52ZNcZf38RCjyhNn9qe2Q5I7Bha_eThxX3VdtRktdEp5UphNWLW7FN7GA==@protonmail.internalid>
 <20230615161104.GP11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615161104.GP11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 09:11:04AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've stabilized the dirent hash function for ascii-ci
> filesystems, adapt the metadump name obfuscation code to detect when
> it's obfuscating a directory entry name on an ascii-ci filesystem and
> spit out names that actually have the same hash.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: s/alloca/malloc/
> ---
>  db/metadump.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 73 insertions(+), 9 deletions(-)

Thanks for fixing it!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 317ff72802d..9ccee0b7ace 100644
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
> @@ -836,6 +840,26 @@ obfuscate_name(
>  	if (name_len < 5)
>  		return;
> 
> +	if (is_ci_name) {
> +		oldname = malloc(name_len);
> +		if (!oldname)
> +			return;
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
> +		goto out_free;
> +	}
> +
>  	/*
>  	 * The beginning of the obfuscated name can be pretty much
>  	 * anything, so fill it in with random characters.
> @@ -843,7 +867,11 @@ obfuscate_name(
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
> @@ -867,6 +895,17 @@ obfuscate_name(
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
> @@ -880,8 +919,15 @@ obfuscate_name(
>  	 */
>  	if (high_bit) {
>  		*first ^= 0x10;
> +
> +		if (is_ci_name && xfs_ascii_ci_need_xfrm(*first))
> +			goto again;
> +
>  		ASSERT(!is_invalid_char(*first));
>  	}
> +
> +out_free:
> +	free(oldname);
>  }
> 
>  /*
> @@ -1177,6 +1223,24 @@ handle_duplicate_name(xfs_dahash_t hash, size_t name_len, unsigned char *name)
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
> @@ -1205,9 +1269,9 @@ generate_obfuscated_name(
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
> @@ -1320,7 +1384,7 @@ obfuscate_path_components(
>  			/* last (or single) component */
>  			namelen = strnlen((char *)comp, len);
>  			hash = libxfs_da_hashname(comp, namelen);
> -			obfuscate_name(hash, namelen, comp);
> +			obfuscate_name(hash, namelen, comp, false);
>  			ASSERT(hash == libxfs_da_hashname(comp, namelen));
>  			break;
>  		}
> @@ -1332,7 +1396,7 @@ obfuscate_path_components(
>  			continue;
>  		}
>  		hash = libxfs_da_hashname(comp, namelen);
> -		obfuscate_name(hash, namelen, comp);
> +		obfuscate_name(hash, namelen, comp, false);
>  		ASSERT(hash == libxfs_da_hashname(comp, namelen));
>  		comp += namelen + 1;
>  		len -= namelen + 1;
