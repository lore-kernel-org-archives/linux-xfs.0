Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA3FC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZCcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZCcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D1D9C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B0C6122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F0C433D2;
        Fri, 26 May 2023 02:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068319;
        bh=53TabZPc7QkgfMw4wuHgxR4XU+9+7p2XI98vnF1Z7UM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ia2cW0/u2Tie69KBa1V1EUUwNgM1etmvb19xc6RCPFPP8E+OajZk6A7sI7yQ82fMp
         6lG8QAYCv6x5QQTFFbMa01Y2CN/lBnMZT0yzv5/aItGp+BXEueHUra4FyqHLWZwzkm
         +QDSzN3BFh8Hk+hUv4BN/kVpMCwhTy55YhsGpd8r6ldT0rufudpqsv1Hr/GzQbCm4j
         T5Nuam1ywNcF9QkPS85LMv3i6wCP6VNgiLNpvfTx6FlMwN3m0tIvawrip5eAoj8EjI
         KUpkxZVpvDRVO0DAaPgOgi4ZS50fdHdsIdblMZ+03fy8pMk9hSIJIill856G0rIRFp
         JiP0RYyH8SNMw==
Date:   Thu, 25 May 2023 19:31:58 -0700
Subject: [PATCH 09/14] xfs_repair: deduplicate strings stored in string blob
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078718.3750196.15705670992283360140.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reduce the memory requirements of the string blob structure by
deduplicating the strings stored within.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c     |   13 ++++-
 repair/strblobs.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 repair/strblobs.h |    8 ++-
 3 files changed, 152 insertions(+), 9 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 04da9fa1194..649f0089ffd 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -49,7 +49,7 @@
  *
  * becomes this backwards information:
  *
- *     (child_agino*, dir_ino*, dir_gen, name*)
+ *     (child_agino*, dir_ino*, dir_gen, name_cookie*)
  *
  * Key fields are starred.
  *
@@ -57,6 +57,10 @@
  * that names are stored separately in an xfblob data structure so that the
  * rest of the information can be sorted and processed as fixed-size records;
  * the incore parent pointer record contains a pointer to the strblob data.
