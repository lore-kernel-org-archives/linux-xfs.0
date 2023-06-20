Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA911EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 05:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjFTFrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 01:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjFTFrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 01:47:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E50120
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 22:47:12 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-25e836b733eso2163661a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 22:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687240031; x=1689832031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bs4HgfeqjgJt5nfZJr9dS3obRKN7AF2do59UTgm42Z4=;
        b=GWlkwYlzXExP8E6L0UAF0jGJDgm9vEnntYbKZOr+a2b3ErGtoW0W0ysHI4XvsRFUGc
         f5VhiobwLyeNgmqBd9t+o48UfB/djqczUPUK3hSX1wM5hCsMLQ4cdrZ5wYEmjVXmIIB3
         WPISWkOSQUgUTwnKB83WHtXjGyOWGmVhPx0kOlxqhXFvVkTQyefYHrSKL4854i37qN4B
         0SAR/b99QR5I20bMXf6eIAfTr8iZVrjyaosJKQmvP8MJjJCnV+JOW5s43F82PAdDWDEe
         NygNqQzv68PAyDmQ8B/wzfDphGH/usX807zPoHseAcMK1RvVThB76pydeZJOJYEs/Zj0
         muag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687240031; x=1689832031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bs4HgfeqjgJt5nfZJr9dS3obRKN7AF2do59UTgm42Z4=;
        b=XuhYFkah24wKALnHRo/+5ekGk6mXlrSMmTr3/Gg77ECprAVBpW+k6fS4BjOBgS4fea
         zTiREOjO7WXYbnp+52vMp/N0IvR2hIcEAWHHlg/3jrBR9axgo65KRZFZgwoAYRyGpMLg
         dED/FMODu4DPc7mxf4PI1gM19v71bRJ9ywIPmZ1j2dNPS4KPzlsQG/2PEyYnjsF1JGX8
         AZYKlBuMLukO6gX32Aq1GGU7BqoZ8GE8R8kBOpc38IcNe//zkgPc/xHi9dFk3jZyzBlD
         gv4psuoWC4K3DzCZ2oqnLC7OezWpH5V+78j6i6UikwddAeJcdtGvTRLvIeb+V4jryiOU
         4dNA==
X-Gm-Message-State: AC+VfDzAQf06Fln5s9oLYXIkMCVQkudBPf9EVdX1XxnpWc9+S1vju+4B
        LOsCxSSNnZs/pGvdLq5gurfmKDHD/NKDw462up8=
X-Google-Smtp-Source: ACHHUZ7cB2FcpYfViv5BTYL0g/30ZwbVk/EjxZH5ei3GJ97IbJelegcqHR5DuFlTFGyMIP0WfyeSwA==
X-Received: by 2002:a17:90a:c087:b0:25e:91ef:8b24 with SMTP id o7-20020a17090ac08700b0025e91ef8b24mr7653880pjs.24.1687240031510;
        Mon, 19 Jun 2023 22:47:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id q21-20020a170902b11500b001b414fae374sm681613plr.291.2023.06.19.22.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 22:47:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBUCq-00DwEa-0I;
        Tue, 20 Jun 2023 15:47:08 +1000
Date:   Tue, 20 Jun 2023 15:47:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: reap large AG metadata extents when possible
Message-ID: <ZJE9XO9cFBDGbr/8@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055733.3728180.3134566782464969180.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506055733.3728180.3134566782464969180.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:45:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're freeing extents that have been set in a bitmap, break the
> bitmap extent into multiple sub-extents organized by fate, and reap the
> extents.  This enables us to dispose of old resources more efficiently
> than doing them block by block.
> 
> While we're at it, rename the reaping functions to make it clear that
> they're reaping per-AG extents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

.....
> +xreap_agextent_binval(
> +	struct xreap_state	*rs,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		*aglenp)
>  {
> -	struct xfs_buf		*bp = NULL;
> -	int			error;
> +	struct xfs_scrub	*sc = rs->sc;
> +	struct xfs_perag	*pag = sc->sa.pag;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
> +	xfs_agblock_t		agbno_next = agbno + *aglenp;
> +	xfs_agblock_t		bno = agbno;
>  
>  	/*
> -	 * If there's an incore buffer for exactly this block, invalidate it.
>  	 * Avoid invalidating AG headers and post-EOFS blocks because we never
>  	 * own those.
>  	 */
> -	if (!xfs_verify_fsbno(sc->mp, fsbno))
> +	if (!xfs_verify_agbno(pag, agbno) ||
> +	    !xfs_verify_agbno(pag, agbno_next - 1))
>  		return;
>  
>  	/*
> -	 * We assume that the lack of any other known owners means that the
> -	 * buffer can be locked without risk of deadlocking.
> +	 * If there are incore buffers for these blocks, invalidate them.  We
> +	 * assume that the lack of any other known owners means that the buffer
> +	 * can be locked without risk of deadlocking.  The buffer cache cannot
> +	 * detect aliasing, so employ nested loops to scan for incore buffers
> +	 * of any plausible size.
>  	 */
> -	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> -			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> -			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> -	if (error)
> -		return;
> -
> -	xfs_trans_bjoin(sc->tp, bp);
> -	xfs_trans_binval(sc->tp, bp);
> +	while (bno < agbno_next) {
> +		xfs_agblock_t	fsbcount;
> +		xfs_agblock_t	max_fsbs;
> +
> +		/*
> +		 * Max buffer size is the max remote xattr buffer size, which
> +		 * is one fs block larger than 64k.
> +		 */
> +		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
> +				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
> +
> +		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
> +			struct xfs_buf	*bp = NULL;
> +			xfs_daddr_t	daddr;
> +			int		error;
> +
> +			daddr = XFS_AGB_TO_DADDR(mp, agno, bno);
> +			error = xfs_buf_incore(mp->m_ddev_targp, daddr,
> +					XFS_FSB_TO_BB(mp, fsbcount),
> +					XBF_BCACHE_SCAN, &bp);
> +			if (error)
> +				continue;
> +
> +			xfs_trans_bjoin(sc->tp, bp);
> +			xfs_trans_binval(sc->tp, bp);
> +			rs->invalidated++;

Hmmm. O(N^2) brute force lookup walk to find any buffer at that
specific daddr?  That's going to have an impact on running systems
by hammering the perag hash lock.

I didn't know this was being done before I suggested XBF_ANY_MATCH,
but now I'm wondering how can we even have multiple buffers in the
cache at a given address? The whole point of the ASSERT() in the
match function is to indicate this should not ever happen.

i.e. xfs_buf_find_insert() uses rhashtable_lookup_get_insert_fast(),
which will return an existing buffer only if it has a match length.
The compare function used at insert time will throw an assert fail
if any other buffer exists at that address that has a mismatched
length that is not stale. There is no way to avoid that ASSERT check
on insert.

Hence, AFAICT, the only way we can get multiple buffers into the
cache at the same daddr with different lengths is for all the
existing buffers at that daddr to all be stale at insert time.  In
which case, why do we need to invalidate buffers that are already
stale (i.e. been invalidated)?

What am I missing here? i.e. this appears to cater for behaviour
that doesn't currently exist in the buffer cache, and I'm not sure
we even want to allow to occur in the buffer cache given that it
generally indicates in-memory metadata corruption.....

Hmmmm. What if the buffer was already stale? The lookup will then
clear all the stale state from it, leave it with no valid contents
which we then invalidate again and log a new buffer cancel item for
it. What are the implications of that? (My brain is too full of
stuff trying to understand what this code is doing to be able to
think this through right now.)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
