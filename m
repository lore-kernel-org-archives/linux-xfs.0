Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34648 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfHMFO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 01:14:26 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 05FD52AD503
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 15:14:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxP7S-0005LK-Sb
        for linux-xfs@vger.kernel.org; Tue, 13 Aug 2019 15:13:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxP8Z-0005aN-8e
        for linux-xfs@vger.kernel.org; Tue, 13 Aug 2019 15:14:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] mkfs: use cvtnum from libfrog
Date: Tue, 13 Aug 2019 15:14:19 +1000
Message-Id: <20190813051421.21137-2-david@fromorbit.com>
In-Reply-To: <20190813051421.21137-1-david@fromorbit.com>
References: <20190813051421.21137-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move the checks for zero block/sector size to the libfrog code
and return -1LL as an invalid value instead. Catch the invalid
value in mkfs and error out there instead of inside cvtnum.

Also rename the libfrog block/sector size variables so they don't
shadow the mkfs global variables of the same name.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libfrog/convert.c | 12 +++++---
 mkfs/xfs_mkfs.c   | 71 ++++-------------------------------------------
 2 files changed, 14 insertions(+), 69 deletions(-)

diff --git a/libfrog/convert.c b/libfrog/convert.c
index 8d4d4077b331..b5f3fc1238dd 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -182,8 +182,8 @@ cvt_u16(
 
 long long
 cvtnum(
-	size_t		blocksize,
-	size_t		sectorsize,
+	size_t		blksize,
+	size_t		sectsize,
 	char		*s)
 {
 	long long	i;
@@ -202,9 +202,13 @@ cvtnum(
 	c = tolower(*sp);
 	switch (c) {
 	case 'b':
-		return i * blocksize;
+		if (!blksize)
+			return -1LL;
+		return i * blksize;
 	case 's':
-		return i * sectorsize;
+		if (!sectsize)
+			return -1LL;
+		return i * sectsize;
 	case 'k':
 		return KILOBYTES(i);
 	case 'm':
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0adaa65d19f8..04063ca5b2c7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -942,69 +942,6 @@ unknown(
 	usage();
 }
 
-long long
-cvtnum(
-	unsigned int	blksize,
-	unsigned int	sectsize,
-	const char	*s)
-{
-	long long	i;
-	char		*sp;
-	int		c;
-
-	i = strtoll(s, &sp, 0);
-	if (i == 0 && sp == s)
-		return -1LL;
-	if (*sp == '\0')
-		return i;
-
-	if (sp[1] != '\0')
-		return -1LL;
-
-	if (*sp == 'b') {
-		if (!blksize) {
-			fprintf(stderr,
-_("Blocksize must be provided prior to using 'b' suffix.\n"));
-			usage();
-		} else {
-			return i * blksize;
-		}
-	}
-	if (*sp == 's') {
-		if (!sectsize) {
-			fprintf(stderr,
-_("Sectorsize must be specified prior to using 's' suffix.\n"));
-			usage();
-		} else {
-			return i * sectsize;
-		}
-	}
-
-	c = tolower(*sp);
-	switch (c) {
-	case 'e':
-		i *= 1024LL;
-		/* fall through */
-	case 'p':
-		i *= 1024LL;
-		/* fall through */
-	case 't':
-		i *= 1024LL;
-		/* fall through */
-	case 'g':
-		i *= 1024LL;
-		/* fall through */
-	case 'm':
-		i *= 1024LL;
-		/* fall through */
-	case 'k':
-		return i * 1024LL;
-	default:
-		break;
-	}
-	return -1LL;
-}
-
 static void
 check_device_type(
 	const char	*name,
@@ -1347,9 +1284,13 @@ getnum(
 	 * convert it ourselves to guarantee there is no trailing garbage in the
 	 * number.
 	 */
-	if (sp->convert)
+	if (sp->convert) {
 		c = cvtnum(blocksize, sectorsize, str);
-	else {
+		if (c == -1LL) {
+			illegal_option(str, opts, index,
+				_("Not a valid value or illegal suffix"));
+		}
+	} else {
 		char		*str_end;
 
 		c = strtoll(str, &str_end, 0);
-- 
2.23.0.rc1
