Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbdHOPI0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Aug 2017 11:08:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 435946B360
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 15:08:26 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Date: Tue, 15 Aug 2017 17:08:12 +0200
Message-Id: <20170815150812.32237-5-jtulak@redhat.com>
In-Reply-To: <20170815150812.32237-1-jtulak@redhat.com>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

This patch adds infrastructure that will be used in subsequent patches.

The Value field is the actual value used in computations for creating
the filesystem.  This is initialized with sensible default values. If
initialized to 0, the value is considered disabled. User input will
override default values.  If the field is a string and not a number, the
value is set to a positive non-zero number when user input has been
supplied.

Add functions that can be used to get/set values to opts table.

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
Change:
* whitespaces
* rename "collateral" -> "connected"
* reorder subopt_params to avoid padding issues
* translation and indentation for fprintf
---
 mkfs/xfs_mkfs.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1aedc804..17ee46a7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -117,6 +117,13 @@ unsigned int		sectorsize;
  *     Filled raw string from the user, so we never lose that information e.g.
  *     to print it back in case of an issue.
  *
+ *   value OPTIONAL
+ *     The actual value used in computations for creating the filesystem.
+ *     This is initialized with sensible default values. If initialized to 0,
+ *     the value is considered disabled. User input will override default
+ *     values. If the field is a string and not a number, the value is set to
+ *     a positive non-zero number when user input has been supplied.
+ *
  */
 struct opt_params {
 	int		index;
@@ -133,6 +140,7 @@ struct opt_params {
 		long long	minval;
 		long long	maxval;
 		long long	flagval;
+		long long	value;
 		char		*raw_input;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
@@ -750,6 +758,162 @@ struct opt_params {
 #define WHACK_SIZE (128 * 1024)
 
 /*
+ * Get and set values to the opts table.
+ */
+static int
+get_conf_val_unsafe(int opt, int subopt, uint64_t *output)
+{
+	if (subopt < 0 || subopt >= MAX_SUBOPTS ||
+	    opt < 0 || opt >= MAX_OPTS) {
+		fprintf(stderr,
+			_("This is a bug: get_conf_val called with invalid "
+			  "opt/subopt: %d/%d\n"),
+			opt, subopt);
+		return -EINVAL;
+	}
+	*output = opts[opt].subopt_params[subopt].value;
+	return 0;
+}
+
+static long long
+get_conf_val(int opt, int subopt)
+{
+	uint64_t res;
+	if (get_conf_val_unsafe(opt, subopt, &res) != 0)
+		exit(1);
+	return res;
+}
+
+static int
+set_conf_val_unsafe(int opt, int subopt, uint64_t val)
+{
+	if (subopt < 0 || subopt >= MAX_SUBOPTS ||
+	    opt < 0 || opt >= MAX_OPTS) {
+		fprintf(stderr,
+			_("This is a bug: set_conf_val called with invalid "
+			  "opt/subopt: %d/%d\n"),
+			opt, subopt);
+		return -EINVAL;
+	}
+	struct subopt_param *sp = &opts[opt].subopt_params[subopt];
+	sp->value = val;
+
+	return 0;
+}
+
+static void
+set_conf_val(int opt, int subopt, uint64_t val)
+{
+	if (set_conf_val_unsafe(opt, subopt, val) != 0)
+		exit(1);
+}
+
+/*
+ * A wrapper around set_conf_val which updates also connected values.
+ * E.g. when changing S_LOG, update S_SIZE too.
+ */
+static void
+set_conf_val_connected(int opt, int subopt, uint64_t val)
+{
+	set_conf_val(opt, subopt, val);
+
+	switch (opt) {
+	case OPT_B:
+		switch (subopt) {
+		case B_LOG:
+			set_conf_val(OPT_B, B_SIZE, 1 << val);
+			break;
+		case B_SIZE:
+			set_conf_val(OPT_B, B_LOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	case OPT_D:
+		switch (subopt) {
+		case D_SECTLOG:
+			set_conf_val(OPT_S, S_LOG, val);
+			set_conf_val(OPT_S, S_SECTLOG, val);
+			set_conf_val(OPT_D, D_SECTSIZE, 1 << val);
+			set_conf_val(OPT_S, S_SECTSIZE, 1 << val);
+			set_conf_val(OPT_S, S_SIZE, 1 << val);
+			break;
+		case D_SECTSIZE:
+			set_conf_val(OPT_S, S_SIZE, val);
+			set_conf_val(OPT_S, S_SECTSIZE, val);
+			set_conf_val(OPT_D, D_SECTLOG, libxfs_highbit32(val));
+			set_conf_val(OPT_S, S_LOG, libxfs_highbit32(val));
+			set_conf_val(OPT_S, S_SECTLOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	case OPT_I:
+		switch (subopt) {
+		case I_LOG:
+			set_conf_val(OPT_I, I_SIZE, 1 << val);
+			break;
+		case I_SIZE:
+			set_conf_val(OPT_I, I_LOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	case OPT_L:
+		switch (subopt) {
+		case L_SECTLOG:
+			set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
+			break;
+		case L_SECTSIZE:
+			set_conf_val(OPT_L, L_SECTLOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	case OPT_M:
+		switch (subopt) {
+		}
+		break;
+	case OPT_N:
+		switch (subopt) {
+		case N_LOG:
+			set_conf_val(OPT_N, N_SIZE, 1 << val);
+			break;
+		case N_SIZE:
+			set_conf_val(OPT_N, N_LOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	case OPT_R:
+		switch (subopt) {
+		}
+		break;
+	case OPT_S:
+		switch (subopt) {
+		case S_LOG:
+		case S_SECTLOG:
+			set_conf_val(OPT_S, S_LOG, val);
+			set_conf_val(OPT_D, D_SECTLOG, val);
+			set_conf_val(OPT_L, L_SECTLOG, val);
+			set_conf_val(OPT_D, D_SECTSIZE, 1 << val);
+			set_conf_val(OPT_S, S_SIZE, 1 << val);
+			set_conf_val(OPT_S, S_SECTSIZE, 1 << val);
+			set_conf_val(OPT_L, L_SECTLOG, val);
+			set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
+			set_conf_val(OPT_L, L_SECTSIZE, val);
+			break;
+		case S_SIZE:
+		case S_SECTSIZE:
+			set_conf_val(OPT_S, S_SIZE, val);
+			set_conf_val(OPT_D, D_SECTSIZE, val);
+			set_conf_val(OPT_D, D_SECTLOG, libxfs_highbit32(val));
+			set_conf_val(OPT_S, S_LOG, libxfs_highbit32(val));
+			set_conf_val(OPT_S, S_SECTLOG, libxfs_highbit32(val));
+			set_conf_val(OPT_L, L_SECTSIZE, val);
+			set_conf_val(OPT_L, L_SECTLOG, libxfs_highbit32(val));
+			break;
+		}
+		break;
+	}
+}
+
+/*
  * Return 0 on success, -ENOMEM if it could not allocate enough memory for
  * the string to be saved.
  */
@@ -951,6 +1115,18 @@ getnum(
 }
 
 /*
+ * A wrapper for getnum and set_conf_val.
+ */
+static inline long long
+parse_conf_val(int opt, int subopt, char *value)
+{
+	long long num = getnum(value, &opts[opt], subopt);
+
+	set_conf_val_connected(opt, subopt, num);
+	return num;
+}
+
+/*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
 static void
-- 
2.13.3

