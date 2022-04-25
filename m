Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C762CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 23:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiDYXmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 19:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDYXmP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 19:42:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A005C120100
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15DAAB81BAB
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 23:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBAEC385A7;
        Mon, 25 Apr 2022 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650929946;
        bh=PbNi32o8ee7pzz96TXhuAex9ZULaHBLijjOk0IlP/Kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oiBm0l+YizuKXrqo4S+dW7iuMfaBaDWxAwZQiVcHx9eRPgJVGL5ZxyGNB5sxc4Tmc
         PUMkbWJXvXLOrIcVzMSUzS0kqk9TH3quHJ7nUcE8HBGcQfLbzgLlLo/VGjU9XjjtnW
         bBhWkQCVmYE0ukpJfehfmE8e8DyhioUAceES/LzGDokApMShf489AC4JHx2MaAz19H
         5JQMjeedW/XyFbsEBHowTa2mxOnQ1eKaMZs4JzMixGWHt4xXNtu1dVoHeceCfiuYSH
         CbprMLJik4UPSBAC8+VoJRrU4dQfgQKwTvMyRKLNU20MMRVzxafqIH36NraC8/JsjN
         h4C/ivaYJAaAg==
Date:   Mon, 25 Apr 2022 16:39:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <20220425233905.GN17025@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688275.383881.1038640482191339784.stgit@magnolia>
 <20220422223635.GC1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422223635.GC1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 23, 2022 at 08:36:35AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every time someone changes the transaction reservation sizes, they
> > introduce potential compatibility problems if the changes affect the
> > minimum log size that we validate at mount time.  If the minimum log
> > size gets larger (which should be avoided because doing so presents a
> > serious risk of log livelock), filesystems created with old mkfs will
> > not mount on a newer kernel; if the minimum size shrinks, filesystems
> > created with newer mkfs will not mount on older kernels.
> > 
> > Therefore, enable the creation of a shadow log reservation structure
> > where we can "undo" the effects of tweaks when computing minimum log
> > sizes.  These shadow reservations should never be used in practice, but
> > they insulate us from perturbations in minimum log size.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_log_rlimit.c |   17 +++++++++++++----
> >  fs/xfs/libxfs/xfs_trans_resv.c |   12 ++++++++++++
> >  fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
> >  fs/xfs/xfs_trace.h             |   12 ++++++++++--
> >  4 files changed, 37 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> > index 67798ff5e14e..2bafc69cac15 100644
> > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > @@ -14,6 +14,7 @@
> >  #include "xfs_trans_space.h"
> >  #include "xfs_da_btree.h"
> >  #include "xfs_bmap_btree.h"
> > +#include "xfs_trace.h"
> >  
> >  /*
> >   * Calculate the maximum length in bytes that would be required for a local
> > @@ -47,18 +48,25 @@ xfs_log_get_max_trans_res(
> >  	struct xfs_trans_res	*max_resp)
> >  {
> >  	struct xfs_trans_res	*resp;
> > +	struct xfs_trans_res	*start_resp;
> >  	struct xfs_trans_res	*end_resp;
> > +	struct xfs_trans_resv	*resv;
> >  	int			log_space = 0;
> >  	int			attr_space;
> >  
> >  	attr_space = xfs_log_calc_max_attrsetm_res(mp);
> >  
> > -	resp = (struct xfs_trans_res *)M_RES(mp);
> > -	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> > -	for (; resp < end_resp; resp++) {
> > +	resv = kmem_zalloc(sizeof(struct xfs_trans_resv), 0);
> > +	xfs_trans_resv_calc_logsize(mp, resv);
> > +
> > +	start_resp = (struct xfs_trans_res *)resv;
> > +	end_resp = (struct xfs_trans_res *)(resv + 1);
> > +	for (resp = start_resp; resp < end_resp; resp++) {
> >  		int		tmp = resp->tr_logcount > 1 ?
> >  				      resp->tr_logres * resp->tr_logcount :
> >  				      resp->tr_logres;
> > +
> > +		trace_xfs_trans_resv_calc_logsize(mp, resp - start_resp, resp);
> >  		if (log_space < tmp) {
> >  			log_space = tmp;
> >  			*max_resp = *resp;		/* struct copy */
> 
> This took me a while to get my head around. The minimum logsize
> calculation stuff is all a bit of a mess.
> 
> Essentially, we call xfs_log_get_max_trans_res() from two places.
> One is to calculate the minimum log size, the other is the
> transaction reservation tracing code done when M_RES(mp) is set up
> via xfs_trans_trace_reservations().  We don't need the call from
> xfs_trans_trace_reservations() - it's trivial to scan the list of
> tracepoints emitted by this function at mount time to find the
> maximum reservation.

