Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbdCCXOZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:25 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 7/9] mkfs.xfs: move ropts to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:14 -0800
Message-Id: <20170303231316.12716-8-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This moves all main() ropts to struct mkfs_xfs_opts in
order to help with clutter and later enable re-parsing
options for other purposes.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 98 +++++++++++++++++++++++++++------------------------------
 1 file changed, 47 insertions(+), 51 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b2f4495d858d..39ab08148687 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -779,6 +779,10 @@ struct mkfs_xfs_opts {
 	int			nlflag;
 	int			nvflag; /* unused */
 	int			nsflag;
+
+	char			*rtextsize;
+	char			*rtsize;
+	int			norsflag;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1728,6 +1732,34 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'r':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)ropts.subopts, &value)) {
+			case R_EXTSIZE:
+				params->rtextsize =
+					getstr(value, &ropts, R_EXTSIZE);
+				break;
+			case R_FILE:
+				params->xi.risfile =
+					getnum(value, &ropts, R_FILE);
+				break;
+			case R_NAME:
+			case R_DEV:
+				params->xi.rtname =
+					getstr(value, &ropts, R_NAME);
+				break;
+			case R_SIZE:
+				params->rtsize = getstr(value, &ropts, R_SIZE);
+				break;
+			case R_NOALIGN:
+				params->norsflag =
+					getnum(value, &ropts, R_NOALIGN);
+				break;
+			default:
+				unknown('r', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1776,7 +1808,6 @@ main(
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
-	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
 	int			Nflag;
 	int			discard = 1;
@@ -1787,9 +1818,7 @@ main(
 	xfs_rfsblock_t		rtblocks;
 	xfs_extlen_t		rtextblocks;
 	xfs_rtblock_t		rtextents;
-	char			*rtextsize;
 	char			*rtfile;
-	char			*rtsize;
 	xfs_sb_t		*sbp;
 	__uint64_t		sector_mask;
 	__uint64_t		tmp_agsize;
@@ -1815,10 +1844,8 @@ main(
 	logblocks = rtblocks = rtextblocks = 0;
 	Nflag = 0;
 	qflag = 0;
-	dfile = rtfile = NULL;
-	rtsize = rtextsize = protofile = NULL;
+	dfile = rtfile = protofile = NULL;
 	lalign = 0;
-	norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 
@@ -1837,6 +1864,7 @@ main(
 		case 'l':
 		case 'm':
 		case 'n':
+		case 'r':
 			p = optarg;
 			parse_subopts(c, p, &params);
 			break;
@@ -1859,38 +1887,6 @@ main(
 		case 'q':
 			qflag = 1;
 			break;
-		case 'r':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)ropts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
-					break;
-				case R_FILE:
-					params.xi.risfile = getnum(value, &ropts,
-							    R_FILE);
-					break;
-				case R_NAME:
-				case R_DEV:
-					params.xi.rtname = getstr(value, &ropts,
-							   R_NAME);
-					break;
-				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
-					break;
-				case R_NOALIGN:
-					norsflag = getnum(value, &ropts,
-								R_NOALIGN);
-					break;
-				default:
-					unknown('r', value);
-				}
-			}
-			break;
 		case 's':
 			p = optarg;
 			while (*p != '\0') {
@@ -1997,7 +1993,7 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 	if (params.xi.rtname)
 		check_device_type(params.xi.rtname,
 				  &params.xi.risfile,
-				  !rtsize,
+				  !params.rtsize,
 				  !params.xi.rtname,
 				  Nflag ? NULL : &params.xi.rcreat,
 				  force_overwrite, "r");
@@ -2230,10 +2226,10 @@ _("rmapbt not supported with realtime devices\n"));
 				(long long)logbytes, blocksize,
 				(long long)(logblocks << params.blocklog));
 	}
-	if (rtsize) {
+	if (params.rtsize) {
 		__uint64_t rtbytes;
 
-		rtbytes = getnum(rtsize, &ropts, R_SIZE);
+		rtbytes = getnum(params.rtsize, &ropts, R_SIZE);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
 			fprintf(stderr,
 			_("illegal rt length %lld, not a multiple of %d\n"),
@@ -2250,10 +2246,10 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * If specified, check rt extent size against its constraints.
 	 */
-	if (rtextsize) {
+	if (params.rtextsize) {
 		__uint64_t rtextbytes;
 
-		rtextbytes = getnum(rtextsize, &ropts, R_EXTSIZE);
+		rtextbytes = getnum(params.rtextsize, &ropts, R_EXTSIZE);
 		if (rtextbytes % blocksize) {
 			fprintf(stderr,
 		_("illegal rt extent size %lld, not a multiple of %d\n"),
@@ -2270,14 +2266,14 @@ _("rmapbt not supported with realtime devices\n"));
 		__uint64_t	rswidth;
 		__uint64_t	rtextbytes;
 
-		if (!norsflag && !params.xi.risfile &&
-		    !(!rtsize && params.xi.disfile))
+		if (!params.norsflag && !params.xi.risfile &&
+		    !(!params.rtsize && params.xi.disfile))
 			rswidth = ft.rtswidth;
 		else
 			rswidth = 0;
 
 		/* check that rswidth is a multiple of fs blocksize */
-		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
+		if (!params.norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
 			rswidth = DTOBT(rswidth);
 			rtextbytes = rswidth << params.blocklog;
 			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
@@ -2427,22 +2423,22 @@ reported by the device (%u).\n"),
 reported by the device (%u).\n"),
 			params.lsectorsize, params.xi.lbsize);
 	}
-	if (rtsize && params.xi.rtsize > 0 && params.xi.rtbsize > sectorsize) {
+	if (params.rtsize && params.xi.rtsize > 0 && params.xi.rtbsize > sectorsize) {
 		fprintf(stderr, _(
 "Warning: the realtime subvolume sector size %u is less than the sector size\n\
 reported by the device (%u).\n"),
 			sectorsize, params.xi.rtbsize);
 	}
 
-	if (rtsize && params.xi.rtsize > 0 && rtblocks > DTOBT(params.xi.rtsize)) {
+	if (params.rtsize && params.xi.rtsize > 0 && rtblocks > DTOBT(params.xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
 			"maximum is %lld blocks\n"),
-			rtsize, (long long)DTOBT(params.xi.rtsize));
+			params.rtsize, (long long)DTOBT(params.xi.rtsize));
 		usage();
-	} else if (!rtsize && params.xi.rtsize > 0)
+	} else if (!params.rtsize && params.xi.rtsize > 0)
 		rtblocks = DTOBT(params.xi.rtsize);
-	else if (rtsize && !params.xi.rtdev) {
+	else if (params.rtsize && !params.xi.rtdev) {
 		fprintf(stderr,
 			_("size specified for non-existent rt subvolume\n"));
 		usage();
-- 
2.11.0

