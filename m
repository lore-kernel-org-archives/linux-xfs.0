Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52520C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE9C61378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhEZMfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 08:35:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233220AbhEZMff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 08:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622032443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YZLrqiiuBxMArts2y89y8Urd6IbDx7SCsrZsEZwPzB8=;
        b=eG55I3mxWlvks9fU9JWiKen2mJF6ic9UzaQkBVQu/t9ysHWONtnMFrjB3vux0PtDBiik6r
        kzHVl++ZFGwmZyyTmCG98LIxel1oYXCKygeZalReuLBvh3ShLtQIP2nQSEOwQ7ExBnm3mk
        Hav2buOZkC/ImKdl8HJmc3wova/gD9w=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-TOlDVbi1OViZmyAqu3U2Bw-1; Wed, 26 May 2021 08:34:01 -0400
X-MC-Unique: TOlDVbi1OViZmyAqu3U2Bw-1
Received: by mail-qt1-f200.google.com with SMTP id o15-20020a05622a138fb02901e0ac29f6b2so575850qtk.11
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 05:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YZLrqiiuBxMArts2y89y8Urd6IbDx7SCsrZsEZwPzB8=;
        b=Cz3Osx9fOfmmoOcRdR+Gxk6BskVDMWM02HsbmP4YLCVSFGSk3vuuWwfge8a43voxHK
         8BUpZ/+bZuWS/oPNz86mUrhybOhD8NMYi6OGrXykcbrsR0Syahr+wzNsJvYmV6X8nOaT
         0C1pPIIUpZp6NAjfWzFFptJGpgp+bj+fEd7hrMUs2uH0Gp5l3Lid0uR94L9DV7HjV04i
         s92AkW1o1JOQe/9q1DdDhOU3ghz2U4tgsTklo06UmiCeglT52t8ZcELYKP8Khk+WSES5
         4NbRP7uCznC+9QcfB7075VnC1g6LoCP6fpt9kiPq8QzyV5vhciLGXsAXFVTuz2Dcrx/9
         uP0A==
X-Gm-Message-State: AOAM532PQ6uhVng4iVy1PwofYyRNyxUT6MAEtaADcHeNOTvcEViLfXQg
        mvpLxFrkn2wZLmX0WBtKlNy1VE8cbv5spaxRUsd98AdQ+j5qGyKVydoKjO/ZfLbqgZ/TofkfTsG
        GoWScau9Rhos9t2lRCy33
X-Received: by 2002:a05:620a:1252:: with SMTP id a18mr39919202qkl.416.1622032440959;
        Wed, 26 May 2021 05:34:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDNxXNm3tBBGhhcSQ08mI7vol1QO/D2Gy7hCQLxeVH3BfivbFTnZ2twzEvyb7VmfreUonmKA==
X-Received: by 2002:a05:620a:1252:: with SMTP id a18mr39919173qkl.416.1622032440682;
        Wed, 26 May 2021 05:34:00 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k9sm1497986qkh.11.2021.05.26.05.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:34:00 -0700 (PDT)