+ * Because string blobs are deduplicated, there's a 1:1 mapping of name cookies
+ * to strings, which means that we can use the name cookie as a comparison key
+ * instead of loading the full dentry name every time we want to perform a
+ * comparison.
  */
 
 struct ag_pptr {
@@ -113,13 +117,16 @@ void
 parent_ptr_init(
 	struct xfs_mount	*mp)
 {
+	uint64_t		iused;
 	xfs_agnumber_t		agno;
 	int			error;
 
 	if (!xfs_has_parent(mp))
 		return;
 
-	error = strblobs_init(mp, "parent pointer names", &nameblobs);
+	/* One hash bucket per inode, up to about 8M of memory on 64-bit. */
+	iused = min(mp->m_sb.sb_icount - mp->m_sb.sb_ifree, 1048573);
+	error = strblobs_init(mp, "parent pointer names", iused, &nameblobs);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
 				strerror(error));
@@ -175,7 +182,7 @@ add_parent_ptr(
 
 	pthread_mutex_lock(&names_mutex);
 	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
-			ag_pptr.namelen);
+			ag_pptr.namelen, ag_pptr.namehash);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
 		do_error(_("storing name '%s' failed: %s\n"),
diff --git a/repair/strblobs.c b/repair/strblobs.c
index 2b7a7a5e04f..0478c5ac8ec 100644
--- a/repair/strblobs.c
+++ b/repair/strblobs.c
@@ -13,23 +13,43 @@
  * =====================
  *
  * This data structure wraps the storage of strings with explicit length in an
- * xfblob structure.
+ * xfblob structure.  It stores a hashtable of string checksums to provide
+ * fast(ish) lookups of existing strings to enable deduplication of the strings
+ * contained within.
  */
+struct strblob_hashent {
+	struct strblob_hashent	*next;
+
+	xfblob_cookie		str_cookie;
+	unsigned int		str_len;
+	xfs_dahash_t		str_hash;
+};
+
 struct strblobs {
 	struct xfblob		*strings;
+	unsigned int		nr_buckets;
+
+	struct strblob_hashent	*buckets[];
 };
 
+static inline size_t strblobs_sizeof(unsigned int nr_buckets)
+{
+	return sizeof(struct strblobs) +
+			(nr_buckets * sizeof(struct strblobs_hashent *));
+}
+
 /* Initialize a string blob structure. */
 int
 strblobs_init(
 	struct xfs_mount	*mp,
 	const char		*descr,
+	unsigned int		hash_buckets,
 	struct strblobs		**sblobs)
 {
 	struct strblobs		*sb;
 	int			error;
 
-	sb = malloc(sizeof(struct strblobs));
+	sb = calloc(strblobs_sizeof(hash_buckets), 1);
 	if (!sb)
 		return ENOMEM;
 
@@ -37,6 +57,7 @@ strblobs_init(
 	if (error)
 		goto out_free;
 
+	sb->nr_buckets = hash_buckets;
 	*sblobs = sb;
 	return 0;
 
@@ -51,21 +72,132 @@ strblobs_destroy(
 	struct strblobs		**sblobs)
 {
 	struct strblobs		*sb = *sblobs;
+	struct strblob_hashent	*ent, *ent_next;
+	unsigned int		bucket;
+
+	for (bucket = 0; bucket < sb->nr_buckets; bucket++) {
+		ent = sb->buckets[bucket];
+		while (ent != NULL) {
+			ent_next = ent->next;
+			free(ent);
+			ent = ent_next;
+		}
+	}
 
 	xfblob_destroy(sb->strings);
 	free(sb);
 	*sblobs = NULL;
 }
 
+/*
+ * Search the string hashtable for a matching entry.  Sets sets the cookie and
+ * returns 0 if one is found; ENOENT if there is no match; or a positive errno.
+ */
+static int
+__strblobs_lookup(
+	struct strblobs		*sblobs,
+	xfblob_cookie		*str_cookie,
+	const unsigned char	*str,
+	unsigned int		str_len,
+	xfs_dahash_t		str_hash)
+{
+	struct strblob_hashent	*ent;
+	char			*buf = NULL;
+	unsigned int		bucket;
+	int			error;
+
+	bucket = str_hash % sblobs->nr_buckets;
+	ent = sblobs->buckets[bucket];
+
+	for (ent = sblobs->buckets[bucket]; ent != NULL; ent = ent->next) {
+		if (ent->str_len != str_len || ent->str_hash != str_hash)
+			continue;
+
+		if (!buf) {
+			buf = malloc(str_len);
+			if (!buf)
+				return ENOMEM;
+		}
+
+		error = strblobs_load(sblobs, ent->str_cookie, buf, str_len);
+		if (error)
+			goto out;
+
+		if (memcmp(str, buf, str_len))
+			continue;
+
+		*str_cookie = ent->str_cookie;
+		goto out;
+	}
+	error = ENOENT;
+
+out:
+	free(buf);
+	return error;
+}
+
+/*
+ * Search the string hashtable for a matching entry.  Sets sets the cookie and
+ * returns 0 if one is found; ENOENT if there is no match; or a positive errno.
+ */
+int
+strblobs_lookup(
+	struct strblobs		*sblobs,
+	xfblob_cookie		*str_cookie,
+	const unsigned char	*str,
+	unsigned int		str_len,
+	xfs_dahash_t		str_hash)
+{
+	return __strblobs_lookup(sblobs, str_cookie, str, str_len, str_hash);
+}
+
+/* Remember a string in the hashtable. */
+static int
+strblobs_hash(
+	struct strblobs		*sblobs,
+	xfblob_cookie		str_cookie,
+	const unsigned char	*str,
+	unsigned int		str_len,
+	xfs_dahash_t		str_hash)
+{
+	struct strblob_hashent	*ent;
+	unsigned int		bucket;
+
+	bucket = str_hash % sblobs->nr_buckets;
+
+	ent = malloc(sizeof(struct strblob_hashent));
+	if (!ent)
+		return ENOMEM;
+
+	ent->str_cookie = str_cookie;
+	ent->str_len = str_len;
+	ent->str_hash = str_hash;
+	ent->next = sblobs->buckets[bucket];
+
+	sblobs->buckets[bucket] = ent;
+	return 0;
+}
+
 /* Store a string and return a cookie for its retrieval. */
 int
 strblobs_store(
 	struct strblobs		*sblobs,
 	xfblob_cookie		*str_cookie,
 	const unsigned char	*str,
-	unsigned int		str_len)
+	unsigned int		str_len,
+	xfs_dahash_t		str_hash)
 {
-	return -xfblob_store(sblobs->strings, str_cookie, str, str_len);
+	int			error;
+
+	error = __strblobs_lookup(sblobs, str_cookie, str, str_len, str_hash);
+	if (error != ENOENT)
+		return error;
+
+	error = -xfblob_store(sblobs->strings, str_cookie, str, str_len);
+	if (error)
+		return error;
+
+	return strblobs_hash(sblobs, *str_cookie, str, str_len, str_hash);
 }
 
 /* Retrieve a previously stored string. */
diff --git a/repair/strblobs.h b/repair/strblobs.h
index f5680175476..6de623e66cc 100644
--- a/repair/strblobs.h
+++ b/repair/strblobs.h
@@ -9,12 +9,16 @@
 struct strblobs;
 
 int strblobs_init(struct xfs_mount *mp, const char *descr,
-		struct strblobs **sblobs);
+		unsigned int hash_buckets, struct strblobs **sblobs);
 void strblobs_destroy(struct strblobs **sblobs);
 
 int strblobs_store(struct strblobs *sblobs, xfblob_cookie *str_cookie,
-		const unsigned char *str, unsigned int str_len);
+		const unsigned char *str, unsigned int str_len,
+		xfs_dahash_t hash);
 int strblobs_load(struct strblobs *sblobs, xfblob_cookie str_cookie,
 		unsigned char *str, unsigned int str_len);
+int strblobs_lookup(struct strblobs *sblobs, xfblob_cookie *str_cookie,
+		const unsigned char *str, unsigned int str_len,
+		xfs_dahash_t hash);
 
 #endif /* __REPAIR_STRBLOBS_H__ */

