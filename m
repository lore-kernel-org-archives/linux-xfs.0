Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3420E339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928277; cv=none; b=G7dhIx53MMjlpRUAM/0u5FOe6kB37ThGhgSJbfb+zZ+uh0H7btWn+D1Xkrut1TsY1WXw7QPA3OZNVmlA+Wt0q/p2R5z7r8bDR5jaZK5zjFHxIMz11DHN5fUiuH7P46RG9utQRFCDMq+8AP+V+gvH/TtSZ0m8CFboJDa0j8qOoTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928277; c=relaxed/simple;
	bh=ApYjPvHOcplrufj1sb+Slh0meYpfLnBnjHkxTB0zy2s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2fMfcpS6m4YD9V2oBbwncUjTThKhOf+aqBNmOPvqPIdVRnaRi2xFSJWKKJbKjDtC+derCCP10W64JUyURlOan86wE+hQ5TpjfDBTB08++8464HS5dIWM3bLyo/Oqg+Ao+HQ4h3rg9W4xt3I/Q19C0nCeYKK5OjZzVarEipjAwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+6YCjM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+6YCjM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1006FC116B1;
	Wed, 24 Apr 2024 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928277;
	bh=ApYjPvHOcplrufj1sb+Slh0meYpfLnBnjHkxTB0zy2s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e+6YCjM4K6gkFU0whrHmoq6FN4+exNPqXV1lWeGRcMTgLW83f9a7qeRHI4nL2L4Wf
	 8noyEoCxjO2Jtxj7CIQYKIeoa28Xjc1ZwuQuPQwodO0BzGygeH7N2wqMBy7em63KIP
	 xNiIK/uApgvdJBEOML+3u53C7OAowvh35KXn6QPVwSONsYocpDSYqK0tWArZD6XvBb
	 C+Q+nHEKQmYyp0jPZ23GhgH1wefYAWpN6+3OtofV3PR9Q9cKvllQxmaqzKYSQowPVZ
	 HiDPIdjlH0GWjK8cs2E9+BwvECCQR7vfxNhkJ+hPWSgTlxukaFIOB+Ycjb5SCV7PJ3
	 xeFGql+Miuw6w==
Date: Tue, 23 Apr 2024 20:11:16 -0700
Subject: [PATCH 09/14] xfs: validate recovered name buffers when recovering
 xattr items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782725.1904599.5660142370086907204.stgit@frogsfrogsfrogs>
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

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   58 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index b4c2dcb4581b..ebd6e98d9c66 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -741,22 +741,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -785,31 +783,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*

