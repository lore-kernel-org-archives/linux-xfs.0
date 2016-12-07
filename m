Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932319AbcLGNhH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:37:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAACB3F1E7
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:45 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/22] mkfs: add a check for conflicting values
Date: Wed,  7 Dec 2016 14:27:12 +0100
Message-Id: <1481117249-21273-6-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a check that reports a conflict only when subopts are mixed with specific values.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 52 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b47cdae..3bb9f09 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1311,18 +1311,18 @@ illegal_option(
  */
 static void
 check_opt(
-	struct opt_params	*opts,
+	struct opt_params	*opt,
 	int			index,
 	bool			str_seen)
 {
-	struct subopt_param	*sp = &opts->subopt_params[index];
+	struct subopt_param	*sp = &opt->subopt_params[index];
 	int			i;
 
 	if (sp->index != index) {
 		fprintf(stderr,
 	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
 			sp->index, index);
-		reqval(opts->name, (char **)opts->subopts, index);
+		reqval(opt->name, (char **)opt->subopts, index);
 	}
 
 	/*
@@ -1335,11 +1335,11 @@ check_opt(
 	 */
 	if (!str_seen) {
 		if (sp->seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opt->name, (char **)opt->subopts, index);
 		sp->seen = true;
 	} else {
 		if (sp->str_seen)
-			respec(opts->name, (char **)opts->subopts, index);
+			respec(opt->name, (char **)opt->subopts, index);
 		sp->str_seen = true;
 	}
 
@@ -1349,10 +1349,44 @@ check_opt(
 
 		if (conflict_opt.opt == LAST_CONFLICT)
 			break;
-		if (opts->subopt_params[conflict_opt.subopt].seen ||
-		    opts->subopt_params[conflict_opt.subopt].str_seen)
-			conflict(opts->name, (char **)opts->subopts,
+		if (conflict_opt.test_values)
+			break;
+		if (opt->subopt_params[conflict_opt.subopt].seen ||
+		    opt->subopt_params[conflict_opt.subopt].str_seen) {
+			conflict(opt->name, (char **)opt->subopts,
 				 conflict_opt.subopt, index);
+		}
+	}
+}
+
+/*
+ * Check for conflict values between options.
+ */
+static void
+check_opt_value(
+	struct opt_params	*opt,
+	int			index,
+	long long 		value)
+{
+	struct subopt_param	*sp = &opt->subopt_params[index];
+	int			i;
+
+	/* check for conflicts with the option */
+	for (i = 0; i < MAX_CONFLICTS; i++) {
+		struct subopt_conflict conflict_opt = sp->conflicts[i];
+
+		if (conflict_opt.opt == LAST_CONFLICT)
+			break;
+		if (!conflict_opt.test_values)
+			break;
+		if ((opt->subopt_params[conflict_opt.subopt].seen ||
+				    opt->subopt_params[conflict_opt.subopt].str_seen) &&
+		    opt->subopt_params[conflict_opt.subopt].value
+				== conflict_opt.invalid_value &&
+		    value == conflict_opt.at_value) {
+			conflict(opt->name, (char **)opt->subopts,
+				 conflict_opt.subopt, index);
+		}
 	}
 }
 
@@ -1399,6 +1433,8 @@ getnum(
 			illegal_option(str, opts, index, NULL);
 	}
 
+	check_opt_value(opts, index, c);
+
 	/* Validity check the result. */
 	if (c < sp->minval)
 		illegal_option(str, opts, index, _("value is too small"));
-- 
2.8.1

