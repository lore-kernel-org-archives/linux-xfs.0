Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7C1FA5
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831255; cv=none; b=jXeafwaiiUrj0DAC13GEgWDE19TuSvX+Q43niUCYt41qwmSTWb/P//pv8YP1EisCenBBWz1gOg5OW1KRfM9nnAWtyaf2o8JWReW3z1PW2C6nll+xFUizZRNcV8zrco59e94ICxOIFBu7Zs+liXAJuWLV45rm2zLFyDpltllVSmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831255; c=relaxed/simple;
	bh=7KceW2QoZ9XR9NKUMVt1oVqOA1Q81zoXovW78xF3dto=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUNPRTbMxyYqUGdJcmsV9yTB61KRe6XfaqNPFm/3wg3qQZ3B6S/nnsfUJGn3Zr3E7I68JAXW5F/Y7+6jEKpm3GjclzM2Y8A2SXy1QJxwkE/mf7LgaeEkM8nEBWDzg21W3aE9c0BLMJLVp1EcxWbpJTtd8drl1/XLXtQPFQwSjfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDmdFBly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDmdFBly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4262C4CEC6;
	Wed,  2 Oct 2024 01:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831254;
	bh=7KceW2QoZ9XR9NKUMVt1oVqOA1Q81zoXovW78xF3dto=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PDmdFBly5LAbOrfql4CMPHcbJcJ+x/P2W9Nwe6FLNgd8ttmXVuatmJKcXzUI44sMJ
	 dOn1OXtFGXyhaU2i+qbTKlQ29wBvybXsHjP68/gBZqcV9dFszCfFTZmndmeIGbLGnk
	 Cwg0iBKhsgAYgFoK51XRpulAAcudmUuM1UgOCsatE7SI1IXNE6u6lE0fDUkrT/hjmc
	 avU49miIVO1AZOraKNqeji9uCw8CbDoGjmAKDCMXadwHHZf3IrDeMj8QxQO5edVDza
	 Oh3tCBJBPqYJd0lwUhKSU4gaKtIBF0lBlmS3Oz8ud7/JiANTQIIwSAVcubxCxVfLFA
	 J9aMysP82YkIQ==
Date: Tue, 01 Oct 2024 18:07:34 -0700
Subject: [PATCH 1/2] misc: clean up code around attr_list_by_handle calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101356.4035924.10466137797699298869.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs>
References: <172783101339.4035924.6880384393728950920.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libfrog/fsprops.c |   10 ++++++----
 scrub/phase5.c    |   46 +++++++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 21 deletions(-)


diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
index 88046b7a0..a25c2726c 100644
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
index f6c295c64..d298d628a 100644
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
 

