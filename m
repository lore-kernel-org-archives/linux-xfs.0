Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D0CC140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swjP+EAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8790EC433C7;
	Sun, 31 Dec 2023 22:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062812;
	bh=zCTRNpsVdxDz0/ttBc+n85M4uxtTzLxzMMWvkmXHarE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=swjP+EASP56Zf49meuR3pGZi5cmc9xi+syPqw9zxMAXejksOY4w7opPpe/Bvmtto5
	 yPeWTWrxaZ24/4vaiWMEDEIML0eic7HmV5hlLZB88L9az8PmsrtogU+Vu51321+U8U
	 6OL3+1+8Bt/BT24ck21YOhAfrX78g8TTtGESaTXu/39I7YtETNYe+yp0AGRS412R3u
	 bmzbe3Vs0Zpaj1H3/4qvcJ++BMYiVcoK/GbxUmQc1INU+N5lWgtvHgidpPNWF6OJSX
	 EbNWgfHiU/dvKDoOC3YFfFhcd+ALSssQ55d6xG/J2kTJYDf1JoNP2k9H66K45Oj9iW
	 ViD3fA1+CJyuw==
Date: Sun, 31 Dec 2023 14:46:52 -0800
Subject: [PATCH 07/13] xfs_scrub: store bad flags with the name entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000676.1798385.3442647022690481167.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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

When scrub is checking unicode names, there are certain properties of
the directory/attribute/label name itself that it can complain about.
Store these in struct name_entry so that the confusable names detector
can pick this up later.

