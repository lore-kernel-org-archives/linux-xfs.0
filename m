Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5526DC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1502D21881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iQK69TWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfHZVlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:41:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfHZVlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:41:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLcSQq180871;
        Mon, 26 Aug 2019 21:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+dzOlZa1uPwrnj5K6x/VRdjIYcZNXqD1Z2TK6DpJPRU=;
 b=iQK69TWBwW/9aMS3dXwnWjO+EBC+4O/B4+6G3IdhJ4gJ4cv2fMHeauHkJjCnIU5YZxyx
 1R22lwnOyBXYl09hbmj6LAmDz7Ebea82QrKZtzG/Rc+YUpWiK4s5sUFpI4LznuUdOSFX
 9pe3PloDKrSNuDPUpBvchlBtk2uyw5qCRwq8gZKx+bPrIYAeqf7so2nSzVWf9W9dlN8Q
 VtAmHrJth2b2EWT2kt/KBUsPlcGK9MIprKc3mbNyNPGROTRqh0uoTbcEhRbJoPwptJsk
 6nW8U2QsDU41K2AKqTA/32b1D4MNXzTFuQRt0YuxgAOeNoKNWT+M1wI9hRspO5QhpQw8 Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2umq5t83mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:41:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLcQ6f015999;
        Mon, 26 Aug 2019 21:41:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7x8fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:41:19 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLfJ8x014480;
        Mon, 26 Aug 2019 21:41:19 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:41:18 -0700
Date:   Mon, 26 Aug 2019 14:41:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: bmap scrub should only scrub records once
Message-ID: <20190826214117.GV1037350@magnolia>
References: <20190826162222.GN1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826162222.GN1037350@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260200
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Meh, at this point I might as well just send these four fixes (and four
more cleanups) that I found as proper series.

--D

