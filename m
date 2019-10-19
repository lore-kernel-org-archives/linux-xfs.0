Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A169CCA9EAC
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 07:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8029D222BD
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 07:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfJSHnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 03:43:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:60096 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfJSHnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 03:43:21 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www17.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <thomas@m3y3r.de>)
        id 1iLj2f-0001q0-Ku; Sat, 19 Oct 2019 09:20:49 +0200
Received: from [2a02:908:4c22:ec00:8ad5:993:4cda:a89f] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <thomas@m3y3r.de>)
        id 1iLj2f-0000W2-E0; Sat, 19 Oct 2019 09:20:49 +0200
From:   Thomas Meyer <thomas@m3y3r.de>
To:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 2/2] xfs: replace homemade binary search
Date:   Sat, 19 Oct 2019 09:20:33 +0200
Message-Id: <20191019072033.17744-2-thomas@m3y3r.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191019072033.17744-1-thomas@m3y3r.de>
References: <20191019072033.17744-1-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: thomas@m3y3r.de
X-Virus-Scanned: Clear (ClamAV 0.101.4/25606/Fri Oct 18 10:58:40 2019)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

use newly introduced bsearch_idx instead.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9595ced393dce..e484ec68944fb 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include <linux/bsearch.h>
 
 /*
  * Local function prototypes.
@@ -314,6 +315,19 @@ xfs_dir2_block_compact(
 		xfs_dir2_data_freescan(args->dp, hdr, needlog);
 }
 
+static int cmp_hashval(const void *key, const void *elt)
+{
+	xfs_dahash_t _search_key = *(xfs_dahash_t *)key;
+	xfs_dahash_t _curren_key = be32_to_cpu((
+				(xfs_dir2_leaf_entry_t *) elt)->hashval);
+
+	if (_search_key == _curren_key)
+		return 0;
+	else if (_search_key < _curren_key)
+		return -1;
+	return 1;
+}
+
 /*
  * Add an entry to a block directory.
  */
@@ -331,19 +345,17 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
 	int			error;		/* error return value */
 	xfs_dir2_data_unused_t	*enddup=NULL;	/* unused at end of data */
-	xfs_dahash_t		hash;		/* hash value of found entry */
-	int			high;		/* high index for binary srch */
 	int			highstale;	/* high stale index */
 	int			lfloghigh=0;	/* last final leaf to log */
 	int			lfloglow=0;	/* first final leaf to log */
 	int			len;		/* length of the new entry */
-	int			low;		/* low index for binary srch */
 	int			lowstale;	/* low stale index */
 	int			mid=0;		/* midpoint for binary srch */
 	int			needlog;	/* need to log header */
 	int			needscan;	/* need to rescan freespace */
 	__be16			*tagp;		/* pointer to tag value */
 	xfs_trans_t		*tp;		/* transaction structure */
+	struct bsearch_result	idx;		/* bsearch result */
 
 	trace_xfs_dir2_block_addname(args);
 
@@ -420,15 +432,9 @@ xfs_dir2_block_addname(
 	/*
 	 * Find the slot that's first lower than our hash value, -1 if none.
 	 */
-	for (low = 0, high = be32_to_cpu(btp->count) - 1; low <= high; ) {
-		mid = (low + high) >> 1;
-		if ((hash = be32_to_cpu(blp[mid].hashval)) == args->hashval)
-			break;
-		if (hash < args->hashval)
-			low = mid + 1;
-		else
-			high = mid - 1;
-	}
+	idx = bsearch_idx(&args->hashval, blp, be32_to_cpu(btp->count) - 1,
+			  sizeof(xfs_dir2_leaf_entry_t), cmp_hashval);
+	mid = idx.idx;
 	while (mid >= 0 && be32_to_cpu(blp[mid].hashval) >= args->hashval) {
 		mid--;
 	}
-- 
2.21.0

