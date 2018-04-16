Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47866 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753269AbeDPT5g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:57:36 -0400
Subject: Re: XFS reports in-memory corruption and unmounts filesystem
References: <CAG+d3v+rMvN=N4adMLC+mhY8FgWrdTior1bToVzb4YBK89UjqQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9f04c538-2972-1fe3-085e-6a1fd0359465@sandeen.net>
Date: Mon, 16 Apr 2018 14:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAG+d3v+rMvN=N4adMLC+mhY8FgWrdTior1bToVzb4YBK89UjqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dheeraj Sangamkar <dheerajrs@gmail.com>, linux-xfs@vger.kernel.org



On 4/16/18 2:13 PM, Dheeraj Sangamkar wrote:
> Hello,
> 
> I have a few linux boxes where I see xfs error messages when the
> filesystem becomes full.
> I saw quite a few reports of this kind of crash but none that had
> exactly the same backtrace as the one I found. So, here it is..
> 
> The kernel log:


> Jan 9 20:09:33 linux-box kernel: 1,1871,248971320,-;XFS (dm-17): Internal error xfs_trans_cancel at line 1005 of file /build/src/linux-4.9.51/fs/xfs/xfs_trans.c. Caller xfs_create+0x44d/0x6c0 [xfs]
> Jan 9 20:09:33 linux-box kernel: 4,1872,248985454,-;CPU: 11 PID: 27044 Comm: xxxxxx Tainted: G O 4.9.0-4-amd64 #1 Debian 4.9.51-1+ntap1

Can you reproduce this on an upstream kernel?

(and can you find a way to not wrap your emails so stuff like the below is readable) ;)

> Jan 9 20:09:33 linux-box kernel: 4,1873,248994971,-;Hardware name: ..........
> Jan 9 20:09:33 linux-box kernel: 4,1874,249005526,-; 0000000000000000 ffffffff99729974 ffff95c11afaae80 0000000000000001
> Jan 9 20:09:33 linux-box kernel: 4,1875,249012916,-; ffffffffc0a041ed ffff95c15b407800 ffff95c1c0949000 00000000ffffffe4
> Jan 9 20:09:33 linux-box kernel: 4,1876,249020305,-; ffffffffc09f70fd 0000000000000001 ffffb23f2279bbf0 0000000000000000
> Jan 9 20:09:33 linux-box kernel: 4,1877,249027694,-;Call Trace:
> Jan 9 20:09:33 linux-box kernel: 4,1878,249030129,-; [<ffffffff99729974>] ? dump_stack+0x5c/0x78
> Jan 9 20:09:33 linux-box kernel: 4,1879,249035474,-; [<ffffffffc0a041ed>] ? xfs_trans_cancel+0xad/0xd0 [xfs]
> Jan 9 20:09:33 linux-box kernel: 4,1880,249041843,-; [<ffffffffc09f70fd>] ? xfs_create+0x44d/0x6c0 [xfs]
> Jan 9 20:09:33 linux-box kernel: 4,1881,249047823,-; [<ffffffff99660000>] ? load_elf_binary+0x12c0/0x1640
> Jan 9 20:09:33 linux-box kernel: 4,1882,249053930,-; [<ffffffffc09f41ec>] ? xfs_generic_create+0x23c/0x2e0 [xfs]
> Jan 9 20:09:33 linux-box kernel: 4,1883,249060597,-; [<ffffffff99612888>] ? path_openat+0x1338/0x1440
> Jan 9 20:09:33 linux-box kernel: 4,1884,249066314,-; [<ffffffff994f6264>] ? futex_wake+0x94/0x170
> Jan 9 20:09:33 linux-box kernel: 4,1885,249071682,-; [<ffffffff99613c51>] ? do_filp_open+0x91/0x100
> Jan 9 20:09:33 linux-box kernel: 4,1886,249077224,-; [<ffffffff995fedba>] ? __check_object_size+0xfa/0x1d8
> Jan 9 20:09:33 linux-box kernel: 4,1887,249083370,-; [<ffffffff9960162e>] ? do_sys_open+0x12e/0x210
> Jan 9 20:09:33 linux-box kernel: 4,1888,249088914,-; [<ffffffff99a085bb>] ? system_call_fast_compare_end+0xc/0x9b
> Jan 9 20:09:33 linux-box kernel: 5,1889,249095715,-;XFS (dm-17): xfs_do_force_shutdown(0x8) called from line 1006 of file /build/src/linux-4.9.51/fs/xfs/xfs_trans.c. Return address = 0xffffffffc0a04206
> Jan 9 20:09:33 linux-box kernel: 1,1890,249110179,-;XFS (dm-17): Corruption of in-memory data detected. Shutting down filesystem
> Jan 9 20:09:33 linux-box kernel: 1,1891,249118348,-;XFS (dm-17): Please umount the filesystem and rectify the problem(s)

Ok, this is actually canceling a dirty transaction, which is the root of the problem.

> Upon running xfs repair, I see the following:
> 
> Output of xfs_repair on the rangedb device:
> root@another-linux-box:/ # xfs_repair -n /dev/sdk
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> sb_icount 4710720, counted 4711168
> sb_ifree 560, counted 0
> sb_fdblocks 95850, counted 8321

I'm going to guess that this might have a dirty log, and you should
mount/umount it before running repair, and that if you do so you'll
see no corruption here.

>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 3
>         - agno = 2
>         - agno = 1
>         - agno = 4
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> root@another-linux-box:/
> 
> Remounting the volume makes the content accessible for a while.
> However, eventually, some file lookup fails with ENOENT and the
> filesystem is unmounted.
> 
> I am not able to create the problem at will.
> 
> Is this problem new/fixed?

Maybe with 

commit f59cf5c29919d17b61913c3360a7bd29b72975c1
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Dec 4 17:32:55 2017 -0800

    xfs: remove "no-allocation" reservations for file creations
    
    If we create a new file we will need an inode, and usually some metadata
    in the parent direction.  Aiming for everything to go well despite the
    lack of a reservation leads to dirty transactions cancelled under a heavy
    create/delete load.  This patch removes those nospace transactions, which
    will lead to slightly earlier ENOSPC on some workloads, but instead
    prevent file system shutdowns due to cancelling dirty transactions for
    others.

but honestly debugging 2 year old kernels is more a question for your distro
than for upstream...

> Was the corruption only in memory or on disk as well?

it's not actually corruption, that's a poorly worded error message TBH.

> Why did xfs_repair not detect the corruption?

Because there is no corruption on the disk.

-Eric
