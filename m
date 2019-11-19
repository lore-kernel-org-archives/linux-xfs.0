Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E67C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9765A22448
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 20:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSUUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 15:20:43 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43195 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727036AbfKSUUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 15:20:43 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D3B7B43F267;
        Wed, 20 Nov 2019 07:20:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iX9zK-0007Sr-9T; Wed, 20 Nov 2019 07:20:38 +1100
Date:   Wed, 20 Nov 2019 07:20:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrew Carr <andrewlanecarr@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
Message-ID: <20191119202038.GX4614@dread.disaster.area>
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net>
 <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
 <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10
        a=fGO4tVQLAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=N1O1NsOVjItdCAkIEK8A:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 10:49:56AM -0500, Andrew Carr wrote:
> Dave / Eric / Others,
> 
> Syslog: https://pastebin.com/QYQYpPFY
> 
> Dmesg: https://pastebin.com/MdBCPmp9

which shows no stack traces, again.



Anyway, you've twiddled mkfs knobs on these filesystems, and that
is the likely cause of the issue: the filesystem is using 64k
directory blocks - the allocation size is larger than 64kB:

[Sun Nov 17 21:40:05 2019] XFS: nginx(31293) possible memory allocation deadlock size 65728 in kmem_alloc (mode:0x250)

Upstream fixed this some time ago:

$ ▶ gl -n 1 -p cb0a8d23024e
commit cb0a8d23024e7bd234dea4d0fc5c4902a8dda766
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Mar 6 17:03:28 2018 -0800

    xfs: fall back to vmalloc when allocation log vector buffers
    
    When using large directory blocks, we regularly see memory
    allocations of >64k being made for the shadow log vector buffer.
    When we are under memory pressure, kmalloc() may not be able to find
    contiguous memory chunks large enough to satisfy these allocations
    easily, and if memory is fragmented we can potentially stall here.
    
    TO avoid this problem, switch the log vector buffer allocation to
    use kmem_alloc_large(). This will allow failed allocations to fall
    back to vmalloc and so remove the dependency on large contiguous
    regions of memory being available. This should prevent slowdowns
    and potential stalls when memory is low and/or fragmented.
    
    Signed-Off-By: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
