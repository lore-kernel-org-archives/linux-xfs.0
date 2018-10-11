Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f42.google.com ([209.85.166.42]:33608 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbeJKNNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:13:22 -0400
Received: by mail-io1-f42.google.com with SMTP id l25-v6so5717409ioj.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 22:47:43 -0700 (PDT)
MIME-Version: 1.0
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Thu, 11 Oct 2018 10:47:31 +0500
Message-ID: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
Subject: xfs_bmap stuck at ~/.steam/steam.pipe file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When I researched the most fragmented files, I found that xfs_bmap
stuck at the file /home/mikhail/.steam/steam.pipe.

Can you look why it happens?

$ xfs_bmap -V
xfs_bmap version 4.18.0


Here backtrace of xfs_bmap process:
(gdb) thread apply all bt full

Thread 1 (Thread 0x7fe0a8c86880 (LWP 21024)):
#0  0x00007fe0a92f649f in __libc_open64
(file=file@entry=0x7ffcdf5dfaa5 "/home/mikhail/.steam/steam.pipe",
oflag=oflag@entry=0) at ../sysdeps/unix/sysv/linux/open64.c:48
        resultvar = 18446744073709551104
        sc_ret = <optimized out>
        mode = 0
#1  0x0000559b98519bab in open64 (__oflag=0, __path=0x7ffcdf5dfaa5
"/home/mikhail/.steam/steam.pipe") at /usr/include/bits/fcntl2.h:59
No locals.
#2  openfile (path=0x7ffcdf5dfaa5 "/home/mikhail/.steam/steam.pipe",
geom=0x7ffcdf5df110, flags=1, mode=384, fs_path=0x7ffcdf5df0d0) at
open.c:82
        fsp = <optimized out>
        fd = <optimized out>
        oflags = 0
#3  0x0000559b98513540 in init (argc=7, argv=0x7ffcdf5df3c8) at init.c:217
        c = <optimized out>
        flags = 1
        sp = 0x0
        mode = 384
        geometry = {blocksize = 0, rtextsize = 0, agblocks = 0,
agcount = 0, logblocks = 0, sectsize = 0, inodesize = 0, imaxpct = 0,
datablocks = 0, rtblocks = 0, rtextents = 0, logstart = 0, uuid =
'\000' <repeats 15 times>, sunit = 0, swidth = 0, version = 0, flags =
0, logsectsize = 0, rtsectsize = 0, dirblocksize = 0, logsunit = 0}
        fsp = {fs_name = 0x0, fs_datadev = 0, fs_log = 0x7fe0a90169e0
"", fs_logdev = 140602884845488, fs_rt = 0x0, fs_rtdev = 0, fs_dir =
0x0, fs_flags = 0, fs_prid = 0}
#4  0x0000559b98512edd in main (argc=<optimized out>, argv=<optimized
out>) at init.c:261
No locals.
(gdb)


Thanks.

--
Best Regards,
Mike Gavrilov.
