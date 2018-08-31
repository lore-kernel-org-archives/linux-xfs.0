Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43492 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbeHaFbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 01:31:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 430F32C092
        for <linux-xfs@vger.kernel.org>; Fri, 31 Aug 2018 01:26:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Fri, 31 Aug 2018 01:26:46 +0000
Message-ID: <bug-200981-201763-8OX7m1RWO0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200981-201763@https.bugzilla.kernel.org/>
References: <bug-200981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200981

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Thu, Aug 30, 2018 at 02:32:35PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=200981
> 
> kernel: vanilla 4.18.5
> gcc (Ubuntu 7.3.0-16ubuntu3) 7.3.0
> Copyright (C) 2017 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> More or less reproducible for me using next sequence:
> 
> - on host:
>   create LV of appropriate size (20g in my case)
>   mkfs.xfs -m reflink=1 /dev/data/LV
>   mount /dev/data/LV /mnt/
>   run kvm VM with qcow2 image (/mnt/disk)    
> 
> - inside vm:
>   sysbench --test=fileio --file-total-size=9G prepare
> 
> - on host:
>   cp --reflink=always disk disk.b
> 
> - inside vm: 
>   sysbench --test=fileio --file-total-size=9G --file-test-mode=seqwr
> --max-time=6000 --max-requests=0 --threads=16 run
> 
> Some time after i/o on /dev/data/LV fall to zero and fs become completely
> unavailable and then I see a bunch of records:

The first error is this:

[ 2212.046108] ================================================
[ 2212.051809] WARNING: lock held when returning to user space!
[ 2212.057511] 4.18.5 #1 Not tainted
[ 2212.060864] ------------------------------------------------
[ 2212.066564] worker/6123 is leaving the kernel with locks still held!
[ 2212.072961] 1 lock held by worker/6123:
[ 2212.076835]  #0: 000000009eab4f1b (sb_internal#2){.+.+}, at:
xfs_trans_alloc+0x17c/0x220

Which happens 5 minutes before the hung processes start being
reported. Looks like something has gone wrong and an error path has
leaked a transaction.

Can you see if commit dcbd44f79986 ("xfs: fix transaction leak on
remote attr set/remove failure") addresses the problem you are
seeing?

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
