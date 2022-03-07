Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFA1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 05:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiCGFDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 00:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbiCGFDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 00:03:49 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14B416437
        for <linux-xfs@vger.kernel.org>; Sun,  6 Mar 2022 21:02:55 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0F5E952FBC4;
        Mon,  7 Mar 2022 16:02:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nR5WI-002TbF-Fi; Mon, 07 Mar 2022 16:02:54 +1100
Date:   Mon, 7 Mar 2022 16:02:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 14/17] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220307050254.GN59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-15-chandan.babu@oracle.com>
 <20220304075133.GJ59715@dread.disaster.area>
 <87ilsslg9w.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilsslg9w.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622591ff
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=bMbDq-AJlXnFEJZzJXsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 05, 2022 at 06:15:15PM +0530, Chandan Babu R wrote:
> On 04 Mar 2022 at 13:21, Dave Chinner wrote:
> > On Tue, Mar 01, 2022 at 04:09:35PM +0530, Chandan Babu R wrote:
> >> This commit upgrades inodes to use 64-bit extent counters when they are read
> >> from disk. Inodes are upgraded only when the filesystem instance has
> >> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> >> 
> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
.....
> >> +	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> >
> > If the answer is so we don't cancel a dirty transaction here, then
> > I think this check needs to be more explicit - don't even try to do
> > the upgrade if the number of extents we are adding will cause an
> > overflow anyway.
> >
> > As it is, wouldn't adding 2^47 - 2^31 extents in a single hit be
> > indicative of a bug? We can only modify the extent count by a
> > handful of extents (10, maybe 20?) at most in a single transaction,
> > so why do we even need this check?
> 
> Yes, the above call to xfs_iext_count_may_overflow() is not correct. The value
> of nr_to_add has to be larger than 2^17 (2^32 - 2^15 for attr fork and 2^48 -
> 2^31 for data fork) for extent count to overflow. Hence, I will remove this
> call to xfs_iext_count_may_overflow().

Would it be worth putting an assert somewhere with this logic in it?
That way we at least capture such bugs in debug settings and protect
ourselves from unintentional mistakes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
