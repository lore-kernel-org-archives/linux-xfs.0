Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5876CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 21:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AC220663
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 21:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbfJXVue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 17:50:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53524 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfJXVue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 17:50:34 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9445D36407E;
        Fri, 25 Oct 2019 08:50:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iNkzz-0006Oc-UY; Fri, 25 Oct 2019 08:50:27 +1100
Date:   Fri, 25 Oct 2019 08:50:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question about logbsize default value
Message-ID: <20191024215027.GC4614@dread.disaster.area>
References: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00242d70-1d8e-231d-7ba0-1594412714ad@assyoma.it>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=g1Dio2bNPoynHb7tUgoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 23, 2019 at 11:40:33AM +0200, Gionatan Danti wrote:
> Hi list,
> on both the mount man page and the doc here [1] I read that when the
> underlying RAID stripe unit is bigger than 256k, the log buffer size
> (logbsize) will be set at 32k by default.
> 
> As in my tests (on top of software RAID 10 with 512k chunks) it seems that
> using logbsize=256k helps in metadata-heavy workload, I wonder why the
> default is to set such a small log buffer size.
> 
> For example, given the following array:
> 
> md126 : active raid10 sda1[3] sdb1[1] sdc1[0] sdd1[2]
>       268439552 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>       bitmap: 1/3 pages [4KB], 65536KB chunk
> 
> running "fs_mark  -n  1000000  -k  -S  0  -D  1000  -N  1000  -s  16384 -d
> /mnt/xfs/" shows the following results:
> 
> 32k  logbsize (default, due to 512k chunk size): 3027.4 files/sec
> 256k logbsize (manually specified during mount): 4768.4 files/sec
> 
> I would naively think that logbsize=256k would be a better default. Am I
> missing something?

Defaults are for best compatibility and general behaviour, not
best performance. A log stripe unit of 32kB allows the user to
configure a logbsize appropriate for their workload, as it supports
logbsize of 32kB, 64kB, 128kB and 256kB. If we chose 256kB as the
default log stripe unit, then you have no opportunity to set the
logbsize appropriately for your workload.

remember, LSU determines how much padding is added to every non-full
log write - 32kB pads out ot 32kB, 256kB pads out to 256kB. Hence if
you have a workload that frequnetly writes non-full iclogs (e.g.
regular fsyncs) then a small LSU results in much better performance
as there is less padding that needs to be initialised and the IOs
are much smaller.

Hence for the general case (i.e. what the defaults are aimed at), a
small LSU is a much better choice. you can still use a large
logbsize mount option and it will perform identically to a large LSU
filesystem on full iclog workloads (like the above fsmark workload
that doesn't use fsync). However, a small LSU is likely to perform
better over a wider range of workloads and storage than a large LSU,
and so small LSU is a better choice for the default....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
