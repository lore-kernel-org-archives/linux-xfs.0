Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 20:33:45 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G4XgGO030965
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:33:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 808285E21E2
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:34:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id VMWRnOHoZoUBBJNN for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:34:06 -0800 (PST)
Message-ID: <47B6679C.2040109@sandeen.net>
Date: Fri, 15 Feb 2008 22:33:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Differences in mkfs.xfs and xfs_info output.
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk> <47B66223.4080604@sandeen.net>
In-Reply-To: <47B66223.4080604@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Jan Derfinak wrote:
>   
>> features2 = 0
>>     
>
>
> Looks like neither XFS_SB_VERSION2_ATTR2BIT nor
> XFS_SB_VERSION2_LAZYSBCOUNTBIT is in fact set.
>
> You're on x86_64 aren't you...
>
> This reminds me of an email I sent in 2006....
>   
Does this make it happier for you?  Hmm actually the kernel needs
the analogous change too.  And then probably something to fix up 
all the misformatted filesystems out there.... yuck.

Hmm and I don't know how lazy-sb-count is getting lost, yet :)

Index: xfsprogs/include/xfs_sb.h
===================================================================
--- xfsprogs.orig/include/xfs_sb.h
+++ xfsprogs/include/xfs_sb.h
@@ -151,6 +151,7 @@ typedef struct xfs_sb
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_dummy;	/* explicit padding */
 } xfs_sb_t;
 
 /*
@@ -169,7 +170,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_DUMMY,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
Index: xfsprogs/libxfs/xfs_mount.c
===================================================================
--- xfsprogs.orig/libxfs/xfs_mount.c
+++ xfsprogs/libxfs/xfs_mount.c
@@ -140,6 +140,7 @@ static struct {
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_dummy),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
