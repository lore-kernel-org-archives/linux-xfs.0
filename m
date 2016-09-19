Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37026 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcISVo6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Sep 2016 17:44:58 -0400
Subject: Re: Segfault with xfs_repair
References: <825fa296-903b-2241-a742-8af4e0b6dd9a@russenmafia.at>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ddfc433-d408-657e-87c7-f8efb0fcd2bb@sandeen.net>
Date: Mon, 19 Sep 2016 16:44:56 -0500
MIME-Version: 1.0
In-Reply-To: <825fa296-903b-2241-a742-8af4e0b6dd9a@russenmafia.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: admin <admin@russenmafia.at>, linux-xfs@vger.kernel.org

On 9/19/16 4:06 PM, admin wrote:
> Hi *,
> 
> so i got some problems using xfs_repair. (xfs_repair version 4.8.0-rc1)
> 
> xfs_repair /dev/mapper/daten
> ####
> Phase 6 - check inode connectivity...
> reinitializing root directory
> reinitializing realtime bitmap inode
> reinitializing realtime summary inode
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> bad hash table for directory inode 16384 (no data entry): rebuilding
> rebuilding directory inode 16384
> bad hash table for directory inode 16387 (no data entry): rebuilding
> rebuilding directory inode 16387
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected dir inode 16384, moving to lost+found
> Segmentation fault
> 
> Strace output doesn't help me either:
> 1472  <... futex resumed> )             = 0
> 1472  munmap(0x7f806d865000, 8392704)   = 0
> 1472  write(2, "        - traversal finished ..."..., 33) = 33
> 1472  write(2, "        - moving disconnected in"..., 55) = 55
> 1472  write(2, "disconnected dir inode 16384, ", 30) = 30
> 1472  write(2, "moving to lost+found\n", 21) = 21
> 1472  --- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR, si_addr=0x10000003f} ---
> 1472  +++ killed by SIGSEGV +++
> 
> 
> Any advice on how to proceed from there?

Either provide a debug binary + the core file, or run it through
valgrind, or better yet, do:

# xfs_metadump /dev/mapper/daten metadump.img
# bzip2 metadump.img

and provide the resulting bzip2'd file to me off-list, and I can probably
reproduce the problem and take a look at the bug.

Thanks,
-Eric
