Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751820AbdH2Xu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:50:58 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002bs-Cr
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005VR-Bb
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/42] mkfs: make subopt table const
Date: Wed, 30 Aug 2017 09:50:12 +1000
Message-Id: <20170829235052.21050-3-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Use const for all the tables to remove most of the (char **) casts.
This adds a couple of temporary (const char **) casts that go away
as the input parsing is factored.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e16e73f86cbc..43f631a647b4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -24,11 +24,11 @@
 /*
  * Prototypes for internal functions.
  */
-static void conflict(char opt, char *tab[], int oldidx, int newidx);
+static void conflict(char opt, const char *tab[], int oldidx, int newidx);
 static void illegal(const char *value, const char *opt);
 static __attribute__((noreturn)) void usage (void);
-static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
-static void respec(char opt, char *tab[], int idx);
+static __attribute__((noreturn)) void reqval(char opt, const char *tab[], int idx);
+static void respec(char opt, const char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
 
@@ -1287,7 +1287,7 @@ check_opt(
 		fprintf(stderr,
 	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
 			sp->index, index);
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opts->name, opts->subopts, index);
 	}
 
 	/*
@@ -1300,11 +1300,11 @@ check_opt(
 	 */
 	if (!str_seen) {
 		if (sp->seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opts->name, opts->subopts, index);
 		sp->seen = true;
 	} else {
 		if (sp->str_seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opts->name, opts->subopts, index);
 		sp->str_seen = true;
 	}
 
@@ -1316,7 +1316,7 @@ check_opt(
 			break;
 		if (opts->subopt_params[conflict_opt].seen ||
 		    opts->subopt_params[conflict_opt].str_seen)
-			conflict(opts->name, (char **)opts->subopts,
+			conflict(opts->name, opts->subopts,
 				 conflict_opt, index);
 	}
 }
@@ -1334,7 +1334,7 @@ getnum(
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
-			reqval(opts->name, (char **)opts->subopts, index);
+			reqval(opts->name, opts->subopts, index);
 		return sp->defaultval;
 	}
 
@@ -1390,7 +1390,7 @@ getstr(
 
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opts->name, opts->subopts, index);
 	return str;
 }
 
@@ -1786,7 +1786,7 @@ main(
 					break;
 				case M_UUID:
 					if (!value || *value == '\0')
-						reqval('m', subopts, M_UUID);
+						reqval('m', (const char **)subopts, M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
 					break;
@@ -1900,7 +1900,7 @@ main(
 				case S_LOG:
 				case S_SECTLOG:
 					if (lssflag)
-						conflict('s', subopts,
+						conflict('s', (const char **)subopts,
 							 S_SECTSIZE, S_SECTLOG);
 					sectorlog = getnum(value, &sopts,
 							   S_SECTLOG);
@@ -1912,7 +1912,7 @@ main(
 				case S_SIZE:
 				case S_SECTSIZE:
 					if (lslflag)
-						conflict('s', subopts, S_SECTLOG,
+						conflict('s', (const char **)subopts, S_SECTLOG,
 							 S_SECTSIZE);
 					sectorsize = getnum(value, &sopts,
 							    S_SECTSIZE);
@@ -3368,7 +3368,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 static void
 conflict(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		oldidx,
 	int		newidx)
 {
@@ -3397,7 +3397,7 @@ ispow2(
 static void __attribute__((noreturn))
 reqval(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, _("-%c %s option requires a value\n"), opt, tab[idx]);
@@ -3407,7 +3407,7 @@ reqval(
 static void
 respec(
 	char		opt,
-	char		*tab[],
+	const char	*tab[],
 	int		idx)
 {
 	fprintf(stderr, "-%c ", opt);
-- 
2.13.3

