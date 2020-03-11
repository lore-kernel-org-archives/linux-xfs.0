Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FC8C10F27
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 09:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB5F2071B
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 09:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgCKJfy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:35:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:37314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKJfy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Mar 2020 05:35:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46A1DACEF;
        Wed, 11 Mar 2020 09:35:53 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 10:35:52 +0100
Message-Id: <20200311093552.25354-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 fs/xfs/xfs_stats.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 113883c4f202..f70f1255220b 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	/* Loop over all stats groups */
 
 	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += snprintf(buf + len, PATH_MAX - len, "%s",
+		len += scnprintf(buf + len, PATH_MAX - len, "%s",
 				xstats[i].desc);
 		/* inner loop does each group */
 		for (; j < xstats[i].endpoint; j++)
-			len += snprintf(buf + len, PATH_MAX - len, " %u",
+			len += scnprintf(buf + len, PATH_MAX - len, " %u",
 					counter_val(stats, j));
-		len += snprintf(buf + len, PATH_MAX - len, "\n");
+		len += scnprintf(buf + len, PATH_MAX - len, "\n");
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
-	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else
-- 
2.16.4