Date:   Wed, 26 May 2021 08:33:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/23] xfs: convert raw ag walks to use for_each_perag
Message-ID: <YK5ANsvJkEBWSD0K@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:20:44AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the raw walks to an iterator, pulling the current AG out of
> pag->pag_agno instead of the loop iterator variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_types.c |  4 ++-
>  fs/xfs/scrub/bmap.c       | 13 +++++----
>  fs/xfs/xfs_log_recover.c  | 55 ++++++++++++++++++---------------------
>  fs/xfs/xfs_reflink.c      |  9 ++++---
>  4 files changed, 43 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 04801362e1a7..e8f4abee7892 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -11,6 +11,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> +#include "xfs_ag.h"
>  
>  /* Find the size of the AG, in blocks. */
>  inline xfs_agblock_t
> @@ -222,12 +223,13 @@ xfs_icount_range(
>  	unsigned long long	*max)
>  {
>  	unsigned long long	nr_inos = 0;
> +	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  
>  	/* root, rtbitmap, rtsum all live in the first chunk */
>  	*min = XFS_INODES_PER_CHUNK;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +	for_each_perag(mp, agno, pag) {
>  		xfs_agino_t	first, last;
>  
>  		xfs_agino_range(mp, agno, &first, &last);
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index b5ebf1d1b4db..e457c086887f 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -22,6 +22,7 @@
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> +#include "xfs_ag.h"
>  
>  /* Set us up with an inode's bmap. */
>  int
> @@ -575,6 +576,7 @@ xchk_bmap_check_rmaps(
>  	int			whichfork)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
> +	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  	bool			zero_size;
>  	int			error;
> @@ -607,15 +609,16 @@ xchk_bmap_check_rmaps(
>  	    (zero_size || ifp->if_nextents > 0))
>  		return 0;
>  
> -	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> -		error = xchk_bmap_check_ag_rmaps(sc, whichfork, agno);
> +	for_each_perag(sc->mp, agno, pag) {
> +		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag->pag_agno);
>  		if (error)
> -			return error;
> +			break;
>  		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  			break;
>  	}
> -
> -	return 0;
> +	if (pag)
> +		xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fee2a4e80241..1227503d2246 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2742,21 +2742,17 @@ STATIC void
>  xlog_recover_process_iunlinks(
>  	struct xlog	*log)
>  {
> -	xfs_mount_t	*mp;
> -	xfs_agnumber_t	agno;
> -	xfs_agi_t	*agi;
> -	struct xfs_buf	*agibp;
> -	xfs_agino_t	agino;
> -	int		bucket;
> -	int		error;
> -
> -	mp = log->l_mp;
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	xfs_agino_t		agino;
> +	int			bucket;
> +	int			error;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		/*
> -		 * Find the agi for this ag.
> -		 */
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +	for_each_perag(mp, agno, pag) {
> +		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
>  		if (error) {
>  			/*
>  			 * AGI is b0rked. Don't process it.
> @@ -2782,7 +2778,7 @@ xlog_recover_process_iunlinks(
>  			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
>  			while (agino != NULLAGINO) {
>  				agino = xlog_recover_process_one_iunlink(mp,
> -							agno, agino, bucket);
> +						pag->pag_agno, agino, bucket);
>  				cond_resched();
>  			}
>  		}
> @@ -3494,27 +3490,28 @@ xlog_recover_cancel(
>   */
>  STATIC void
>  xlog_recover_check_summary(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xfs_mount_t	*mp;
> -	struct xfs_buf	*agfbp;
> -	struct xfs_buf	*agibp;
> -	xfs_agnumber_t	agno;
> -	uint64_t	freeblks;
> -	uint64_t	itotal;
> -	uint64_t	ifree;
> -	int		error;
> +	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_perag	*pag;
> +	struct xfs_buf		*agfbp;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno;
> +	uint64_t		freeblks;
> +	uint64_t		itotal;
> +	uint64_t		ifree;
> +	int			error;
>  
>  	mp = log->l_mp;
>  
>  	freeblks = 0LL;
>  	itotal = 0LL;
>  	ifree = 0LL;
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = xfs_read_agf(mp, NULL, agno, 0, &agfbp);
> +	for_each_perag(mp, agno, pag) {
> +		error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &agfbp);
>  		if (error) {
>  			xfs_alert(mp, "%s agf read failed agno %d error %d",
> -						__func__, agno, error);
> +						__func__, pag->pag_agno, error);
>  		} else {
>  			struct xfs_agf	*agfp = agfbp->b_addr;
>  
> @@ -3523,10 +3520,10 @@ xlog_recover_check_summary(
>  			xfs_buf_relse(agfbp);
>  		}
>  
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
>  		if (error) {
>  			xfs_alert(mp, "%s agi read failed agno %d error %d",
> -						__func__, agno, error);
> +						__func__, pag->pag_agno, error);
>  		} else {
>  			struct xfs_agi	*agi = agibp->b_addr;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f297d68a931b..0e430b0c1b16 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -755,16 +755,19 @@ int
>  xfs_reflink_recover_cow(
>  	struct xfs_mount	*mp)
>  {
> +	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return 0;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = xfs_refcount_recover_cow_leftovers(mp, agno);
> -		if (error)
> +	for_each_perag(mp, agno, pag) {
> +		error = xfs_refcount_recover_cow_leftovers(mp, pag->pag_agno);
> +		if (error) {
> +			xfs_perag_put(pag);
>  			break;
> +		}
>  	}
>  
>  	return error;
> -- 
> 2.31.1
> 

