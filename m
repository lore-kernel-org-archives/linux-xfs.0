Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935006AbdGTJ3n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:29:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 50E51315FDE
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:29:43 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 6/7] mkfs: extend opt_params with a value field
Date: Thu, 20 Jul 2017 11:29:31 +0200
Message-Id: <20170720092932.32580-7-jtulak@redhat.com>
In-Reply-To: <20170720092932.32580-1-jtulak@redhat.com>
References: <20170720092932.32580-1-jtulak@redhat.com>
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
* update the description of commit/in code
* merge with another patch, which adds the get/set functions.

---
 mkfs/xfs_mkfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9d2db2a2..e008b5a4 100644
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
@@ -134,6 +141,7 @@ struct opt_params {
 		long long	maxval;
 		long long	flagval;
 		const char	*raw_input;
+		uint64_t	value;
 	}		subopt_params[MAX_SUBOPTS];
 } opts[MAX_OPTS] = {
 #define OPT_B	0
@@ -749,6 +757,23 @@ struct opt_params {
  */
 #define WHACK_SIZE (128 * 1024)
 
+/*
+ * Get and set values to the opts table.
+ */
+static inline uint64_t
+get_conf_val(int opt, int subopt)
+{
+	return opts[opt].subopt_params[subopt].value;
+}
+
+static void
+set_conf_val(int opt, int subopt, uint64_t val)
+{
+	struct subopt_param *sp = &opts[opt].subopt_params[subopt];
+
+	sp->value = val;
+}
+
 static inline void
 set_conf_raw(int opt, int subopt, const char *value)
 {
@@ -880,6 +905,18 @@ getnum(
 }
 
 /*
+ * A wrapper for getnum and set_conf_val.
+ */
+static inline uint64_t
+parse_conf_val(int opt, int subopt, char *value)
+{
+	uint64_t num = getnum(value, &opts[opt], subopt);
+
+	set_conf_val(opt, subopt, num);
+	return num;
+}
+
+/*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
 static void
-- 
2.11.0

