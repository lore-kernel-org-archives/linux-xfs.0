Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 869E37F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 21:56:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6820E304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 19:56:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id g4sneI0rRtKkKRgP for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 19:56:29 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 01B2B63BD802
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 21:56:28 -0500 (CDT)
Message-ID: <5256175C.6020000@sandeen.net>
Date: Wed, 09 Oct 2013 21:56:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: get fsstress DIO working on non-xfs filesystems
References: <4B54C8AB.6080607@sandeen.net>
In-Reply-To: <4B54C8AB.6080607@sandeen.net>
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

Pretty sure all DIO IO fails in fsstress today since XFS_IOC_DIOINFO
fails.  If so, rather than just bailing out on the op, assign
some sane default DIO parameters, getting min IO size from
sector size if possible.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: factor out get_alignment, use BLKSSZGET for min DIO size
rather than guessing at 512.


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 5d5611f..af06059 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -550,6 +550,27 @@ int main(int argc, char **argv)
 	return 0;
 }
 
+/*
+ * Get alignment via XFS_IOC_DIOINFO, else fall back to
+ * best guess from BLKSSZGET, else return -1.
+ */
+static int
+get_alignment(pathname_t *f, int fd, struct dioattr *dio)
+{
+	if (xfsctl(f->path, fd, XFS_IOC_DIOINFO, dio) < 0) {
+		int sectorsize;
+
+		if (ioctl(fd, BLKSSZGET, &sectorsize) < 0)
+			return -1;
+
+		dio->d_maxiosz = -1U;
+		dio->d_miniosz = sectorsize;
+		dio->d_mem = sectorsize;
+	}
+
+	return 0;
+}
+
 void
 add_to_flist(int ft, int id, int parent)
 {
@@ -1965,10 +1986,10 @@ dread_f(int opno, long r)
 		close(fd);
 		return;
 	}
-	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
+	if (get_alignment(&f, fd, &diob) < 0) {
 		if (v)
 			printf(
-			"%d/%d: dread - xfsctl(XFS_IOC_DIOINFO) %s%s failed %d\n",
+			"%d/%d: dread - get_alignment %s%s failed %d\n",
 				procid, opno, f.path, st, errno);
 		free_pathname(&f);
 		close(fd);
@@ -2037,9 +2058,9 @@ dwrite_f(int opno, long r)
 		return;
 	}
 	inode_info(st, sizeof(st), &stb, v);
-	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
+	if (get_alignment(&f, fd, &diob) < 0) {
 		if (v)
-			printf("%d/%d: dwrite - xfsctl(XFS_IOC_DIOINFO)"
+			printf("%d/%d: dwrite - get_alignment"
 				" %s%s failed %d\n",
 			       procid, opno, f.path, st, errno);
 		free_pathname(&f);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
