Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833ABC43461
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5644361430
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhEJNlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 09:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349919AbhEJMza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 08:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620651264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zlHm0JAEEYq3+z8cJq1s49iSO75EPtNXEvMhA6Ddqws=;
        b=fVEuXXFkKcWsEfxfNFipqcopFEMvIull98hexZkJvlHF/NEBWa0JXFgBVujZugmwX2sYeV
        vPRtDvhDwvZR/K82C2XU/mGekaQ71THdWEchrcD85VcRDjmMCKAi0Ur6xxd6OjttdtcRWj
        Os+MgXKjzdMQ+JsrgLw3TZMWZgcASQM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-o5Z-F-UMP7eEqhJPsbUIqw-1; Mon, 10 May 2021 08:54:23 -0400
X-MC-Unique: o5Z-F-UMP7eEqhJPsbUIqw-1
Received: by mail-qt1-f197.google.com with SMTP id g21-20020ac86f150000b02901c94e794dd7so10304509qtv.7
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 05:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zlHm0JAEEYq3+z8cJq1s49iSO75EPtNXEvMhA6Ddqws=;
        b=herG+sKdl/buOQpUJnt0it7cG4YRcgJka+voExoxNEwdtsKylK3K4GNTUFgGQW7IW+
         XVe1+2v+xZVnTo2iarlYP7SaU1Rru+qqjw8eCppRRDgk7xGmAzUCu4vGqBD3IowX+LGO
         Qlya3mtp2pPc+4qPTj1CYM3NhN92uZMvrHirgyos4BsovDGro0mvjTGnF+pnwxTWx4aY
         qbReuDSvZYHVZ75e21ttgGheX2yX+V3BkPak9r6cK1VsKGduPyhqA1+O5a/Z3leVRx6N
         q3/8lFVOvCDvKVgVcEpDZgr3fll4aXFI606MMxDzx/nbe8v44FuZMugG5++WMl4GJa+7
         xsKg==
X-Gm-Message-State: AOAM53344WbHqyEc0CjJIzcVDi/Tk0gl3/yXroBRpXVV6EBzPJipn54e
        i7z3j/EYNKvrylp3kCE/l9P+bKUPQDnF2E8elbjOP400goBEOqv8eXzSCQnOW03yyUr6do9nmv+
        yw/Tt3Iqw0R8bX96SlFDm
X-Received: by 2002:a37:62cf:: with SMTP id w198mr22266646qkb.126.1620651262548;
        Mon, 10 May 2021 05:54:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGUAevHiyfjgOaE5mZCPKhO6GMZis2jyx4iel1rg/2KgL/vzl+FfNeMYkJM5EE1iI6WmeqrQ==
X-Received: by 2002:a37:62cf:: with SMTP id w198mr22266624qkb.126.1620651262347;
        Mon, 10 May 2021 05:54:22 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id v11sm11018515qtx.79.2021.05.10.05.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 05:54:22 -0700 (PDT)
Date:   Mon, 10 May 2021 08:54:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/22] xfs: convert raw ag walks to use for_each_perag
Message-ID: <YJks/GFifrdeZVMU@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:37PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the raw walks to an iterator, pulling the current AG out of
> pag->pag_agno instead of the loop iterator variable.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_types.c |  4 ++-
>  fs/xfs/scrub/bmap.c       |  6 +++--
>  fs/xfs/xfs_log_recover.c  | 55 ++++++++++++++++++---------------------
>  fs/xfs/xfs_reflink.c      |  9 ++++---
>  4 files changed, 39 insertions(+), 35 deletions(-)
> 
...
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index b5ebf1d1b4db..c60a1990d629 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
...
> @@ -607,8 +609,8 @@ xchk_bmap_check_rmaps(
>  	    (zero_size || ifp->if_nextents > 0))
>  		return 0;
>  
> -	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> -		error = xchk_bmap_check_ag_rmaps(sc, whichfork, agno);
> +	for_each_perag(sc->mp, agno, pag) {
> +		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag->pag_agno);
>  		if (error)
>  			return error;

It looks like this loop is missing xfs_perag_put() early breakout
treatment. The rest of the patch LGTM.

Brian

>  		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
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

