Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B41C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D2820866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gq6obxJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgHaUye (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 16:54:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHaUyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 16:54:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKhp31119471;
        Mon, 31 Aug 2020 20:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pZNMsxLlWtLZ5YFR4RHK12XDheKBHmXo8JjbGyDuF6I=;
 b=Gq6obxJW2N90MA95pWpb52EEP9AlhhKMhjh3OER7Ovqr374A764TcgVObkbCMKbp+8Ml
 4q03NvyM0zzyHjg63YfrjXK51Y9R36ogC0r/fbFP9sH0h+jHs+JunEeJOHFUqJ0PJreH
 TWauUZcpX0fwg8vCy83com/Z3PdUarCEcU4+1qN9Q+rg58qon+Jyc5egUqinPpoHcmeM
 0nvE+vHqNRjdvIr2fKNd5PyZd7xn7M+CBx1vptniLTgwBwyfWODIwNMn+GuqhMa0MUSz
 ZDr/Mzwy+veGi9F1BW7a8rlBQvdnR+dt22DeH5QNRUPXXUtb3mQzBQOLKk1nSL6PUcJu vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 337qrhfk9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 20:54:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKivJh071456;
        Mon, 31 Aug 2020 20:54:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380sqkpgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 20:54:25 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VKsNYs006934;
        Mon, 31 Aug 2020 20:54:23 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 13:54:22 -0700
Date:   Mon, 31 Aug 2020 13:54:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfsprogs: Introduce xfs_dfork_nextents() helper
Message-ID: <20200831205426.GX6096@magnolia>
References: <20200831130102.507-1-chandanrlinux@gmail.com>
 <20200831130102.507-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130102.507-3-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:31:00PM +0530, Chandan Babu R wrote:
> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper
> function xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents()
> returns the same value as XFS_DFORK_NEXTENTS(). A future commit which
> extends inode's extent counter fields will add more logic to this
> helper.
> 
> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> with calls to xfs_dfork_nextents().
> 
> No functional changes have been made.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  db/bmap.c               |  6 +++---
>  db/btdump.c             |  4 ++--
>  db/check.c              |  2 +-
>  db/frag.c               |  8 ++++---
>  db/inode.c              | 14 ++++++------
>  db/metadump.c           |  4 ++--
>  libxfs/xfs_format.h     |  4 ----
>  libxfs/xfs_inode_buf.c  | 26 ++++++++++++++++------
>  libxfs/xfs_inode_buf.h  |  2 ++
>  libxfs/xfs_inode_fork.c |  3 ++-
>  repair/attr_repair.c    |  2 +-
>  repair/dinode.c         | 48 +++++++++++++++++++++++------------------
>  repair/prefetch.c       |  2 +-
>  13 files changed, 74 insertions(+), 51 deletions(-)
> 
> diff --git a/db/bmap.c b/db/bmap.c
> index fdc70e95..9800a909 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -68,7 +68,7 @@ bmap(
>  	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
>  		fmt == XFS_DINODE_FMT_BTREE);
>  	if (fmt == XFS_DINODE_FMT_EXTENTS) {
> -		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
>  			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
> @@ -158,9 +158,9 @@ bmap_f(
>  		push_cur();
>  		set_cur_inode(iocur_top->ino);
>  		dip = iocur_top->data;
> -		if (be32_to_cpu(dip->di_nextents))
> +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))

Suggestion: Shift these kinds of changes to a separate patch to minimize
the amount of non-libxfs changes in a patch that will (eventually) be
ported from the kernel.  Ideally, the only changes to db/ and repair/
and mkfs/ would be the ones that are necessary to avoid breaking the
build.

Once you've separated the other conversions (like this one here) into a
separate patch, we can review that as a separate refactoring change to
userspace.

The reason for this ofc is that when the maintainers run libxfs-apply to
pull in the kernel patches, they're totally going to miss things like
this conversion unless you make them an explicit separate change.

FWIW the conversions themselves mostly look ok...

>  			dfork = 1;
> -		if (be16_to_cpu(dip->di_anextents))
> +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			afork = 1;
>  		pop_cur();
>  	}
> diff --git a/db/btdump.c b/db/btdump.c
> index 920f595b..9ced71d4 100644
> --- a/db/btdump.c
> +++ b/db/btdump.c
> @@ -166,13 +166,13 @@ dump_inode(
>  
>  	dip = iocur_top->data;
>  	if (attrfork) {
> -		if (!dip->di_anextents ||
> +		if (!xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) ||
>  		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
>  			dbprintf(_("attr fork not in btree format\n"));
>  			return 0;
>  		}
>  	} else {
> -		if (!dip->di_nextents ||
> +		if (!xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK) ||
>  		    dip->di_format != XFS_DINODE_FMT_BTREE) {
>  			dbprintf(_("data fork not in btree format\n"));
>  			return 0;
> diff --git a/db/check.c b/db/check.c
> index 12c03b6d..2d1823a4 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2686,7 +2686,7 @@ process_exinode(
>  	xfs_bmbt_rec_t		*rp;
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
> -	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	*nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
>  						sizeof(xfs_bmbt_rec_t)) {
>  		if (!sflag || id->ilist)
> diff --git a/db/frag.c b/db/frag.c
> index 1cfc6c2c..20fb1306 100644
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
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> +	process_bmbt_reclist(rp, nextents, extmapp);
>  }
>  
>  static void
> @@ -273,9 +275,9 @@ process_fork(
>  	int		whichfork)
>  {
>  	extmap_t	*extmap;
> -	int		nex;
> +	xfs_extnum_t	nex;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  	if (!nex)
>  		return;
>  	extmap = extmap_alloc(nex);
> diff --git a/db/inode.c b/db/inode.c
> index 0cff9d63..3853092c 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -271,7 +271,7 @@ inode_a_bmx_count(
>  		return 0;
>  	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
>  	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
> -		be16_to_cpu(dip->di_anextents) : 0;
> +		xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) : 0;
>  }
>  
>  static int
> @@ -325,6 +325,7 @@ inode_a_size(
>  {
>  	xfs_attr_shortform_t	*asf;
>  	xfs_dinode_t		*dip;
> +	xfs_extnum_t		nextents;
>  
>  	ASSERT(startoff == 0);
>  	ASSERT(idx == 0);
> @@ -334,8 +335,8 @@ inode_a_size(
>  		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
>  		return bitize(be16_to_cpu(asf->hdr.totsize));
>  	case XFS_DINODE_FMT_EXTENTS:
> -		return (int)be16_to_cpu(dip->di_anextents) *
> -							bitsz(xfs_bmbt_rec_t);
> +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> +		return (int)(nextents * bitsz(xfs_bmbt_rec_t));
>  	case XFS_DINODE_FMT_BTREE:
>  		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
>  	default:
> @@ -496,7 +497,7 @@ inode_u_bmx_count(
>  	dip = obj;
>  	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
>  	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
> -		be32_to_cpu(dip->di_nextents) : 0;
> +		xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK) : 0;
>  }
>  
>  static int
> @@ -582,6 +583,7 @@ inode_u_size(
>  	int		idx)
>  {
>  	xfs_dinode_t	*dip;
> +	xfs_extnum_t	nextents;
>  
>  	ASSERT(startoff == 0);
>  	ASSERT(idx == 0);
> @@ -592,8 +594,8 @@ inode_u_size(
>  	case XFS_DINODE_FMT_LOCAL:
>  		return bitize((int)be64_to_cpu(dip->di_size));
>  	case XFS_DINODE_FMT_EXTENTS:
> -		return (int)be32_to_cpu(dip->di_nextents) *
> -						bitsz(xfs_bmbt_rec_t);
> +		nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> +		return (int)(nextents * bitsz(xfs_bmbt_rec_t));
>  	case XFS_DINODE_FMT_BTREE:
>  		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
>  	case XFS_DINODE_FMT_UUID:
> diff --git a/db/metadump.c b/db/metadump.c
> index e5cb3aa5..6a6757a2 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2282,7 +2282,7 @@ process_exinode(
>  
>  	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
>  
> -	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	nex = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  	used = nex * sizeof(xfs_bmbt_rec_t);
>  	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
>  		if (show_warnings)
> @@ -2335,7 +2335,7 @@ static int
>  process_dev_inode(
>  	xfs_dinode_t		*dip)
>  {
> -	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +	if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK)) {
>  		if (show_warnings)
>  			print_warning("inode %llu has unexpected extents",
>  				      (unsigned long long)cur_ino);
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index a738cd8b..188deada 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -993,10 +993,6 @@ enum xfs_dinode_fmt {
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
> index ae71a19e..d5584372 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -362,9 +362,10 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	xfs_extnum_t		max_extents;
> +	uint32_t		di_nextents;
>  
> +	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -396,6 +397,15 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> +xfs_extnum_t
> +xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
> +{
> +	if (whichfork == XFS_DATA_FORK)
> +		return be32_to_cpu(dip->di_nextents);
> +	else
> +		return be16_to_cpu(dip->di_anextents);
> +}
> +
>  static xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
> @@ -432,6 +442,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	int64_t			nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -462,10 +474,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> -	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> +	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
> +        /* Fork checks carried over from xfs_iformat_fork */
> +	if (mode && nextents > nblocks)
>  		return __this_address;
>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -522,7 +536,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
> index 9b373dcf..f97b3428 100644
> --- a/libxfs/xfs_inode_buf.h
> +++ b/libxfs/xfs_inode_buf.h
> @@ -71,5 +71,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> +xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
> +			int whichfork);
>  
>  #endif	/* __XFS_INODE_BUF_H__ */
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index 80ba6c12..8c32f993 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -205,9 +205,10 @@ xfs_iformat_extents(
>  	int			whichfork)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(sbp, dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 6cec0f70..b6ca564b 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -1083,7 +1083,7 @@ process_longform_attr(
>  	bno = blkmap_get(blkmap, 0);
>  	if (bno == NULLFSBLOCK) {
>  		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -				be16_to_cpu(dip->di_anextents) == 0)
> +			xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK) == 0)

		    ^
This should /not/ be indented so that it lines up with the if body.

--D

>  			return(0); /* the kernel can handle this state */
>  		do_warn(
>  	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
> diff --git a/repair/dinode.c b/repair/dinode.c
> index de9a3286..98bb4a17 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -68,7 +68,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
>  		fprintf(stderr,
>  _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
>  
> -	if (be16_to_cpu(dino->di_anextents) != 0)  {
> +	if (xfs_dfork_nextents(&mp->m_sb, dino, XFS_ATTR_FORK) != 0) {
>  		if (no_modify)
>  			return(1);
>  		dino->di_anextents = cpu_to_be16(0);
> @@ -882,7 +882,7 @@ process_exinode(
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
>  	*tot = 0;
> -	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	numrecs = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
>  
>  	/*
>  	 * We've already decided on the maximum number of extents on the inode,
> @@ -981,7 +981,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
>  	}
>  
>  	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
> -	numrecs = be32_to_cpu(dino->di_nextents);
> +	numrecs = xfs_dfork_nextents(&mp->m_sb, dino, XFS_DATA_FORK);
>  
>  	/*
>  	 * the max # of extents in a symlink inode is equal to the
> @@ -1496,6 +1496,8 @@ process_check_sb_inodes(
>  	int		*type,
>  	int		*dirty)
>  {
> +	xfs_extnum_t	nextents;
> +
>  	if (lino == mp->m_sb.sb_rootino) {
>  		if (*type != XR_INO_DIR)  {
>  			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
> @@ -1550,10 +1552,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
>  				do_warn(_("would reset to regular file\n"));
>  			}
>  		}
> -		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
> +
> +		nextents = xfs_dfork_nextents(&mp->m_sb, dinoc, XFS_DATA_FORK);
> +		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
>  			do_warn(
>  _("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
> -				be32_to_cpu(dinoc->di_nextents), lino);
> +				nextents, lino);
>  			return 1;
>  		}
>  		return 0;
> @@ -1571,10 +1575,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
>  				do_warn(_("would reset to regular file\n"));
>  			}
>  		}
> -		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
> +
> +		nextents = xfs_dfork_nextents(&mp->m_sb, dinoc, XFS_DATA_FORK);
> +		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
>  			do_warn(
>  _("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
> -				be32_to_cpu(dinoc->di_nextents), lino);
> +				nextents, lino);
>  			return 1;
>  		}
>  		return 0;
> @@ -1735,6 +1741,7 @@ process_inode_blocks_and_extents(
>  	xfs_ino_t		lino,
>  	int			*dirty)
>  {
> +	xfs_extnum_t		dnextents;
>  	xfs_extnum_t		max_extents;
>  
>  	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
> @@ -1760,20 +1767,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			nextents, lino);
>  		return 1;
>  	}
> -	if (nextents != be32_to_cpu(dino->di_nextents))  {
> +
> +	dnextents = xfs_dfork_nextents(&mp->m_sb, dino, XFS_DATA_FORK);
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
> @@ -1784,19 +1790,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
>  			anextents, lino);
>  		return 1;
>  	}
> -	if (anextents != be16_to_cpu(dino->di_anextents))  {
> +
> +	dnextents = xfs_dfork_nextents(&mp->m_sb, dino, XFS_ATTR_FORK);
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
> @@ -1831,14 +1837,14 @@ process_inode_data_fork(
>  {
>  	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
>  	int		err = 0;
> -	int		nex;
> +	xfs_extnum_t	nex;
>  
>  	/*
>  	 * extent count on disk is only valid for positive values. The kernel
>  	 * uses negative values in memory. hence if we see negative numbers
>  	 * here, trash it!
>  	 */
> -	nex = be32_to_cpu(dino->di_nextents);
> +	nex = xfs_dfork_nextents(&mp->m_sb, dino, XFS_DATA_FORK);
>  	if (nex < 0)
>  		*nextents = 1;
>  	else
> @@ -1959,7 +1965,7 @@ process_inode_attr_fork(
>  		return 0;
>  	}
>  
> -	*anextents = be16_to_cpu(dino->di_anextents);
> +	*anextents = xfs_dfork_nextents(&mp->m_sb, dino, XFS_ATTR_FORK);
>  	if (*anextents > be64_to_cpu(dino->di_nblocks))
>  		*anextents = 1;
>  
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 686bf7be..6eb7c06b 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -393,7 +393,7 @@ pf_read_exinode(
>  	xfs_dinode_t		*dino)
>  {
>  	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
> -			be32_to_cpu(dino->di_nextents));
> +			xfs_dfork_nextents(&mp->m_sb, dino, XFS_DATA_FORK));
>  }
>  
>  static void
> -- 
> 2.28.0
> 
