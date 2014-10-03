Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91B5D7F4E
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:15:16 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:15:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 31/35] xfsprogs: add utf8 support to growfs
Message-ID: <20141003221516.GE1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Add utf-8 to xfs_growfs and xfs_info.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

[v2: use versioned fsgeom ioctl. -bpm]
---
 growfs/xfs_growfs.c | 85 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 61 insertions(+), 24 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index c3df0c0..5e9d575 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -18,6 +18,7 @@
 
 #include <xfs/libxfs.h>
 #include <xfs/path.h>
+#include <xfs/utf8norm.h>
 
 static void
 usage(void)
@@ -44,7 +45,8 @@ Options:\n\
 
 void
 report_info(
-	xfs_fsop_geom_v2_t	geo,
+	xfs_fsop_geom_t	geo,
+	int		oldioctl,
 	char		*mntpoint,
 	int		isint,
 	char		*logname,
@@ -57,8 +59,31 @@ report_info(
 	int		crcs_enabled,
 	int		cimode,
 	int		ftype_enabled,
-	int		finobt_enabled)
+	int		finobt_enabled,
+	int		utf8)
 {
+	char		utf8_version_string[10];
+
+	/* XXX Can we assume that geo.version has always been zeroed by
+	 * the kernel so it is always meaningful? */
+	if (!oldioctl && geo.version >= XFS_FSOP_GEOM_VERSION5 && utf8) {
+		int	major, minor, revision;
+
+		major = geo.utf8version >> UNICODE_MAJ_SHIFT;
+		minor = (geo.utf8version & 0xff00) >> UNICODE_MIN_SHIFT;
+		revision = geo.utf8version & 0xff;
+
+		if (!revision && !minor)
+			sprintf(utf8_version_string, "%d", major);
+		else if (!revision)
+			sprintf(utf8_version_string, "%d.%d", major, minor);
+		else
+			sprintf(utf8_version_string, "%d.%d.%d",
+					major, minor, revision);
+	} else {
+		sprintf(utf8_version_string, "0");
+	}
+
 	printf(_(
 	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
 	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
@@ -66,6 +91,7 @@ report_info(
 	    "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 	    "         =%-22s sunit=%-6u swidth=%u blks\n"
 	    "naming   =version %-14u bsize=%-6u ascii-ci=%d ftype=%d\n"
+	    "         =%-22s utf8=%s\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
 	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
@@ -76,7 +102,8 @@ report_info(
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize, cimode, ftype_enabled,
+		dirversion, geo.dirblocksize, cimode, ftype_enabled,
+		"", utf8_version_string,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -101,7 +128,7 @@ main(int argc, char **argv)
 	int			error;	/* we have hit an error */
 	long			esize;	/* new rt extent size */
 	int			ffd;	/* mount point file descriptor */
-	xfs_fsop_geom_v2_t	geo;	/* current fs geometry */
+	xfs_fsop_geom_t		geo;	/* current fs geometry */
 	int			iflag;	/* -i flag */
 	int			isint;	/* log is currently internal */
 	int			lflag;	/* -l flag */
@@ -109,11 +136,12 @@ main(int argc, char **argv)
 	int			maxpct;	/* -m flag value */
 	int			mflag;	/* -m flag */
 	int			nflag;	/* -n flag */
-	xfs_fsop_geom_v2_t	ngeo;	/* new fs geometry */
+	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
 	int			ci;	/* ASCII case-insensitive fs */
 	int			lazycount; /* lazy superblock counters */
+	int			utf8;	/* Unicode chars supported */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -125,6 +153,7 @@ main(int argc, char **argv)
 	int			crcs_enabled;
 	int			ftype_enabled = 0;
 	int			finobt_enabled;	/* free inode btree */
+	int			oldioctl = 0;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -219,21 +248,28 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	/* get the current filesystem size & geometry */
-	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V2, &geo) < 0) {
-		/*
-		 * OK, new xfsctl barfed - back off and try earlier version
-		 * as we're probably running an older kernel version.
-		 * Only field added in the v2 geometry xfsctl is "logsunit"
-		 * so we'll zero that out for later display (as zero).
-		 */
-		geo.logsunit = 0;
-		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo) < 0) {
-			fprintf(stderr, _(
-				"%s: cannot determine geometry of filesystem"
-				" mounted at %s: %s\n"),
-				progname, fname, strerror(errno));
-			exit(1);
+	memset(&geo, '\0', sizeof(geo));
+	geo.version = XFS_FSOP_GEOM_VERSION5;
+	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
+	
+		oldioctl = 1;
+		/* get the current filesystem size & geometry */
+		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V2, &geo) < 0) {
+			/*
+			 * OK, new xfsctl barfed - back off and try
+			 * earlier version as we're probably running an
+			 * older kernel version.  Only field added in
+			 * the v2 geometry xfsctl is "logsunit" so we'll
+			 * zero that out for later display (as zero).
+			 */
+			geo.logsunit = 0;
+			if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo)
+					< 0) {
+				fprintf(stderr,
+	_("%s: cannot determine geometry of filesystem mounted at %s: %s\n"),
+					progname, fname, strerror(errno));
+				exit(1);
+			}
 		}
 	}
 	isint = geo.logstart > 0;
@@ -247,11 +283,12 @@ main(int argc, char **argv)
 	crcs_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_V5SB ? 1 : 0;
 	ftype_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
 	finobt_enabled = geo.flags & XFS_FSOP_GEOM_FLAGS_FINOBT ? 1 : 0;
+	utf8 = geo.flags & XFS_FSOP_GEOM_FLAGS_UTF8 ? 1 : 0;
 	if (nflag) {
-		report_info(geo, datadev, isint, logdev, rtdev,
+		report_info(geo, oldioctl, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
 				attrversion, projid32bit, crcs_enabled, ci,
-				ftype_enabled, finobt_enabled);
+				ftype_enabled, finobt_enabled, utf8);
 		exit(0);
 	}
 
@@ -286,10 +323,10 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	report_info(geo, datadev, isint, logdev, rtdev,
+	report_info(geo, oldioctl, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
 			attrversion, projid32bit, crcs_enabled, ci, ftype_enabled,
-			finobt_enabled);
+			finobt_enabled, utf8);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
