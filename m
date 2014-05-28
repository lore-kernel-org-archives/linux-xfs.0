Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B6267F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 19:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C965304039
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 17:14:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DDutHLO1O5CbO0DA for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 17:14:24 -0700 (PDT)
Message-ID: <53852A61.90400@sandeen.net>
Date: Tue, 27 May 2014 19:14:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2,
	RFC] xfsprogs: check fs sector size in platform_findsizes()
References: <53852A05.5040006@redhat.com>
In-Reply-To: <53852A05.5040006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Try the xfs geometry ioctl if the mkfs target resides
in a file; this gives us the equivalent of a device
sector size.

This does, however, emit a warning if the target file
exists on a non-XFS filesystem, and that might not be super.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2e07d54..d66a90f 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -141,10 +141,19 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 		exit(1);
 	}
 	if ((st.st_mode & S_IFMT) == S_IFREG) {
+		struct xfs_fsop_geom_v1 geom = { 0 };
+
 		*sz = (long long)(st.st_size >> 9);
-		*bsz = BBSIZE;
-		if (BBSIZE > max_block_alignment)
-			max_block_alignment = BBSIZE;
+		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+			fprintf(stderr, _("Cannot get host filesystem geometry.\n"
+	"mkfs may fail if there is a sector size mismatch between\n"
+	"the image and the host filesystem.\n"));
+			*bsz = BBSIZE;
+		} else
+			*bsz = geom.sectsize;
+
+		if (*bsz > max_block_alignment)
+			max_block_alignment = *bsz;
 		return;
 	}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
