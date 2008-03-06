Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 20:41:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m264fdfN023764
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 20:41:42 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A133165CF7D
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 20:42:05 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id 5eRPcUCBTwamdpNy for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 20:42:05 -0800 (PST)
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [REVIEW] mkfs.xfs man page needs the default settings updated, TAKE 2.
In-Reply-To: <47CD6ED7.5050505@sandeen.net> (Eric Sandeen's message of "Tue,
	04 Mar 2008 09:46:31 -0600")
References: <ncc8x0zhwxw.fsf@sgi.com> <47CD6D0E.3090301@sandeen.net>
	<47CD6ED7.5050505@sandeen.net>
Date: Thu, 06 Mar 2008 15:41:29 +1100
Message-ID: <ncczltcfoqu.fsf_-_@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

--=-=-=


Thanks to Eric for the comments, is this better ?

Cheers,
-- 
Niv Sardi

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Update-mkfs-manpage-for-new-defaults.patch

>From 7e0e328663858ecf13f35678f1a6d349c3d4dd5a Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@sgi.com>
Date: Fri, 22 Feb 2008 16:48:32 +1100
Subject: [PATCH] Update mkfs manpage for new defaults:

log, attr and inodes v2,
Drop the ability to turn unwritten extents off completly,
reduce imaxpct for big filesystems, less AGs for single disks configs.
---
 xfsprogs/man/man8/mkfs.xfs.8 |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
index b6024c3..afc284c 100644
--- a/xfsprogs/man/man8/mkfs.xfs.8
+++ b/xfsprogs/man/man8/mkfs.xfs.8
@@ -304,10 +304,16 @@ bits.
 This specifies the maximum percentage of space in the filesystem that
 can be allocated to inodes. The default
 .I value
-is 25%. Setting the
+is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
+for filesystems over 50TB. Setting the
 .I value
-to 0 means that essentially all of the filesystem can
-become inode blocks.
+to 0 means that essentially all of the filesystem can become inode
+blocks. Note that this is only used by inode32 (on 32bits platforms),
+and is ignored on 64bits platforms. On 32 bits platforms, we can only
+use the first TB of disk space for inodes, so the allocator will try
+to avoid this region, hence miss-using the first AG if this is set to
+high (the worst case is a 4TB filesystem where a full AG will be
+untouched by anything but inodes with a 25% maxpct).
 .TP
 .BI align[= value ]
 This is used to specify that inode allocation is or is not aligned. The
@@ -325,18 +331,11 @@ that does not have the inode alignment feature
 (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
 .TP
 .BI attr[= value ]
-This is used to specify the version of extended attribute inline allocation
-policy to be used.
-By default, this is zero.  Once extended attributes are used for the
-first time, the version will be set to either one or two.
-The current version (two) uses a more efficient algorithm for managing
-the available inline inode space than version one does, however, for
-backward compatibility reasons (and in the absence of the
-.B attr=2
-mkfs option, or the
-.B attr2
-mount option), version one will be selected
-by default when attributes are first used on a filesystem.
+This is used to specify the version of extended attribute inline
+allocation policy to be used.  By default, this is 2.  The current
+version (two) uses a more efficient algorithm for managing the
+available inline inode space than version one does. This option is
+kept for backward compatibility, attr2 was added in kernel 2.6.16.
 .RE
 .TP
 .BI \-l " log_section_options"
@@ -389,15 +388,11 @@ and directory block size, the minimum log size is larger than 512 blocks.
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
+allows bigger log buffer size (version 1 had a limit at 32K), and the
+use of the sunit and su options. Possibility to use version=1 is left
+for backward compatibility only.
 .TP
 .BI sunit= value
 This specifies the alignment to be used for log writes. The
-- 
1.5.4.3


--=-=-=--
