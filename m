Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979AC446053;
	Fri,  9 Oct 2026 06:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526664; cv=none; b=YzOdwhJmPfyvKPTmHkRElTluMZIC55FYRzJDWl4YFQtjlmghQET3Rrjpm5rVq2Y/j1WFQNTLnO+CseZGr/NdRBOm+IWZyNCxVp50FS8gheWdM9zymbhkAbqUWEz1bT+NqNq89tyglPa/siqTqtYGucbpWQi+tNZfzQOeCpx4JU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526664; c=relaxed/simple;
	bh=9vcY5RdUjV3LUcdCuqAuCoIn6Q7wA7MZdfj/RGt8ti8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhz/jIP7g61OHqcBRY3WI/Eg3LxiKGKsvmmrnhS489cs36kt2TwlFApZN/DJy+u3M61IOpKTHnnecA3xl/ohdwQ7/XK6SyjE95wYqJtl0u5Cy2BcTN7FAk2kVjtjfB8v7vUUVlv9t9ofaKXYRF8ICN0U68MNnC2kfvWUdUfWfx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiMh5qrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiMh5qrY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1841F1F00893;
	Fri,  9 Oct 2026 06:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526662;
	bh=0EvX77sAc9DrZTHS4jS8U+vDdrgy6Ye8SGzlPgJ1ma8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XiMh5qrYSvokviC0dTKwwmLLaPyOZaNdhocJpVASj9oaa0jD5ZAYTmcPeRmRcwnN1
	 STnjj91YBthEMJuFNGCnBftLIPzyVJHhGNbuPJ8ATBtFEhgv4HIh2qSXwycGWovkkU
	 /Pvuy785H5SgbFULC2cu9I6GAoLVfU2M+SKNsDq3AnpMW5te1v0JcanxoLd4rKBN0L
	 6pzySf86a+xNv4kJwtahzsod3qmCeefmd5p+f0uG9c5haDAp2+OSzhSdQYRznuZGNb
	 GOvq3fqgkPg8v4P9dSsPezH7KBS1V29HghI+fPDTwdQ5prz+ET4Ih4z5K50vD/DvjV
	 GmaTOZ2EoIOdQ==
Date: Thu, 08 Oct 2026 23:17:41 -0700
Subject: [PATCH 11/13] xfs: check for buffer overruns when examining
 local/remote xattr entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614859.3163896.2791616340863381551.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr_repair.c |   14 ++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f7c00ea1af5d31..f909e2b25158a8 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -306,6 +306,12 @@ xchk_xattr_local_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
+	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 			be16_to_cpu(lentry->valuelen));
 	name_end = (char *)lentry + namesize;
@@ -335,6 +341,12 @@ xchk_xattr_remote_entry(
 	char				*name_end;
 	unsigned int			namesize;
 
+	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 	name_end = (char *)rentry + namesize;
 	if (rentry->namelen == 0) {
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7695d4cc8e7cc..c3152b578622a9 100644
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
@@ -293,10 +294,14 @@ xrep_xattr_salvage_local_attr(
 	 * Decode the leaf local entry format.  If something seems wrong, we
 	 * junk the attribute.
 	 */
+	name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
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
@@ -335,6 +340,7 @@ xrep_xattr_salvage_remote_attr(
 		.name			= rentry->name,
 		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
+	char				*name_end;
 	unsigned int			namesize;
 	int				error;
 
@@ -343,8 +349,12 @@ xrep_xattr_salvage_remote_attr(
 	 * junk the attribute.  Note that we should never find a zero-length
 	 * remote attribute value.
 	 */
+	name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+	if (name_end > buf_end)
+		return 0;
 	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
-	if ((char *)rentry + namesize > buf_end)
+	name_end = (char *)rentry + namesize;
+	if (name_end > buf_end)
 		return 0;
 	if (args.valuelen == 0 ||
 	    !xrep_xattr_want_salvage(rx, ent->flags, rentry->name,

