Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7BDC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F42C61051
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhHRBeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 21:34:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45852 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235093AbhHRBeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 21:34:18 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9EF25104A25F;
        Wed, 18 Aug 2021 11:33:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGASb-001xNq-KK; Wed, 18 Aug 2021 11:33:41 +1000
Date:   Wed, 18 Aug 2021 11:33:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs: replace xfs_sb_version checks with feature
 flag checks
Message-ID: <20210818013341.GP3657114@dread.disaster.area>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-6-david@fromorbit.com>
 <20210811221329.GK3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811221329.GK3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=GfEYSm-wLwr3SNRR96UA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 03:13:29PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 10, 2021 at 03:24:40PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Convert the xfs_sb_version_hasfoo() to checks against
> > mp->m_features. Checks of the superblock itself during disk
> > operations (e.g. in the read/write verifiers and the to/from disk
> > formatters) are not converted - they operate purely on the
> > superblock state. Everything else should use the mount features.
> > 
> > Large parts of this conversion were done with sed with commands like
> > this:
> > 
> > for f in `git grep -l xfs_sb_version_has fs/xfs/*.c`; do
> > 	sed -i -e 's/xfs_sb_version_has\(.*\)(&\(.*\)->m_sb)/xfs_has_\1(\2)/' $f
> > done
> > 
> > With manual cleanups for things like "xfs_has_extflgbit" and other
> > little inconsistencies in naming.
> > 
> > The result is ia lot less typing to check features and an XFS binary
> > size reduced by a bit over 3kB:
> > 
> > $ size -t fs/xfs/built-in.a
> > 	text	   data	    bss	    dec	    hex	filenam
> > before	1130866  311352     484 1442702  16038e (TOTALS)
> > after	1127727  311352     484 1439563  15f74b (TOTALS)
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> <snip>
> 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 699066fb9052..7361830163d7 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -951,8 +951,7 @@ xfs_growfs_rt(
> >  		return -EINVAL;
> >  
> >  	/* Unsupported realtime features. */
> > -	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
> > -	    xfs_sb_version_hasreflink(&mp->m_sb))
> > +	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
> 
> A regression test that I developed to test the act of adding a realtime
> volume to an existing filesystem exposed the following failure:
> 
> --- /tmp/fstests/tests/xfs/779.out      2021-08-08 08:47:08.535033170 -0700
> +++ /var/tmp/fstests/xfs/779.out.bad    2021-08-11 14:54:18.389346401 -0700
> @@ -1,2 +1,4 @@
>  QA output created by 779
> +/opt/a is not a realtime file?
> +expected file extszhint 0, got 12288
>  Silence is golden
> 
> Since this test is not yet upstream, I will describe the sequence of
> events:
> 
> 1. Suppress SCRATCH_RTDEV when invoking _scratch_mkfs.  This creates a
>    filesystem with no realtime volume attached.
> 2. Mount the fs with SCRATCH_RTDEV in the mount options.  The rt volume
>    still has not been attached.
> 3. Set RTINHERIT (and EXTSZINHERIT) on the root directory.  Make sure
>    the extent size hint is not a multiple of the rt extent size.
> 4. Call xfs_growfs -r to add the rt volume into the filesystem.
> 5. Create a file.  Due to RTINHERIT, the new file should be a realtime
>    file.
> 6. Check that the file is actually a realtime file and does not have an
>    extent size hint.
> 
> The regression of course happens in step 6, because xfs_growfs_rt can
> add a realtime volume to an existing filesystem.  Prior to this patch,
> the "has realtime?" predicate always looked at the mp->m_sb.  Now that
> the feature state has been turned into a separate xfs_mount state, we
> must set the REALTIME m_feature flag explicitly.
> 
> The following patch solves the regression:

I've added a variant of this to the patch - it just sets
XFS_FEAT_REALTIME directly without the "xfs_add_realtime()" wrapper.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
