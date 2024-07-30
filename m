Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D786110E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299668; cv=none; b=VdtAeAuSxBCOlBnybwixZxpUKhVSbTx5NvIDA9bumzrWNZn631TGUR5C9MoOV8oLpVqLt2AjYctArBB15xZ/o3LtkovzQX3DwPXJ5ZRGT7MPuv+2gSJq3dd5Uc6U1RqDuvcE+ClmXOR+TwUwmQ7CwjZ1CrKdD594d2rFw7S7Dlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299668; c=relaxed/simple;
	bh=XKX4yNFaIltEpIacbHoR3aTqxIT2InsWyFxu8dXyde4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YadjL6/wWu+gSWroMa7qWHAmy1hBoIBBpxt4+0tc7J/lWXlrQ+tJvfjotOam3T4FOHZGe6yjOiPa0N1hEfvHUm16ZWFuy4k++19ROhYp/n+6bcfRjXNMDEG9c+MRBv2kQIuYrKZ1rDbhefOyl3Lq5NrNvyDFgD2WWl77Wnnja4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpOVjzK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpOVjzK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D7C32786;
	Tue, 30 Jul 2024 00:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299668;
	bh=XKX4yNFaIltEpIacbHoR3aTqxIT2InsWyFxu8dXyde4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OpOVjzK/xLAZeRmpiNacRdRC1lGJ+08KnC72oqhaf4FBF/brTv8JTWi2EJzQTT1dt
	 30uWUwDEiQacIX8JIhHsVNx5DwuUjk2WTeDBpc3kPiUdNbAnDqYi2YwbEqyzYj0O0v
	 82IoAFEIsV4/LFIX3zxKHNjFPc+kScjhT0j9Z2fnOVOFwK1oTwdocByG+1hoUT2f0c
	 BckOyXzvyzbj1DSYP8Hqjs3d7gP1C78nibZsQ6gP2HvcXn85uOevC6tyPuJyvtAJQy
	 zlrZ4wgfeGq+pwjShcwoAUvT0PK+/+s71ND3pXkpQibcRRTWXnsfKRoxMD7GGOfbbb
	 r93ThUM5+Og3w==
Date: Mon, 29 Jul 2024 17:34:27 -0700
Subject: [PATCH 041/115] xfs: remove XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843020.1338752.3697044140404729295.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: f566d5b9fb7136d39d4e9c54d84c82835b539b4e

Nobody checks this flag, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h     |    1 -
 libxfs/xfs_da_btree.h |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index e4f550085..670ab2a61 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -590,7 +590,6 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_remove_state(struct xfs_da_args *args)
 {
-	args->op_flags |= XFS_DA_OP_REMOVE;
 	if (xfs_attr_is_shortform(args->dp))
 		return XFS_DAS_SF_REMOVE;
 	if (xfs_attr_is_leaf(args->dp))
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 7a004786e..76e764080 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -91,9 +91,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
-#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -102,7 +101,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 

