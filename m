Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E40AC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBFFB61927
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhEKMbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 08:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhEKMbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 08:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ww3K3WM67+eEMbgyDET062EPl6b95TZ73R/VuQ8RNwY=;
        b=Kz9UjulqVwJp3pNg4wevgW3sMPSwecD76UeqeFuFL1wBX6SOGMx4sWbMqckzQc0MM5q7Ov
        RNwqjfAYirMjKwv6eo3pcPZjt/rxGBjiNS592CIhjV3PkKui3CgG7ZHblElDzxpjqihain
        YNmh30dqyuQuYatDZM7UG+7angAarJo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-bzVMEJ_hMoSxKMUkrp95VA-1; Tue, 11 May 2021 08:29:57 -0400
X-MC-Unique: bzVMEJ_hMoSxKMUkrp95VA-1
Received: by mail-qt1-f197.google.com with SMTP id o5-20020ac872c50000b02901c32e7e3c21so12898316qtp.8
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 05:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ww3K3WM67+eEMbgyDET062EPl6b95TZ73R/VuQ8RNwY=;
        b=e80MXrSKHnpQcmPyQ/pGWCIJffix3Tl6Nj9u1SCpsaiEbxcKbieD1repx4d+t7Y13l
         yu9iBOlQeOODwz+eCE8Q7/LQIkiNXptXzFEROaGF3rhoesdVagLIT5EKz5Ze8U5p+B3T
         CUsxV7LZdIAQugyd3IX0lj0smLxf7qlsk7kCl74d7mx08hDnnpRlJgFip32/mfeQhpCZ
         Cjiby/yqysbK+X6ld49sa2gh39mPegXY+Ikmb+bZJmqK33jpnFcTRD4cmt/oNQhFsuXW
         w3/iUwMHpMYsKebLXk9s7JZdoa1fRhBVbHbRMDnPeUklzlSx9+ckA4y6Px7oieYFu0ja
         aMmg==
X-Gm-Message-State: AOAM531j8YLdLOhFIZPEXhGCYr0NDS6ziVA7m9M711li2EwqTD9gaTA7
        yqGUbul7p16VgfXQUnSjzR90x0z0Ns72G4yAc9lObILco/RGw53ZcM92wJtUx6LCcap+joxx6FV
        tEM/VoACAaWMHjYTGqW6/
X-Received: by 2002:a0c:c447:: with SMTP id t7mr29206566qvi.60.1620736196488;
        Tue, 11 May 2021 05:29:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3Mnq86niS+uUFU4VGzfy5G5Xe9RbSpFxPi4P/40Oll+p9uceweNC4GKLG36GyINu0u/MtLw==
X-Received: by 2002:a0c:c447:: with SMTP id t7mr29206553qvi.60.1620736196289;
        Tue, 11 May 2021 05:29:56 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id g64sm13655496qkf.41.2021.05.11.05.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:29:56 -0700 (PDT)
Date:   Tue, 11 May 2021 08:29:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/22] xfs: push perags through the ag reservation
 callouts
Message-ID: <YJp4wmJaA1GeEbW0@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently pass an agno from the AG reservation functions to the
> individual feature accounting functions, which then may have to do
> perag lookups to access per-AG state. Plumb the perag through from
> the highest AG reservation layer to the feature callouts so they
> don't have to look it up again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

The changes look fine, but the commit log implies we're relieving some
lower level functions of the need to re-look up perag structs. I don't
see one perag get/put cycle being removed here, so I suppose either that
comes later or the commit log is a bit misleading..? Either way, with a
minor reword of the commit log to clarify that, this otherwise looks
fine to me.

Brian

