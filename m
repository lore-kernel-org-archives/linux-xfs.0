Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FCEC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 22:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbiF0W10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 18:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240399AbiF0W1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 18:27:23 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8ED7518357
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 15:27:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7FAC010EA992;
        Tue, 28 Jun 2022 08:27:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5xCS-00BqDO-68; Tue, 28 Jun 2022 08:27:20 +1000
Date:   Tue, 28 Jun 2022 08:27:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks
 to be cleared
Message-ID: <20220627222720.GF227878@dread.disaster.area>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628104422.4040423.6482533913763183686.stgit@magnolia>
 <20220627013731.GB227878@dread.disaster.area>
 <Yrkqpbq0qEtixtdX@magnolia>
 <20220627051649.GD227878@dread.disaster.area>
 <YroaNHm9nQz39dyR@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YroaNHm9nQz39dyR@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62ba2ec9
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=t6_JvATAxVzgssUnmgcA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 01:59:32PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 27, 2022 at 03:16:49PM +1000, Dave Chinner wrote:
> > On Sun, Jun 26, 2022 at 08:57:25PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jun 27, 2022 at 11:37:31AM +1000, Dave Chinner wrote:
> > > > On Sun, Jun 26, 2022 at 03:04:04PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > On a system with a realtime volume and a 28k realtime extent,
> > > > > generic/491 fails because the test opens a file on a frozen filesystem
> > > > > and closing it causes xfs_release -> xfs_can_free_eofblocks to
> > > > > mistakenly think that the the blocks of the realtime extent beyond EOF
> > > > > are posteof blocks to be freed.  Realtime extents cannot be partially
> > > > > unmapped, so this is pointless.  Worse yet, this triggers posteof
> > > > > cleanup, which stalls on a transaction allocation, which is why the test
> > > > > fails.
> > > > > 
> > > > > Teach the predicate to account for realtime extents properly.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/xfs_bmap_util.c |    2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > > index 52be58372c63..85e1a26c92e8 100644
> > > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > > @@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
> > > > >  	 * forever.
> > > > >  	 */
> > > > >  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > > > > +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> > > > > +		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
> > > > >  	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > > > >  	if (last_fsb <= end_fsb)
> > > > >  		return false;
> > > > 
> > > > Ok, that works.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > > > 
> > > > However, I was looking at xfs_can_free_eofblocks() w.r.t. freeze a
> > > > couple of days ago and wondering why there isn't a freeze/RO state
> > > > check in xfs_can_free_eofblocks(). Shouldn't we have one here so
> > > > that we never try to run xfs_free_eofblocks() on RO/frozen
> > > > filesystems regardless of unexpected state/alignment issues?
> > > 
> > > I asked myself that question too.  I found three callers of this
> > > predicate:
> > > 
> > > 1. fallocate, which should have obtained freeze protection
> > 
> > *nod*
> > 
> > > 2. inodegc, which should never be running when we get to the innermost
> > > freeze protection level
> > 
> > So inodegc could still do IO here on a read-only fs?
> 
> Correct.
> 
> > > 3. xfs_release, which doesn't take freeze protection at all.  Either it
> > > needs to take freeze protection so that xfs_free_eofblocks can't get
> > > stuck in xfs_trans_alloc, or we'd need to modify xfs_trans_alloc to
> > > sb_start_intwrite_trylock
> > 
> > That looks to me like it is simply a case of replacing the
> > !xfs_is_readonly() check in xfs_release() with a
> > !xfs_fs_writeable(mp, SB_FREEZE_WRITE) check and we shouldn't have
> > to touch anythign else, right?
> 
> I think there would still be a race if we did that -- I don't see
> anything in __fput that prohibits another thread from initiating a
> freeze after the release process calls _can_free_eofblocks but before
> the actual call to _free_eofblocks.

Yup, the probability of that happening is pretty small, and there's
every chance it could have got stuck on something else racing with
the freeze.

In reality, I don't think that blocking in ->release on freeze is
inherently bad - it will just wait until the filesystem is thawed
and then continue on. i.e. just because the test hangs on closing a
fd on a frozen fs doesn't mean that the freeze mechanism is broken
in any way....

> Hm.  How often would we have a readonly fd pointing to a file that has
> posteof blocks?  I suppose this could happen if the system was extending
> a file, crashed, and then someone remounted, opened a ro fd, and then
> closed and froze the fs at the same time...?

Snapshots. Open files at freeze time will result in post-eof blocks
existing in the snapshot. Mount the snapshot read-only ..... and
that's what the read-only check in xfs_release() catches......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
