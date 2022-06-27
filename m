Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BB0C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 03:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiF0D5b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 23:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiF0D5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 23:57:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E743896
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 20:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE32FB80EA2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 03:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D48C341C8;
        Mon, 27 Jun 2022 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656302246;
        bh=qke30VYJVgRdqiKXWNdln0gj6B+pRsoQmAjJzlP3qDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P28Sc5IlBTgqMAzBMUGcCtZxeQWVWS67zd9+JtGUrw1FgL9ETFw5ZJYcPBJjJ7fZ1
         nY6wpY4ApYxQ4lmHL1VMOr3ucU9Mme83XtgLbDcesZChykxnncCicGXMv8tYk9XHHn
         5xOdAKHet+hLsnkBhLKpgFuStSdu5BuyfIdXM4k3DsgKcGgE2UzDLoyifjcMh0UaNY
         ASgFVTv5n7wYtPh9lBUV7FqjJXpmkcRh29OB00ZvcxlT9082QeCu3380RjRctBbpJB
         tQJtMHKSSpr7IZS0gzM/4yrZdgX8+EMMMm0Twl03Jv5gTlrVrkmcDePTgEqXJ2zAJ/
         tZc6ZUTKIktsg==
Date:   Sun, 26 Jun 2022 20:57:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks
 to be cleared
Message-ID: <Yrkqpbq0qEtixtdX@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628104422.4040423.6482533913763183686.stgit@magnolia>
 <20220627013731.GB227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627013731.GB227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 11:37:31AM +1000, Dave Chinner wrote:
> On Sun, Jun 26, 2022 at 03:04:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On a system with a realtime volume and a 28k realtime extent,
> > generic/491 fails because the test opens a file on a frozen filesystem
> > and closing it causes xfs_release -> xfs_can_free_eofblocks to
> > mistakenly think that the the blocks of the realtime extent beyond EOF
> > are posteof blocks to be freed.  Realtime extents cannot be partially
> > unmapped, so this is pointless.  Worse yet, this triggers posteof
> > cleanup, which stalls on a transaction allocation, which is why the test
> > fails.
> > 
> > Teach the predicate to account for realtime extents properly.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_bmap_util.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 52be58372c63..85e1a26c92e8 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
> >  	 * forever.
> >  	 */
> >  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> > +		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
> >  	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> >  	if (last_fsb <= end_fsb)
> >  		return false;
> 
> Ok, that works.
> 
> However, I was looking at xfs_can_free_eofblocks() w.r.t. freeze a
> couple of days ago and wondering why there isn't a freeze/RO state
> check in xfs_can_free_eofblocks(). Shouldn't we have one here so
> that we never try to run xfs_free_eofblocks() on RO/frozen
> filesystems regardless of unexpected state/alignment issues?

I asked myself that question too.  I found three callers of this
predicate:

1. fallocate, which should have obtained freeze protection

2. inodegc, which should never be running when we get to the innermost
freeze protection level

3. xfs_release, which doesn't take freeze protection at all.  Either it
needs to take freeze protection so that xfs_free_eofblocks can't get
stuck in xfs_trans_alloc, or we'd need to modify xfs_trans_alloc to
sb_start_intwrite_trylock

I don't really want to try to add (3) as part of a fix for 5.19, but I
would like to get these fixes merged so I can concentrate on finding and
fixing the file corruption problems that are still present in -rc4.  If
we want to engineer a freeze/ro state check later, we can do that too.

So, can we move ahead with this fix?

--D

> Cheers,
> 
> Dave.
> 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
