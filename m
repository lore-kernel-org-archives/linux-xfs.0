Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012CDF51
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="py7oLFRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F45EC433C8;
	Sun, 31 Dec 2023 23:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064485;
	bh=LN+lFmRreXrYEr88om5/Yf4FM08CpIkJSHWzI3siOx4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=py7oLFRqDxuCnmdMs/I76AHegPTfZitEtuw4003g+Dli0cUUme85Yc8Aw7JdgbqE1
	 bCF3OW/p4qn1HDRNC4pxO/yD4rf5eedmIQryCAAO+/TAHeGdgsvdF6Ym9mkXBiIAEA
	 oIJ8Bv1GkPtK/h5aHxOA8oZUd5/dbirzT9Vg04hnjslGbMHpRFAWBKmIUN3uPyLsMK
	 2dIGtXNxgc8Ef8gR1ewoCI2s1UDRU0NJ1Lxmd5fG4taBwXVDwmL0rfE3/KORRsneD1
	 ums4uYZ7nqhitpDb+06jIU3siWNGk/UQuM0iVz+ESn4rKc57vYFy3HXEdf+mIGfxrl
	 /ydYajDIxZ2DQ==
Date: Sun, 31 Dec 2023 15:14:44 -0800
Subject: [PATCH 05/18] xfs: set child file owner in xfs_da_args when changing
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006929.1805510.14126114105822304119.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Now that struct xfs_da_args has an explicit file owner field, we must
set it when modifying parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   13 ++++++++++---
 libxfs/xfs_parent.h |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index f7cef51e1ec..8f4196c20f1 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -202,6 +202,7 @@ xfs_parent_addname(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, parent_name);
 
@@ -240,6 +241,7 @@ xfs_parent_removename(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, parent_name);
 
@@ -289,6 +291,7 @@ xfs_parent_replacename(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, old_name);
 	xfs_init_parent_danewvalue(&ppargs->args, new_name);
@@ -372,6 +375,7 @@ static inline void
 xfs_parent_scratch_init(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -388,6 +392,7 @@ xfs_parent_scratch_init(
 	scr->args.whichfork	= XFS_ATTR_FORK;
 	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
 					sizeof(struct xfs_parent_name_rec));
+	scr->args.owner		= owner;
 }
 
 /*
@@ -416,7 +421,7 @@ xfs_parent_lookup(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	xfs_parent_scratch_init(tp, ip, ip->i_ino, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
 
 	return xfs_attr_get_ilocked(&scr->args);
@@ -430,6 +435,7 @@ xfs_parent_lookup(
 int
 xfs_parent_set(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -439,7 +445,7 @@ xfs_parent_set(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_LOGGED;
 
 	return xfs_attr_set(&scr->args);
@@ -453,6 +459,7 @@ xfs_parent_set(
 int
 xfs_parent_unset(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -462,7 +469,7 @@ xfs_parent_unset(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_LOGGED | XFS_DA_OP_REMOVE;
 
 	return xfs_attr_set(&scr->args);
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 58e59af818b..46bf96c7e3c 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -162,11 +162,11 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_set(struct xfs_inode *ip,
+int xfs_parent_set(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_unset(struct xfs_inode *ip,
+int xfs_parent_unset(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *rec,
 		struct xfs_parent_scratch *scratch);
 

