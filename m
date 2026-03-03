Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C61DF248
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497106; cv=none; b=lP0T/XhsBAh9t9m4pPjZ78dsVup91PgTp1OGE7A1msx3vCPfGsJCaWwhcCC3y4tsrS6r20EfQHUC+JGwhAxBt3CSSz0B4SFtfWxRlycSNhCRUvWjqNICOUOfGX3YBT1oDX0EvDX04EYyVU23r5cAoUcE2jQmLpGW6spwS6TS2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497106; c=relaxed/simple;
	bh=RG6toFXlU3GW76DCwNGPTtGavVFwPFKzxzDMvSlybeg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8sPzBmU+ysuEW0FtWQFEKhrYh12xafJgDcubM5ULtDsTDGqFUJrvm5TFv4XZmm3XO00cGUqYG61WgegNfTdDhHJOCTMWqWiCUXXJOud/lZ1QQGRpnQAsOVodNFc0IytPtJxy7ap9lHXVVJqWwRlo4eyz7kx1y2bZ2F9s/AI/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7W4gG0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7W4gG0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39970C2BC86;
	Tue,  3 Mar 2026 00:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497106;
	bh=RG6toFXlU3GW76DCwNGPTtGavVFwPFKzxzDMvSlybeg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u7W4gG0CxgTz2Fh9QLaVmzKmHjVR3jcXhYU220hRyLjOJHNRBgPSc/yiFv/cs6ZHo
	 HrqGgBclEvWi+hZ8bu2F0IRMbXokZXphhe2JsRox5ZlshH2IZe8q7YWeqsPceR1aYO
	 5KxUhGevVFy1YVK7CM//bdpQYHr/IBG0UIZalYDGm0UBygzg6vzLcw0A/6HR3e0Xz/
	 OkwwMiUM7Ofo0E+VgkapaQGNHLqBJh3x4opiq+N8/Ef8VjHTnWjEloD2e+E7e/absK
	 X/07w4g5hRqtXcbMmdpt31GTASgLlhHWU6p04tC9NKF7AJVY85SwA/kJe921LBdr5z
	 kPrQSpvUGLGjA==
Date: Mon, 02 Mar 2026 16:18:25 -0800
Subject: [PATCH 24/36] xfs: add a method to replace shortform attrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638219.457970.3184478908074339643.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: eaec8aeff31d0679eadb27a13a62942ddbfd7b87

If we're trying to replace an xattr in a shortform attr structure and
the old entry fits the new entry, we can just memcpy and exit without
having to delete, compact, and re-add the entry (or worse use the attr
intent machinery).  For parent pointers this only advantages renaming
where the filename length stays the same (e.g. mv autoexec.bat
scandisk.exe) but for regular xattrs it might be useful for updating
security labels and the like.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h    |    1 +
 libxfs/xfs_attr_leaf.h |    1 +
 libxfs/xfs_attr.c      |    4 ++++
 libxfs/xfs_attr_leaf.c |   38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 6bbf4007cbbbd9..be9183fc33ad90 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -57,6 +57,7 @@
 #define trace_xfs_attr_defer_replace(...)	((void) 0)
 #define trace_xfs_attr_defer_remove(...)	((void) 0)
 #define trace_xfs_attr_sf_addname_return(...)	((void) 0)
+#define trace_xfs_attr_sf_replace(...)		((void) 0)
 #define trace_xfs_attr_set_iter_return(...)	((void) 0)
 #define trace_xfs_attr_leaf_addname_return(...)	((void) 0)
 #define trace_xfs_attr_node_addname_return(...)	((void) 0)
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 589f810eedc0d8..aca46da2bc502e 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -46,6 +46,7 @@ struct xfs_attr3_icleaf_hdr {
  * Internal routines when attribute fork size < XFS_LITINO(mp).
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
+int	xfs_attr_shortform_replace(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0b45e72b5478b4..a2611aace8190f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1084,6 +1084,10 @@ xfs_attr_replacename(
 		return 0;
 	}
 
+	error = xfs_attr_shortform_replace(args);
+	if (error != -ENOSPC)
+		return error;
+
 	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
 
 	error = xfs_attr_sf_removename(args);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index f591984c3748ff..90be21a3887642 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -839,6 +839,44 @@ xfs_attr_sf_findname(
 	return NULL;
 }
 
+/*
+ * Replace a shortform xattr if it's the right length.  Returns 0 on success,
+ * -ENOSPC if the length is wrong, or -ENOATTR if the attr was not found.
+ */
+int
+xfs_attr_shortform_replace(
+	struct xfs_da_args		*args)
+{
+	struct xfs_attr_sf_entry	*sfe;
+
+	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+
+	trace_xfs_attr_sf_replace(args);
+
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe)
+		return -ENOATTR;
+
+	if (args->attr_filter & XFS_ATTR_PARENT) {
+		if (sfe->namelen != args->new_namelen ||
+		    sfe->valuelen != args->new_valuelen)
+			return -ENOSPC;
+
+		memcpy(sfe->nameval, args->new_name, sfe->namelen);
+		memcpy(&sfe->nameval[sfe->namelen], args->new_value,
+				sfe->valuelen);
+	} else {
+		if (sfe->valuelen != args->valuelen)
+			return -ENOSPC;
+		memcpy(&sfe->nameval[sfe->namelen], args->value,
+				sfe->valuelen);
+	}
+
+	xfs_trans_log_inode(args->trans, args->dp,
+			XFS_ILOG_CORE | XFS_ILOG_ADATA);
+	return 0;
+}
+
 /*
  * Add a name/value pair to the shortform attribute list.
  * Overflow from the inode has already been checked for.

