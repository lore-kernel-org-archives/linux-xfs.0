Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8869C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 16:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbiDYQSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243309AbiDYQSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 12:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196A2FD00
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66BBFB811F5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E90DC385A4;
        Mon, 25 Apr 2022 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650903333;
        bh=7LcWfIp5ofWIARt/wjhjbZM3l+UFQoxmdezB7VMDnW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGUxlbkO2NRqjtR3qQ0GciFP/AyTwbxX3GHHfxwQS0DGhg4tSB2n0yEwAPz9A/jbj
         4BdON5+Tu82H4ScaY+pSDL7jEWjua+hkMB00BFz1MH5SCYqTwsxQueAP3uuACR45Ap
         ECDd1YQCBzHAUkOaawxib1eRrv+a12+U88S60Cal3Z0g3LvpkWkkw1Vm4u/WpW+Q/+
         d303vKyjKTj9oW3memx67oE/v+Vz0Yonl1nueqYafUIquIL1zDY31jN+Dz1LRpOd0y
         tU+BIlSYcVPjl2UxxCSasiSpfUvEYaczogNDB+kArdxUVHwlKj7K3CWL35rlhTg9+2
         4khV0DHoMM2JQ==
Date:   Mon, 25 Apr 2022 09:15:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix soft lockup via spinning in filestream ag
 selection loop
Message-ID: <20220425161532.GD17025@magnolia>
References: <20220422141226.1831426-1-bfoster@redhat.com>
 <20220422160021.GB17025@magnolia>
 <YmLWRBjTSP43r6Cs@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmLWRBjTSP43r6Cs@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 22, 2022 at 12:22:28PM -0400, Brian Foster wrote:
> On Fri, Apr 22, 2022 at 09:00:21AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 22, 2022 at 10:12:26AM -0400, Brian Foster wrote:
> > > The filestream AG selection loop uses pagf data to aid in AG
> > > selection, which depends on pagf initialization. If the in-core
> > > structure is not initialized, the caller invokes the AGF read path
> > > to do so and carries on. If another task enters the loop and finds
> > > a pagf init already in progress, the AGF read returns -EAGAIN and
> > > the task continues the loop. This does not increment the current ag
> > > index, however, which means the task spins on the current AGF buffer
> > > until unlocked.
> > > 
> > > If the AGF read I/O submitted by the initial task happens to be
> > > delayed for whatever reason, this results in soft lockup warnings
> > 
> > Is there a specific 'whatever reason' going on here?
> > 
> 
> Presumably.. given this seems to reproduce reliably or not at all in
> certain environments/configs, my suspicion was that either the timing of
> the test changes enough such that some other task involved with the test
> is able to load the bdev, or otherwise timing changes just enough to
> trigger the pagf_init race and the subsequent spinning is what
> exacerbates the delay (i.e. burning cpu and subsequent soft lockup BUG
> starve out some part(s) of the I/O submission/completion processing).
> I've no tangible evidence for either aside from the latter seems fairly
> logical when you consider that the test consistently completes in 3-4
> seconds with the fix in place, but without it we consistently hit
> multiple instances of the soft lockup detector (on ~20s intervals IIRC)
> and the system seems to melt down indefinitely. *shrug*

Ah, ok, so there wasn't any specific event that was causing AGF IO to
take a long time, it's just that a thread running the filestream
allocator could fail the trylock loop for any reason for long enough to
trip the hangcheck warning.

--D

> Brian
> 
> > > via the spinning task. This is reproduced by xfs/170. To avoid this
> > > problem, fix the AGF trylock failure path to properly iterate to the
> > > next AG. If a task iterates all AGs without making progress, the
> > > trylock behavior is dropped in favor of blocking locks and thus a
> > > soft lockup is no longer possible.
> > > 
> > > Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
> > 
> > Ooops, this was a major braino on my part.
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > I included the Fixes: tag because this looks like a regression in said
> > > commit, but I've not explicitly verified.
> > > 
> > > Brian
> > > 
> > >  fs/xfs/xfs_filestream.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> > > index 6a3ce0f6dc9e..be9bcf8a1f99 100644
> > > --- a/fs/xfs/xfs_filestream.c
> > > +++ b/fs/xfs/xfs_filestream.c
> > > @@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
> > >  		if (!pag->pagf_init) {
> > >  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> > >  			if (err) {
> > > -				xfs_perag_put(pag);
> > > -				if (err != -EAGAIN)
> > > +				if (err != -EAGAIN) {
> > > +					xfs_perag_put(pag);
> > >  					return err;
> > > +				}
> > >  				/* Couldn't lock the AGF, skip this AG. */
> > > -				continue;
> > > +				goto next_ag;
> > >  			}
> > >  		}
> > >  
> > > -- 
> > > 2.34.1
> > > 
> > 
> 
