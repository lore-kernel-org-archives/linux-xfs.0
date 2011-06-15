Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5F9OqVN178994 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 04:24:52 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DF8016695DD
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 02:24:41 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	sW6YXghSZlxPbmGv for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2011 02:24:41 -0700 (PDT)
Received: by iyb26 with SMTP id 26so134191iyb.26
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 02:24:41 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Jun 2011 14:54:40 +0530
Message-ID: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>
Subject: auto group failing on kernel v2.6.38.5
From: Manish Aggarwal <mani.iitb@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7222046101830224363=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7222046101830224363==
Content-Type: multipart/alternative; boundary=20cf30564473dcf77904a5bcb811

--20cf30564473dcf77904a5bcb811
Content-Type: text/plain; charset=ISO-8859-1

Hi I am running xfstest suite using command

./check -xfs -g auto

PC x86 machine with Kernel version 2.6.38.5
XFS Tests Suite dated 2011-05-11 (
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=summary)


Many of the test cases are failing , please let me know thatt am I missing
something?

Regards,
Manish


FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 mannuDesk 2.6.38.5
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda6
MOUNT_OPTIONS -- /dev/sda6 /home/manish/Projects/xfstests/sdb4

001 4s ... 5s
002 0s ... 0s
003 0s ... 0s
004 1s ... 1s
005 0s ... 0s
006 35s ... 36s
007 58s ... 58s
008 1s ... 1s
009 1s ... 1s
010     [not run] dbtest was not built for this platform
011 43s ... 45s
012 1s ... 2s
013 145s ... 158s
014 53s ... 51s
015 1s ... - output mismatch (see 015.out.bad)
--- 015.out    2011-05-11 22:32:24.000000000 +0530
+++ 015.out.bad    2011-06-15 14:34:36.561351828 +0530
@@ -4,4 +4,8 @@
 check free space:
 delete fill:
 check free space:
-   !!! free space is in range
+   !!! free space has value of 20
+free space is NOT in range 43306.56 .. 44181.44
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
016 74s ... 79s
017 28s ... 30s
019 1s ... 1s
020 4s ... 3s
021 1s ... 1s
026 12s ... 13s
027 12s ... 12s
028 23s ... 23s
029 1s ... 1s
030 16s ... 18s
031 9s ... 9s
032 72s ... 70s
033 10s ... 11s
034 1s ... 1s
035     [not run] No dump tape specified
040     [not run] Can't run srcdiff without KWORKAREA set
041 23s ... 19s
042 115s ... [failed, exit status 1] - output mismatch (see 042.out.bad)
--- 042.out    2011-05-11 22:32:24.000000000 +0530
+++ 042.out.bad    2011-06-15 14:42:05.946733738 +0530
@@ -9,5 +9,8 @@
 Run xfs_fsr on filesystem... done
 Check fill file... done
 Check large file... done
-Checking filesystem... done
-xfs_fsr tests passed.
+Checking filesystem... fail
+_check_scratch_fs failed (returned 1): see 042.full
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
044     [not run] This test requires a valid $SCRATCH_LOGDEV
045 1s ... 1s
046 13s ... 13s
047     24s
048 0s ... 0s
049 86s ... [failed, exit status 1] - output mismatch (see 049.out.bad)
--- 049.out    2011-05-11 22:32:24.000000000 +0530
+++ 049.out.bad    2011-06-15 14:42:52.004157941 +0530
@@ -13,3 +13,5 @@
 --- clean
 --- umount ext2 on xfs
 --- umount xfs
+!!! umount xfs failed
+(see 049.full for details)
050     [failed, exit status 1] - output mismatch (see 050.out.bad)
--- 050.out    2011-05-11 22:32:24.000000000 +0530
+++ 050.out.bad    2011-06-15 14:42:52.866147163 +0530
@@ -1,193 +1,5 @@
 QA output created by 050
-*** user
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
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** unmount
-*** group
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
-[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** push past the hard block limit (expect EDQUOT)
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
-[NAME] =OK= 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
-
-*** unmount
-*** uqnoenforce
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
-*** gqnoenforce
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
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
051 1s ... 0s
052     [failed, exit status 1] - output mismatch (see 052.out.bad)
--- 052.out    2011-05-11 22:32:24.000000000 +0530
+++ 052.out.bad    2011-06-15 14:42:54.705124173 +0530
@@ -1,9 +1,5 @@
 QA output created by 052
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Comparing out of xfs_quota and xfs_db
-OK.
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
053 1s ... [failed, exit status 1] - output mismatch (see 053.out.bad)
--- 053.out    2011-05-11 22:32:24.000000000 +0530
+++ 053.out.bad    2011-06-15 14:42:55.443114947 +0530
@@ -1,24 +1,5 @@
 QA output created by 053
-make filesystem on $SCRATCH_DEV... done
-mount filesytem... done
-acls before repair:
-$SCRATCH_MNT/test.0 [u::r--,g::rwx,o::rw-]
-$SCRATCH_MNT/test.1 [u::r-x,g::---,o::---]
-$SCRATCH_MNT/test.2 [u::---,g::r-x,o::---]
-$SCRATCH_MNT/test.3 [u::---,g::---,o::r-x]
-$SCRATCH_MNT/test.4 [u::---,g::r-x,o::rwx]
-$SCRATCH_MNT/test.5 [u::---,u:id2:r-x,g::---,m::rwx,o::---]
-$SCRATCH_MNT/test.6 [u::rwx,g::r-x,o::r--]
-$SCRATCH_MNT/test.7 [u::---,g::---,g:id2:r-x,m::-w-,o::---]
-unmount $SCRATCH_DEV... done
-repair filesystem... done
-mount filesytem... done
-acls after repair:
-$SCRATCH_MNT/test.0 [u::r--,g::rwx,o::rw-]
-$SCRATCH_MNT/test.1 [u::r-x,g::---,o::---]
-$SCRATCH_MNT/test.2 [u::---,g::r-x,o::---]
-$SCRATCH_MNT/test.3 [u::---,g::---,o::r-x]
-$SCRATCH_MNT/test.4 [u::---,g::r-x,o::rwx]
-$SCRATCH_MNT/test.5 [u::---,u:id2:r-x,g::---,m::rwx,o::---]
-$SCRATCH_MNT/test.6 [u::rwx,g::r-x,o::r--]
-$SCRATCH_MNT/test.7 [u::---,g::---,g:id2:r-x,m::-w-,o::---]
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
054 3s ... [failed, exit status 1] - output mismatch (see 054.out.bad)
--- 054.out    2011-05-11 22:32:24.000000000 +0530
+++ 054.out.bad    2011-06-15 14:42:56.126106409 +0530
@@ -1,73 +1,5 @@
 QA output created by 054
-*** Default mount options
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (56789) Gid: (98765)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
-
-*** User quota mount option
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (56789) Gid: (98765)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
-
-*** Group quota mount option
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (56789) Gid: (98765)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
-
-*** User and Group quota mount options
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (56789) Gid: (98765)
-Device: <DEVICE> Inode: <INODE> Links: 1
- File: "<MOUNT>/testfile"
- Size: 0 Filetype: Regular File
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)
-Device: <DEVICE> Inode: <INODE> Links: 1
-
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
056 12s ... [failed, exit status 1] - output mismatch (see 056.out.bad)
--- 056.out    2011-05-11 22:32:24.000000000 +0530
+++ 056.out.bad    2011-06-15 14:43:06.828972606 +0530
@@ -1,37 +1,8 @@
 QA output created by 056
-Creating directory system to dump using src/fill.
-Setup ..........
-Dumping to file...
-xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_056 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_056"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: /var/xfsdump/inventory created
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Restoring from file...
-xfsrestore  -f DUMP_FILE  -L stress_056 RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: examining media file 0
-xfsrestore: reading directories
-xfsrestore: 7 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-Comparing listing of dump directory with restore directory
-Files TMP.dump_dir and TMP.restore_dir are identical
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
+_check_xfs_filesystem: filesystem on /dev/sda6 has dirty log (see 056.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see
056.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r) (see
056.full)
057     [not run] Place holder for IRIX test 057
058     [not run] Place holder for IRIX test 058
061 11s ... [failed, exit status 1] - output mismatch (see 061.out.bad)
--- 061.out    2011-05-11 22:32:24.000000000 +0530
+++ 061.out.bad    2011-06-15 14:43:17.950833562 +0530
@@ -1,34 +1,8 @@
 QA output created by 061
-Creating directory system to dump using src/fill.
-Setup ..........
-Restoring from file...
-xfsrestore  -f DUMP_FILE  -L stress_056 RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: found dump matching specified label:
-xfsrestore: hostname: crackle.melbourne.sgi.com
-xfsrestore: mount point: /spare1
-xfsrestore: volume: /dev/dsk/dks0d2s1
-xfsrestore: session time: TIME
-xfsrestore: level: 0
-xfsrestore: session label: "stress_056"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 7 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-Comparing dump directory with restore directory
-Files DUMP_DIR/file_guid and RESTORE_DIR/DUMP_SUBDIR/file_guid are
identical
-Files DUMP_DIR/file_mix1 and RESTORE_DIR/DUMP_SUBDIR/file_mix1 are
identical
-Files DUMP_DIR/file_mix2 and RESTORE_DIR/DUMP_SUBDIR/file_mix2 are
identical
-Files DUMP_DIR/file_sticky and RESTORE_DIR/DUMP_SUBDIR/file_sticky are
identical
-Files DUMP_DIR/file_suid and RESTORE_DIR/DUMP_SUBDIR/file_suid are
identical
-Comparing listing of dump directory with restore directory
-Files TMP.dump_dir and TMP.restore_dir are identical
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
+_check_xfs_filesystem: filesystem on /dev/sda6 has dirty log (see 061.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see
061.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r) (see
061.full)
062 1s ... [failed, exit status 1] - output mismatch (see 062.out.bad)
--- 062.out    2011-05-11 22:32:24.000000000 +0530
+++ 062.out.bad    2011-06-15 14:43:18.673824524 +0530
@@ -1,660 +1,7 @@
 QA output created by 062
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-*** create test bed
-SCRATCH_MNT
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
-
-=== TYPE reg; NAMESPACE user
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/reg
-user.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/reg
-user.name=0xbabe
-user.name2=0xdeadbeef
-user.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/reg
-user.name=0sur4=
-user.name2=0s3q2+7w==
-user.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/reg
-user.name=0xbabe
-user.name2=0xdeaf
-user.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/reg
-user.name=0xbabe
-user.name2=0xdecade
-user.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/reg
-user.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/reg
-user.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/reg: user.name2: No such attribute
-*** final list (strings, type=reg, nsp=user)
-# file: SCRATCH_MNT/reg
-user.name=0xbabe
-user.name3=0xdeface
-
-
-=== TYPE dir; NAMESPACE user
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/dir
-user.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dir
-user.name=0xbabe
-user.name2=0xdeadbeef
-user.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dir
-user.name=0sur4=
-user.name2=0s3q2+7w==
-user.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/dir
-user.name=0xbabe
-user.name2=0xdeaf
-user.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/dir
-user.name=0xbabe
-user.name2=0xdecade
-user.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/dir
-user.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/dir
-user.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/dir: user.name2: No such attribute
-*** final list (strings, type=dir, nsp=user)
-# file: SCRATCH_MNT/dir
-user.name=0xbabe
-user.name3=0xdeface
-
-
-=== TYPE lnk; NAMESPACE user
-
-*** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-*** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-*** fetch several attribute names and values (hex)
-*** fetch several attribute names and values (base64)
-*** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-*** grow value of existing attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-*** set an empty value for second attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
-*** overwrite empty value
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
-*** remove attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: Operation not permitted
-*** final list (strings, type=lnk, nsp=user)
-
-=== TYPE dev/b; NAMESPACE user
-
-*** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-*** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-*** fetch several attribute names and values (hex)
-*** fetch several attribute names and values (base64)
-*** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-*** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-*** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
-*** overwrite empty value
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
-*** remove attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: Operation not permitted
-*** final list (strings, type=dev/b, nsp=user)
-
-=== TYPE dev/c; NAMESPACE user
-
-*** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-*** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-*** fetch several attribute names and values (hex)
-*** fetch several attribute names and values (base64)
-*** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-*** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-*** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
-*** overwrite empty value
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
-*** remove attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted
-*** final list (strings, type=dev/c, nsp=user)
-
-=== TYPE dev/p; NAMESPACE user
-
-*** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-*** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-*** fetch several attribute names and values (hex)
-*** fetch several attribute names and values (base64)
-*** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-*** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-*** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
-*** overwrite empty value
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
-*** remove attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted
-*** final list (strings, type=dev/p, nsp=user)
-
-=== TYPE reg; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/reg
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/reg
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/reg
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/reg
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/reg: trusted.name2: No such attribute
-*** final list (strings, type=reg, nsp=trusted)
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-
-=== TYPE dir; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/dir
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dir
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/dir
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/dir
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/dir: trusted.name2: No such attribute
-*** final list (strings, type=dir, nsp=trusted)
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-
-=== TYPE lnk; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/lnk
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/lnk
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/lnk
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/lnk
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/lnk: trusted.name2: No such attribute
-*** final list (strings, type=lnk, nsp=trusted)
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-
-=== TYPE dev/b; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/b
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/b
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/b
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/dev/b
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/dev/b: trusted.name2: No such attribute
-*** final list (strings, type=dev/b, nsp=trusted)
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-
-=== TYPE dev/c; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/c
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/c
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/c
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/dev/c
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/dev/c: trusted.name2: No such attribute
-*** final list (strings, type=dev/c, nsp=trusted)
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-
-=== TYPE dev/p; NAMESPACE trusted
-
-*** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/p
-trusted.name
-
-*** overwrite empty, set several new attributes
-*** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name2=0xdeadbeef
-trusted.name3=0xdeface
-
-*** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/p
-trusted.name=0sur4=
-trusted.name2=0s3q2+7w==
-trusted.name3=0s3vrO
-
-*** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name2=0xdeaf
-trusted.name3=0xdeface
-
-*** grow value of existing attribute
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name2=0xdecade
-trusted.name3=0xdeface
-
-*** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/p
-trusted.name2
-
-*** overwrite empty value
-# file: SCRATCH_MNT/dev/p
-trusted.name2=0xcafe
-
-*** remove attribute
-SCRATCH_MNT/dev/p: trusted.name2: No such attribute
-*** final list (strings, type=dev/p, nsp=trusted)
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-
-
-*** extend test bed
-SCRATCH_MNT
-SCRATCH_MNT/descend
-SCRATCH_MNT/descend/and
-SCRATCH_MNT/descend/down
-SCRATCH_MNT/descend/down/here
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/here
-SCRATCH_MNT/here/up
-SCRATCH_MNT/here/up/ascend
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
-
-*** directory descent with us following symlinks
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/here
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/here/up
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/here/up/ascend
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/descend
-user.1=0x3233
-user.x=0x797a
-
-# file: SCRATCH_MNT/descend/down
-user.1=0x3233
-user.x=0x797a
-
-# file: SCRATCH_MNT/descend/down/here
-user.1=0x3233
-user.x=0x797a
-
-# file: SCRATCH_MNT/descend/and/ascend
-trusted.9=0x3837
-trusted.a=0x6263
-
-
-*** directory descent without following symlinks
-# file: SCRATCH_MNT/reg
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-# file: SCRATCH_MNT/dir
-trusted.name=0xbabe
-trusted.name3=0xdeface
-user.name=0xbabe
-user.name3=0xdeface
-
-# file: SCRATCH_MNT/lnk
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/b
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/c
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/dev/p
-trusted.name=0xbabe
-trusted.name3=0xdeface
-
-# file: SCRATCH_MNT/here
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/here/up
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/here/up/ascend
-trusted.9=0x3837
-trusted.a=0x6263
-
-# file: SCRATCH_MNT/descend
-user.1=0x3233
-user.x=0x797a
-
-# file: SCRATCH_MNT/descend/down
-user.1=0x3233
-user.x=0x797a
-
-# file: SCRATCH_MNT/descend/down/here
-user.1=0x3233
-user.x=0x797a
-
-
-
-*** backup everything
-*** clear out the scratch device
-*** reset test bed with no extended attributes
-*** create test bed
-SCRATCH_MNT
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
-*** extend test bed
-SCRATCH_MNT
-SCRATCH_MNT/descend
-SCRATCH_MNT/descend/and
-SCRATCH_MNT/descend/down
-SCRATCH_MNT/descend/down/here
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/here
-SCRATCH_MNT/here/up
-SCRATCH_MNT/here/up/ascend
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
-*** restore everything
-*** compare before and after backups
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6

 *** unmount
063 12s ... [failed, exit status 1] - output mismatch (see 063.out.bad)
--- 063.out    2011-05-11 22:32:24.000000000 +0530
+++ 063.out.bad    2011-06-15 14:43:29.427690082 +0530
@@ -1,74 +1,8 @@
 QA output created by 063
-Creating directory system to dump using src/fill.
-Setup Attribute "attr1" set to a 9 byte value for smalll:
-some_text
-.Attribute "attr2" set to a 10 byte value for biggg:
-some_text2
-.Attribute "attr3" set to a 10 byte value for sub/smalll:
-some_text3
-.Attribute "attr4" set to a 10 byte value for sub/biggg:
-some_text4
-.Attribute "attr5" set to a 8 byte value for dir:
-dir_text
-...............
-Dumping to file...
-xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_063 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_063"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: /var/xfsdump/inventory created
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Restoring from file...
-xfsrestore  -f DUMP_FILE  -L stress_063 RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: examining media file 0
-xfsrestore: reading directories
-xfsrestore: 4 directories and 21 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-Comparing dump directory with restore directory
-Looking at the extended attributes (EAs)
-EAs on dump
-User names
-Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
-dir_text
-Attribute "attr1" had a 9 byte value for DUMP_DIR/smalll:
-some_text
-Attribute "attr3" had a 10 byte value for DUMP_DIR/sub/smalll:
-some_text3
-Root names
-Attribute "attr2" had a 10 byte value for DUMP_DIR/biggg:
-some_text2
-Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
-some_text4
-EAs on restore
-User names
-Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
-dir_text
-Attribute "attr1" had a 9 byte value for DUMP_DIR/smalll:
-some_text
-Attribute "attr3" had a 10 byte value for DUMP_DIR/sub/smalll:
-some_text3
-Root names
-Attribute "attr2" had a 10 byte value for DUMP_DIR/biggg:
-some_text2
-Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
-some_text4
-Files 063.ea1 and 063.ea2 are identical
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
+_check_xfs_filesystem: filesystem on /dev/sda6 has dirty log (see 063.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see
063.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r) (see
063.full)
064     [failed, exit status 1] - output mismatch (see 064.out.bad)
--- 064.out    2011-05-11 22:32:24.000000000 +0530
+++ 064.out.bad    2011-06-15 14:43:40.183555616 +0530
@@ -1,1484 +1,8 @@
 QA output created by 064
