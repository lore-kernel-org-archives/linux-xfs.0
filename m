Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163227AbdDWSzK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 614283D96A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:09 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 01/12] mkfs: Save raw user input field to the opts struct
Date: Sun, 23 Apr 2017 20:54:52 +0200
Message-Id: <20170423185503.31415-2-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Save exactly what the user gave us for every option.  This way, we will
never lose the information if we need it to print back an issue.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83a04fc..84674d5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -119,6 +119,10 @@ uint64_t		sectorsize;
  *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
  *     value in any case.
  *
+ *   raw_input INTERNAL
+ *     Filled raw string from the user, so we never lose that information e.g.
+ *     to print it back in case of an issue.
+ *
  * !!! NOTE ==================================================================
  *
  * If you are adding a new option, or changing an existing one,
@@ -141,6 +145,7 @@ struct opt_params {
 		uint64_t	minval;
 		uint64_t	maxval;
 		uint64_t	defaultval;
+		const char	*raw_input;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -748,6 +753,18 @@ struct opt_params mopts = {
  */
 #define WHACK_SIZE (128 * 1024)
 
+static inline void
+set_conf_raw(struct opt_params *opt, int subopt, const char *value)
+{
+	opt->subopt_params[subopt].raw_input = value;
+}
+
+static inline const char *
+get_conf_raw(const struct opt_params *opt, int subopt)
+{
+	return opt->subopt_params[subopt].raw_input;
+}
+
 /*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
-- 
2.1.4

