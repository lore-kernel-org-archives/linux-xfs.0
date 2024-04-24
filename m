Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3297339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928339; cv=none; b=bGKikGcsxxbXRRgkbeNHSeLEFTlr+dj/Djtlk96VZllFvnKB1lRvQIwuR/NZRqsTrNp3MJU652k/Ak+14HdunY2z3vH/zqUMClMily1l/4YbQaQPJJRJY23YfuCNZ9Mk9LGkQ4pJ76PpfZj7asajs7AkKOdQg+ysvhdj5XfDp1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928339; c=relaxed/simple;
	bh=PCtTIwLnxDkXm6FIE2ExMLIzBfbY+2iQ3krSJ+1RRZ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lv8/05zpczlCMhIrGFeSkbGrRfeB49wyKBvaaYIAI7qG3NZfF201nZnv0rXLOQKrcHCkqEsNFzvgO0JM3wHtySRCEDTI0cvGZunUG3YolRXkdEBFPZwe1vgyv1We3ItoKdLAONcehZg+AQRNqio+V/rZ3nt+V12JnTsfK43/h+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ul765sUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ul765sUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99CDC116B1;
	Wed, 24 Apr 2024 03:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928339;
	bh=PCtTIwLnxDkXm6FIE2ExMLIzBfbY+2iQ3krSJ+1RRZ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ul765sUHR5ZY8SDl/5GjMGllIIh2p7d5KromSq4U4p0vR86UE3J04+eKBhKDwVJHx
	 42NhSkqWsu83F8c+90xrw+IWemaMZb3sbiICREphrk+9UKV/r5xmL7Gs1UrQmw5kdN
	 Spryur5MfGAjzNlbnzghytJYQ0dv9062KXiVynruLYt4SilxluLqM7RNtFcHu5M8U3
	 iwuPeJaZNV0C8nkcjhy7Du5ghi1oLduuN4IQp+HsQmoxJT5VBnNS3jJZHLs4Shq4PQ
	 EJHKGepSNB3O6rbiiF9IBxjBLfqeZc6RQi4vramdn+enWxzLgq+nmINFU7l6gOmxZu
	 qgdLkmoIC/khw==
Date: Tue, 23 Apr 2024 20:12:19 -0700
Subject: [PATCH 13/14] xfs: refactor name/value iovec validation in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782792.1904599.18060284396967997117.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

Hoist the code that checks the attr name and value iovecs into separate
helpers so that we can add more callsites for the new parent pointer
attr intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   64 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c8f92166b9ad..39536303a7b6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -734,6 +734,46 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.relog_intent	= xfs_attr_relog_intent,
 };
 
+static inline void *
+xfs_attri_validate_name_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct xfs_log_iovec	*iovec,
+	unsigned int			name_len)
+{
+	if (iovec->i_len != xlog_calc_iovec_len(name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	if (!xfs_attr_namecheck(iovec->i_addr, name_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				iovec->i_addr, iovec->i_len);
+		return NULL;
+	}
+
+	return iovec->i_addr;
+}
+
+static inline void *
+xfs_attri_validate_value_iovec(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format     *attri_formatp,
+	const struct xfs_log_iovec	*iovec,
+	unsigned int			value_len)
+{
+	if (iovec->i_len != xlog_calc_iovec_len(value_len)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, sizeof(*attri_formatp));
+		return NULL;
+	}
+
+	return iovec->i_addr;
+}
+
 STATIC int
 xlog_recover_attri_commit_pass2(
 	struct xlog                     *log,
@@ -798,30 +838,18 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
+	attr_name = xfs_attri_validate_name_iovec(mp, attri_formatp,
+			&item->ri_buf[i], name_len);
+	if (!attr_name)
 		return -EFSCORRUPTED;
-	}
-
-	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, name_len)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
-		return -EFSCORRUPTED;
-	}
 	i++;
 
 	/* Validate the attr value, if present */
 	if (value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					item->ri_buf[0].i_addr,
-					item->ri_buf[0].i_len);
+		attr_value = xfs_attri_validate_value_iovec(mp, attri_formatp,
+				&item->ri_buf[i], value_len);
+		if (!attr_value)
 			return -EFSCORRUPTED;
-		}
-
-		attr_value = item->ri_buf[i].i_addr;
 		i++;
 	}
 