-Creating directory system of hardlinks to incrementally dump.
-creating hardlink file1_h1 to file1
-creating hardlink file1_h2 to file1
-creating hardlink file1_h3 to file1
-creating hardlink file1_h4 to file1
-creating hardlink file1_h5 to file1
-creating hardlink file2_h1 to file2
-creating hardlink file2_h2 to file2
-creating hardlink file2_h3 to file2
-creating hardlink file2_h4 to file2
-creating hardlink file2_h5 to file2
-creating hardlink file3_h1 to file3
-creating hardlink file3_h2 to file3
-creating hardlink file3_h3 to file3
-creating hardlink file3_h4 to file3
-creating hardlink file3_h5 to file3
-creating hardlink file4_h1 to file4
-creating hardlink file4_h2 to file4
-creating hardlink file4_h3 to file4
-creating hardlink file4_h4 to file4
-creating hardlink file4_h5 to file4
-creating hardlink file5_h1 to file5
-creating hardlink file5_h2 to file5
-creating hardlink file5_h3 to file5
-creating hardlink file5_h4 to file5
-creating hardlink file5_h5 to file5
-creating hardlink file6_h1 to file6
-creating hardlink file6_h2 to file6
-creating hardlink file6_h3 to file6
-creating hardlink file6_h4 to file6
-creating hardlink file6_h5 to file6
-creating hardlink file7_h1 to file7
-creating hardlink file7_h2 to file7
-creating hardlink file7_h3 to file7
-creating hardlink file7_h4 to file7
-creating hardlink file7_h5 to file7
-creating hardlink file8_h1 to file8
-creating hardlink file8_h2 to file8
-creating hardlink file8_h3 to file8
-creating hardlink file8_h4 to file8
-creating hardlink file8_h5 to file8
-creating hardlink file9_h1 to file9
-creating hardlink file9_h2 to file9
-creating hardlink file9_h3 to file9
-creating hardlink file9_h4 to file9
-creating hardlink file9_h5 to file9
-Do the incremental dumps
-Dumping to file...
-xfsdump  -l0 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: /var/xfsdump/inventory created
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l1 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 1 incremental dump of HOSTNAME:SCRATCH_MNT based on level 0
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l2 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 2 incremental dump of HOSTNAME:SCRATCH_MNT based on level 1
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l3 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 3 incremental dump of HOSTNAME:SCRATCH_MNT based on level 2
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l4 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 4 incremental dump of HOSTNAME:SCRATCH_MNT based on level 3
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l5 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 5 incremental dump of HOSTNAME:SCRATCH_MNT based on level 4
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l6 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 6 incremental dump of HOSTNAME:SCRATCH_MNT based on level 5
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l7 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 7 incremental dump of HOSTNAME:SCRATCH_MNT based on level 6
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l8 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 8 incremental dump of HOSTNAME:SCRATCH_MNT based on level 7
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Dumping to file...
-xfsdump  -l9 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 9 incremental dump of HOSTNAME:SCRATCH_MNT based on level 8
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_064"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we start with:
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-12 file6
-12 file6_h1
-12 file6_h2
-12 file6_h3
-12 file6_h4
-12 file6_h5
-12 file7
-12 file7_h1
-12 file7_h2
-12 file7_h3
-12 file7_h4
-12 file7_h5
-12 file8
-12 file8_h1
-12 file8_h2
-12 file8_h3
-12 file8_h4
-12 file8_h5
-12 file9
-12 file9_h1
-12 file9_h2
-12 file9_h3
-12 file9_h4
-12 file9_h5
-Look at what files are contained in the inc. dump
-
-restoring from df.level0
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 0
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file1
-dumpdir/file1_h1
-dumpdir/file1_h2
-dumpdir/file1_h3
-dumpdir/file1_h4
-dumpdir/file1_h5
-dumpdir/file2
-dumpdir/file2_h1
-dumpdir/file2_h2
-dumpdir/file2_h3
-dumpdir/file2_h4
-dumpdir/file2_h5
-dumpdir/file3
-dumpdir/file3_h1
-dumpdir/file3_h2
-dumpdir/file3_h3
-dumpdir/file3_h4
-dumpdir/file3_h5
-dumpdir/file4
-dumpdir/file4_h1
-dumpdir/file4_h2
-dumpdir/file4_h3
-dumpdir/file4_h4
-dumpdir/file4_h5
-dumpdir/file5
-dumpdir/file5_h1
-dumpdir/file5_h2
-dumpdir/file5_h3
-dumpdir/file5_h4
-dumpdir/file5_h5
-dumpdir/file6
-dumpdir/file6_h1
-dumpdir/file6_h2
-dumpdir/file6_h3
-dumpdir/file6_h4
-dumpdir/file6_h5
-dumpdir/file7
-dumpdir/file7_h1
-dumpdir/file7_h2
-dumpdir/file7_h3
-dumpdir/file7_h4
-dumpdir/file7_h5
-dumpdir/file8
-dumpdir/file8_h1
-dumpdir/file8_h2
-dumpdir/file8_h3
-dumpdir/file8_h4
-dumpdir/file8_h5
-dumpdir/file9
-dumpdir/file9_h1
-dumpdir/file9_h2
-dumpdir/file9_h3
-dumpdir/file9_h4
-dumpdir/file9_h5
-
-restoring from df.level1
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 1
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file1
-dumpdir/file1_h1
-dumpdir/file1_h2
-dumpdir/file1_h3
-dumpdir/file1_h4
-dumpdir/file1_h5
-
-restoring from df.level2
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 2
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file2
-dumpdir/file2_h1
-dumpdir/file2_h2
-dumpdir/file2_h3
-dumpdir/file2_h4
-dumpdir/file2_h5
-
-restoring from df.level3
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 3
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file3
-dumpdir/file3_h1
-dumpdir/file3_h2
-dumpdir/file3_h3
-dumpdir/file3_h4
-dumpdir/file3_h5
-
-restoring from df.level4
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 4
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file4
-dumpdir/file4_h1
-dumpdir/file4_h2
-dumpdir/file4_h3
-dumpdir/file4_h4
-dumpdir/file4_h5
-
-restoring from df.level5
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 5
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file5
-dumpdir/file5_h1
-dumpdir/file5_h2
-dumpdir/file5_h3
-dumpdir/file5_h4
-dumpdir/file5_h5
-
-restoring from df.level6
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 6
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file6
-dumpdir/file6_h1
-dumpdir/file6_h2
-dumpdir/file6_h3
-dumpdir/file6_h4
-dumpdir/file6_h5
-
-restoring from df.level7
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 7
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file7
-dumpdir/file7_h1
-dumpdir/file7_h2
-dumpdir/file7_h3
-dumpdir/file7_h4
-dumpdir/file7_h5
-
-restoring from df.level8
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 8
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file8
-dumpdir/file8_h1
-dumpdir/file8_h2
-dumpdir/file8_h3
-dumpdir/file8_h4
-dumpdir/file8_h5
-
-restoring from df.level9
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 9
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/file9
-dumpdir/file9_h1
-dumpdir/file9_h2
-dumpdir/file9_h3
-dumpdir/file9_h4
-dumpdir/file9_h5
-Do the cumulative restores
-
-restoring from df.level0
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 0
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-0 file1
-0 file1_h1
-0 file1_h2
-0 file1_h3
-0 file1_h4
-0 file1_h5
-0 file2
-0 file2_h1
-0 file2_h2
-0 file2_h3
-0 file2_h4
-0 file2_h5
-0 file3
-0 file3_h1
-0 file3_h2
-0 file3_h3
-0 file3_h4
-0 file3_h5
-0 file4
-0 file4_h1
-0 file4_h2
-0 file4_h3
-0 file4_h4
-0 file4_h5
-0 file5
-0 file5_h1
-0 file5_h2
-0 file5_h3
-0 file5_h4
-0 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level1
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 1
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-0 file2
-0 file2_h1
-0 file2_h2
-0 file2_h3
-0 file2_h4
-0 file2_h5
-0 file3
-0 file3_h1
-0 file3_h2
-0 file3_h3
-0 file3_h4
-0 file3_h5
-0 file4
-0 file4_h1
-0 file4_h2
-0 file4_h3
-0 file4_h4
-0 file4_h5
-0 file5
-0 file5_h1
-0 file5_h2
-0 file5_h3
-0 file5_h4
-0 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level2
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 2
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-0 file3
-0 file3_h1
-0 file3_h2
-0 file3_h3
-0 file3_h4
-0 file3_h5
-0 file4
-0 file4_h1
-0 file4_h2
-0 file4_h3
-0 file4_h4
-0 file4_h5
-0 file5
-0 file5_h1
-0 file5_h2
-0 file5_h3
-0 file5_h4
-0 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level3
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 3
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-0 file4
-0 file4_h1
-0 file4_h2
-0 file4_h3
-0 file4_h4
-0 file4_h5
-0 file5
-0 file5_h1
-0 file5_h2
-0 file5_h3
-0 file5_h4
-0 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level4
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 4
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-0 file5
-0 file5_h1
-0 file5_h2
-0 file5_h3
-0 file5_h4
-0 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level5
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 5
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-0 file6
-0 file6_h1
-0 file6_h2
-0 file6_h3
-0 file6_h4
-0 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level6
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 6
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-12 file6
-12 file6_h1
-12 file6_h2
-12 file6_h3
-12 file6_h4
-12 file6_h5
-0 file7
-0 file7_h1
-0 file7_h2
-0 file7_h3
-0 file7_h4
-0 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level7
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 7
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-12 file6
-12 file6_h1
-12 file6_h2
-12 file6_h3
-12 file6_h4
-12 file6_h5
-12 file7
-12 file7_h1
-12 file7_h2
-12 file7_h3
-12 file7_h4
-12 file7_h5
-0 file8
-0 file8_h1
-0 file8_h2
-0 file8_h3
-0 file8_h4
-0 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level8
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 8
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-12 file6
-12 file6_h1
-12 file6_h2
-12 file6_h3
-12 file6_h4
-12 file6_h5
-12 file7
-12 file7_h1
-12 file7_h2
-12 file7_h3
-12 file7_h4
-12 file7_h5
-12 file8
-12 file8_h1
-12 file8_h2
-12 file8_h3
-12 file8_h4
-12 file8_h5
-0 file9
-0 file9_h1
-0 file9_h2
-0 file9_h3
-0 file9_h4
-0 file9_h5
-
-restoring from df.level9
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 9
-xfsrestore: session label: "stress_064"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 55 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls -l restore_dir
-12 file1
-12 file1_h1
-12 file1_h2
-12 file1_h3
-12 file1_h4
-12 file1_h5
-12 file2
-12 file2_h1
-12 file2_h2
-12 file2_h3
-12 file2_h4
-12 file2_h5
-12 file3
-12 file3_h1
-12 file3_h2
-12 file3_h3
-12 file3_h4
-12 file3_h5
-12 file4
-12 file4_h1
-12 file4_h2
-12 file4_h3
-12 file4_h4
-12 file4_h5
-12 file5
-12 file5_h1
-12 file5_h2
-12 file5_h3
-12 file5_h4
-12 file5_h5
-12 file6
-12 file6_h1
-12 file6_h2
-12 file6_h3
-12 file6_h4
-12 file6_h5
-12 file7
-12 file7_h1
-12 file7_h2
-12 file7_h3
-12 file7_h4
-12 file7_h5
-12 file8
-12 file8_h1
-12 file8_h2
-12 file8_h3
-12 file8_h4
-12 file8_h5
-12 file9
-12 file9_h1
-12 file9_h2
-12 file9_h3
-12 file9_h4
-12 file9_h5
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
+_check_xfs_filesystem: filesystem on /dev/sda6 has dirty log (see 064.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see
064.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r) (see
064.full)
065     [failed, exit status 1] - output mismatch (see 065.out.bad)
--- 065.out    2011-05-11 22:32:24.000000000 +0530
+++ 065.out.bad    2011-06-15 14:43:50.945421073 +0530
@@ -1,832 +1,13 @@
 QA output created by 065
-Do the incremental dumps
-Listing of what files we have at level 0:
-dumpdir/addeddir1 XXX drwxr-xr-x 0,0
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir3 XXX drwxr-xr-x 0,0
-dumpdir/addeddir3/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4/addedfile5 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile1 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l0 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: /var/xfsdump/inventory created
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 1:
-dumpdir/addeddir1 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4/addedfile5 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile1 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l1 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 1 incremental dump of HOSTNAME:SCRATCH_MNT based on level 0
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 2:
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l2 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 2 incremental dump of HOSTNAME:SCRATCH_MNT based on level 1
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 3:
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-dumpdir/linkfile0 5 -rw-r--r-- 0,0
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile2 5 -rw-r--r-- 0,0
-dumpdir/linkfile64 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l3 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 3 incremental dump of HOSTNAME:SCRATCH_MNT based on level 2
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 4:
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile2 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l4 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 4 incremental dump of HOSTNAME:SCRATCH_MNT based on level 3
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 5:
-dumpdir/addedfile6 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l5 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 5 incremental dump of HOSTNAME:SCRATCH_MNT based on level 4
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 6:
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l6 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 6 incremental dump of HOSTNAME:SCRATCH_MNT based on level 5
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 7:
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l7 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 7 incremental dump of HOSTNAME:SCRATCH_MNT based on level 6
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Listing of what files we have at level 8:
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-Dumping to file...
-xfsdump  -l8 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 8 incremental dump of HOSTNAME:SCRATCH_MNT based on level 7
dump begun DATE
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_065"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Look at what files are contained in the inc. dump
-
-restoring from df.level0
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 0
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 6 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addeddir3/addedfile4
-dumpdir/addeddir4/addedfile5
-dumpdir/addedfile0
-dumpdir/addedfile1
-dumpdir/addedfile2
-dumpdir/addedfile3
-
-restoring from df.level1
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 1
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 6 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-
-restoring from df.level2
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 2
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 4 directories and 7 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addeddir6/addedfile4
-dumpdir/addedfile2
-
-restoring from df.level3
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 3
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 3 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addeddir6/addedfile4
-dumpdir/addedfile0
-dumpdir/addedfile2
-dumpdir/linkfile0
-dumpdir/linkfile0_1
-dumpdir/linkfile2
-dumpdir/linkfile64
-
-restoring from df.level4
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 4
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 3 directories and 7 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addedfile0
-dumpdir/linkfile0_1
-dumpdir/linkfile2
-
-restoring from df.level5
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 5
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 5 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addedfile6
-dumpdir/linkfile6_1
-dumpdir/linkfile6_2
-dumpdir/linkfile6_3
-
-restoring from df.level6
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 6
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 5 entries processed
-xfsrestore: directory post-processing
-xfsrestore: reading non-directory files
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-dumpdir/addedfile6_mv
-dumpdir/linkfile6_mv_1
-dumpdir/linkfile6_mv_2
-dumpdir/linkfile6_mv_3
-
-restoring from df.level7
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 7
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 0 directories and 0 entries processed
-xfsrestore: directory post-processing
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-
-restoring from df.level8
-Contents of dump ...
-xfsrestore  -f DUMP_FILE -t
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 8
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 0 directories and 0 entries processed
-xfsrestore: directory post-processing
-xfsrestore: table of contents display complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-
-Do the cumulative restores
-
-restoring from df.level0
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 0
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 6 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addeddir1 XXX drwxr-xr-x 0,0
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir3 XXX drwxr-xr-x 0,0
-dumpdir/addeddir3/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4/addedfile5 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile1 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-
-restoring from df.level1
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 1
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 6 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addeddir1 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0
-dumpdir/addeddir4/addedfile5 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile1 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-
-restoring from df.level2
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 2
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 4 directories and 7 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-
-restoring from df.level3
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 3
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 3 directories and 11 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile2 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-dumpdir/linkfile0 5 -rw-r--r-- 0,0
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile2 5 -rw-r--r-- 0,0
-dumpdir/linkfile64 5 -rw-r--r-- 0,0
-
-restoring from df.level4
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 4
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 3 directories and 7 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0
-dumpdir/addedfile0 5 -rw-r--r-- 0,0
-dumpdir/addedfile3 5 -rw-r--r-- 0,0
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile2 5 -rw-r--r-- 0,0
-
-restoring from df.level5
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 5
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 5 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addedfile6 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_3 5 -rw-r--r-- 0,0
-
-restoring from df.level6
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 6
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 2 directories and 5 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-
-restoring from df.level7
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 7
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 0 directories and 0 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-
-restoring from df.level8
-Restoring cumumlative from file...
-xfsrestore  -f DUMP_FILE -r RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: searching media for dump
-xfsrestore: examining media file 0
-xfsrestore: dump description:
-xfsrestore: hostname: HOSTNAME
-xfsrestore: mount point: SCRATCH_MNT
-xfsrestore: volume: SCRATCH_DEV
-xfsrestore: session time: TIME
-xfsrestore: level: 8
-xfsrestore: session label: "stress_065"
-xfsrestore: media label: "stress_tape_media"
-xfsrestore: file system ID: ID
-xfsrestore: session id: ID
-xfsrestore: media ID: ID
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: reading directories
-xfsrestore: 0 directories and 0 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-list restore_dir
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0
-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0
-
-Do the ls comparison
-Comparing ls of FS with restored FS at level 0
-Files TMP.ls.0 and TMP.restorals.0 are identical
-
-Comparing ls of FS with restored FS at level 1
-Files TMP.ls.1 and TMP.restorals.1 are identical
-
-Comparing ls of FS with restored FS at level 2
-Files TMP.ls.2 and TMP.restorals.2 are identical
-
-Comparing ls of FS with restored FS at level 3
-Files TMP.ls.3 and TMP.restorals.3 are identical
-
-Comparing ls of FS with restored FS at level 4
-Files TMP.ls.4 and TMP.restorals.4 are identical
-
-Comparing ls of FS with restored FS at level 5
-Files TMP.ls.5 and TMP.restorals.5 are identical
-
-Comparing ls of FS with restored FS at level 6
-Files TMP.ls.6 and TMP.restorals.6 are identical
-
-Comparing ls of FS with restored FS at level 7
-Files TMP.ls.7 and TMP.restorals.7 are identical
-
-Comparing ls of FS with restored FS at level 8
-Files TMP.ls.8 and TMP.restorals.8 are identical
-
+mount: /dev/sda6 already mounted or /home/manish/Projects/xfstests/sdb4
busy
+mount: according to mtab, /dev/sda6 is already mounted on
/home/manish/Projects/xfstests/sdb4
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
+_check_xfs_filesystem: filesystem on /dev/sda6 has dirty log (see 065.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see
065.full)
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (r) (see
065.full)
066 1s ... [failed, exit status 1] - output mismatch (see 066.out.bad)
--- 066.out    2011-05-11 22:32:24.000000000 +0530
+++ 066.out.bad    2011-06-15 14:43:51.626412560 +0530
@@ -1,40 +1,5 @@
 QA output created by 066
-dd a largefile at offset 4294967297
-10+0 records in
-10+0 records out
-ls dumpdir/largefile
-22 largefile
-Dumping to file...
-xfsdump  -f DUMP_FILE -M stress_tape_media -L stress_066 SCRATCH_MNT
-xfsdump: using file dump (drive_simple) strategy
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
-xfsdump: dump date: DATE
-xfsdump: session id: ID
-xfsdump: session label: "stress_066"
-xfsdump: ino map <PHASES>
-xfsdump: ino map construction complete
-xfsdump: estimated dump size: NUM bytes
-xfsdump: /var/xfsdump/inventory created
-xfsdump: creating dump session media file 0 (media 0, file 0)
-xfsdump: dumping ino map
-xfsdump: dumping directories
-xfsdump: dumping non-directory files
-xfsdump: ending media file
-xfsdump: media file size NUM bytes
-xfsdump: dump size (non-dir files) : NUM bytes
-xfsdump: dump complete: SECS seconds elapsed
-xfsdump: Dump Status: SUCCESS
-Restoring from file...
-xfsrestore  -f DUMP_FILE  -L stress_066 RESTORE_DIR
-xfsrestore: using file dump (drive_simple) strategy
-xfsrestore: using online session inventory
-xfsrestore: searching media for directory dump
-xfsrestore: examining media file 0
-xfsrestore: reading directories
-xfsrestore: 2 directories and 2 entries processed
-xfsrestore: directory post-processing
-xfsrestore: restoring non-directory files
-xfsrestore: restore complete: SECS seconds elapsed
-xfsrestore: Restore Status: SUCCESS
-ls restoredir/largefile
-22 largefile
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
067 1s ... [failed, exit status 1] - output mismatch (see 067.out.bad)
--- 067.out    2011-05-11 22:32:24.000000000 +0530
+++ 067.out.bad    2011-06-15 14:43:52.403402846 +0530
@@ -1,166 +1,5 @@
 QA output created by 067
