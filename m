Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbfANTyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jan 2019 14:54:23 -0500
Date: Mon, 14 Jan 2019 11:54:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs_repair: allow '/' in attribute names
Message-ID: <20190114195416.GZ12689@magnolia>
References: <1c673348-0244-89ff-5b3c-545ee3e458e4@redhat.com>
 <95c0c4ef-2a5b-656d-243d-f7a1cea516f6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95c0c4ef-2a5b-656d-243d-f7a1cea516f6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jan 11, 2019 at 05:12:15PM -0600, Eric Sandeen wrote:
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
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: refactor per dave's suggestion
> 
> djwong has new helpers in libxfs for this now, I'll pick them up
> and switch to them in...
> 
> ... drumroll ...
> 
> ...xfsprogs-5.0
> 
> -Eric
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 1d04500..5ad81c0 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -122,6 +122,14 @@ set_da_freemap(xfs_mount_t *mp, da_freemap_t *map, int start, int stop)
>   * fork being emptied and put in shortform format.
>   */
>  
> +static int
> +attr_namecheck(
> +	uint8_t	*name,
> +	int	length)
> +{
> +	return namecheck((char *)name, length, false);
> +}
> +
>  /*
>   * This routine just checks what security needs are for attribute values
>   * only called when root flag is set, otherwise these names could exist in
> @@ -292,11 +300,9 @@ process_shortform_attr(
>  			}
>  		}
>  
> -		/* namecheck checks for / and null terminated for file names.
> -		 * attributes names currently follow the same rules.
> -		*/
> -		if (namecheck((char *)&currententry->nameval[0],
> -						currententry->namelen))  {
> +		/* namecheck checks for null chars in attr names. */
> +		if (attr_namecheck(currententry->nameval,
> +						currententry->namelen)) {
>  			do_warn(
>  	_("entry contains illegal character in shortform attribute name\n"));
>  			junkit = 1;
> @@ -458,7 +464,7 @@ process_leaf_attr_local(
>  	xfs_attr_leaf_name_local_t *local;
>  
>  	local = xfs_attr3_leaf_name_local(leaf, i);
> -	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
> +	if (local->namelen == 0 || attr_namecheck(local->nameval,
>  							local->namelen)) {
>  		do_warn(
>  	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
> @@ -513,7 +519,7 @@ process_leaf_attr_remote(
>  
>  	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>  
> -	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
> +	if (remotep->namelen == 0 || attr_namecheck(remotep->name,
>  						remotep->namelen) ||
>  			be32_to_cpu(entry->hashval) !=
>  				libxfs_da_hashname((unsigned char *)&remotep->name[0],
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
> + * a '/', or anything contains a \0, returns 0 otherwise

Sort of a run-on sentence with no end marker

Maybe it's not such a big deal if it's all gonna get replaced with
libxfs helpers next release anyway.

Looks ok as far as I can see, which today ain't much. :(

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> index ba5763e..a6ab21b 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -44,6 +44,14 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
>  	l->ino = ino;
>  }
>  
> +static int
> +dir_namecheck(
> +	uint8_t	*name,
> +	int	length)
> +{
> +	return namecheck((char *)name, length, true);
> +}
> +
>  int
>  dir2_is_badino(
>  	xfs_ino_t	ino)
> @@ -310,7 +318,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
>  		 * the length value is stored in a byte
>  		 * so it can't be too big, it can only wrap
>  		 */
> -		if (namecheck((char *)&sfep->name[0], namelen))  {
> +		if (dir_namecheck(sfep->name, namelen)) {
>  			/*
>  			 * junk entry
>  			 */
> @@ -781,7 +789,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
>  		 * during phase 4.
>  		 */
>  		junkit = dep->name[0] == '/';
> -		nm_illegal = namecheck((char *)dep->name, dep->namelen);
> +		nm_illegal = dir_namecheck(dep->name, dep->namelen);
>  		if (ino_discovery && nm_illegal) {
>  			do_warn(
>  _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),
> 
