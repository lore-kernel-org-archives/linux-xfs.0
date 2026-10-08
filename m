Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6951E3BD638;
	Thu,  8 Oct 2026 05:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439048; cv=none; b=CqMIbWVm2JZGcV3MwX288lCpSPkAMbZeDBGxbKDUsjRzq5l153lV2Z2mtr+2YKzAlu9VjLwm6vRoS/wpeD+GFDgRw1cmCztGb/B7s2uYQsO1CObnd0VV0hX8RP6PeQ71K8EmdU0RPd/anEusyj+yVmEPdPGz3sSV5OoeIInVg5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439048; c=relaxed/simple;
	bh=P0208Hg+zeYOIe7DA+OqwYDywMj1uzE02EgT2yrBEr0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5FyZROlpb6jS3hOJxMDQUjJTF2MImCztjSgpJOE6tJQLOCAlYs3CfdoCri380Lnhqs6EQ5GuC/7zLd0oaQIVOooCNEy67rKvIPpLOh1+fHetEENtWSqDd4nclV9P+oLMzQQEOv5OiuYQLCH9hR7J5BR2st4Jorh8VwDrnXbpZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAtqv5Kt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAtqv5Kt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12C851F000FF;
	Thu,  8 Oct 2026 05:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791439047;
	bh=VZLgKN46o5QFFkXE8CovhDyR0jBtYRsRXZbPTOrMiBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=oAtqv5KtspdYmi8qTMkOGBzIuNHH6uHXcQfsa4ixOvEHn+w3p6wXKOVjYJ7fUxEwc
	 SMvtYYLEq6nqiuetZfr+0l8uNcasmEwLxxFmgrVQhsWpJE3NulGww8+h5CvwXsWvZX
	 HzKuzBSVxxcuqmu1vBW2aVrK3irl/6ix+fbA/NV+p6iI06QqG9AzzxSIIyTV5WNE/E
	 VMTgX7oHgiYETY5MW4VFEiwJwKE02idN3RTtM0yQyPHlDz8dMGZd4wlf6GrYGIvSFW
	 3tj3uA/4MH7b4pEDm4lTZIqyYsjIa6g7epqPDKlPBqU7ybb+HdY8uwn27RhrQ7HckM
	 wQydScDKFzBCg==
Date: Wed, 07 Oct 2026 22:57:26 -0700
Subject: [PATCH 10/12] xfs: check for buffer overruns when examining
 local/remote xattr entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521472.2728617.17391389777619283843.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the xattr scrub and repair code can walk off the end
of the buffer if the xattr entry record starts so close to the end of
the buffer that there's not even space for the entry structure itself.
Strengthen the bounds checking here.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr.c        |   12 ++++++++++++
 fs/xfs/scrub/attr_repair.c |   16 ++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 842d65834afbc9..4ce7299060fbba 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -335,6 +335,12 @@ xchk_xattr_entry(
 	/* Check the name information. */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+		name_end = (char *)lentry +
+				offsetof(struct xfs_attr_leaf_name_local, nameval[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -342,6 +348,12 @@ xchk_xattr_entry(
 			xchk_da_set_corrupt(ds, level);
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		name_end = (char *)rentry +
+				offsetof(struct xfs_attr_leaf_name_remote, name[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7695d4cc8e7cc..25e71b3a14d95d 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -285,6 +285,7 @@ xrep_xattr_salvage_local_attr(
 	struct xfs_attr_leaf_name_local	*lentry)
 {
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
+	char				*name_end;
 	unsigned char			*value;
 	unsigned int			valuelen;
 	unsigned int			namesize;
@@ -293,10 +294,15 @@ xrep_xattr_salvage_local_attr(
 	 * Decode the leaf local entry format.  If something seems wrong, we
 	 * junk the attribute.
 	 */
+	name_end = (char *)lentry +
+			offsetof(struct xfs_attr_leaf_name_local, nameval[0]);
+	if (name_end > buf_end)
+		return 0;
 	value = &lentry->nameval[lentry->namelen];
 	valuelen = be16_to_cpu(lentry->valuelen);
 	namesize = xfs_attr_leaf_entsize_local(lentry->namelen, valuelen);
-	if ((char *)lentry + namesize > buf_end)
+	name_end = (char *)lentry + namesize;
+	if (name_end > buf_end)
 		return 0;
 	if (!xrep_xattr_want_salvage(rx, ent->flags, lentry->nameval,
 			lentry->namelen, value, valuelen))
@@ -335,6 +341,7 @@ xrep_xattr_salvage_remote_attr(
 		.name			= rentry->name,
 		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
+	char				*name_end;
 	unsigned int			namesize;
 	int				error;
 
@@ -343,8 +350,13 @@ xrep_xattr_salvage_remote_attr(
 	 * junk the attribute.  Note that we should never find a zero-length
 	 * remote attribute value.
 	 */
+	name_end = (char *)rentry +
+			offsetof(struct xfs_attr_leaf_name_remote, name[0]);
+	if (name_end > buf_end)
+		return 0;
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
-	if ((char *)rentry + namesize > buf_end)
+	name_end = (char *)rentry + namesize;
+	if (name_end > buf_end)
 		return 0;
 	if (args.valuelen == 0 ||
 	    !xrep_xattr_want_salvage(rx, ent->flags, rentry->name,

