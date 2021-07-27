Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788BBC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585AC60F9B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhG0XOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232314AbhG0XOk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE9160249;
        Tue, 27 Jul 2021 23:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627427680;
        bh=+V9mUO2Bv3/qb0x+b2rF2C/PnYohVQR9Q6QMSo4ml8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVqWzSjNdqBAgDEqy8CC5kp4h8g/LoSeeZ0qaEGWIZDAEFyE8t9HvHc36kZzAZ0zP
         xcIqmmqPUo8X20LuO5EsvNue8DLKK3vnYxlS5l0bTPHlaGbTQHRc7vIvJxufY8y6I7
         ukXBpZHWodp8/QTNR6BtlBqbZMrUxsGY09SbFbJBJ921kQJ3mHpHj8/mMMIcJCnt28
         C6mp2GSp3EWN7EIW7w2gJNXeT95SHMXcIIHPhqD+a7O0grMWVYsz8Zcs3a57woqk+V
         0+uwTwQMv1m8d6HyLfPwQ0HXLqkfmb2WOamMbZKjb7M2AXgNuYaStfYjvnHU7+0Kkf
         4fXK0RrldapeQ==
Date:   Tue, 27 Jul 2021 16:14:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 05/12] xfsprogs: Introduce xfs_dfork_nextents() helper
Message-ID: <20210727231439.GX559212@magnolia>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
 <20210726114724.24956-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114724.24956-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:17:17PM +0530, Chandan Babu R wrote:
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
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  db/bmap.c               |  6 ++--
>  db/btdump.c             |  4 +--
>  db/check.c              | 27 ++++++++++-------
>  db/frag.c               |  6 ++--
>  db/inode.c              | 14 +++++----
>  db/metadump.c           |  4 +--
>  libxfs/xfs_format.h     |  4 ---
>  libxfs/xfs_inode_buf.c  | 43 +++++++++++++++++++++++----
>  libxfs/xfs_inode_buf.h  |  2 ++
>  libxfs/xfs_inode_fork.c | 11 ++++---
>  repair/attr_repair.c    |  2 +-
>  repair/bmap_repair.c    |  4 +--
>  repair/dinode.c         | 66 ++++++++++++++++++++++++-----------------
>  repair/prefetch.c       |  2 +-
>  14 files changed, 123 insertions(+), 72 deletions(-)
> 
> diff --git a/db/bmap.c b/db/bmap.c
> index 50f0474bc..5e1ab9258 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -68,7 +68,7 @@ bmap(
>  	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
>  		fmt == XFS_DINODE_FMT_BTREE);
>  	if (fmt == XFS_DINODE_FMT_EXTENTS) {
> -		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +		nextents = xfs_dfork_nextents(mp, dip, whichfork);
>  		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
>  			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
> @@ -158,9 +158,9 @@ bmap_f(
>  		push_cur();
>  		set_cur_inode(iocur_top->ino);
>  		dip = iocur_top->data;
> -		if (be32_to_cpu(dip->di_nextents))
> +		if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK))
>  			dfork = 1;
> -		if (be16_to_cpu(dip->di_anextents))
> +		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>  			afork = 1;
>  		pop_cur();
>  	}
> diff --git a/db/btdump.c b/db/btdump.c
> index 920f595b4..59609fd2d 100644
> --- a/db/btdump.c
> +++ b/db/btdump.c
> @@ -166,13 +166,13 @@ dump_inode(
>  
>  	dip = iocur_top->data;
>  	if (attrfork) {
> -		if (!dip->di_anextents ||
> +		if (!xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) ||
>  		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
>  			dbprintf(_("attr fork not in btree format\n"));
>  			return 0;
>  		}
>  	} else {
> -		if (!dip->di_nextents ||
> +		if (!xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) ||
>  		    dip->di_format != XFS_DINODE_FMT_BTREE) {
>  			dbprintf(_("data fork not in btree format\n"));
>  			return 0;
> diff --git a/db/check.c b/db/check.c
> index 0d923e3ae..fe422e0ca 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2720,7 +2720,7 @@ process_exinode(
>  	xfs_bmbt_rec_t		*rp;
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> -	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	*nex = xfs_dfork_nextents(mp, dip, whichfork);
>  	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
>  						sizeof(xfs_bmbt_rec_t)) {
>  		if (!sflag || id->ilist)
> @@ -2744,12 +2744,14 @@ process_inode(
>  	inodata_t		*id = NULL;
>  	xfs_ino_t		ino;
>  	xfs_extnum_t		nextents = 0;
> +	xfs_extnum_t		dnextents;
>  	int			security;
>  	xfs_rfsblock_t		totblocks;
>  	xfs_rfsblock_t		totdblocks = 0;
>  	xfs_rfsblock_t		totiblocks = 0;
>  	dbm_t			type;
>  	xfs_extnum_t		anextents = 0;
> +	xfs_extnum_t		danextents;
>  	xfs_rfsblock_t		atotdblocks = 0;
>  	xfs_rfsblock_t		atotiblocks = 0;
>  	xfs_qcnt_t		bc = 0;
> @@ -2878,14 +2880,17 @@ process_inode(
>  		error++;
>  		return;
>  	}
> +
> +	dnextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
> +	danextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +
>  	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
>  		dbprintf(_("inode %lld mode %#o fmt %s "
>  			 "afmt %s "
>  			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
>  			id->ino, mode, fmtnames[(int)dip->di_format],
>  			fmtnames[(int)dip->di_aformat],
> -			be32_to_cpu(dip->di_nextents),
> -			be16_to_cpu(dip->di_anextents),
> +			dnextents, danextents,
>  			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
>  			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
>  			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
> @@ -2903,19 +2908,19 @@ process_inode(
>  		if (xfs_sb_version_hasmetadir(&mp->m_sb) &&
>  		    id->ino == mp->m_sb.sb_metadirino)
>  			addlink_inode(id);
> -		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
> +		blkmap = blkmap_alloc(dnextents);
>  		break;
>  	case S_IFREG:
>  		if (diflags & XFS_DIFLAG_REALTIME)
>  			type = DBM_RTDATA;
>  		else if (id->ino == mp->m_sb.sb_rbmino) {
>  			type = DBM_RTBITMAP;
> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
> +			blkmap = blkmap_alloc(dnextents);
>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>  				addlink_inode(id);
>  		} else if (id->ino == mp->m_sb.sb_rsumino) {
>  			type = DBM_RTSUM;
> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
> +			blkmap = blkmap_alloc(dnextents);
>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>  				addlink_inode(id);
>  		}
> @@ -2923,7 +2928,7 @@ process_inode(
>  			 id->ino == mp->m_sb.sb_gquotino ||
>  			 id->ino == mp->m_sb.sb_pquotino) {
>  			type = DBM_QUOTA;
> -			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
> +			blkmap = blkmap_alloc(dnextents);
>  			if (!xfs_sb_version_hasmetadir(&mp->m_sb))
>  				addlink_inode(id);
>  		}
> @@ -3006,17 +3011,17 @@ process_inode(
>  				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
>  		error++;
>  	}
> -	if (nextents != be32_to_cpu(dip->di_nextents)) {
> +	if (nextents != dnextents) {
>  		if (v)
>  			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
> -				be32_to_cpu(dip->di_nextents), id->ino, nextents);
> +				dnextents, id->ino, nextents);
>  		error++;
>  	}
> -	if (anextents != be16_to_cpu(dip->di_anextents)) {
> +	if (anextents != danextents) {
>  		if (v)
>  			dbprintf(_("bad anextents %d for inode %lld, counted "
>  				 "%d\n"),
> -				be16_to_cpu(dip->di_anextents), id->ino, anextents);
> +				danextents, id->ino, anextents);
>  		error++;
>  	}
>  	if (type == DBM_DIR)
> diff --git a/db/frag.c b/db/frag.c
> index 90fa2131c..3e43a9a21 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -262,9 +262,11 @@ process_exinode(
>  	int			whichfork)
>  {
>  	xfs_bmbt_rec_t		*rp;
> +	xfs_extnum_t		nextents;
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> -	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
> +	nextents = xfs_dfork_nextents(mp, dip, whichfork);
> +	process_bmbt_reclist(rp, nextents, extmapp);
>  }
>  
>  static void
> @@ -275,7 +277,7 @@ process_fork(
>  	extmap_t	*extmap;
>  	xfs_extnum_t	nex;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = xfs_dfork_nextents(mp, dip, whichfork);
>  	if (!nex)
>  		return;
>  	extmap = extmap_alloc(nex);
> diff --git a/db/inode.c b/db/inode.c
> index e59cff451..681f4f98a 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -278,7 +278,7 @@ inode_a_bmx_count(
>  		return 0;
>  	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
>  	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
> -		be16_to_cpu(dip->di_anextents) : 0;
> +		xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) : 0;
>  }
>  
>  static int
> @@ -332,6 +332,7 @@ inode_a_size(
>  {
>  	struct xfs_attr_shortform	*asf;
>  	xfs_dinode_t			*dip;
> +	xfs_extnum_t			nextents;
>  
>  	ASSERT(startoff == 0);
>  	ASSERT(idx == 0);
> @@ -341,8 +342,8 @@ inode_a_size(
>  		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
>  		return bitize(be16_to_cpu(asf->hdr.totsize));
>  	case XFS_DINODE_FMT_EXTENTS:
> -		return (int)be16_to_cpu(dip->di_anextents) *
> -							bitsz(xfs_bmbt_rec_t);
> +		nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +		return (int)nextents * bitsz(xfs_bmbt_rec_t);

I think you can drop the cast (and convert the typedef) her.

>  	case XFS_DINODE_FMT_BTREE:
>  		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
>  	default:
> @@ -503,7 +504,7 @@ inode_u_bmx_count(
>  	dip = obj;
>  	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
>  	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
> -		be32_to_cpu(dip->di_nextents) : 0;
> +		xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) : 0;
>  }
>  
>  static int
> @@ -589,6 +590,7 @@ inode_u_size(
>  	int		idx)
>  {
>  	xfs_dinode_t	*dip;
> +	xfs_extnum_t	nextents;
>  
>  	ASSERT(startoff == 0);
>  	ASSERT(idx == 0);
> @@ -599,8 +601,8 @@ inode_u_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		return bitize((int)be64_to_cpu(dip->di_size));
>  	case XFS_DINODE_FMT_EXTENTS:
> -		return (int)be32_to_cpu(dip->di_nextents) *
> -						bitsz(xfs_bmbt_rec_t);
> +		nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
> +		return (int)nextents * bitsz(xfs_bmbt_rec_t);

...and here.

The rest of the db/repair changes look good.

--D

>  	case XFS_DINODE_FMT_BTREE:
>  		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
>  	case XFS_DINODE_FMT_UUID:
> diff --git a/db/metadump.c b/db/metadump.c
> index 332e43a8e..c194501d0 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2314,7 +2314,7 @@ process_exinode(
>  
>  	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = xfs_dfork_nextents(mp, dip, whichfork);
>  	used = nex * sizeof(xfs_bmbt_rec_t);
>  	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
>  		if (show_warnings)
> @@ -2369,7 +2369,7 @@ static int
>  process_dev_inode(
>  	xfs_dinode_t		*dip)
>  {
> -	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK)) {
>  		if (show_warnings)
>  			print_warning("inode %llu has unexpected extents",
>  				      (unsigned long long)cur_ino);
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index 84b3aefe2..2a5e7e3a3 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -1166,10 +1166,6 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index b2e8e431a..8d52ce186 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -339,9 +339,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(mp, dip, whichfork);
> +
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -372,6 +374,31 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> +xfs_extnum_t
> +xfs_dfork_nextents(
> +	struct xfs_mount	*mp,
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
> +{
> +	xfs_extnum_t		nextents = 0;
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		nextents = be32_to_cpu(dip->di_nextents);
> +		break;
> +
> +	case XFS_ATTR_FORK:
> +		nextents = be16_to_cpu(dip->di_anextents);
> +		break;
> +
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	return nextents;
> +}
> +
>  static xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
> @@ -471,6 +498,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	uint64_t		nblocks;
> +	xfs_extnum_t            nextents;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -501,10 +530,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> -	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
> +	nextents += xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
> +        /* Fork checks carried over from xfs_iformat_fork */
> +	if (mode && nextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -561,7 +592,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
> index a30b76760..ea2c35091 100644
> --- a/libxfs/xfs_inode_buf.h
> +++ b/libxfs/xfs_inode_buf.h
> @@ -36,6 +36,8 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> +xfs_extnum_t xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
> +		int whichfork);
>  
>  static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
>  {
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index 48afaaeec..831313e3a 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -105,7 +105,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(mp, dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> @@ -224,6 +224,7 @@ xfs_iformat_data_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  
> @@ -232,7 +233,7 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -299,14 +300,16 @@ xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_extnum_t		nextents;
>  	int			error = 0;
>  
>  	/*
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
> -				be16_to_cpu(dip->di_anextents));
> +	nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
> +	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, nextents);
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index bc3c2bef7..0a461b675 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -1083,7 +1083,7 @@ process_longform_attr(
>  	bno = blkmap_get(blkmap, 0);
>  	if (bno == NULLFSBLOCK) {
>  		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -				be16_to_cpu(dip->di_anextents) == 0)
> +			xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) == 0)
>  			return(0); /* the kernel can handle this state */
>  		do_warn(
>  	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
> diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
> index 699089791..2e0475db1 100644
> --- a/repair/bmap_repair.c
> +++ b/repair/bmap_repair.c
> @@ -528,7 +528,7 @@ rebuild_bmap(
>  	 */
>  	switch (whichfork) {
>  	case XFS_DATA_FORK:
> -		if ((*dinop)->di_nextents == 0)
> +		if (!xfs_dfork_nextents(mp, *dinop, XFS_DATA_FORK))
>  			return 0;
>  		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
>  		(*dinop)->di_nextents = 0;
> @@ -536,7 +536,7 @@ rebuild_bmap(
>  		*dirty = 1;
>  		break;
>  	case XFS_ATTR_FORK:
> -		if ((*dinop)->di_anextents == 0)
> +		if (!xfs_dfork_nextents(mp, *dinop, XFS_ATTR_FORK))
>  			return 0;
>  		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
>  		(*dinop)->di_anextents = 0;
> diff --git a/repair/dinode.c b/repair/dinode.c
> index a034b5e86..6cc5bce5c 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -69,7 +69,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
>  		fprintf(stderr,
>  _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
>  
> -	if (be16_to_cpu(dino->di_anextents) != 0)  {
> +	if (xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK) != 0) {
>  		if (no_modify)
>  			return(1);
>  		dino->di_anextents = cpu_to_be16(0);
> @@ -973,7 +973,7 @@ process_exinode(
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  	*tot = 0;
> -	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	numrecs = xfs_dfork_nextents(mp, dip, whichfork);
>  
>  	/*
>  	 * We've already decided on the maximum number of extents on the inode,
> @@ -1050,7 +1050,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
>  	xfs_fileoff_t		expected_offset;
>  	xfs_bmbt_rec_t		*rp;
>  	xfs_bmbt_irec_t		irec;
> -	int			numrecs;
> +	xfs_extnum_t		numrecs;
>  	int			i;
>  	int			max_blocks;
>  
> @@ -1072,7 +1072,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
>  	}
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
> -	numrecs = be32_to_cpu(dino->di_nextents);
> +	numrecs = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
>  
>  	/*
>  	 * the max # of extents in a symlink inode is equal to the
> @@ -1578,6 +1578,8 @@ process_check_sb_inodes(
>  	int		*type,
>  	int		*dirty)
>  {
> +	xfs_extnum_t	nextents;
> +
>  	if (lino == mp->m_sb.sb_rootino) {
>  		if (*type != XR_INO_DIR)  {
>  			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
> @@ -1632,10 +1634,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
>  				do_warn(_("would reset to regular file\n"));
>  			}
>  		}
> -		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
> +
> +		nextents = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK);
> +		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
>  			do_warn(
> -_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
> -				be32_to_cpu(dinoc->di_nextents), lino);
> +_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
> +				nextents, lino);
>  			return 1;
>  		}
>  		return 0;
> @@ -1653,10 +1657,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
>  				do_warn(_("would reset to regular file\n"));
>  			}
>  		}
> -		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
> +
> +		nextents = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK);
> +		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
>  			do_warn(
> -_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
> -				be32_to_cpu(dinoc->di_nextents), lino);
> +_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
> +				nextents, lino);
>  			return 1;
>  		}
>  		return 0;
> @@ -1816,6 +1822,8 @@ process_inode_blocks_and_extents(
>  	xfs_ino_t	lino,
>  	int		*dirty)
>  {
> +	xfs_extnum_t		dnextents;
> +
>  	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
>  		if (!no_modify)  {
>  			do_warn(
> @@ -1838,20 +1846,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			nextents, lino);
>  		return 1;
>  	}
> -	if (nextents != be32_to_cpu(dino->di_nextents))  {
> +
> +	dnextents = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
> +	if (nextents != dnextents)  {
>  		if (!no_modify)  {
>  			do_warn(
>  _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
> -				lino,
> -				be32_to_cpu(dino->di_nextents),
> -				nextents);
> +				lino, dnextents, nextents);
>  			dino->di_nextents = cpu_to_be32(nextents);
>  			*dirty = 1;
>  		} else  {
>  			do_warn(
>  _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
> -				be32_to_cpu(dino->di_nextents),
> -				lino, nextents);
> +				dnextents, lino, nextents);
>  		}
>  	}
>  
> @@ -1861,19 +1868,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			anextents, lino);
>  		return 1;
>  	}
> -	if (anextents != be16_to_cpu(dino->di_anextents))  {
> +
> +	dnextents = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK);
> +	if (anextents != dnextents)  {
>  		if (!no_modify)  {
>  			do_warn(
>  _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
> -				lino,
> -				be16_to_cpu(dino->di_anextents), anextents);
> +				lino, dnextents, anextents);
>  			dino->di_anextents = cpu_to_be16(anextents);
>  			*dirty = 1;
>  		} else  {
>  			do_warn(
>  _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
> -				be16_to_cpu(dino->di_anextents),
> -				lino, anextents);
> +				dnextents, lino, anextents);
>  		}
>  	}
>  
> @@ -1910,8 +1917,8 @@ process_inode_data_fork(
>  {
>  	struct xfs_dinode	*dino = *dinop;
>  	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
> +	xfs_extnum_t		nex;
>  	int			err = 0;
> -	int			nex;
>  	int			try_rebuild = -1; /* don't know yet */
>  
>  retry:
> @@ -1920,7 +1927,7 @@ retry:
>  	 * uses negative values in memory. hence if we see negative numbers
>  	 * here, trash it!
>  	 */
> -	nex = be32_to_cpu(dino->di_nextents);
> +	nex = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
>  	if (nex < 0)
>  		*nextents = 1;
>  	else
> @@ -1970,8 +1977,7 @@ _("rebuilding inode %"PRIu64" data fork\n"),
>  					lino);
>  				try_rebuild = 0;
>  				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
> -						be32_to_cpu(dino->di_nextents),
> -						ino_bpp, dinop, dirty);
> +						nex, ino_bpp, dinop, dirty);
>  				dino = *dinop;
>  				if (!err)
>  					goto retry;
> @@ -2070,7 +2076,7 @@ retry:
>  		return 0;
>  	}
>  
> -	*anextents = be16_to_cpu(dino->di_anextents);
> +	*anextents = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK);
>  	if (*anextents > be64_to_cpu(dino->di_nblocks))
>  		*anextents = 1;
>  
> @@ -2118,13 +2124,17 @@ retry:
>  
>  		if (!no_modify)  {
>  			if (try_rebuild == 1) {
> +				xfs_extnum_t danextents;
> +
> +				danextents = xfs_dfork_nextents(mp, dino,
> +						XFS_ATTR_FORK);
>  				do_warn(
>  _("rebuilding inode %"PRIu64" attr fork\n"),
>  					lino);
>  				try_rebuild = 0;
>  				err = rebuild_bmap(mp, lino, XFS_ATTR_FORK,
> -						be16_to_cpu(dino->di_anextents),
> -						ino_bpp, dinop, dirty);
> +						danextents, ino_bpp, dinop,
> +						dirty);
>  				dino = *dinop;
>  				if (!err)
>  					goto retry;
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 9e5ced94a..b8d11ead0 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -393,7 +393,7 @@ pf_read_exinode(
>  	xfs_dinode_t		*dino)
>  {
>  	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
> -			be32_to_cpu(dino->di_nextents));
> +			xfs_dfork_nextents(mp, dino, XFS_DATA_FORK));
>  }
>  
>  static void
> -- 
> 2.30.2
> 