This restructuring enables a subsequent patch to detect suspicious
sequences in the NFC normalized form of the name without needing to hang
on to that NFC form until the end of processing.  IOWs, it's a memory
usage optimization.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |  122 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 58 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 385e42c6acc..a770d0d7aae 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -69,6 +69,9 @@ struct name_entry {
 
 	xfs_ino_t		ino;
 
+	/* Everything that we don't like about this name. */
+	unsigned int		badflags;
+
 	/* Raw dirent name */
 	size_t			namelen;
 	char			name[0];
@@ -274,6 +277,55 @@ name_entry_compute_checknames(
 	return false;
 }
 
+/*
+ * Check a name for suspicious elements that have appeared in filename
+ * spoofing attacks.  This includes names that mixed directions or contain
+ * direction overrides control characters, both of which have appeared in
+ * filename spoofing attacks.
+ */
+static unsigned int
+name_entry_examine(
+	const struct name_entry	*entry)
+{
+	UCharIterator		uiter;
+	UChar32			uchr;
+	uint8_t			mask = 0;
+	unsigned int		ret = 0;
+
+	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
+	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
+	/* characters are invisible */
+		if (is_nonrendering(uchr))
+			ret |= UNICRASH_ZERO_WIDTH;
+
+		/* control characters */
+		if (u_iscntrl(uchr))
+			ret |= UNICRASH_CONTROL_CHAR;
+
+		switch (u_charDirection(uchr)) {
+		case U_LEFT_TO_RIGHT:
+			mask |= 0x01;
+			break;
+		case U_RIGHT_TO_LEFT:
+			mask |= 0x02;
+			break;
+		case U_RIGHT_TO_LEFT_OVERRIDE:
+			ret |= UNICRASH_BIDI_OVERRIDE;
+			break;
+		case U_LEFT_TO_RIGHT_OVERRIDE:
+			ret |= UNICRASH_BIDI_OVERRIDE;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* mixing left-to-right and right-to-left chars */
+	if (mask == 0x3)
+		ret |= UNICRASH_BIDI_MIXED;
+	return ret;
+}
+
 /* Create a new name entry, returns false if we could not succeed. */
 static bool
 name_entry_create(
@@ -299,6 +351,7 @@ name_entry_create(
 	if (!name_entry_compute_checknames(uc, new_entry))
 		goto out;
 
+	new_entry->badflags = name_entry_examine(new_entry);
 	*entry = new_entry;
 	return true;
 
@@ -360,54 +413,6 @@ name_entry_hash(
 	}
 }
 
-/*
- * Check a name for suspicious elements that have appeared in filename
- * spoofing attacks.  This includes names that mixed directions or contain
- * direction overrides control characters, both of which have appeared in
- * filename spoofing attacks.
- */
-static void
-name_entry_examine(
-	struct name_entry	*entry,
-	unsigned int		*badflags)
-{
-	UCharIterator		uiter;
-	UChar32			uchr;
-	uint8_t			mask = 0;
-
-	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
-	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
-		/* characters are invisible */
-		if (is_nonrendering(uchr))
-			*badflags |= UNICRASH_ZERO_WIDTH;
-
-		/* control characters */
-		if (u_iscntrl(uchr))
-			*badflags |= UNICRASH_CONTROL_CHAR;
-
-		switch (u_charDirection(uchr)) {
-		case U_LEFT_TO_RIGHT:
-			mask |= 0x01;
-			break;
-		case U_RIGHT_TO_LEFT:
-			mask |= 0x02;
-			break;
-		case U_RIGHT_TO_LEFT_OVERRIDE:
-			*badflags |= UNICRASH_BIDI_OVERRIDE;
-			break;
-		case U_LEFT_TO_RIGHT_OVERRIDE:
-			*badflags |= UNICRASH_BIDI_OVERRIDE;
-			break;
-		default:
-			break;
-		}
-	}
-
-	/* mixing left-to-right and right-to-left chars */
-	if (mask == 0x3)
-		*badflags |= UNICRASH_BIDI_MIXED;
-}
-
 /* Initialize the collision detector. */
 static int
 unicrash_init(
@@ -638,17 +643,17 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
  * must be skeletonized according to Unicode TR39 to detect names that
  * could be visually confused with each other.
  */
-static void
+static unsigned int
 unicrash_add(
 	struct unicrash		*uc,
 	struct name_entry	**new_entryp,
-	unsigned int		*badflags,
 	struct name_entry	**existing_entry)
 {
 	struct name_entry	*new_entry = *new_entryp;
 	struct name_entry	*entry;
 	size_t			bucket;
 	xfs_dahash_t		hash;
+	unsigned int		badflags = new_entry->badflags;
 
 	/* Store name in hashtable. */
 	hash = name_entry_hash(new_entry);
@@ -669,28 +674,30 @@ unicrash_add(
 			uc->buckets[bucket] = new_entry->next;
 			name_entry_free(new_entry);
 			*new_entryp = NULL;
-			return;
+			return 0;
 		}
 
 		/* Same normalization? */
 		if (new_entry->normstrlen == entry->normstrlen &&
 		    !u_strcmp(new_entry->normstr, entry->normstr) &&
 		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
-			*badflags |= UNICRASH_NOT_UNIQUE;
+			badflags |= UNICRASH_NOT_UNIQUE;
 			*existing_entry = entry;
-			return;
+			break;
 		}
 
 		/* Confusable? */
 		if (new_entry->skelstrlen == entry->skelstrlen &&
 		    !u_strcmp(new_entry->skelstr, entry->skelstr) &&
 		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
-			*badflags |= UNICRASH_CONFUSABLE;
+			badflags |= UNICRASH_CONFUSABLE;
 			*existing_entry = entry;
-			return;
+			break;
 		}
 		entry = entry->next;
 	}
+
+	return badflags;
 }
 
 /* Check a name for unicode normalization problems or collisions. */
@@ -704,14 +711,13 @@ __unicrash_check_name(
 {
 	struct name_entry	*dup_entry = NULL;
 	struct name_entry	*new_entry = NULL;
-	unsigned int		badflags = 0;
+	unsigned int		badflags;
 
 	/* If we can't create entry data, just skip it. */
 	if (!name_entry_create(uc, name, ino, &new_entry))
 		return 0;
 
-	name_entry_examine(new_entry, &badflags);
-	unicrash_add(uc, &new_entry, &badflags, &dup_entry);
+	badflags = unicrash_add(uc, &new_entry, &dup_entry);
 	if (new_entry && badflags)
 		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);

