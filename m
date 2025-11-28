Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545172C3247
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764316403; cv=none; b=toMCu+20ilvn/jgjvjz13a5wqtVutCpEQXDmfLZF/J4lBFAiUr7vQBc+Qlz4aG7ZkIq8hkiQjndrJF+r7F3P9dvc00pEkDUtyi72gFwtxsKI+PqUfqGgXQbNaI5XJ3GRy+rEFwX67p5U4c+/mjkfpLcGTxfN/U9w8gpGE1/qJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764316403; c=relaxed/simple;
	bh=nfoDKLIl8QqKPjp8zqSme7vAob5XT4Q4uxi71J3siXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYOjGR51H8jRHi0ZQDDu68OpTaOLT7XY0AkBZOlzZCuLxz7/APXFb+d/UpYAhC23xqJSIuYm8Fn6s0jGvs2PUQDUL5VoijjFJCrY8ScPgNZw6G5g8NHACx/WfbVxCXSpEEk1TWhmkkdgaFI64HbGYnRSZw6V+4MZx2UBYftokTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EEGgECAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEGgECAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B313EC4CEF1;
	Fri, 28 Nov 2025 07:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764316401;
	bh=nfoDKLIl8QqKPjp8zqSme7vAob5XT4Q4uxi71J3siXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EEGgECAYvBXo2HxrD5VAKzjW6jxClcXeuzQTiF4STwyV8lumR0/0ha52VIId0OkxY
	 vTydI3R37IhGBqoKTSJ/v0v/nxhbN0MENbvEqlqv/TMzJwzKBuiScTUjC9wXrXHWkw
	 wmoXzPAjt5HVH/dDDZrxFPclW18pBihByALIz5cgx3qz83u+NF14/2sFx3YSef4+xo
	 VJrQKYbRRaMVKEBBESrqmlPWo1edp+SPo1WkRtuIEdFUtrJKAHXYocit54jroBBNUx
	 TsEuFdqj0lXo6ELdyTUiZud4DINisbu+K1UWuZ4GyphpOCxYT1uAkhDr5Rdgx8vvKT
	 NMeoy1NgehX/w==
Date: Fri, 28 Nov 2025 08:53:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: add a enum for the XR_INO_* values
Message-ID: <gsry5zrjmrda6m6yj7o2wifqgf5gg4hpbcaej7ehon3aqdbswt@lewg6qgjizhx>
References: <20251128063719.1495736-1-hch@lst.de>
 <z-56E7SJXYuGLyhwMv_kupA6P2PsSlno3ZFbm0ZBF9Txb-n4NCMjzm45G45l18LisGhRfSQjDFf3YyOKUNVgPw==@protonmail.internalid>
 <20251128063719.1495736-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063719.1495736-2-hch@lst.de>

