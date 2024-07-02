Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5779CC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882673; cv=none; b=YskPL28Y6Ys9MGM1fpKvRwUie5fMiAfnaulqnDppc4k4hP4JJ6kMA2i3n6MbvKkp7UkwXAk/7hLROELiz07kDByoAvMPvdrqfJPD5zm0WokWAsWPnzFM0INFw5z2gusamfIsYa9+Xr3juGPVQ5urkV9YY9NeeEsS6R2kf6hHI54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882673; c=relaxed/simple;
	bh=4FxuukcafAOvmgxtFs4sNID+kztlgmKG1hhV6FsVifA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sotaA8r/9dBNEcpOkahxHa60pMoqhwgAmgynm25kYkJ3L7mKRDiWqXhotY3x6IfpiGxAXnGhGCFgWgbVCe3pswfE4Odj9YSz0Aqqc3dO/UKlBLXE5MCb95UwBQFFYRtYIWh/wXo6b+9oMrSRu7G9AyF6smOd1/fbC6OfDqdSk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgszWyJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgszWyJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283E9C116B1;
	Tue,  2 Jul 2024 01:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882673;
	bh=4FxuukcafAOvmgxtFs4sNID+kztlgmKG1hhV6FsVifA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sgszWyJc5mJjHVhWKlEokYJ5d7kyjbe2y53lE1Znq1qRNQ9e9BiinrwZ66VuvJ39J
	 wxZRx8B7ATLhCMrCQLKNMQE2YaeyoQRV/n9akhYE1xBZiObsR2Bc0AkjzQylahJM0f
	 icvGEB7Ol+698ARWqB71/YPI8a6V8eKZ/vYWs+JScnXQDBHj/MlpmBnZgjFQySp39j
	 Tr00+Vl6eAkHHQH79qXByW+AGwkGodXM+sWsxPoYVpWWSo0rbZ6+bGQuOyCv6sAU4y
	 7N0Q42SWlqPu2s2rXJpZ3xtgMTDQzLTpXHFVzXrLMjn45KLYO3gLo2jZf7r2pLamz5
	 RLXV/GOKzWRlg==
Date: Mon, 01 Jul 2024 18:11:12 -0700
Subject: [PATCH 02/24] xfs_{db,repair}: implement new attr hash value function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121093.2009260.4332172990916225703.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
---
 db/hash.c                |    8 ++++----
 db/metadump.c            |   10 +++++-----
 libxfs/libxfs_api_defs.h |    2 ++
 repair/attr_repair.c     |   18 ++++++++++++------
 4 files changed, 23 insertions(+), 15 deletions(-)


diff --git a/db/hash.c b/db/hash.c
index 9b3fdea6c413..1500a6032fd7 100644
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
index 9457e02e8288..c1bf5d002751 100644
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
index 2d858580abfe..c36a6ac81a7b 100644
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
index 37b5852b885e..8321c9b679b2 100644
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

