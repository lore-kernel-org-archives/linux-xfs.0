Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F8ECD13D2
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 16:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjIRQ03 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjIRQJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 12:09:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9634749E8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 09:07:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33D3C433BB;
        Mon, 18 Sep 2023 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695051529;
        bh=bnJRfFImsqcxBkMR6bd3bPRez48jdwYLB5h4nYE4UwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XeVQPa0H271Ucv3kbcv3+IMzKl8x/6DkwZ+3E0fM1U6+md7i98Bpi9VAhdmB3bSCe
         var63doi8cBHw83Rq1zgYTNXrTbhnQ3mJvEW4lAmJ+Z9m1yhmUu/E3BdbbfkAEvZ23
         sGhw4YsuYzldnZJlg/6CEw9D1yHMmi2sroydTrT67eiZBt539SVGMtOVNYy8wUgHYu
         yLy7tTbylGGgMwyRMcvPcKR1QIWM5v6NckkRiy6lA1V+6BINpEBQf3FOHy79CwJMdg
         8bSTu4d/LWaR8FbyP2R/0dLdUcS6ZHj2ArjY42QSQDGNJKZwJIxkOHIaLsEhT6SLcU
         RYW2+bpFL8pFA==
Date:   Mon, 18 Sep 2023 08:38:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 1/6] xfs: cache last bitmap block in realtime allocator
Message-ID: <20230918153848.GA348018@frogsfrogsfrogs>
References: <cover.1693950248.git.osandov@osandov.com>
 <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
 <ZPqYU79pTYYZFmf9@dread.disaster.area>
 <20230908152827.GX28186@frogsfrogsfrogs>
 <ZQN/qNgZJZdWdxQx@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQN/qNgZJZdWdxQx@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 07:48:24AM +1000, Dave Chinner wrote:
> On Fri, Sep 08, 2023 at 08:28:27AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 08, 2023 at 01:43:15PM +1000, Dave Chinner wrote:
> > > On Tue, Sep 05, 2023 at 02:51:52PM -0700, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > 
> > > > Profiling a workload on a highly fragmented realtime device showed a ton
> > > > of CPU cycles being spent in xfs_trans_read_buf() called by
> > > > xfs_rtbuf_get(). Further tracing showed that much of that was repeated
> > > > calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
> > > > These come from xfs_rtallocate_extent_block(): as it walks through
> > > > ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
> > > > xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
> > > > is very fragmented, then this is _a lot_ of buffer lookups.
> > > > 
> > > > The realtime allocator already passes around a cache of the last used
> > > > realtime summary block to avoid repeated reads (the parameters rbpp and
> > > > rsb). We can do the same for the realtime bitmap.
> > > > 
> > > > This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
> > > > the most recently used block for both the realtime bitmap and summary.
> > > > xfs_rtbuf_get() now handles the caching instead of the callers, which
> > > > requires plumbing xfs_rtbuf_cache to more functions but also makes sure
> > > > we don't miss anything.
> > > > 
> > > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_rtbitmap.c | 179 ++++++++++++++++++-----------------
> > > >  fs/xfs/xfs_rtalloc.c         | 119 +++++++++++------------
> > > >  fs/xfs/xfs_rtalloc.h         |  30 ++++--
> > > >  3 files changed, 170 insertions(+), 158 deletions(-)
> > > 
> > > ....
> > > 
> > > > diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> > > > index 62c7ad79cbb6..72f4261bb101 100644
> > > > --- a/fs/xfs/xfs_rtalloc.h
> > > > +++ b/fs/xfs/xfs_rtalloc.h
> > > > @@ -101,29 +101,40 @@ xfs_growfs_rt(
> > > >  /*
> > > >   * From xfs_rtbitmap.c
> > > >   */
> > > > +struct xfs_rtbuf_cache {
> > > > +	struct xfs_buf *bbuf;	/* bitmap block buffer */
> > > > +	xfs_fileoff_t bblock;	/* bitmap block number */
> > > > +	struct xfs_buf *sbuf;	/* summary block buffer */
> > > > +	xfs_fileoff_t sblock;	/* summary block number */
> > > 
> > > I don't think the block numbers are file offsets? Most of the code
> > > passes the bitmap and summary block numbers around as a
> > > xfs_fsblock_t...
> > 
> > They're fed into xfs_bmapi_read as the xfs_fileoff_t parameter.
> > 
> > I have a whole series cleaning up all of the units abuse in the rt code
> > part of the realtime modernization patchdeluge:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units
> > 
> > Here's the specific patch that cleans up this one part:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=realtime-groups&id=b344bd4bd655576f8bda193b0e33f471a6295b05
> ....
> 
> > Could someone (Omar?) take a look at my other rt cleanups too?  I'd very
> > much like to get them merged out of my dev tree.
> 
> Can you post the series to the list? That makes it much easier to
> comment on them....

https://lore.kernel.org/linux-xfs/167243865605.709511.15650588946095003543.stgit@magnolia/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
