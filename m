Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1669EC8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3tQO3JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D534C433C8;
	Sun, 31 Dec 2023 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063797;
	bh=BvDxWpmvDVzNThwxcvzklsvX8Vc1NJ2JtFxIaFf5ZvY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U3tQO3JK49aP8PahMZNacAOIZBIsJ0RK1U3NiT4rjWjRay3cOZWXZAov4nqE2SbSD
	 rYqbkmYnAoPTgvCaEBVYtXr9nS81J7T29Gxb0+2p6+T9S0smuD1KgnRMbOV5XHKUET
	 Pkuo5Nouzvu/Svhgl/YSkb3iMmRCp1IlrSbgMpvheEBAYurDcOsPy5vYoWu9pY+8ln
	 HaDltfHuCl+If2UcL3Jtlfg5NKCqwrl0Yc/z8gUhJEwvftclKwjfcwNsJWNnswGPJ0
	 sM/lwGMiuE28o5ngAoW2fHCj0AFRKe0kjgeOz42vv1H4+AfLUOc+m6OyDNDxNseLN/
	 HzSELhbdXz1UA==
Date: Sun, 31 Dec 2023 15:03:17 -0800
Subject: [PATCH 04/11] xfs: preserve NVLOOKUP in xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405005650.1804370.12958441930331877156.stgit@frogsfrogsfrogs>
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

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ca6cfb1ee8a..e714ea60319 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -943,11 +943,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
+	 * removal to fail as well.  Preserve the logged and vlookup flags,
+	 * since we need to pass them through to the lower levels.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	args->op_flags &= (XFS_DA_OP_LOGGED | XFS_DA_OP_NVLOOKUP);
+	args->op_flags |= XFS_DA_OP_OKNOENT;
 
 	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);

