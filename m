Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F028C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiADXsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:48:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48626 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiADXsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:48:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C7C6B817E5
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C515BC36AEB;
        Tue,  4 Jan 2022 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641340120;
        bh=NF86lQkbF3rfvskQ6+hw4WJl9bPKsX+MwdaAw/yWoVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEV0UxelsgCdTR8/PNfk2/wultFjkdriO0pNATFpT9Ws6C4u++vdpUaKmZ56IkU4K
         vlhVe9l0mdReUr/3lAX1WhSnN091pPoBKKtpTEDI0uEnL19ql7qoJUmrTScrFcIuD8
         tiTIHKHiCXy8xD6p2pta5MkeibtfLKfcl+i0p2UhWQ/JpGWtyk4lwtcbyoDapzNx9J
         Lw2zXJb9Xg3IOwzOBzL4WymY4mKta1Wobn/K/uXeShX3MeEZSO9ErKdEQ1WQ0pSPU+
         mp5Sdsd9lssYWAVZFlRBQvPZFgS9A0Mw0Wn2lJHTOYG1wAii2u03MbPJ/mL6spRAZ9
         P2m5OY3e1moAA==
Date:   Tue, 4 Jan 2022 15:48:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 04/16] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <20220104234840.GK31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-5-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-5-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:07PM +0530, Chandan Babu R wrote:
> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
> counter fields will add more logic to this helper.
> 
> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> with calls to xfs_dfork_nextents().
> 
> No functional changes have been made.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |  4 ----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
>  fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/inode.c           | 18 ++++++++++--------
>  5 files changed, 59 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d75e5b16da7e..e5654b578ec0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))

Yay, I love watching macros die.  Especially when the replacement
validates its arguments completely!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5c95a5428fc7..860d32816909 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(dip, whichfork);
> +
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -405,6 +407,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	xfs_filblks_t		nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -435,10 +439,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = xfs_dfork_data_extents(dip);
> +	nextents += xfs_dfork_attr_extents(dip);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
>  	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	if (mode && nextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -495,7 +501,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_attr_extents(dip))
>  			return __this_address;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a17c4d87520a..829739e249b6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -105,7 +105,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> @@ -230,7 +230,7 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	xfs_extnum_t		naextents;
>  	int			error = 0;
>  
> +	naextents = xfs_dfork_attr_extents(dip);
> +
>  	/*
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> -				be16_to_cpu(dip->di_anextents));
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 2605f7ff8fc1..7ed2ecb51bca 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
>  	return MAXAEXTNUM;
>  }
>  
> +static inline xfs_extnum_t
> +xfs_dfork_data_extents(
> +	struct xfs_dinode	*dip)
> +{
> +	return be32_to_cpu(dip->di_nextents);
> +}
> +
> +static inline xfs_extnum_t
> +xfs_dfork_attr_extents(
> +	struct xfs_dinode	*dip)
> +{
> +	return be16_to_cpu(dip->di_anextents);
> +}
> +
> +static inline xfs_extnum_t
> +xfs_dfork_nextents(
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
> +{
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		return xfs_dfork_data_extents(dip);
> +	case XFS_ATTR_FORK:
> +		return xfs_dfork_attr_extents(dip);
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
>  				xfs_extnum_t nextents);
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index aefdf8fe1372..a601b04fe408 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -233,6 +233,7 @@ xchk_dinode(
>  	unsigned long long	isize;
>  	uint64_t		flags2;
>  	xfs_extnum_t		nextents;
> +	xfs_extnum_t		naextents;
>  	uint16_t		flags;
>  	uint16_t		mode;
>  
> @@ -377,7 +378,7 @@ xchk_dinode(
>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>  
>  	/* di_nextents */
> -	nextents = be32_to_cpu(dip->di_nextents);
> +	nextents = xfs_dfork_data_extents(dip);
>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -394,10 +395,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	naextents = xfs_dfork_attr_extents(dip);
> +
>  	/* di_forkoff */
>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);
> -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +	if (naextents != 0 && dip->di_forkoff == 0)
>  		xchk_ino_set_corrupt(sc, ino);
>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -409,19 +412,18 @@ xchk_dinode(
>  		xchk_ino_set_corrupt(sc, ino);
>  
>  	/* di_anextents */
> -	nextents = be16_to_cpu(dip->di_anextents);
>  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> -		if (nextents > fork_recs)
> +		if (naextents > fork_recs)
>  			xchk_ino_set_corrupt(sc, ino);
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if (nextents <= fork_recs)
> +		if (naextents <= fork_recs)
>  			xchk_ino_set_corrupt(sc, ino);
>  		break;
>  	default:
> -		if (nextents != 0)
> +		if (naextents != 0)
>  			xchk_ino_set_corrupt(sc, ino);
>  	}
>  
> @@ -499,14 +501,14 @@ xchk_inode_xref_bmap(
>  			&nextents, &count);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < xfs_dfork_data_extents(dip))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
>  			&nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != xfs_dfork_attr_extents(dip))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> -- 
> 2.30.2
> 
