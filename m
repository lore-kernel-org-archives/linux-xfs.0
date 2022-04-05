Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BBBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 05:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiDEF25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiDEF24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 01:28:56 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1944F35272
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 22:26:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 531C810E567A;
        Tue,  5 Apr 2022 15:26:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbbiS-00DwUJ-SN; Tue, 05 Apr 2022 15:26:56 +1000
Date:   Tue, 5 Apr 2022 15:26:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215804] New: [xfstests generic/670] Unable to handle kernel
 paging request at virtual address fffffbffff000008
Message-ID: <20220405052656.GV1544202@dread.disaster.area>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=624bd322
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=9pLDvDoYkmKJyd31:21 a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=QrtX6K2Hc1lpGlIrNRwA:9
        a=CjuIK1q_8ugA:10 a=n7drqJQfYvJZ14RCwtyM:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

On Tue, Apr 05, 2022 at 04:44:35AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215804
> 
>             Bug ID: 215804
>            Summary: [xfstests generic/670] Unable to handle kernel paging
>                     request at virtual address fffffbffff000008
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-5.18-merge-4
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
> xfstests generic/670 hit a panic[1] on 64k directory block size XFS (mkfs.xfs
> -n size=65536 -m rmapbt=1 -b size=1024):
.....
> [37285.246770] Call trace: 
> [37285.246952]  __split_huge_pmd+0x1d8/0x34c 
> [37285.247246]  split_huge_pmd_address+0x10c/0x1a0 
> [37285.247577]  try_to_unmap_one+0xb64/0x125c 
> [37285.247878]  rmap_walk_file+0x1dc/0x4b0 
> [37285.248159]  try_to_unmap+0x134/0x16c 
> [37285.248427]  split_huge_page_to_list+0x5ec/0xcbc 
> [37285.248763]  truncate_inode_partial_folio+0x194/0x2ec 
> [37285.249128]  truncate_inode_pages_range+0x2e8/0x870 
> [37285.249483]  truncate_pagecache_range+0xa0/0xc0 

That doesn't look like an XFS regression, more likely a bug in the
new large folios in the page cache feature. Can you revert commit
6795801366da ("xfs: Support large folios") and see if the problem
goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
