Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E36C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 16:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3111A610CC
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 16:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhHMQQt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhHMQQs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Aug 2021 12:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED88C601FA;
        Fri, 13 Aug 2021 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628871382;
        bh=80phKlIywnBAWok3CEUnZINoEWdAUB937Tg87OJYNUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jxdTIzfaj4eJa5b0/Ssih7C6oSOywZ6D+6vl5ttcLyIJ96DbVRMRNOtxoZyPFFAZv
         zm1tiXOCUAI82hI6RxEdz9VScUnfOQ6KJgxJvZvXzrIDW0iSKT1ByOjoUSuKjPY6XF
         5XcNVyly9oXd890v8E4IXDsPWLj7bSNbTH+qfLb3AgKgCbOCH7mOYQRXbDiOgeC3EV
         NP2EBAYhlsV7DlG8KKZg70TXBpGeNGhGvA7hdt+cT/kKdaAy2Zp9WBv3YDyPg+mTuw
         cq0+MDRmUd70aKu4Z3eO1aTSs/rvt0FqvA4filLYOkPWUC8AIZZciCoW+iW9LpWEQ5
         6W9VaqUqImMeA==
Date:   Fri, 13 Aug 2021 09:16:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix off-by-one error when the last rt extent is
 in use
Message-ID: <20210813161621.GW3601443@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872992772.1220643.10308054638747493338.stgit@magnolia>
 <87fsvdlijp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsvdlijp.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 04:20:34PM +0530, Chandan Babu R wrote:
> On 11 Aug 2021 at 17:58, "Darrick J. Wong" <djwong@kernel.org> wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > The fsmap implementation for realtime devices uses the gap between
> > info->next_daddr and a free rtextent reported by xfs_rtalloc_query_range
> > to feed userspace fsmap records with an "unknown" owner.  We use this
> > trick to report to userspace when the last rtextent in the filesystem is
> > in use by synthesizing a null rmap record starting at the next block
> > after the query range.
> >
> > Unfortunately, there's a minor accounting bug in the way that we
> > construct the null rmap record.  Originally, ahigh.ar_startext contains
> > the last rtextent for which the user wants records.  It's entirely
> > possible that number is beyond the end of the rt volume, so the location
> > synthesized rmap record /must/ be constrained to the minimum of the high
> > key and the number of extents in the rt volume.
> >
> 
> When the number of blocks on the realtime device is not an integral multiple
> of xfs_sb->sb_rextsize, ahigh.ar_startext can contain a value which is one
> more than the highest valid rtextent. Hence, without this patch, the last
> record reported to the userpace might contain an invalid upper bound. Assuming
> that my understanding is indeed correct,

Correct.  Thanks for reviewing this!

--D

> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsmap.c |   22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> >
> > diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> > index 7d0b09c1366e..a0e8ab58124b 100644
> > --- a/fs/xfs/xfs_fsmap.c
> > +++ b/fs/xfs/xfs_fsmap.c
> > @@ -523,27 +523,39 @@ xfs_getfsmap_rtdev_rtbitmap_query(
> >  {
> >  	struct xfs_rtalloc_rec		alow = { 0 };
> >  	struct xfs_rtalloc_rec		ahigh = { 0 };
> > +	struct xfs_mount		*mp = tp->t_mountp;
> >  	int				error;
> >  
> > -	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> > +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
> >  
> > +	/*
> > +	 * Set up query parameters to return free extents covering the range we
> > +	 * want.
> > +	 */
> >  	alow.ar_startext = info->low.rm_startblock;
> > +	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
> > +
> >  	ahigh.ar_startext = info->high.rm_startblock;
> > -	do_div(alow.ar_startext, tp->t_mountp->m_sb.sb_rextsize);
> > -	if (do_div(ahigh.ar_startext, tp->t_mountp->m_sb.sb_rextsize))
> > +	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
> >  		ahigh.ar_startext++;
> > +
> >  	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
> >  			xfs_getfsmap_rtdev_rtbitmap_helper, info);
> >  	if (error)
> >  		goto err;
> >  
> > -	/* Report any gaps at the end of the rtbitmap */
> > +	/*
> > +	 * Report any gaps at the end of the rtbitmap by simulating a null
> > +	 * rmap starting at the block after the end of the query range.
> > +	 */
> >  	info->last = true;
> > +	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
> > +
> >  	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
> >  	if (error)
> >  		goto err;
> >  err:
> > -	xfs_iunlock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> > +	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
> >  	return error;
> >  }
> >  
> 
> 
> -- 
> chandan