On Mon, Aug 26, 2019 at 09:22:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The inode block mapping scrub function does more work for btree format
> extent maps than is absolutely necessary -- first it will walk the bmbt
> and check all the entries, and then it will load the incore tree and
> check every entry in that tree, possibly for a second time.
> 
> Simplify the code and decrease check runtime by separating the two
> responsibilities.  The bmbt walk will make sure the incore extent
> mappings are loaded, check the shape of the bmap btree (via xchk_btree)
> and check that every bmbt record has a corresponding incore extent map;
> and the incore extent map walk takes all the responsibility for checking
> the mapping records and cross referencing them with other AG metadata.
> 
> This enables us to clean up some messy parameter handling and reduce
> redundant code.  Rename a few functions to make the split of
> responsibilities clearer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: always load the extent cache and separate the bmbt/iext walk code
> ---
>  fs/xfs/scrub/bmap.c |   76 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 1bd29fdc2ab5..f6ed6eb133a6 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -75,6 +75,7 @@ struct xchk_bmap_info {
>  	xfs_fileoff_t		lastoff;
>  	bool			is_rt;
>  	bool			is_shared;
> +	bool			was_loaded;
>  	int			whichfork;
>  };
>  
> @@ -213,25 +214,20 @@ xchk_bmap_xref_rmap(
>  
>  /* Cross-reference a single rtdev extent record. */
>  STATIC void
> -xchk_bmap_rt_extent_xref(
> -	struct xchk_bmap_info	*info,
> +xchk_bmap_rt_iextent_xref(
>  	struct xfs_inode	*ip,
> -	struct xfs_btree_cur	*cur,
> +	struct xchk_bmap_info	*info,
>  	struct xfs_bmbt_irec	*irec)
>  {
> -	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> -		return;
> -
>  	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
>  			irec->br_blockcount);
>  }
>  
>  /* Cross-reference a single datadev extent record. */
>  STATIC void
> -xchk_bmap_extent_xref(
> -	struct xchk_bmap_info	*info,
> +xchk_bmap_iextent_xref(
>  	struct xfs_inode	*ip,
> -	struct xfs_btree_cur	*cur,
> +	struct xchk_bmap_info	*info,
>  	struct xfs_bmbt_irec	*irec)
>  {
>  	struct xfs_mount	*mp = info->sc->mp;
> @@ -240,9 +236,6 @@ xchk_bmap_extent_xref(
>  	xfs_extlen_t		len;
>  	int			error;
>  
> -	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> -		return;
> -
>  	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
>  	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
>  	len = irec->br_blockcount;
> @@ -300,20 +293,15 @@ xchk_bmap_dirattr_extent(
>  
>  /* Scrub a single extent record. */
>  STATIC int
> -xchk_bmap_extent(
> +xchk_bmap_iextent(
>  	struct xfs_inode	*ip,
> -	struct xfs_btree_cur	*cur,
>  	struct xchk_bmap_info	*info,
>  	struct xfs_bmbt_irec	*irec)
>  {
>  	struct xfs_mount	*mp = info->sc->mp;
> -	struct xfs_buf		*bp = NULL;
>  	xfs_filblks_t		end;
>  	int			error = 0;
>  
> -	if (cur)
> -		xfs_btree_get_block(cur, 0, &bp);
> -
>  	/*
>  	 * Check for out-of-order extents.  This record could have come
>  	 * from the incore list, for which there is no ordering check.
> @@ -364,10 +352,13 @@ xchk_bmap_extent(
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  
> +	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		return 0;
> +
>  	if (info->is_rt)
> -		xchk_bmap_rt_extent_xref(info, ip, cur, irec);
> +		xchk_bmap_rt_iextent_xref(ip, info, irec);
>  	else
> -		xchk_bmap_extent_xref(info, ip, cur, irec);
> +		xchk_bmap_iextent_xref(ip, info, irec);
>  
>  	info->lastoff = irec->br_startoff + irec->br_blockcount;
>  	return error;
> @@ -380,10 +371,13 @@ xchk_bmapbt_rec(
>  	union xfs_btree_rec	*rec)
>  {
>  	struct xfs_bmbt_irec	irec;
> +	struct xfs_bmbt_irec	iext_irec;
> +	struct xfs_iext_cursor	icur;
>  	struct xchk_bmap_info	*info = bs->private;
>  	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
>  	struct xfs_buf		*bp = NULL;
>  	struct xfs_btree_block	*block;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
>  	uint64_t		owner;
>  	int			i;
>  
> @@ -402,9 +396,25 @@ xchk_bmapbt_rec(
>  		}
>  	}
>  
> -	/* Set up the in-core record and scrub it. */
> +	/*
> +	 * Check that the incore extent tree contains an extent that matches
> +	 * this one exactly.  We validate those cached bmaps later, so we don't
> +	 * need to check them here.  If the extent tree was freshly loaded by
> +	 * the scrubber then we skip the check entirely.
> +	 */
> +	if (info->was_loaded)
> +		return 0;
> +
>  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> -	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> +	if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> +				&iext_irec) ||
> +	    irec.br_startoff != iext_irec.br_startoff ||
> +	    irec.br_startblock != iext_irec.br_startblock ||
> +	    irec.br_blockcount != iext_irec.br_blockcount ||
> +	    irec.br_state != iext_irec.br_state)
> +		xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> +				irec.br_startoff);
> +	return 0;
>  }
>  
>  /* Scan the btree records. */
> @@ -415,15 +425,26 @@ xchk_bmap_btree(
>  	struct xchk_bmap_info	*info)
>  {
>  	struct xfs_owner_info	oinfo;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_inode	*ip = sc->ip;
>  	struct xfs_btree_cur	*cur;
>  	int			error;
>  
> +	/* Load the incore bmap cache if it's not loaded. */
> +	info->was_loaded = ifp->if_flags & XFS_IFEXTENTS;
> +	if (!info->was_loaded) {
> +		error = xfs_iread_extents(sc->tp, ip, whichfork);
> +		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> +			goto out;
> +	}
> +
> +	/* Check the btree structure. */
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
>  	error = xchk_btree(sc, cur, xchk_bmapbt_rec, &oinfo, info);
>  	xfs_btree_del_cursor(cur, error);
> +out:
>  	return error;
>  }
>  
> @@ -671,13 +692,6 @@ xchk_bmap(
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out;
>  
> -	/* Now try to scrub the in-memory extent list. */
> -        if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(sc->tp, ip, whichfork);
> -		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> -			goto out;
> -	}
> -
>  	/* Find the offset of the last extent in the mapping. */
>  	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
>  	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> @@ -689,7 +703,7 @@ xchk_bmap(
>  	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xchk_should_terminate(sc, &error) ||
>  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> -			break;
> +			goto out;
>  		if (isnullstartblock(irec.br_startblock))
>  			continue;
>  		if (irec.br_startoff >= endoff) {
> @@ -697,7 +711,7 @@ xchk_bmap(
>  					irec.br_startoff);
>  			goto out;
>  		}
> -		error = xchk_bmap_extent(ip, NULL, &info, &irec);
> +		error = xchk_bmap_iextent(ip, &info, &irec);
>  		if (error)
>  			goto out;
>  	}
