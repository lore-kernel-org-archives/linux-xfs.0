Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F85C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF3F58qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC396C433C7;
	Sun, 31 Dec 2023 23:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064594;
	bh=WsYma92WyuV7JStxidKjhecPF+oYng9n1StzLFfBcTE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aF3F58qGWDFwbZMfbrVXIE3FNqfQlzE9meqRbqySTJ5kMFYqp3JI9bu23HKRPdZb5
	 5hVI7QqL/RlNNTd0oQFfKGylGXbo6vYobS52Dx3f9uPlwgQ2ZGCdbBjqG5BZv/4KoU
	 h2uboLufuQPyHKp4xpbwaWij+vSHsqyQuGdlnrkZM0j/AzRYK/bSNpKo9/kbw0nt+R
	 InAMn8bvskbebFJJk2SReoWSpfM/LeQb+XzgDvw1t/CWX8eVSL1P9S6QsiFmhvAzAZ
	 LKT3O+/73sj5GYn8OmNURvLcw8UmpkM55vNviF8MrKqQTZTxw8oRXS0Q/eZxYnSlE/
	 8hdaynMLcaGRQ==
Date: Sun, 31 Dec 2023 15:16:34 -0800
Subject: [PATCH 12/18] xfs_repair: deduplicate strings stored in string blob
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007022.1805510.370858683587822792.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reduce the memory requirements of the string blob structure by
deduplicating the strings stored within.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c     |   13 ++++-
 repair/strblobs.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 repair/strblobs.h |    9 +++
 3 files changed, 153 insertions(+), 9 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 88970f81348..3ea5514531c 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -50,7 +50,7 @@
  *
  * becomes this backwards information:
  *
- *     (child_agino*, dir_ino*, dir_gen, name*)
+ *     (child_agino*, dir_ino*, dir_gen, name_cookie*)
  *
  * Key fields are starred.
  *
@@ -58,6 +58,10 @@
  * that names are stored separately in an xfblob data structure so that the
  * rest of the information can be sorted and processed as fixed-size records;
  * the incore parent pointer record contains a pointer to the strblob data.
+ * Because string blobs are deduplicated, there's a 1:1 mapping of name cookies
+ * to strings, which means that we can use the name cookie as a comparison key
+ * instead of loading the full dentry name every time we want to perform a
+ * comparison.
  */
 
 struct ag_pptr {
@@ -115,15 +119,18 @@ parent_ptr_init(
 	struct xfs_mount	*mp)
 {
 	char			*descr;
+	uint64_t		iused;
 	xfs_agnumber_t		agno;
 	int			error;
 
 	if (!xfs_has_parent(mp))
 		return;
 
+	/* One hash bucket per inode, up to about 8M of memory on 64-bit. */
+	iused = min(mp->m_sb.sb_icount - mp->m_sb.sb_ifree, 1048573);
 	descr = kasprintf("xfs_repair (%s): parent pointer names",
 			mp->m_fsname);
-	error = strblobs_init(descr, &nameblobs);
+	error = strblobs_init(descr, iused, &nameblobs);
 	kfree(descr);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
@@ -180,7 +187,7 @@ add_parent_ptr(
 
 	pthread_mutex_lock(&names_mutex);
 	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
-			ag_pptr.namelen);
+			ag_pptr.namelen, ag_pptr.namehash);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
 		do_error(_("storing name '%s' failed: %s\n"),
diff --git a/repair/strblobs.c b/repair/strblobs.c
index 45d2559c722..4ed21e9536d 100644
--- a/repair/strblobs.c
+++ b/repair/strblobs.c
@@ -13,22 +13,42 @@
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
 
@@ -36,6 +56,7 @@ strblobs_init(
 	if (error)
 		goto out_free;
 
+	sb->nr_buckets = hash_buckets;
 	*sblobs = sb;
 	return 0;
 
@@ -50,21 +71,132 @@ strblobs_destroy(
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
index 27e98eee208..40cd6d8e91c 100644
--- a/repair/strblobs.h
+++ b/repair/strblobs.h
@@ -8,12 +8,17 @@
 
 struct strblobs;
 
-int strblobs_init(const char *descr, struct strblobs **sblobs);
+int strblobs_init(const char *descr, unsigned int hash_buckets,
+		struct strblobs **sblobs);
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

