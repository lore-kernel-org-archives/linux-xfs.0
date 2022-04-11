Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A66C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiDKBTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiDKBTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:19:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D094728E
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:17:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 20DB510CEDAB;
        Mon, 11 Apr 2022 11:17:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndigH-00GFAt-24; Mon, 11 Apr 2022 11:17:25 +1000
Date:   Mon, 11 Apr 2022 11:17:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: pass explicit mount pointer to rtalloc query
 functions
Message-ID: <20220411011725.GQ1544202@dread.disaster.area>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
 <164961486038.70555.14613665424255377303.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164961486038.70555.14613665424255377303.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625381a6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=9z5-8WLzsSaswSXiLiUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 11:21:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pass an explicit xfs_mount pointer to the rtalloc query functions so
> that they can support transactionless queries.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good, minor nit below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 10e1cb71439e..e6677c690c1a 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -450,11 +450,11 @@ xfs_getfsmap_logdev(
>  /* Transform a rtbitmap "record" into a fsmap */
>  STATIC int
>  xfs_getfsmap_rtdev_rtbitmap_helper(
> +	struct xfs_mount		*mp,
>  	struct xfs_trans		*tp,
>  	const struct xfs_rtalloc_rec	*rec,
>  	void				*priv)
>  {
> -	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_getfsmap_info	*info = priv;
>  	struct xfs_rmap_irec		irec;
>  	xfs_daddr_t			rec_daddr;
> @@ -535,7 +535,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
>  	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
>  	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
>  		ahigh.ar_startext++;
> -	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
> +	error = xfs_rtalloc_query_range(tp->t_mountp, tp, &alow, &ahigh,

This can be mp rather than tp->t_mountp, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
