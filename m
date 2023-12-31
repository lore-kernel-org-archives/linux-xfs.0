Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3E6BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgbVv/kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230E1C433C7;
	Sun, 31 Dec 2023 20:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055538;
	bh=QE4f67Wbvd2iXZ1qiGLzcF1qSkQi/lKtdlLYz5pVJXY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QgbVv/kcXk1uEMOmsnVKStlIC96qIBep+t8YPmBXBvliZRwTXEQfpRH0qRIMe3CXS
	 0Edb3vTFg9orSZDvtQmRAw++iZHv9zlzqeT92VKmoV/GZw4xy1QClQNb672/XlF4OT
	 nJ+o7Z2QwBR+/Q5MoEKgotmMD5QGhfajCRwL2Remzz5aTQO7MkuO7hWW4MqtccLx8j
	 ACg2MEH2rG04hUyjGwCZAU96o1AfjOQqtSGiKejQccRmiZTqf1L1082AVspsh7ozs0
	 L5PwiRjlvv3MaUmuWKAyFNrx3N5QMonkxutT9KwMf1femg7Y/rtdLPMPrLKcJiWkbW
	 WuoKJkSDVoePg==
Date: Sun, 31 Dec 2023 12:45:37 -0800
Subject: [PATCH 03/14] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840452.1756514.6322317429011491219.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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
index c95cef827179c..b6b558f4501ad 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -708,6 +708,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -726,6 +727,32 @@ xlog_recover_attri_commit_pass2(
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

