Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC24963D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300357; cv=none; b=d1khnnQ09jTa7x1XG0qXq7k5fy2Ys1GZ82XFs/B34H0rgcilQyXsBrG1qx5H4aouP4NGmNLPoXMY2Dg/e71u9IQzmaSUyehJjb19tQBFJNcDsAJM7vnVLGUadpwGQm8cCzLhcWo11PD4IT77bLs4ElxbtT4t5U4ejnrpzrlCWYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300357; c=relaxed/simple;
	bh=CRUYQx5snKVYWwdu7tbWexDeV8aGc2ic6GE7Sx+ot2I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvMl8+5LdoDlmzSZehJtVeKLSB2is5kkMZ+G8nf6/h39+WGxInC1tlCgYWfyEFOXz9LlqSjVSQUyeW4LxR9FBFPs4bhSO1yEBmLIGJIKDFC4enErC92dKyT6LAfmjkbkINCYgCVGtqvZnmE4LLS5D3VMM/2jYUYoTgdx0RwXO2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5tnHn6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5tnHn6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3B8C32786;
	Tue, 30 Jul 2024 00:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300357;
	bh=CRUYQx5snKVYWwdu7tbWexDeV8aGc2ic6GE7Sx+ot2I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S5tnHn6p1CzwfDd4bbqwbSpEebQln4sItqGlvw7QjTN+/WfXn3YLc15Ex4uxfO3tY
	 IufnL9C/V8Fy55JITpFoSJaOIMIx7XUOkwZuiiBA4sfz3f15VveXFzRoWCb1JONB7l
	 81wpS6hAvYyD2qwC42CuvQcZd48zpm+bpDLBpsm0nTqnQwHcsgnWNxQdf8pNsKLlf5
	 LpWmhxOcK89bxqL2p3kH9O24ISXM733an8GQNGLgjCQZvTPfcz5qbwExB8dsz40WNt
	 cD3Gs7/juI8p2VH+vvRxMEjI+MTl2NhByuHE4+JCfrytp+7SDsH5nBNvzdNfDr4bhS
	 LF+lwzpaeaNfg==
Date: Mon, 29 Jul 2024 17:45:56 -0700
Subject: [PATCH 085/115] xfs: report directory tree corruption in the health
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843652.1338752.3168191725388025794.stgit@frogsfrogsfrogs>
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

Source kernel commit: 37056912d5721324ac28787a4f903798f7361099

Report directories that are the source of corruption in the directory
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 85f2a7e20..7ae1912cd 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -411,6 +411,7 @@ struct xfs_bulkstat {
 #define XFS_BS_SICK_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
+#define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 3c64b5f9b..b0edb4288 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -95,6 +95,7 @@ struct xfs_da_args;
 
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
+#define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -125,7 +126,8 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR | \
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
-				 XFS_SICK_INO_PARENT)
+				 XFS_SICK_INO_PARENT | \
+				 XFS_SICK_INO_DIRTREE)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \

