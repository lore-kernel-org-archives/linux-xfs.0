Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779B7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 19:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbiDKTsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiDKTsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 15:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE55B2716E
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 12:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6CDDB81896
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 19:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D2FC385A4;
        Mon, 11 Apr 2022 19:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649706381;
        bh=JUxLfb5MTdpnC3R8O9b951rxEgGzYajmfnGybFwqJ9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VtckWmxAa32VVBVV+QKABOK1WCZWKGREDo0q5w0/X3Y5Y4oK1zjmaps5gnV4TRvaP
         ivkWRjJeHiQlH1QVECBa656LhHUqYfJTi9uFTnorTJWu9CJkU1E4vIyGXae+HtJpJZ
         /ABE0YMCitiem4HCaEo0yTiyhTUq5vtfOsO9PXseOqYgB4bKvRc6Ww4uNUL08ypiQf
         Xwdh3N5HJzdmttJO74S+GkrvTC+X8m6YKj/N1fGmhtADTt6gfTGvMzF6p4oZE+bXJs
         DchvPFl7ZElkizsyiSsRz5kNvI0OaLlsFVykYIb70KVthzUo33QSGXJ5zHu4RVh1Ro
         z8tTg/eejBEpg==
Date:   Mon, 11 Apr 2022 12:46:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: pass explicit mount pointer to rtalloc query
 functions
Message-ID: <20220411194620.GA16799@magnolia>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
 <164961486038.70555.14613665424255377303.stgit@magnolia>
 <20220411011725.GQ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411011725.GQ1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 11:17:25AM +1000, Dave Chinner wrote:
> On Sun, Apr 10, 2022 at 11:21:00AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Pass an explicit xfs_mount pointer to the rtalloc query functions so
> > that they can support transactionless queries.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Looks good, minor nit below.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 10e1cb71439e..e6677c690c1a 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -450,11 +450,11 @@ xfs_getfsmap_logdev(
> >  /* Transform a rtbitmap "record" into a fsmap */
> >  STATIC int
> >  xfs_getfsmap_rtdev_rtbitmap_helper(
> > +	struct xfs_mount		*mp,
> >  	struct xfs_trans		*tp,
> >  	const struct xfs_rtalloc_rec	*rec,
> >  	void				*priv)
> >  {
> > -	struct xfs_mount		*mp = tp->t_mountp;
> >  	struct xfs_getfsmap_info	*info = priv;
> >  	struct xfs_rmap_irec		irec;
> >  	xfs_daddr_t			rec_daddr;
> > @@ -535,7 +535,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
> >  	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
> >  	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
> >  		ahigh.ar_startext++;
> > -	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
> > +	error = xfs_rtalloc_query_range(tp->t_mountp, tp, &alow, &ahigh,
> 
> This can be mp rather than tp->t_mountp, right?

Yup.  Would you mind fixing that up on commit, please?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
