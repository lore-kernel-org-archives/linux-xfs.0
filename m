Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B05B38B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710286; cv=none; b=Zi0ZCXmzj47nTM04u3f7tBnWccgr8l0YeIpnIbl/3FCgB4vzDrfNw7JzXyIErOIj1xQME1RZKGrOmiqLQ/9yiY8bMpzmR4g1t1/euA4rZ8Y1oTw/0bnNuJkZrJebqynGylDiDfZ28gXZ7gFMNL7DHKVyVwSWqFY+BXDhSPtFUQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710286; c=relaxed/simple;
	bh=i7ECNhrBwjjxvcceIr0vfaTLVpMQLOLc1SkVVkZysks=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grvOr4tUnb2G2n6NwRpdXy4UtAX/v7UrrXgaKQ7HkLRWHeWuYJe3JMTmaIzXHt+8o94o0aJldpostLmTofhLGhX3ECrDbY15+Ll3I3phcmKSgXSobkLL3yME87ulRYKN+zfWkV6B5ou2uOrLhV70AKxCQJ+128/zDw+tVKk2zmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxmCBRe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxmCBRe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13124C433C7;
	Wed, 10 Apr 2024 00:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710286;
	bh=i7ECNhrBwjjxvcceIr0vfaTLVpMQLOLc1SkVVkZysks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kxmCBRe40XjySKqTf+fYGqFZO7JEe51fXR7gRmzdwPW2G6111TxHPyn8gwGMVtmLX
	 8YCEqAsVYheUTpqfG+A8Jo26zKQWABfTwoedGPJaGQlALjP7NKxxUgwsxrfiX4sH5E
	 rbYTFJfa+0YzvnsWvIt28m7ihWynPr6rrOA42XEhd30uys8BbEok8yy8qQ4sOOW9FO
	 gB7dbigPfUbfLUTWvVLUZTYyC1KIJXS7F8r1M0LMfVxVLNy/wLe7Z1W4fm9oqU7d2K
	 0QVh/m7g2DBB8ksXmhMfHpiPkhRudA3R7dOlAA4X5l3kz92EAXQPGTrHIX33/Ec9Tj
	 ldFfTXCMT+5kg==
Date: Tue, 09 Apr 2024 17:51:25 -0700
Subject: [PATCH 04/12] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968918.3631545.8245038196869543271.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e5e7ddbc594b9..d3559e6b24b7d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -737,6 +737,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -755,6 +756,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {

