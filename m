Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343C5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiDGI6h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiDGI6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:58:36 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12D7DC1C8C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:56:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5E6D910E576B;
        Thu,  7 Apr 2022 18:56:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncNwN-00EnCW-Uk; Thu, 07 Apr 2022 18:56:31 +1000
Date:   Thu, 7 Apr 2022 18:56:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220407085631.GK1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-13-chandan.babu@oracle.com>
 <20220407010544.GC1544202@dread.disaster.area>
 <20220407015855.GZ27690@magnolia>
 <20220407024401.GI1544202@dread.disaster.area>
 <87o81dxq5y.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o81dxq5y.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624ea742
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=mqy_xOorUfA6ASB-ffQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 01:48:17PM +0530, Chandan Babu R wrote:
> On 07 Apr 2022 at 08:14, Dave Chinner wrote:
> > On Wed, Apr 06, 2022 at 06:58:55PM -0700, Darrick J. Wong wrote:
> >> On Thu, Apr 07, 2022 at 11:05:44AM +1000, Dave Chinner wrote:
> >> > On Wed, Apr 06, 2022 at 11:48:56AM +0530, Chandan Babu R wrote:
> >> > > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> >> > > index 453309fc85f2..7aabeccea9ab 100644
> >> > > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> >> > > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> >> > > @@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
> >> > >  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
> >> > >  
> >> > >  	/* One extra level for the inode root. */
> >> > > -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
> >> > > +	return xfs_btree_compute_maxlevels(minrecs,
> >> > > +			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
> >> > >  }
> >> > 
> >> > Why is this set to XFS_MAX_EXTCNT_DATA_FORK_LARGE rather than being
> >> > conditional xfs_has_large_extent_counts(mp)? i.e. if the feature bit
> >> > is not set, the maximum on-disk levels in the bmbt is determined by
> >> > XFS_MAX_EXTCNT_DATA_FORK_SMALL, not XFS_MAX_EXTCNT_DATA_FORK_LARGE.
> >> 
> >> This function (and all the other _maxlevels_ondisk functions) compute
> >> the maximum possible btree height for any filesystem that we'd care to
> >> mount.  This value is then passed to the functions that create the btree
> >> cursor caches, which is why this is independent of any xfs_mount.
> >> 
> >> That said ... depending on how much this inflates the size of the bmbt
> >> cursor cache, I think we could create multiple slabs.
> >> 
> >> > The "_ondisk" suffix implies that it has something to do with the
> >> > on-disk format of the filesystem, but AFAICT what we are calculating
> >> > here is a constant used for in-memory structure allocation? There
> >> > needs to be something explained/changed here, because this is
> >> > confusing...
> >> 
> >> You suggested it. ;)
> >> 
> >> https://lore.kernel.org/linux-xfs/20211013075743.GG2361455@dread.disaster.area/
> >
> > That doesn't mean it's perfect and can't be changed, nor that I
> > remember the exact details of something that happened 6 months ago.
> > Indeed, if I'm confused by it 6 months later, that tends to say it
> > wasn't a very good name... :)
> >
> > .... or that the missing context needs explaining so the reader is
> > reminded what the _ondisk() name means.
> >
> > i.e. the problem goes away with a simple comment:
> >
> > /*
> >  * Calculate the maximum possible height of the btree that the
> >  * on-disk format supports. This is used for sizing structures large
> >  * enough to support every possible configuration of a filesystem
> >  * that might get mounted.
> >  */
> >
> 
> If there are no objections, I will include the above comment as part of this
> patch.

Yes, that's fine, and with that added, you can add:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
