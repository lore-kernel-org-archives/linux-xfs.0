Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AA05C96
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300232; cv=none; b=lPyxIYafVBhdoGKKMnGnWuj7ZX3nzNlmUGztjnx2qVyxem49UU7RwT1u4AMvuY6hUByMWfBp3fVhR/0OANmoZH2hJvbdXKrs1lCWEu2WtFCk0HpNtafEcGKYD2WOAuZdVzC+BpSL5NpE4uhLzmLSbVirKSvB7O/hsOlpdtZ8kAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300232; c=relaxed/simple;
	bh=nXCYp8NGfklbGzFykjoVKDGFqGM7UWWmDnHxe5sgExc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jngEW98qOO9KAWsAmL4MeTvfoKTSWWO1tEUQNDvPJS1255i6xu8adgebZ0N9zmIOm/uhuUhPhxxf2IxuR64Vy70TqO6vS/11faGeQR3BJJTl44rU4x0INJHq1OWNhF3RJxsQqkIfHCGWErQDj1JYZRBo4azs1uFGYvSNoctE/5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUZJvPhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUZJvPhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48711C32786;
	Tue, 30 Jul 2024 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300232;
	bh=nXCYp8NGfklbGzFykjoVKDGFqGM7UWWmDnHxe5sgExc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SUZJvPhlUKtj0vx6TwQ3HHViSMJIvWmbeAwetAe9ieY/cktq+kxtFCVy0BtGa8mPh
	 I4iJ5nBXjpFTtu+F+AuQm+DFq/eYE3o80eygliBNGAjYhcdcsoYpf2kr0r4CrukRH5
	 ZOZs452p3b3exo6BOHGSEKycn18L9d1llIoXlPwFAQg6hwWkguhNSGqgT+Zzd6DgIB
	 l/FzTcwOKe2PUa0JQZzMIX04P7Jy4cyjf5iajWId/Rx5+BfKnS6qQLBQouwlFhQB3u
	 FDExjpIuhq+j+8EycdFDUNUDlYcAmLBMnHCLqkHdZ8Nk+8rS9ZLx/ybtUppyKCJMri
	 AHsubbdJdNLWQ==
Date: Mon, 29 Jul 2024 17:43:51 -0700
Subject: [PATCH 077/115] xfs: check dirents have parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843530.1338752.11619267767899663328.stgit@frogsfrogsfrogs>
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

Source kernel commit: 61b3f0df5c235806d372aaf696ce9aee7746d18f

If the fs has parent pointers, we need to check that each child dirent
points to a file that has a parent pointer pointing back at us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_parent.c |   22 ++++++++++++++++++++++
 libxfs/xfs_parent.h |    5 +++++
 2 files changed, 27 insertions(+)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index bb0465197..8c29ba61c 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -288,3 +288,25 @@ xfs_parent_from_attr(
 		*parent_gen = be32_to_cpu(rec->p_gen);
 	return 0;
 }
+
+/*
+ * Look up a parent pointer record (@parent_name -> @pptr) of @ip.
+ *
+ * Caller must hold at least ILOCK_SHARED.  The scratchpad need not be
+ * initialized.
+ *
+ * Returns 0 if the pointer is found, -ENOATTR if there is no match, or a
+ * negative errno.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_name		*parent_name,
+	struct xfs_parent_rec		*pptr,
+	struct xfs_da_args		*scratch)
+{
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
+	return xfs_attr_get_ilocked(scratch);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index d7ab09e73..977885823 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -96,4 +96,9 @@ int xfs_parent_from_attr(struct xfs_mount *mp, unsigned int attr_flags,
 		const void *value, unsigned int valuelen,
 		xfs_ino_t *parent_ino, uint32_t *parent_gen);
 
+/* Repair functions */
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
+
 #endif /* __XFS_PARENT_H__ */

