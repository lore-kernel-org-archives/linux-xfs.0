Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AB8C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 00:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbiFTAVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jun 2022 20:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiFTAVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jun 2022 20:21:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD9C7958F
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jun 2022 17:21:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AC98510E78EA;
        Mon, 20 Jun 2022 10:21:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o35AU-008i8T-5i; Mon, 20 Jun 2022 10:21:26 +1000
Date:   Mon, 20 Jun 2022 10:21:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 14/17] xfs: Add the parent pointer support to the
 superblock version 5.
Message-ID: <20220620002126.GM227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-15-allison.henderson@oracle.com>
 <20220616060310.GE227878@dread.disaster.area>
 <3d1cdf9bdf67954c457077a58b6520f609999b57.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d1cdf9bdf67954c457077a58b6520f609999b57.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62afbd88
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=eJfxgxciAAAA:8 a=20KFwNOVAAAA:8
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=ofUXJsk1A2IqffOnco8A:9
        a=CjuIK1q_8ugA:10 a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 05:32:36PM -0700, Alli wrote:
> On Thu, 2022-06-16 at 16:03 +1000, Dave Chinner wrote:
> > On Sat, Jun 11, 2022 at 02:41:57AM -0700, Allison Henderson wrote:
> > > [dchinner: forward ported and cleaned up]
> > > [achender: rebased and added parent pointer attribute to
> > >            compatible attributes mask]
> > > 
> > > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h | 14 +++++++++-----
> > >  fs/xfs/libxfs/xfs_fs.h     |  1 +
> > >  fs/xfs/libxfs/xfs_sb.c     |  2 ++
> > >  fs/xfs/xfs_super.c         |  4 ++++
> > >  4 files changed, 16 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h
> > > b/fs/xfs/libxfs/xfs_format.h
> > > index 96976497306c..e85d6b643622 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -83,6 +83,7 @@ struct xfs_ifork;
> > >  #define	XFS_SB_VERSION2_OKBITS		\
> > >  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> > >  	 XFS_SB_VERSION2_ATTR2BIT	| \
> > > +	 XFS_SB_VERSION2_PARENTBIT	| \
> > >  	 XFS_SB_VERSION2_PROJID32BIT	| \
> > >  	 XFS_SB_VERSION2_FTYPE)
> > 
> > No need for a v4 filesystem format feature bit - this is v4 only.
> Ok, I ended up having to add this in the rebase or we get an "SB
> validate failed".  I think it has to go over in
> xfs_sb_validate_v5_features next to the manual crc bit check.  Will
> move

Ah, I meant that parent pointers are a v5 only feature, and so we
don't need a "v4 only" feature bit for it. As it is, we can't use
that specific bit because SGI shipped a version of parent pointers
on v4 filesystems on IRIX under that feature bit that was broken and
subsequently recalled and killed. Essentially, that means
XFS_SB_VERSION2_PARENTBIT is blacklisted and cannot ever be used by
upstream kernels.

> > > @@ -353,11 +354,13 @@ xfs_sb_has_compat_feature(
> > >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/*
> > > reverse map btree */
> > >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/*
> > > reflinked files */
> > >  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/*
> > > inobt block counts */
> > > +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 4)		/*
> > > parent inode ptr */
> > >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> > > -		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> > > -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > > -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> > > -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> > > +		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
> > > +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
> > > +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> > > +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> > > +		 XFS_SB_FEAT_RO_COMPAT_PARENT)
> > 
> > I'm not sure this is a RO Compat feature - we added an attribute
> > namespace flag on disk, and the older kernels do not know about
> > that (i.e. we changed XFS_ATTR_NSP_ONDISK_MASK). This may result in
> > parent pointer attrs being exposed as user attrs rather than being
> > hidden, or maybe parent pointer attrs being seen as corrupt because
> > they have a flag that isn't defined set, etc.
> > 
> > Hence I'm not sure that this classification is correct.
> 
> Gosh, I'm sure there was a reason we did this, but what ever it was
> goes all the way back in the first re-appearance of the set back in
> 2018 and I just cant remember the discussion at the time.  It may have
> just been done to get mkfs working and we just never got to reviewing
> it.
> 
> Should we drop it and just use XFS_SB_VERSION2_PARENTBIT?

No, it needs to be a v5 feature bit - create a v5 parent pointer
filesystem, create some files on it, and then go an mount it on a
kernel that doesn't have PP support. If you can see the parent
pointer attributes from userspace as "user.<binary garbage>"
attributes, then we need to use an INCOMPAT feature bit rather than
a RO_COMPAT bit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
