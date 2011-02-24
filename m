Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1O29w4D099224 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 20:09:58 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AE7B12E1A38
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 18:12:41 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NiEs98FtHD7z0PfC for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 18:12:41 -0800 (PST)
Date: Thu, 24 Feb 2011 13:12:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 13/16] xfsprogs: metadump: move duplicate name
	handling into its own function
Message-ID: <20110224021239.GA3166@dastard>
References: <201102182121.p1ILL2pI029171@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102182121.p1ILL2pI029171@stout.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> Move the handling of duplicate names into its own function.  As a
> result, all names other than "lost+found" files (not just those that
> get obfuscated) will be checked to avoid duplication.
> 
> This makes the local buffer newname[] in generate_obfuscated_name()
> unnecessary, so just drop it and use the passed-in name.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> This is a new change, not posted with this series previously.

Couple of minor comments below.

> 
> ---
>  db/metadump.c |   95 +++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 49 insertions(+), 46 deletions(-)
> 
> Index: b/db/metadump.c
> ===================================================================
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -469,6 +469,37 @@ in_lost_found(
>  }
>  
>  /*
> + * Look up the given name in the name table.  If it is already
> + * present, find an alternate and attempt to use that name instead.
> + *
> + * Returns 1 if the (possibly modified) name is not present in the
> + * name table.  Returns 0 otherwise.
> + */
> +static int
> +handle_duplicates(xfs_dahash_t hash, size_t name_len, uchar_t *name)

handle_duplicate_name()?

> +{
> +	int	dup = 0;
> +
> +	if (!nametable_find(hash, name_len, name))
> +	    	return 1;	/* Not already in table */
> +
> +	/* Name is already in use.  Need to find an alternate. */
> +
> +	do {
> +		obfuscate_name(hash, name_len, name);
> +
> +		/*
> +		 * Search the name table to be sure we don't produce
> +		 * a name that's already been used.
> +		 */
> +		if (!nametable_find(hash, name_len, name))
> +			break;
> +	} while (++dup < DUP_MAX);
> +
> +	return dup < DUP_MAX ? 1 : 0;
> +}
> +
> +/*
>   * Given a name and its hash value, massage the name in such a way
>   * that the result is another name of equal length which shares the
>   * same hash value.
> @@ -549,9 +580,6 @@ generate_obfuscated_name(
>  	uchar_t			*name)
>  {
>  	xfs_dahash_t		hash;
> -	int			dup = 0;
> -	uchar_t			newname[NAME_MAX];
> -	uchar_t			*newp;
>  
>  	/*
>  	 * We don't obfuscate "lost+found" or any orphan files
> @@ -562,58 +590,33 @@ generate_obfuscated_name(
>  	if (ino && in_lost_found(ino, namelen, name))
>  		return;
>  
> -	/*
> -	 * If the name starts with a slash, just skip over it.  We
> -	 * will copy our obfuscated name back into space following
> -	 * the slash when we're done.  Our new name will not have
> -	 * the '/', and that's the version we'll keep in our
> -	 * duplicates table.  Note that the namelen value passed in
> -	 * does not include the leading slash (if any).
> -	 */
>  	if (*name == '/')
> -	    	name++;
> +	    	name++;		/* Skip over leading slash (if any). */

I think the comment explaining _why_ we are skipping over the slash
is much more important than the new comment that just describes what
the code is doing. Hence I'd prefer a slightly modified version of
the old comment rather than removing it altogether...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
