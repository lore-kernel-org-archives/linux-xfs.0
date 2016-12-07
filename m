Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbcLGNgn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:36:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 148BEC01BB21
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:50 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 09/22] mkfs: change conflict checks to utilize the new conflict structure
Date: Wed,  7 Dec 2016 14:27:16 +0100
Message-Id: <1481117249-21273-10-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Bring the conflicts detection up to date with conflicts declaration.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 30618ff..d11fad6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1372,7 +1372,7 @@ illegal_option(
  * Check for conflicts and option respecification.
  */
 static void
-check_opt(
+check_subopt_conflicts(
 	struct opt_params	*opt,
 	int			index,
 	bool			str_seen)
@@ -1424,7 +1424,7 @@ check_opt(
  * Check for conflict values between options.
  */
 static void
-check_opt_value(
+check_subopt_value(
 	struct opt_params	*opt,
 	int			index,
 	long long 		value)
@@ -1450,6 +1450,32 @@ check_opt_value(
 	}
 }
 
+/**
+ * Go through entire opt_params table and check every option for valid values
+ * and for conflicts.
+ */
+static void
+check_opt(
+	struct opt_params *opts,
+	int opti)
+{
+	int index;
+	struct opt_params *opt = &opts[opti];
+	for (index = 0; index < MAX_SUBOPTS; index++) {
+		struct subopt_param *sp = &opt->subopt_params[index];
+		check_subopt_conflicts(opt, index, false);
+		check_subopt_value(opt, index, sp->value);
+	}
+}
+static void
+check_all_opts(struct opt_params *opts)
+{
+	int opti;
+	for (opti = 0; opti < MAX_OPTS; opti++) {
+		check_opt(opts, opti);
+	}
+}
+
 static long long
 getnum(
 	const char		*str,
@@ -1459,7 +1485,6 @@ getnum(
 	struct subopt_param	*sp = &opts->subopt_params[index];
 	long long		c;
 
-	check_opt(opts, index, false);
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->defaultval == SUBOPT_NEEDS_VAL)
@@ -1493,8 +1518,6 @@ getnum(
 			illegal_option(str, opts, index, NULL);
 	}
 
-	check_opt_value(opts, index, c);
-
 	/* Validity check the result. */
 	if (c < sp->minval)
 		illegal_option(str, opts, index, _("value is too small"));
@@ -1517,7 +1540,7 @@ getstr(
 	struct opt_params	*opts,
 	int			index)
 {
-	check_opt(opts, index, true);
+	check_subopt(opts, index, true);
 
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
@@ -2213,6 +2236,8 @@ main(
 	} else
 		dfile = xi.dname;
 
+	check_all_opts(opts);
+
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
-- 
2.8.1