-
-=== Test out large ACLs  ===
-try 20 aces for access acl
-# file: largeacldir
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-group::rwx
-mask::rwx
-other::rwx
-
-try 20 aces for default acl
-# file: largeacldir
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-group::rwx
-mask::rwx
-other::rwx
-default:user::rwx
-default:user:1:rwx
-default:user:2:rwx
-default:user:3:rwx
-default:user:4:rwx
-default:user:5:rwx
-default:user:6:rwx
-default:user:7:rwx
-default:user:8:rwx
-default:user:9:rwx
-default:user:10:rwx
-default:user:11:rwx
-default:user:12:rwx
-default:user:13:rwx
-default:user:14:rwx
-default:user:15:rwx
-default:user:16:rwx
-default:group::rwx
-default:mask::rwx
-default:other::rwx
-
-try 21 aces for access acl
-# file: largeacldir
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-user:17:rwx
-group::rwx
-mask::rwx
-other::rwx
-default:user::rwx
-default:user:1:rwx
-default:user:2:rwx
-default:user:3:rwx
-default:user:4:rwx
-default:user:5:rwx
-default:user:6:rwx
-default:user:7:rwx
-default:user:8:rwx
-default:user:9:rwx
-default:user:10:rwx
-default:user:11:rwx
-default:user:12:rwx
-default:user:13:rwx
-default:user:14:rwx
-default:user:15:rwx
-default:user:16:rwx
-default:group::rwx
-default:mask::rwx
-default:other::rwx
-
-try 21 aces for default acl
-# file: largeacldir
-# owner: 0
-# group: 0
-user::rwx
-user:1:rwx
-user:2:rwx
-user:3:rwx
-user:4:rwx
-user:5:rwx
-user:6:rwx
-user:7:rwx
-user:8:rwx
-user:9:rwx
-user:10:rwx
-user:11:rwx
-user:12:rwx
-user:13:rwx
-user:14:rwx
-user:15:rwx
-user:16:rwx
-user:17:rwx
-group::rwx
-mask::rwx
-other::rwx
-default:user::rwx
-default:user:1:rwx
-default:user:2:rwx
-default:user:3:rwx
-default:user:4:rwx
-default:user:5:rwx
-default:user:6:rwx
-default:user:7:rwx
-default:user:8:rwx
-default:user:9:rwx
-default:user:10:rwx
-default:user:11:rwx
-default:user:12:rwx
-default:user:13:rwx
-default:user:14:rwx
-default:user:15:rwx
-default:user:16:rwx
-default:user:17:rwx
-default:group::rwx
-default:mask::rwx
-default:other::rwx
-
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
068 94s ... - output mismatch (see 068.out.bad)
--- 068.out    2011-05-11 22:32:24.000000000 +0530
+++ 068.out.bad    2011-06-15 14:43:53.141393620 +0530
@@ -1,43 +1,5 @@
 QA output created by 068
-*** init FS
-
-*** iteration: 0
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 1
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 2
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 3
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 4
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 5
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 6
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 7
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 8
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
-*** iteration: 9
-*** freezing $SCRATCH_MNT
-*** thawing  $SCRATCH_MNT
-
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
069 9s ... - output mismatch (see 069.out.bad)
--- 069.out    2011-05-11 22:32:24.000000000 +0530
+++ 069.out.bad    2011-06-15 14:43:53.905384068 +0530
@@ -1,9 +1,5 @@
 QA output created by 069
-*** mkfs
-*** mount FS
-*** checking file with 1 integers
-*** checking file with 20 integers
-*** checking file with 300 integers
-*** checking file with 40000 integers
-*** checking file with 3000000 integers
-*** checking file with 12345 integers
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
070 19s ... 22s
072 1s ... [failed, exit status 1] - output mismatch (see 072.out.bad)
--- 072.out    2011-05-11 22:32:24.000000000 +0530
+++ 072.out.bad    2011-06-15 14:44:17.914083917 +0530
@@ -1,2 +1,5 @@
 QA output created by 072
-Silence is golden
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
073 34s ... [failed, exit status 1] - output mismatch (see 073.out.bad)
--- 073.out    2011-05-11 22:32:24.000000000 +0530
+++ 073.out.bad    2011-06-15 14:44:19.447064754 +0530
@@ -1,73 +1,5 @@
 QA output created by 073
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-
-=== populating scratch device
-1000+0 records in
-1000+0 records out
-
-=== copying scratch device to single target
-Creating file <FSIMAGE1>
- 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ...
80%  ... 90%  ... 100%
-
-All copies completed.
-checking new image
-mounting new image on loopback
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
-
-=== copying scratch device to single target, duplicate UUID
-Creating file <FSIMAGE1>
- 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ...
80%  ... 90%  ... 100%
-
-All copies completed.
-checking new image
-mounting new image on loopback
-retrying mount with nouuid option
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
-
-=== copying scratch device to single target, large ro device
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Creating file <FSIMAGE1>
- 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ...
80%  ... 90%  ... 100%
-
-All copies completed.
-checking new image
-mounting new image on loopback
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
-
-=== copying scratch device to multiple targets
-Creating file <FSIMAGE1>
-Creating file <FSIMAGE2>
- 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ...
80%  ... 90%  ... 100%
-
-All copies completed.
-checking new image
-mounting new image on loopback
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
-checking new image
-mounting new image on loopback
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
074 211s ... 218s
075 84s ... 100s
076 80s ... [failed, exit status 1] - output mismatch (see 076.out.bad)
--- 076.out    2011-05-11 22:32:24.000000000 +0530
+++ 076.out.bad    2011-06-15 14:49:41.146042964 +0530
@@ -1,5 +1,6 @@
 QA output created by 076
-*** init fs
-*** test concurrent block/fs access
-*** done
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
+failed to unmount /dev/sda6
 *** unmount
077     [failed, exit status 1] - output mismatch (see 077.out.bad)
--- 077.out    2011-05-11 22:32:24.000000000 +0530
+++ 077.out.bad    2011-06-15 14:49:42.722023261 +0530
@@ -1,7 +1,5 @@
 QA output created by 077
 *** create filesystem
-*** set default ACL
-*** populate filesystem, pass #1
-*** populate filesystem, pass #2
-*** all done
+mkfs failed
+(see 077.full for details)
 *** unmount
078 78s ... 80s
_check_xfs_filesystem: filesystem on /dev/sda5 has dirty log (see 078.full)
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (c) (see
078.full)
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (r) (see
078.full)
Ran: 001 002 003 004 005 006 007 008 009 011 012 013 014 015 016 017 019 020
021 026 027 028 029 030 031 032 033 034 041 042 045 046 047 048 049 050 051
052 053 054 056 061 062 063 064 065 066 067 068 069 070 072 073 074 075 076
077 078
Not run: 010 035 040 044 057 058
Failures: 015 042 049 050 052 053 054 056 061 062 063 064 065 066 067 068
069 072 073 076 077
Failed 21 of 58 tests

--20cf30564473dcf77904a5bcb811
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi I am running xfstest suite using command<br><br>./check -xfs -g auto <br=
><br>PC x86 machine with Kernel version 2.6.38.5<br>
XFS Tests Suite dated 2011-05-11 (<a href=3D"http://oss.sgi.com/cgi-bin/git=
web.cgi?p=3Dxfs/cmds/xfstests.git;a=3Dsummary" target=3D"_blank">http://oss=
.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git;a=3Dsummary</a>)<br><=
br><br>
Many of the test cases are failing , please let me know thatt am I missing =
something?<br><br>Regards,<br>Manish<br><br><br>FSTYP=A0=A0=A0=A0=A0=A0=A0=
=A0 -- xfs (non-debug)<br>PLATFORM=A0=A0=A0=A0=A0 -- Linux/i686 mannuDesk 2=
.6.38.5<br>MKFS_OPTIONS=A0 -- -f -bsize=3D4096 /dev/sda6<br>
MOUNT_OPTIONS -- /dev/sda6 /home/manish/Projects/xfstests/sdb4<br><br>001 4=
s ... 5s<br>002 0s ... 0s<br>003 0s ... 0s<br>004 1s ... 1s<br>005 0s ... 0=
s<br>006 35s ... 36s<br>007 58s ... 58s<br>008 1s ... 1s<br>009 1s ... 1s<b=
r>
010=A0=A0=A0 =A0[not run] dbtest was not built for this platform<br>011 43s=
 ... 45s<br>012 1s ... 2s<br>013 145s ... 158s<br>014 53s ... 51s<br>015 1s=
 ... - output mismatch (see 015.out.bad)<br>--- 015.out=A0=A0=A0 2011-05-11=
 22:32:24.000000000 +0530<br>
+++ 015.out.bad=A0=A0=A0 2011-06-15 14:34:36.561351828 +0530<br>@@ -4,4 +4,=
8 @@<br>=A0check free space:<br>=A0delete fill:<br>=A0check free space:<br>=
-=A0=A0 !!! free space is in range<br>+=A0=A0 !!! free space has value of 2=
0<br>+free space is NOT in range 43306.56 .. 44181.44<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>016 74s .=
.. 79s<br>017 28s ... 30s<br>
019 1s ... 1s<br>020 4s ... 3s<br>021 1s ... 1s<br>026 12s ... 13s<br>027 1=
2s ... 12s<br>028 23s ... 23s<br>029 1s ... 1s<br>030 16s ... 18s<br>031 9s=
 ... 9s<br>032 72s ... 70s<br>033 10s ... 11s<br>034 1s ... 1s<br>035=A0=A0=
=A0 =A0[not run] No dump tape specified<br>
040=A0=A0=A0 =A0[not run] Can&#39;t run srcdiff without KWORKAREA set<br>04=
1 23s ... 19s<br>042 115s ... [failed, exit status 1] - output mismatch (se=
e 042.out.bad)<br>--- 042.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<=
br>+++ 042.out.bad=A0=A0=A0 2011-06-15 14:42:05.946733738 +0530<br>
@@ -9,5 +9,8 @@<br>=A0Run xfs_fsr on filesystem... done<br>=A0Check fill fi=
le... done<br>=A0Check large file... done<br>-Checking filesystem... done<b=
r>-xfs_fsr tests passed.<br>+Checking filesystem... fail<br>+_check_scratch=
_fs failed (returned 1): see 042.full<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>044=A0=A0=
=A0 =A0[not run] This test requires a valid $SCRATCH_LOGDEV<br>
045 1s ... 1s<br>046 13s ... 13s<br>047=A0=A0=A0 =A024s<br>048 0s ... 0s<br=
>049 86s ... [failed, exit status 1] - output mismatch (see 049.out.bad)<br=
>--- 049.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 049.out.ba=
d=A0=A0=A0 2011-06-15 14:42:52.004157941 +0530<br>
@@ -13,3 +13,5 @@<br>=A0--- clean<br>=A0--- umount ext2 on xfs<br>=A0--- um=
ount xfs<br>+!!! umount xfs failed<br>+(see 049.full for details)<br>050=A0=
=A0=A0 =A0[failed, exit status 1] - output mismatch (see 050.out.bad)<br>--=
- 050.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>
+++ 050.out.bad=A0=A0=A0 2011-06-15 14:42:52.866147163 +0530<br>@@ -1,193 +=
1,5 @@<br>=A0QA output created by 050<br>-*** user<br>-meta-data=3DDDEV isi=
ze=3DXXX agcount=3DN, agsize=3DXXX blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXX=
X blocks=3DXXX, imaxpct=3DPCT<br>
-=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-n=
aming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX =
blocks=3DXXX<br>-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX=
<br>-<br>-*** report no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0=
 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [=
--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 1 4 10 00 =
[--------] 0 0 0 00 [--------]<br>-<br>-*** push past the soft inode limit<=
br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]<br>-<b=
r>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 =
00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]<br>-=
<br>-*** push past the hard inode limit (expect EDQUOT)<br>-[ROOT] 0 0 0 00=
 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 500 =
00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]<br>
-<br>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 0=
0 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] =3DOK=3D 10=
0 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]<br>-<br>-*** unmo=
unt<br>
-*** group<br>-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX blks<=
br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-naming=
=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX block=
s=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-<br>-*** re=
port no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0=
 0 0 00 [--------]<br>-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00=
 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]<br=
>-<br>-*** push past the soft inode limit<br>-[ROOT] 0 0 0 00 [--------] 3 =
0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 3 =
4 10 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0=
 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 500 00 [7 days] 4 4=
 10 00 [7 days] 0 0 0 00 [--------]<br>-<br>-*** push past the hard inode l=
imit (expect EDQUOT)<br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]<br>-<br=
>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 00 [-=
-------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] =3DOK=3D 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------=
]<br>-<br>-*** unmount<br>-*** uqnoenforce<br>-meta-data=3DDDEV isize=3DXXX=
 agcount=3DN, agsize=3DXXX blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=
=3DXXX, imaxpct=3DPCT<br>
-=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-n=
aming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX =
blocks=3DXXX<br>-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX=
<br>-<br>-*** report no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0=
 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [=
--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 1 4 10 00 =
[--------] 0 0 0 00 [--------]<br>-<br>-*** push past the soft inode limit<=
br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]<br>-<b=
r>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 =
00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00 [--------]<=
br>-<br>-*** push past the hard inode limit (expect EDQUOT)<br>-[ROOT] 0 0 =
0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 =
500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]<br>
-<br>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 0=
0 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 540 100 500=
 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]<br>-<br>-*** unmou=
nt<br>
-*** gqnoenforce<br>-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX=
 blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-na=
ming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX b=
locks=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-<br>-*** re=
port no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0=
 0 0 00 [--------]<br>-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00=
 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]<br=
>-<br>-*** push past the soft inode limit<br>-[ROOT] 0 0 0 00 [--------] 3 =
0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 3 =
4 10 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0=
 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 500 00 [--------] 4=
 4 10 00 [--------] 0 0 0 00 [--------]<br>-<br>-*** push past the hard ino=
de limit (expect EDQUOT)<br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]<br>=
-<br>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 0=
0 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]=
<br>-<br>-*** unmount<br>-*** pquota<br>-meta-data=3DDDEV isize=3DXXX agcou=
nt=3DN, agsize=3DXXX blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=3DXXX=
, imaxpct=3DPCT<br>-=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, =
unwritten=3DX<br>
-naming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXX=
X blocks=3DXXX<br>-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DX=
XX<br>-<br>-*** report no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0=
 0 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [=
--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 1 4 10 00 =
[--------] 0 0 0 00 [--------]<br>-<br>-*** push past the soft inode limit<=
br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 0 100 500 00 [--------] 3 4 10 00 [--------] 0 0 0 00 [--------]<br>-<b=
r>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 =
00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]<br>-=
<br>-*** push past the hard inode limit (expect EDQUOT)<br>-[ROOT] 0 0 0 00=
 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 500 =
00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]<br>
-<br>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 0=
0 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] =3DOK=3D 10=
0 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]<br>-<br>-*** unmou=
nt<br>
-*** pqnoenforce<br>-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX=
 blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=
=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-na=
ming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX b=
locks=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-<br>-*** re=
port no quota settings<br>-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0=
 0 0 00 [--------]<br>-<br>-*** report initial settings<br>-[ROOT] 0 0 0 00=
 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]<br=
>-<br>-*** push past the soft inode limit<br>-[ROOT] 0 0 0 00 [--------] 3 =
0 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 0 100 500 00 [--------] 3 =
4 10 00 [--------] 0 0 0 00 [--------]<br>
-<br>-*** push past the soft block limit<br>-[ROOT] 0 0 0 00 [--------] 3 0=
 0 00 [--------] 0 0 0 00 [--------]<br>-[NAME] 140 100 500 00 [--------] 4=
 4 10 00 [--------] 0 0 0 00 [--------]<br>-<br>-*** push past the hard ino=
de limit (expect EDQUOT)<br>
-[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>-[NA=
ME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00 [--------]<br>=
-<br>-*** push past the hard block limit (expect EDQUOT)<br>-[ROOT] 0 0 0 0=
0 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]<br>
-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00 [--------]=
<br>-<br>-*** unmount<br>+umount: /home/manish/Projects/xfstests/sdb4: devi=
ce is busy.<br>+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about proc=
esses that use<br>
+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+f=
ailed to unmount /dev/sda6<br>051 1s ... 0s<br>052=A0=A0=A0 =A0[failed, exi=
t status 1] - output mismatch (see 052.out.bad)<br>--- 052.out=A0=A0=A0 201=
1-05-11 22:32:24.000000000 +0530<br>
+++ 052.out.bad=A0=A0=A0 2011-06-15 14:42:54.705124173 +0530<br>@@ -1,9 +1,=
5 @@<br>=A0QA output created by 052<br>-meta-data=3DDDEV isize=3DXXX agcoun=
t=3DN, agsize=3DXXX blks<br>-data=A0=A0=A0=A0 =3D bsize=3DXXX blocks=3DXXX,=
 imaxpct=3DPCT<br>-=A0=A0=A0=A0=A0=A0=A0=A0 =3D sunit=3DXXX swidth=3DXXX, u=
nwritten=3DX<br>
-naming=A0=A0 =3DVERN bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXX=
X blocks=3DXXX<br>-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DX=
XX<br>-Comparing out of xfs_quota and xfs_db<br>-OK.<br>+umount: /home/mani=
sh/Projects/xfstests/sdb4: device is busy.<br>
+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<=
br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br=
>+failed to unmount /dev/sda6<br>053 1s ... [failed, exit status 1] - outpu=
t mismatch (see 053.out.bad)<br>
--- 053.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 053.out.bad=
=A0=A0=A0 2011-06-15 14:42:55.443114947 +0530<br>@@ -1,24 +1,5 @@<br>=A0QA =
output created by 053<br>-make filesystem on $SCRATCH_DEV... done<br>-mount=
 filesytem... done<br>
-acls before repair:<br>-$SCRATCH_MNT/test.0 [u::r--,g::rwx,o::rw-]<br>-$SC=
RATCH_MNT/test.1 [u::r-x,g::---,o::---]<br>-$SCRATCH_MNT/test.2 [u::---,g::=
r-x,o::---]<br>-$SCRATCH_MNT/test.3 [u::---,g::---,o::r-x]<br>-$SCRATCH_MNT=
/test.4 [u::---,g::r-x,o::rwx]<br>
-$SCRATCH_MNT/test.5 [u::---,u:id2:r-x,g::---,m::rwx,o::---]<br>-$SCRATCH_M=
NT/test.6 [u::rwx,g::r-x,o::r--]<br>-$SCRATCH_MNT/test.7 [u::---,g::---,g:i=
d2:r-x,m::-w-,o::---]<br>-unmount $SCRATCH_DEV... done<br>-repair filesyste=
m... done<br>
-mount filesytem... done<br>-acls after repair: <br>-$SCRATCH_MNT/test.0 [u=
::r--,g::rwx,o::rw-]<br>-$SCRATCH_MNT/test.1 [u::r-x,g::---,o::---]<br>-$SC=
RATCH_MNT/test.2 [u::---,g::r-x,o::---]<br>-$SCRATCH_MNT/test.3 [u::---,g::=
---,o::r-x]<br>
-$SCRATCH_MNT/test.4 [u::---,g::r-x,o::rwx]<br>-$SCRATCH_MNT/test.5 [u::---=
,u:id2:r-x,g::---,m::rwx,o::---]<br>-$SCRATCH_MNT/test.6 [u::rwx,g::r-x,o::=
r--]<br>-$SCRATCH_MNT/test.7 [u::---,g::---,g:id2:r-x,m::-w-,o::---]<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+failed t=
o unmount /dev/sda6<br>054 3s ... [failed, exit status 1] - output mismatch=
 (see 054.out.bad)<br>
--- 054.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 054.out.bad=
=A0=A0=A0 2011-06-15 14:42:56.126106409 +0530<br>@@ -1,73 +1,5 @@<br>=A0QA =
output created by 054<br>-*** Default mount options<br>- File: &quot;&lt;MO=
UNT&gt;/testfile&quot;<br>
- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid: (12345) =
Gid: (54321)<br>-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>-=
 File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular Fi=
le<br>
- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)<br>-Device: &lt;DEVICE&=
gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt;MOUNT&gt;/testfile&=
quot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid:=
 (56789) Gid: (98765)<br>
-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt=
;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0=
644/-rw-r--r--) Uid: (12345) Gid: (54321)<br>-Device: &lt;DEVICE&gt; Inode:=
 &lt;INODE&gt; Links: 1 <br>
-<br>-*** User quota mount option<br>- File: &quot;&lt;MOUNT&gt;/testfile&q=
uot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid: =
(12345) Gid: (54321)<br>-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links:=
 1 <br>
- File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular F=
ile<br>- Mode: (0644/-rw-r--r--) Uid: (34567) Gid: (76543)<br>-Device: &lt;=
DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt;MOUNT&gt;/te=
stfile&quot;<br>
- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid: (56789) =
Gid: (98765)<br>-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>-=
 File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular Fi=
le<br>
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)<br>-Device: &lt;DEVICE&=
gt; Inode: &lt;INODE&gt; Links: 1 <br>-<br>-*** Group quota mount option<br=
>- File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular =
File<br>
- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)<br>-Device: &lt;DEVICE&=
gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt;MOUNT&gt;/testfile&=
quot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid:=
 (34567) Gid: (76543)<br>
-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt=
;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0=
644/-rw-r--r--) Uid: (56789) Gid: (98765)<br>-Device: &lt;DEVICE&gt; Inode:=
 &lt;INODE&gt; Links: 1 <br>
