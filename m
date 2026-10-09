Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A43B38B9
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526647; cv=none; b=UfXmHJ7FXtFiUvHv8Ah9Komj8fhgW/TvPKUKATqaMOYt5Nyyvf1LnpHcqy7WROBw1M6WWAXodfJWN6z+TpAGBheBcFBVxfOcWXxzqKj7AKAzkHfnpU5i84rcywY/64MA998G1aC3moZQ7jbwyHyVYTwBjBhiBBwpzLPY8ckmlg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526647; c=relaxed/simple;
	bh=ZGAC8iPywDlW0DZi2W5OtYXPhRIuV/fPXbPzXw4wWkM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3qhL5Ta3PCh1iDlnOUfqXpN3UTkDX9AN9EjfMOt/AsMGF6MRqn2cLZhpjpZ+Wem+Dx3wqIoIA7fQly41Fu1pFrmPl8P49u0TbACOVoGGj8FEYb5ClvWHH9U/3aYU6XsuHIZX+APVah1ZdNpsGSCgf4DEzb/qARshiFcoKocXD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpjnbppU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpjnbppU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79E581F000FF;
	Fri,  9 Oct 2026 06:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526646;
	bh=YjsIarVQh0gxMX+2eAGkOTV69B1hFCin7h88y0Ig/eY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mpjnbppUrrfX4GOxSPrT9578KBiFzw8xhWK6nHT/f03aHgA2zYtYtDjF2I+XAQ+HB
	 55lERX0Yz8P91JQ35qxEpPGMB7iwUNHHhVjnM/L0qNlAI9TXKj0DuOLi3rC6pTxAl5
	 hqkwWWDJmyYAhqv1YRdWXG6d0gyhZ3Ujj7eJkXmv0gXsPOIR02vyUlpkqKyR/3vGaY
	 9/mkzGIBSupQoVvy/x3KIHci9GrCiR3YRT4YPElWkubyaOyICyLd1NBLCy4fyuDL5t
	 HqxXy5a5cP3yqguwVKQ3NJX567gxTmtzHVQOEbO0FG2AkUgJMkvc0fxq6yRvtP4N8m
	 /t8FgjMdXv81w==
Date: Thu, 08 Oct 2026 23:17:26 -0700
Subject: [PATCH 10/13] xfs: break out xattr entry checks into separate
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179151614837.3163896.5021594784263990587.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're going to add more xattr entry checking code in xchk_xattr_entry so
break these out into separate functions so that we don't go crazy
indenting.  There's a slight behavior change here where we skip updating
the usedmap if we've decided the xattr structure is corrupt.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   90 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 842d65834afbc9..f7c00ea1af5d31 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -293,6 +293,66 @@ xchk_xattr_set_map(
 	return ret;
 }
 
+static unsigned int
+xchk_xattr_local_entry(
+	struct xchk_da_btree		*ds,
+	int				level,
+	char				*buf_end,
+	struct xfs_attr_leafblock	*leaf,
+	int				idx)
+{
+	struct xfs_attr_leaf_name_local	*lentry =
+			xfs_attr3_leaf_name_local(leaf, idx);
+	char				*name_end;
+	unsigned int			namesize;
+
+	namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
+			be16_to_cpu(lentry->valuelen));
+	name_end = (char *)lentry + namesize;
+	if (lentry->namelen == 0) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
+	return namesize;
+}
+
+static unsigned int
+xchk_xattr_remote_entry(
+	struct xchk_da_btree		*ds,
+	int				level,
+	char				*buf_end,
+	struct xfs_attr_leafblock	*leaf,
+	int				idx,
+	struct xfs_attr_leaf_entry	*ent)
+{
+	struct xfs_attr_leaf_name_remote *rentry =
+			xfs_attr3_leaf_name_remote(leaf, idx);
+	char				*name_end;
+	unsigned int			namesize;
+
+	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
+	name_end = (char *)rentry + namesize;
+	if (rentry->namelen == 0) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (rentry->valueblk == 0 && !(ent->flags & XFS_ATTR_INCOMPLETE)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
+	return namesize;
+}
+
 /*
  * Check this leaf entry's relations to everything else.
  * Returns the number of bytes used for the name/value data.
@@ -311,9 +371,6 @@ xchk_xattr_entry(
 {
 	struct xfs_mount		*mp = ds->state->mp;
 	struct xchk_xattr_buf		*ab = ds->sc->buf;
-	char				*name_end;
-	struct xfs_attr_leaf_name_local	*lentry;
-	struct xfs_attr_leaf_name_remote *rentry;
 	unsigned int			nameidx;
 	unsigned int			namesize;
 
@@ -333,25 +390,14 @@ xchk_xattr_entry(
 	}
 
 	/* Check the name information. */
-	if (ent->flags & XFS_ATTR_LOCAL) {
-		lentry = xfs_attr3_leaf_name_local(leaf, idx);
-		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
-				be16_to_cpu(lentry->valuelen));
-		name_end = (char *)lentry + namesize;
-		if (lentry->namelen == 0)
-			xchk_da_set_corrupt(ds, level);
-	} else {
-		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
-		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
-		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0)
-			xchk_da_set_corrupt(ds, level);
-		if (rentry->valueblk == 0 &&
-		    !(ent->flags & XFS_ATTR_INCOMPLETE))
-			xchk_da_set_corrupt(ds, level);
-	}
-	if (name_end > buf_end)
-		xchk_da_set_corrupt(ds, level);
+	if (ent->flags & XFS_ATTR_LOCAL)
+		namesize = xchk_xattr_local_entry(ds, level, buf_end, leaf,
+				idx);
+	else
+		namesize = xchk_xattr_remote_entry(ds, level, buf_end, leaf,
+				idx, ent);
+	if (!namesize)
+		return;
 
 	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, nameidx, namesize))
 		xchk_da_set_corrupt(ds, level);

