Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IfMSJ253051 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:41:23 -0600
Received: from hades.usersys.redhat.com (186.215.132.159.static.gvt.net.br
	[186.215.132.159]) by cuda.sgi.com with ESMTP id
	856DZHGGh4OuuZjD for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 10:41:20 -0800 (PST)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_fsr: Get the last mount on a specific mount point
Date: Tue,  7 Feb 2012 16:41:16 -0200
Message-Id: <1328640076-12645-1-git-send-email-cmaiolino@redhat.com>
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

Actually xfs_fsr uses the first mount matching the mount point specified. Since
Linux allows more than one mount over the same mount point, the best to do is to
use the last mount found in /proc/mounts, instead of the first one.

Thanks to Eric Sandeen for suggesting the patch

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fsr/xfs_fsr.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 40c2e6f..4e6d706 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1646,7 +1646,9 @@ getmntany(FILE *fp, struct mntent *mp, struct mntent *mpref, struct stat64 *s)
 {
 	struct mntent *t;
 	struct stat64 ms;
+	int found = 0;
 
+	memset(mp, 0, sizeof(struct mntent));
 	while ((t = getmntent(fp))) {
 		if (mpref->mnt_fsname) {	/* device */
 			if (stat64(t->mnt_fsname, &ms) < 0)
@@ -1660,10 +1662,16 @@ getmntany(FILE *fp, struct mntent *mp, struct mntent *mpref, struct stat64 *s)
 			if (s->st_ino != ms.st_ino || s->st_dev != ms.st_dev)
 				continue;
 		}
-		*mp = *t;
-		break;
+
+		found = 1;
+		free(mp->mnt_fsname);
+		free(mp->mnt_dir);
+		free(mp->mnt_type);
+		mp->mnt_fsname = strdup(t->mnt_fsname);
+		mp->mnt_dir = strdup(t->mnt_dir);
+		mp->mnt_type = strdup(t->mnt_type);
 	}
-	return (t != NULL);
+	return (found);
 }
 
 
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
