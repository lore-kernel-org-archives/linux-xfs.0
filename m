Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HC9sG2011567 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 06:09:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 827611C57732
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:10:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AiiqDK2eus3VAd8q for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 04:10:53 -0800 (PST)
Date: Sun, 17 Jan 2010 07:10:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfsprogs: fix sign warnings in libxfs
Message-ID: <20100117121053.GA21901@infradead.org>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 09:09:04PM +1100, Dave Chinner wrote:
> The directory naming is a mix of char and uchar_t and the compiler
> warns wheter they cross over. Cast the pointers according to the
> destination requirements as it doesn't seem to matter to avoid
> the warnings.

I think this makes sense, but it should really go into the kernel
code first - we currently paper over the warnings there by using
-funsigned-char for all XFS code which we might be able to remove
with those changes.

>  
>  struct xfs_name {
> -	const char	*name;
> +	const uchar_t	*name;
>  	int		len;

Maye use on of the standard types (unsigned char / u8 / uint8_t)
instead of the weird xfs-specific uchar_t, which in fact is already
gone in the kernel?

> @@ -1545,7 +1545,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
>  	ASSERT(!(args->flags & ATTR_KERNOVAL));
>  
>  	mp = args->dp->i_mount;
> -	dst = args->value;
> +	dst = (xfs_caddr_t)args->value;
>  	valuelen = args->valuelen;
>  	lblkno = args->rmtblkno;
>  	while (valuelen > 0) {
> @@ -1601,7 +1601,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
>  
>  	dp = args->dp;
>  	mp = dp->i_mount;
> -	src = args->value;
> +	src = (xfs_caddr_t)args->value;

If we make xfs_buf_iomove take a void * we can just pass on the
unsignedness in those two places.

> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index f8f926f..d535752 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -476,11 +476,11 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>  
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; i++) {
> -		nargs.name = (char *)sfe->nameval;
> +		nargs.name = (uchar_t *)sfe->nameval;
>  		nargs.namelen = sfe->namelen;
> -		nargs.value = (char *)&sfe->nameval[nargs.namelen];
> +		nargs.value = (uchar_t *)&sfe->nameval[nargs.namelen];
>  		nargs.valuelen = sfe->valuelen;
> -		nargs.hashval = xfs_da_hashname((char *)sfe->nameval,
> +		nargs.hashval = xfs_da_hashname((uchar_t *)sfe->nameval,
>  						sfe->namelen);

Both the leaf and sf nameval fields already are __u8/__uint8_t aka
unsigned char, so I can't see why can't see why any casts are needed
here and in the later hunks dealing with namevals.

> @@ -489,7 +489,7 @@ xfs_dir2_block_lookup(
>  	 * Fill in inode number, CI name if appropriate, release the block.
>  	 */
>  	args->inumber = be64_to_cpu(dep->inumber);
> -	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
> +	error = xfs_dir_cilookup_result(args, (char *)dep->name, dep->namelen);

xfs_dir_cilookup_result always gets unsigned char names now, so I'd move
the conversion into it.

>  	xfs_da_brelse(args->trans, bp);
>  	return XFS_ERROR(error);
>  }
> @@ -576,7 +576,7 @@ xfs_dir2_block_lookup_int(
>  		 * and buffer. If it's the first case-insensitive match, store
>  		 * the index and buffer and continue looking for an exact match.
>  		 */
> -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> +		cmp = mp->m_dirnameops->compname(args, (char *)dep->name, dep->namelen);

Also here, ->compname appears to always get unsigned names.

> -		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
> +		if (xfs_da_compname(args, (char *)sfep->name, sfep->namelen) ==
>  								XFS_CMP_EXACT) {
>  			ASSERT(xfs_dir2_sf_get_inumber(sfp,
>  						xfs_dir2_sf_inumberp(sfep)) ==
> @@ -928,8 +929,8 @@ xfs_dir2_sf_replace(
>  		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
>  				i < sfp->hdr.count;
>  				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
> -			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
> -								XFS_CMP_EXACT) {
> +			if (xfs_da_compname(args, (char *)sfep->name,
> +					sfep->namelen) == XFS_CMP_EXACT) {

Same seems to apply for direct calls to xfs_da_compname.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
