Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5F8u4X6174166 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 03:56:05 -0500
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0DAC4E131B
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 01:56:03 -0700 (PDT)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	gwgMzgDdHvbrT3AH for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2011 01:56:03 -0700 (PDT)
Received: by vxb39 with SMTP id 39so142994vxb.26
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 01:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110614140348.GD32466@dastard>
References: <BANLkTinCvmt+=ZO9HwUWda1vkmLEqOfSwg@mail.gmail.com>
	<20110613141324.GC32466@dastard>
	<BANLkTi=3NPR=EG8bqjr+xzPtNRkpYnyqmA@mail.gmail.com>
	<20110614140348.GD32466@dastard>
Date: Wed, 15 Jun 2011 14:26:02 +0530
Message-ID: <BANLkTi=-H=3igMbswKMdA0fXJoRerdc8jg@mail.gmail.com>
Subject: Re: xfstest run result on 2.6.35.13 X86, 51 test cases failed
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I understand the slowness is because we are using Sandisk 8GB USB flash.
Kernel : Vanilla 2.6.38.5
PC: Desktop HQ Pentinum Core 2 Duo

#./check -xfs -g quick

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 mannuDesk 2.6.38.5
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda6
MOUNT_OPTIONS -- /dev/sda6 /home/manish/Projects/xfstests/sdb4

001 5s ... 5s
002 0s ... 0s
003 0s ... 0s
004 1s ... 1s
005 1s ... 1s
006 36s ... 36s
007 58s ... 58s
008 2s ... 1s
009 1s ... 1s
011 45s ... 41s
012 1s ... 2s
013 143s ... 145s
014 49s ... 50s
015 1s ... - output mismatch (see 015.out.bad)
--- 015.out	2011-05-11 22:32:24.000000000 +0530
+++ 015.out.bad	2011-06-13 17:19:09.132699162 +0530
@@ -4,4 +4,5 @@
 check free space:
 delete fill:
 check free space:
-   !!! free space is in range
+   !!! free space has value of 20
+free space is NOT in range 43306.56 .. 44181.44
016 64s ... 75s
017 28s ... 29s
019 1s ... 1s
020 4s ... 3s
021 1s ... 1s
026 12s ... 12s
027 13s ... 12s
028 23s ... 23s
029 1s ... 1s
030 15s ... 15s
031 9s ... 10s
032 67s ... 68s
033 10s ... 10s
034 2s ... 2s
045 1s ... 1s
046 12s ... 13s
048 0s ... 0s
050	 [failed, exit status 1] - output mismatch (see 050.out.bad)
--- 050.out	2011-05-11 22:32:24.000000000 +0530
+++ 050.out.bad	2011-06-13 17:24:01.444044767 +0530
@@ -12,23 +12,24 @@

 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
+[NAME] =OK= 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]
+ URK 99: 0 is out of range! [425,500]

 *** unmount
 *** group
@@ -76,23 +77,23 @@

 *** report initial settings
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the soft inode limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the soft block limit
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the hard inode limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the hard block limit (expect EDQUOT)
 [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
+[NAME] 0 100 500 00 [--------] 0 4 10 00 [--------] 0 0 0 00 [--------]

 *** unmount
 *** gqnoenforce
@@ -115,79 +116,7 @@
 [NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]

 *** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
-
-*** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
-
-*** unmount
-*** pquota
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-
-*** report no quota settings
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-
-*** report initial settings
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** unmount
-*** pqnoenforce
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-
-*** report no quota settings
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-
-*** report initial settings
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the soft inode limit
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the soft block limit
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]
-
-*** push past the hard inode limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]
-
-*** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]
-
-*** unmount
+mount: /dev/sda6 already mounted or /home/manish/Projects/xfstests/sdb4 busy
+mount: according to mtab, /dev/sda6 is already mounted on
/home/manish/Projects/xfstests/sdb4
+qmount failed
+(see 050.full for details)
051 1s ... 1s
052	 - output mismatch (see 052.out.bad)
--- 052.out	2011-05-11 22:32:24.000000000 +0530
+++ 052.out.bad	2011-06-13 17:24:04.819002574 +0530
@@ -5,5 +5,9 @@
 naming   =VERN bsize=XXX
 log      =LDEV bsize=XXX blocks=XXX
 realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+warning: quota output file is empty
 Comparing out of xfs_quota and xfs_db
-OK.
+0a1,3
+> hard_blocks=1004
+> soft_blocks=1004
+> used_blocks=0
053	 1s
054	 3s
056	 12s
061	 11s
062 8s ... 1s
063	 12s
066	 1s
067	 1s
069 17s ... 9s
070 18s ... 21s
072 4s ... 1s
075 75s ... 69s
076 456s ... 82s
078 1193s ... 78s
_check_xfs_filesystem: filesystem on /dev/sda5 has dirty log (see 078.full)
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (c)
(see 078.full)
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (r)
(see 078.full)
Ran: 001 002 003 004 005 006 007 008 009 011 012 013 014 015 016 017
019 020 021 026 027 028 029 030 031 032 033 034 045 046 048 050 051
052 053 054 056 061 062 063 066 067 069 070 072 075 076 078
Failures: 015 050 052
Failed 3 of 48 tests

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
