Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163244AbdDWSzP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A317166CBA
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:14 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 06/12] mkfs: create get/set functions for opts table
Date: Sun, 23 Apr 2017 20:54:57 +0200
Message-Id: <20170423185503.31415-7-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add functions that can be used to get/set values to opts table.

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
 mkfs/xfs_mkfs.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c2ffd91..4caf93c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -786,6 +786,38 @@ get_conf_raw(int opt, int subopt)
 	return opts[opt].subopt_params[subopt].raw_input;
 }
 
+static uint64_t getnum(const char *str, struct opt_params *opts, int index);
+
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
+/*
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
+
 /*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
-- 
2.1.4

