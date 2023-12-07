Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1DF1845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7D5egfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC03C433C7;
	Thu,  7 Dec 2023 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915800;
	bh=NsWWt6ZyY2ygo5PAE9z16wsLuAeyqku/IlIG0NEK3gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E7D5egfh+SuJHQlUZH/Oc/OeBaiypIbpI2Gblb35ANVkKeNbxPmW1FcY2xpw3C4Pq
	 PpRlQwVSYvcM3BH6JhcrZ6k6pGiMZwo57vSalQZ84A1txE9jCl+sTSmsLouLE1mvpC
	 AACqgAgHDXMDmL2wv0hHJuSqkwjcW/vBjjeK6+Rln9K81hcQp5v6UJQXzpN3xv/3XY
	 RL0IkpqgZl9SBFnkuWwI8ucC32wrnfHAoS0034IOWPbGqA9DIk6Dx1dihCafzA2YPg
	 y31cBpG9G7wzirqi+YTwNP8vkqNGUDRqLmhVz/lNHYGNhAVpybBgs2JZWHBYCjguRB
	 oys6rjKLIZxlg==
Date: Wed, 06 Dec 2023 18:23:20 -0800
Subject: [PATCH 1/8] xfs: don't leak recovered attri intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, leo.lilong@huawei.com, hch@lst.de,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191561908.1133151.9374182101405120767.stgit@frogsfrogsfrogs>
In-Reply-To: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
References: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
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

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 36fe2abb16e6..11e88a76a33c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:

