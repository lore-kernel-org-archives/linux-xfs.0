Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1CiVV9002135 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 06:44:32 -0600
Received: from hades.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BF9F290E3B
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 04:44:28 -0800 (PST)
Received: from hades.usersys.redhat.com (186.215.132.159.static.gvt.net.br
	[186.215.132.159]) by cuda.sgi.com with ESMTP id
	UgeupsTAu4wHVIDc for <xfs@oss.sgi.com>;
	Thu, 01 Dec 2011 04:44:28 -0800 (PST)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] mkfs: Refuse to initialize a misaligned device if not forced
	using libblkid
Date: Thu,  1 Dec 2011 10:44:25 -0200
Message-Id: <1322743465-17175-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Carlos Maiolino <cmaiolino@redhat.com>

This is the first patch proposal to fix the problem about the usage of
4k sector devices when the device is not properly aligned

The patch make mkfs to refuse to initialize a xfs filesystem if the -f
option is not passed at the command line, and forces a 512b sector size
if the user opt to force the device initialization

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f527f3d..495c70d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -369,8 +369,14 @@ out:
 	return ret;
 }
 
-static void blkid_get_topology(const char *device, int *sunit, int *swidth, int *sectorsize)
+static void blkid_get_topology(
+	const char *device,
+	int *sunit,
+	int *swidth,
+	int *sectorsize,
+	int force_overwrite)
 {
+
 	blkid_topology tp;
 	blkid_probe pr;
 	unsigned long val;
@@ -409,6 +415,12 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth, int
 		fprintf(stderr,
 			_("warning: device is not properly aligned %s\n"),
 			device);
+
+		if(!force_overwrite){
+			fprintf(stderr, _("Use -f to force usage of a misaligned device\n"));
+			exit(EXIT_FAILURE);
+		}
+	*sectorsize = BBSIZE;  /* Force a 512b sector size if the device is misaligned*/
 	}
 
 	blkid_free_probe(pr);
@@ -421,19 +433,19 @@ out_free_probe:
 		device);
 }
 
-static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
+static void get_topology(libxfs_init_t *xi, struct fs_topology *ft, int force_overwrite)
 {
 	if (!xi->disfile) {
 		const char *dfile = xi->volname ? xi->volname : xi->dname;
 
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
-				   &ft->sectorsize);
+				   &ft->sectorsize, force_overwrite);
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int dummy;
 
-		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy);
+		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth, &dummy, force_overwrite);
 	}
 }
 #else /* ENABLE_BLKID */
@@ -460,7 +472,7 @@ check_overwrite(
 	return 0;
 }
 
-static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
+static void get_topology(libxfs_init_t *xi, struct fs_topology *ft, int force_overwrite)
 {
 	char *dfile = xi->volname ? xi->volname : xi->dname;
 	int bsz = BBSIZE;
@@ -1625,7 +1637,7 @@ main(
 	}
 
 	memset(&ft, 0, sizeof(ft));
-	get_topology(&xi, &ft);
+	get_topology(&xi, &ft, force_overwrite);
 
 	if (ft.sectoralign) {
 		/*
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
