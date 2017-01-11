Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757558AbdAKOJc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 09:09:32 -0500
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
References: <20170110194249.GK14038@birch.djwong.org>
 <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1dec16e5-66ea-1876-1105-2219b6f1c17c@sandeen.net>
Date: Wed, 11 Jan 2017 08:09:30 -0600
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On 1/11/17 4:01 AM, Amir Goldstein wrote:
> Now I am hitting these xfs_db crashes during xfs/1316, which are apparently not
> related to OOM killer. I have seen them last run as well but dmesg is quiet now.

Please install debug bits and get a proper coredump, or try valgrind,
to get a real backtrace here so we can see what's going on...

Thanks,
-Eric
 
> xfs/1316        *** Error in `/usr/sbin/xfs_db': free(): invalid
> pointer: 0x00007f9dbf036b78 ***
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(+0x77725)[0x7f9dbecea725]
> /lib/x86_64-linux-gnu/libc.so.6(+0x7ff4a)[0x7f9dbecf2f4a]
> /lib/x86_64-linux-gnu/libc.so.6(cfree+0x4c)[0x7f9dbecf6abc]
> /usr/sbin/xfs_db[0x414961]
> /usr/sbin/xfs_db[0x4154de]
> /usr/sbin/xfs_db[0x420d38]
> /usr/sbin/xfs_db[0x420926]
> /usr/sbin/xfs_db[0x405125]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f9dbec93830]
> /usr/sbin/xfs_db[0x405179]
> ======= Memory map: ========
> 00400000-0049e000 r-xp 00000000 08:01 15995842
>   /usr/sbin/xfs_db
> 0069d000-0069e000 r--p 0009d000 08:01 15995842
>   /usr/sbin/xfs_db
> 0069e000-006a1000 rw-p 0009e000 08:01 15995842
>   /usr/sbin/xfs_db
> 006a1000-006b0000 rw-p 00000000 00:00 0
> 0119e000-011e0000 rw-p 00000000 00:00 0                                  [heap]
> 7f9db8000000-7f9db8021000 rw-p 00000000 00:00 0
> 7f9db8021000-7f9dbc000000 ---p 00000000 00:00 0
> 7f9dbea5d000-7f9dbea73000 r-xp 00000000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbea73000-7f9dbec72000 ---p 00016000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbec72000-7f9dbec73000 rw-p 00015000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbec73000-7f9dbee33000 r-xp 00000000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbee33000-7f9dbf032000 ---p 001c0000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf032000-7f9dbf036000 r--p 001bf000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf036000-7f9dbf038000 rw-p 001c3000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf038000-7f9dbf03c000 rw-p 00000000 00:00 0
> 7f9dbf03c000-7f9dbf054000 r-xp 00000000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf054000-7f9dbf253000 ---p 00018000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf253000-7f9dbf254000 r--p 00017000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf254000-7f9dbf255000 rw-p 00018000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf255000-7f9dbf259000 rw-p 00000000 00:00 0
> 7f9dbf259000-7f9dbf25d000 r-xp 00000000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf25d000-7f9dbf45c000 ---p 00004000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45c000-7f9dbf45d000 r--p 00003000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45d000-7f9dbf45e000 rw-p 00004000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45e000-7f9dbf484000 r-xp 00000000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf667000-7f9dbf66b000 rw-p 00000000 00:00 0
> 7f9dbf680000-7f9dbf683000 rw-p 00000000 00:00 0
> 7f9dbf683000-7f9dbf684000 r--p 00025000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf684000-7f9dbf685000 rw-p 00026000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf685000-7f9dbf686000 rw-p 00000000 00:00 0
> 7ffdde2cb000-7ffdde2ed000 rw-p 00000000 00:00 0                          [stack]
> 7ffdde366000-7ffdde368000 r--p 00000000 00:00 0                          [vvar]
> 7ffdde368000-7ffdde36a000 r-xp 00000000 00:00 0                          [vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
>   [vsyscall]
> *** Error in `/usr/sbin/xfs_db': free(): invalid pointer: 0x00007f202b108b78 ***
