Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 18:17:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA11HDCk030090
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 18:17:17 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA01159 for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 12:17:16 +1100
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id lA11HFdD88962245
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 12:17:16 +1100 (AEDT)
Received: (from xaiki@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id lA11HFpJ88935053
	for xfs@oss.sgi.com; Thu, 1 Nov 2007 12:17:15 +1100 (AEDT)
Date: Thu, 1 Nov 2007 12:17:15 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071101011715.GD88034736@melbourne.sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com> <20071031233516.GB88034736@melbourne.sgi.com> <20071031234027.GC88034736@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
In-Reply-To: <20071031234027.GC88034736@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After discussing with dave, I changed my mind about the last patch, here's the updated version:

Cheers,
-- 
Niv

--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0006-less-AGs-for-single-disks-configs.patch"

>From ce672e92543fa99199ed23fa934dedf8d678924e Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@cxhome.ath.cx>
Date: Tue, 30 Oct 2007 12:26:35 +1100
Subject: [PATCH] less AGs for single disks configs.

get the underlying structure with get_subvol_stripe_wrapper(),
and pass sunit | swidth as an argument to calc_default_ag_geometry().

if it is set, get the AG sizes bigger.

this also cleans up a typo:
-       } else if (daflag)      /* User-specified AG size */
+       } else if (daflag)      /* User-specified AG count */
---
 xfsprogs/mkfs/xfs_mkfs.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index 78c2c77..4cf9975 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -393,6 +393,7 @@ void
 calc_default_ag_geometry(
 	int		blocklog,
 	__uint64_t	dblocks,
+	int		multidisk,
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
+		shift = 5 - (multidisk == 0);
 	else if (dblocks > GIGABYTES(8, blocklog))
-		shift = 4;
+		shift = 4 - (multidisk == 0);
 	else if (dblocks >= MEGABYTES(128, blocklog))
-		shift = 3;
+		shift = 3 - (multidisk == 0);
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
+		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
+					  &xlv_dsunit, &xlv_dswidth, &sectoralign),
+			calc_default_ag_geometry(blocklog, dblocks, xlv_dsunit | xlv_dswidth,
+						 &agsize, &agcount);
+	}
 
 	/*
 	 * If the last AG is too small, reduce the filesystem size
-- 
1.5.3.4


--oTHb8nViIGeoXxdp--
