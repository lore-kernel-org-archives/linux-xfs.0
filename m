Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B79BC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 21:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0480860232
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 21:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbhHZVSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 17:18:45 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44866 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhHZVSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Aug 2021 17:18:44 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 299C2104AF27;
        Fri, 27 Aug 2021 07:17:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mJMky-005JYV-Pm; Fri, 27 Aug 2021 07:17:52 +1000
Date:   Fri, 27 Aug 2021 07:17:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xs_ig_attempts =?utf-8?B?4omgIHhzX2ln?= =?utf-8?Q?=5Ffound?= +
 xs_ig_missed
Message-ID: <20210826211752.GN3657114@dread.disaster.area>
References: <e9072acd-2daa-96da-f1f2-bca7870d6b55@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9072acd-2daa-96da-f1f2-bca7870d6b55@molgen.mpg.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=5KLPUuaC_9wA:10 a=7-415B0cAAAA:8
        a=QZnRqybkWLmsy2NMUrUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 10:36:41AM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> In the internal statistics [1] the attempts to look up an inode in the inode
> cache (`xs_ig_attempts`) is a little bigger (35) than the sum of found and
> missed entries minus duplicates (`xfs.inode_ops.ig_dup`): 651067226 =
> 651067191 + 35 > 651067191 = 259143798 + 391923706 - 313.
> 
>     $ grep ^ig /sys/fs/xfs/sdc/stats/stats # hardware RAID
>     ig 651067226 259143798 75 391923706 313 391196609 8760483
> 
> For the software RAID device there is no difference: 794085909 = 293058663 +
> 501027325 - 79.
> 
>     $ grep ^ig /sys/fs/xfs/md0/stats/stats
>     ig 794085909 293058663 18555 501027325 79 500997366 320679
> 
> Is the first difference expected?

Yes. XFS stats are low overhead unsynchronised per-cpu counters,
never guaranteed to be perfectly accurate or consistent because,
well, unsycnhronised per-cpu counters are neither.

IOWs, individual counters are never "point in time" accurate because of
counter update races during aggregation. Multiple counters are never
"point in time" synchronised, either, as individual
counters are aggregated sequentially and hence have different,
unsynchronised sampling times.

IOWs, the stats are not really meaningful as aboslute values - they
are generally used for monitoring purposes via delta sampling (e.g.
"how many of these events happened in the last second") or checking
that certain operations have occurred as a basic code coverage check
for developers (e.g. did we split the freespace inode btree at all
during a fstests run?).....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
