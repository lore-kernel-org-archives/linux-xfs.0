Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC1DF44
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUh9aRHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA5C433C8;
	Sun, 31 Dec 2023 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064438;
	bh=ZneBvJb+8Nk/29u2qGI3xRkS0yX0F5oUrU58Gb2K5dU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CUh9aRHUFuaiAA+xR2a/JOjMyMqntOHLb1uphRj0DPHD163FeVUn3B7I46qvMohzq
	 xUO7TokNqBY5umrG4YaLjxpnKtHGuMCUzC0QdtnmSfKFPrF/5jK1u2PgTcgHcQaT33
	 B9SINbpP+Ge1hPwQgEiR509HKLnE3Tne+dBVlIyq4Nn7M55ILzZdhJTZnawQXbjsOv
	 bFqtqAxCpWHLyjfw8uv85UOPdTVxVQ/KkHcPdv6bBev8EyjaPA7+K4/p+HCkB+cfFg
	 Aaa/cSxfPFf78uVo5Sj+t87bzhz75SCL84+i4fMrB4jkSmxOyepvz4hPfe5KLv5LQ7
	 L4JFp5GaAkeGQ==
Date: Sun, 31 Dec 2023 15:13:58 -0800
Subject: [PATCH 02/18] xfs: check dirents have parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006890.1805510.6360248917737490532.stgit@frogsfrogsfrogs>
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

If the fs has parent pointers, we need to check that each child dirent
points to a file that has a parent pointer pointing back at us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |   10 +++++++++
 2 files changed, 64 insertions(+)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 92b541737cb..024e89756e6 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -367,3 +367,57 @@ xfs_parent_irec_hashname(
 
 	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
 }
+
+static inline void
+xfs_parent_scratch_init(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_NVLOOKUP;
+	scr->args.trans		= tp;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
+					sizeof(struct xfs_parent_name_rec));
+}
+
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.
+ * Caller must hold at least ILOCK_SHARED.  Returns 0 if the pointer is found,
+ * -ENOATTR if there is no match, or a negative errno.  The scratchpad need not
+ * be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	int				error;
+
+	/*
+	 * Make sure the attr fork iext tree is loaded in transaction context
+	 * before we start down the rest of the call path.
+	 */
+	if (xfs_inode_hasattr(ip)) {
+		error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+	}
+
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
+
+	return xfs_attr_get_ilocked(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index e43ae5a7df8..e4443da1d86 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -152,4 +152,14 @@ void xfs_parent_irec_hashname(struct xfs_mount *mp,
 bool xfs_parent_verify_irec(struct xfs_mount *mp,
 		const struct xfs_parent_name_irec *irec);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */

