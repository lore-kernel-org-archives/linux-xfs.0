Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917DDC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72323206F9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCXATg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:19:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43008 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbgCXATf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:19:35 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D14107EB057
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 11:19:31 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-00057Q-Mv
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-0004h5-E2
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] mkfs: use cvtnum from libfrog
Date:   Tue, 24 Mar 2020 11:19:24 +1100
Message-Id: <20200324001928.17894-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200324001928.17894-1-david@fromorbit.com>
References: <20200324001928.17894-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=yPCof4ZbAAAA:8 a=ihEym0ZacZWdIiCorzoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move the checks for zero block/sector size to the libfrog code
and return -1LL as an invalid value instead. Catch the invalid
value in mkfs and error out there instead of inside cvtnum.

Also rename the libfrog block/sector size variables so they don't
shadow the mkfs global variables of the same name and mark the
string being passed in as a const.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_multidisk.h |  3 --
 libfrog/convert.c       | 14 +++++---
 libfrog/convert.h       |  2 +-
 mkfs/proto.c            |  2 +-
 mkfs/xfs_mkfs.c         | 72 ++++-------------------------------------
 5 files changed, 18 insertions(+), 75 deletions(-)

diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index 79500ed95a38..1b9936ec768c 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -42,9 +42,6 @@
 #define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
 #define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
 
-extern long long cvtnum(unsigned int blksize, unsigned int sectsize,
-			const char *str);
-
 /* proto.c */
 extern char *setup_proto (char *fname);
 extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
diff --git a/libfrog/convert.c b/libfrog/convert.c
index 8d4d4077b331..6b8ff30de24a 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -182,9 +182,9 @@ cvt_u16(
 
 long long
 cvtnum(
-	size_t		blocksize,
-	size_t		sectorsize,
-	char		*s)
+	size_t		blksize,
+	size_t		sectsize,
+	const char	*s)
 {
 	long long	i;
 	char		*sp;
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
diff --git a/libfrog/convert.h b/libfrog/convert.h
index 321540aa630c..b307d31ce955 100644
--- a/libfrog/convert.h
+++ b/libfrog/convert.h
@@ -14,7 +14,7 @@ extern uint64_t	cvt_u64(char *s, int base);
 extern uint32_t	cvt_u32(char *s, int base);
 extern uint16_t	cvt_u16(char *s, int base);
 
-extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
+extern long long cvtnum(size_t blocksize, size_t sectorsize, const char *s);
 extern void cvtstr(double value, char *str, size_t sz);
 extern unsigned long cvttime(char *s);
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ab01c8b0d178..01b30c5f1b15 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -6,7 +6,7 @@
 
 #include "libxfs.h"
 #include <sys/stat.h>
-#include "xfs_multidisk.h"
+#include "libfrog/convert.h"
 
 /*
  * Prototypes for internal functions.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 19a8e6d1d344..f14ce8db5a74 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -10,6 +10,7 @@
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/topology.h"
+#include "libfrog/convert.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
@@ -942,69 +943,6 @@ unknown(
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
@@ -1374,9 +1312,13 @@ getnum(
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
2.26.0.rc2