Here's the thing -- xfs_db also calls xfs_log_get_max_trans_res to
figure out the transaction reservation that's used to compute the
minimum log size.  Whenever I get a report about mount failing due to
minlogsize checks, I can ask the reporter to send me the ftrace output
from the mount attempt and compare it against what userspace thinks:

# xfs_db /dev/sde -c logres
type 0 logres 168184 logcount 5 flags 0x4
type 1 logres 293760 logcount 5 flags 0x4
type 2 logres 307936 logcount 2 flags 0x4
type 3 logres 187760 logcount 2 flags 0x4
type 4 logres 170616 logcount 2 flags 0x4
type 5 logres 244720 logcount 3 flags 0x4
type 6 logres 243568 logcount 2 flags 0x4
type 7 logres 260352 logcount 2 flags 0x4
type 8 logres 243568 logcount 3 flags 0x4
type 9 logres 278648 logcount 2 flags 0x4
type 10 logres 2168 logcount 0 flags 0x0
type 11 logres 73728 logcount 2 flags 0x4
type 12 logres 99960 logcount 2 flags 0x4
type 13 logres 760 logcount 0 flags 0x0
type 14 logres 292992 logcount 1 flags 0x4
type 15 logres 23288 logcount 3 flags 0x4
type 16 logres 13312 logcount 0 flags 0x0
type 17 logres 147584 logcount 3 flags 0x4
type 18 logres 640 logcount 0 flags 0x0
type 19 logres 94968 logcount 2 flags 0x4
type 20 logres 4224 logcount 0 flags 0x0
type 21 logres 6512 logcount 0 flags 0x0
type 22 logres 232 logcount 1 flags 0x0
type 23 logres 172407 logcount 5 flags 0x4
type 24 logres 640 logcount 1 flags 0x0
type 25 logres 760 logcount 0 flags 0x0
type 26 logres 243568 logcount 2 flags 0x4
type 27 logres 170616 logcount 2 flags 0x4
type -1 logres 547200 logcount 8 flags 0x4

And this "-1" entry matches the last output of the kernel.  I'd rather
not lose this tracing facility (which means keeping this function
non-static) though I will move the tracepoint out of
xfs_trans_trace_reservations.

> Hence I think we should start by removing that call to this
> function, and making this a static function called only from
> xfs_log_calc_minimum_size().
> 
> At this point, we can use an on-stack struct xfs_trans_resv for the
> calculated values - no need for memory allocation here as we will
> never be short of stack space in this path.

~312 bytes?  That's ~8% of the kernel stack.  I'll see if I run into any
complaints, though I bet I won't on x64.

> The tracing in the loop also wants an integer index into the struct
> xfs_trans_resv structure, so it should be changed to match what
> xfs_trans_trace_reservations() does:
> 
> 	struct xfs_trans_resv	resv;
> 	struct xfs_trans_res	*resp;
> 	struct xfs_trans_res	*end_resp;
> 
> 	....
> 
> 	xfs_trans_resv_calc(mp, &resv)
> 
> 	resp = (struct xfs_trans_res *)&resv;
> 	end_resp = (struct xfs_trans_res *)(&resv + 1);
> 	for (i = 0; resp < end_resp; resp++) {
> 		.....
> 		trace_xfs_trans_resv_calc_logsize(mp, i, resp);
> 		....
> 	}

Done.

> 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 6f83d9b306ee..12d4e451e70e 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -933,3 +933,15 @@ xfs_trans_resv_calc(
> >  	/* Put everything back the way it was.  This goes at the end. */
> >  	mp->m_rmap_maxlevels = rmap_maxlevels;
> >  }
> > +
> > +/*
> > + * Compute an alternate set of log reservation sizes for use exclusively with
> > + * minimum log size calculations.
> > + */
> > +void
> > +xfs_trans_resv_calc_logsize(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans_resv	*resp)
> > +{
> > +	xfs_trans_resv_calc(mp, resp);
> > +}
> 
> This function and it's name was waht confused me for a while - I
> don't think it belongs in this patch, and I don't think it belongs
> in this file when it's filled out in the next patch. It's basically
> handling things specific to minimum log size calculations, so with
> the above mods I think it should also end up being static to
> libxfs/xfs_log_rlimit.c.

Moved.  I guess I should rename it to xfs_log_recalc_trans_resv or
something.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
