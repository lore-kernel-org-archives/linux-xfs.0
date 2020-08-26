Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471DC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D940B20786
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 10:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHZKdv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 06:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgHZKdt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 06:33:49 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209039] xfs_fsr skips most of the files as no improvement will
 be made
Date:   Wed, 26 Aug 2020 10:33:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bfoster@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209039-201763-Mr4LOLSTcB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209039-201763@https.bugzilla.kernel.org/>
References: <bug-209039-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209039

--- Comment #1 from bfoster@redhat.com ---
On Wed, Aug 26, 2020 at 07:40:57AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=209039
> 
>             Bug ID: 209039
>            Summary: xfs_fsr skips most of the files as no improvement will
>                     be made
>            Product: File System
>            Version: 2.5
>     Kernel Version: 4.19.107-Unraid
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: marc@gutt.it
>         Regression: No
> 
> I checked the fragmentation factor of disk1 as follows:
> 
>     xfs_db -c frag -r /dev/md1
>     actual 1718, ideal 674, fragmentation factor 60.77%
>     Note, this number is largely meaningless.
>     Files on this filesystem average 2.55 extents per file
> 

Without knowing the details of your fs, it sounds like it's not very
fragmented from the cursory numbers.

> I tried to defrag disk1:
> 
>     xfs_fsr /dev/md1 -v -d
>     /mnt/disk1 start inode=0
>     ino=133
>     ino=133 extents=4 can_save=3 tmp=/mnt/disk1/.fsr/ag0/tmp23917
>     DEBUG: fsize=30364684107 blsz_dio=16773120 d_min=512 d_max=2147483136
> pgsz=4096
>     Temporary file has 4 extents (4 in original)
>     No improvement will be made (skipping): ino=133
>     ino=135
>     ino=135 extents=4 can_save=3 tmp=/mnt/disk1/.fsr/ag1/tmp23917
>     orig forkoff 288, temp forkoff 0
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 296
>     orig forkoff 288, temp forkoff 288
>     set temp attr
>     DEBUG: fsize=28400884827 blsz_dio=16773120 d_min=512 d_max=2147483136
> pgsz=4096
>     Temporary file has 4 extents (4 in original)
>     No improvement will be made (skipping): ino=135
>     ino=138
>     ...
> 
> This means the file would still consist of 4 parts across the hdd platter
> after
> defragmentation and because of that it's skipped. But why isn't it able to
> merge the parts of this and hundreds of other files?
> 

Note that fsr is not guaranteed to do anything. It simply attempts to
reallocate a file and if the new file has better contiguity than the
original, the old is swapped out for the new. The effectiveness depends
on how fragmented the original file is, how much contiguous free space
is available to create the new one, etc. It's usually not worth playing
with fsr unless you observe some measurable performance impact of
fragmentation (as opposed to just reading the fragmentation numbers,
which can be misleading). Is that the case here?

> More details about inode 133:
> 
>     xfs_db -r /dev/md1 -c "inode 133" -c "bmap -d"
>     data offset 0 startblock 1314074773 (4/240332949) count 2097151 flag 0
>     data offset 2097151 startblock 1316171924 (4/242430100) count 2097151
>     flag
> 0
>     data offset 4194302 startblock 1318269075 (4/244527251) count 2097151
>     flag
> 0
>     data offset 6291453 startblock 1320366226 (4/246624402) count 1121800
>     flag
> 0

In this case, it looks like you already have maximum sized (~8GB)
extents for the first three. The extent map for this file is as
efficient as it can possibly be on XFS.

Brian

> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
