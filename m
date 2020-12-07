Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA20C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE5121D42
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgLGRry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:47:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgLGRry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607363187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tWexjcj9RuEy/k5UqwBL0kkZ/F5rTI1aCFV0SsE7X+A=;
        b=RyBpC0y7yNgFrvv/ajwDaS/Xh8fMsd7dcajXp9pEYQSbfncTmCLw+jVQ71hgnTTIqm6WIo
        e9TQaZ20zos0TOEO2zNYdWrqNMlK6H4cW4IcfCf64aciqaGl6IUcFW0Vq4JWRUxHBJazSd
        1DUJzOmzF9UoWTpP2xMygaHwrNpPIhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-14A-uEZsORuJuasbO7QN1w-1; Mon, 07 Dec 2020 12:46:25 -0500
X-MC-Unique: 14A-uEZsORuJuasbO7QN1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AFAC809DCD;
        Mon,  7 Dec 2020 17:46:24 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 468C9648A2;
        Mon,  7 Dec 2020 17:46:24 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:46:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: refactor file range validation
Message-ID: <20201207174622.GD1598552@bfoster>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729626928.1608297.12355625902682243490.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729626928.1608297.12355625902682243490.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:11:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded validation of file block ranges into a
> single helper, and teach the bmap scrubber to check the ranges.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c  |    2 +-
>  fs/xfs/libxfs/xfs_types.c |   25 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_types.h |    3 +++
>  fs/xfs/scrub/bmap.c       |    4 ++++
>  fs/xfs/xfs_bmap_item.c    |    2 +-
>  fs/xfs/xfs_rmap_item.c    |    2 +-
>  6 files changed, 35 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7bcf498ef6b2..dcf56bcafb8f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6227,7 +6227,7 @@ xfs_bmap_validate_extent(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
> +	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
>  		return __this_address;
>  
>  	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 7b310eb296b7..b254fbeaaa50 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -258,3 +258,28 @@ xfs_verify_dablk(
>  
>  	return dabno <= max_dablk;
>  }
> +
> +/* Check that a file block offset does not exceed the maximum. */
> +bool
> +xfs_verify_fileoff(
> +	struct xfs_mount	*mp,
> +	xfs_fileoff_t		off)
> +{
> +	return off <= XFS_MAX_FILEOFF;
> +}
> +
> +/* Check that a range of file block offsets do not exceed the maximum. */
> +bool
> +xfs_verify_fileext(
> +	struct xfs_mount	*mp,
> +	xfs_fileoff_t		off,
> +	xfs_fileoff_t		len)
> +{
> +	if (off + len <= off)
> +		return false;
> +
> +	if (!xfs_verify_fileoff(mp, off))
> +		return false;
> +
> +	return xfs_verify_fileoff(mp, off + len - 1);
> +}
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 18e83ce46568..064bd6e8c922 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -203,5 +203,8 @@ bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
>  bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
>  void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
>  		unsigned long long *max);
> +bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
> +bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
> +		xfs_fileoff_t len);
>  
>  #endif	/* __XFS_TYPES_H__ */
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index cce8ac7d3973..bce4421acdb9 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -329,6 +329,10 @@ xchk_bmap_iextent(
>  		xchk_fblock_set_corrupt(info->sc, info->whichfork,
>  				irec->br_startoff);
>  
> +	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
> +		xchk_fblock_set_corrupt(info->sc, info->whichfork,
> +				irec->br_startoff);
> +
>  	xchk_bmap_dirattr_extent(ip, info, irec);
>  
>  	/* There should never be a "hole" extent in either extent list. */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 5c9706760e68..9a2e54b7ccb9 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -449,7 +449,7 @@ xfs_bui_validate(
>  	if (!xfs_verify_ino(mp, bmap->me_owner))
>  		return false;
>  
> -	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
> +	if (!xfs_verify_fileext(mp, bmap->me_startoff, bmap->me_len))
>  		return false;
>  
>  	return xfs_verify_fsbext(mp, bmap->me_startblock, bmap->me_len);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4fa875237422..49cebd68b672 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -490,7 +490,7 @@ xfs_rui_validate_map(
>  	    !xfs_verify_ino(mp, rmap->me_owner))
>  		return false;
>  
> -	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
> +	if (!xfs_verify_fileext(mp, rmap->me_startoff, rmap->me_len))
>  		return false;
>  
>  	return xfs_verify_fsbext(mp, rmap->me_startblock, rmap->me_len);
> 

