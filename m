Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878D5C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Jan 2022 22:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiAWWwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jan 2022 17:52:04 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54085 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232364AbiAWWwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jan 2022 17:52:04 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F378B62CC5A;
        Mon, 24 Jan 2022 09:52:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nBliL-003Q8Z-E4; Mon, 24 Jan 2022 09:52:01 +1100
Date:   Mon, 24 Jan 2022 09:52:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: CFQ or BFQ scheduler and XFS
Message-ID: <20220123225201.GK59729@dread.disaster.area>
References: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bb2c601dfffd38c2809c7c6f6a369a5@assyoma.it>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61eddc13
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=N1T0FlrwyI4qCENvTtIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 23, 2022 at 10:27:32PM +0100, Gionatan Danti wrote:
> Hi list,
> I have a question about CFQ scheduler and the old warning one can find on
> the faq page: "As of kernel 3.2.12, the default i/o scheduler, CFQ, will
> defeat much of the parallelization in XFS".
> 
> Can I ask for more information about the bad interaction between CFQ and
> XFS, and especially why it does defeat filesystem parallelization? Is this
> warning still valid? What about the newer BFQ?

CFQ doesn't understand that IO from different threads/tasks are
related and so it cannot account for/control multi-threaded IO
workloads.  Given that XFS's journal IO is inherently a
multi-threaded IO workload, CFQ IO accounting and throttling simply
does not work properly with XFS or any other filesystem that
decouples IO from the user task context that requires the IO to be
done on it's behalf.

> Note: I always used deadline or noop with XFS, but I am facing a disk with
> random read starvation when NCQ is enabled and a mixed sequential & random
> load happens. So far I saw that the only scheduler (somewhat) immune to the
> issue is CFQ, probably because it does not mix IO from multiple processes
> (it issue IO from one process at time, if I understand it correctly).

And, as per above, that's exactly why it doesn't work well with XFS...

Read starvation during sequential writes sounds more like a problem
with the block layer writeback throttle or something you need to
use an IO controller (blk-cgroups) to address, not try to fix with a
IO scheduler...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
