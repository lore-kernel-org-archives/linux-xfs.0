Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdHOPIK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Aug 2017 11:08:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD0F87EA90
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 15:08:09 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/6 v2] mkfs: Save raw user input field to the opts struct
Date: Tue, 15 Aug 2017 17:08:08 +0200
Message-Id: <20170815150812.32237-1-jtulak@redhat.com>
In-Reply-To: <20170811123037.15962-1-jtulak@redhat.com>
References: <20170811123037.15962-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Save exactly what the user gave us for every option.  This way, we will
never lose the information if we need it to print back an issue.
(Just add the infrastructure now, used in the next patches.)

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGE:
* test for NULL before strdup in get_conf_raw
* Translation and indentation for fprints
* add set_conf_raw_safe
---
 mkfs/xfs_mkfs.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7bb6408f..adfbd376 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -107,6 +107,11 @@ unsigned int		sectorsize;
  *     sets what is used with simple specifying the subopt (-d file).
  *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
  *     value in any case.
+ *
+ *   raw_input INTERNAL
+ *     Filled raw string from the user, so we never lose that information e.g.
+ *     to print it back in case of an issue.
+ *
  */
 struct opt_params {
 	const char	name;
@@ -122,6 +127,7 @@ struct opt_params {
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
+		char		*raw_input;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -730,6 +736,88 @@ struct opt_params mopts = {
 #define WHACK_SIZE (128 * 1024)
 
 /*
+ * Return 0 on success, -ENOMEM if it could not allocate enough memory for
+ * the string to be saved.
+ */
+static int
+set_conf_raw(struct opt_params *opt, const int subopt, const char *value)
+{
+	if (subopt < 0 || subopt >= MAX_SUBOPTS) {
+		fprintf(stderr,
+			_("This is a bug: set_conf_raw called with invalid "
+			  "opt/subopt: %c/%d\n"),
+			opt->name, subopt);
+		return -EINVAL;
+	}
+	if (value == NULL) {
+		if (opt->subopt_params[subopt].raw_input != NULL)
+			free(opt->subopt_params[subopt].raw_input);
+		opt->subopt_params[subopt].raw_input = NULL;
+	} else {
+		opt->subopt_params[subopt].raw_input = strdup(value);
+		if (opt->subopt_params[subopt].raw_input == NULL)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+/*
+ * Same as set_conf_raw(), except if any error occurs, return NULL.
+ */
+static void
+set_conf_raw_safe(struct opt_params *opt, const int subopt, const char *value)
+{
+	if (set_conf_raw(opt, subopt, value) != 0) {
+		exit(1);
+	}
+}
+
+/*
+ * Return 0 on success, -ENOMEM if it could not allocate enough memory for
+ * the string to be saved into the out pointer.
+ */
+static int
+get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
+{
+	if (subopt < 0 || subopt >= MAX_SUBOPTS) {
+		fprintf(stderr,
+			_("This is a bug: get_conf_raw called with invalid "
+			  "opt/subopt: %c/%d\n"),
+			opt->name, subopt);
+		return -EINVAL;
+	}
+
+	if (opt->subopt_params[subopt].raw_input == NULL) {
+		*out = NULL;
+		return 0;
+	}
+
+	*out = strdup(opt->subopt_params[subopt].raw_input);
+	if (*out == NULL)
+		return -ENOMEM;
+	return 0;
+
+}
+
+/*
+ * Same as get_conf_raw(), except it returns the string through return.
+ * If any error occurs, return NULL.
+ */
+static char *
+get_conf_raw_safe(const struct opt_params *opt, const int subopt)
+{
+	char *str;
+
+	str = NULL;
+
+	if (get_conf_raw(opt, subopt, &str) == -ENOMEM) {
+		fprintf(stderr, "Out of memory!");
+		return NULL;
+	}
+	return str;
+}
+
+/*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
 static void
-- 
2.13.3

