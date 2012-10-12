Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CGIOlX190141 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 11:18:24 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NxO689c9azAY4gCs for
	<xfs@oss.sgi.com>; Fri, 12 Oct 2012 09:19:57 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9CGJvba025631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 12:19:57 -0400
Message-ID: <5078432B.6050501@redhat.com>
Date: Fri, 12 Oct 2012 11:19:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_quota: XFS_XFLAG_PROJINHERIT is only for dirs
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
Cc: nscott@redhat.com, Dave Chinner <dchinner@redhat.com>

xfs_quota has long set XFS_XFLAG_PROJINHERIT on all files,
and tested for presence on all files.  However, Dave's semi-recent
xfs_repair update is now flagging this as an error:

bd5683f xfs_repair: validate inode di_flags field

       if (flags & (XFS_DIFLAG_RTINHERIT |
                    XFS_DIFLAG_EXTSZINHERIT |
                    XFS_DIFLAG_PROJINHERIT |
                    XFS_DIFLAG_NOSYMLINKS)) {
               /* must be a directory */
               if (di_mode && !S_ISDIR(di_mode)) {
                       do_warn(_(
               "directory flags set on non-directory inode %llu"),
                               lino);

In tests 050, 107, 134, 244, 261 and 287, inserting a _check_scratch_fs
will cause them to fail due to repair finding these errors.

On the one hand, quota has set this flag everywhere for many years.  On
the other hand, an *INHERIT flag makes no sense on a non-dir.  So I think
the right way to go is to tell quota to stop setting (and checking for)
the flag unconditionally, and do it only for S_ISDIR.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

note: A little unsure of the new check in check_project.  Should we just
leave that to repair?

diff --git a/quota/project.c b/quota/project.c
index a2c7046..7042015 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -126,8 +126,11 @@ check_project(
 			printf(_("%s - project identifier is not set"
 				 " (inode=%u, tree=%u)\n"),
 				path, fsx.fsx_projid, (unsigned int)prid);
-		if (!(fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT))
-			printf(_("%s - project inheritance flag is not set\n"),
+		if (S_ISDIR(stat->st_mode) && !(fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT))
+			printf(_("%s - project inheritance flag is not set on dir\n"),
+				path);
+		if (!S_ISDIR(stat->st_mode) && (fsx.fsx_xflags & XFS_XFLAG_PROJINHERIT))
+			printf(_("%s - project inheritance flag is set on non-dir\n"),
 				path);
 	}
 	if (fd != -1)
@@ -219,7 +222,8 @@ setup_project(
 	}
 
 	fsx.fsx_projid = prid;
-	fsx.fsx_xflags |= XFS_XFLAG_PROJINHERIT;
+	if (S_ISDIR(stat->st_mode))
+		fsx.fsx_xflags |= XFS_XFLAG_PROJINHERIT;
 	if (xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx) < 0) {
 		exitcode = 1;
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
