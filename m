Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R7HACU204289 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 02:17:10 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 004E041750A
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:20:42 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id ktebPE1GtVWk4PCr
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:20:42 -0700 (PDT)
Received: by vws13 with SMTP id 13so1169067vws.26
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 00:20:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Apr 2011 12:47:57 +0530
Message-ID: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
Subject: xfstests 013 - 2.6.35.11 - hang
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

I have downloaded xfstests-fa83948599dd10078a62acab8b0c1f93c82ad807.tar.gz
Build and run xfstests on MIPS target. This is my first try with
xfstests but report is not good.

./check -xfs quick
001, 004 have differences
013 have hang


VDLinux#> ./check -xfs -g quick
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/mips localhost 2.6.35.11
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
MOUNT_OPTIONS --     /dev/sda4 /dtv/usb/sda4

XFS mounting filesystem sda4
XFS mounting filesystem sda3
001      [failed, exit status 1] - output mismatch (see 001.out.bad)
--- 001.out     Thu Jan  1 00:07:48 1970
+++ 001.out.bad Thu Jan  1 00:59:07 1970
@@ -1,9 +1,77 @@
 QA output created by 001
 cleanup
 setup ....................................
-iter 1 chain ... check ....................................
-iter 2 chain ... check ....................................
-iter 3 chain ... check ....................................
-iter 4 chain ... check ....................................
-iter 5 chain ... check ....................................
-cleanup
+iter 1 chain ... check
+Error: corruption for small ...
+
+Error: corruption for big ...
+
+Error: corruption for sub/small ...
+
+Error: corruption for sub/big ...
+
+Error: corruption for sub/a ...
+
+Error: corruption for sub/b ...
+
+Error: corruption for sub/c ...
+
+Error: corruption for sub/d ...
+
+Error: corruption for sub/e ...
+
+Error: corruption for sub/f ...
+
+Error: corruption for sub/g ...
+
+Error: corruption for sub/h ...
+
+Error: corruption for sub/i ...
+
+Error: corruption for sub/j ...
+
+Error: corruption for sub/k ...
+
+Error: corruption for sub/l ...
+
+Error: corruption for sub/m ...
+
+Error: corruption for sub/n ...
+
+Error: corruption for sub/a00 ...
+
+Error: corruption for sub/b00 ...
+
+Error: corruption for sub/c00 ...
+
+Error: corruption for sub/d00 ...
+
+Error: corruption for sub/e00 ...
+
+Error: corruption for sub/f00 ...
+
+Error: corruption for sub/g00 ...
+
+Error: corruption for sub/h00 ...
+
+Error: corruption for sub/i00 ...
+
+Error: corruption for sub/j00 ...
+
+Error: corruption for sub/k00 ...
+
+Error: corruption for sub/l00 ...
+
+Error: corruption for sub/m00 ...
+
+Error: corruption for sub/n00 ...
+
+Error: corruption for sub/a000 ...
+
+Error: corruption for sub/e000 ...
+
+Error: corruption for sub/h000 ...
+
+Error: corruption for sub/k000 ...
+
+Fatal error: test abandoned without changes
XFS mounting filesystem sda3
002 1s ... 2s
XFS mounting filesystem sda3
003 1s ... 1s
XFS mounting filesystem sda3
004     XFS mounting filesystem sda4
XFS mounting filesystem sda4
 [failed, exit status 1] - output mismatch (see 004.out.bad)
--- 004.out     Thu Jan  1 00:07:48 1970
+++ 004.out.bad Thu Jan  1 00:59:40 1970
@@ -5,5 +5,13 @@
 naming   =VERN bsize=XXX
 log      =LDEV bsize=XXX blocks=XXX
 realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Checking blocks column same as df: yes
+Checking blocks column same as df: no (2806374400 != 33636352)
+Error: /dev/sda4: freesp mismatch: no (2806374400 != 33636352)
+xfs_db output ...
+   from      to extents  blocks    pct
+      1       1      16      16   0.00
+ 131072  172283       4  685134 100.00
+total free extents 20
+total free blocks 685150
+average free extent size 34257.5
 Checking percent column yields 100: 100
XFS mounting filesystem sda3
005 1s ... 1s
XFS mounting filesystem sda3
006 39s ... 38s
XFS mounting filesystem sda3
007      31s
XFS mounting filesystem sda3
008 8s ... 5s
XFS mounting filesystem sda3
009 13s ...XFS mounting filesystem sda4
 13s
XFS mounting filesystem sda3
011      93s
XFS mounting filesystem sda3
012 78s ... 65s
XFS mounting filesystem sda3
013     XFS mounting filesystem sda3
XFS mounting filesystem sda3
INFO: task fsstress:15299 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fsstress      D 8000606c     0 15299  15296 0x00100000
Stack : 83a5a700 83a5a6d0 8103e8c0 83995e38 8000606c 0003c49a 7fffffff 7fffffff
        00000002 00000000 00000000 00420000 00420000 0041d1c0 00420000 8000606c
        83995e28 8006f20c 8004030c 00000003 83995e34 83a5a6d0 8103e8c0 80065528
        0002480d 0003c499 00000000 00000000 7fffffff 83995e80 00000002 80005e90
        00000000 810884e0 81077580 8103e8c0 00000001 83a5a6d0 80024144 83995e84
        ...
Call Trace:
[<80005948>] schedule+0x3ec/0x4b0
[<8000606c>] schedule_timeout+0x2c/0x210
[<80005e90>] wait_for_common+0xf4/0x1bc
[<800b77dc>] sync_inodes_sb+0x90/0x1a4
[<800bc190>] __sync_filesystem+0x60/0xbc
[<80097394>] iterate_supers+0xa0/0x124
[<800bc25c>] sys_sync+0x44/0x74
[<80002164>] stack_done+0x20/0x3c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
