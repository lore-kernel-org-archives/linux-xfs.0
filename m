Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC8BC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 02:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3663C20791
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 02:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGPCCV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 22:02:21 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:56210 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726796AbgGPCCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 22:02:21 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B81CE5F1812;
        Thu, 16 Jul 2020 12:02:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jvtDt-00027i-LT; Thu, 16 Jul 2020 12:02:09 +1000
Date:   Thu, 16 Jul 2020 12:02:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200716020209.GK2005@dread.disaster.area>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200715222935.GI2005@dread.disaster.area>
 <20200716014759.GH3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716014759.GH3151642@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=yfOv0ADgII1o1NBEPHwA:9 a=oVsgy_YJIYrHwS7q:21 a=yKepPxqi-PQYBw2A:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 06:47:59PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 16, 2020 at 08:29:35AM +1000, Dave Chinner wrote:
> > On Wed, Jul 15, 2020 at 03:33:10PM -0400, Brian Foster wrote:
> > > The block reservation calculation for inode allocation is supposed
> > > to consist of the blocks required for the inode chunk plus
> > > (maxlevels-1) of the inode btree multiplied by the number of inode
> > > btrees in the fs (2 when finobt is enabled, 1 otherwise).
> > > 
> > > Instead, the macro returns (ialloc_blocks + 2) due to a precedence
> > > error in the calculation logic. This leads to block reservation
> > > overruns via generic/531 on small block filesystems with finobt
> > > enabled. Add braces to fix the calculation and reserve the
> > > appropriate number of blocks.
> > > 
> > > Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > > index 88221c7a04cc..c6df01a2a158 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > > @@ -57,7 +57,7 @@
> > >  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> > >  #define	XFS_IALLOC_SPACE_RES(mp)	\
> > >  	(M_IGEO(mp)->ialloc_blks + \
> > > -	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
> > > +	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> > >  	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> > 
> > Ugh. THese macros really need rewriting as static inline functions.
> > This would not have happened if it were written as:
> > 
> > static inline int
> > xfs_ialloc_space_res(struct xfs_mount *mp)
> > {
> > 	int	res = M_IGEO(mp)->ialloc_blks;
> > 
> > 	res += M_IGEO(mp)->inobt_maxlevels - 1;
> > 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > 		res += M_IGEO(mp)->inobt_maxlevels - 1;
> > 	return res;
> > }
> > 
> > Next question: why is this even a macro that is calculated on demand
> > instead of a read-only constant held in inode geometry calculated
> > at mount time? Then it doesn't even need to be an inline function
> > and can just be rolled into xfs_ialloc_setup_geometry()....
> 
> Yeah, I hate those macros too.  Fixing all that sounds like a <cough>
> cleanup series for someone, but in the meantime this is easy enough to
> backport to stable kernels.

Well, I'm not suggesting that we have to fix all of them at once.
Just converting this specific one to a IGEO variable is probably
only 20 lines of code, which is still an "easy to backport" fix.

i.e. XFS_IALLOC_SPACE_RES() is used in just 7 places in the code,
4 of them are in that same header file, so it's a simple, standalone
patch that fixes the bug by addressing the underlying cause of
the problem (i.e. nasty macro!).

Historically speaking , we have cleaned up stuff like this to fix
the bug, not done a one liner and then left fixing the root cause to
some larger chunk of future work. The "one-liner" approach is
largely a recent invention. I look at this sort of thing as being
similar to cleaning up typedefs: we remove typedefs as we change
surrounding code, thereby slowly remove them over time. We could
just remove them all as one big patchset, but we don't do that
because of all the outstanding work it would cause conflicts in.

Perhaps we've lost sight of the fact that doing things in little
chunks on demand actually results in a lot of good cleanup change
over time. We really don't have to do cleanups as one huge chunk of
work all at once....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