- File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular F=
ile<br>- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)<br>-Device: &lt;=
DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>-<br>-*** User and Group quota=
 mount options<br>
- File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular F=
ile<br>- Mode: (0644/-rw-r--r--) Uid: (12345) Gid: (54321)<br>-Device: &lt;=
DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt;MOUNT&gt;/te=
stfile&quot;<br>
- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid: (34567) =
Gid: (76543)<br>-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>-=
 File: &quot;&lt;MOUNT&gt;/testfile&quot;<br>- Size: 0 Filetype: Regular Fi=
le<br>
- Mode: (0644/-rw-r--r--) Uid: (56789) Gid: (98765)<br>-Device: &lt;DEVICE&=
gt; Inode: &lt;INODE&gt; Links: 1 <br>- File: &quot;&lt;MOUNT&gt;/testfile&=
quot;<br>- Size: 0 Filetype: Regular File<br>- Mode: (0644/-rw-r--r--) Uid:=
 (12345) Gid: (54321)<br>
-Device: &lt;DEVICE&gt; Inode: &lt;INODE&gt; Links: 1 <br>-<br>+umount: /ho=
me/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=A0=A0=A0=A0=
 (In some cases useful info about processes that use<br>+=A0=A0=A0=A0=A0=A0=
=A0=A0 the device is found by lsof(8) or fuser(1))<br>
+failed to unmount /dev/sda6<br>056 12s ... [failed, exit status 1] - outpu=
t mismatch (see 056.out.bad)<br>--- 056.out=A0=A0=A0 2011-05-11 22:32:24.00=
0000000 +0530<br>+++ 056.out.bad=A0=A0=A0 2011-06-15 14:43:06.828972606 +05=
30<br>@@ -1,37 +1,8 @@<br>
=A0QA output created by 056<br>-Creating directory system to dump using src=
/fill.<br>-Setup ..........<br>-Dumping to file...<br>-xfsdump=A0 -f DUMP_F=
ILE -M stress_tape_media -L stress_056 SCRATCH_MNT<br>-xfsdump: using file =
dump (drive_simple) strategy<br>
-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT<br>-xfsdump: dump date: DATE=
<br>-xfsdump: session id: ID<br>-xfsdump: session label: &quot;stress_056&q=
uot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction =
complete<br>
-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: /var/xfsdump/inventor=
y created<br>-xfsdump: creating dump session media file 0 (media 0, file 0)=
<br>-xfsdump: dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump:=
 dumping non-directory files<br>
-xfsdump: ending media file<br>-xfsdump: media file size NUM bytes<br>-xfsd=
ump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete: SECS=
 seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Restoring from file.=
..<br>
-xfsrestore=A0 -f DUMP_FILE=A0 -L stress_056 RESTORE_DIR<br>-xfsrestore: us=
ing file dump (drive_simple) strategy<br>-xfsrestore: using online session =
inventory<br>-xfsrestore: searching media for directory dump<br>-xfsrestore=
: examining media file 0<br>
-xfsrestore: reading directories<br>-xfsrestore: 7 directories and 11 entri=
es processed<br>-xfsrestore: directory post-processing<br>-xfsrestore: rest=
oring non-directory files<br>-xfsrestore: restore complete: SECS seconds el=
apsed<br>
-xfsrestore: Restore Status: SUCCESS<br>-Comparing listing of dump director=
y with restore directory<br>-Files TMP.dump_dir and TMP.restore_dir are ide=
ntical<br>+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>
+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<=
br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br=
>+failed to unmount /dev/sda6<br>+_check_xfs_filesystem: filesystem on /dev=
/sda6 has dirty log (see 056.full)<br>
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see 05=
6.full)<br>+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent =
(r) (see 056.full)<br>057=A0=A0=A0 =A0[not run] Place holder for IRIX test =
057<br>
058=A0=A0=A0 =A0[not run] Place holder for IRIX test 058<br>061 11s ... [fa=
iled, exit status 1] - output mismatch (see 061.out.bad)<br>--- 061.out=A0=
=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 061.out.bad=A0=A0=A0 2011=
-06-15 14:43:17.950833562 +0530<br>
@@ -1,34 +1,8 @@<br>=A0QA output created by 061<br>-Creating directory syst=
em to dump using src/fill.<br>-Setup ..........<br>-Restoring from file...<=
br>-xfsrestore=A0 -f DUMP_FILE=A0 -L stress_056 RESTORE_DIR<br>-xfsrestore:=
 using file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: found dump matching specified label:<br>-xfsrestore: host=
name: <a href=3D"http://crackle.melbourne.sgi.com">crackle.melbourne.sgi.co=
m</a><br>
-xfsrestore: mount point: /spare1<br>-xfsrestore: volume: /dev/dsk/dks0d2s1=
<br>-xfsrestore: session time: TIME<br>-xfsrestore: level: 0<br>-xfsrestore=
: session label: &quot;stress_056&quot;<br>-xfsrestore: media label: &quot;=
stress_tape_media&quot;<br>
-xfsrestore: file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsresto=
re: media ID: ID<br>-xfsrestore: searching media for directory dump<br>-xfs=
restore: reading directories<br>-xfsrestore: 7 directories and 11 entries p=
rocessed<br>
-xfsrestore: directory post-processing<br>-xfsrestore: restoring non-direct=
ory files<br>-xfsrestore: restore complete: SECS seconds elapsed<br>-xfsres=
tore: Restore Status: SUCCESS<br>-Comparing dump directory with restore dir=
ectory<br>
-Files DUMP_DIR/file_guid and RESTORE_DIR/DUMP_SUBDIR/file_guid are identic=
al<br>-Files DUMP_DIR/file_mix1 and RESTORE_DIR/DUMP_SUBDIR/file_mix1 are i=
dentical<br>-Files DUMP_DIR/file_mix2 and RESTORE_DIR/DUMP_SUBDIR/file_mix2=
 are identical<br>
-Files DUMP_DIR/file_sticky and RESTORE_DIR/DUMP_SUBDIR/file_sticky are ide=
ntical<br>-Files DUMP_DIR/file_suid and RESTORE_DIR/DUMP_SUBDIR/file_suid a=
re identical<br>-Comparing listing of dump directory with restore directory=
<br>
-Files TMP.dump_dir and TMP.restore_dir are identical<br>+umount: /home/man=
ish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=A0=A0=A0=A0 (In s=
ome cases useful info about processes that use<br>+=A0=A0=A0=A0=A0=A0=A0=A0=
 the device is found by lsof(8) or fuser(1))<br>
+failed to unmount /dev/sda6<br>+_check_xfs_filesystem: filesystem on /dev/=
sda6 has dirty log (see 061.full)<br>+_check_xfs_filesystem: filesystem on =
/dev/sda6 is inconsistent (c) (see 061.full)<br>+_check_xfs_filesystem: fil=
esystem on /dev/sda6 is inconsistent (r) (see 061.full)<br>
062 1s ... [failed, exit status 1] - output mismatch (see 062.out.bad)<br>-=
-- 062.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 062.out.bad=
=A0=A0=A0 2011-06-15 14:43:18.673824524 +0530<br>@@ -1,660 +1,7 @@<br>=A0QA=
 output created by 062<br>
-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX blks<br>-data=A0=A0=
=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-naming=A0=A0 =3DVERN=
 bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX blocks=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-*** create =
test bed<br>-SCRATCH_MNT<br>-SCRATCH_MNT/dev<br>-SCRATCH_MNT/dev/b<br>-SCRA=
TCH_MNT/dev/c<br>-SCRATCH_MNT/dev/p<br>-SCRATCH_MNT/dir<br>-SCRATCH_MNT/lnk=
<br>
-SCRATCH_MNT/reg<br>-<br>-=3D=3D=3D TYPE reg; NAMESPACE user<br>-<br>-*** s=
et/get one initially empty attribute<br>-# file: SCRATCH_MNT/reg<br>-<a hre=
f=3D"http://user.name">user.name</a><br>-<br>-*** overwrite empty, set seve=
ral new attributes<br>
-*** fetch several attribute names and values (hex)<br>-# file: SCRATCH_MNT=
/reg<br>-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-user.name2=
=3D0xdeadbeef<br>-user.name3=3D0xdeface<br>-<br>-*** fetch several attribut=
e names and values (base64)<br>
-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://user.name">user.name</a>=3D0=
sur4=3D<br>-user.name2=3D0s3q2+7w=3D=3D<br>-user.name3=3D0s3vrO<br>-<br>-**=
* shrink value of an existing attribute<br>-# file: SCRATCH_MNT/reg<br>-<a =
href=3D"http://user.name">user.name</a>=3D0xbabe<br>
-user.name2=3D0xdeaf<br>-user.name3=3D0xdeface<br>-<br>-*** grow value of e=
xisting attribute<br>-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://user.na=
me">user.name</a>=3D0xbabe<br>-user.name2=3D0xdecade<br>-user.name3=3D0xdef=
ace<br>-<br>
-*** set an empty value for second attribute<br>-# file: SCRATCH_MNT/reg<br=
>-user.name2<br>-<br>-*** overwrite empty value<br>-# file: SCRATCH_MNT/reg=
<br>-user.name2=3D0xcafe<br>-<br>-*** remove attribute<br>-SCRATCH_MNT/reg:=
 user.name2: No such attribute<br>
-*** final list (strings, type=3Dreg, nsp=3Duser)<br>-# file: SCRATCH_MNT/r=
eg<br>-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-user.name3=
=3D0xdeface<br>-<br>-<br>-=3D=3D=3D TYPE dir; NAMESPACE user<br>-<br>-*** s=
et/get one initially empty attribute<br>
-# file: SCRATCH_MNT/dir<br>-<a href=3D"http://user.name">user.name</a><br>=
-<br>-*** overwrite empty, set several new attributes<br>-*** fetch several=
 attribute names and values (hex)<br>-# file: SCRATCH_MNT/dir<br>-<a href=
=3D"http://user.name">user.name</a>=3D0xbabe<br>
-user.name2=3D0xdeadbeef<br>-user.name3=3D0xdeface<br>-<br>-*** fetch sever=
al attribute names and values (base64)<br>-# file: SCRATCH_MNT/dir<br>-<a h=
ref=3D"http://user.name">user.name</a>=3D0sur4=3D<br>-user.name2=3D0s3q2+7w=
=3D=3D<br>-user.name3=3D0s3vrO<br>
-<br>-*** shrink value of an existing attribute<br>-# file: SCRATCH_MNT/dir=
<br>-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-user.name2=3D0=
xdeaf<br>-user.name3=3D0xdeface<br>-<br>-*** grow value of existing attribu=
te<br>
-# file: SCRATCH_MNT/dir<br>-<a href=3D"http://user.name">user.name</a>=3D0=
xbabe<br>-user.name2=3D0xdecade<br>-user.name3=3D0xdeface<br>-<br>-*** set =
an empty value for second attribute<br>-# file: SCRATCH_MNT/dir<br>-user.na=
me2<br>
-<br>-*** overwrite empty value<br>-# file: SCRATCH_MNT/dir<br>-user.name2=
=3D0xcafe<br>-<br>-*** remove attribute<br>-SCRATCH_MNT/dir: user.name2: No=
 such attribute<br>-*** final list (strings, type=3Ddir, nsp=3Duser)<br>-# =
file: SCRATCH_MNT/dir<br>
-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-user.name3=3D0xdef=
ace<br>-<br>-<br>-=3D=3D=3D TYPE lnk; NAMESPACE user<br>-<br>-*** set/get o=
ne initially empty attribute<br>-setfattr: SCRATCH_MNT/lnk: Operation not p=
ermitted<br>
-*** overwrite empty, set several new attributes<br>-setfattr: SCRATCH_MNT/=
lnk: Operation not permitted<br>-setfattr: SCRATCH_MNT/lnk: Operation not p=
ermitted<br>-setfattr: SCRATCH_MNT/lnk: Operation not permitted<br>-*** fet=
ch several attribute names and values (hex)<br>
-*** fetch several attribute names and values (base64)<br>-*** shrink value=
 of an existing attribute<br>-setfattr: SCRATCH_MNT/lnk: Operation not perm=
itted<br>-*** grow value of existing attribute<br>-setfattr: SCRATCH_MNT/ln=
k: Operation not permitted<br>
-*** set an empty value for second attribute<br>-setfattr: SCRATCH_MNT/lnk:=
 Operation not permitted<br>-SCRATCH_MNT/lnk: user.name2: Operation not per=
mitted<br>-*** overwrite empty value<br>-setfattr: SCRATCH_MNT/lnk: Operati=
on not permitted<br>
-SCRATCH_MNT/lnk: user.name2: Operation not permitted<br>-*** remove attrib=
ute<br>-setfattr: SCRATCH_MNT/lnk: Operation not permitted<br>-SCRATCH_MNT/=
lnk: user.name2: Operation not permitted<br>-*** final list (strings, type=
=3Dlnk, nsp=3Duser)<br>
-<br>-=3D=3D=3D TYPE dev/b; NAMESPACE user<br>-<br>-*** set/get one initial=
ly empty attribute<br>-setfattr: SCRATCH_MNT/dev/b: Operation not permitted=
<br>-*** overwrite empty, set several new attributes<br>-setfattr: SCRATCH_=
MNT/dev/b: Operation not permitted<br>
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted<br>-setfattr: SCRATCH=
_MNT/dev/b: Operation not permitted<br>-*** fetch several attribute names a=
nd values (hex)<br>-*** fetch several attribute names and values (base64)<b=
r>
-*** shrink value of an existing attribute<br>-setfattr: SCRATCH_MNT/dev/b:=
 Operation not permitted<br>-*** grow value of existing attribute<br>-setfa=
ttr: SCRATCH_MNT/dev/b: Operation not permitted<br>-*** set an empty value =
for second attribute<br>
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted<br>-SCRATCH_MNT/dev/b=
: user.name2: Operation not permitted<br>-*** overwrite empty value<br>-set=
fattr: SCRATCH_MNT/dev/b: Operation not permitted<br>-SCRATCH_MNT/dev/b: us=
er.name2: Operation not permitted<br>
-*** remove attribute<br>-setfattr: SCRATCH_MNT/dev/b: Operation not permit=
ted<br>-SCRATCH_MNT/dev/b: user.name2: Operation not permitted<br>-*** fina=
l list (strings, type=3Ddev/b, nsp=3Duser)<br>-<br>-=3D=3D=3D TYPE dev/c; N=
AMESPACE user<br>
-<br>-*** set/get one initially empty attribute<br>-setfattr: SCRATCH_MNT/d=
ev/c: Operation not permitted<br>-*** overwrite empty, set several new attr=
ibutes<br>-setfattr: SCRATCH_MNT/dev/c: Operation not permitted<br>-setfatt=
r: SCRATCH_MNT/dev/c: Operation not permitted<br>
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted<br>-*** fetch several=
 attribute names and values (hex)<br>-*** fetch several attribute names and=
 values (base64)<br>-*** shrink value of an existing attribute<br>-setfattr=
: SCRATCH_MNT/dev/c: Operation not permitted<br>
-*** grow value of existing attribute<br>-setfattr: SCRATCH_MNT/dev/c: Oper=
ation not permitted<br>-*** set an empty value for second attribute<br>-set=
fattr: SCRATCH_MNT/dev/c: Operation not permitted<br>-SCRATCH_MNT/dev/c: us=
er.name2: Operation not permitted<br>
-*** overwrite empty value<br>-setfattr: SCRATCH_MNT/dev/c: Operation not p=
ermitted<br>-SCRATCH_MNT/dev/c: user.name2: Operation not permitted<br>-***=
 remove attribute<br>-setfattr: SCRATCH_MNT/dev/c: Operation not permitted<=
br>
-SCRATCH_MNT/dev/c: user.name2: Operation not permitted<br>-*** final list =
(strings, type=3Ddev/c, nsp=3Duser)<br>-<br>-=3D=3D=3D TYPE dev/p; NAMESPAC=
E user<br>-<br>-*** set/get one initially empty attribute<br>-setfattr: SCR=
ATCH_MNT/dev/p: Operation not permitted<br>
-*** overwrite empty, set several new attributes<br>-setfattr: SCRATCH_MNT/=
dev/p: Operation not permitted<br>-setfattr: SCRATCH_MNT/dev/p: Operation n=
ot permitted<br>-setfattr: SCRATCH_MNT/dev/p: Operation not permitted<br>
-*** fetch several attribute names and values (hex)<br>-*** fetch several a=
ttribute names and values (base64)<br>-*** shrink value of an existing attr=
ibute<br>-setfattr: SCRATCH_MNT/dev/p: Operation not permitted<br>-*** grow=
 value of existing attribute<br>
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted<br>-*** set an empty =
value for second attribute<br>-setfattr: SCRATCH_MNT/dev/p: Operation not p=
ermitted<br>-SCRATCH_MNT/dev/p: user.name2: Operation not permitted<br>
-*** overwrite empty value<br>-setfattr: SCRATCH_MNT/dev/p: Operation not p=
ermitted<br>-SCRATCH_MNT/dev/p: user.name2: Operation not permitted<br>-***=
 remove attribute<br>-setfattr: SCRATCH_MNT/dev/p: Operation not permitted<=
br>
-SCRATCH_MNT/dev/p: user.name2: Operation not permitted<br>-*** final list =
(strings, type=3Ddev/p, nsp=3Duser)<br>-<br>-=3D=3D=3D TYPE reg; NAMESPACE =
trusted<br>-<br>-*** set/get one initially empty attribute<br>-# file: SCRA=
TCH_MNT/reg<br>
-<a href=3D"http://trusted.name">trusted.name</a><br>-<br>-*** overwrite em=
pty, set several new attributes<br>-*** fetch several attribute names and v=
alues (hex)<br>-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name"=
>trusted.name</a>=3D0xbabe<br>
-trusted.name2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<br>-<br>-*** fetch=
 several attribute names and values (base64)<br>-# file: SCRATCH_MNT/reg<br=
