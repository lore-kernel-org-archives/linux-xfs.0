Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B428EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302363; cv=none; b=f9mkwj/WTsWL9BYOc48HKSOmj0Nbp5k3lSuUpBqSFUJ/VfTQMcs29oHwrVClTt0pavVn164q2XaK2ux69xLeKzU5wN6FbsbHuWLM9yWjqAI6B+uYga7OhZFXCGZmWIDaVI8tVAwJ6Px6R0VQl30l47iBlrSGry/3g+2AUzgZKi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302363; c=relaxed/simple;
	bh=tP0K5wXI2S/at1TxL27wK7PGwjBUOEQnlEuVTYk9Fyc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KE5b6lkBXaKJOqcwskOeiNIiItN/+XupQ6XP0rE5Pni3Z02v8mEanN8dAcXLMlJBjThWPgs86fIazue9JeRI6biA/ugkFrpAXzRplIcc0zuh/4BRlrFoX17/Fke/ubLcYwGrS8x16ZSYzHXV0gUFLO4UBaOxD+RAXxtYJ5kx8yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMe5rRb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMe5rRb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3624C32786;
	Tue, 30 Jul 2024 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302362;
	bh=tP0K5wXI2S/at1TxL27wK7PGwjBUOEQnlEuVTYk9Fyc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PMe5rRb0hYonfkI1OmPvDlgv/i+y6OquaeHxQfrGETim2lx/qdcao0B8j/Nifr72O
	 cfogCW/c+NiqjR0j0wWVhuzxKIQk0RvWVTvxkRzgPFK3ULhPn6GbnlvMEkpcqiW9Y8
	 /Jg6BgkHn15D5vDUxTgBs7XwRUR/4lJPUAV7MMIjCODm08V0iXxeOHv2+ZU/vnFRqQ
	 TrM7Q+qNejK7Ab18nJl/rdOsCQCz6lpmnTFQphHvRJwEXWe4fNLiRXEPc10SW41/LA
	 kLeRt+HQEE8ZCieMWCe/lOidUCi+tCPv0voTEhxyl1RI2KKzxmlomcTfRKaahXjS8/
	 yftgz9pmnUNvg==
Date: Mon, 29 Jul 2024 18:19:22 -0700
Subject: [PATCH 02/24] xfs_{db,repair}: implement new attr hash value function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850548.1350924.9508256472898863803.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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

Port existing utilities to use libxfs_attr_hashname instead of calling
libxfs_da_hashname directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/hash.c                |    8 ++++----
 db/metadump.c            |   10 +++++-----
 libxfs/libxfs_api_defs.h |    2 ++
 repair/attr_repair.c     |   18 ++++++++++++------
 4 files changed, 23 insertions(+), 15 deletions(-)


diff --git a/db/hash.c b/db/hash.c
index 9b3fdea6c..1500a6032 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -73,7 +73,7 @@ hash_f(
 		if (use_dir2_hash)
 			hashval = libxfs_dir2_hashname(mp, &xname);
 		else
-			hashval = libxfs_da_hashname(xname.name, xname.len);
+			hashval = libxfs_attr_hashname(xname.name, xname.len);
 		dbprintf("0x%x\n", hashval);
 	}
 
