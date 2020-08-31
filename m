Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C378DC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941E52064B
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fdf0UcM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgHaUsi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 16:48:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHaUsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 16:48:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKjVDi007214;
        Mon, 31 Aug 2020 20:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mqsW0PMuYUnoqmuNiWy9jtfkKjsuKP0D8+oDFDx3QbM=;
 b=fdf0UcM+IrhYm4EnSWCL/2SS4Ue3+fi+3X/Gwf2LzywmmIC4gmtu5m8OB6E6OqASqo1m
 crgwXt+OBMt32GYrTCjxAZDh7AADSkfbO3riVe7/7C/Vh7WCO9eqGfI+OyHOwKOPM1lf
 g9eEdqE4Na+JxONYUs3n2Zo541fDH6n00X421leJjsIA4i1Jk9GztWVP/iyqx4JraUR4
 gM69GCFIFaNpmsbIoTCusvI4L6s0BCqSjwDuzfxsmLFLGMsFrqbdbDVVvZGAullRMtVR
 H4KQdAT9FfukctsyJCCR4tspEMrRosknCYoVI0LCh4h46IDMWpg0eMRyczTLcQtBxYp5 Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqrht1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 20:48:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKjb2k155500;
        Mon, 31 Aug 2020 20:48:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3380xvbg8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 20:48:30 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VKmTj4003407;
        Mon, 31 Aug 2020 20:48:29 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 13:48:28 -0700
Date:   Mon, 31 Aug 2020 13:48:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <20200831204832.GW6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
 <20200831130010.454-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130010.454-3-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:30:09PM +0530, Chandan Babu R wrote:
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
>  fs/xfs/libxfs/xfs_format.h     |  4 ----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 29 ++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_inode_buf.h  |  2 ++
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++++---
>  fs/xfs/scrub/inode.c           | 12 +++++++-----
>  5 files changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 31b7ece985bb..5f41e177dbda 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -992,10 +992,6 @@ enum xfs_dinode_fmt {
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
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5dcd71bfab2e..cce2aa99aad8 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -368,9 +368,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	uint32_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> +
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -401,6 +403,19 @@ xfs_dinode_verify_fork(
>  	return NULL;
>  }
>  
> +xfs_extnum_t
> +xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)

The first arg probaly should be a (struct xfs_mount *) to save the
callers some typing.

> +{
> +	xfs_extnum_t nextents;
> +
> +	if (whichfork == XFS_DATA_FORK)
> +		nextents = be32_to_cpu(dip->di_nextents);
> +	else
> +		nextents = be16_to_cpu(dip->di_anextents);
> +
> +	return nextents;

Would this be cleaner (as well as barf loudly on invalid args)?

	switch (whichfork) {
	case XFS_DATA_FORK:
		return be32_to_cpu(...);
	case XFS_ATTR_FORK:
		return be16_to_cpu(...);
	default:
		ASSERT(0);
		return 0;
	}


> +}
> +
>  static xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
> @@ -437,6 +452,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	int64_t			nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -467,10 +484,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
> +	nextents += xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
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
> @@ -527,7 +546,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 6b08b9d060c2..a97caf675aaf 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -59,5 +59,7 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
>  xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
> +xfs_extnum_t xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip,
> +				int whichfork);

Please try to match the second-line indentation of the declaration above
it.  Or: two tabs is enough.

>  
>  #endif	/* __XFS_INODE_BUF_H__ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 3a084aea8f85..2ce80bb5c70a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -10,6 +10,7 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> @@ -104,9 +105,10 @@ xfs_iformat_extents(
>  	int			whichfork)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	int			nex = xfs_dfork_nextents(sbp, dip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> @@ -226,6 +228,7 @@ xfs_iformat_data_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  
> @@ -234,7 +237,7 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = xfs_dfork_nextents(sbp, dip, XFS_DATA_FORK);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -286,6 +289,7 @@ xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	int			error = 0;
>  
>  	/*
> @@ -296,7 +300,7 @@ xfs_iformat_attr_fork(
>  	ip->i_afp->if_format = dip->di_aformat;
>  	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
>  		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +	ip->i_afp->if_nextents = xfs_dfork_nextents(sbp, dip, XFS_ATTR_FORK);
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 6d483ab29e63..e428ad0eef03 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -354,7 +354,7 @@ xchk_dinode(
>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>  
>  	/* di_nextents */
> -	nextents = be32_to_cpu(dip->di_nextents);
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK);
>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -371,10 +371,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);

Might be a good time to change these all to "naextents"?

> +
>  	/* di_forkoff */
>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);
> -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +	if (nextents != 0 && dip->di_forkoff == 0)
>  		xchk_ino_set_corrupt(sc, ino);
>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -386,7 +388,6 @@ xchk_dinode(
>  		xchk_ino_set_corrupt(sc, ino);
>  
>  	/* di_anextents */
> -	nextents = be16_to_cpu(dip->di_anextents);
>  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -464,6 +465,7 @@ xchk_inode_xref_bmap(
>  	struct xfs_scrub	*sc,
>  	struct xfs_dinode	*dip)
>  {
> +	xfs_mount_t		*mp = sc->mp;

Don't increase the usage of structure typedefs, please.

--D

>  	xfs_extnum_t		nextents;
>  	xfs_filblks_t		count;
>  	xfs_filblks_t		acount;
> @@ -477,14 +479,14 @@ xchk_inode_xref_bmap(
>  			&nextents, &count);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < xfs_dfork_nextents(&mp->m_sb, dip, XFS_DATA_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
>  			&nextents, &acount);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> -- 
> 2.28.0
> 
