Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F647C43219
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 21:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJNVrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiJNVrH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 17:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5A51D1A8F
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 14:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C775B82415
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 21:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD82C433D6;
        Fri, 14 Oct 2022 21:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665783974;
        bh=unbCKnWzyhraygPK6QjSVxTSi2U78iFWWhzaTTOKqMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Inc7pYDyHCs/Ro6+QuyFiITyKBooy5A4dOp0s8rYOYqWijMmu0UBmm/JYGcbmRcMo
         4ktfHrLUFykhv6dNv3KIi524S0j/4fQs2FwawgnsYqn3+jxFEmJU6g0f5SxcY6BFi5
         SWafRh7LDgiwGkXkzzM/cTjprS6C0GdsuGE6awF2EQ/x1TolbTfuxyRN2XV9Zr9hAb
         SuBqEAnYek1rhUEHaD8Ckj6kzgS70xazoPhUWh6Frhi36co6Mh8uEiDycXoQvgJ06d
         y+yOKBBvlgPFOCUEHDBz4e8pxsOoHs3XxsElypNUTdgCQbmoR3pR3skzURAe1dO9qL
         ufOwHlVxIOWjA==
Date:   Fri, 14 Oct 2022 14:46:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: online checking of the free rt extent count
Message-ID: <Y0nYpaNkPRgVE+LX@magnolia>
References: <166473480544.1083794.8963547317476704789.stgit@magnolia>
 <166473480575.1083794.6363015906526063261.stgit@magnolia>
 <20221014035634.GM3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014035634.GM3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 02:56:34PM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:05AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the summary count checker to count the number of free realtime
> > extents and compare that to the superblock copy.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/fscounters.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/scrub/scrub.h      |    8 ----
> >  2 files changed, 84 insertions(+), 10 deletions(-)
> 
> .....
> > @@ -288,6 +301,59 @@ xchk_fscount_aggregate_agcounts(
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_XFS_RT
> > +static inline int
> > +xchk_fscount_add_frextent(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_trans		*tp,
> > +	const struct xfs_rtalloc_rec	*rec,
> > +	void				*priv)
> 
> This is a callback function, so it shouldn't be declared as
> "inline"....

Ok done.

--D

> With that fixed,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
