Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0A17C8B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 23:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726789986; cv=none; b=H9FLDKSMh4heUlHxsvC8xe94m0Y+iFSxqTo3yCG1TUTz+qAO+73/vw/vlWQ0D0tLZRvZa/RQwQPy2zbjKPF1BhEVwxvrsm/NzkWOzJmeUTp/H8YZGLwoy2BYcV2BWgIxI7jjyk9Vv+AdmujevSevwWchKNm9hg03OU3oqfOmpl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726789986; c=relaxed/simple;
	bh=kIaY+NssqJHtwTsoP73k8rZq9dsiM7PfLT/CJFVUMag=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQMri4W4Hhc3ZtVdljKeKLSGUN/stUeLprgx8NZ3dkchDDNRtMlSFBHNiCYTxuymkt5Xjmc4tGjlelUbae+UrbO0u+wXhAjsLGfpgpB9znwT6pBRg6Ug5ja8jTgP24yRNunelRz7C5Lg0KnykbYq2r2gLslNV0Ls+p9+94gFHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quOM1VE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quOM1VE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8E9C4CEC4;
	Thu, 19 Sep 2024 23:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726789985;
	bh=kIaY+NssqJHtwTsoP73k8rZq9dsiM7PfLT/CJFVUMag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=quOM1VE7wxIpVLZp6boyCfFTPB1TlM3NOeaeOhU8vLDcKo7lTMxWcCLfLJ4yLoLsi
	 pr5dPrssY8jcZwxK86YIWtWTj+TvLYPwt8Gh4SZZKMcIWcnSLDmcqjMcADfNUIP11J
	 LMJd5k8KsXdjtV7N6T62m6F1SqKe1AA25b7rBdn8VXhJRlns/a9GJ8u+/jqgOl9CPG
	 +DA3HeVcf9bmujBo1yhbozGw+RoEwvPEwUhwi7OA61tK/YXG5+H4e+7GVHaAH0sOCi
	 L3rfuBAO8/UrNwoMxiwD8QwxyHoChUPRNMcOTtZWDoCQBSRV6Hh8RT0+ihoHxP8FhA
	 G9ly8xeMVW0Tw==
Date: Thu, 19 Sep 2024 16:53:05 -0700
Subject: [PATCH 1/2] misc: clean up code around attr_list_by_handle calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172678988217.4013721.10321131196439907338.stgit@frogsfrogsfrogs>
In-Reply-To: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs>
References: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs>
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

Reduce stack usage of the attr_list_by_handle calls by allocating the
buffers dynamically.  Remove some redundant bits while we're at it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsprops.c |   10 ++++++----
 scrub/phase5.c    |   46 +++++++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 21 deletions(-)


diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
index 88046b7a0738..a25c2726cd58 100644
--- a/libfrog/fsprops.c
+++ b/libfrog/fsprops.c
@@ -69,13 +69,14 @@ fsprops_walk_names(
 	void			*priv)
 {
 	struct attrlist_cursor	cur = { };
-	char			attrbuf[XFS_XATTR_LIST_MAX];
-	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist		*attrlist;
 	int			ret;
 
-	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
+	attrlist = calloc(XFS_XATTR_LIST_MAX, 1);
+	if (!attrlist)
+		return -1;
 
-	while ((ret = attr_list_by_handle(fph->hanp, fph->hlen, attrbuf,
+	while ((ret = attr_list_by_handle(fph->hanp, fph->hlen, attrlist,
 				XFS_XATTR_LIST_MAX, XFS_IOC_ATTR_ROOT,
 				&cur)) == 0) {
 		unsigned int	i;
@@ -96,6 +97,7 @@ fsprops_walk_names(
 			break;
 	}
 
+	free(attrlist);
 	return ret;
 }
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
index f6c295c64ada..d298d628a998 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -190,30 +190,40 @@ check_xattr_ns_names(
 	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
 {
-	struct attrlist_cursor		cur;
-	char				attrbuf[XFS_XATTR_LIST_MAX];
-	char				keybuf[XATTR_NAME_MAX + 1];
-	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
-	struct attrlist_ent		*ent;
+	struct attrlist_cursor		cur = { };
+	char				*keybuf;
+	struct attrlist			*attrlist;
 	struct unicrash			*uc = NULL;
 	int				i;
 	int				error;
 
+	attrlist = calloc(XFS_XATTR_LIST_MAX, 1);
+	if (!attrlist) {
+		error = errno;
+		str_errno(ctx, descr_render(dsc));
+		return error;
+	}
+
+	keybuf = calloc(XATTR_NAME_MAX + 1, 1);
+	if (!keybuf) {
+		error = errno;
+		str_errno(ctx, descr_render(dsc));
+		goto out_attrlist;
+	}
+
 	error = unicrash_xattr_init(&uc, ctx, bstat);
 	if (error) {
 		str_liberror(ctx, error, descr_render(dsc));
-		return error;
+		goto out_keybuf;
 	}
 
-	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
-	memset(&cur, 0, sizeof(cur));
-	memset(keybuf, 0, XATTR_NAME_MAX + 1);
-	error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
-			XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
-	while (!error) {
+	while ((error = attr_list_by_handle(handle, sizeof(*handle), attrlist,
+				XFS_XATTR_LIST_MAX, attr_ns->flags,
+				&cur)) == 0) {
 		/* Examine the xattrs. */
 		for (i = 0; i < attrlist->al_count; i++) {
-			ent = ATTR_ENTRY(attrlist, i);
+			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
 			if (uc)
@@ -225,14 +235,12 @@ check_xattr_ns_names(
 						keybuf);
 			if (error) {
 				str_liberror(ctx, error, descr_render(dsc));
-				goto out;
+				goto out_uc;
 			}
 		}
 
 		if (!attrlist->al_more)
 			break;
-		error = attr_list_by_handle(handle, sizeof(*handle), attrbuf,
-				XFS_XATTR_LIST_MAX, attr_ns->flags, &cur);
 	}
 	if (error) {
 		if (errno == ESTALE)
@@ -241,8 +249,12 @@ check_xattr_ns_names(
 		if (errno)
 			str_errno(ctx, descr_render(dsc));
 	}
-out:
+out_uc:
 	unicrash_free(uc);
+out_keybuf:
+	free(keybuf);
+out_attrlist:
+	free(attrlist);
 	return error;
 }
 