>-<a href=3D"http://trusted.name">trusted.name</a>=3D0sur4=3D<br>-trusted.n=
ame2=3D0s3q2+7w=3D=3D<br>
-trusted.name3=3D0s3vrO<br>-<br>-*** shrink value of an existing attribute<=
br>-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name">trusted.nam=
e</a>=3D0xbabe<br>-trusted.name2=3D0xdeaf<br>-trusted.name3=3D0xdeface<br>-=
<br>-*** grow value of existing attribute<br>
-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0xbabe<br>-trusted.name2=3D0xdecade<br>-trusted.name3=3D0xdeface<br>-<=
br>-*** set an empty value for second attribute<br>-# file: SCRATCH_MNT/reg=
<br>
-trusted.name2<br>-<br>-*** overwrite empty value<br>-# file: SCRATCH_MNT/r=
eg<br>-trusted.name2=3D0xcafe<br>-<br>-*** remove attribute<br>-SCRATCH_MNT=
/reg: trusted.name2: No such attribute<br>-*** final list (strings, type=3D=
reg, nsp=3Dtrusted)<br>
-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>-<a href=3D"http://user.name">u=
ser.name</a>=3D0xbabe<br>-user.name3=3D0xdeface<br>-<br>-<br>-=3D=3D=3D TYP=
E dir; NAMESPACE trusted<br>
-<br>-*** set/get one initially empty attribute<br>-# file: SCRATCH_MNT/dir=
<br>-<a href=3D"http://trusted.name">trusted.name</a><br>-<br>-*** overwrit=
e empty, set several new attributes<br>-*** fetch several attribute names a=
nd values (hex)<br>
-# file: SCRATCH_MNT/dir<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0xbabe<br>-trusted.name2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<br>=
-<br>-*** fetch several attribute names and values (base64)<br>-# file: SCR=
ATCH_MNT/dir<br>
-<a href=3D"http://trusted.name">trusted.name</a>=3D0sur4=3D<br>-trusted.na=
me2=3D0s3q2+7w=3D=3D<br>-trusted.name3=3D0s3vrO<br>-<br>-*** shrink value o=
f an existing attribute<br>-# file: SCRATCH_MNT/dir<br>-<a href=3D"http://t=
rusted.name">trusted.name</a>=3D0xbabe<br>
-trusted.name2=3D0xdeaf<br>-trusted.name3=3D0xdeface<br>-<br>-*** grow valu=
e of existing attribute<br>-# file: SCRATCH_MNT/dir<br>-<a href=3D"http://t=
rusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name2=3D0xdecade<br>-tru=
sted.name3=3D0xdeface<br>
-<br>-*** set an empty value for second attribute<br>-# file: SCRATCH_MNT/d=
ir<br>-trusted.name2<br>-<br>-*** overwrite empty value<br>-# file: SCRATCH=
_MNT/dir<br>-trusted.name2=3D0xcafe<br>-<br>-*** remove attribute<br>-SCRAT=
CH_MNT/dir: trusted.name2: No such attribute<br>
-*** final list (strings, type=3Ddir, nsp=3Dtrusted)<br>-# file: SCRATCH_MN=
T/dir<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-tru=
sted.name3=3D0xdeface<br>-<a href=3D"http://user.name">user.name</a>=3D0xba=
be<br>-user.name3=3D0xdeface<br>
-<br>-<br>-=3D=3D=3D TYPE lnk; NAMESPACE trusted<br>-<br>-*** set/get one i=
nitially empty attribute<br>-# file: SCRATCH_MNT/lnk<br>-<a href=3D"http://=
trusted.name">trusted.name</a><br>-<br>-*** overwrite empty, set several ne=
w attributes<br>
-*** fetch several attribute names and values (hex)<br>-# file: SCRATCH_MNT=
/lnk<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trus=
ted.name2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<br>-<br>-*** fetch seve=
ral attribute names and values (base64)<br>
-# file: SCRATCH_MNT/lnk<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0sur4=3D<br>-trusted.name2=3D0s3q2+7w=3D=3D<br>-trusted.name3=3D0s3vrO=
<br>-<br>-*** shrink value of an existing attribute<br>-# file: SCRATCH_MNT=
/lnk<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>
-trusted.name2=3D0xdeaf<br>-trusted.name3=3D0xdeface<br>-<br>-*** grow valu=
e of existing attribute<br>-# file: SCRATCH_MNT/lnk<br>-<a href=3D"http://t=
rusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name2=3D0xdecade<br>-tru=
sted.name3=3D0xdeface<br>
-<br>-*** set an empty value for second attribute<br>-# file: SCRATCH_MNT/l=
nk<br>-trusted.name2<br>-<br>-*** overwrite empty value<br>-# file: SCRATCH=
_MNT/lnk<br>-trusted.name2=3D0xcafe<br>-<br>-*** remove attribute<br>-SCRAT=
CH_MNT/lnk: trusted.name2: No such attribute<br>
-*** final list (strings, type=3Dlnk, nsp=3Dtrusted)<br>-# file: SCRATCH_MN=
T/lnk<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-tru=
sted.name3=3D0xdeface<br>-<br>-<br>-=3D=3D=3D TYPE dev/b; NAMESPACE trusted=
<br>-<br>-*** set/get one initially empty attribute<br>
-# file: SCRATCH_MNT/dev/b<br>-<a href=3D"http://trusted.name">trusted.name=
</a><br>-<br>-*** overwrite empty, set several new attributes<br>-*** fetch=
 several attribute names and values (hex)<br>-# file: SCRATCH_MNT/dev/b<br>
-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name=
2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<br>-<br>-*** fetch several attr=
ibute names and values (base64)<br>-# file: SCRATCH_MNT/dev/b<br>-<a href=
=3D"http://trusted.name">trusted.name</a>=3D0sur4=3D<br>
-trusted.name2=3D0s3q2+7w=3D=3D<br>-trusted.name3=3D0s3vrO<br>-<br>-*** shr=
ink value of an existing attribute<br>-# file: SCRATCH_MNT/dev/b<br>-<a hre=
f=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name2=3D0xd=
eaf<br>-trusted.name3=3D0xdeface<br>
-<br>-*** grow value of existing attribute<br>-# file: SCRATCH_MNT/dev/b<br=
>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.nam=
e2=3D0xdecade<br>-trusted.name3=3D0xdeface<br>-<br>-*** set an empty value =
for second attribute<br>
-# file: SCRATCH_MNT/dev/b<br>-trusted.name2<br>-<br>-*** overwrite empty v=
alue<br>-# file: SCRATCH_MNT/dev/b<br>-trusted.name2=3D0xcafe<br>-<br>-*** =
remove attribute<br>-SCRATCH_MNT/dev/b: trusted.name2: No such attribute<br=
>
-*** final list (strings, type=3Ddev/b, nsp=3Dtrusted)<br>-# file: SCRATCH_=
MNT/dev/b<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>=
-trusted.name3=3D0xdeface<br>-<br>-<br>-=3D=3D=3D TYPE dev/c; NAMESPACE tru=
sted<br>-<br>
-*** set/get one initially empty attribute<br>-# file: SCRATCH_MNT/dev/c<br=
>-<a href=3D"http://trusted.name">trusted.name</a><br>-<br>-*** overwrite e=
mpty, set several new attributes<br>-*** fetch several attribute names and =
values (hex)<br>
-# file: SCRATCH_MNT/dev/c<br>-<a href=3D"http://trusted.name">trusted.name=
</a>=3D0xbabe<br>-trusted.name2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<b=
r>-<br>-*** fetch several attribute names and values (base64)<br>-# file: S=
CRATCH_MNT/dev/c<br>
-<a href=3D"http://trusted.name">trusted.name</a>=3D0sur4=3D<br>-trusted.na=
me2=3D0s3q2+7w=3D=3D<br>-trusted.name3=3D0s3vrO<br>-<br>-*** shrink value o=
f an existing attribute<br>-# file: SCRATCH_MNT/dev/c<br>-<a href=3D"http:/=
/trusted.name">trusted.name</a>=3D0xbabe<br>
-trusted.name2=3D0xdeaf<br>-trusted.name3=3D0xdeface<br>-<br>-*** grow valu=
e of existing attribute<br>-# file: SCRATCH_MNT/dev/c<br>-<a href=3D"http:/=
/trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name2=3D0xdecade<br>-t=
rusted.name3=3D0xdeface<br>
-<br>-*** set an empty value for second attribute<br>-# file: SCRATCH_MNT/d=
ev/c<br>-trusted.name2<br>-<br>-*** overwrite empty value<br>-# file: SCRAT=
CH_MNT/dev/c<br>-trusted.name2=3D0xcafe<br>-<br>-*** remove attribute<br>
-SCRATCH_MNT/dev/c: trusted.name2: No such attribute<br>-*** final list (st=
rings, type=3Ddev/c, nsp=3Dtrusted)<br>-# file: SCRATCH_MNT/dev/c<br>-<a hr=
ef=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name3=3D0x=
deface<br>
-<br>-<br>-=3D=3D=3D TYPE dev/p; NAMESPACE trusted<br>-<br>-*** set/get one=
 initially empty attribute<br>-# file: SCRATCH_MNT/dev/p<br>-<a href=3D"htt=
p://trusted.name">trusted.name</a><br>-<br>-*** overwrite empty, set severa=
l new attributes<br>
-*** fetch several attribute names and values (hex)<br>-# file: SCRATCH_MNT=
/dev/p<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-tr=
usted.name2=3D0xdeadbeef<br>-trusted.name3=3D0xdeface<br>-<br>-*** fetch se=
veral attribute names and values (base64)<br>
-# file: SCRATCH_MNT/dev/p<br>-<a href=3D"http://trusted.name">trusted.name=
</a>=3D0sur4=3D<br>-trusted.name2=3D0s3q2+7w=3D=3D<br>-trusted.name3=3D0s3v=
rO<br>-<br>-*** shrink value of an existing attribute<br>-# file: SCRATCH_M=
NT/dev/p<br>
-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name=
2=3D0xdeaf<br>-trusted.name3=3D0xdeface<br>-<br>-*** grow value of existing=
 attribute<br>-# file: SCRATCH_MNT/dev/p<br>-<a href=3D"http://trusted.name=
">trusted.name</a>=3D0xbabe<br>
-trusted.name2=3D0xdecade<br>-trusted.name3=3D0xdeface<br>-<br>-*** set an =
empty value for second attribute<br>-# file: SCRATCH_MNT/dev/p<br>-trusted.=
name2<br>-<br>-*** overwrite empty value<br>-# file: SCRATCH_MNT/dev/p<br>-=
trusted.name2=3D0xcafe<br>
-<br>-*** remove attribute<br>-SCRATCH_MNT/dev/p: trusted.name2: No such at=
tribute<br>-*** final list (strings, type=3Ddev/p, nsp=3Dtrusted)<br>-# fil=
e: SCRATCH_MNT/dev/p<br>-<a href=3D"http://trusted.name">trusted.name</a>=
=3D0xbabe<br>
-trusted.name3=3D0xdeface<br>-<br>-<br>-<br>-*** extend test bed<br>-SCRATC=
H_MNT<br>-SCRATCH_MNT/descend<br>-SCRATCH_MNT/descend/and<br>-SCRATCH_MNT/d=
escend/down<br>-SCRATCH_MNT/descend/down/here<br>-SCRATCH_MNT/dev<br>-SCRAT=
CH_MNT/dev/b<br>
-SCRATCH_MNT/dev/c<br>-SCRATCH_MNT/dev/p<br>-SCRATCH_MNT/dir<br>-SCRATCH_MN=
T/here<br>-SCRATCH_MNT/here/up<br>-SCRATCH_MNT/here/up/ascend<br>-SCRATCH_M=
NT/lnk<br>-SCRATCH_MNT/reg<br>-<br>-*** directory descent with us following=
 symlinks<br>
-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>-<a href=3D"http://user.name">u=
ser.name</a>=3D0xbabe<br>-user.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MN=
T/dir<br>
-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name=
3=3D0xdeface<br>-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-us=
er.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MNT/lnk<br>-<a href=3D"http://=
trusted.name">trusted.name</a>=3D0xbabe<br>
-trusted.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MNT/dev/b<br>-<a href=3D=
"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name3=3D0xdefac=
e<br>-<br>-# file: SCRATCH_MNT/dev/c<br>-<a href=3D"http://trusted.name">tr=
usted.name</a>=3D0xbabe<br>
-trusted.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MNT/dev/p<br>-<a href=3D=
"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name3=3D0xdefac=
e<br>-<br>-# file: SCRATCH_MNT/here<br>-trusted.9=3D0x3837<br>-trusted.a=3D=
0x6263<br>
-<br>-# file: SCRATCH_MNT/here/up<br>-trusted.9=3D0x3837<br>-trusted.a=3D0x=
6263<br>-<br>-# file: SCRATCH_MNT/here/up/ascend<br>-trusted.9=3D0x3837<br>=
-trusted.a=3D0x6263<br>-<br>-# file: SCRATCH_MNT/descend<br>-user.1=3D0x323=
3<br>-user.x=3D0x797a<br>
-<br>-# file: SCRATCH_MNT/descend/down<br>-user.1=3D0x3233<br>-user.x=3D0x7=
97a<br>-<br>-# file: SCRATCH_MNT/descend/down/here<br>-user.1=3D0x3233<br>-=
user.x=3D0x797a<br>-<br>-# file: SCRATCH_MNT/descend/and/ascend<br>-trusted=
.9=3D0x3837<br>
-trusted.a=3D0x6263<br>-<br>-<br>-*** directory descent without following s=
ymlinks<br>-# file: SCRATCH_MNT/reg<br>-<a href=3D"http://trusted.name">tru=
sted.name</a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>-<a href=3D"http://u=
ser.name">user.name</a>=3D0xbabe<br>
-user.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MNT/dir<br>-<a href=3D"http=
://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>=
-<a href=3D"http://user.name">user.name</a>=3D0xbabe<br>-user.name3=3D0xdef=
ace<br>-<br>
-# file: SCRATCH_MNT/lnk<br>-<a href=3D"http://trusted.name">trusted.name</=
a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MNT/dev/b=
<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-trusted.=
name3=3D0xdeface<br>
-<br>-# file: SCRATCH_MNT/dev/c<br>-<a href=3D"http://trusted.name">trusted=
.name</a>=3D0xbabe<br>-trusted.name3=3D0xdeface<br>-<br>-# file: SCRATCH_MN=
T/dev/p<br>-<a href=3D"http://trusted.name">trusted.name</a>=3D0xbabe<br>-t=
rusted.name3=3D0xdeface<br>
-<br>-# file: SCRATCH_MNT/here<br>-trusted.9=3D0x3837<br>-trusted.a=3D0x626=
3<br>-<br>-# file: SCRATCH_MNT/here/up<br>-trusted.9=3D0x3837<br>-trusted.a=
=3D0x6263<br>-<br>-# file: SCRATCH_MNT/here/up/ascend<br>-trusted.9=3D0x383=
7<br>-trusted.a=3D0x6263<br>
-<br>-# file: SCRATCH_MNT/descend<br>-user.1=3D0x3233<br>-user.x=3D0x797a<b=
r>-<br>-# file: SCRATCH_MNT/descend/down<br>-user.1=3D0x3233<br>-user.x=3D0=
x797a<br>-<br>-# file: SCRATCH_MNT/descend/down/here<br>-user.1=3D0x3233<br=
>-user.x=3D0x797a<br>
-<br>-<br>-<br>-*** backup everything<br>-*** clear out the scratch device<=
br>-*** reset test bed with no extended attributes<br>-*** create test bed<=
br>-SCRATCH_MNT<br>-SCRATCH_MNT/dev<br>-SCRATCH_MNT/dev/b<br>-SCRATCH_MNT/d=
ev/c<br>
-SCRATCH_MNT/dev/p<br>-SCRATCH_MNT/dir<br>-SCRATCH_MNT/lnk<br>-SCRATCH_MNT/=
reg<br>-*** extend test bed<br>-SCRATCH_MNT<br>-SCRATCH_MNT/descend<br>-SCR=
ATCH_MNT/descend/and<br>-SCRATCH_MNT/descend/down<br>-SCRATCH_MNT/descend/d=
own/here<br>
-SCRATCH_MNT/dev<br>-SCRATCH_MNT/dev/b<br>-SCRATCH_MNT/dev/c<br>-SCRATCH_MN=
T/dev/p<br>-SCRATCH_MNT/dir<br>-SCRATCH_MNT/here<br>-SCRATCH_MNT/here/up<br=
>-SCRATCH_MNT/here/up/ascend<br>-SCRATCH_MNT/lnk<br>-SCRATCH_MNT/reg<br>
-*** restore everything<br>-*** compare before and after backups<br>+umount=
: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=A0=A0=
=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=A0=A0=
=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>
+failed to unmount /dev/sda6<br>=A0<br>=A0*** unmount<br>063 12s ... [faile=
d, exit status 1] - output mismatch (see 063.out.bad)<br>--- 063.out=A0=A0=
=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 063.out.bad=A0=A0=A0 2011-06=
-15 14:43:29.427690082 +0530<br>
@@ -1,74 +1,8 @@<br>=A0QA output created by 063<br>-Creating directory syst=
em to dump using src/fill.<br>-Setup Attribute &quot;attr1&quot; set to a 9=
 byte value for smalll:<br>-some_text<br>-.Attribute &quot;attr2&quot; set =
to a 10 byte value for biggg:<br>
-some_text2<br>-.Attribute &quot;attr3&quot; set to a 10 byte value for sub=
/smalll:<br>-some_text3<br>-.Attribute &quot;attr4&quot; set to a 10 byte v=
alue for sub/biggg:<br>-some_text4<br>-.Attribute &quot;attr5&quot; set to =
a 8 byte value for dir:<br>
-dir_text<br>-...............<br>-Dumping to file...<br>-xfsdump=A0 -f DUMP=
_FILE -M stress_tape_media -L stress_063 SCRATCH_MNT<br>-xfsdump: using fil=
e dump (drive_simple) strategy<br>-xfsdump: level 0 dump of HOSTNAME:SCRATC=
H_MNT<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_063&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: /var/xfsdump/inventory created<br>-xfsdump: creating dump session=
 media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdump: d=
umping directories<br>-xfsdump: dumping non-directory files<br>-xfsdump: en=
ding media file<br>
-xfsdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) =
: NUM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: D=
ump Status: SUCCESS<br>-Restoring from file...<br>-xfsrestore=A0 -f DUMP_FI=
LE=A0 -L stress_063 RESTORE_DIR<br>
-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: using =
online session inventory<br>-xfsrestore: searching media for directory dump=
<br>-xfsrestore: examining media file 0<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 4 directories and 21 entries processed<br>-xfsrestore: directo=
ry post-processing<br>-xfsrestore: restoring non-directory files<br>-xfsres=
tore: restore complete: SECS seconds elapsed<br>-xfsrestore: Restore Status=
: SUCCESS<br>
-Comparing dump directory with restore directory<br>-Looking at the extende=
d attributes (EAs)<br>-EAs on dump<br>-User names<br>-Attribute &quot;attr5=
&quot; had a 8 byte value for DUMP_DIR/dir:<br>-dir_text<br>-Attribute &quo=
t;attr1&quot; had a 9 byte value for DUMP_DIR/smalll:<br>
-some_text<br>-Attribute &quot;attr3&quot; had a 10 byte value for DUMP_DIR=
/sub/smalll:<br>-some_text3<br>-Root names<br>-Attribute &quot;attr2&quot; =
had a 10 byte value for DUMP_DIR/biggg:<br>-some_text2<br>-Attribute &quot;=
attr4&quot; had a 10 byte value for DUMP_DIR/sub/biggg:<br>
-some_text4<br>-EAs on restore<br>-User names<br>-Attribute &quot;attr5&quo=
t; had a 8 byte value for DUMP_DIR/dir:<br>-dir_text<br>-Attribute &quot;at=
tr1&quot; had a 9 byte value for DUMP_DIR/smalll:<br>-some_text<br>-Attribu=
te &quot;attr3&quot; had a 10 byte value for DUMP_DIR/sub/smalll:<br>
-some_text3<br>-Root names<br>-Attribute &quot;attr2&quot; had a 10 byte va=
lue for DUMP_DIR/biggg:<br>-some_text2<br>-Attribute &quot;attr4&quot; had =
a 10 byte value for DUMP_DIR/sub/biggg:<br>-some_text4<br>-Files 063.ea1 an=
d 063.ea2 are identical<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+failed t=
o unmount /dev/sda6<br>+_check_xfs_filesystem: filesystem on /dev/sda6 has =
dirty log (see 063.full)<br>
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see 06=
3.full)<br>+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent =
(r) (see 063.full)<br>064=A0=A0=A0 =A0[failed, exit status 1] - output mism=
atch (see 064.out.bad)<br>
--- 064.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 064.out.bad=
=A0=A0=A0 2011-06-15 14:43:40.183555616 +0530<br>@@ -1,1484 +1,8 @@<br>=A0Q=
A output created by 064<br>-Creating directory system of hardlinks to incre=
mentally dump.<br>
-creating hardlink file1_h1 to file1<br>-creating hardlink file1_h2 to file=
1<br>-creating hardlink file1_h3 to file1<br>-creating hardlink file1_h4 to=
 file1<br>-creating hardlink file1_h5 to file1<br>-creating hardlink file2_=
h1 to file2<br>
-creating hardlink file2_h2 to file2<br>-creating hardlink file2_h3 to file=
2<br>-creating hardlink file2_h4 to file2<br>-creating hardlink file2_h5 to=
 file2<br>-creating hardlink file3_h1 to file3<br>-creating hardlink file3_=
h2 to file3<br>
-creating hardlink file3_h3 to file3<br>-creating hardlink file3_h4 to file=
3<br>-creating hardlink file3_h5 to file3<br>-creating hardlink file4_h1 to=
 file4<br>-creating hardlink file4_h2 to file4<br>-creating hardlink file4_=
h3 to file4<br>
-creating hardlink file4_h4 to file4<br>-creating hardlink file4_h5 to file=
4<br>-creating hardlink file5_h1 to file5<br>-creating hardlink file5_h2 to=
 file5<br>-creating hardlink file5_h3 to file5<br>-creating hardlink file5_=
h4 to file5<br>
-creating hardlink file5_h5 to file5<br>-creating hardlink file6_h1 to file=
6<br>-creating hardlink file6_h2 to file6<br>-creating hardlink file6_h3 to=
 file6<br>-creating hardlink file6_h4 to file6<br>-creating hardlink file6_=
h5 to file6<br>
-creating hardlink file7_h1 to file7<br>-creating hardlink file7_h2 to file=
7<br>-creating hardlink file7_h3 to file7<br>-creating hardlink file7_h4 to=
 file7<br>-creating hardlink file7_h5 to file7<br>-creating hardlink file8_=
h1 to file8<br>
-creating hardlink file8_h2 to file8<br>-creating hardlink file8_h3 to file=
8<br>-creating hardlink file8_h4 to file8<br>-creating hardlink file8_h5 to=
 file8<br>-creating hardlink file9_h1 to file9<br>-creating hardlink file9_=
h2 to file9<br>
-creating hardlink file9_h3 to file9<br>-creating hardlink file9_h4 to file=
9<br>-creating hardlink file9_h5 to file9<br>-Do the incremental dumps<br>-=
Dumping to file...<br>-xfsdump=A0 -l0 -f DUMP_FILE -M stress_tape_media -L =
stress_064 SCRATCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 0 dump=
 of HOSTNAME:SCRATCH_MNT<br>-xfsdump: dump date: DATE<br>-xfsdump: session =
id: ID<br>-xfsdump: session label: &quot;stress_064&quot;<br>-xfsdump: ino =
map &lt;PHASES&gt;<br>
-xfsdump: ino map construction complete<br>-xfsdump: estimated dump size: N=
UM bytes<br>-xfsdump: /var/xfsdump/inventory created<br>-xfsdump: creating =
dump session media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br=
>
-xfsdump: dumping directories<br>-xfsdump: dumping non-directory files<br>-=
xfsdump: ending media file<br>-xfsdump: media file size NUM bytes<br>-xfsdu=
mp: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete: SECS =
seconds elapsed<br>
-xfsdump: Dump Status: SUCCESS<br>-Dumping to file...<br>-xfsdump=A0 -l1 -f=
 DUMP_FILE -M stress_tape_media -L stress_064 SCRATCH_MNT<br>-xfsdump: usin=
g file dump (drive_simple) strategy<br>-xfsdump: level 1 incremental dump o=
f HOSTNAME:SCRATCH_MNT based on level 0 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_064&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Dumping to file=
...<br>-xfsdump=A0 -l2 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRA=
TCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 2 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 1 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_064&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Dumping to file...<br>-xfsdump=A0 -l3 -f DUMP_FILE -M stress_tape_media -L=
 stress_064 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 3 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 2 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_064&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Dumping to file=
...<br>-xfsdump=A0 -l4 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRA=
TCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 4 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 3 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_064&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Dumping to file...<br>-xfsdump=A0 -l5 -f DUMP_FILE -M stress_tape_media -L=
 stress_064 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 5 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 4 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_064&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Dumping to file=
...<br>-xfsdump=A0 -l6 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRA=
TCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 6 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 5 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_064&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Dumping to file...<br>-xfsdump=A0 -l7 -f DUMP_FILE -M stress_tape_media -L=
 stress_064 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 7 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 6 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_064&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Dumping to file=
...<br>-xfsdump=A0 -l8 -f DUMP_FILE -M stress_tape_media -L stress_064 SCRA=
TCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 8 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 7 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_064&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Dumping to file...<br>-xfsdump=A0 -l9 -f DUMP_FILE -M stress_tape_media -L=
 stress_064 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 9 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 8 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_064&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we start with:<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 f=
ile1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-12 file6<br>-12 file6_h1<br>-12 file6_h2<br>-12 fil=
e6_h3<br>
-12 file6_h4<br>-12 file6_h5<br>-12 file7<br>-12 file7_h1<br>-12 file7_h2<b=
r>-12 file7_h3<br>-12 file7_h4<br>-12 file7_h5<br>-12 file8<br>-12 file8_h1=
<br>-12 file8_h2<br>-12 file8_h3<br>-12 file8_h4<br>-12 file8_h5<br>-12 fil=
e9<br>
-12 file9_h1<br>-12 file9_h2<br>-12 file9_h3<br>-12 file9_h4<br>-12 file9_h=
5<br>-Look at what files are contained in the inc. dump<br>-<br>-restoring =
from df.level0<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE -t<b=
r>
-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: search=
ing media for dump<br>-xfsrestore: examining media file 0<br>-xfsrestore: d=
ump description: <br>-xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount =
point: SCRATCH_MNT<br>
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>-xfs=
restore: level: 0<br>-xfsrestore: session label: &quot;stress_064&quot;<br>=
-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore: fil=
e system ID: ID<br>
-xfsrestore: session id: ID<br>-xfsrestore: media ID: ID<br>-xfsrestore: us=
ing online session inventory<br>-xfsrestore: searching media for directory =
dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 directories and =
55 entries processed<br>
-xfsrestore: directory post-processing<br>-xfsrestore: reading non-director=
y files<br>-xfsrestore: table of contents display complete: SECS seconds el=
apsed<br>-xfsrestore: Restore Status: SUCCESS<br>-<br>-dumpdir/file1<br>
-dumpdir/file1_h1<br>-dumpdir/file1_h2<br>-dumpdir/file1_h3<br>-dumpdir/fil=
e1_h4<br>-dumpdir/file1_h5<br>-dumpdir/file2<br>-dumpdir/file2_h1<br>-dumpd=
ir/file2_h2<br>-dumpdir/file2_h3<br>-dumpdir/file2_h4<br>-dumpdir/file2_h5<=
br>
-dumpdir/file3<br>-dumpdir/file3_h1<br>-dumpdir/file3_h2<br>-dumpdir/file3_=
h3<br>-dumpdir/file3_h4<br>-dumpdir/file3_h5<br>-dumpdir/file4<br>-dumpdir/=
file4_h1<br>-dumpdir/file4_h2<br>-dumpdir/file4_h3<br>-dumpdir/file4_h4<br>
-dumpdir/file4_h5<br>-dumpdir/file5<br>-dumpdir/file5_h1<br>-dumpdir/file5_=
h2<br>-dumpdir/file5_h3<br>-dumpdir/file5_h4<br>-dumpdir/file5_h5<br>-dumpd=
ir/file6<br>-dumpdir/file6_h1<br>-dumpdir/file6_h2<br>-dumpdir/file6_h3<br>
-dumpdir/file6_h4<br>-dumpdir/file6_h5<br>-dumpdir/file7<br>-dumpdir/file7_=
h1<br>-dumpdir/file7_h2<br>-dumpdir/file7_h3<br>-dumpdir/file7_h4<br>-dumpd=
ir/file7_h5<br>-dumpdir/file8<br>-dumpdir/file8_h1<br>-dumpdir/file8_h2<br>
-dumpdir/file8_h3<br>-dumpdir/file8_h4<br>-dumpdir/file8_h5<br>-dumpdir/fil=
e9<br>-dumpdir/file9_h1<br>-dumpdir/file9_h2<br>-dumpdir/file9_h3<br>-dumpd=
ir/file9_h4<br>-dumpdir/file9_h5<br>-<br>-restoring from df.level1<br>-Cont=
ents of dump ...<br>
-xfsrestore=A0 -f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simpl=
e) strategy<br>-xfsrestore: searching media for dump<br>-xfsrestore: examin=
ing media file 0<br>-xfsrestore: dump description: <br>-xfsrestore: hostnam=
e: HOSTNAME<br>
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>-xfsrestore: session time: TIME<br>-xfsrestore: level: 1<br>-xfsrestore: =
session label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;st=
ress_tape_media&quot;<br>
-xfsrestore: file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsresto=
re: media ID: ID<br>-xfsrestore: using online session inventory<br>-xfsrest=
ore: searching media for directory dump<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 2 directories and 55 entries processed<br>-xfsrestore: directo=
ry post-processing<br>-xfsrestore: reading non-directory files<br>-xfsresto=
re: table of contents display complete: SECS seconds elapsed<br>-xfsrestore=
: Restore Status: SUCCESS<br>
-<br>-dumpdir/file1<br>-dumpdir/file1_h1<br>-dumpdir/file1_h2<br>-dumpdir/f=
ile1_h3<br>-dumpdir/file1_h4<br>-dumpdir/file1_h5<br>-<br>-restoring from d=
f.level2<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE -t<br>-xfs=
restore: using file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 2<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file2<br>-dumpdir/file2_h1<br>-dumpdir/file2_h2<br>
-dumpdir/file2_h3<br>-dumpdir/file2_h4<br>-dumpdir/file2_h5<br>-<br>-restor=
ing from df.level3<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 3<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file3<br>-dumpdir/file3_h1<br>-dumpdir/file3_h2<br>
-dumpdir/file3_h3<br>-dumpdir/file3_h4<br>-dumpdir/file3_h5<br>-<br>-restor=
ing from df.level4<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 4<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file4<br>-dumpdir/file4_h1<br>-dumpdir/file4_h2<br>
-dumpdir/file4_h3<br>-dumpdir/file4_h4<br>-dumpdir/file4_h5<br>-<br>-restor=
ing from df.level5<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 5<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file5<br>-dumpdir/file5_h1<br>-dumpdir/file5_h2<br>
-dumpdir/file5_h3<br>-dumpdir/file5_h4<br>-dumpdir/file5_h5<br>-<br>-restor=
ing from df.level6<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 6<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file6<br>-dumpdir/file6_h1<br>-dumpdir/file6_h2<br>
-dumpdir/file6_h3<br>-dumpdir/file6_h4<br>-dumpdir/file6_h5<br>-<br>-restor=
ing from df.level7<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 7<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file7<br>-dumpdir/file7_h1<br>-dumpdir/file7_h2<br>
-dumpdir/file7_h3<br>-dumpdir/file7_h4<br>-dumpdir/file7_h5<br>-<br>-restor=
ing from df.level8<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 8<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file8<br>-dumpdir/file8_h1<br>-dumpdir/file8_h2<br>
-dumpdir/file8_h3<br>-dumpdir/file8_h4<br>-dumpdir/file8_h5<br>-<br>-restor=
ing from df.level9<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE =
-t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: =
searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 9<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/file9<br>-dumpdir/file9_h1<br>-dumpdir/file9_h2<br>
-dumpdir/file9_h3<br>-dumpdir/file9_h4<br>-dumpdir/file9_h5<br>-Do the cumu=
lative restores<br>-<br>-restoring from df.level0<br>-Restoring cumumlative=
 from file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore:=
 using file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 0<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-0 file1<br>-0 file1_h1<br>-0 file1_h2<br>-0 file1_h3<br>-0 fi=
le1_h4<br>
-0 file1_h5<br>-0 file2<br>-0 file2_h1<br>-0 file2_h2<br>-0 file2_h3<br>-0 =
file2_h4<br>-0 file2_h5<br>-0 file3<br>-0 file3_h1<br>-0 file3_h2<br>-0 fil=
e3_h3<br>-0 file3_h4<br>-0 file3_h5<br>-0 file4<br>-0 file4_h1<br>-0 file4_=
h2<br>
-0 file4_h3<br>-0 file4_h4<br>-0 file4_h5<br>-0 file5<br>-0 file5_h1<br>-0 =
file5_h2<br>-0 file5_h3<br>-0 file5_h4<br>-0 file5_h5<br>-0 file6<br>-0 fil=
e6_h1<br>-0 file6_h2<br>-0 file6_h3<br>-0 file6_h4<br>-0 file6_h5<br>-0 fil=
e7<br>
-0 file7_h1<br>-0 file7_h2<br>-0 file7_h3<br>-0 file7_h4<br>-0 file7_h5<br>=
-0 file8<br>-0 file8_h1<br>-0 file8_h2<br>-0 file8_h3<br>-0 file8_h4<br>-0 =
file8_h5<br>-0 file9<br>-0 file9_h1<br>-0 file9_h2<br>-0 file9_h3<br>-0 fil=
e9_h4<br>
-0 file9_h5<br>-<br>-restoring from df.level1<br>-Restoring cumumlative fro=
m file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: usi=
ng file dump (drive_simple) strategy<br>-xfsrestore: searching media for du=
mp<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 1<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-0 file2<br>-0 file2_h1<br>-0 file2_h2<br>-=
0 file2_h3<br>-0 file2_h4<br>-0 file2_h5<br>-0 file3<br>-0 file3_h1<br>-0 f=
ile3_h2<br>-0 file3_h3<br>-0 file3_h4<br>-0 file3_h5<br>-0 file4<br>-0 file=
4_h1<br>
-0 file4_h2<br>-0 file4_h3<br>-0 file4_h4<br>-0 file4_h5<br>-0 file5<br>-0 =
file5_h1<br>-0 file5_h2<br>-0 file5_h3<br>-0 file5_h4<br>-0 file5_h5<br>-0 =
file6<br>-0 file6_h1<br>-0 file6_h2<br>-0 file6_h3<br>-0 file6_h4<br>-0 fil=
e6_h5<br>
-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-0 file7_h3<br>-0 file7_h4<br>-0 =
file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 file8_h2<br>-0 file8_h3<br>-0 fil=
e8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file9_h1<br>-0 file9_h2<br>-0 file9_=
h3<br>
-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring from df.level2<br>-Restoring =
cumumlative from file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-=
xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: searchi=
ng media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 2<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-0 file3<br>-0 file3_h1<b=
r>-0 file3_h2<br>-0 file3_h3<br>-0 file3_h4<br>-0 file3_h5<br>-0 file4<br>
-0 file4_h1<br>-0 file4_h2<br>-0 file4_h3<br>-0 file4_h4<br>-0 file4_h5<br>=
-0 file5<br>-0 file5_h1<br>-0 file5_h2<br>-0 file5_h3<br>-0 file5_h4<br>-0 =
file5_h5<br>-0 file6<br>-0 file6_h1<br>-0 file6_h2<br>-0 file6_h3<br>-0 fil=
e6_h4<br>
-0 file6_h5<br>-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-0 file7_h3<br>-0 =
file7_h4<br>-0 file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 file8_h2<br>-0 fil=
e8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file9_h1<br>-0 file9_=
h2<br>
-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring from df.level3=
<br>-Restoring cumumlative from file...<br>-xfsrestore=A0 -f DUMP_FILE -r R=
ESTORE_DIR<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsr=
estore: searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 3<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-0 file=
4<br>
-0 file4_h1<br>-0 file4_h2<br>-0 file4_h3<br>-0 file4_h4<br>-0 file4_h5<br>=
-0 file5<br>-0 file5_h1<br>-0 file5_h2<br>-0 file5_h3<br>-0 file5_h4<br>-0 =
file5_h5<br>-0 file6<br>-0 file6_h1<br>-0 file6_h2<br>-0 file6_h3<br>-0 fil=
e6_h4<br>
-0 file6_h5<br>-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-0 file7_h3<br>-0 =
file7_h4<br>-0 file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 file8_h2<br>-0 fil=
e8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file9_h1<br>-0 file9_=
h2<br>
-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring from df.level4=
<br>-Restoring cumumlative from file...<br>-xfsrestore=A0 -f DUMP_FILE -r R=
ESTORE_DIR<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsr=
estore: searching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 4<br>-xfsrestore: session label: &quot;stress_064&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 d=
irectories and 55 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-0 file5<br>-0 file5_h1<br>-0 file5_h2<br>-0 file5_h3<br>-0 file5_h4<b=
r>-0 file5_h5<br>-0 file6<br>-0 file6_h1<br>-0 file6_h2<br>-0 file6_h3<br>
-0 file6_h4<br>-0 file6_h5<br>-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-0 =
file7_h3<br>-0 file7_h4<br>-0 file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 fil=
e8_h2<br>-0 file8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file9_=
h1<br>
-0 file9_h2<br>-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring=
 from df.level5<br>-Restoring cumumlative from file...<br>-xfsrestore=A0 -f=
 DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump (drive_simple) st=
rategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 5<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-0 file6<br>-0 file6_h1<br>-0 file6_h2<br>-0 file6_h=
3<br>
-0 file6_h4<br>-0 file6_h5<br>-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-0 =
file7_h3<br>-0 file7_h4<br>-0 file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 fil=
e8_h2<br>-0 file8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file9_=
h1<br>
-0 file9_h2<br>-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring=
 from df.level6<br>-Restoring cumumlative from file...<br>-xfsrestore=A0 -f=
 DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump (drive_simple) st=
rategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 6<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-12 file6<br>-12 file6_h1<br>-12 file6_h2<br>-12 fil=
e6_h3<br>
-12 file6_h4<br>-12 file6_h5<br>-0 file7<br>-0 file7_h1<br>-0 file7_h2<br>-=
0 file7_h3<br>-0 file7_h4<br>-0 file7_h5<br>-0 file8<br>-0 file8_h1<br>-0 f=
ile8_h2<br>-0 file8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>-0 file=
9_h1<br>
-0 file9_h2<br>-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>-<br>-restoring=
 from df.level7<br>-Restoring cumumlative from file...<br>-xfsrestore=A0 -f=
 DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump (drive_simple) st=
rategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 7<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-12 file6<br>-12 file6_h1<br>-12 file6_h2<br>-12 fil=
e6_h3<br>
-12 file6_h4<br>-12 file6_h5<br>-12 file7<br>-12 file7_h1<br>-12 file7_h2<b=
r>-12 file7_h3<br>-12 file7_h4<br>-12 file7_h5<br>-0 file8<br>-0 file8_h1<b=
r>-0 file8_h2<br>-0 file8_h3<br>-0 file8_h4<br>-0 file8_h5<br>-0 file9<br>
-0 file9_h1<br>-0 file9_h2<br>-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>=
-<br>-restoring from df.level8<br>-Restoring cumumlative from file...<br>-x=
fsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump (d=
rive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 8<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-12 file6<br>-12 file6_h1<br>-12 file6_h2<br>-12 fil=
e6_h3<br>
-12 file6_h4<br>-12 file6_h5<br>-12 file7<br>-12 file7_h1<br>-12 file7_h2<b=
r>-12 file7_h3<br>-12 file7_h4<br>-12 file7_h5<br>-12 file8<br>-12 file8_h1=
<br>-12 file8_h2<br>-12 file8_h3<br>-12 file8_h4<br>-12 file8_h5<br>-0 file=
9<br>
-0 file9_h1<br>-0 file9_h2<br>-0 file9_h3<br>-0 file9_h4<br>-0 file9_h5<br>=
-<br>-restoring from df.level9<br>-Restoring cumumlative from file...<br>-x=
fsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump (d=
rive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 9<br>-xfsrestore: se=
ssion label: &quot;stress_064&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 55 entries processed<br>-xfsres=
tore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-ls -l re=
store_dir<br>-12 file1<br>-12 file1_h1<br>-12 file1_h2<br>-12 file1_h3<br>
-12 file1_h4<br>-12 file1_h5<br>-12 file2<br>-12 file2_h1<br>-12 file2_h2<b=
r>-12 file2_h3<br>-12 file2_h4<br>-12 file2_h5<br>-12 file3<br>-12 file3_h1=
<br>-12 file3_h2<br>-12 file3_h3<br>-12 file3_h4<br>-12 file3_h5<br>-12 fil=
e4<br>
-12 file4_h1<br>-12 file4_h2<br>-12 file4_h3<br>-12 file4_h4<br>-12 file4_h=
5<br>-12 file5<br>-12 file5_h1<br>-12 file5_h2<br>-12 file5_h3<br>-12 file5=
_h4<br>-12 file5_h5<br>-12 file6<br>-12 file6_h1<br>-12 file6_h2<br>-12 fil=
e6_h3<br>
-12 file6_h4<br>-12 file6_h5<br>-12 file7<br>-12 file7_h1<br>-12 file7_h2<b=
r>-12 file7_h3<br>-12 file7_h4<br>-12 file7_h5<br>-12 file8<br>-12 file8_h1=
<br>-12 file8_h2<br>-12 file8_h3<br>-12 file8_h4<br>-12 file8_h5<br>-12 fil=
e9<br>
-12 file9_h1<br>-12 file9_h2<br>-12 file9_h3<br>-12 file9_h4<br>-12 file9_h=
5<br>+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=
=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=
=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>
+failed to unmount /dev/sda6<br>+_check_xfs_filesystem: filesystem on /dev/=
sda6 has dirty log (see 064.full)<br>+_check_xfs_filesystem: filesystem on =
/dev/sda6 is inconsistent (c) (see 064.full)<br>+_check_xfs_filesystem: fil=
esystem on /dev/sda6 is inconsistent (r) (see 064.full)<br>
065=A0=A0=A0 =A0[failed, exit status 1] - output mismatch (see 065.out.bad)=
<br>--- 065.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 065.out=
.bad=A0=A0=A0 2011-06-15 14:43:50.945421073 +0530<br>@@ -1,832 +1,13 @@<br>=
=A0QA output created by 065<br>
-Do the incremental dumps<br>-Listing of what files we have at level 0:<br>=
-dumpdir/addeddir1 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir2 XXX drwxr-xr-x =
0,0<br>-dumpdir/addeddir3 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir3/addedfil=
e4 5 -rw-r--r-- 0,0<br>
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir4/addedfile5 5 -r=
w-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile1=
 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile2 5 -rw-r--r-- 0,0<br>-dumpdir/added=
file3 5 -rw-r--r-- 0,0<br>
-Dumping to file...<br>-xfsdump=A0 -l0 -f DUMP_FILE -M stress_tape_media -L=
 stress_065 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT<br>-xfsdump: dump date:=
 DATE<br>
-xfsdump: session id: ID<br>-xfsdump: session label: &quot;stress_065&quot;=
<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction comp=
lete<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: /var/xfsdump/=
inventory created<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we have at level 1:<br>-dumpdir/addeddir1 XXX drwxr-xr-x 0,0<br>
-dumpdir/addeddir4 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir4/addedfile5 5 -r=
w-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile1=
 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>-Dumping to fi=
le...<br>
-xfsdump=A0 -l1 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT=
<br>-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 1 =
incremental dump of HOSTNAME:SCRATCH_MNT based on level 0 dump begun DATE<b=
r>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we have at level 2:<br>-dumpdir/addeddir2 XXX drwxr-xr-x 0,0<br>
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6/addedfile4 5 -r=
w-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile2=
 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>-Dumping to fi=
le...<br>
-xfsdump=A0 -l2 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT=
<br>-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 2 =
incremental dump of HOSTNAME:SCRATCH_MNT based on level 1 dump begun DATE<b=
r>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we have at level 3:<br>-dumpdir/addeddir2 XXX drwxr-xr-x 0,0<br>
-dumpdir/addeddir6 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6/addedfile4 5 -r=
w-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile2=
 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>-dumpdir/linkf=
ile0 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile2 5 -rw-r--r-- 0,=
0<br>-dumpdir/linkfile64 5 -rw-r--r-- 0,0<br>-Dumping to file...<br>-xfsdum=
p=A0 -l3 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATCH_MNT<br>-xf=
sdump: using file dump (drive_simple) strategy<br>
-xfsdump: level 3 incremental dump of HOSTNAME:SCRATCH_MNT based on level 2=
 dump begun DATE<br>-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<b=
r>-xfsdump: session label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;=
PHASES&gt;<br>
-xfsdump: ino map construction complete<br>-xfsdump: estimated dump size: N=
UM bytes<br>-xfsdump: creating dump session media file 0 (media 0, file 0)<=
br>-xfsdump: dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: =
dumping non-directory files<br>
-xfsdump: ending media file<br>-xfsdump: media file size NUM bytes<br>-xfsd=
ump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete: SECS=
 seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what file=
s we have at level 4:<br>
-dumpdir/addeddir2 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6 XXX drwxr-xr-x =
0,0<br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r-=
-r-- 0,0<br>-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile2 5 -=
rw-r--r-- 0,0<br>
-Dumping to file...<br>-xfsdump=A0 -l4 -f DUMP_FILE -M stress_tape_media -L=
 stress_065 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 4 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 3 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we have at level 5:<br>-dumpdir/addedfile6 5 -rw-r--r-- 0,0<br>-dump=
dir/linkfile6_1 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile6_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_3 5 -rw-r--r-- =
0,0<br>-Dumping to file...<br>-xfsdump=A0 -l5 -f DUMP_FILE -M stress_tape_m=
edia -L stress_065 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) =
strategy<br>
-xfsdump: level 5 incremental dump of HOSTNAME:SCRATCH_MNT based on level 4=
 dump begun DATE<br>-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<b=
r>-xfsdump: session label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;=
PHASES&gt;<br>
-xfsdump: ino map construction complete<br>-xfsdump: estimated dump size: N=
UM bytes<br>-xfsdump: creating dump session media file 0 (media 0, file 0)<=
br>-xfsdump: dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: =
dumping non-directory files<br>
-xfsdump: ending media file<br>-xfsdump: media file size NUM bytes<br>-xfsd=
ump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete: SECS=
 seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what file=
s we have at level 6:<br>
-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_1 5 -rw-r-=
-r-- 0,0<br>-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_=
mv_3 5 -rw-r--r-- 0,0<br>-Dumping to file...<br>-xfsdump=A0 -l6 -f DUMP_FIL=
E -M stress_tape_media -L stress_065 SCRATCH_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 6 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 5 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_065&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Listing of what files we have at level 7:<br>-dumpdir/addedfile6_mv 5 -rw-=
r--r-- 0,0<br>-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile=
6_mv_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0<br>
-Dumping to file...<br>-xfsdump=A0 -l7 -f DUMP_FILE -M stress_tape_media -L=
 stress_065 SCRATCH_MNT<br>-xfsdump: using file dump (drive_simple) strateg=
y<br>-xfsdump: level 7 incremental dump of HOSTNAME:SCRATCH_MNT based on le=
vel 6 dump begun DATE<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_065&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: creating dump session media file 0 (media 0, file 0)<br>-xfsdump:=
 dumping ino map<br>-xfsdump: dumping directories<br>-xfsdump: dumping non-=
directory files<br>-xfsdump: ending media file<br>-xfsdump: media file size=
 NUM bytes<br>
-xfsdump: dump size (non-dir files) : NUM bytes<br>-xfsdump: dump complete:=
 SECS seconds elapsed<br>-xfsdump: Dump Status: SUCCESS<br>-Listing of what=
 files we have at level 8:<br>-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile6_mv_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_2 5 -rw-r=
--r-- 0,0<br>-dumpdir/linkfile6_mv_3 5 -rw-r--r-- 0,0<br>-Dumping to file..=
.<br>-xfsdump=A0 -l8 -f DUMP_FILE -M stress_tape_media -L stress_065 SCRATC=
H_MNT<br>
-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: level 8 incr=
emental dump of HOSTNAME:SCRATCH_MNT based on level 7 dump begun DATE<br>-x=
fsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session la=
bel: &quot;stress_065&quot;<br>
-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdump: ino map construction complete=
<br>-xfsdump: estimated dump size: NUM bytes<br>-xfsdump: creating dump ses=
sion media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdum=
p: dumping directories<br>
-xfsdump: dumping non-directory files<br>-xfsdump: ending media file<br>-xf=
sdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) : N=
UM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: Dump=
 Status: SUCCESS<br>
-Look at what files are contained in the inc. dump<br>-<br>-restoring from =
df.level0<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE -t<br>-xf=
srestore: using file dump (drive_simple) strategy<br>-xfsrestore: searching=
 media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 0<br>-xfsrestore: session label: &quot;stress_065&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 6 d=
irectories and 11 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/addeddir3/addedfile4<br>-dumpdir/addeddir4/addedfile5<=
br>
-dumpdir/addedfile0<br>-dumpdir/addedfile1<br>-dumpdir/addedfile2<br>-dumpd=
ir/addedfile3<br>-<br>-restoring from df.level1<br>-Contents of dump ...<br=
>-xfsrestore=A0 -f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simp=
le) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 1<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 6 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-<br>-restoring from df.level2<br>-Contents of dump ...<br>
-xfsrestore=A0 -f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simpl=
e) strategy<br>-xfsrestore: searching media for dump<br>-xfsrestore: examin=
ing media file 0<br>-xfsrestore: dump description: <br>-xfsrestore: hostnam=
e: HOSTNAME<br>
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>-xfsrestore: session time: TIME<br>-xfsrestore: level: 2<br>-xfsrestore: =
session label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;st=
ress_tape_media&quot;<br>
-xfsrestore: file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsresto=
re: media ID: ID<br>-xfsrestore: using online session inventory<br>-xfsrest=
ore: searching media for directory dump<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 4 directories and 7 entries processed<br>-xfsrestore: director=
y post-processing<br>-xfsrestore: reading non-directory files<br>-xfsrestor=
e: table of contents display complete: SECS seconds elapsed<br>-xfsrestore:=
 Restore Status: SUCCESS<br>
-<br>-dumpdir/addeddir6/addedfile4<br>-dumpdir/addedfile2<br>-<br>-restorin=
g from df.level3<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE -t=
<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: se=
arching media for dump<br>
-xfsrestore: examining media file 0<br>-xfsrestore: dump description: <br>-=
xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br>=
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>
-xfsrestore: level: 3<br>-xfsrestore: session label: &quot;stress_065&quot;=
<br>-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore:=
 file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID=
: ID<br>
-xfsrestore: using online session inventory<br>-xfsrestore: searching media=
 for directory dump<br>-xfsrestore: reading directories<br>-xfsrestore: 3 d=
irectories and 11 entries processed<br>-xfsrestore: directory post-processi=
ng<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/addeddir6/addedfile4<br>-dumpdir/addedfile0<br>-dumpdi=
r/addedfile2<br>
-dumpdir/linkfile0<br>-dumpdir/linkfile0_1<br>-dumpdir/linkfile2<br>-dumpdi=
r/linkfile64<br>-<br>-restoring from df.level4<br>-Contents of dump ...<br>=
-xfsrestore=A0 -f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simpl=
e) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 4<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 3 directories and 7 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: reading non-directory files<br>-xfsrestore: table of contents =
display complete: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCC=
ESS<br>-<br>-dumpdir/addedfile0<br>-dumpdir/linkfile0_1<br>-dumpdir/linkfil=
e2<br>
-<br>-restoring from df.level5<br>-Contents of dump ...<br>-xfsrestore=A0 -=
f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simple) strategy<br>-=
xfsrestore: searching media for dump<br>-xfsrestore: examining media file 0=
<br>
-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>-xfsr=
estore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<br>-xf=
srestore: session time: TIME<br>-xfsrestore: level: 5<br>-xfsrestore: sessi=
on label: &quot;stress_065&quot;<br>
-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore: fil=
e system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID: ID=
<br>-xfsrestore: using online session inventory<br>-xfsrestore: searching m=
edia for directory dump<br>
-xfsrestore: reading directories<br>-xfsrestore: 2 directories and 5 entrie=
s processed<br>-xfsrestore: directory post-processing<br>-xfsrestore: readi=
ng non-directory files<br>-xfsrestore: table of contents display complete: =
SECS seconds elapsed<br>
-xfsrestore: Restore Status: SUCCESS<br>-<br>-dumpdir/addedfile6<br>-dumpdi=
r/linkfile6_1<br>-dumpdir/linkfile6_2<br>-dumpdir/linkfile6_3<br>-<br>-rest=
oring from df.level6<br>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FIL=
E -t<br>
-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: search=
ing media for dump<br>-xfsrestore: examining media file 0<br>-xfsrestore: d=
ump description: <br>-xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount =
point: SCRATCH_MNT<br>
-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>-xfs=
restore: level: 6<br>-xfsrestore: session label: &quot;stress_065&quot;<br>=
-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore: fil=
e system ID: ID<br>
-xfsrestore: session id: ID<br>-xfsrestore: media ID: ID<br>-xfsrestore: us=
ing online session inventory<br>-xfsrestore: searching media for directory =
dump<br>-xfsrestore: reading directories<br>-xfsrestore: 2 directories and =
5 entries processed<br>
-xfsrestore: directory post-processing<br>-xfsrestore: reading non-director=
y files<br>-xfsrestore: table of contents display complete: SECS seconds el=
apsed<br>-xfsrestore: Restore Status: SUCCESS<br>-<br>-dumpdir/addedfile6_m=
v<br>
-dumpdir/linkfile6_mv_1<br>-dumpdir/linkfile6_mv_2<br>-dumpdir/linkfile6_mv=
_3<br>-<br>-restoring from df.level7<br>-Contents of dump ...<br>-xfsrestor=
e=A0 -f DUMP_FILE -t<br>-xfsrestore: using file dump (drive_simple) strateg=
y<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 7<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 0 directories and 0 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: table of contents display complete: SECS seconds elapsed<br>-x=
fsrestore: Restore Status: SUCCESS<br>-<br>-<br>-restoring from df.level8<b=
r>-Contents of dump ...<br>-xfsrestore=A0 -f DUMP_FILE -t<br>-xfsrestore: u=
sing file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 8<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 0 directories and 0 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: table of contents display complete: SECS seconds elapsed<br>-x=
fsrestore: Restore Status: SUCCESS<br>-<br>-Do the cumulative restores<br>-=
<br>-restoring from df.level0<br>-Restoring cumumlative from file...<br>
-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump =
(drive_simple) strategy<br>-xfsrestore: searching media for dump<br>-xfsres=
tore: examining media file 0<br>-xfsrestore: dump description: <br>-xfsrest=
ore: hostname: HOSTNAME<br>
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>-xfsrestore: session time: TIME<br>-xfsrestore: level: 0<br>-xfsrestore: =
session label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;st=
ress_tape_media&quot;<br>
-xfsrestore: file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsresto=
re: media ID: ID<br>-xfsrestore: using online session inventory<br>-xfsrest=
ore: searching media for directory dump<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 6 directories and 11 entries processed<br>-xfsrestore: directo=
ry post-processing<br>-xfsrestore: restoring non-directory files<br>-xfsres=
tore: restore complete: SECS seconds elapsed<br>-xfsrestore: Restore Status=
: SUCCESS<br>
-list restore_dir<br>-dumpdir/addeddir1 XXX drwxr-xr-x 0,0<br>-dumpdir/adde=
ddir2 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir3 XXX drwxr-xr-x 0,0<br>-dumpd=
ir/addeddir3/addedfile4 5 -rw-r--r-- 0,0<br>-dumpdir/addeddir4 XXX drwxr-xr=
-x 0,0<br>
-dumpdir/addeddir4/addedfile5 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw=
-r--r-- 0,0<br>-dumpdir/addedfile1 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile2 =
5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>-<br>-restoring=
 from df.level1<br>
-Restoring cumumlative from file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTO=
RE_DIR<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsresto=
re: searching media for dump<br>-xfsrestore: examining media file 0<br>-xfs=
restore: dump description: <br>
-xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br=
>-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>-xf=
srestore: level: 1<br>-xfsrestore: session label: &quot;stress_065&quot;<br=
>
-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore: fil=
e system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID: ID=
<br>-xfsrestore: using online session inventory<br>-xfsrestore: searching m=
edia for directory dump<br>
-xfsrestore: reading directories<br>-xfsrestore: 2 directories and 6 entrie=
s processed<br>-xfsrestore: directory post-processing<br>-xfsrestore: resto=
ring non-directory files<br>-xfsrestore: restore complete: SECS seconds ela=
psed<br>
-xfsrestore: Restore Status: SUCCESS<br>-list restore_dir<br>-dumpdir/added=
dir1 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir4 XXX drwxr-xr-x 0,0<br>-dumpdi=
r/addeddir4/addedfile5 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw-r--r--=
 0,0<br>
