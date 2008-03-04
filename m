Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 21:37:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m245bYsB016598
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 21:37:36 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3634A649524
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 21:38:02 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id Y6bONUG0Abz58wwZ for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 21:38:02 -0800 (PST)
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: [REVIEW] mkfs.xfs man page needs the default settings updated.
Date: Tue, 04 Mar 2008 16:36:59 +1100
Message-ID: <ncc8x0zhwxw.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com

--=-=-=


Manpages update for the new defaults, please review, I believe I got'em all.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Update-mkfs-manpage-for-new-defaults.patch

>From 71011d480d52aaefe99ef252dfff513bf77f209e Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@sgi.com>
Date: Fri, 22 Feb 2008 16:48:32 +1100
Subject: [PATCH] Update mkfs manpage for new defaults:

log, attr and inodes v2,
Drop the ability to turn unwritten extents off completly,
reduce imaxpct for big filesystems, less AGs for single disks configs.
---
 xfsprogs/man/man8/mkfs.xfs.8 |   44 +++++------------------------------------
 1 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
index b6024c3..f9a89af 100644
--- a/xfsprogs/man/man8/mkfs.xfs.8
+++ b/xfsprogs/man/man8/mkfs.xfs.8
@@ -304,7 +304,8 @@ bits.
 This specifies the maximum percentage of space in the filesystem that
 can be allocated to inodes. The default
 .I value
-is 25%. Setting the
+is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
+for filesystems over 50TB. Setting the
 .I value
 to 0 means that essentially all of the filesystem can
 become inode blocks.
@@ -327,16 +328,10 @@ that does not have the inode alignment feature
 .BI attr[= value ]
 This is used to specify the version of extended attribute inline allocation
 policy to be used.
-By default, this is zero.  Once extended attributes are used for the
+By default, this is 2.  Once extended attributes are used for the
 first time, the version will be set to either one or two.
 The current version (two) uses a more efficient algorithm for managing
-the available inline inode space than version one does, however, for
-backward compatibility reasons (and in the absence of the
-.B attr=2
-mkfs option, or the
-.B attr2
-mount option), version one will be selected
-by default when attributes are first used on a filesystem.
+the available inline inode space than version one does.
 .RE
 .TP
 .BI \-l " log_section_options"
@@ -389,15 +384,9 @@ and directory block size, the minimum log size is larger than 512 blocks.
 .BI version= value
 This specifies the version of the log. The
 .I value
-is either 1 or 2. Specifying
+is either 1 or 2 (the default is 2).
 .B version=2
-enables the
-.B sunit
-suboption, and allows the logbsize to be increased beyond 32K.
-Version 2 logs are automatically selected if a log stripe unit
-is specified.  See
-.BR sunit " and " su
-suboptions, below.
+allows the logbsize to be increased beyond 32K.
 .TP
 .BI sunit= value
 This specifies the alignment to be used for log writes. The
@@ -430,27 +419,6 @@ suffixes). This value must be a multiple of the filesystem block size.
 Version 2 logs are automatically selected if the log
 .B su
 suboption is specified.
-.TP
-.BI lazy-count= value
-This changes the method of logging various persistent counters
-in the superblock.  Under metadata intensive workloads, these
-counters are updated and logged frequently enough that the superblock
-updates become a serialisation point in the filesystem. The
-.I value
-can be either 0 or 1.
-.IP
-With
-.BR lazy-count=1 ,
-the superblock is not modified or logged on every change of the
-persistent counters. Instead, enough information is kept in
-other parts of the filesystem to be able to maintain the persistent
-counter values without needed to keep them in the superblock.
-This gives significant improvements in performance on some configurations.
-The default
-.I value
-is 0 (off) so you must specify
-.B lazy-count=1
-if you want to make use of this feature.
 .RE
 .TP
 .BI \-n " naming_options"
-- 
1.5.4.1


--=-=-=


-- 
Niv Sardi

--=-=-=--
