Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B39C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 21 May 2022 22:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343598AbiEUWbw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 May 2022 18:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiEUWbv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 May 2022 18:31:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B97831C914
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 15:31:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 06A3F10E74BB;
        Sun, 22 May 2022 08:31:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nsXdS-00EoEc-Vq; Sun, 22 May 2022 08:31:47 +1000
Date:   Sun, 22 May 2022 08:31:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Message-ID: <20220521223146.GM1098723@dread.disaster.area>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
 <bug-216007-201763-l8R3pKFzHP@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216007-201763-l8R3pKFzHP@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62896856
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=jW9XMcD_w1WAFi1Y:21 a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=EvhzaQOGhtVETvwDhakA:9 a=CjuIK1q_8ugA:10
        a=4XdoLCUCO_b63ij2jC9c:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 21, 2022 at 05:14:36AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216007
> 
> --- Comment #4 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
> > What sort of storage subsystem does this machine have? If it's a spinning
> > disk then you've probably just filled memory
> 
> Yes, all the disks are classic spinning CMR disks. But, out of all file systems
> tried, only XFS is doing this on the test machine. I can trigger this behavior
> every time. And kernels from 5.10 and bellow still work, even with my
> non-standard .config.
> 
> Here is the memory situation when it is stuck:
> 
> ftp-back ~ # free
>                total        used        free      shared  buff/cache   available
> Mem:         3995528      175872       69240         416     3750416     3763584

Doesn't tell us a whole lot except for "no free memory to allocate
without reclaim". /proc/meminfo, /proc/vmstat and /proc/slabinfo
would tell us a lot more.

Also, knowing if you've tweaked things like dirty ratios, etc would
also be helpful...

> This may not be a XFS bug, but so far only XFS seems to suffer from it.

Not that uncommon, really. XFS puts a different load on the memory
allocation/reclaim and cache subsystems compared to other
filesystems, so XFS tends to trip over bugs that others don't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
