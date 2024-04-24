Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123F4BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928199; cv=none; b=GFpHORwwgUvAAzNtKsfbuhqtoSk2EuND9UtVXq5ARD9j0djwb6kBKzz6ea/w0zo25VVOfJF2lEdnm/fN7Gv+X98556zV8lbQC8gX8jNBetlbzCvPZwMEICl7IqNuiHk5NhjgboTqu3NIYtT4WzFkoFPyLIy+sNLVk3KmokW5hm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928199; c=relaxed/simple;
	bh=HEyCRW7J3P9E8BOO6r8u/bcnKFnS04bARQTL/ZI0VYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoEX8lusbm7ci5GOJQ0TNQxvlpFGg4keQ0QhjKJUXoIjM/bjYRctNr/9fOfGS94gNgaUoyNsUKyC11es7Fnh2X6GUiK4VIZxS5X/avhbT/9+o4Z/yHWv2nAqBu8AjIkdOpxfjTgEJXFn7iZURPluwIQR2GLPJIrkixxUZuWvgT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjL4IPKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjL4IPKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E306EC2BD10;
	Wed, 24 Apr 2024 03:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928198;
	bh=HEyCRW7J3P9E8BOO6r8u/bcnKFnS04bARQTL/ZI0VYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PjL4IPKi1kT+3YW4U6FJ1ERH4Nk3wZBfvZ/yaciNryH3Nq/vjXzlaMY4f8CgVGBSV
	 2edArSonhzeprDxHtId23XlbJKN4JROR4F27UFleKkldNAsXGxXMT9Ojsu4i0tPyBL
	 72Jkfxz2UoCIbYoGhzuywVK7EwYTOoEkOrn6CqEsZNTshgI0OQH0TElRNaKbBk6RxM
	 DqWyFj9YUTCWmzUyiNDAlKqyiEnG0GJ8m0Jsfn8BqF9hXBFEw0XDb/cCsjfbGgvn1U
	 ZFpdH8T6mN210Nq6o9Lj183Sb3KJ9/CEw2tJEbRY+ozKdI2Yv31HYwUf15Kb5eWvqg
	 tPeDGC9xndOyw==
Date: Tue, 23 Apr 2024 20:09:58 -0700
Subject: [PATCH 04/14] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782640.1904599.15360184000286406971.stgit@frogsfrogsfrogs>
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

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e5e7ddbc594b..d3559e6b24b7 100644
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

