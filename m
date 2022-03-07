Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC26CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 04:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbiCGE4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Mar 2022 23:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiCGE4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Mar 2022 23:56:20 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B6695D1A4
        for <linux-xfs@vger.kernel.org>; Sun,  6 Mar 2022 20:55:26 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0B41752FE00;
        Mon,  7 Mar 2022 15:55:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nR5P1-002TUC-7a; Mon, 07 Mar 2022 15:55:23 +1100
Date:   Mon, 7 Mar 2022 15:55:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V7 06/17] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20220307045523.GM59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-7-chandan.babu@oracle.com>
 <20220304012952.GZ59715@dread.disaster.area>
 <87bkymgd21.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkymgd21.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6225903d
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=QyXUC8HyAAAA:8 a=7-415B0cAAAA:8
        a=PRCeTUT47p0C9XNNKRgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 05, 2022 at 06:13:21PM +0530, Chandan Babu R wrote:
> On 04 Mar 2022 at 06:59, Dave Chinner wrote:
> > On Tue, Mar 01, 2022 at 04:09:27PM +0530, Chandan Babu R wrote:
> >> A future commit will introduce a 64-bit on-disk data extent counter and a
> >> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> >> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> >> of these quantities.
> >> 
> >> Reported-by: kernel test robot <lkp@intel.com>
> >
> > What was reported by the test robot? This change isn't a bug that
> > needed fixing, it's a core part of the patchset...
> >
> 
> Kernel test robot had complained about the following,
> 
>   ld.lld: error: undefined symbol: __udivdi3
>   >>> referenced by xfs_bmap.c
>   >>>               xfs/libxfs/xfs_bmap.o:(xfs_bmap_compute_maxlevels) in archive fs/built-in.a
> 
> I had solved the linker error by replacing the division operation with the
> following statement,
> 
>   maxblocks = howmany_64(maxleafents, minleafrecs);
> 
> Sorry, I will include this description in the commit message.

Oh, I wouldn't even bother with a Reported-by tag then. It's just
like a reviewer pointing out that there was an issue with the patch
- you don't add "reported-by" for every little thing that someone
points out that you fix, right? You might mention who noticed it
in the changelog for the patch, but this sort of information does
not belong in the commit message for a new feature.

IOWs, reported-by is really only useful for referencing the bug
report for a regression or bug that was found in a released kernel
- it's not useful or meaningful for patches that are being developed
and have not yet been merged...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
