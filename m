Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41000 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCUDkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:14 -0400
Subject: [PATCH 05/14] xfs_scrub: make name_entry a first class structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:40:10 -0700
Message-ID: <152160361091.8288.13615401988451480485.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of open-coding the construction and hashtable insertion of name
entries, make name_entry a first class object.  This means that we now
have name_entry_ prefix functions that take care of computing Unicode
normalized names as part of name_entry construction, and we pass around
the name_entries when we're looking for suspicious characters and
identically rendering names.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/unicrash.c |  264 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 157 insertions(+), 107 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 3538a60..51da32c 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -61,9 +61,16 @@
 
 struct name_entry {
 	struct name_entry	*next;
+
+	/* NFKC normalized name */
+	uint8_t			*normstr;
+	size_t			normstrlen;
+
 	xfs_ino_t		ino;
-	size_t			uninamelen;
-	uint8_t			uniname[0];
+
+	/* Raw UTF8 name */
+	size_t			namelen;
+	char			name[0];
 };
 #define NAME_ENTRY_SZ(nl)	(sizeof(struct name_entry) + 1 + \
 				 (nl * sizeof(uint8_t)))
@@ -119,6 +126,120 @@ is_utf8_locale(void)
 	return answer;
 }
 
+/*
+ * Generate normalized form of the name.
+ * If this fails, just forget everything; this is an advisory checker.
+ */
+static bool
+name_entry_compute_checknames(
+	struct unicrash		*uc,
+	struct name_entry	*entry)
+{
+	uint8_t			*normstr;
+	size_t			normstrlen;
+
+	normstrlen = (entry->namelen * 2) + 1;
+	normstr = calloc(normstrlen, sizeof(uint8_t));
+	if (!normstr)
+		return false;
+
+	if (!u8_normalize(UNINORM_NFKC, (const uint8_t *)entry->name,
+			entry->namelen, normstr, &normstrlen));
+		goto out_normstr;
+
+	entry->normstr = normstr;
+	entry->normstrlen = normstrlen;
+	return true;
+out_normstr:
+	free(normstr);
+	return false;
+}
+
+/* Create a new name entry, returns false if we could not succeed. */
+static bool
+name_entry_create(
+	struct unicrash		*uc,
+	const char		*name,
+	xfs_ino_t		ino,
+	struct name_entry	**entry)
+{
+	struct name_entry	*new_entry;
+	size_t			namelen = strlen(name);
+
+	/* Create new entry */
+	new_entry = calloc(NAME_ENTRY_SZ(namelen), 1);
+	if (!new_entry)
+		return false;
+	new_entry->next = NULL;
+	new_entry->ino = ino;
+	memcpy(new_entry->name, name, namelen);
+	new_entry->name[namelen] = 0;
+	new_entry->namelen = namelen;
+
+	/* Normalize name to find collisions. */
+	if (!name_entry_compute_checknames(uc, new_entry))
+		goto out;
+
+	*entry = new_entry;
+	return true;
+
+out:
+	free(new_entry);
+	return false;
+}
+
+/* Free a name entry */
+static void
+name_entry_free(
+	struct name_entry	*entry)
+{
+	free(entry->normstr);
+	free(entry);
+}
+
+/* Adapt the dirhash function from libxfs, avoid linking with libxfs. */
+
+#define rol32(x, y)		(((x) << (y)) | ((x) >> (32 - (y))))
+
+/*
+ * Implement a simple hash on a character string.
+ * Rotate the hash value by 7 bits, then XOR each character in.
+ * This is implemented with some source-level loop unrolling.
+ */
+static xfs_dahash_t
+name_entry_hash(
+	struct name_entry	*entry)
+{
+	uint8_t			*name;
+	size_t			namelen;
+	xfs_dahash_t		hash;
+
+	name = entry->normstr;
+	namelen = entry->normstrlen;
+
+	/*
+	 * Do four characters at a time as long as we can.
+	 */
+	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
+		       (name[3] << 0) ^ rol32(hash, 7 * 4);
+
+	/*
+	 * Now do the rest of the characters.
+	 */
+	switch (namelen) {
+	case 3:
+		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
+		       rol32(hash, 7 * 3);
+	case 2:
+		return (name[0] << 7) ^ (name[1] << 0) ^ rol32(hash, 7 * 2);
+	case 1:
+		return (name[0] << 0) ^ rol32(hash, 7 * 1);
+	default: /* case 0: */
+		return hash;
+	}
+}
+
 /* Initialize the collision detector. */
 static bool
 unicrash_init(
@@ -190,89 +311,28 @@ unicrash_free(
 	for (i = 0; i < uc->nr_buckets; i++) {
 		for (ne = uc->buckets[i]; ne != NULL; ne = x) {
 			x = ne->next;
-			free(ne);
+			name_entry_free(ne);
 		}
 	}
 	free(uc);
 }
 
-/* Steal the dirhash function from libxfs, avoid linking with libxfs. */
-
-#define rol32(x, y)		(((x) << (y)) | ((x) >> (32 - (y))))
-
-/*
- * Implement a simple hash on a character string.
- * Rotate the hash value by 7 bits, then XOR each character in.
- * This is implemented with some source-level loop unrolling.
- */
-static xfs_dahash_t
-unicrash_hashname(
-	const uint8_t		*name,
-	size_t			namelen)
-{
-	xfs_dahash_t		hash;
-
-	/*
-	 * Do four characters at a time as long as we can.
-	 */
-	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
-		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
-		       (name[3] << 0) ^ rol32(hash, 7 * 4);
-
-	/*
-	 * Now do the rest of the characters.
-	 */
-	switch (namelen) {
-	case 3:
-		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
-		       rol32(hash, 7 * 3);
-	case 2:
-		return (name[0] << 7) ^ (name[1] << 0) ^ rol32(hash, 7 * 2);
-	case 1:
-		return (name[0] << 0) ^ rol32(hash, 7 * 1);
-	default: /* case 0: */
-		return hash;
-	}
-}
-
-/*
- * Normalize a name according to Unicode NFKC normalization rules.
- * Returns true if the name was already normalized.
- */
-static bool
-unicrash_normalize(
-	const char		*in,
-	uint8_t			*out,
-	size_t			outlen)
-{
-	size_t			inlen = strlen(in);
-
-	assert(inlen <= outlen);
-	if (!u8_normalize(UNINORM_NFKC, (const uint8_t *)in, inlen,
-			out, &outlen)) {
-		/* Didn't normalize, just return the same buffer. */
-		memcpy(out, in, inlen + 1);
-		return true;
-	}
-	out[outlen] = 0;
-	return outlen == inlen ? memcmp(in, out, inlen) == 0 : false;
-}
-
 /* Complain about Unicode problems. */
 static void
 unicrash_complain(
 	struct unicrash		*uc,
 	const char		*descr,
 	const char		*what,
+	struct name_entry	*entry,
 	unsigned int		badflags,
-	const char		*name,
-	uint8_t			*uniname)
+	struct name_entry	*dup_entry)
 {
 	char			*bad1 = NULL;
 	char			*bad2 = NULL;
 
-	bad1 = string_escape(name);
-	bad2 = string_escape((char *)uniname);
+	bad1 = string_escape(entry->name);
+	if (dup_entry)
+		bad2 = string_escape(dup_entry->name);
 
 	/*
 	 * Two names that normalize to the same string will render
@@ -294,52 +354,39 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 
 /*
  * Try to add a name -> ino entry to the collision detector.  The name
- * must be normalized according to Unicode NFKC normalization rules to
- * detect byte-unique names that map to the same sequence of Unicode
- * code points.
- *
- * This function returns true either if there was no previous mapping or
- * there was a mapping that matched exactly.  It returns false if
- * there is already a record with that name pointing to a different
- * inode.
+ * must be normalized according to Unicode NFKC rules to detect names that
+ * could be confused with each other.
  */
 static bool
 unicrash_add(
 	struct unicrash		*uc,
-	uint8_t			*uniname,
-	xfs_ino_t		ino,
-	unsigned int		*badflags)
+	struct name_entry	*new_entry,
+	unsigned int		*badflags,
+	struct name_entry	**existing_entry)
 {
-	struct name_entry	*ne;
-	struct name_entry	*x;
-	struct name_entry	**nep;
-	size_t			uninamelen = u8_strlen(uniname);
+	struct name_entry	*entry;
 	size_t			bucket;
 	xfs_dahash_t		hash;
 
-	/* Do we already know about that name? */
-	hash = unicrash_hashname(uniname, uninamelen);
+	/* Store name in hashtable. */
+	hash = name_entry_hash(new_entry);
 	bucket = hash % uc->nr_buckets;
-	for (nep = &uc->buckets[bucket], ne = *nep; ne != NULL; ne = x) {
-		if (u8_strcmp(uniname, ne->uniname) == 0 &&
-		    (uc->compare_ino ? ino != ne->ino : true)) {
+	entry = uc->buckets[bucket];
+	new_entry->next = entry;
+	uc->buckets[bucket] = new_entry;
+
+	while (entry != NULL) {
+		/* Same normalization? */
+		if (new_entry->normstrlen == entry->normstrlen &&
+		    !u8_strcmp(new_entry->normstr, entry->normstr) &&
+		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
 			*badflags |= UNICRASH_NOT_UNIQUE;
+			*existing_entry = entry;
 			return true;
 		}
-		nep = &ne->next;
-		x = ne->next;
+		entry = entry->next;
 	}
 
-	/* Remember that name. */
-	x = malloc(NAME_ENTRY_SZ(uninamelen));
-	if (!x)
-		return false;
-	x->next = NULL;
-	x->ino = ino;
-	x->uninamelen = uninamelen;
-	memcpy(x->uniname, uniname, uninamelen + 1);
-	*nep = x;
-
 	return true;
 }
 
@@ -352,19 +399,22 @@ __unicrash_check_name(
 	const char		*name,
 	xfs_ino_t		ino)
 {
-	uint8_t			uniname[(NAME_MAX * 2) + 1];
+	struct name_entry	*dup_entry = NULL;
+	struct name_entry	*new_entry;
 	unsigned int		badflags = 0;
 	bool			moveon;
 
-	memset(uniname, 0, (NAME_MAX * 2) + 1);
-	unicrash_normalize(name, uniname, NAME_MAX * 2);
-	moveon = unicrash_add(uc, uniname, ino, &badflags);
+	/* If we can't create entry data, just skip it. */
+	if (!name_entry_create(uc, name, ino, &new_entry))
+		return true;
+
+	moveon = unicrash_add(uc, new_entry, &badflags, &dup_entry);
 	if (!moveon)
 		return false;
 
 	if (badflags)
-		unicrash_complain(uc, descr, namedescr, badflags, name,
-				uniname);
+		unicrash_complain(uc, descr, namedescr, new_entry, badflags,
+				dup_entry);
 
 	return true;
 }

