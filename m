Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11751CAB3
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 07:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Li+owrsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F124C433C7;
	Wed, 20 Dec 2023 07:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703056155;
	bh=Hr3IugD0zUkF85J7HhD4IOIlsxgv9FJ9EU6ylpxLiXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Li+owrsYTNFu00yIr6u3I+S4aNudcSC5OwLaa9STi5o1NvMI1TiASmHPt1FoBlFPN
	 cz4W6ZseZbk0DDrUl10OMEm3EaKma85UJtuBAoSVfEYHQjiyRQVOJ2rnuWKDWgpLky
	 xgCGKYobhK957dIIf1DazkNFdvDvAU8Hq+voLGPoJ9YjxrvwbHOF35zaFPMe4nKKFO
	 dIaHKXFpdiFarwNb1yLlh3bRitqMx7BFiHgt8ji8BnNrIT1M6UXIpx7+jHFfTKuZTY
	 5XwZ/hlWPVaWIgjTdESlZcnJfgDiTTMALf1IfzW0acDXXhh5/Ou9vzLIh6mCIezWez
	 36C3YHhamz02g==
Date: Tue, 19 Dec 2023 23:09:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: remove struct xfs_attr_shortform
Message-ID: <20231220070914.GO361584@frogsfrogsfrogs>
References: <20231220063503.1005804-1-hch@lst.de>
 <20231220063503.1005804-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220063503.1005804-8-hch@lst.de>

