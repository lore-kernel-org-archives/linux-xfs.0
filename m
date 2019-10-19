Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2886CA9EAC
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 07:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4024222C5
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 07:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfJSHnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 03:43:19 -0400
Received: from www17.your-server.de ([213.133.104.17]:60082 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfJSHnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 03:43:18 -0400
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Oct 2019 03:43:17 EDT
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www17.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <thomas@m3y3r.de>)
        id 1iLj2Y-0001pf-Kr; Sat, 19 Oct 2019 09:20:42 +0200
Received: from [2a02:908:4c22:ec00:8ad5:993:4cda:a89f] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <thomas@m3y3r.de>)
        id 1iLj2Y-0000W2-Ey; Sat, 19 Oct 2019 09:20:42 +0200
From:   Thomas Meyer <thomas@m3y3r.de>
To:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 1/2] lib/bsearch.c: introduce bsearch_idx
Date:   Sat, 19 Oct 2019 09:20:32 +0200
Message-Id: <20191019072033.17744-1-thomas@m3y3r.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: thomas@m3y3r.de
X-Virus-Scanned: Clear (ClamAV 0.101.4/25606/Fri Oct 18 10:58:40 2019)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

many existing bsearch implementations don't want to have the pointer to the
found element, but the index position, or if the searched element doesn't
exist, the index position the search element would be placed in the array.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 include/linux/bsearch.h |  7 +++++
 lib/bsearch.c           | 62 +++++++++++++++++++++++++++++++++--------
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/include/linux/bsearch.h b/include/linux/bsearch.h
index 62b1eb3488584..0c40c8b39b881 100644
--- a/include/linux/bsearch.h
+++ b/include/linux/bsearch.h
@@ -7,4 +7,11 @@
 void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt));
 
+struct bsearch_result { size_t idx; bool found; };
+
+struct bsearch_result bsearch_idx(const void *key, const void *base,
+		      size_t num,
+		      size_t size,
+		      int (*cmp)(const void *key, const void *elt));
+
 #endif /* _LINUX_BSEARCH_H */
diff --git a/lib/bsearch.c b/lib/bsearch.c
index 8baa839681628..5c46d0ec1e473 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -10,8 +10,8 @@
 #include <linux/bsearch.h>
 #include <linux/kprobes.h>
 
-/*
- * bsearch - binary search an array of elements
+/**
+ * bsearch() - binary search an array of elements
  * @key: pointer to item being searched for
  * @base: pointer to first element to search
  * @num: number of elements
@@ -27,28 +27,68 @@
  * could compare the string with the struct's name field.  However, if
  * the key and elements in the array are of the same type, you can use
  * the same comparison function for both sort() and bsearch().
+ *
+ * Return: Either a pointer to the search element or NULL if not found.
  */
 void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt))
 {
-	const char *pivot;
+	struct bsearch_result idx = bsearch_idx(key, base, num, size, cmp);
+
+	if (idx.found == true)
+		return (void *)base + idx.idx * size;
+
+	return NULL;
+}
+EXPORT_SYMBOL(bsearch);
+NOKPROBE_SYMBOL(bsearch);
+
+/**
+ * bsearch_idx() - binary search an array of elements
+ * @key: pointer to item being searched for
+ * @base: pointer to first element to search
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp: pointer to comparison function
+ *
+ * This function does a binary search on the given array.  The
+ * contents of the array should already be in ascending sorted order
+ * under the provided comparison function.
+ *
+ * Returns an index position and a bool if an exact match was found
+ * if an exact match was found the idx is the index in the base array.
+ * if no exact match was found the idx will point the the next higher index
+ * entry in the base array. this can also be base[num], i.e. after the actual
+ * allocated array.
+ */
+struct bsearch_result bsearch_idx(const void *key, const void *base,
+				  size_t num,
+				  size_t size,
+				  int (*cmp)(const void *key, const void *elt))
+{
+	struct bsearch_result res = { .found = false };
 	int result;
+	size_t base_idx = 0;
+	size_t pivot_idx;
 
 	while (num > 0) {
-		pivot = base + (num >> 1) * size;
-		result = cmp(key, pivot);
+		pivot_idx = base_idx + (num >> 1);
+		result = cmp(key, base + pivot_idx * size);
 
-		if (result == 0)
-			return (void *)pivot;
+		if (result == 0) {
+			res.idx = pivot_idx;
+			res.found = true;
+			return res;
+		}
 
 		if (result > 0) {
-			base = pivot + size;
+			base_idx = pivot_idx + 1;
 			num--;
 		}
 		num >>= 1;
 	}
 
-	return NULL;
+	res.idx = base_idx;
+	return res;
 }
-EXPORT_SYMBOL(bsearch);
-NOKPROBE_SYMBOL(bsearch);
+EXPORT_SYMBOL(bsearch_idx);
-- 
2.21.0

