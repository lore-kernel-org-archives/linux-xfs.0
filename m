Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 74F237F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 14:13:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A1548F8033
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 12:13:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id R8ChB95kNqyOxxEw for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 12:13:02 -0700 (PDT)
Message-ID: <5390C13E.6030205@sandeen.net>
Date: Thu, 05 Jun 2014 14:13:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2 V2] xfsprogs: try to handle mkfs of a file on 4k sector
	device
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

If this fails, and there's a sector size mismatch
between the host FS and the filesystem, then mkfs might
fail - but that's no worse than it's been before.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: remove warning when FSGEOMETRY fails (i.e. on non-xfs
filesystems) for now

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 2e07d54..3796fdd 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -141,10 +141,20 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
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
+			/*
+			 * fall back to BBSIZE; mkfs might fail if there's a
+			 * size mismatch between the image & the host fs...
+			 */
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
