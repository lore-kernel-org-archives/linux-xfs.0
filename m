Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753468AbeDJXqP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 19:46:15 -0400
Subject: Re: [PATCH 04/14] xfs_scrub: communicate name problems via flagset
 instead of booleans
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160360472.8288.12725342216863079202.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1b344564-4177-0980-97c5-f605ea326033@sandeen.net>
Date: Tue, 10 Apr 2018 18:46:14 -0500
MIME-Version: 1.0
In-Reply-To: <152160360472.8288.12725342216863079202.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 3/20/18 10:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use an unsigned int to pass around name error flags instead of booleans.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/unicrash.c |   43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> index 10d7c14..3538a60 100644
> --- a/scrub/unicrash.c
> +++ b/scrub/unicrash.c
> @@ -77,6 +77,14 @@ struct unicrash {
>  #define UNICRASH_SZ(nr)		(sizeof(struct unicrash) + \
>  				 (nr * sizeof(struct name_entry *)))
>  
> +/* Things to complain about in Unicode naming. */
> +
> +/*
> + * Multiple names resolve to the same normalized string and therefore render
> + * identically.
> + */
> +#define UNICRASH_NOT_UNIQUE	(1 << 0)
> +
>  /*
>   * We only care about validating utf8 collisions if the underlying
>   * system configuration says we're using utf8.  If the language
> @@ -256,7 +264,7 @@ unicrash_complain(
>  	struct unicrash		*uc,
>  	const char		*descr,
>  	const char		*what,
> -	bool			unique,
> +	unsigned int		badflags,
>  	const char		*name,
>  	uint8_t			*uniname)
>  {
> @@ -266,11 +274,20 @@ unicrash_complain(
>  	bad1 = string_escape(name);
>  	bad2 = string_escape((char *)uniname);
>  
> -	if (!unique)
> +	/*
> +	 * Two names that normalize to the same string will render
> +	 * identically even though the filesystem considers them unique
> +	 * names.  "cafe\xcc\x81" and "caf\xc3\xa9" have different byte
> +	 * sequences, but they both appear as "café".
> +	 */
> +	if (badflags & UNICRASH_NOT_UNIQUE) {
>  		str_warn(uc->ctx, descr,
> -_("Duplicate normalized Unicode name \"%s\" found in %s."),
> -				bad1, what);
> +_("Unicode name \"%s\" in %s renders identically to \"%s\"."),
> +				bad1, what, bad2);
> +		goto out;
> +	}
>  
> +out:
>  	free(bad1);
>  	free(bad2);
>  }
> @@ -291,7 +308,7 @@ unicrash_add(
>  	struct unicrash		*uc,
>  	uint8_t			*uniname,
>  	xfs_ino_t		ino,
> -	bool			*unique)
> +	unsigned int		*badflags)
>  {
>  	struct name_entry	*ne;
>  	struct name_entry	*x;
> @@ -304,8 +321,9 @@ unicrash_add(
>  	hash = unicrash_hashname(uniname, uninamelen);
>  	bucket = hash % uc->nr_buckets;
>  	for (nep = &uc->buckets[bucket], ne = *nep; ne != NULL; ne = x) {
> -		if (u8_strcmp(uniname, ne->uniname) == 0) {
> -			*unique = uc->compare_ino ? ne->ino == ino : false;
> +		if (u8_strcmp(uniname, ne->uniname) == 0 &&
> +		    (uc->compare_ino ? ino != ne->ino : true)) {
> +			*badflags |= UNICRASH_NOT_UNIQUE;
>  			return true;
>  		}
>  		nep = &ne->next;
> @@ -321,7 +339,6 @@ unicrash_add(
>  	x->uninamelen = uninamelen;
>  	memcpy(x->uniname, uniname, uninamelen + 1);
>  	*nep = x;
> -	*unique = true;
>  
>  	return true;
>  }
> @@ -336,19 +353,19 @@ __unicrash_check_name(
>  	xfs_ino_t		ino)
>  {
>  	uint8_t			uniname[(NAME_MAX * 2) + 1];
> +	unsigned int		badflags = 0;
>  	bool			moveon;
> -	bool			unique;
>  
>  	memset(uniname, 0, (NAME_MAX * 2) + 1);
>  	unicrash_normalize(name, uniname, NAME_MAX * 2);
> -	moveon = unicrash_add(uc, uniname, ino, &unique);
> +	moveon = unicrash_add(uc, uniname, ino, &badflags);
>  	if (!moveon)
>  		return false;
>  
> -	if (unique)
> -		return true;
> +	if (badflags)
> +		unicrash_complain(uc, descr, namedescr, badflags, name,
> +				uniname);
>  
> -	unicrash_complain(uc, descr, namedescr, unique, name, uniname);
>  	return true;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
