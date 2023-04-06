Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD1FC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbjDFTkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbjDFTkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1DD94
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3997E60FA2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B45C4339B;
        Thu,  6 Apr 2023 19:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810040;
        bh=kZChdp0+4a2Qd7prqrsCtBF5eT9dV1qbjyAEXGvNc5A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QJlkUl1U17d8YUw0oJ4lld4ydsTq/ky8iVZWhXc8wcO3qTKCyWK3CSNbTX2RG7rkJ
         4bHueHMLSW69GZWk9N9ADlZBHTLziVjjSCRI1/6YJGofENuObnk763x8hpySlQjy+C
         1t8jLskRQGml3CRPNazlfjMAJvyfcRf6ufH6gzJ4mAWtZQn1FqZ9rMRPzDU741qQwp
         C12synrAS+JBshrz4BmMzqGWhYZiZbKArmc2D1w7xd8x9wAcPcOHpmbMImlqj4nQdx
         Gp6fZYoO25NQjNC5Clfel+6haDBBt2FF0R7jizr2YOKdmEqA8p7Luw0chkbH2c+T0q
         YXLtTsqtMHy6Q==
Date:   Thu, 06 Apr 2023 12:40:40 -0700
Subject: [PATCH 3/7] xfs_repair: deduplicate strings stored in string blob
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828298.617551.7017288128667378303.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
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
index d18fa0493..2523f4a53 100644
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
index 2b7a7a5e0..0478c5ac8 100644
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
index f56801754..6de623e66 100644
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

