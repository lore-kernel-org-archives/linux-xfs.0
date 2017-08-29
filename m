Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbdH2XvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:01 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0002e5-GR
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHX-0005XK-Eo
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 41/42] mkfs: move error functions
Date: Wed, 30 Aug 2017 09:50:51 +1000
Message-Id: <20170829235052.21050-42-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Move all the error and helper functions like conflict() to the top
of the file so we can get rid of the forward declarations.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 324 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 157 insertions(+), 167 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9d087bc068a7..c01dc11882d9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -21,16 +21,6 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 
-/*
- * Prototypes for internal functions.
- */
-static void conflict(char opt, const char *tab[], int oldidx, int newidx);
-static void illegal(const char *value, const char *opt);
-static __attribute__((noreturn)) void usage (void);
-static __attribute__((noreturn)) void reqval(char opt, const char *tab[], int idx);
-static void respec(char opt, const char *tab[], int idx);
-static void unknown(char opt, char *s);
-static int  ispow2(unsigned int i);
 
 /*
  * XXX: The configured block and sector sizes are defined as global variables so
@@ -896,6 +886,163 @@ struct mkfs_default_params {
  */
 #define WHACK_SIZE (128 * 1024)
 
+static void __attribute__((noreturn))
+usage( void )
+{
+	fprintf(stderr, _("Usage: %s\n\
+/* blocksize */		[-b log=n|size=num]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
+/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
+			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
+			    sectlog=n|sectsize=num\n\
+/* force overwrite */	[-f]\n\
+/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
+			    projid32bit=0|1,sparse=0|1]\n\
+/* no discard */	[-K]\n\
+/* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
+			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
+			    lazy-count=0|1]\n\
+/* label */		[-L label (maximum 12 characters)]\n\
+/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
+/* no-op info only */	[-N]\n\
+/* prototype file */	[-p fname]\n\
+/* quiet */		[-q]\n\
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
+/* sectorsize */	[-s log=n|size=num]\n\
+/* version */		[-V]\n\
+			devicename\n\
+<devicename> is required unless -d name=xxx is given.\n\
+<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),\n\
+      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).\n\
+<value> is xxx (512 byte blocks).\n"),
+		progname);
+	exit(1);
+}
+
+static void
+conflict(
+	char		opt,
+	const char	*tab[],
+	int		oldidx,
+	int		newidx)
+{
+	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
+		opt, tab[oldidx], opt, tab[newidx]);
+	usage();
+}
+
+
+static void
+illegal(
+	const char	*value,
+	const char	*opt)
+{
+	fprintf(stderr, _("Illegal value %s for -%s option\n"), value, opt);
+	usage();
+}
+
+static int
+ispow2(
+	unsigned int	i)
+{
+	return (i & (i - 1)) == 0;
+}
+
+static void __attribute__((noreturn))
+reqval(
+	char		opt,
+	const char	*tab[],
+	int		idx)
+{
+	fprintf(stderr, _("-%c %s option requires a value\n"), opt, tab[idx]);
+	usage();
+}
+
+static void
+respec(
+	char		opt,
+	const char	*tab[],
+	int		idx)
+{
+	fprintf(stderr, "-%c ", opt);
+	if (tab)
+		fprintf(stderr, "%s ", tab[idx]);
+	fprintf(stderr, _("option respecified\n"));
+	usage();
+}
+
+static void
+unknown(
+	char		opt,
+	char		*s)
+{
+	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
+	usage();
+}
+
+long long
+cvtnum(
+	unsigned int	blksize,
+	unsigned int	sectsize,
+	const char	*s)
+{
+	long long	i;
+	char		*sp;
+	int		c;
+
+	i = strtoll(s, &sp, 0);
+	if (i == 0 && sp == s)
+		return -1LL;
+	if (*sp == '\0')
+		return i;
+
+	if (sp[1] != '\0')
+		return -1LL;
+
+	if (*sp == 'b') {
+		if (!blksize) {
+			fprintf(stderr,
+_("Blocksize must be provided prior to using 'b' suffix.\n"));
+			usage();
+		} else {
+			return i * blksize;
+		}
+	}
+	if (*sp == 's') {
+		if (!sectsize) {
+			fprintf(stderr,
+_("Sectorsize must be specified prior to using 's' suffix.\n"));
+			usage();
+		} else {
+			return i * sectsize;
+		}
+	}
+
+	c = tolower(*sp);
+	switch (c) {
+	case 'e':
+		i *= 1024LL;
+		/* fall through */
+	case 'p':
+		i *= 1024LL;
+		/* fall through */
+	case 't':
+		i *= 1024LL;
+		/* fall through */
+	case 'g':
+		i *= 1024LL;
+		/* fall through */
+	case 'm':
+		i *= 1024LL;
+		/* fall through */
+	case 'k':
+		return i * 1024LL;
+	default:
+		break;
+	}
+	return -1LL;
+}
+
 static void
 check_device_type(
 	const char	*name,
@@ -3920,160 +4067,3 @@ main(
 
 	return 0;
 }
-
-static void
-conflict(
-	char		opt,
-	const char	*tab[],
-	int		oldidx,
-	int		newidx)
-{
-	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
-		opt, tab[oldidx], opt, tab[newidx]);
-	usage();
-}
-
-
-static void
-illegal(
-	const char	*value,
-	const char	*opt)
-{
-	fprintf(stderr, _("Illegal value %s for -%s option\n"), value, opt);
-	usage();
-}
-
-static int
-ispow2(
-	unsigned int	i)
-{
-	return (i & (i - 1)) == 0;
-}
-
-static void __attribute__((noreturn))
-reqval(
-	char		opt,
-	const char	*tab[],
-	int		idx)
-{
-	fprintf(stderr, _("-%c %s option requires a value\n"), opt, tab[idx]);
-	usage();
-}
-
-static void
-respec(
-	char		opt,
-	const char	*tab[],
-	int		idx)
-{
-	fprintf(stderr, "-%c ", opt);
-	if (tab)
-		fprintf(stderr, "%s ", tab[idx]);
-	fprintf(stderr, _("option respecified\n"));
-	usage();
-}
-
-static void
-unknown(
-	char		opt,
-	char		*s)
-{
-	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
-	usage();
-}
-
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
-static void __attribute__((noreturn))
-usage( void )
-{
-	fprintf(stderr, _("Usage: %s\n\
-/* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
-/* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
-			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
-			    sectlog=n|sectsize=num\n\
-/* force overwrite */	[-f]\n\
-/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1,sparse=0|1]\n\
-/* no discard */	[-K]\n\
-/* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
-			    lazy-count=0|1]\n\
-/* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
-/* no-op info only */	[-N]\n\
-/* prototype file */	[-p fname]\n\
-/* quiet */		[-q]\n\
-/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
-/* sectorsize */	[-s log=n|size=num]\n\
-/* version */		[-V]\n\
-			devicename\n\
-<devicename> is required unless -d name=xxx is given.\n\
-<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),\n\
-      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).\n\
-<value> is xxx (512 byte blocks).\n"),
-		progname);
-	exit(1);
-}
-- 
2.13.3

