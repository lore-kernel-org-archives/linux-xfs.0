Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561EDC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267A3613C0
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhESWVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:21:30 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38684 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhESWVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:21:30 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8FC4568B7C;
        Thu, 20 May 2021 08:20:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljUXu-002w6w-VH; Thu, 20 May 2021 08:20:06 +1000
Date:   Thu, 20 May 2021 08:20:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, hsiangkao@aol.com
Subject: Re: regressions in xfs/168?
Message-ID: <20210519222006.GA664593@dread.disaster.area>
References: <20210519210205.GT9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519210205.GT9675@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=ItnuAVGJs5W-sGxVx-gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 02:02:05PM -0700, Darrick J. Wong wrote:
> Hm.  Does anyone /else/ see failures with the new test xfs/168 (the fs
> shrink tests) on a 1k blocksize?  It looks as though we shrink the AG so
> small that we trip the assert at the end of xfs_ag_resv_init that checks
> that the reservations for an AG don't exceed the free space in that AG,
> but tripping that doesn't return any error code, so xfs_ag_shrink_space
> commits the new fs size and presses on with even more shrinking until
> we've depleted AG 1 so thoroughly that the fs won't mount anymore.

Yup, now that I've got the latest fstests I see that failure, too.

[58972.431760] Call Trace:
[58972.432467]  xfs_ag_resv_init+0x1d3/0x240
[58972.433611]  xfs_ag_shrink_space+0x1bf/0x360
[58972.434801]  xfs_growfs_data+0x413/0x640
[58972.435894]  xfs_file_ioctl+0x32f/0xd30
[58972.439289]  __x64_sys_ioctl+0x8e/0xc0
[58972.440337]  do_syscall_64+0x3a/0x70
[58972.441347]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[58972.442741] RIP: 0033:0x7f7021755d87

> At a bare minimum we probably need to check the same thing the assert
> does and bail out of the shrink; or maybe we just need to create a
> function to adjust an AG's reservation to make that function less
> complicated.

So if I'm reading xfs_ag_shrink_space() correctly, it doesn't
check what the new reservation will be and so it's purely looking at
whether the physical range can be freed or not? And when freeing
that physical range results in less free space in the AG than the
reservation requires, we pop an assert failure rather than failing
the reservation and undoing the shrink like the code is supposed to
do?

IOWs, the problem is the ASSERT firing on debug kernels, not the
actual shrink code that does handle this reservation ENOSPC error
case properly? i.e. we've got something like an uncaught overflow
in xfs_ag_resv_init() that is tripping the assert? (e.g. used >
ask)

So I'm not sure that the problem is the shrink code here - it should
undo a reservation failure just fine, but the reservation code is
failing before we get there on a debug kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
