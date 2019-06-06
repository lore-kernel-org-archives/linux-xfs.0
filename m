Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbfFFT5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 15:57:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Jm2qQ004400
        for <linux-xfs@vger.kernel.org>; Thu, 6 Jun 2019 12:57:35 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy5hk11ug-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2019 12:57:34 -0700
From: Sheena Artrip <sheenobu@fb.com>
Subject: [PATCH v2] xfs_restore: detect rtinherit on destination
Date: Thu, 6 Jun 2019 12:57:24 -0700
Message-ID: <20190606195724.2975689-1-sheenobu@fb.com>
In-Reply-To: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sheena.artrip@gmail.com, linux-xfs@vger.kernel.org, Sheena Artrip <sheenobu@fb.com>

When running xfs_restore with a non-rtdev dump,
it will ignore any rtinherit flags on the destination
and send I/O to the metadata region.

Instead, detect rtinherit on the destination XFS fileystem root inode
and use that to override the incoming inode flags.

Original version of this patch missed some branches so multiple
invocations of xfsrestore onto the same fs caused
the rtinherit bit to get re-removed. There could be some
additional edge cases in non-realtime to realtime workflows so
the outstanding question would be: is it worth supporting?

Changes in v2:
* Changed root inode bulkstat to just ioctl to the destdir inode

Signed-off-by: Sheena Artrip <sheenobu@fb.com>
---
 restore/content.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/restore/content.c b/restore/content.c
index 6b22965..4822d1c 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -670,6 +670,9 @@ struct tran {
 		/* to establish critical regions while updating pers
 		 * inventory
 		 */
+	bool_t t_dstisrealtime;
+		/* to force the realtime flag on incoming inodes
+		 */
 };
 
 typedef struct tran tran_t;
@@ -1803,6 +1806,37 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		free_handle(fshanp, fshlen);
 	}
 
+	/* determine if destination root inode has rtinherit.
+	 * If so, we should force XFS_REALTIME on the incoming inodes.
+	 */
+	if (persp->a.dstdirisxfspr) {
+		struct fsxattr dstxattr;
+
+		int dstfd = open(persp->a.dstdir, O_RDONLY);
+		if (dstfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
+					_("open of %s failed: %s\n"),
+					persp->a.dstdir,
+					strerror(errno));
+			return BOOL_FALSE;
+		}
+
+		/* Get the xattr details for the destination folder */
+		if (ioctl(dstfd, XFS_IOC_FSGETXATTR, &dstxattr) < 0) {
+			(void)close(dstfd);
+			mlog(MLOG_ERROR,
+			      _("failed to get xattr information for dst inode\n"));
+			return BOOL_FALSE;
+		}
+
+		(void)close(dstfd);
+
+		/* test against rtinherit */
+		if((dstxattr.fsx_xflags & XFS_XFLAG_RTINHERIT) != 0) {
+			tranp->t_dstisrealtime = true;
+		}
+	}
+
 	/* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
 	 * referenced ONLY via the macros provided; the descriptors will be
 	 * occasionally remapped, causing the ptr to change.
@@ -7270,6 +7304,10 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 	bool_t ahcs = contextp->cb_ahcs;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 
+	if (tranp->t_dstisrealtime) {
+		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	int rval;
 	bool_t ok;
 
@@ -7480,6 +7518,10 @@ restore_reg(drive_t *drivep,
 	if (tranp->t_toconlypr)
 		return BOOL_TRUE;
 
+	if (tranp->t_dstisrealtime) {
+	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	oflags = O_CREAT | O_RDWR;
 	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
 		oflags |= O_DIRECT;
@@ -8470,6 +8512,11 @@ restore_extent(filehdr_t *fhdrp,
 		}
 		assert(new_off == off);
 	}
+
+	if (tranp->t_dstisrealtime) {
+	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
 		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
@@ -8729,6 +8776,10 @@ restore_extattr(drive_t *drivep,
 
 	assert(extattrbufp);
 
+	if (tranp->t_dstisrealtime) {
+		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
+	}
+
 	if (!isdirpr)
 		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
 
-- 
2.17.1