-dumpdir/addedfile1 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,=
0<br>-<br>-restoring from df.level2<br>-Restoring cumumlative from file...<=
br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file du=
mp (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 2<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 4 directories and 7 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-list res=
tore_dir<br>-dumpdir/addeddir2 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6 XXX=
 drwxr-xr-x 0,0<br>
-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile0 5 -rw=
-r--r-- 0,0<br>-dumpdir/addedfile2 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 =
5 -rw-r--r-- 0,0<br>-<br>-restoring from df.level3<br>-Restoring cumumlativ=
e from file...<br>
-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file dump =
(drive_simple) strategy<br>-xfsrestore: searching media for dump<br>-xfsres=
tore: examining media file 0<br>-xfsrestore: dump description: <br>-xfsrest=
ore: hostname: HOSTNAME<br>
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>-xfsrestore: session time: TIME<br>-xfsrestore: level: 3<br>-xfsrestore: =
session label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;st=
ress_tape_media&quot;<br>
-xfsrestore: file system ID: ID<br>-xfsrestore: session id: ID<br>-xfsresto=
re: media ID: ID<br>-xfsrestore: using online session inventory<br>-xfsrest=
ore: searching media for directory dump<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 3 directories and 11 entries processed<br>-xfsrestore: directo=
ry post-processing<br>-xfsrestore: restoring non-directory files<br>-xfsres=
tore: restore complete: SECS seconds elapsed<br>-xfsrestore: Restore Status=
: SUCCESS<br>
-list restore_dir<br>-dumpdir/addeddir2 XXX drwxr-xr-x 0,0<br>-dumpdir/adde=
ddir6 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6/addedfile4 5 -rw-r--r-- 0,0<=
br>-dumpdir/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile2 5 -rw-r--r--=
 0,0<br>
-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile0 5 -rw-r--r-- 0,0=
<br>-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile2 5 -rw-r--r-=
- 0,0<br>-dumpdir/linkfile64 5 -rw-r--r-- 0,0<br>-<br>-restoring from df.le=
vel4<br>
-Restoring cumumlative from file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTO=
RE_DIR<br>-xfsrestore: using file dump (drive_simple) strategy<br>-xfsresto=
re: searching media for dump<br>-xfsrestore: examining media file 0<br>-xfs=
restore: dump description: <br>
-xfsrestore: hostname: HOSTNAME<br>-xfsrestore: mount point: SCRATCH_MNT<br=
>-xfsrestore: volume: SCRATCH_DEV<br>-xfsrestore: session time: TIME<br>-xf=
srestore: level: 4<br>-xfsrestore: session label: &quot;stress_065&quot;<br=
>
-xfsrestore: media label: &quot;stress_tape_media&quot;<br>-xfsrestore: fil=
e system ID: ID<br>-xfsrestore: session id: ID<br>-xfsrestore: media ID: ID=
<br>-xfsrestore: using online session inventory<br>-xfsrestore: searching m=
edia for directory dump<br>
-xfsrestore: reading directories<br>-xfsrestore: 3 directories and 7 entrie=
s processed<br>-xfsrestore: directory post-processing<br>-xfsrestore: resto=
ring non-directory files<br>-xfsrestore: restore complete: SECS seconds ela=
psed<br>
-xfsrestore: Restore Status: SUCCESS<br>-list restore_dir<br>-dumpdir/added=
dir2 XXX drwxr-xr-x 0,0<br>-dumpdir/addeddir6 XXX drwxr-xr-x 0,0<br>-dumpdi=
r/addedfile0 5 -rw-r--r-- 0,0<br>-dumpdir/addedfile3 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile0_1 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile2 5 -rw-r--r-- 0,=
0<br>-<br>-restoring from df.level5<br>-Restoring cumumlative from file...<=
br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file du=
mp (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 5<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 5 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-list res=
tore_dir<br>-dumpdir/addedfile6 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_1 5 =
-rw-r--r-- 0,0<br>
-dumpdir/linkfile6_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_3 5 -rw-r--r-- =
0,0<br>-<br>-restoring from df.level6<br>-Restoring cumumlative from file..=
.<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using file =
dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 6<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 2 directories and 5 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-list res=
tore_dir<br>-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_m=
v_1 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_3 5 -rw-r=
--r-- 0,0<br>-<br>-restoring from df.level7<br>-Restoring cumumlative from =
file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using=
 file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 7<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 0 directories and 0 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-list res=
tore_dir<br>-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_m=
v_1 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_3 5 -rw-r=
--r-- 0,0<br>-<br>-restoring from df.level8<br>-Restoring cumumlative from =
file...<br>-xfsrestore=A0 -f DUMP_FILE -r RESTORE_DIR<br>-xfsrestore: using=
 file dump (drive_simple) strategy<br>
-xfsrestore: searching media for dump<br>-xfsrestore: examining media file =
0<br>-xfsrestore: dump description: <br>-xfsrestore: hostname: HOSTNAME<br>=
-xfsrestore: mount point: SCRATCH_MNT<br>-xfsrestore: volume: SCRATCH_DEV<b=
r>
-xfsrestore: session time: TIME<br>-xfsrestore: level: 8<br>-xfsrestore: se=
ssion label: &quot;stress_065&quot;<br>-xfsrestore: media label: &quot;stre=
ss_tape_media&quot;<br>-xfsrestore: file system ID: ID<br>-xfsrestore: sess=
ion id: ID<br>
-xfsrestore: media ID: ID<br>-xfsrestore: using online session inventory<br=
>-xfsrestore: searching media for directory dump<br>-xfsrestore: reading di=
rectories<br>-xfsrestore: 0 directories and 0 entries processed<br>-xfsrest=
ore: directory post-processing<br>
-xfsrestore: restoring non-directory files<br>-xfsrestore: restore complete=
: SECS seconds elapsed<br>-xfsrestore: Restore Status: SUCCESS<br>-list res=
tore_dir<br>-dumpdir/addedfile6_mv 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_m=
v_1 5 -rw-r--r-- 0,0<br>
-dumpdir/linkfile6_mv_2 5 -rw-r--r-- 0,0<br>-dumpdir/linkfile6_mv_3 5 -rw-r=
--r-- 0,0<br>-<br>-Do the ls comparison<br>-Comparing ls of FS with restore=
d FS at level 0<br>-Files TMP.ls.0 and TMP.restorals.0 are identical<br>
-<br>-Comparing ls of FS with restored FS at level 1<br>-Files TMP.ls.1 and=
 TMP.restorals.1 are identical<br>-<br>-Comparing ls of FS with restored FS=
 at level 2<br>-Files TMP.ls.2 and TMP.restorals.2 are identical<br>-<br>
-Comparing ls of FS with restored FS at level 3<br>-Files TMP.ls.3 and TMP.=
restorals.3 are identical<br>-<br>-Comparing ls of FS with restored FS at l=
evel 4<br>-Files TMP.ls.4 and TMP.restorals.4 are identical<br>-<br>-Compar=
ing ls of FS with restored FS at level 5<br>
-Files TMP.ls.5 and TMP.restorals.5 are identical<br>-<br>-Comparing ls of =
FS with restored FS at level 6<br>-Files TMP.ls.6 and TMP.restorals.6 are i=
dentical<br>-<br>-Comparing ls of FS with restored FS at level 7<br>-Files =
TMP.ls.7 and TMP.restorals.7 are identical<br>
-<br>-Comparing ls of FS with restored FS at level 8<br>-Files TMP.ls.8 and=
 TMP.restorals.8 are identical<br>-<br>+mount: /dev/sda6 already mounted or=
 /home/manish/Projects/xfstests/sdb4 busy<br>+mount: according to mtab, /de=
v/sda6 is already mounted on /home/manish/Projects/xfstests/sdb4<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+umount: =
/home/manish/Projects/xfstests/sdb4: device is busy.<br>
+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<=
br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br=
>+failed to unmount /dev/sda6<br>+_check_xfs_filesystem: filesystem on /dev=
/sda6 has dirty log (see 065.full)<br>
+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent (c) (see 06=
5.full)<br>+_check_xfs_filesystem: filesystem on /dev/sda6 is inconsistent =
(r) (see 065.full)<br>066 1s ... [failed, exit status 1] - output mismatch =
(see 066.out.bad)<br>
--- 066.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 066.out.bad=
=A0=A0=A0 2011-06-15 14:43:51.626412560 +0530<br>@@ -1,40 +1,5 @@<br>=A0QA =
output created by 066<br>-dd a largefile at offset 4294967297<br>-10+0 reco=
rds in<br>
-10+0 records out<br>-ls dumpdir/largefile<br>-22 largefile<br>-Dumping to =
file...<br>-xfsdump=A0 -f DUMP_FILE -M stress_tape_media -L stress_066 SCRA=
TCH_MNT<br>-xfsdump: using file dump (drive_simple) strategy<br>-xfsdump: l=
evel 0 dump of HOSTNAME:SCRATCH_MNT<br>
-xfsdump: dump date: DATE<br>-xfsdump: session id: ID<br>-xfsdump: session =
label: &quot;stress_066&quot;<br>-xfsdump: ino map &lt;PHASES&gt;<br>-xfsdu=
mp: ino map construction complete<br>-xfsdump: estimated dump size: NUM byt=
es<br>
-xfsdump: /var/xfsdump/inventory created<br>-xfsdump: creating dump session=
 media file 0 (media 0, file 0)<br>-xfsdump: dumping ino map<br>-xfsdump: d=
umping directories<br>-xfsdump: dumping non-directory files<br>-xfsdump: en=
ding media file<br>
-xfsdump: media file size NUM bytes<br>-xfsdump: dump size (non-dir files) =
: NUM bytes<br>-xfsdump: dump complete: SECS seconds elapsed<br>-xfsdump: D=
ump Status: SUCCESS<br>-Restoring from file...<br>-xfsrestore=A0 -f DUMP_FI=
LE=A0 -L stress_066 RESTORE_DIR<br>
-xfsrestore: using file dump (drive_simple) strategy<br>-xfsrestore: using =
online session inventory<br>-xfsrestore: searching media for directory dump=
<br>-xfsrestore: examining media file 0<br>-xfsrestore: reading directories=
<br>
-xfsrestore: 2 directories and 2 entries processed<br>-xfsrestore: director=
y post-processing<br>-xfsrestore: restoring non-directory files<br>-xfsrest=
ore: restore complete: SECS seconds elapsed<br>-xfsrestore: Restore Status:=
 SUCCESS<br>
-ls restoredir/largefile<br>-22 largefile<br>+umount: /home/manish/Projects=
/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=A0=A0=A0=A0 (In some cases us=
eful info about processes that use<br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device =
is found by lsof(8) or fuser(1))<br>
+failed to unmount /dev/sda6<br>067 1s ... [failed, exit status 1] - output=
 mismatch (see 067.out.bad)<br>--- 067.out=A0=A0=A0 2011-05-11 22:32:24.000=
000000 +0530<br>+++ 067.out.bad=A0=A0=A0 2011-06-15 14:43:52.403402846 +053=
0<br>@@ -1,166 +1,5 @@<br>
=A0QA output created by 067<br>-<br>-=3D=3D=3D Test out large ACLs=A0 =3D=
=3D=3D<br>-try 20 aces for access acl<br>-# file: largeacldir<br>-# owner: =
0<br>-# group: 0<br>-user::rwx<br>-user:1:rwx<br>-user:2:rwx<br>-user:3:rwx=
<br>-user:4:rwx<br>
-user:5:rwx<br>-user:6:rwx<br>-user:7:rwx<br>-user:8:rwx<br>-user:9:rwx<br>=
-user:10:rwx<br>-user:11:rwx<br>-user:12:rwx<br>-user:13:rwx<br>-user:14:rw=
x<br>-user:15:rwx<br>-user:16:rwx<br>-group::rwx<br>-mask::rwx<br>-other::r=
wx<br>
-<br>-try 20 aces for default acl<br>-# file: largeacldir<br>-# owner: 0<br=
>-# group: 0<br>-user::rwx<br>-user:1:rwx<br>-user:2:rwx<br>-user:3:rwx<br>=
-user:4:rwx<br>-user:5:rwx<br>-user:6:rwx<br>-user:7:rwx<br>-user:8:rwx<br>
-user:9:rwx<br>-user:10:rwx<br>-user:11:rwx<br>-user:12:rwx<br>-user:13:rwx=
<br>-user:14:rwx<br>-user:15:rwx<br>-user:16:rwx<br>-group::rwx<br>-mask::r=
wx<br>-other::rwx<br>-default:user::rwx<br>-default:user:1:rwx<br>-default:=
user:2:rwx<br>
-default:user:3:rwx<br>-default:user:4:rwx<br>-default:user:5:rwx<br>-defau=
lt:user:6:rwx<br>-default:user:7:rwx<br>-default:user:8:rwx<br>-default:use=
r:9:rwx<br>-default:user:10:rwx<br>-default:user:11:rwx<br>-default:user:12=
:rwx<br>
-default:user:13:rwx<br>-default:user:14:rwx<br>-default:user:15:rwx<br>-de=
fault:user:16:rwx<br>-default:group::rwx<br>-default:mask::rwx<br>-default:=
other::rwx<br>-<br>-try 21 aces for access acl<br>-# file: largeacldir<br>
-# owner: 0<br>-# group: 0<br>-user::rwx<br>-user:1:rwx<br>-user:2:rwx<br>-=
user:3:rwx<br>-user:4:rwx<br>-user:5:rwx<br>-user:6:rwx<br>-user:7:rwx<br>-=
user:8:rwx<br>-user:9:rwx<br>-user:10:rwx<br>-user:11:rwx<br>-user:12:rwx<b=
r>
-user:13:rwx<br>-user:14:rwx<br>-user:15:rwx<br>-user:16:rwx<br>-user:17:rw=
x<br>-group::rwx<br>-mask::rwx<br>-other::rwx<br>-default:user::rwx<br>-def=
ault:user:1:rwx<br>-default:user:2:rwx<br>-default:user:3:rwx<br>-default:u=
ser:4:rwx<br>
-default:user:5:rwx<br>-default:user:6:rwx<br>-default:user:7:rwx<br>-defau=
lt:user:8:rwx<br>-default:user:9:rwx<br>-default:user:10:rwx<br>-default:us=
er:11:rwx<br>-default:user:12:rwx<br>-default:user:13:rwx<br>-default:user:=
14:rwx<br>
-default:user:15:rwx<br>-default:user:16:rwx<br>-default:group::rwx<br>-def=
ault:mask::rwx<br>-default:other::rwx<br>-<br>-try 21 aces for default acl<=
br>-# file: largeacldir<br>-# owner: 0<br>-# group: 0<br>-user::rwx<br>
-user:1:rwx<br>-user:2:rwx<br>-user:3:rwx<br>-user:4:rwx<br>-user:5:rwx<br>=
-user:6:rwx<br>-user:7:rwx<br>-user:8:rwx<br>-user:9:rwx<br>-user:10:rwx<br=
>-user:11:rwx<br>-user:12:rwx<br>-user:13:rwx<br>-user:14:rwx<br>-user:15:r=
wx<br>
-user:16:rwx<br>-user:17:rwx<br>-group::rwx<br>-mask::rwx<br>-other::rwx<br=
>-default:user::rwx<br>-default:user:1:rwx<br>-default:user:2:rwx<br>-defau=
lt:user:3:rwx<br>-default:user:4:rwx<br>-default:user:5:rwx<br>-default:use=
r:6:rwx<br>
-default:user:7:rwx<br>-default:user:8:rwx<br>-default:user:9:rwx<br>-defau=
lt:user:10:rwx<br>-default:user:11:rwx<br>-default:user:12:rwx<br>-default:=
user:13:rwx<br>-default:user:14:rwx<br>-default:user:15:rwx<br>-default:use=
r:16:rwx<br>
-default:user:17:rwx<br>-default:group::rwx<br>-default:mask::rwx<br>-defau=
lt:other::rwx<br>-<br>+umount: /home/manish/Projects/xfstests/sdb4: device =
is busy.<br>+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about process=
es that use<br>
+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+f=
ailed to unmount /dev/sda6<br>068 94s ... - output mismatch (see 068.out.ba=
d)<br>--- 068.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 068.o=
ut.bad=A0=A0=A0 2011-06-15 14:43:53.141393620 +0530<br>
@@ -1,43 +1,5 @@<br>=A0QA output created by 068<br>-*** init FS<br>-<br>-**=
* iteration: 0<br>-*** freezing $SCRATCH_MNT<br>-*** thawing=A0 $SCRATCH_MN=
T<br>-<br>-*** iteration: 1<br>-*** freezing $SCRATCH_MNT<br>-*** thawing=
=A0 $SCRATCH_MNT<br>
-<br>-*** iteration: 2<br>-*** freezing $SCRATCH_MNT<br>-*** thawing=A0 $SC=
RATCH_MNT<br>-<br>-*** iteration: 3<br>-*** freezing $SCRATCH_MNT<br>-*** t=
hawing=A0 $SCRATCH_MNT<br>-<br>-*** iteration: 4<br>-*** freezing $SCRATCH_=
MNT<br>
-*** thawing=A0 $SCRATCH_MNT<br>-<br>-*** iteration: 5<br>-*** freezing $SC=
RATCH_MNT<br>-*** thawing=A0 $SCRATCH_MNT<br>-<br>-*** iteration: 6<br>-***=
 freezing $SCRATCH_MNT<br>-*** thawing=A0 $SCRATCH_MNT<br>-<br>-*** iterati=
on: 7<br>
-*** freezing $SCRATCH_MNT<br>-*** thawing=A0 $SCRATCH_MNT<br>-<br>-*** ite=
ration: 8<br>-*** freezing $SCRATCH_MNT<br>-*** thawing=A0 $SCRATCH_MNT<br>=
-<br>-*** iteration: 9<br>-*** freezing $SCRATCH_MNT<br>-*** thawing=A0 $SC=
RATCH_MNT<br>
-<br>+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=
=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=
=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+fa=
iled to unmount /dev/sda6<br>
069 9s ... - output mismatch (see 069.out.bad)<br>--- 069.out=A0=A0=A0 2011=
-05-11 22:32:24.000000000 +0530<br>+++ 069.out.bad=A0=A0=A0 2011-06-15 14:4=
3:53.905384068 +0530<br>@@ -1,9 +1,5 @@<br>=A0QA output created by 069<br>-=
*** mkfs<br>
-*** mount FS<br>-*** checking file with 1 integers<br>-*** checking file w=
ith 20 integers<br>-*** checking file with 300 integers<br>-*** checking fi=
le with 40000 integers<br>-*** checking file with 3000000 integers<br>-*** =
checking file with 12345 integers<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+failed t=
o unmount /dev/sda6<br>070 19s ... 22s<br>
072 1s ... [failed, exit status 1] - output mismatch (see 072.out.bad)<br>-=
-- 072.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 072.out.bad=
=A0=A0=A0 2011-06-15 14:44:17.914083917 +0530<br>@@ -1,2 +1,5 @@<br>=A0QA o=
utput created by 072<br>
-Silence is golden<br>+umount: /home/manish/Projects/xfstests/sdb4: device =
is busy.<br>+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about process=
es that use<br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or =
fuser(1))<br>+failed to unmount /dev/sda6<br>
073 34s ... [failed, exit status 1] - output mismatch (see 073.out.bad)<br>=
--- 073.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 073.out.bad=
=A0=A0=A0 2011-06-15 14:44:19.447064754 +0530<br>@@ -1,73 +1,5 @@<br>=A0QA =
output created by 073<br>
-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX blks<br>-data=A0=A0=
=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-naming=A0=A0 =3DVERN=
 bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX blocks=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-<br>-=3D=3D=
=3D populating scratch device<br>-1000+0 records in<br>-1000+0 records out<=
br>-<br>-=3D=3D=3D copying scratch device to single target<br>-Creating fil=
e &lt;FSIMAGE1&gt;<br>
- 0%=A0 ... 10%=A0 ... 20%=A0 ... 30%=A0 ... 40%=A0 ... 50%=A0 ... 60%=A0 .=
.. 70%=A0 ... 80%=A0 ... 90%=A0 ... 100%<br>-<br>-All copies completed.<br>=
-checking new image<br>-mounting new image on loopback<br>-comparing new im=
age files to old<br>
-comparing new image directories to old<br>-comparing new image geometry to=
 old<br>-unmounting and removing new image<br>-<br>-=3D=3D=3D copying scrat=
ch device to single target, duplicate UUID<br>-Creating file &lt;FSIMAGE1&g=
t;<br>
- 0%=A0 ... 10%=A0 ... 20%=A0 ... 30%=A0 ... 40%=A0 ... 50%=A0 ... 60%=A0 .=
.. 70%=A0 ... 80%=A0 ... 90%=A0 ... 100%<br>-<br>-All copies completed.<br>=
-checking new image<br>-mounting new image on loopback<br>-retrying mount w=
ith nouuid option<br>
-comparing new image files to old<br>-comparing new image directories to ol=
d<br>-comparing new image geometry to old<br>-unmounting and removing new i=
mage<br>-<br>-=3D=3D=3D copying scratch device to single target, large ro d=
evice<br>
-meta-data=3DDDEV isize=3DXXX agcount=3DN, agsize=3DXXX blks<br>-data=A0=A0=
=A0=A0 =3D bsize=3DXXX blocks=3DXXX, imaxpct=3DPCT<br>-=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D sunit=3DXXX swidth=3DXXX, unwritten=3DX<br>-naming=A0=A0 =3DVERN=
 bsize=3DXXX<br>-log=A0=A0=A0=A0=A0 =3DLDEV bsize=3DXXX blocks=3DXXX<br>
-realtime =3DRDEV extsz=3DXXX blocks=3DXXX, rtextents=3DXXX<br>-Creating fi=
le &lt;FSIMAGE1&gt;<br>- 0%=A0 ... 10%=A0 ... 20%=A0 ... 30%=A0 ... 40%=A0 =
... 50%=A0 ... 60%=A0 ... 70%=A0 ... 80%=A0 ... 90%=A0 ... 100%<br>-<br>-Al=
l copies completed.<br>-checking new image<br>
-mounting new image on loopback<br>-comparing new image files to old<br>-co=
mparing new image directories to old<br>-comparing new image geometry to ol=
d<br>-unmounting and removing new image<br>-<br>-=3D=3D=3D copying scratch =
device to multiple targets<br>
-Creating file &lt;FSIMAGE1&gt;<br>-Creating file &lt;FSIMAGE2&gt;<br>- 0%=
=A0 ... 10%=A0 ... 20%=A0 ... 30%=A0 ... 40%=A0 ... 50%=A0 ... 60%=A0 ... 7=
0%=A0 ... 80%=A0 ... 90%=A0 ... 100%<br>-<br>-All copies completed.<br>-che=
cking new image<br>
-mounting new image on loopback<br>-comparing new image files to old<br>-co=
mparing new image directories to old<br>-comparing new image geometry to ol=
d<br>-unmounting and removing new image<br>-checking new image<br>-mounting=
 new image on loopback<br>
-comparing new image files to old<br>-comparing new image directories to ol=
d<br>-comparing new image geometry to old<br>-unmounting and removing new i=
mage<br>+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>
+=A0=A0=A0=A0=A0=A0=A0 (In some cases useful info about processes that use<=
br>+=A0=A0=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br=
>+failed to unmount /dev/sda6<br>074 211s ... 218s<br>075 84s ... 100s<br>0=
76 80s ... [failed, exit status 1] - output mismatch (see 076.out.bad)<br>
--- 076.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 076.out.bad=
=A0=A0=A0 2011-06-15 14:49:41.146042964 +0530<br>@@ -1,5 +1,6 @@<br>=A0QA o=
utput created by 076<br>-*** init fs<br>-*** test concurrent block/fs acces=
s<br>-*** done<br>
+umount: /home/manish/Projects/xfstests/sdb4: device is busy.<br>+=A0=A0=A0=
=A0=A0=A0=A0 (In some cases useful info about processes that use<br>+=A0=A0=
=A0=A0=A0=A0=A0=A0 the device is found by lsof(8) or fuser(1))<br>+failed t=
o unmount /dev/sda6<br>=A0*** unmount<br>
077=A0=A0=A0 =A0[failed, exit status 1] - output mismatch (see 077.out.bad)=
<br>--- 077.out=A0=A0=A0 2011-05-11 22:32:24.000000000 +0530<br>+++ 077.out=
.bad=A0=A0=A0 2011-06-15 14:49:42.722023261 +0530<br>@@ -1,7 +1,5 @@<br>=A0=
QA output created by 077<br>
=A0*** create filesystem<br>-*** set default ACL<br>-*** populate filesyste=
m, pass #1<br>-*** populate filesystem, pass #2<br>-*** all done<br>+mkfs f=
ailed<br>+(see 077.full for details)<br>=A0*** unmount<br>078 78s ... 80s<b=
r>
_check_xfs_filesystem: filesystem on /dev/sda5 has dirty log (see 078.full)=
<br>_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (c) (see=
 078.full)<br>_check_xfs_filesystem: filesystem on /dev/sda5 is inconsisten=
t (r) (see 078.full)<br>
Ran: 001 002 003 004 005 006 007 008 009 011 012 013 014 015 016 017 019 02=
0 021 026 027 028 029 030 031 032 033 034 041 042 045 046 047 048 049 050 0=
51 052 053 054 056 061 062 063 064 065 066 067 068 069 070 072 073 074 075 =
076 077 078<br>
Not run: 010 035 040 044 057 058<br>Failures: 015 042 049 050 052 053 054 0=
56 061 062 063 064 065 066 067 068 069 072 073 076 077<br>Failed 21 of 58 t=
ests<br><br><br><br><br>

--20cf30564473dcf77904a5bcb811--


--===============7222046101830224363==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7222046101830224363==--
