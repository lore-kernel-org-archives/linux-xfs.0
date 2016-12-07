Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752117AbcLGN3D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:29:03 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C90427F76D
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:28:03 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 22/22] mkfs: prevent multiple specifications of a single option
Date: Wed,  7 Dec 2016 14:27:29 +0100
Message-Id: <1481117249-21273-23-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Because things like -l size=40M,size=50M are clearly wrong and should
not pass. However, in two cases, we do not know if the option is a
string or number - thus the few more lines with can_respec flag.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cd0eb20..7fe743a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -432,6 +432,10 @@ test_uvalue_num(enum e_type a_type, union u_value a, long long b) {
  *     Set to true if, when user specifies the option, she has to specify
  *     a value too. That is, if needs_val is true, then it is not possible to
  *     use the subopt as a flag.
+ *
+ *   can_respec OPTIONAL
+ *     If true, then there can come one getnum() after a getstr() call for this
+ *     option.
  */
 struct opt_params {
 	int		index;
@@ -458,6 +462,7 @@ struct opt_params {
 		union u_value value;
 		enum e_type 	type;
 		bool		needs_val;
+		bool		can_respec;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
 	{
@@ -877,6 +882,7 @@ struct opt_params {
 			  .maxval.i = 2,
 			  .needs_val = true,
 			  .type = INT,
+			  .can_respec = true,
 			},
 			{ .index = L_SUNIT,
 			  .conflicts = { {.opt = OPT_L,
@@ -1009,6 +1015,7 @@ struct opt_params {
 			  .maxval.i = 2,
 			  .needs_val = true,
 			  .type = INT,
+			  .can_respec = true,
 			},
 			{ .index = N_FTYPE,
 			  .conflicts = {  {.opt = OPT_M,
@@ -2017,6 +2024,22 @@ getnum(
 	struct subopt_param	*sp = &opts->subopt_params[index];
 	long long		c;
 
+	if (sp->seen){
+		/* If the option has respec flag, it is possible to do ONE
+		 * getnum call even with sp->seen == 1. Do this by disabling
+		 * the respec flag - this time we can continue, but if getnum
+		 * gets called once more, we will fail.
+		 */
+		if (sp->can_respec){
+			sp->can_respec = false;
+		} else {
+			fprintf(stderr,
+			_("You can't use an option multiple times: -%c %s\n"),
+			  opts->name, opts->subopts[index]);
+			usage();
+		}
+	}
+
 	/* empty strings might just return a default value */
 	if (!str || *str == '\0') {
 		if (sp->needs_val)
@@ -2123,6 +2146,12 @@ getstr(
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
 		reqval(opts->name, (char **)opts->subopts, index);
+	if (opts->subopt_params[index].seen){
+		fprintf(stderr,
+		_("You can't use an option multiple times: -%c %s\n"),
+		  opts->name, opts->subopts[index]);
+		usage();
+	}
 	opts->subopt_params[index].seen = true;
 	return str;
 }
-- 
2.8.1

