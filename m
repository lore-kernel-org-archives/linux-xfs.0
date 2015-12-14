Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FCD67F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 11:16:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E45198F804B
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 09:16:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nHosZ2kAclYaAOr6 for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 09:16:15 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2EA976214D38
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 11:16:15 -0600 (CST)
Subject: [PATCH V2] mkfs: get sector size from host fs d_miniosz when mkfs'ing
	file
References: <5660CD5E.2040209@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <566EF95E.1050706@sandeen.net>
Date: Mon, 14 Dec 2015 11:16:14 -0600
MIME-Version: 1.0
In-Reply-To: <5660CD5E.2040209@redhat.com>
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
To: xfs@oss.sgi.com

Now that we allow logical-sector-sized DIOs even if our xfs
filesystem is set to physical-sector-sized "sectors," we can
allow the creation of filesystem images with block and sector
sizes down to the host device's logical sector size, rather
than the filesystem's sector size.

So in platform_findsizes(), change our query of the filesystem
to an XFS_IOC_DIOINFO query, and use the returned d_miniosz for
sector size in the S_IFREG case.

This allows the creation of i.e. a 2k block sized image on
an xfs filesystem w/ 4k sector size created on a 4k/512
block device, which would otherwise fail today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Just use XFS_IOC_DIOINFO to get the minimum DIO size,
thanks Dave.

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 885016a..f6ea1b2 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -142,18 +142,20 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 			progname, path, strerror(errno));
 		exit(1);
 	}
+
 	if ((st.st_mode & S_IFMT) == S_IFREG) {
-		struct xfs_fsop_geom_v1 geom = { 0 };
+		struct dioattr	da;
 
 		*sz = (long long)(st.st_size >> 9);
-		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
+
+		if (ioctl(fd, XFS_IOC_DIOINFO, &da) < 0) {
 			/*
 			 * fall back to BBSIZE; mkfs might fail if there's a
 			 * size mismatch between the image & the host fs...
 			 */
 			*bsz = BBSIZE;
 		} else
-			*bsz = geom.sectsize;
+			*bsz = da.d_miniosz;
 
 		if (*bsz > max_block_alignment)
 			max_block_alignment = *bsz;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
