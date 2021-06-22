Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B01AC2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 03:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F85611AF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 03:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFVDhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 23:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhFVDhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 23:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C856124B;
        Tue, 22 Jun 2021 03:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624332889;
        bh=5AwhVSLjpalY9feo88Wf3fH4kyPDFIm7liHncMv69m0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YEo38MBF+4IrZJCGYxLSMr71pbYazVDeZXjXa9q4tOFdgNyiANQ5ypgdqJTULr9eJ
         WYqbqFuyDQV2dWsXAo3ZmzYWgftfVmLCfAe9ZW1c0GdMG7Lmv9nZ3ldqExCfvu9qV3
         rEnCmMRjxtwCVQbeA1wB4w0E2wZ4JZiBSUjJPHs6yWvyUnxZ9xqv3vakcDWEEk9DRy
         21BV321lxq4tiF6Mfk5wPUJszdP24q8ONxLXbx73EyEMtaMZj0xxAqtMf60bq1XqGM
         5kzBHCA7CghEEWkOaeNCsNJyY67W2mucB4/0L5Q4yYHvqzVeFmNMHR+4UjF8lFJHoF
         MfkmaboZOephA==
Date:   Mon, 21 Jun 2021 20:34:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix endianness issue in xfs_ag_shrink_space
Message-ID: <20210622033449.GG3619569@locust>
References: <20210621223436.GF3619569@locust>
 <20210621231719.GX664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621231719.GX664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 09:17:19AM +1000, Dave Chinner wrote:
> On Mon, Jun 21, 2021 at 03:34:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The AGI buffer is in big-endian format, so we must convert the
> > endianness to CPU format to do any comparisons.
> > 
> > Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index c68a36688474..afff2ab7e9f1 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -510,6 +510,7 @@ xfs_ag_shrink_space(
> >  	struct xfs_buf		*agibp, *agfbp;
> >  	struct xfs_agi		*agi;
> >  	struct xfs_agf		*agf;
> > +	xfs_agblock_t		aglen;
> >  	int			error, err2;
> >  
> >  	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> > @@ -524,14 +525,14 @@ xfs_ag_shrink_space(
> >  		return error;
> >  
> >  	agf = agfbp->b_addr;
> > +	aglen = be32_to_cpu(agi->agi_length);
> >  	/* some extra paranoid checks before we shrink the ag */
> >  	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> >  		return -EFSCORRUPTED;
> > -	if (delta >= agi->agi_length)
> > +	if (delta >= aglen)
> >  		return -EINVAL;
> >  
> > -	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> > -				    be32_to_cpu(agi->agi_length) - delta);
> > +	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> FWIW, my plan for this stuff is to move the perag geometry stuff
> into the xfs_perag. That gets rid of all this "need the on disk
> buffer to get AG size" stuff. It also avoids having to calculate
> valid ranges of types on every verify call (expensive) because, at
> most per-ag type verifier call sites, we already have the perag on
> hand...

woo!

--D

> Cheers,
> -- 
> Dave Chinner
> david@fromorbit.com
