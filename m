Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735E6C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD0021D42
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgLGRrq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:47:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgLGRrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607363180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=72LqjWy1CHGgl8bfq1yHY0B4hwgjVel8oy4xmpsRaBU=;
        b=Myl2xk8+xQGAvggBPTzNRMOm7kzbNQyU+RW3vH2xlNsdDG/GkcgoXwqjnHCTQZ8W2PtWVg
        57poxaD2E23ACE04Ulk7w/xl4KptVqxU31XPKaBNGTwsSiyYE7lb3yxBKUSmvrPanEhrTm
        P+9awurmEUtpeGcelPYupZMHWQytqxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-P5ZeXZ-jNp67ohu3kj9uxw-1; Mon, 07 Dec 2020 12:46:18 -0500
X-MC-Unique: P5ZeXZ-jNp67ohu3kj9uxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FED5807344;
        Mon,  7 Dec 2020 17:46:17 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33AA160BE2;
        Mon,  7 Dec 2020 17:46:17 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:46:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor realtime volume extent validation
Message-ID: <20201207174615.GC1598552@bfoster>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626316.1608297.11622795343009336589.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626316.1608297.11622795343009336589.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:11:03PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of realtime device extents into a
> single helper.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c  |   13 +++----------
>  fs/xfs/libxfs/xfs_types.c |   16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h |    2 ++
>  fs/xfs/scrub/bmap.c       |    8 +-------
>  fs/xfs/scrub/rtbitmap.c   |    4 +---
>  5 files changed, 23 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7f1b6ad570a9..7bcf498ef6b2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6226,20 +6226,13 @@ xfs_bmap_validate_extent(
>  	struct xfs_bmbt_irec	*irec)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fsblock_t		endfsb;
> -	bool			isrt;
>  
> -	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
> -		return __this_address;
>  	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
>  		return __this_address;
>  
> -	isrt = XFS_IS_REALTIME_INODE(ip);
> -	endfsb = irec->br_startblock + irec->br_blockcount - 1;
> -	if (isrt && whichfork == XFS_DATA_FORK) {
> -		if (!xfs_verify_rtbno(mp, irec->br_startblock))
> -			return __this_address;
> -		if (!xfs_verify_rtbno(mp, endfsb))
> +	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
> +		if (!xfs_verify_rtext(mp, irec->br_startblock,
> +					  irec->br_blockcount))
>  			return __this_address;
>  	} else {
>  		if (!xfs_verify_fsbext(mp, irec->br_startblock,
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index b74866dbea94..7b310eb296b7 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -198,6 +198,22 @@ xfs_verify_rtbno(
>  	return rtbno < mp->m_sb.sb_rblocks;
>  }
>  
> +/* Verify that a realtime device extent is fully contained inside the volume. */
> +bool
> +xfs_verify_rtext(
> +	struct xfs_mount	*mp,
> +	xfs_rtblock_t		rtbno,
> +	xfs_rtblock_t		len)
> +{
> +	if (rtbno + len <= rtbno)
> +		return false;
> +
> +	if (!xfs_verify_rtbno(mp, rtbno))
> +		return false;
> +
> +	return xfs_verify_rtbno(mp, rtbno + len - 1);
> +}
> +
>  /* Calculate the range of valid icount values. */
>  void
>  xfs_icount_range(
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 7feaaac25b3d..18e83ce46568 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -197,6 +197,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
>  bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
> +bool xfs_verify_rtext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
> +		xfs_rtblock_t len);
>  bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
>  bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
>  void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 3e2ba7875059..cce8ac7d3973 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -319,7 +319,6 @@ xchk_bmap_iextent(
>  	struct xfs_bmbt_irec	*irec)
>  {
>  	struct xfs_mount	*mp = info->sc->mp;
> -	xfs_filblks_t		end;
>  	int			error = 0;
>  
>  	/*
> @@ -349,13 +348,8 @@ xchk_bmap_iextent(
>  	if (irec->br_blockcount > MAXEXTLEN)
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
> -	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
> -		xchk_fblock_set_corrupt(info->sc, info->whichfork,
> -				irec->br_startoff);
> -	end = irec->br_startblock + irec->br_blockcount - 1;
>  	if (info->is_rt &&
> -	    (!xfs_verify_rtbno(mp, irec->br_startblock) ||
> -	     !xfs_verify_rtbno(mp, end)))
> +	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  	if (!info->is_rt &&
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 76e4ffe0315b..d409ca592178 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -52,9 +52,7 @@ xchk_rtbitmap_rec(
>  	startblock = rec->ar_startext * tp->t_mountp->m_sb.sb_rextsize;
>  	blockcount = rec->ar_extcount * tp->t_mountp->m_sb.sb_rextsize;
>  
> -	if (startblock + blockcount <= startblock ||
> -	    !xfs_verify_rtbno(sc->mp, startblock) ||
> -	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
> +	if (!xfs_verify_rtext(sc->mp, startblock, blockcount))
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
>  	return 0;
>  }
> 

