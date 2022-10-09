Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335BBC4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiJIXol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiJIXoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:44:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0287C13F60
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 16:15:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8B95B8AD9B3;
        Mon, 10 Oct 2022 09:47:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ohf55-0004mb-9t; Mon, 10 Oct 2022 09:47:35 +1100
Date:   Mon, 10 Oct 2022 09:47:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216566] New: [xfstests generic/648] BUG: unable to handle
 page fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700 [xfs]
Message-ID: <20221009224735.GS3600936@dread.disaster.area>
References: <bug-216566-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216566-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=63434f88
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=7s3L7G-p9EHrk6z53l8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 09, 2022 at 05:47:49PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216566
> 
>             Bug ID: 216566
>            Summary: [xfstests generic/648] BUG: unable to handle page
>                     fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700
>                     [xfs]
>            Product: File System
>            Version: 2.5
>     Kernel Version: v6.1-rc0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> xfstests generic/648 hit kernel panic[1] on xfs with 64k directory block size
> (-n size=65536), before panic, there's a kernel assertion (not sure if it's
> related).
> 
> It's reproducable, but not easy. Generally I reproduced it by loop running
> generic/648 on xfs (-n size=65536) hundreds of time.
> 
> The last time I hit this panic on linux with HEAD=

Given that there have been no changes to XFS committed in v6.1-rc0
at this point in time, this won't be an XFS regression unless you
can reproduce it on 6.0 or 5.19 kernels, too. Regardless, I'd suggest
bisection is in order to find where the problem was introduced.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
