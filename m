Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DD380C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231091; cv=none; b=E2iNf1ZrwuQPaAa6QaqSs16pOW4rnGk0IgMV00bf/1FWnGHlIsPclJAAwTmmTTYvZgEFIo/Fd/qWqDimHnNqwtIzUvxbyTFKrJ7gtHzwsoPpJiBLq0j8TAzxMMGegcRY5+mo+y8j3G7RTu+xUJ8MYUoTAoJ+CYMSlNDWoJJVLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231091; c=relaxed/simple;
	bh=ND64G5HylAOZ0oE/K+HUxueY4tuLXo4yDE2el99tg14=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFM+yTmGCDHZNsqG+XxZ6gpLBIGkwgTC1u232kYE06/Z6d0n1ydJouVJJHFtGsF61imSS9nbJ+ZAgPOR9wYZvcxEpDRlIcLf+aiAmGKoG0Wx/H8DNOj9YRJ9h/XfqdoAlIJqHPrfnzxNUSVW5wWgbyv8PbgYtFnS7aWvkKUG6+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNUcWdju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNUcWdju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F795C113CC;
	Tue, 16 Apr 2024 01:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231091;
	bh=ND64G5HylAOZ0oE/K+HUxueY4tuLXo4yDE2el99tg14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pNUcWdjubikv+C5zMW+cJx6BMccOGwqhft19ClmWxfC8W0szgNfuzCgFxm6tHew7u
	 2gXN7IiK6bOQNA+xGnYfadv0thV9A343kVQ3ZpL9ekAYjfvyegPVhsFydbV0P6ZPSQ
	 wc4HaOugRL0bmobIXwaJ5R5Fjwfc+rH5Ir97sTjKDK/+k/7huTbwx/1ftaWe1jXpJy
	 MEO5xv5vhrYia/VPd8nvH1veO78Wz2eKgNnT+Levfyt7tVF+kCAInbVV+PKSEiD7d6
	 eW38MmOCUFT9Flw3+z7IJbm1OuM810Um2dMCz6ZCbbb78OP+Gssa5QeKslBnbP8myH
	 wmn7UvPH33CpQ==
Date: Mon, 15 Apr 2024 18:31:30 -0700
Subject: [PATCH 21/31] xfs: don't return XFS_ATTR_PARENT attributes via
 listxattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, hch@infradead.org, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323028128.251715.17144732888350103618.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers are internal filesystem metadata.  They're not intended
to be directly visible to userspace, so filter them out of
xfs_xattr_put_listent so that they don't appear in listxattr.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Inspired-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: change this to XFS_ATTR_PRIVATE_NSP_MASK per fsverity patchset]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |    3 +++
 fs/xfs/xfs_xattr.c            |    4 ++++
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 1395ad1937c53..ebde6eb1da65d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -726,6 +726,9 @@ struct xfs_attr3_leafblock {
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT)
 
+/* Private attr namespaces not exposed to userspace */
+#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT)
+
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
 				 XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 39651af255856..c33dfa20f538e 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -229,6 +229,10 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	/* Don't expose private xattr namespaces. */
+	if (flags & XFS_ATTR_PRIVATE_NSP_MASK)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

