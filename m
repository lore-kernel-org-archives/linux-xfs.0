Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44642 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbfA2A3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 19:29:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 537C72B4DC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 00:29:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Tue, 29 Jan 2019 00:29:38 +0000
Message-ID: <bug-202441-201763-xDT6Dzv60A@https.bugzilla.kernel.org/>
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

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
On Mon, Jan 28, 2019 at 11:26:32PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #2 from Roger (rogan6710@gmail.com) ---
> 
> Hello Dave !
> Thanks for the really fast reply :)
> Here is most of the (rather lengthy) system information:
> 
> Single "eight" core processor:
> 
> rogan@trooper:~$ uname -a
> Linux trooper.morgoth.org 4.19.18 #2 SMP Sat Jan 26 13:43:16 CST 2019 x86_64
> AMD FX(tm)-9590 Eight-Core Processor AuthenticAMD GNU/Linux
> 
> root@trooper:~# xfs_repair -V
> xfs_repair version 4.19.0
> 
> root@trooper:~# cat /proc/meminfo 
> MemTotal:       24645396 kB
> MemFree:          358452 kB
> MemAvailable:   22044292 kB
> Buffers:            3152 kB
> Cached:         22005216 kB
> SwapCached:            0 kB
> Active:          1713092 kB
> Inactive:       21824100 kB
> Active(anon):    1157816 kB
> Inactive(anon):   555736 kB
> Active(file):     555276 kB
> Inactive(file): 21268364 kB
....
> Slab:             565012 kB
> SReclaimable:     502684 kB

Ok, so memory is completely used by the page cache, and there is
some inode/dentry cache overhead in the slab caches.

Nothing unusual in the rest of the output , either.

>  xfs_info /dev/sdc1
> xfs_info: /dev/sdc1 contains a mounted filesystem
> 
> fatal error -- couldn't initialize XFS library
> 
> hmm ?

$ man xfs_info
...
        xfs_info [ -t mtab ] mount-point
...
        [...] The mount-point argument is the pathname of the
        directory where the filesystem is mounted. [...]

$ sudo mount /dev/vdc /mnt/scratch
$ sudo xfs_info /dev/vdc
xfs_info: /dev/vdc contains a mounted filesystem

fatal error -- couldn't initialize XFS library
$ sudo xfs_info /mnt/scratch
meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$

> I'll do a quick run and give you some dmesg

OK, that'll be interesting :)

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
