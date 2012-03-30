Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UF1mEs118165 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 10:01:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BnUdcBAuWFJnAOM8 for
	<xfs@oss.sgi.com>; Fri, 30 Mar 2012 08:01:47 -0700 (PDT)
Message-ID: <4F75CAD9.60808@redhat.com>
Date: Fri, 30 Mar 2012 10:01:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs_fsr: create extent-based attr to grow forkoff
References: <4F75C939.6030009@redhat.com>
In-Reply-To: <4F75C939.6030009@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Gabriel VLASIU <gabriel@vlasiu.net>

In some cases the target file may have a non-local attribute,
but the temp file gets assigned a local attribute on creation,
due to selinux, for example.

In this case, the large-ish selinux attr will create a forkoff
in the temp file smaller than the forkoff in the target file,
because the FMT_EXTENTS attr takes up less space.  There is
no mechanism to grow the forkoff to match, so we can end up
failing to swap these 2 inodes if the result is not enough
data space in the temp inode as a result.

After testing the target file for a non-local extent, and
checking to see if the forkoff needs to be grown on the first
pass, we can add a large attr to knock all attributes of the
temp file out of local format, and grow the fork offset.

This passes xfstest 227, and also resolves issues seen on
a metadata image provided by Gabriel.

Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index d83bdc9..e8ab028 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1022,6 +1022,8 @@ fsr_setup_attr_fork(
 	struct stat64	tstatbuf;
 	int		i;
 	int		diff = 0;
+	struct fsxattr	fsx;
+	int		target_attr_local = 0;
 	int		last_forkoff = 0;
 	int		no_change_cnt = 0;
 	int		ret;
@@ -1052,6 +1054,11 @@ fsr_setup_attr_fork(
 		return -1;
 	}
 
+	memset(&fsx, 0, sizeof(fsx));
+	ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
+	if (fsx.fsx_nextents == 0)
+		target_attr_local = 1;
+
 	i = 0;
 	do {
 		xfs_bstat_t	tbstat;
@@ -1072,6 +1079,7 @@ fsr_setup_attr_fork(
 		if (dflag)
 			fsrprintf(_("orig forkoff %d, temp forkoff %d\n"),
 					bstatp->bs_forkoff, tbstat.bs_forkoff);
+		diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
 
 		snprintf(name, sizeof(name), "user.%d", i);
 
@@ -1086,6 +1094,21 @@ fsr_setup_attr_fork(
 				return -1;
 			}
 			continue;
+		} else if (i == 0 && diff < 0 && target_attr_local == 0) {
+			/*
+			 * A small attr may exist from eg selinux but, if the
+			 * target is not local, write a big attr to tempfile
+			 * to knock it out of local format to match target.
+			 * This should actually increase the temp forkoffset.
+			 */
+			char val[2048];
+			memset(val, 'X', 2048);
+			ret = fsetxattr(tfd, name, val, 2048, XATTR_CREATE);
+			if (ret) {
+				fsrprintf(_("could not set large ATTR\n"));
+				return -1;
+			}
+			continue;
 		}
 
 		/*
@@ -1100,7 +1123,6 @@ fsr_setup_attr_fork(
 		last_forkoff = tbstat.bs_forkoff;
 
 		/* work out which way to grow the fork */
-		diff = tbstat.bs_forkoff - bstatp->bs_forkoff;
 		if (abs(diff) > fsgeom.inodesize - sizeof(struct xfs_dinode)) {
 			fsrprintf(_("forkoff diff %d too large!\n"), diff);
 			return -1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
