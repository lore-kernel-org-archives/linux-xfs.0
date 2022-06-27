Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB1CCCA47B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 20:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbiF0U7i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 16:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240770AbiF0U7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 16:59:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E431260DC
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 13:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91265B81BA0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 20:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478D7C34115;
        Mon, 27 Jun 2022 20:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656363573;
        bh=dB3FZ5nXaVpTpF6MPD6CAnyatuA68WsWxrOZ6U28RWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD8BWex9D3LHGsOdbIY6lhUgCi3Z4aXcsVXGuvILjEKCePqmLKmNFLAVnOHI9GJcc
         6yX/dd+QiFXRBlcfedzXYyrtShMadUY+UWtsxldmIoEh8TpPEZsfYE/Rh0PM7rFmph
         ssRW33KOd9FoFultlU1Xksb1taB2hA1gdvW4VH8GGr1jGXoeajXFYjmNhSfXL0hHl6
         rx50FQcnrD1JUaEu2R7mDsSySBifeO+8bqejmmUVMpNDSerrycX35h00fycqIWeaoo
         4zMHCPPkdAzL6PsHWxsvvE6qFuI7rDs38/WUoJafSUAQmW1McJarYa3f10N4DlkAyC
         awuCeQEw5fABQ==
Date:   Mon, 27 Jun 2022 13:59:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks
 to be cleared
Message-ID: <YroaNHm9nQz39dyR@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628104422.4040423.6482533913763183686.stgit@magnolia>
 <20220627013731.GB227878@dread.disaster.area>
 <Yrkqpbq0qEtixtdX@magnolia>
 <20220627051649.GD227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627051649.GD227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 03:16:49PM +1000, Dave Chinner wrote:
> On Sun, Jun 26, 2022 at 08:57:25PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 27, 2022 at 11:37:31AM +1000, Dave Chinner wrote:
> > > On Sun, Jun 26, 2022 at 03:04:04PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > On a system with a realtime volume and a 28k realtime extent,
> > > > generic/491 fails because the test opens a file on a frozen filesystem
> > > > and closing it causes xfs_release -> xfs_can_free_eofblocks to
> > > > mistakenly think that the the blocks of the realtime extent beyond EOF
> > > > are posteof blocks to be freed.  Realtime extents cannot be partially
> > > > unmapped, so this is pointless.  Worse yet, this triggers posteof
> > > > cleanup, which stalls on a transaction allocation, which is why the test
> > > > fails.
> > > > 
> > > > Teach the predicate to account for realtime extents properly.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_bmap_util.c |    2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > index 52be58372c63..85e1a26c92e8 100644
> > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > @@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
> > > >  	 * forever.
> > > >  	 */
> > > >  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > > > +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> > > > +		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
> > > >  	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > > >  	if (last_fsb <= end_fsb)
> > > >  		return false;
> > > 
> > > Ok, that works.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > > 
> > > However, I was looking at xfs_can_free_eofblocks() w.r.t. freeze a
> > > couple of days ago and wondering why there isn't a freeze/RO state
> > > check in xfs_can_free_eofblocks(). Shouldn't we have one here so
> > > that we never try to run xfs_free_eofblocks() on RO/frozen
> > > filesystems regardless of unexpected state/alignment issues?
> > 
> > I asked myself that question too.  I found three callers of this
> > predicate:
> > 
> > 1. fallocate, which should have obtained freeze protection
> 
> *nod*
> 
> > 2. inodegc, which should never be running when we get to the innermost
> > freeze protection level
> 
> So inodegc could still do IO here on a read-only fs?

Correct.

> > 3. xfs_release, which doesn't take freeze protection at all.  Either it
> > needs to take freeze protection so that xfs_free_eofblocks can't get
> > stuck in xfs_trans_alloc, or we'd need to modify xfs_trans_alloc to
> > sb_start_intwrite_trylock
> 
> That looks to me like it is simply a case of replacing the
> !xfs_is_readonly() check in xfs_release() with a
> !xfs_fs_writeable(mp, SB_FREEZE_WRITE) check and we shouldn't have
> to touch anythign else, right?

I think there would still be a race if we did that -- I don't see
anything in __fput that prohibits another thread from initiating a
freeze after the release process calls _can_free_eofblocks but before
the actual call to _free_eofblocks.

Hm.  How often would we have a readonly fd pointing to a file that has
posteof blocks?  I suppose this could happen if the system was extending
a file, crashed, and then someone remounted, opened a ro fd, and then
closed and froze the fs at the same time...?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
