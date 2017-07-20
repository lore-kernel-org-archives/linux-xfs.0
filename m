Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935653AbdGTJwK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:52:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B8727C852
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:52:10 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 5/5] mkfs: replace variables with opts table: -r options
Date: Thu, 20 Jul 2017 11:51:56 +0200
Message-Id: <20170720095156.35417-6-jtulak@redhat.com>
In-Reply-To: <20170720095156.35417-1-jtulak@redhat.com>
References: <20170720095156.35417-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Remove variables that can be replaced with a direct access to the opts
table, so we have it all in a single place, accessible from anywhere.

In future, we can remove some instances where we are passing values as
arguments to helper functions, when we have the values in the opts
struct and could pass only the struct.  But for now, limit the changes
to simple replacement without any change in the logic.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 70 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8c582b87..27b476d2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1501,7 +1501,6 @@ main(
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
 	int			nlflag;
-	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
 	int			nvflag;
@@ -1512,10 +1511,8 @@ main(
 	char			*protostring;
 	int			qflag;
 	xfs_rfsblock_t		rtblocks;
-	int		rtbytes;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	int		rtextbytes;
 	char			*rtfile;
 	xfs_sb_t		*sbp;
 	__uint64_t		sector_mask;
@@ -1558,9 +1555,7 @@ main(
 	qflag = false;
 	dfile = logfile = rtfile = NULL;
 	protofile = NULL;
-	rtbytes = rtextbytes = 0;
 	lalign = 0;
-	norsflag = false;
 	force_overwrite = false;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -1987,9 +1982,8 @@ main(
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
-					rtextbytes = parse_conf_val(OPT_R,
-								    R_EXTSIZE,
-								    value);
+					parse_conf_val(OPT_R, R_EXTSIZE,
+						       value);
 					break;
 				case R_FILE:
 					xi.risfile = parse_conf_val(OPT_R,
@@ -2004,13 +1998,11 @@ main(
 					set_conf_val(OPT_R, R_DEV, 1);
 					break;
 				case R_SIZE:
-					rtbytes = parse_conf_val(OPT_R, R_SIZE,
-								 value);
+					parse_conf_val(OPT_R, R_SIZE, value);
 					break;
 				case R_NOALIGN:
-					norsflag = parse_conf_val(OPT_R,
-								  R_NOALIGN,
-								  value);
+					parse_conf_val(OPT_R, R_NOALIGN,
+						       value);
 					break;
 				default:
 					unknown('r', value);
@@ -2155,7 +2147,10 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 				  !xi.logname, Nflag ? NULL : &xi.lcreat,
 				  force_overwrite, "l");
 	if (xi.rtname)
-		check_device_type(xi.rtname, &xi.risfile, !rtbytes, !xi.rtname,
+		check_device_type(xi.rtname,
+				  &xi.risfile,
+				  !get_conf_val(OPT_R, R_SIZE),
+				  !xi.rtname,
 				  Nflag ? NULL : &xi.rcreat,
 				  force_overwrite, "r");
 	if (xi.disfile || xi.lisfile || xi.risfile)
@@ -2404,33 +2399,36 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)(logblocks <<
 					   get_conf_val(OPT_B, B_LOG)));
 	}
-	if (rtbytes) {
-		if (rtbytes % XFS_MIN_BLOCKSIZE) {
+	if (get_conf_val(OPT_R, R_SIZE)) {
+		if (get_conf_val(OPT_R, R_SIZE) % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
-				(long long)rtbytes, XFS_MIN_BLOCKSIZE);
+				get_conf_val(OPT_R, R_SIZE), XFS_MIN_BLOCKSIZE);
 			usage();
 		}
-		rtblocks = (xfs_rfsblock_t)(rtbytes >>
+		rtblocks = (xfs_rfsblock_t)(get_conf_val(OPT_R, R_SIZE) >>
 					    get_conf_val(OPT_B, B_LOG));
-		if (rtbytes % get_conf_val(OPT_B, B_SIZE))
+		if (get_conf_val(OPT_R, R_SIZE) % get_conf_val(OPT_B, B_SIZE))
 			fprintf(stderr,
 	_("warning: rt length %lld not a multiple of %lld, truncated to %lld\n"),
-				(long long)rtbytes, get_conf_val(OPT_B, B_SIZE),
+				get_conf_val(OPT_R, R_SIZE),
+				get_conf_val(OPT_B, B_SIZE),
 				(long long)(rtblocks <<
 					   get_conf_val(OPT_B, B_LOG)));
 	}
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-	if (rtextbytes) {
-		if (rtextbytes % get_conf_val(OPT_B, B_SIZE)) {
+	if (get_conf_val(OPT_R, R_EXTSIZE)) {
+		if (get_conf_val(OPT_R, R_EXTSIZE) %
+		    get_conf_val(OPT_B, B_SIZE)) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %lld\n"),
-				(long long)rtextbytes, get_conf_val(OPT_B, B_SIZE));
+				get_conf_val(OPT_R, R_EXTSIZE),
+				get_conf_val(OPT_B, B_SIZE));
 			usage();
 		}
-		rtextblocks = (xfs_extlen_t)(rtextbytes >>
+		rtextblocks = (xfs_extlen_t)(get_conf_val(OPT_R, R_EXTSIZE) >>
 					     get_conf_val(OPT_B, B_LOG));
 	} else {
 		/*
@@ -2439,20 +2437,23 @@ _("rmapbt not supported with realtime devices\n"));
 		 * to the stripe width.
 		 */
 		__uint64_t	rswidth;
-		__uint64_t	rtextbytes;
 
-		if (!norsflag && !xi.risfile && !(!rtbytes && xi.disfile))
+		if (!get_conf_val(OPT_R, R_NOALIGN) && !xi.risfile &&
+		    !(!get_conf_val(OPT_R, R_SIZE) && xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
 
 		/* check that rswidth is a multiple of fs B_SIZE */
-		if (!norsflag && rswidth &&
+		if (!get_conf_val(OPT_R, R_NOALIGN) && rswidth &&
 		    !(BBTOB(rswidth) % get_conf_val(OPT_B, B_SIZE))) {
 			rswidth = DTOBT(rswidth);
-			rtextbytes = rswidth << get_conf_val(OPT_B, B_LOG);
-			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
-			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
+			set_conf_val(OPT_R, R_EXTSIZE,
+				     rswidth << get_conf_val(OPT_B, B_LOG));
+			if (XFS_MIN_RTEXTSIZE <=
+			    get_conf_val(OPT_R, R_EXTSIZE) &&
+			    (get_conf_val(OPT_R, R_EXTSIZE) <=
+			     XFS_MAX_RTEXTSIZE)) {
 				rtextblocks = rswidth;
 			}
 		}
@@ -2621,7 +2622,7 @@ reported by the device (%u).\n"),
 reported by the device (%u).\n"),
 			get_conf_val(OPT_L, L_SECTSIZE), xi.lbsize);
 	}
-	if (rtbytes && xi.rtsize > 0 &&
+	if (get_conf_val(OPT_R, R_SIZE) && xi.rtsize > 0 &&
 	    xi.rtbsize > get_conf_val(OPT_D, D_SECTSIZE)) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %lld is less than the sector size\n\
@@ -2629,16 +2630,17 @@ reported by the device (%u).\n"),
 			get_conf_val(OPT_D, D_SECTSIZE), xi.rtbsize);
 	}
 
-	if (rtbytes && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
+	if (get_conf_val(OPT_R, R_SIZE) && xi.rtsize > 0 &&
+	    rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
 			get_conf_raw(OPT_R, R_SIZE),
 			(long long)DTOBT(xi.rtsize));
 		usage();
-	} else if (!rtbytes && xi.rtsize > 0)
+	} else if (!get_conf_val(OPT_R, R_SIZE) && xi.rtsize > 0)
 		rtblocks = DTOBT(xi.rtsize);
-	else if (rtbytes && !xi.rtdev) {
+	else if (get_conf_val(OPT_R, R_SIZE) && !xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
-- 
2.11.0

