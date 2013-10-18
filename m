Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C27AC7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53CCDAC001
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:30:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id F7KVnHL7bOpcXUWK for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:30:23 -0700 (PDT)
Message-ID: <5261B67A.6000109@redhat.com>
Date: Fri, 18 Oct 2013 17:30:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs_fsr: fix SWAPEXT failures under selinux
References: <5261B11F.1040000@redhat.com>
In-Reply-To: <5261B11F.1040000@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

If we run xfs_fsr on a system which creates selinux extended
attributes, the temp file created by xfs_fsr may have a
large-ish local extended attribute as soon as it is created.

If the target file has NON-local extended attributes, it may
have a fork offset larger than the temp file, because i.e.
FMT_EXTENTS attributes take up less space.  We currently
have no mechanism to grow the temp file's fork offset.
So in this case, the SWAPEXT ioctl will fail.

(With systems using selinux and lots of xattrs, this becomes
fairly common in the real world.)

After testing the target file for a non-local extent, and
checking to see if the temp forkoff needs to be grown on the
first pass, we can add a large attr to knock all attributes on
the temp file out of local format, and grow the fork offset for
this particular case.

This passes xfstest 227, and also resolves issues seen on
a metadata image provided by Gabriel.

Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index c949f07..6f00b41 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1060,7 +1060,7 @@ fsr_setup_attr_fork(
 		char		name[64];
 
 		/*
-		 * bulkstat the temp inode  to see what the forkoff is. Use
+		 * bulkstat the temp inode to see what the forkoff is.  Use
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
@@ -1073,6 +1073,11 @@ fsr_setup_attr_fork(
 		if (dflag)
 			fsrprintf(_("orig forkoff %d, temp forkoff %d\n"),
 					bstatp->bs_forkoff, tbstat.bs_forkoff);
+		diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
+
+		/* if they are equal, we are done */
+		if (!diff)
+			goto out;
 
 		snprintf(name, sizeof(name), "user.%d", i);
 
@@ -1081,12 +1086,62 @@ fsr_setup_attr_fork(
 		 * an attribute fork at the default location.
 		 */
 		if (!tbstat.bs_forkoff) {
+			ASSERT(i == 0);
 			ret = fsetxattr(tfd, name, "XX", 2, XATTR_CREATE);
 			if (ret) {
 				fsrprintf(_("could not set ATTR\n"));
 				return -1;
 			}
 			continue;
+		} else if (i == 0) {
+			struct fsxattr	fsx;
+			/*
+			 * First pass, and temp file already has an inline
+			 * xattr, probably due to selinux.
+			 *
+			 * It's *possible* that the temp file attr area
+			 * is larger than the target file's, if the 
+			 * target file's attrs are not inline:
+			 *
+			 *  Target		 Temp
+			 * +-------+ 0		+-------+ 0
+			 * |	   |		|       |
+			 * |	   |		| Data  |
+			 * | Data  |		|       |
+			 * |	   |		v-------v forkoff
+			 * |	   |		|       |
+			 * v-------v forkoff	| Attr  | local
+			 * | Attr  | ext/btree	|       |
+			 * +-------+		+-------+
+			 *
+			 * FSGETXATTRA will tell us nr of attr extents in
+			 * target, if any.  If none, it's local:
+			 */
+
+			memset(&fsx, 0, sizeof(fsx));
+			if (ioctl(fd, XFS_IOC_FSGETXATTRA, &fsx)) {
+				fsrprintf(_("FSGETXATTRA failed on target\n"));
+				return -1;
+			}
+
+			/*
+			 * If target attr area is less than the temp's (diff < 0)
+			 * and the target is not local, write a big attr to
+			 * the temp file to knock the attr out of local format,
+			 * to match the target.  (This should actually *increase*
+			 * the temp file's forkoffset when the attr moves out
+			 * of the inode)
+			 */
+ 			if (diff < 0 && fsx.fsx_nextents > 0) {
+				char val[2048];
+				memset(val, 'X', 2048);
+				if (fsetxattr(tfd, name, val, 2048, 0)) {
+					fsrprintf(_("big ATTR set failed\n"));
+					return -1;
+				}
+				/* Go back & see where we're at now */
+				continue;
+			}
 		}
 
 		/*
@@ -1101,19 +1156,14 @@ fsr_setup_attr_fork(
 		last_forkoff = tbstat.bs_forkoff;
 
 		/* work out which way to grow the fork */
-		diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
 		if (abs(diff) > fsgeom.inodesize - sizeof(struct xfs_dinode)) {
 			fsrprintf(_("forkoff diff %d too large!\n"), diff);
 			return -1;
 		}
 
-		/* if they are equal, we are done */
-		if (!diff)
-			goto out;
-
 		/*
-		 * if the temp inode fork offset is smaller then we have to
-		 * grow the data fork
+		 * if the temp inode fork offset is still smaller then we have
+		 * to grow the data fork
 		 */
 		if (diff < 0) {
 			/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
