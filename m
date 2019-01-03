Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:3806 "EHLO
        ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727713AbfACVUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 16:20:49 -0500
Date: Fri, 4 Jan 2019 08:20:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: allow '/' in attribute names
Message-ID: <20190103212044.GO4205@dastard>
References: <1c673348-0244-89ff-5b3c-545ee3e458e4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c673348-0244-89ff-5b3c-545ee3e458e4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 03, 2019 at 01:15:56PM -0600, Eric Sandeen wrote:
> For some reason, since the earliest days of XFS, a '/' character
> in an extended attribute name has been treated as corruption by
> xfs_repair.  This despite nothing in other userspace tools or the
> kernel having this restriction.
> 
> My best guess is that this was an unintentional leftover from
> common code between dirs & attrs in the "da" code, and there has
> never been a good reason for it.
> 
> Since userspace and kernelspace allow such a name to be set,
> listed, and read, it seems wrong to flag it as corruption.
> So, make this test conditional on whether we're validating a name
> in a dir, as opposed to the name of an attr.

Sounds fair.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 1d04500..2f6f7ef 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -292,11 +292,9 @@ process_shortform_attr(
>  			}
>  		}
>  
> -		/* namecheck checks for / and null terminated for file names.
> -		 * attributes names currently follow the same rules.
> -		*/
> +		/* namecheck checks for null chars in attr names. */
>  		if (namecheck((char *)&currententry->nameval[0],
> -						currententry->namelen))  {
> +						currententry->namelen, false)) {

Hmmmm. that's kinda messy. How about:

/* attr_namecheck checks for null chars in attr names. */
bool
attr_namecheck(
	uint8_t	name,
	int	length)
{
	return namecheck((char *)name, length, false);
}

>  			do_warn(
>  	_("entry contains illegal character in shortform attribute name\n"));
>  			junkit = 1;
> @@ -459,7 +457,7 @@ process_leaf_attr_local(
>  
>  	local = xfs_attr3_leaf_name_local(leaf, i);
>  	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
> -							local->namelen)) {
> +						     local->namelen, false)) {
>  		do_warn(
>  	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
>  			i, da_bno, ino, local->namelen);
> @@ -514,7 +512,7 @@ process_leaf_attr_remote(
>  	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>  
>  	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
> -						remotep->namelen) ||
> +						remotep->namelen, false) ||
>  			be32_to_cpu(entry->hashval) !=
>  				libxfs_da_hashname((unsigned char *)&remotep->name[0],
>  						remotep->namelen) ||

That gets rid of the casts out of this code as well, and hides
the boolean inside the scope where it has meaning.

> diff --git a/repair/da_util.c b/repair/da_util.c
> index 1450767..1f6568e 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -13,20 +13,25 @@
>  #include "da_util.h"
>  
>  /*
> - * takes a name and length (name need not be null-terminated)
> - * and returns 1 if the name contains a '/' or a \0, returns 0
> - * otherwise
> + * takes a name and length (name need not be null-terminated) and whether
> + * we are checking a dir (vs an attr), and returns 1 if the direntry contains
> + * a '/', or if anything contains a \0, and returns 0 otherwise
>   */
>  int
> -namecheck(char *name, int length)
> +namecheck(
> +	char	*name,
> +	int	length,
> +	bool	isadir)
>  {
> -	char *c;
> -	int i;
> +	char	*c;
> +	int	i;
>  
>  	ASSERT(length < MAXNAMELEN);
>  
>  	for (c = name, i = 0; i < length; i++, c++) {
> -		if (*c == '/' || *c == '\0')
> +		if (isadir && *c == '/')
> +			return 0;
> +		if (*c == '\0')
>  			return 1;
>  	}
>  
> diff --git a/repair/da_util.h b/repair/da_util.h
> index d36dfd0..041dff7 100644
> --- a/repair/da_util.h
> +++ b/repair/da_util.h
> @@ -27,7 +27,8 @@ typedef struct da_bt_cursor {
>  int
>  namecheck(
>  	char		*name,
> -	int		length);
> +	int		length,
> +	bool		isadir);
>  
>  struct xfs_buf *
>  da_read_buf(
> diff --git a/repair/dir2.c b/repair/dir2.c
> index ba5763e..6d592d6 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -310,7 +310,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
>  		 * the length value is stored in a byte
>  		 * so it can't be too big, it can only wrap
>  		 */
> -		if (namecheck((char *)&sfep->name[0], namelen))  {
> +		if (namecheck((char *)&sfep->name[0], namelen, true))  {

same for these - convert to a dir_namecheck() wrapper function....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