@@ -306,7 +306,7 @@ collide_xattrs(
 	unsigned long		i;
 	int			error = 0;
 
-	old_hash = libxfs_da_hashname((uint8_t *)name, namelen);
+	old_hash = libxfs_attr_hashname((uint8_t *)name, namelen);
 
 	if (fd >= 0) {
 		/*
@@ -331,8 +331,8 @@ collide_xattrs(
 		snprintf(xattrname, MAXNAMELEN + 5, "user.%s", name);
 		obfuscate_name(old_hash, namelen, (uint8_t *)xattrname + 5,
 				false);
-		ASSERT(old_hash == libxfs_da_hashname((uint8_t *)xattrname + 5,
-				namelen));
+		ASSERT(old_hash == libxfs_attr_hashname(
+					(uint8_t *)xattrname + 5, namelen));
 
 		if (fd >= 0) {
 			error = fsetxattr(fd, xattrname, "1", 1, 0);
diff --git a/db/metadump.c b/db/metadump.c
index 9457e02e8..c1bf5d002 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -835,7 +835,7 @@ dirattr_hashname(
 		return libxfs_dir2_hashname(mp, &xname);
 	}
 
-	return libxfs_da_hashname(name, namelen);
+	return libxfs_attr_hashname(name, namelen);
 }
 
 static void
@@ -982,9 +982,9 @@ obfuscate_path_components(
 		if (!slash) {
 			/* last (or single) component */
 			namelen = strnlen((char *)comp, len);
-			hash = libxfs_da_hashname(comp, namelen);
+			hash = dirattr_hashname(true, comp, namelen);
 			obfuscate_name(hash, namelen, comp, false);
-			ASSERT(hash == libxfs_da_hashname(comp, namelen));
+			ASSERT(hash == dirattr_hashname(true, comp, namelen));
 			break;
 		}
 		namelen = slash - (char *)comp;
@@ -994,9 +994,9 @@ obfuscate_path_components(
 			len--;
 			continue;
 		}
-		hash = libxfs_da_hashname(comp, namelen);
+		hash = dirattr_hashname(true, comp, namelen);
 		obfuscate_name(hash, namelen, comp, false);
-		ASSERT(hash == libxfs_da_hashname(comp, namelen));
+		ASSERT(hash == dirattr_hashname(true, comp, namelen));
 		comp += namelen + 1;
 		len -= namelen + 1;
 	}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2d858580a..c36a6ac81 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -38,6 +38,8 @@
 
 #define xfs_attr_check_namespace	libxfs_attr_check_namespace
 #define xfs_attr_get			libxfs_attr_get
+#define xfs_attr_hashname		libxfs_attr_hashname
+#define xfs_attr_hashval		libxfs_attr_hashval
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 37b5852b8..8321c9b67 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -485,6 +485,7 @@ process_leaf_attr_local(
 	xfs_ino_t		ino)
 {
 	xfs_attr_leaf_name_local_t *local;
+	xfs_dahash_t		computed;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
 	if (local->namelen == 0 ||
@@ -504,9 +505,12 @@ process_leaf_attr_local(
 	 * ordering anyway in case both the name value and the
 	 * hashvalue were wrong but matched. Unlikely, however.
 	 */
-	if (be32_to_cpu(entry->hashval) != libxfs_da_hashname(
-				&local->nameval[0], local->namelen) ||
-				be32_to_cpu(entry->hashval) < last_hashval) {
+	computed = libxfs_attr_hashval(mp, entry->flags, local->nameval,
+				       local->namelen,
+				       local->nameval + local->namelen,
+				       be16_to_cpu(local->valuelen));
+	if (be32_to_cpu(entry->hashval) != computed ||
+	    be32_to_cpu(entry->hashval) < last_hashval) {
 		do_warn(
 	_("bad hashvalue for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
 			i, da_bno, ino);
@@ -540,15 +544,17 @@ process_leaf_attr_remote(
 {
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
+	xfs_dahash_t		computed;
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
+	computed = libxfs_attr_hashval(mp, entry->flags, remotep->name,
+				       remotep->namelen, NULL,
+				       be32_to_cpu(remotep->valuelen));
 	if (remotep->namelen == 0 ||
 	    !libxfs_attr_namecheck(entry->flags, remotep->name,
 				   remotep->namelen) ||
-	    be32_to_cpu(entry->hashval) !=
-			libxfs_da_hashname((unsigned char *)&remotep->name[0],
-					   remotep->namelen) ||
+	    be32_to_cpu(entry->hashval) != computed ||
 	    be32_to_cpu(entry->hashval) < last_hashval ||
 	    be32_to_cpu(remotep->valueblk) == 0) {
 		do_warn(

