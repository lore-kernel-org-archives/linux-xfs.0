Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1BA77CA6
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3351304048
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uYMqsRUsihIY2zSd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:52 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 199BA85541
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:52 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 5/8] mkfs: add a check for conflicting values
Date: Tue,  2 Aug 2016 17:42:16 +0200
Message-Id: <1470152539-18759-6-git-send-email-jtulak@redhat.com>
In-Reply-To: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
References: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Add a check that reports a conflict only when subopts are mixed with specific values.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 52 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b2fbc58..6f3f278 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1289,18 +1289,18 @@ illegal_option(
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
@@ -1313,11 +1313,11 @@ check_opt(
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
 
@@ -1327,10 +1327,44 @@ check_opt(
 
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
 
@@ -1377,6 +1411,8 @@ getnum(
 			illegal_option(str, opts, index, NULL);
 	}
 
+	check_opt_value(opts, index, c);
+
 	/* Validity check the result. */
 	if (c < sp->minval)
 		illegal_option(str, opts, index, _("value is too small"));
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
