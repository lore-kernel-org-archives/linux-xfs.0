Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25AFBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYZE+DFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CB2C433C8;
	Sun, 31 Dec 2023 20:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055647;
	bh=15hxiE/mzyzlOco0H6E5COPJUsvpOADTNb5nnTjxDlY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CYZE+DFxr+oiJUipT/iL9cvCtN3pe2KOHuLwrz+OQSh2JOBNSocIwCai+1ra+hT4H
	 Lu1Xy8t0/XyDP3Z2tfbEl6pBDbkXC9BeGCCn9tfLnyrNBrlXZvmVE4N5VBvGBysWPM
	 hhXgMmkXoB8xBONBWhrd5ToEDI5ikeuNGlRPENZGPAGaMrzD7gxQCQ1o4Pe+RGgb8T
	 kt24nEo7GO9jQ7nCH4X4a0QnrgSQErP75BjA1xnQeiewQcFUHlUnW0X+eVwCaZUTPc
	 0SL5Ul1BK0X3JURhYWirFTXF6zHhRDuI3zlkThIOKoPnL32R/IBHM96rlSvU2HwHzY
	 FSuziMNdlW1Ow==
Date: Sun, 31 Dec 2023 12:47:27 -0800
Subject: [PATCH 10/14] xfs: always set args->value in xfs_attri_item_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840561.1756514.3635801941684306792.stgit@frogsfrogsfrogs>
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

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index b9a9bb7c1ebad..fbf392ab2dc5b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -545,6 +545,8 @@ xfs_attri_recover_work(
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -553,8 +555,6 @@ xfs_attri_recover_work(
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

