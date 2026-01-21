Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFDD425CCB
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977606; cv=none; b=P4ITJkz4dZePpMUIHHvGU80LLIRbZVG5ZuUllMGIJvWeYk73/JPhhA7lje9oNapXVtd4Xf2D0LIMCkRe/u9SWsBJ0957uy2Ot7nNVXZIz4f8Aw9k/0xXAHLdPwzicHX+zy62bG5gfzSjERzl8B/KL2Bn8OQUo60xIJyyPYxd9J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977606; c=relaxed/simple;
	bh=hTTt6FVYqjyZKScEChp2G9w8WDDbSHLR5Td1HXg4sM0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f8gUTFkc92i6jajIgr9sHIZrjX1qO1hYugdbrHIG0JMxEVIanZ7ozxW7TLPTTkIRyAtjdND8PeWf1OCMvbuPnj4BLnC+57d4MKZO6i1XT0xsu4e8dD/nKVYFnDrhyLIa8JWEuNW6rCWJ+z0xrBxvWMKrrn5riomc/FY6aW1nWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3xNa5xL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3xNa5xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B33C116D0;
	Wed, 21 Jan 2026 06:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977602;
	bh=hTTt6FVYqjyZKScEChp2G9w8WDDbSHLR5Td1HXg4sM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X3xNa5xL6h6n175vMht/lnyfAq4G25mYoeD5dTapGdHCzNuXTJpfZ7jcUQV39ixoh
	 lauRfSRITRY8q5H7x6KOOvChcFaavSNVbs5m4/tgALEeiAkhCBbupeNDjHqa4BBgQb
	 I9P25wmjYrLB4rlUDwztjGE8pfbK1YvOGI1UDZ9bqF7DQnhWaJUvfTxauSpsfB+RFm
	 jp6JEzImB0CKWC/Ij6LmIqF8VNxo2n3VZMkLtpD2NXKouvY8GHzN8Ip1hksFblFCYz
	 pDPVADBT3BW1/E2AKkAqCFNmQV3UrQeYofy5j8z6piLIFXxzWODiPHtofdCfcYEVsv
	 bHKO1dDgkftqg==
Date: Tue, 20 Jan 2026 22:40:02 -0800
Subject: [PATCH 3/3] xfs: add a method to replace shortform attrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176897695994.202851.7241999799670618810.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
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
index 00dca18b85906e..28adb6001af0dd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1081,6 +1081,10 @@ xfs_attr_replacename(
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

