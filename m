Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48482 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbfA1WAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 17:00:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 38B3D2B950
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 22:00:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Mon, 28 Jan 2019 22:00:12 +0000
Message-ID: <bug-202441-201763-0DpwTDtWVf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
Hi roger,

On Mon, Jan 28, 2019 at 08:41:36PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441

[...]

> I have a file system related problem where a compile job on a sata hdd almost
> stops and ui becomes unresponsive when copying large files at the same time,
> regardless of to what disk or from where they are copied.

Thanks for the detailed bug report! I'll need some more information
about your system and storage to understand (and hopefully
reproduce) the symptoms you are seeing. Can you provide the
information listed here, please?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> All testing has been done on "bare metal" without even md, lvm or similar.
> I have done a lot of testing of many different kernel versions on two
> different
> systems (Slackware 14.2 and "current") and I feel confident that this is a
> kernel regression.
> 
> The problem is _very_ pronounced when using xfs and it is only present from
> kernel version 4.19.0 and all following versions NOT before (I have not
> tested
> any 4.19 rc versions). I have tested many of them including the latest
> 4.19.18
> and 5.0-rc3 with varying configurations and some very limited testing on
> 4.20.4.
> 
> It affects jfs, ext2, ext3, ext4 also but to a much lesser extent.
> btrfs and reiserfs does not seem to be affected at all, at least not on the
> 4.19 series.

Ok, that's interesting, because it's the second report of similar
problems on 4.19:

https://bugzilla.kernel.org/show_bug.cgi?id=202349

I've not been able to reproduce the problems as documented in that
bug because all my test systems are headless, but in trying to
reproduce it I have seen some concerning behaviour that leads to
massive slowdowns that I don't ever recall seeing before. I'm hoping
that your problem is what I've seen, and not something different.

> After adding another 16GB ram on one of my testing machines I noticed that it
> took much more time before the compile job slowed down and ui became
> unresponsive, so I suspected some cache related issue.
> I made a few test runs and while watching "top" I observed that as soon as
> buff/cache passed ~ 23G (total 24G) while copying, the compile job slowed
> down
> to almost a halt, while the copying also slowed down significantly.
> 
> After echo 0 >/proc/sys/vm/vfs_cache_pressure the compilation runs without
> slowdown all the way through, while copying retains its steady +100MB/sec.
> This "solution" is tested on 4.19.17-18 with "generic" Slackware config
> and 5.0-rc3 both on xfs.

Ok, so you turn off inode reclaim, and so page cache pressure
doesn't cause inodes to be reclaimed anymore. That's something I've
tested, and while it does alleviate the symptoms it eventually ends
up OOM killing the test machines dead because the inode cache takes
all of memory and can't be reclaimed. This is a documented side
effect of this modification - Documentation/sysctl/vm.txt:

        [....] When vfs_cache_pressure=0, the kernel will never
        reclaim dentries and inodes due to memory pressure and this
        can easily lead to out-of-memory conditions. [....]

> Here's how I hit this issue every time on a pre-zen AMD:
> 
> 1. A decent amount of data to copy, probably at least 5-10 times as much as
> ram
> and reasonably fast media (~100Mb/sec) to copy from and to (Gbit nfs mount,
> usb3 drive, regular hard drive...).

Ok, so you add a large amount of page cache pressure, some dirty
inodes.

> 2. A dedicated xfs formatted regular rotating hard drive for the compile job
> (I
> suppose any io-latency sensitive parallellizable job will do), This problem
> is
> probably present for ssd's as well, but because they are so fast, cache
> becomes
> less of an issue and you will maybe not notice much, at least I don't.

Ok, so now you add memory pressure (gcc) along with temporary and
dirty XFS inodes. Is the system swapping?

Can you get me the dmesg output of several samples (maybe 10?) of
"echo w > /sysrq/trigger" a few seconds apart when the compile job
is running?

> Under these circumstances a defconfig kernel compile (ver 4.19.17) takes
> about
> 3min 35s on 4.18.20 (xfs) and sometimes more than an hour using any version
> after it. On Slackware "current" I use gcc 8.2.0 multilib, on 14.2 regular
> gcc
> 5.5.0 which seemed to produce slightly better results.

I note that in 4.19 there was a significant rework of the mm/ code
that drives the shrinkers that do inode cache reclaim. I suspect
we are seeing the fallout of these changes - are you able to confirm
that the change occurred between 4.18 and 4.19-rc1 and perhaps run a
bisect on the mm/ directory over that window?

Thanks again for the detailed bug report!

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
