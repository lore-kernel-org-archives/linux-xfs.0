Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E5BC77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 04:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345102AbjD1E2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 00:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbjD1E2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 00:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBDC2728
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 21:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 907CC63B09
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 04:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCFFC433EF;
        Fri, 28 Apr 2023 04:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682656108;
        bh=2y+GrMc2Di+WmsWVc0MrQK+vAV/TGn9Na7hISLrqqgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxhST4tXOpV0tAOD/sUr0xkXDJcytUVNII/oH5PchcuRNL972MJ2JcBRjBZku3HJ/
         24Xe+2teexeqqwA/hwaU9Ud/majyslw9bzUP/NVO/yIDwinq4nOtBUammAmWwi3i8r
         Y2+69JXNMDkqePMfcbkUEwyMoHiSDRpf+YdydsMcyEVtt0AD5fa68k64fDy/Q0qAPI
         OC6U2YZile+mY8TNuPDY1B29JTGAptuujYOD4EjjlQcyTNx8b4kRqNGn8nHOn5I0dS
         WSS11X6lubR3sn1nM88e6mW6rXB17UjjKpBYe8ak7GQpEknABREwEeIMPV5+0ihcz3
         6r3UQHOIJnpEA==
Date:   Thu, 27 Apr 2023 21:28:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: disable reaping in fscounters scrub
Message-ID: <20230428042827.GI59213@frogsfrogsfrogs>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263577739.1719564.16150152466509865245.stgit@frogsfrogsfrogs>
 <20230428022041.GT3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428022041.GT3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2023 at 12:20:41PM +1000, Dave Chinner wrote:
> On Thu, Apr 27, 2023 at 03:49:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The fscounters scrub code doesn't work properly because it cannot
> > quiesce updates to the percpu counters in the filesystem, hence it
> > returns false corruption reports.  This has been fixed properly in
> > one of the online repair patchsets that are under review by replacing
> > the xchk_disable_reaping calls with an exclusive filesystem freeze.
> > Disabling background gc isn't sufficient to fix the problem.
> > 
> > In other words, scrub doesn't need to call xfs_inodegc_stop, which is
> > just as well since it wasn't correct to allow scrub to call
> > xfs_inodegc_start when something else could be calling xfs_inodegc_stop
> > (e.g. trying to freeze the filesystem).
> > 
> > Neuter the scrubber for now, and remove the xchk_*_reaping functions.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Looks ok, minor nit below.
> 
> > @@ -453,6 +446,9 @@ xchk_fscounters(
> >  	if (frextents > mp->m_sb.sb_rextents)
> >  		xchk_set_corrupt(sc);
> >  
> > +	/* XXX: We can't quiesce percpu counter updates, so exit early. */
> > +	return 0;
> 
> Can you just add to this that we can re-enable this functionality
> when we have the exclusive freeze functionality in the kernel?

Will do.

--D

> With that,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