>  fs/xfs/libxfs/xfs_ag_resv.c        |  9 ++++-----
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 17 +++++++++--------
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |  2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |  7 +++----
>  fs/xfs/libxfs/xfs_refcount_btree.h |  3 ++-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  6 +++---
>  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
>  7 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2e3dcdfd4984..f7394a8ecf6b 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -250,7 +250,6 @@ xfs_ag_resv_init(
>  	struct xfs_trans		*tp)
>  {
>  	struct xfs_mount		*mp = pag->pag_mount;
> -	xfs_agnumber_t			agno = pag->pag_agno;
>  	xfs_extlen_t			ask;
>  	xfs_extlen_t			used;
>  	int				error = 0, error2;
> @@ -260,11 +259,11 @@ xfs_ag_resv_init(
>  	if (pag->pag_meta_resv.ar_asked == 0) {
>  		ask = used = 0;
>  
> -		error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask, &used);
> +		error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask, &used);
>  		if (error)
>  			goto out;
>  
> -		error = xfs_finobt_calc_reserves(mp, tp, agno, &ask, &used);
> +		error = xfs_finobt_calc_reserves(mp, tp, pag, &ask, &used);
>  		if (error)
>  			goto out;
>  
> @@ -282,7 +281,7 @@ xfs_ag_resv_init(
>  
>  			mp->m_finobt_nores = true;
>  
> -			error = xfs_refcountbt_calc_reserves(mp, tp, agno, &ask,
> +			error = xfs_refcountbt_calc_reserves(mp, tp, pag, &ask,
>  					&used);
>  			if (error)
>  				goto out;
> @@ -300,7 +299,7 @@ xfs_ag_resv_init(
>  	if (pag->pag_rmapbt_resv.ar_asked == 0) {
>  		ask = used = 0;
>  
> -		error = xfs_rmapbt_calc_reserves(mp, tp, agno, &ask, &used);
> +		error = xfs_rmapbt_calc_reserves(mp, tp, pag, &ask, &used);
>  		if (error)
>  			goto out;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 4c5831646bd9..4ec8ea1331a5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  STATIC int
>  xfs_inobt_get_minrecs(
> @@ -680,7 +681,7 @@ static int
>  xfs_inobt_count_blocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_btnum_t		btnum,
>  	xfs_extlen_t		*tree_blocks)
>  {
> @@ -688,7 +689,7 @@ xfs_inobt_count_blocks(
>  	struct xfs_btree_cur	*cur = NULL;
>  	int			error;
>  
> -	error = xfs_inobt_cur(mp, tp, agno, btnum, &cur, &agbp);
> +	error = xfs_inobt_cur(mp, tp, pag->pag_agno, btnum, &cur, &agbp);
>  	if (error)
>  		return error;
>  
> @@ -704,14 +705,14 @@ static int
>  xfs_finobt_read_blocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_extlen_t		*tree_blocks)
>  {
>  	struct xfs_buf		*agbp;
>  	struct xfs_agi		*agi;
>  	int			error;
>  
> -	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> +	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
>  	if (error)
>  		return error;
>  
> @@ -728,7 +729,7 @@ int
>  xfs_finobt_calc_reserves(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
>  {
> @@ -739,14 +740,14 @@ xfs_finobt_calc_reserves(
>  		return 0;
>  
>  	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> -		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
> +		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
>  	else
> -		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
> +		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
>  				&tree_len);
>  	if (error)
>  		return error;
>  
> -	*ask += xfs_inobt_max_size(mp, agno);
> +	*ask += xfs_inobt_max_size(mp, pag->pag_agno);
>  	*used += tree_len;
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index 35bbd978c272..d5afe01fb2de 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -64,7 +64,7 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
>  #endif	/* DEBUG */
>  
>  int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
> -		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
> +		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
>  extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
>  int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index b281f0c674f5..c4ddf9ded00b 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -450,7 +450,7 @@ int
>  xfs_refcountbt_calc_reserves(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
>  {
> @@ -463,8 +463,7 @@ xfs_refcountbt_calc_reserves(
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return 0;
>  
> -
> -	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> +	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
>  	if (error)
>  		return error;
>  
> @@ -479,7 +478,7 @@ xfs_refcountbt_calc_reserves(
>  	 * expansion.  We therefore can pretend the space isn't there.
>  	 */
>  	if (mp->m_sb.sb_logstart &&
> -	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
>  		agblocks -= mp->m_sb.sb_logblocks;
>  
>  	*ask += xfs_refcountbt_max_size(mp, agblocks);
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index 69dc515db671..eab1b0c672c0 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -13,6 +13,7 @@
>  struct xfs_buf;
>  struct xfs_btree_cur;
>  struct xfs_mount;
> +struct xfs_perag;
>  struct xbtree_afakeroot;
>  
>  /*
> @@ -58,7 +59,7 @@ extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp,
>  		xfs_agblock_t agblocks);
>  
>  extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
> -		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
> +		struct xfs_trans *tp, struct xfs_perag *pag, xfs_extlen_t *ask,
>  		xfs_extlen_t *used);
>  
>  void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 46a5295ecf35..ba2f7064451b 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -595,7 +595,7 @@ int
>  xfs_rmapbt_calc_reserves(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> +	struct xfs_perag	*pag,
>  	xfs_extlen_t		*ask,
>  	xfs_extlen_t		*used)
>  {
> @@ -608,7 +608,7 @@ xfs_rmapbt_calc_reserves(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return 0;
>  
> -	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> +	error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0, &agbp);
>  	if (error)
>  		return error;
>  
> @@ -623,7 +623,7 @@ xfs_rmapbt_calc_reserves(
>  	 * expansion.  We therefore can pretend the space isn't there.
>  	 */
>  	if (mp->m_sb.sb_logstart &&
> -	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == pag->pag_agno)
>  		agblocks -= mp->m_sb.sb_logblocks;
>  
>  	/* Reserve 1% of the AG or enough for 1 block per record. */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 115c3455a734..57fab72e26ad 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -57,6 +57,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
>  		xfs_agblock_t agblocks);
>  
>  extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
> -		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
> +		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
>  
>  #endif	/* __XFS_RMAP_BTREE_H__ */
> -- 
> 2.31.1
> 

