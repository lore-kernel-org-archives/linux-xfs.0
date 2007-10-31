Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 16:40:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9VNeQvh020115
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 16:40:30 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA28452 for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 10:40:29 +1100
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l9VNeSdD88785647
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 10:40:28 +1100 (AEDT)
Received: (from xaiki@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l9VNeS4788897341
	for xfs@oss.sgi.com; Thu, 1 Nov 2007 10:40:28 +1100 (AEDT)
Date: Thu, 1 Nov 2007 10:40:28 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071031234027.GC88034736@melbourne.sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com> <20071031233516.GB88034736@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20071031233516.GB88034736@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Oops, the last patch should have been this one, sorry for the noise.

-- 
Niv

--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0006-less-AGs-for-single-disks-configs.patch"

>From 1defd8358a7ee693176875ebc3a670a347c87d11 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Tue, 30 Oct 2007 12:26:35 +1100
Subject: [PATCH] less AGs for single disks configs.

This patch modifies get_subvol_stripe_wrapper() to return 0 on multi disk configs,
<0 on error, and >0 on single disk configs (Ideally I'd like it to be able to return the
count of disks or something more usefull).

it then uses the output of the new get_subvol_stripe_wrapper() in calc_default_ag_geometry()
to get bigger AGs when in single disk configs (currently only x2 bigger).
---
 xfsprogs/include/volume.h  |    2 +-
 xfsprogs/libdisk/drivers.c |   15 ++++++++-------
 xfsprogs/mkfs/xfs_mkfs.c   |   18 ++++++++++++------
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/xfsprogs/include/volume.h b/xfsprogs/include/volume.h
index 0cc931d..e4cd26c 100644
--- a/xfsprogs/include/volume.h
+++ b/xfsprogs/include/volume.h
@@ -46,7 +46,7 @@ typedef enum sv_type_e {
 	SVTYPE_LAST		=255
 } sv_type_t;
 
-extern void get_subvol_stripe_wrapper (char *, sv_type_t, int *, int *, int *);
+extern int  get_subvol_stripe_wrapper (char *, sv_type_t, int *, int *, int *);
 extern int  get_driver_block_major (const char *, int);
 
 #endif /* __VOLUME_H__ */
diff --git a/xfsprogs/libdisk/drivers.c b/xfsprogs/libdisk/drivers.c
index 26c6ec1..9bdc270 100644
--- a/xfsprogs/libdisk/drivers.c
+++ b/xfsprogs/libdisk/drivers.c
@@ -18,7 +18,7 @@
 
 #include "drivers.h"
 
-void
+int
 get_subvol_stripe_wrapper(
 	char		*dev,
 	sv_type_t	type,
@@ -29,7 +29,7 @@ get_subvol_stripe_wrapper(
 	struct stat64	sb;
 
 	if (dev == NULL)
-		return;
+		return -ENODEV;
 
 	if (stat64(dev, &sb)) {
 		fprintf(stderr, _("Cannot stat %s: %s\n"),
@@ -38,16 +38,17 @@ get_subvol_stripe_wrapper(
 	}
 
 	if (  dm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if (  md_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if ( lvm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if ( xvm_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 	if (evms_get_subvol_stripe(dev, type, sunit, swidth, sectalign, &sb))
-		return;
+		return 0;
 
+	return 1;
 	/* ... add new device drivers here */
 }
 
diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 78c2c77..ea5cd86 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -393,6 +393,7 @@ void
 calc_default_ag_geometry(
 	int		blocklog,
 	__uint64_t	dblocks,
+	int		singled,
 	__uint64_t	*agsize,
 	__uint64_t	*agcount)
 {
@@ -428,12 +429,13 @@ calc_default_ag_geometry(
 	 *
 	 * This scales us up smoothly between min/max AG sizes.
 	 */
+
 	if (dblocks > GIGABYTES(512, blocklog))
-		shift = 5;
+		shift = 5 - (singled > 0);
 	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
+		shift = 4 - (singled > 0);
 	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
+		shift = 3 - (singled > 0);
 	else
 		ASSERT(0);
 	blocks = dblocks >> shift;
@@ -1771,10 +1773,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		agsize /= blocksize;
 		agcount = dblocks / agsize + (dblocks % agsize != 0);
 
-	} else if (daflag)	/* User-specified AG size */
+	} else if (daflag)	/* User-specified AG count */
 		agsize = dblocks / agcount + (dblocks % agcount != 0);
-	else
-		calc_default_ag_geometry(blocklog, dblocks, &agsize, &agcount);
+	else {
+		calc_default_ag_geometry(blocklog, dblocks,
+					 get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
+								   &xlv_dsunit, &xlv_dswidth, &sectoralign),
+					 &agsize, &agcount);
+	}
 
 	/*
 	 * If the last AG is too small, reduce the filesystem size
-- 
1.5.3.4


--QTprm0S8XgL7H0Dt--
