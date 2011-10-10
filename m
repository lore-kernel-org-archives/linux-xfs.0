Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A18gGr136196 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:08:42 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 070BA1C7415B
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:08:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QKNHDyvlTj5FMMsz for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:08:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD4MA-0003mU-8p
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:38 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD4MA-0003ul-0u
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] repair: handle repair of image files on large sector size
	filesystems
Date: Mon, 10 Oct 2011 12:08:31 +1100
Message-Id: <1318208915-14975-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1318208915-14975-1-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Because repair uses direct IO, it cannot do IO smaller than a sector
on the underlying device. When repairing a filesystem image, the
filesystem hosting the image may have a sector size larger than the
sector size of the image, and so single image sector reads and
writes will fail.

To avoid this, when checking a file and there is a sector size
mismatch like this, turn off direct IO. While there, fix a compile
bug in the IO_DEBUG option for libxfs which was found during triage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c       |    2 +-
 repair/sb.c         |    9 ++++++++-
 repair/xfs_repair.c |   29 +++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fe8ae09..c3edb89 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -365,7 +365,7 @@ libxfs_getbufr(dev_t device, xfs_daddr_t blkno, int bblen)
 		libxfs_initbuf(bp, device, blkno, blen);
 #ifdef IO_DEBUG
 	printf("%lx: %s: allocated %u bytes buffer, key=%llu(%llu), %p\n",
-		pthread_self(), __FUNCTION__, BBTOB(len),
+		pthread_self(), __FUNCTION__, blen,
 		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
 
diff --git a/repair/sb.c b/repair/sb.c
index 6d2e91a..004319f 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -689,7 +689,14 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 	 */
 	num_sbs = MIN(NUM_SBS, rsb->sb_agcount);
 	skip = howmany(num_sbs, rsb->sb_agcount);
-	size = NUM_AGH_SECTS * rsb->sb_sectsize;
+
+	/*
+	 * We haven't been able to validate the sector size yet properly
+	 * (e.g. in the case of repairing an image in a file), so we need to
+	 * take into account sector mismatches and so use the maximum possible
+	 * sector size rather than the sector size in @rsb.
+	 */
+	size = NUM_AGH_SECTS * (1 << (XFS_MAX_SECTORSIZE_LOG));
 	retval = 0;
 	list = NULL;
 	num_ok = 0;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 4e2b022..69b7eab 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -569,6 +569,35 @@ main(int argc, char **argv)
 	memset(&xfs_m, 0, sizeof(xfs_mount_t));
 	libxfs_sb_from_disk(&xfs_m.m_sb, XFS_BUF_TO_SBP(sbp));
 
+	/*
+	 * if the sector size of the filesystem we are trying to repair is
+	 * smaller than that of the underlying filesystem (i.e. we are repairing
+	 * an image), the we have to turn off direct IO because we cannot do IO
+	 * smaller than the host filesystem's sector size.
+	 */
+	if (isa_file) {
+		int     fd = libxfs_device_to_fd(x.ddev);
+		struct xfs_fsop_geom_v1 geom = { 0 };
+
+		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+			do_warn(_("Cannot get host filesystem geometry.\n"
+		"Repair may fail if there is a sector size mismatch between\n"
+		"the image and the host filesystem.\n"));
+			geom.sectsize = BBSIZE;
+		}
+
+		if (xfs_m.m_sb.sb_sectsize < geom.sectsize) {
+			long	old_flags;
+
+			old_flags = fcntl(fd, F_GETFL, 0);
+			if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
+				do_warn(_(
+		"Sector size on host filesystem larger than image sector size.\n"
+		"Cannot turn off direct IO, so exiting.\n"));
+				exit(1);
+			}
+		}
+	}
 	mp = libxfs_mount(&xfs_m, &xfs_m.m_sb, x.ddev, x.logdev, x.rtdev, 0);
 
 	if (!mp)  {
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
