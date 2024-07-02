Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B52038B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883221; cv=none; b=kDrf4Llth4hu+CaLzUQZRnn9XYMbeOYC3Wn2avL6bre7mPasHKbPp4cRpCgx/Y/8dthOoTLDKuBR5I2JhFzQg6qAoBk1iSKNI9sfMZQky60K1wl2NpXGEkw6NoPNDbuQwWo8wx3wPykuWVuNTaK2gO5wDHYn47qdkutuzkGNHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883221; c=relaxed/simple;
	bh=kDhpKlLishcifl0GAzSHTkL/OL/dIV07jKXSEpMri2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgTUhEaeiteG6GMsWFv2rormTFdOPp3CP7kyEZV1wEiD2borHTBuyn6yZ/qD3MkfnYTb5jxYxSmqdghbNz9jjkc+1+bTafVLAglch4tms7cPWXT2hFQMBCluVTRgqIFT5BhVr1Yvm+6GnvdbSMlQF4uN9RkCqcqkfL6y23XNnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmmedEn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmmedEn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7FFC116B1;
	Tue,  2 Jul 2024 01:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883220;
	bh=kDhpKlLishcifl0GAzSHTkL/OL/dIV07jKXSEpMri2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LmmedEn7CdLkw4teLVptjvQ9IHTKTv5sp4ZuNTEAhBjZlIqCRLOVTQrDZXsZGIsSb
	 eklX1nEsTf/Mivg0vHbjYmvPqm5FWvfH7fEsxEvqUqKgfxuWRs1bfpIXmFzIwCbFrC
	 U3KWci6XfRUqqr/gUY3vdDEkOqo87IG2OvNZGDqrxHXqfyb668YoMGIDL07B6OyeHa
	 RJDBssM9xkB2QL5bq5DVmO0glFZ2FOzuePIT3fUI4TxPtUUVhIUj0JsgOitGWgbH4H
	 vK8wSsM/N6gkJorqMfE5dNF3xwZuyuf2Q8bSKnD/3XefwcdulG80Vhhx72NSVcB9js
	 /ad+2kGHASDuQ==
Date: Mon, 01 Jul 2024 18:20:20 -0700
Subject: [PATCH 11/12] xfs_repair: update ondisk parent pointer records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122336.2010218.16979367018169015160.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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

Update the ondisk parent pointer records as necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/pptr.c            |   88 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 87 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e12f0a40b00a..df316727bd62 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -209,8 +209,10 @@
 #define xfs_parent_hashval		libxfs_parent_hashval
 #define xfs_parent_lookup		libxfs_parent_lookup
 #define xfs_parent_removename		libxfs_parent_removename
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_from_attr		libxfs_parent_from_attr
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put
diff --git a/repair/pptr.c b/repair/pptr.c
index 61466009d88b..94d6d834627c 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -673,6 +673,44 @@ load_file_pptr_name(
 			name, file_pptr->namelen);
 }
 
+/* Add an on disk parent pointer to a file. */
+static int
+add_file_pptr(
+	struct xfs_inode		*ip,
+	const struct ag_pptr		*ag_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= ag_pptr->namelen,
+	};
+	struct xfs_parent_rec		pptr_rec = { };
+	struct xfs_da_args		scratch;
+
+	xfs_parent_rec_init(&pptr_rec, ag_pptr->parent_ino,
+			ag_pptr->parent_gen);
+	return -libxfs_parent_set(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+}
+
+/* Remove an on disk parent pointer from a file. */
+static int
+remove_file_pptr(
+	struct xfs_inode		*ip,
+	const struct file_pptr		*file_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= file_pptr->namelen,
+	};
+	struct xfs_parent_rec		pptr_rec = { };
+	struct xfs_da_args		scratch;
+
+	xfs_parent_rec_init(&pptr_rec, file_pptr->parent_ino,
+			file_pptr->parent_gen);
+	return -libxfs_parent_unset(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -729,7 +767,16 @@ add_missing_parent_ptr(
 				name);
 	}
 
-	/* XXX actually do the work */
+	error = add_file_pptr(ip, ag_pptr, name);
+	if (error)
+		do_error(
+ _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /* Remove @file_pptr from @ip. */
@@ -771,7 +818,16 @@ remove_incorrect_parent_ptr(
 			file_pptr->namelen,
 			name);
 
-	/* XXX actually do the work */
+	error = remove_file_pptr(ip, file_pptr, name);
+	if (error)
+		do_error(
+ _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /*
@@ -851,7 +907,33 @@ compare_parent_ptrs(
 			ag_pptr->namelen,
 			name1);
 
-	/* XXX do the work */
+	/* Remove the parent pointer that we don't want. */
+	error = remove_file_pptr(ip, file_pptr, name2);
+	if (error)
+		do_error(
+_("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name2,
+			strerror(error));
+
+	/*
+	 * Add the parent pointer that we do want.  It's possible that this
+	 * parent pointer already exists but we haven't gotten that far in the
+	 * scan, so we'll keep going on EEXIST.
+	 */
+	error = add_file_pptr(ip, ag_pptr, name1);
+	if (error && error != EEXIST)
+		do_error(
+ _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name1,
+			strerror(error));
 }
 
 static int

