Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbdLXTJD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Dec 2017 14:09:03 -0500
Received: from Liberator-5.netgear.com (unknown [50.35.53.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B731D77B2D0
        for <linux-xfs@vger.kernel.org>; Sun, 24 Dec 2017 13:08:37 -0600 (CST)
Subject: [PATCH 1/3] mkfs: un-document removed logarithm based CLI options
From: Eric Sandeen <sandeen@sandeen.net>
References: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
Message-ID: <c518f87e-78ae-d83b-f714-d86a70d8049c@sandeen.net>
Date: Sun, 24 Dec 2017 11:09:01 -0800
MIME-Version: 1.0
In-Reply-To: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Remove logarithm-based options from usage() and manpage.

Fixes: 70f72d5 "mkfs: remove logarithm based CLI options"
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index bbbe1c5..4b8c78c 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -5,7 +5,7 @@ mkfs.xfs \- construct an XFS filesystem
 .B mkfs.xfs
 [
 .B \-b
-.I block_size
+.I block_size_options
 ] [
 .B \-m
 .I global_metadata_options
@@ -33,7 +33,7 @@ mkfs.xfs \- construct an XFS filesystem
 .I realtime_section_options
 ] [
 .B \-s
-.I sector_size
+.I sector_size_options
 ] [
 .B \-L
 .I label
@@ -126,17 +126,14 @@ disable or enable the functionality.
 .BI \-b " block_size_options"
 This option specifies the fundamental block size of the filesystem.
 The valid
-.I block_size_options
-are:
-.BI log= value
-or
+.I block_size_option
+is:
+.RS 1.2i
+.TP
 .BI size= value
-and only one can be supplied.
-The block size is specified either as a base two logarithm value with
-.BR log= ,
-or in bytes with
-.BR size= .
-The default value is 4096 bytes (4 KiB), the minimum is 512, and the
+The filesystem block size is specified with a
+.I value
+in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
 .IP
 To specify any options on the command line in units of filesystem blocks, this
@@ -147,6 +144,7 @@ Although
 .B mkfs.xfs
 will accept any of these values and create a valid filesystem,
 XFS on Linux can only mount filesystems with pagesize or smaller blocks.
+.RE
 .TP
 .BI \-m " global_metadata_options"
 These options specify metadata format options that either apply to the entire
@@ -419,15 +417,11 @@ The valid
 are:
 .RS 1.2i
 .TP
-.BI size= value " | log=" value " | perblock=" value
+.BI size= value " | perblock=" value
 The inode size is specified either as a
 .I value
 in bytes with
-.BR size= ,
-a base two logarithm
-.I value
-with
-.BR log= ,
+.BR size=
 or as the number fitting in a filesystem block with
 .BR perblock= .
 The minimum (and default)
@@ -648,15 +642,10 @@ These options specify the version and size parameters for the naming
 are:
 .RS 1.2i
 .TP
-.BI size= value " | log=" value
-The block size is specified either as a
-.I value
-in bytes with
-.BR size= ,
-or as a base two logarithm
+.BI size= value
+The directory block size is specified with a
 .I value
-.RB "with " log= .
-The block size must be a power of 2 and cannot be less than the
+in bytes.  The block size must be a power of 2 and cannot be less than the
 filesystem block size.
 The default size
 .I value
@@ -888,15 +877,17 @@ This option disables stripe size detection, enforcing a realtime device with no
 stripe geometry.
 .RE
 .TP
-.BI \-s " sector_size"
+.BI \-s " sector_size_options"
 This option specifies the fundamental sector size of the filesystem.
-The
-.I sector_size
-is specified either as a value in bytes with
+The valid
+.I sector_size_option
+is:
+.RS 1.2i
+.TP
 .BI size= value
-or as a base two logarithm value with
-.BI log= value.
-The default
+The sector size is specified with a
+.I value
+in bytes.  The default
 .I sector_size
 is 512 bytes. The minimum value for sector size is
 512; the maximum is 32768 (32 KiB). The
@@ -907,6 +898,7 @@ filesystem block size.
 To specify any options on the command line in units of sectors, this
 option must be specified first so that the sector size is
 applied consistently to all options.
+.RE
 .TP
 .BI \-L " label"
 Set the filesystem
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f3d57cf..1f3494c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -860,25 +860,24 @@ static void __attribute__((noreturn))
 usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
-/* blocksize */		[-b log=n|size=num]\n\
+/* blocksize */		[-b size=num]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
-			    sectlog=n|sectsize=num\n\
+			    sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
-			    lazy-count=0|1]\n\
+			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
-/* sectorsize */	[-s log=n|size=num]\n\
+/* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
 <devicename> is required unless -d name=xxx is given.\n\

