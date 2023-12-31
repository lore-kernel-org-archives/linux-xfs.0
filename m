Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C07BC8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1c1TKnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ECBC433C9;
	Sun, 31 Dec 2023 23:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063860;
	bh=mGYNXjPF5NWZaFX9c2+jDvCqL8FStNbxso250XPVi7c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M1c1TKnuimP2oWHc7EJGH+5FOWjP3mySi77GaTkXuV/QGgcYh7yHUZD22+RUAJSsp
	 YR27wlxr62j5GWAuLF4O2ckGYsXL1E9tPrScqtDLJZ2yPV3weMoYfj9IacjOeLvT7c
	 ZqmBmHDalJ6AWUZTUxu5vYdU3ZWRg+3dHgUxXlRYFQJb/v40iVaK5zdEQBE2BH05RQ
	 wxUBMjcyBor0X+Zb8P5GaHCYxdUtqEs3o/1cnsAen5/7ArZJYixlgk7Ps4jI8jLejD
	 H3et7Gq4l4u1OLp7QpK9EdagaRx0OFf5nbXDUUcSHzGRKnIk11lG5ASwLe8x2I59rc
	 +J+hVVSTpQDYQ==
Date: Sun, 31 Dec 2023 15:04:19 -0800
Subject: [PATCH 08/11] xfs: log NVLOOKUP xattr setting operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005703.1804370.18312911467773302433.stgit@frogsfrogsfrogs>
In-Reply-To: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
References: <170405005590.1804370.14232373294131770998.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr set operation with the
NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    2 ++
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 3 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c38048536af..47684d07693 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -896,6 +896,8 @@ xfs_attr_defer_add(
 
 	switch (op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
+		if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+			new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_NVSET;
 		new->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index bf648b75194..2ac520a18e9 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1044,6 +1044,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

