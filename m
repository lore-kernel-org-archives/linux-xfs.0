Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp01.udag.de ([62.146.106.17]:49758 "EHLO smtp01.udag.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932382AbcISVPF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Sep 2016 17:15:05 -0400
Received: from [192.168.123.1] (84-112-186-65.cable.dynamic.surfer.at [84.112.186.65])
        by smtp01.udag.de (Postfix) with ESMTPA id 664C41E8
        for <linux-xfs@vger.kernel.org>; Mon, 19 Sep 2016 23:06:49 +0200 (CEST)
From: admin <admin@russenmafia.at>
Subject: Segfault with xfs_repair
Message-ID: <825fa296-903b-2241-a742-8af4e0b6dd9a@russenmafia.at>
Date: Mon, 19 Sep 2016 23:06:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi *,

so i got some problems using xfs_repair. (xfs_repair version 4.8.0-rc1)

xfs_repair /dev/mapper/daten
####
Phase 6 - check inode connectivity...
reinitializing root directory
reinitializing realtime bitmap inode
reinitializing realtime summary inode
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
bad hash table for directory inode 16384 (no data entry): rebuilding
rebuilding directory inode 16384
bad hash table for directory inode 16387 (no data entry): rebuilding
rebuilding directory inode 16387
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
disconnected dir inode 16384, moving to lost+found
Segmentation fault

Strace output doesn't help me either:
1472  <... futex resumed> )             = 0
1472  munmap(0x7f806d865000, 8392704)   = 0
1472  write(2, "        - traversal finished ..."..., 33) = 33
1472  write(2, "        - moving disconnected in"..., 55) = 55
1472  write(2, "disconnected dir inode 16384, ", 30) = 30
1472  write(2, "moving to lost+found\n", 21) = 21
1472  --- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR, 
si_addr=0x10000003f} ---
1472  +++ killed by SIGSEGV +++


Any advice on how to proceed from there?

cheers!

