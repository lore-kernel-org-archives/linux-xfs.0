Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1273C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 01:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbiEYBhc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 21:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiEYBhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 21:37:32 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23D837220D
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 18:37:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DDA0C5345F3;
        Wed, 25 May 2022 11:37:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntfxl-00G33M-3a; Wed, 25 May 2022 11:37:25 +1000
Date:   Wed, 25 May 2022 11:37:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfsprogs: 5.19 libxfs kernel sync
Message-ID: <20220525013725.GE1098723@dread.disaster.area>
References: <20220524070543.GA1098723@dread.disaster.area>
 <87tu9frtsq.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu9frtsq.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628d8857
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=aSPawknbC3q46MLxOgMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 06:01:15PM +0530, Chandan Babu R wrote:
> On Tue, May 24, 2022 at 05:05:43 PM +1000, Dave Chinner wrote:
> > Hi folks,
> >
> > Now that the 5.19 kernel code is largely stablised for the first
> > merge, I've been starting to get together the libxfs sync tree for
> > xfsprogs with all those changes in it. I have built a branch
> > that can be found here:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev.git libxfs-5.19-sync
> >
> > that contains my work in progress so far. It's build on top of the
> > current xfsprogs for-next branch. I've ported across everything up
> > to the start of the LARP series so far, so I have done the porting
> > of the large extent count work and all the other bits and pieces for
> > log changes and so on.
> >
> > For the large extent count work, I have not added any of the
> > specific new xfsprogs functionality like mkfs, etc. Patches 14-18
> > of Chandan's V7 patch series here:
> >
> > https://lore.kernel.org/linux-xfs/20220321052027.407099-1-chandan.babu@oracle.com/
> >
> > still need to be ported on top of this for the functionality to be
> > fully supported in xfsprogs.
> >
> > Chandan, can you port those changes over to this libxfs sync branch
> > and check that I haven't missed anything in the conversion? I did
> > pick up one of your patches from that series - "Introduce per-inode
> > 64-bit extent counters" - because of all the xfs_db bits in it for
> > the change in on-disk format, but otherwise I've largely just worked
> > through fixing all the compiler errors and converting the xfsprogs
> > code over to the new functions and types.
> >
> > If you port the ramin patches over to thsi branch and test them,
> > I'll include them into the branch. I'll be checking for stability
> > and regressions on this brnach for the next couple of days, and if
> > everythign looks OK I'll send Eric a pull request for it....
> 
> Apart from a single nit, The "large extent counter" patches already included
> in libxfs sync branch look good.
> 
> My original patch "xfs: Introduce xfs_dfork_nextents() helper" had an
> invocation of "xfs_dfork_data_extents(dip);" in process_dev_inode() instead of
> "xfs_dfork_nextents(dip, XFS_DATA_FORK);".

Ok, thatnks for finding that - I'll update the branch I have with
that fix, it shouldn't affect anything else you do on top of it...

> I will try to port the remaining patches by today and will run xfstests
> overnight. I will post the patches tomorrow if the test execution doesn't
> reveal any bugs.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