On Wed, Dec 20, 2023 at 07:35:01AM +0100, Christoph Hellwig wrote:
> sparse complains about struct xfs_attr_shortform because it embeds a
> structure with a variable sized array in a variable sized array.
> 
> Given that xfs_attr_shortform is not a very useful structure, and the
> dir2 equivalent has been removed a long time ago, remove it as well.
> 
> Provide a xfs_attr_sf_firstentry helper that returns the first
> xfs_attr_sf_entry behind a xfs_attr_sf_hdr to replace the structure
> dereference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       |  4 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.c  | 37 +++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_attr_leaf.h  |  2 +-
>  fs/xfs/libxfs/xfs_attr_sf.h    | 13 +++++++++---
>  fs/xfs/libxfs/xfs_da_format.h  | 33 +++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_inode_fork.c |  5 ++---
>  fs/xfs/libxfs/xfs_ondisk.h     | 14 ++++++-------
>  fs/xfs/scrub/attr.c            |  9 ++++-----
>  fs/xfs/scrub/inode_repair.c    |  4 ++--
>  fs/xfs/xfs_attr_list.c         | 12 +++++------
>  10 files changed, 71 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e8b4317da830ba..ec4061db7ffccd 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1052,9 +1052,9 @@ xfs_attr_set(
>  
>  static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
>  {
> -	struct xfs_attr_shortform *sf = dp->i_af.if_data;
> +	struct xfs_attr_sf_hdr *sf = dp->i_af.if_data;
>  
> -	return be16_to_cpu(sf->hdr.totsize);
> +	return be16_to_cpu(sf->totsize);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 82e1830334160b..e1281ab413c832 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -704,10 +704,10 @@ struct xfs_attr_sf_entry *
>  xfs_attr_sf_findname(
>  	struct xfs_da_args		*args)
>  {
> -	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
> +	struct xfs_attr_sf_hdr		*sf = args->dp->i_af.if_data;
>  	struct xfs_attr_sf_entry	*sfe;
>  
> -	for (sfe = &sf->list[0];
> +	for (sfe = xfs_attr_sf_firstentry(sf);
>  	     sfe < xfs_attr_sf_endptr(sf);
>  	     sfe = xfs_attr_sf_nextentry(sfe)) {
>  		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
> @@ -730,7 +730,7 @@ xfs_attr_shortform_add(
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_mount		*mp = dp->i_mount;
>  	struct xfs_ifork		*ifp = &dp->i_af;
> -	struct xfs_attr_shortform	*sf = ifp->if_data;
> +	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
>  	struct xfs_attr_sf_entry	*sfe;
>  	int				size;
>  
> @@ -750,8 +750,8 @@ xfs_attr_shortform_add(
>  	sfe->flags = args->attr_filter;
>  	memcpy(sfe->nameval, args->name, args->namelen);
>  	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
> -	sf->hdr.count++;
> -	be16_add_cpu(&sf->hdr.totsize, size);
> +	sf->count++;
> +	be16_add_cpu(&sf->totsize, size);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
>  
>  	xfs_sbversion_add_attr2(mp, args->trans);
> @@ -782,9 +782,9 @@ xfs_attr_sf_removename(
>  {
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_mount		*mp = dp->i_mount;
> -	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
> +	struct xfs_attr_sf_hdr		*sf = dp->i_af.if_data;
>  	struct xfs_attr_sf_entry	*sfe;
> -	uint16_t			totsize = be16_to_cpu(sf->hdr.totsize);
> +	uint16_t			totsize = be16_to_cpu(sf->totsize);
>  	void				*next, *end;
>  	int				size = 0;
>  
> @@ -809,9 +809,9 @@ xfs_attr_sf_removename(
>  	end = xfs_attr_sf_endptr(sf);
>  	if (next < end)
>  		memmove(sfe, next, end - next);
> -	sf->hdr.count--;
> +	sf->count--;
>  	totsize -= size;
> -	sf->hdr.totsize = cpu_to_be16(totsize);
> +	sf->totsize = cpu_to_be16(totsize);
>  
>  	/*
>  	 * Fix up the start offset of the attribute fork
> @@ -868,21 +868,21 @@ xfs_attr_shortform_to_leaf(
>  {
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_ifork		*ifp = &dp->i_af;
> -	struct xfs_attr_shortform	*sf = ifp->if_data;
> +	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
>  	struct xfs_attr_sf_entry	*sfe;
> +	int				size = be16_to_cpu(sf->totsize);
>  	struct xfs_da_args		nargs;
>  	char				*tmpbuffer;
> -	int				error, i, size;
> +	int				error, i;
>  	xfs_dablk_t			blkno;
>  	struct xfs_buf			*bp;
>  
>  	trace_xfs_attr_sf_to_leaf(args);
>  
> -	size = be16_to_cpu(sf->hdr.totsize);
>  	tmpbuffer = kmem_alloc(size, 0);
>  	ASSERT(tmpbuffer != NULL);
>  	memcpy(tmpbuffer, ifp->if_data, size);
> -	sf = (struct xfs_attr_shortform *)tmpbuffer;
> +	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
>  
>  	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
>  	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
> @@ -905,8 +905,8 @@ xfs_attr_shortform_to_leaf(
>  	nargs.trans = args->trans;
>  	nargs.op_flags = XFS_DA_OP_OKNOENT;
>  
> -	sfe = &sf->list[0];
> -	for (i = 0; i < sf->hdr.count; i++) {
> +	sfe = xfs_attr_sf_firstentry(sf);
> +	for (i = 0; i < sf->count; i++) {
>  		nargs.name = sfe->nameval;
>  		nargs.namelen = sfe->namelen;
>  		nargs.value = &sfe->nameval[nargs.namelen];
> @@ -973,10 +973,10 @@ xfs_attr_shortform_allfit(
>  /* Verify the consistency of a raw inline attribute fork. */
>  xfs_failaddr_t
>  xfs_attr_shortform_verify(
> -	struct xfs_attr_shortform	*sfp,
> +	struct xfs_attr_sf_hdr		*sfp,
>  	size_t				size)
>  {
> -	struct xfs_attr_sf_entry	*sfep;
> +	struct xfs_attr_sf_entry	*sfep = xfs_attr_sf_firstentry(sfp);
>  	struct xfs_attr_sf_entry	*next_sfep;
>  	char				*endp;
>  	int				i;
> @@ -990,8 +990,7 @@ xfs_attr_shortform_verify(
>  	endp = (char *)sfp + size;
>  
>  	/* Check all reported entries */
> -	sfep = &sfp->list[0];
> -	for (i = 0; i < sfp->hdr.count; i++) {
> +	for (i = 0; i < sfp->count; i++) {
>  		/*
>  		 * struct xfs_attr_sf_entry has a variable length.
>  		 * Check the fixed-offset parts of the structure are
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 35e668ae744fb1..9b9948639c0fb3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -53,7 +53,7 @@ int	xfs_attr_sf_removename(struct xfs_da_args *args);
>  struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
> -xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
> +xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_sf_hdr *sfp,
>  		size_t size);
>  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index a774d4d8776354..9abf7de95465f5 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -41,7 +41,14 @@ static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep)
>  	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
>  }
>  
> -/* next entry in struct */
> +/* first entry in the SF attr fork */
> +static inline struct xfs_attr_sf_entry *
> +xfs_attr_sf_firstentry(struct xfs_attr_sf_hdr *hdr)
> +{
> +	return (struct xfs_attr_sf_entry *)(hdr + 1);
> +}
> +
> +/* next entry after sfep */
>  static inline struct xfs_attr_sf_entry *
>  xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
>  {
> @@ -50,9 +57,9 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
>  
>  /* pointer to the space after the last entry, e.g. for adding a new one */
>  static inline struct xfs_attr_sf_entry *
> -xfs_attr_sf_endptr(struct xfs_attr_shortform *sf)
> +xfs_attr_sf_endptr(struct xfs_attr_sf_hdr *sf)
>  {
> -	return (void *)sf + be16_to_cpu(sf->hdr.totsize);
> +	return (void *)sf + be16_to_cpu(sf->totsize);
>  }
>  
>  #endif	/* __XFS_ATTR_SF_H__ */
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index f9015f88eca706..24f9d1461f9a6f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -578,20 +578,25 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>  #define XFS_ATTR_LEAF_MAPSIZE	3	/* how many freespace slots */
>  
>  /*
> - * Entries are packed toward the top as tight as possible.
> - */
> -struct xfs_attr_shortform {
> -	struct xfs_attr_sf_hdr {	/* constant-structure header block */
> -		__be16	totsize;	/* total bytes in shortform list */
> -		__u8	count;	/* count of active entries */
> -		__u8	padding;
> -	} hdr;
> -	struct xfs_attr_sf_entry {
> -		uint8_t namelen;	/* actual length of name (no NULL) */
> -		uint8_t valuelen;	/* actual length of value (no NULL) */
> -		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		uint8_t nameval[];	/* name & value bytes concatenated */
> -	} list[];			/* variable sized array */
> + * Attribute storage when stored inside the inode.
> + *
> + * Small attribute lists are packed as tightly as possible so as to fit into the
> + * literal area of the inode.
> + *
> + * These "shortform" attribute forks consist of a single xfs_attr_sf_hdr header
> + * followed by zero or more xfs_attr_sf_entry structures.
> + */
> +struct xfs_attr_sf_hdr {	/* constant-structure header block */
> +	__be16	totsize;	/* total bytes in shortform list */
> +	__u8	count;		/* count of active entries */
> +	__u8	padding;
> +};
> +
> +struct xfs_attr_sf_entry {
> +	__u8	namelen;	/* actual length of name (no NULL) */
> +	__u8	valuelen;	/* actual length of value (no NULL) */
> +	__u8	flags;		/* flags bits (XFS_ATTR_*) */
> +	__u8	nameval[];	/* name & value bytes concatenated */
>  };
>  
>  typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index d8405a8d3c14f9..f4569e18a8d0ea 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -279,10 +279,9 @@ static uint16_t
>  xfs_dfork_attr_shortform_size(
>  	struct xfs_dinode		*dip)
>  {
> -	struct xfs_attr_shortform	*atp =
> -		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
> +	struct xfs_attr_sf_hdr		*sf = XFS_DFORK_APTR(dip);
>  
> -	return be16_to_cpu(atp->hdr.totsize);
> +	return be16_to_cpu(sf->totsize);
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index d9c988c5ad692e..81885a6a028ed7 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -93,13 +93,13 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
>  	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
>  	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_shortform,	4);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
> -	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, namelen,	0);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
> +	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
>  	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index bac6fb2f01d880..83c7feb387147a 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -528,23 +528,22 @@ xchk_xattr_check_sf(
>  {
>  	struct xchk_xattr_buf		*ab = sc->buf;
>  	struct xfs_ifork		*ifp = &sc->ip->i_af;
> -	struct xfs_attr_shortform	*sf = ifp->if_data;
> -	struct xfs_attr_sf_entry	*sfe;
> +	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
> +	struct xfs_attr_sf_entry	*sfe = xfs_attr_sf_firstentry(sf);
>  	struct xfs_attr_sf_entry	*next;
>  	unsigned char			*end = ifp->if_data + ifp->if_bytes;
>  	int				i;
>  	int				error = 0;
>  
>  	bitmap_zero(ab->usedmap, ifp->if_bytes);
> -	xchk_xattr_set_map(sc, ab->usedmap, 0, sizeof(sf->hdr));
> +	xchk_xattr_set_map(sc, ab->usedmap, 0, sizeof(*sf));
>  
> -	sfe = &sf->list[0];
>  	if ((unsigned char *)sfe > end) {
>  		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
>  		return 0;
>  	}
>  
> -	for (i = 0; i < sf->hdr.count; i++) {
> +	for (i = 0; i < sf->count; i++) {
>  		unsigned char		*name = sfe->nameval;
>  		unsigned char		*value = &sfe->nameval[sfe->namelen];
>  
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 66949cc3d7cc9e..0ca62d59f84ad1 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -760,7 +760,7 @@ xrep_dinode_check_afork(
>  	struct xfs_scrub		*sc,
>  	struct xfs_dinode		*dip)
>  {
> -	struct xfs_attr_shortform	*afork_ptr;
> +	struct xfs_attr_sf_hdr		*afork_ptr;
>  	size_t				attr_size;
>  	unsigned int			afork_size;
>  
> @@ -778,7 +778,7 @@ xrep_dinode_check_afork(
>  			return true;
>  
>  		/* xattr structure cannot be larger than the fork */
> -		attr_size = be16_to_cpu(afork_ptr->hdr.totsize);
> +		attr_size = be16_to_cpu(afork_ptr->totsize);
>  		if (attr_size > afork_size)
>  			return true;
>  
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 8700b00e154c98..e368ad671e261e 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -56,13 +56,13 @@ xfs_attr_shortform_list(
>  	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
>  	struct xfs_inode		*dp = context->dp;
>  	struct xfs_attr_sf_sort		*sbuf, *sbp;
> -	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
> +	struct xfs_attr_sf_hdr		*sf = dp->i_af.if_data;
>  	struct xfs_attr_sf_entry	*sfe;
>  	int				sbsize, nsbuf, count, i;
>  	int				error = 0;
>  
>  	ASSERT(sf != NULL);
> -	if (!sf->hdr.count)
> +	if (!sf->count)
>  		return 0;
>  
>  	trace_xfs_attr_list_sf(context);
> @@ -78,8 +78,8 @@ xfs_attr_shortform_list(
>  	 */
>  	if (context->bufsize == 0 ||
>  	    (XFS_ISRESET_CURSOR(cursor) &&
> -	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
> -		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
> +	     (dp->i_af.if_bytes + sf->count * 16) < context->bufsize)) {
> +		for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
>  			if (XFS_IS_CORRUPT(context->dp->i_mount,
>  					   !xfs_attr_namecheck(sfe->nameval,
>  							       sfe->namelen)))
> @@ -108,7 +108,7 @@ xfs_attr_shortform_list(
>  	/*
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
> -	sbsize = sf->hdr.count * sizeof(*sbuf);
> +	sbsize = sf->count * sizeof(*sbuf);
>  	sbp = sbuf = kmem_alloc(sbsize, KM_NOFS);
>  
>  	/*
> @@ -116,7 +116,7 @@ xfs_attr_shortform_list(
>  	 * the relevant info from only those that match into a buffer.
>  	 */
>  	nsbuf = 0;
> -	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
> +	for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
>  		if (unlikely(
>  		    ((char *)sfe < (char *)sf) ||
>  		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
> -- 
> 2.39.2
> 
> 
