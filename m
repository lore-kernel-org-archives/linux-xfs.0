Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 09:23:18 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2EGNB6p016859
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 09:23:11 -0700
Received: from svlexc03.hq.netapp.com (svlexc03.corp.netapp.com [10.57.156.149])
	by smtp1.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id l2EGCk7l007746
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 09:12:46 -0700 (PDT)
Date: Wed, 14 Mar 2007 12:11:56 -0400
From: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Subject: Strange XFS issue on tiny-NAS ARM NFS server
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: "Talpey, Thomas" <Thomas.Talpey@netapp.com>

This might be pilot error, but a *very* strange thing happens with
an XFS filesystem on an NFS server I'm experimenting with. This is
an NSLU2 ARM-based machine, running 2.6.20.1 and an XFS filesystem
freshly built on a usb-attached 2.5" drive.

Running Connectathon 04 basic tests against the server, things are
fine with an EXT-formatted filesystem. However, reformatting the
export as a default XFS filesystem (mkfs.xfs -f /dev/sda3), the
following occurs:

>[tmt@tmt2 cthon04]$ ./server -b -p /mnt/export -m /mnt 192.168.1.77
>Start tests on path /mnt/tmt2.test [y/n]? y
>
>sh ./runtests  -b -t /mnt/tmt2.test
>
>Starting BASIC tests: test directory /mnt/tmt2.test (arg: -t)
>
>./test1: File and directory creation test
>        created 155 files 62 directories 5 levels deep in 0.78 seconds
>        ./test1 ok.
>
>./test2: File and directory removal test
>        removed 155 files 62 directories 5 levels deep in 0.60 seconds
>        ./test2 ok.
>
>./test3: lookups across mount point
>        500 getcwd and stat calls in 0.0  seconds
>        ./test3 ok.
>
>./test4: setattr, getattr, and lookup
>        1000 chmods and stats on 10 files in 0.80 seconds
>        ./test4 ok.
>
>./test5: read and write
>rm: cannot remove `/mnt/tmt2.test/file.7': No such file or directory
>rm: cannot remove `/mnt/tmt2.test/file.8': No such file or directory
>rm: cannot remove `/mnt/tmt2.test/file.9': No such file or directory
>        ./test5: (/home/tmt/nfs/cthon04/basic) can't remove old test directory /mnt/tmt2.test
>basic tests failed
>Tests failed, leaving /mnt mounted
>[tmt@tmt2 cthon04]$ ls -lsa /mnt/tmt2.test
>total 0
>0 drwxrwxrwx 2 tmt  tmt  17 Mar 14 11:23 
>0 drwxrwxrwx 2 tmt  tmt  17 Mar 14 11:23 
>0 drwxrwxrwx 2 tmt  tmt  17 Mar 14 11:23 .
>0 drwxrwxrwx 3 root root 32 Mar 14 11:23 ..
>[tmt@tmt2 cthon04]$ 


Those first two entries are entirely null - piping the output
to "od" shows no filename at all. The same result is seen if
listed from a login shell on the server.

The problem stems from connectathon test4, which is attemting
to create 10 files and chmod them repeatedly. If the test is
run with a file count less than 8, it works fine. If >= 8,
then upon removing the 6th file (file.5), the remaining files
vanish, and the blank entry appears. There are no complaints
in dmesg (see below fyi). The behavior is the same across all
client mount options and server export options, only going
away by reformatting the export to ext.

Before giving the problem report a full work-up, I'm wondering
if I'm missing the obvious, or if it's a known issue. A look
around with google (etc) didn't turn up anything. Thanks for
any info.

(please include me in the reply, I'm not on the list).

Tom.

(dmesg)
>...
><6>SGI XFS with no debug enabled
><5>XFS mounting filesystem sda3
><7>Ending clean XFS mount for filesystem: sda3
><6>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
><4>NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
><4>NFSD: starting 90-second grace period
>root@LKG881990:/$ 
>root@LKG881990:/$ cat /proc/fs/xfs/stat
>extent_alloc 19 73 18 69
>abt 119 87 43 41
>blk_map 8 1 1 1 1 11 0
>bmbt 0 0 0 0
>dir 233 232 230 10
>trans 0 1726 0
>ig 2659 2426 0 233 0 227 1002
>log 67 2010 0 11 1
>push_ail 1729 0 0 0 0 0 0 0 0 0
>xstrat 0 0
>rw 0 0
>attr 0 0 0 0
>icluster 5 2 19
>vnodes 6 233 0 1382 227 227 227 0
>buf 1940 239 1709 0 0 0 0 231 64
>xpc 0 0 0
>debug 0
>root@LKG881990:/$ mkfs.xfs -v
>mkfs.xfs version 2.8.16
>root@LKG881990:/$ 
