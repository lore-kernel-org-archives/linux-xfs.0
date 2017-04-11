Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbdDKO7C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:59:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75D708FAA0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 14:59:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-35.pek2.redhat.com [10.72.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 659537B522
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 14:59:01 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v4] repair: handle reading superblock from image on larger sector size filesystem
Date: Tue, 11 Apr 2017 22:58:52 +0800
Message-Id: <1491922732-8142-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Due to xfs_repair uses direct IO, sometimes it can't read superblock
from an image file has smaller sector size than host filesystem.
Especially that superblock doesn't align with host filesystem's
sector size.

Fortunately, xfsprogs already has code to do isa_file and geometry
check in xfs_repair.c, it turns off O_DIRECT after phase1() if the
sector size is less than the host filesystem's geometry. So move
the isa_file auto detection over up the phase1(), and try to do
once geometry check before phase1() if get_sb() return OK.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V4 did below changes:
1) change the new common function name to check_fs_vs_host_sectsize()
2) move the isa_file judgement from common function to main function
3) add more comments (written by Eric).

Thanks,
Zorro

 repair/xfs_repair.c | 96 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 39 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b07567b..ab60c0f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -627,6 +627,40 @@ is_multidisk_filesystem(
 	return true;
 }
 
+/*
+ * if the sector size of the filesystem we are trying to repair is
+ * smaller than that of the underlying filesystem (i.e. we are repairing
+ * an image), the we have to turn off direct IO because we cannot do IO
+ * smaller than the host filesystem's sector size.
+ */
+static void
+check_fs_vs_host_sectsize(
+	struct xfs_sb	*sb)
+{
+	int	fd;
+	long	old_flags;
+	struct xfs_fsop_geom_v1 geom = { 0 };
+
+	fd = libxfs_device_to_fd(x.ddev);
+
+	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+		do_log(_("Cannot get host filesystem geometry.\n"
+	"Repair may fail if there is a sector size mismatch between\n"
+	"the image and the host filesystem.\n"));
+		geom.sectsize = BBSIZE;
+	}
+
+	if (sb->sb_sectsize < geom.sectsize) {
+		old_flags = fcntl(fd, F_GETFL, 0);
+		if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
+			do_warn(_(
+	"Sector size on host filesystem larger than image sector size.\n"
+	"Cannot turn off direct IO, so exiting.\n"));
+			exit(1);
+		}
+	}
+}
+
 int
 main(int argc, char **argv)
 {
@@ -657,6 +691,25 @@ main(int argc, char **argv)
 	timestamp(PHASE_START, 0, NULL);
 	timestamp(PHASE_END, 0, NULL);
 
+	/* -f forces this, but let's be nice and autodetect it, as well. */
+	if (!isa_file) {
+		int		fd = libxfs_device_to_fd(x.ddev);
+		struct stat	statbuf;
+
+		if (fstat(fd, &statbuf) < 0)
+			do_warn(_("%s: couldn't stat \"%s\"\n"),
+				progname, fs_name);
+		else if (S_ISREG(statbuf.st_mode))
+			isa_file = 1;
+	}
+
+	if (isa_file) {
+		/* Best effort attempt to validate fs vs host sector size */
+		rval = get_sb(&psb, 0, XFS_MAX_SECTORSIZE, 0);
+		if (rval == XR_OK)
+			check_fs_vs_host_sectsize(&psb);
+	}
+
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
 	timestamp(PHASE_END, 1, NULL);
@@ -675,47 +728,12 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	/* -f forces this, but let's be nice and autodetect it, as well. */
-	if (!isa_file) {
-		int		fd = libxfs_device_to_fd(x.ddev);
-		struct stat	statbuf;
-
-		if (fstat(fd, &statbuf) < 0)
-			do_warn(_("%s: couldn't stat \"%s\"\n"),
-				progname, fs_name);
-		else if (S_ISREG(statbuf.st_mode))
-			isa_file = 1;
-	}
-
 	/*
-	 * if the sector size of the filesystem we are trying to repair is
-	 * smaller than that of the underlying filesystem (i.e. we are repairing
-	 * an image), the we have to turn off direct IO because we cannot do IO
-	 * smaller than the host filesystem's sector size.
+	 * Now that we have completely validated the superblock, geometry may
+	 * have changed; re-check geometry vs the host filesystem geometry
 	 */
-	if (isa_file) {
-		int     fd = libxfs_device_to_fd(x.ddev);
-		struct xfs_fsop_geom_v1 geom = { 0 };
-
-		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
-			do_log(_("Cannot get host filesystem geometry.\n"
-		"Repair may fail if there is a sector size mismatch between\n"
-		"the image and the host filesystem.\n"));
-			geom.sectsize = BBSIZE;
-		}
-
-		if (psb.sb_sectsize < geom.sectsize) {
-			long	old_flags;
-
-			old_flags = fcntl(fd, F_GETFL, 0);
-			if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
-				do_warn(_(
-		"Sector size on host filesystem larger than image sector size.\n"
-		"Cannot turn off direct IO, so exiting.\n"));
-				exit(1);
-			}
-		}
-	}
+	if (isa_file)
+		check_fs_vs_host_sectsize(&psb);
 
 	/*
 	 * Prepare the mount structure. Point the log reference to our local
-- 
2.7.4

