Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQIpNqD010037 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:51:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B318E4AED3
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:51:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id MIuRxG72MEyJx4Mb for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:51:22 -0800 (PST)
Date: Fri, 26 Dec 2008 09:36:55 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_db 2.9.8: coredump
Message-ID: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com

# xfs_db -V
xfs_db version 2.9.8

p34:~# xfs_db -c frag -f /dev/sda1
Segmentation fault (core dumped)
p34:~# xfs_db -c frag -r /dev/sda1
Segmentation fault (core dumped)

(It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).

Now it can no longer check it?

===============================================================================

Program terminated with signal 11, Segmentation fault.
[New process 11346]
(gdb) bt
#0  0x00007f6a67c8c3e0 in ?? () from /lib/libc.so.6
#1  0x00007f6a67c8b43a in memmove () from /lib/libc.so.6
#2  0x0000000000403f2e in ?? ()
#3  0x0000000000412ff1 in ?? ()
#4  0x00000000004129cb in ?? ()
#5  0x0000000000413392 in ?? ()
#6  0x0000000000413833 in ?? ()
#7  0x0000000000412af3 in ?? ()
#8  0x0000000000413933 in ?? ()
#9  0x0000000000412af3 in ?? ()
#10 0x0000000000412d81 in ?? ()
#11 0x0000000000414af6 in ?? ()
#12 0x00007f6a67c2d1a6 in __libc_start_main () from /lib/libc.so.6
#13 0x0000000000402839 in ?? ()
#14 0x00007fff709e46a8 in ?? ()
#15 0x000000000000001c in ?? ()
#16 0x0000000000000005 in ?? ()
#17 0x00007fff709e5eb3 in ?? ()
#18 0x00007fff709e5eba in ?? ()
#19 0x00007fff709e5ebd in ?? ()
#20 0x00007fff709e5ec2 in ?? ()
#21 0x00007fff709e5ec5 in ?? ()
#22 0x0000000000000000 in ?? ()
(gdb) q
p34:~#

===============================================================================

[251994.093918] xfs_db[11095]: segfault at c40ff8 ip 00007f1a990a53e0 sp 00007fffa1dff608 error 4 in libc-2.7.so[7f1a99028000+14a000]
[252342.441918] xfs_db[11335]: segfault at eb2ff8 ip 00007fd8263cc3e0 sp 00007fff2f1258f8 error 4 in libc-2.7.so[7fd82634f000+14a000]
[252349.502317] xfs_db[11337]: segfault at fa5ff8 ip 00007f77340dc3e0 sp 00007fff3ce34608 error 4 in libc-2.7.so[7f773405f000+14a000]
[252381.346221] xfs_db[11346]: segfault at 1c71ff8 ip 00007f6a67c8c3e0 sp 00007fff709e41b8 error 4 in libc-2.7.so[7f6a67c0f000+14a000]
[252388.659308] xfs_db[11348]: segfault at 18caff8 ip 00007f2e0f0f93e0 sp 00007fff17e53628 error 4 in libc-2.7.so[7f2e0f07c000+14a000]

===============================================================================

The end of the strace for xfs_db -c frag -r /dev/sda1:

read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\2I"..., 1
6384) = 16384
lseek(4, 377470976, SEEK_SET)           = 377470976
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\2I"..., 1
6384) = 16384
lseek(4, 4711120683008, SEEK_SET)       = 4711120683008
read(4, "BMAP\0\0\0+\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377
\377\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(4, 377520128, SEEK_SET)           = 377520128
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\nI"..., 1
6384) = 16384
lseek(4, 4711209119744, SEEK_SET)       = 4711209119744
read(4, "BMAP\0\0\0=\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377
\377\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(4, 1480579043328, SEEK_SET)       = 1480579043328
read(4, "BMAP\0\0\0/\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377
\377\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(4, 377552896, SEEK_SET)           = 377552896
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\7I"..., 1
6384) = 16384
lseek(4, 377610240, SEEK_SET)           = 377610240
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3I"..., 1
6384) = 16384
lseek(4, 377675776, SEEK_SET)           = 377675776
read(4, "IN\201\244\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\5H"..
., 16384) = 16384
lseek(4, 377724928, SEEK_SET)           = 377724928
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\6I"..., 1
6384) = 16384
lseek(4, 377757696, SEEK_SET)           = 377757696
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10I"..., 
16384) = 16384
lseek(4, 377798656, SEEK_SET)           = 377798656
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\7I"..., 1
6384) = 16384
lseek(4, 377823232, SEEK_SET)           = 377823232
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\10I"..., 
16384) = 16384
lseek(4, 377856000, SEEK_SET)           = 377856000
read(4, "IN\201\244\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\6H"..
., 16384) = 16384
lseek(4, 1487440093184, SEEK_SET)       = 1487440093184
read(4, "BMAP\0\0\0\31\377\377\377\377\377\377\377\377\377\377\377\377\377\377\3
77\377\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
lseek(4, 377896960, SEEK_SET)           = 377896960
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\7I"..., 1
6384) = 16384
lseek(4, 377921536, SEEK_SET)           = 377921536
read(4, "IN\201\244\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\5I"..
., 16384) = 16384
lseek(4, 377946112, SEEK_SET)           = 377946112
read(4, "IN\0\0\2\2\0\0\0\0\3\350\0\0\0d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\2I"..., 1
6384) = 16384
lseek(4, 1488025448448, SEEK_SET)       = 1488025448448
read(4, "\354j8\243\207$\351\334e\232\5o<8\366y\255\350\215\340R\234`\5\332\247\
22\326\7D%c\214"..., 4096) = 4096
brk(0x2516000)                          = 0x2516000
brk(0x250a000)                          = 0x250a000
mmap(NULL, 188416, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7
fe1d1554000
brk(0x24fd000)                          = 0x24fd000
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV (core dumped) +++

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
