Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C70179E1
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302864; cv=none; b=CK2RhQBk6CO7qL3XD7W3jI+5LlCFrWBEcQaNHp7o54QZU/WzY1XZ8F8T/dYkk+njA3PKiOv2CntzVvRQp1B4TRtNhVPjLS5nrWmVg4ztBKlfZmrlDMWFkxbTwIaDO+DIlg3XFPaEakYEpCTaib6BcC7XihN2bHaPWxP5ZwZgNHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302864; c=relaxed/simple;
	bh=u3007zI65Nr7bsUX+kYnKHB7x9TLDULJegU5EjLJDqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajXk4gFdevuXSba/bxgXLBTME6Dbitmt6ComWHp3ypAmH0ZcUOrrGsVl3cvwiUoL2KWUVznhyqnIkp9sa93Cx0nNeQWVthgdULwA1qpdw/NUQLM74kVda8E4CIgowYAPSCuDcQMP+rG8KdrgsYkz0O4Fxab4n4DnRPvxMXFj35Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/DaxTrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/DaxTrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A2CC32786;
	Tue, 30 Jul 2024 01:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302863;
	bh=u3007zI65Nr7bsUX+kYnKHB7x9TLDULJegU5EjLJDqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P/DaxTrE2rAf2MhGng/0gX/5C9N3h84Z3ZiJRbQ+NWxxpJM7vU0tQZePJ/P0Hypat
	 kEPuEKIW63y1vVGnm9sSCrMxARs34iQUuVopdHzmxdVvQ73NETBE6kM72pFSqHYuY5
	 DqOgqAcbo49HYvOzToymq2yZ+KijQFnpWtUTTIagIec1dICTR/D9v0Eu1w1Bh+9Wyk
	 v1bgAhnWoHK6UmCcKq9BUt5UyNctdU8k4Z+djtdXqr43Nd18ejiaKCcnZvVOPn0U1c
	 Yxg/7vBk130+VohiIi5IvdNR5fgu71tP8yOqr3Vd8IYSef5BBEH+lVBuJCeG54jAUM
	 A6z1bYOZYXjNw==
Date: Mon, 29 Jul 2024 18:27:43 -0700
Subject: [PATCH 08/12] xfs_repair: deduplicate strings stored in string blob
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851590.1352527.9464164025188189424.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/pptr.c     |   13 ++++-
 repair/strblobs.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 repair/strblobs.h |    9 +++
 3 files changed, 153 insertions(+), 9 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 9f219b398..f8db57b2c 100644
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
@@ -121,15 +125,18 @@ parent_ptr_init(
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
 	descr = kasprintf(GFP_KERNEL, "xfs_repair (%s): parent pointer names",
 			mp->m_fsname);
-	error = strblobs_init(descr, &nameblobs);
+	error = strblobs_init(descr, iused, &nameblobs);
 	kfree(descr);
 	if (error)
 		do_error(_("init parent pointer names failed: %s\n"),
@@ -190,7 +197,7 @@ add_parent_ptr(
 
 	pthread_mutex_lock(&names_mutex);
 	error = strblobs_store(nameblobs, &ag_pptr.name_cookie, fname,
-			ag_pptr.namelen);
+			ag_pptr.namelen, ag_pptr.namehash);
 	pthread_mutex_unlock(&names_mutex);
 	if (error)
 		do_error(_("storing name '%s' failed: %s\n"),
diff --git a/repair/strblobs.c b/repair/strblobs.c
index 45d2559c7..3cd678dbb 100644
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
+	unsigned char		*buf = NULL;
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
index 27e98eee2..40cd6d8e9 100644
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