On Fri, Nov 28, 2025 at 07:36:59AM +0100, Christoph Hellwig wrote:
> Move the XR_INO_ definitions into dinode.c as they aren't used anywhere
> else, and turn them into an enum to improve type safety.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/dinode.c | 52 +++++++++++++++++++++++++++++++++++--------------
>  repair/incore.h | 19 ------------------
>  2 files changed, 37 insertions(+), 34 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8ca0aa0238c7..b824dfc0a59f 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -23,6 +23,26 @@
>  #include "bmap_repair.h"
>  #include "rt.h"
> 
> +/* inode types */
> +enum xr_ino_type {
> +	XR_INO_UNKNOWN,		/* unknown */
> +	XR_INO_DIR,		/* directory */
> +	XR_INO_RTDATA,		/* realtime file */
> +	XR_INO_RTBITMAP,	/* realtime bitmap inode */
> +	XR_INO_RTSUM,		/* realtime summary inode */
> +	XR_INO_DATA,		/* regular file */
> +	XR_INO_SYMLINK,		/* symlink */
> +	XR_INO_CHRDEV,		/* character device */
> +	XR_INO_BLKDEV,		/* block device */
> +	XR_INO_SOCK,		/* socket */
> +	XR_INO_FIFO,		/* fifo */
> +	XR_INO_UQUOTA,		/* user quota inode */
> +	XR_INO_GQUOTA,		/* group quota inode */
> +	XR_INO_PQUOTA,		/* project quota inode */
> +	XR_INO_RTRMAP,		/* realtime rmap */
> +	XR_INO_RTREFC,		/* realtime refcount */

I think those comments are redundant as the enums are mostly
self-descriptive, but independent of that the patch looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> +};
> +
>  /*
>   * gettext lookups for translations of strings use mutexes internally to
>   * the library. Hence when we come through here doing parallel scans in
> @@ -482,7 +502,7 @@ out_unlock:
>  static inline bool
>  is_reflink_type(
>  	struct xfs_mount	*mp,
> -	int			type)
> +	enum xr_ino_type	type)
>  {
>  	if (type == XR_INO_DATA && xfs_has_reflink(mp))
>  		return true;
> @@ -503,7 +523,7 @@ process_bmbt_reclist_int(
>  	xfs_mount_t		*mp,
>  	xfs_bmbt_rec_t		*rp,
>  	xfs_extnum_t		*numrecs,
> -	int			type,
> +	enum xr_ino_type	type,
>  	xfs_ino_t		ino,
>  	xfs_rfsblock_t		*tot,
>  	blkmap_t		**blkmapp,
> @@ -952,7 +972,7 @@ process_rtrmap(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
>  	struct xfs_dinode	*dip,
> -	int			type,
> +	enum xr_ino_type	type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*tot,
>  	uint64_t		*nex,
> @@ -1123,7 +1143,7 @@ process_rtrefc(
>  	xfs_agnumber_t			agno,
>  	xfs_agino_t			ino,
>  	struct xfs_dinode		*dip,
> -	int				type,
> +	enum xr_ino_type		type,
>  	int				*dirty,
>  	xfs_rfsblock_t			*tot,
>  	uint64_t			*nex,
> @@ -1279,7 +1299,7 @@ process_btinode(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
>  	struct xfs_dinode	*dip,
> -	int			type,
> +	enum xr_ino_type	type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*tot,
>  	xfs_extnum_t		*nex,
> @@ -1455,7 +1475,7 @@ process_exinode(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
>  	struct xfs_dinode	*dip,
> -	int			type,
> +	enum xr_ino_type	type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*tot,
>  	xfs_extnum_t		*nex,
> @@ -1648,7 +1668,7 @@ process_quota_inode(
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		lino,
>  	struct xfs_dinode	*dino,
> -	uint			ino_type,
> +	enum xr_ino_type	ino_type,
>  	struct blkmap		*blkmap)
>  {
>  	xfs_fsblock_t		fsbno;
> @@ -1935,7 +1955,7 @@ process_misc_ino_types(
>  	xfs_mount_t		*mp,
>  	struct xfs_dinode	*dino,
>  	xfs_ino_t		lino,
> -	int			type)
> +	enum xr_ino_type	type)
>  {
>  	/*
>  	 * must also have a zero size
> @@ -1982,7 +2002,10 @@ _("size of quota inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
>  }
> 
>  static int
> -process_misc_ino_types_blocks(xfs_rfsblock_t totblocks, xfs_ino_t lino, int type)
> +process_misc_ino_types_blocks(
> +	xfs_rfsblock_t		totblocks,
> +	xfs_ino_t		lino,
> +	enum xr_ino_type	type)
>  {
>  	/*
>  	 * you can not enforce all misc types have zero data fork blocks
> @@ -2092,7 +2115,7 @@ process_check_rt_inode(
>  	struct xfs_mount	*mp,
>  	struct xfs_dinode	*dinoc,
>  	xfs_ino_t		lino,
> -	int			*type,
> +	enum xr_ino_type	*type,
>  	int			*dirty,
>  	int			expected_type,
>  	const char		*tag)
> @@ -2130,7 +2153,7 @@ process_check_metadata_inodes(
>  	xfs_mount_t		*mp,
>  	struct xfs_dinode	*dinoc,
>  	xfs_ino_t		lino,
> -	int			*type,
> +	enum xr_ino_type	*type,
>  	int			*dirty)
>  {
>  	if (lino == mp->m_sb.sb_rootino) {
> @@ -2205,7 +2228,7 @@ process_check_inode_sizes(
>  	xfs_mount_t		*mp,
>  	struct xfs_dinode	*dino,
>  	xfs_ino_t		lino,
> -	int			type)
> +	enum xr_ino_type	type)
>  {
>  	xfs_fsize_t		size = be64_to_cpu(dino->di_size);
> 
> @@ -2466,7 +2489,7 @@ process_inode_data_fork(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		ino,
>  	struct xfs_dinode	**dinop,
> -	int			type,
> +	enum xr_ino_type	type,
>  	int			*dirty,
>  	xfs_rfsblock_t		*totblocks,
>  	xfs_extnum_t		*nextents,
> @@ -3029,10 +3052,10 @@ process_dinode_int(
>  	xfs_ino_t		*parent,	/* out -- parent if ino is a dir */
>  	struct xfs_buf		**ino_bpp)
>  {
> +	enum xr_ino_type	type = XR_INO_UNKNOWN;
>  	xfs_rfsblock_t		totblocks = 0;
>  	xfs_rfsblock_t		atotblocks = 0;
>  	int			di_mode;
> -	int			type;
>  	int			retval = 0;
>  	xfs_extnum_t		nextents;
>  	xfs_extnum_t		anextents;
> @@ -3048,7 +3071,6 @@ process_dinode_int(
> 
>  	*dirty = *isa_dir = 0;
>  	*used = is_used;
> -	type = XR_INO_UNKNOWN;
> 
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	di_mode = be16_to_cpu(dino->di_mode);
> diff --git a/repair/incore.h b/repair/incore.h
> index 57019148f588..293988c9769d 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -225,25 +225,6 @@ int		count_bcnt_extents(xfs_agnumber_t);
>   * inode definitions
>   */
> 
> -/* inode types */
> -
> -#define XR_INO_UNKNOWN	0		/* unknown */
> -#define XR_INO_DIR	1		/* directory */
> -#define XR_INO_RTDATA	2		/* realtime file */
> -#define XR_INO_RTBITMAP	3		/* realtime bitmap inode */
> -#define XR_INO_RTSUM	4		/* realtime summary inode */
> -#define XR_INO_DATA	5		/* regular file */
> -#define XR_INO_SYMLINK	6		/* symlink */
> -#define XR_INO_CHRDEV	7		/* character device */
> -#define XR_INO_BLKDEV	8		/* block device */
> -#define XR_INO_SOCK	9		/* socket */
> -#define XR_INO_FIFO	10		/* fifo */
> -#define XR_INO_UQUOTA	12		/* user quota inode */
> -#define XR_INO_GQUOTA	13		/* group quota inode */
> -#define XR_INO_PQUOTA	14		/* project quota inode */
> -#define XR_INO_RTRMAP	15		/* realtime rmap */
> -#define XR_INO_RTREFC	16		/* realtime refcount */
> -
>  /* inode allocation tree */
> 
>  /*
> --
> 2.47.3
> 
> 
