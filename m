Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA752EF65C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151787; cv=none; b=Q74pcLVFDqAJVWBynQR8sJ8+KiyNZzIpKZ8kctefeTUBKRQydSoZzFFVSHw0ekylDX+k79pnyLf83RdgO2//V0ngzwG2PkelRrzvu2rPk+68gEEMYvWs1ltooKMmhfGjy1H7gP4HYCoNt/n7Z75fnHLSPdvE01AF+j6RNqnAtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151787; c=relaxed/simple;
	bh=Bu2fk0FZb7j12s/CIAwAL4pKAZgq6KmYFiMKdpBmWGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XI3ROwHvYik1mCxHa+93v+zvUxZI8bn5qhomft2EvmAFrumMHKdskBdWxCxWgodj1JDvuNSpmfMJAO+wSZASp3+PCKZ5pinxFhHA2xWbRpoJ8o29lkAYsw7UgtLRMQgWTrN19ztyos0FpT+OUDvFV/xriO0RNlGhEoK6bB03rP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5lUZsBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5lUZsBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C574CC4CEF1;
	Fri, 23 Jan 2026 07:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151786;
	bh=Bu2fk0FZb7j12s/CIAwAL4pKAZgq6KmYFiMKdpBmWGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V5lUZsBH7TsYMEdFs+vzT7I7t50c6gsU753cj5NSEFgli3IEuRZXuy7OQ5NokR6vM
	 l5ZUg0jCwc6kHr2yG07PfvsgmQfSq74leKs3I/X6UpveirsYToGaGe6hkY6I9siRL+
	 nKnpAihzwIpSRG1ypIMHzyqNdJ24yzo0qrDU3P5uDrEaHR4+/r322cXggNM6e6q8Fv
	 RRcMBfQDfymH9PXnIwLUV9RK+L994XjhRCwXOGl8yaDv/EfJpZ2NReyVohxJUve6JI
	 NFebUaA1bYfuM5t09oCY+paGBmyW5s7s/0a2Zhwae3+5Zs0AHNvQFPgDBJz+cjy1lz
	 0a1LvCaouJT1g==
Date: Thu, 22 Jan 2026 23:03:06 -0800
Subject: [PATCH 3/3] xfs: add a method to replace shortform attrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176915153446.1677678.13050416220046429614.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153369.1677678.8151270167939415602.stgit@frogsfrogsfrogs>
References: <176915153369.1677678.8151270167939415602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 fs/xfs/libxfs/xfs_attr_leaf.h |    1 +
 fs/xfs/xfs_trace.h            |    1 +
 fs/xfs/libxfs/xfs_attr.c      |    4 ++++
 fs/xfs/libxfs/xfs_attr_leaf.c |   38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 589f810eedc0d8..aca46da2bc502e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -46,6 +46,7 @@ struct xfs_attr3_icleaf_hdr {
  * Internal routines when attribute fork size < XFS_LITINO(mp).
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
+int	xfs_attr_shortform_replace(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3483461cf46255..813e5a9f57eb7a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2413,6 +2413,7 @@ DEFINE_ATTR_EVENT(xfs_attr_sf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_sf_create);
 DEFINE_ATTR_EVENT(xfs_attr_sf_lookup);
 DEFINE_ATTR_EVENT(xfs_attr_sf_remove);
+DEFINE_ATTR_EVENT(xfs_attr_sf_replace);
 DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
 
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7f863614a16397..4e0d516072bb63 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1085,6 +1085,10 @@ xfs_attr_replacename(
 		return 0;
 	}
 
+	error = xfs_attr_shortform_replace(args);
+	if (error != -ENOSPC)
+		return error;
+
 	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
 
 	error = xfs_attr_sf_removename(args);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f10479bf0c8f2b..44019aab5cce70 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -842,6 +842,44 @@ xfs_attr_sf_findname(
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

