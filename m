Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E2EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 23:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 345E961019
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 23:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244635AbhITXjl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:39:41 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57739 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240008AbhITXhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 19:37:41 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 3262989A95;
        Tue, 21 Sep 2021 09:36:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSSpX-00Ephy-Co; Tue, 21 Sep 2021 09:36:11 +1000
Date:   Tue, 21 Sep 2021 09:36:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20210920233611.GN1756565@dread.disaster.area>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920230635.GM1756565@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=VN5i81WXcHvmF2wlZfsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
> FWIW, an example of avoidable runtime calculation overhead of
> constants is xlog_calc_unit_res(). These values are actually
> constant for a given transaction reservation, but at 1.6 million
> transactions a second it shows up at #20 on the flat profile of
> functions using the most CPU:
> 
> 0.71%  [kernel]  [k] xlog_calc_unit_res
> 
> 0.71% of 32 CPUs for 1.6 million calculations a second of the same
> constants is a non-trivial amount of CPU time to spend doing
> unnecessary repeated calculations.
> 
> Even though the btree cursor constant calculations are simpler than
> the log res calculations, they are more frequent. Hence on general
> principles of efficiency, I don't think we want to be replacing high
> frequency, low overhead slab/zone based allocations with heap
> allocations that require repeated constant calculations and
> size->slab redirection....

FWIW, I have another example that I don't have profiles for right now
because I didn't record them in the patch series that ends up
pre-calculating the AIL push target: xlog_grant_push_threshold().

This threshold is largely a fixed value ahead of the current log
tail (push at >75% of the physical log spacei consumed). We
do that calculation more often than we call xlog_calc_unit_res().
Because xlog_grant_push_threshold() accesses contended atomic
variables, it ends up consume 1-2% of total CPU time when
transactions rates reach the million/s ballpark.

I've currently replaced it with a fixed push threshold calculated at
mount time and let the AIL calculate the LSN of the push target
itself when it needs it.  The result is a substantial reduction in
the CPU usage of the hot xfs_log_reserve() path, which also happens
to be the same hot path xlog_calc_unit_res() is called from...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
