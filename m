Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90FA6FD0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299903; cv=none; b=KtntO6lSJM48JdMNvk3XvUqZQ4FLngjPYP1udHUeIRQmqC7HL40nb3/+v6qqOWxjMnGazi4LBPNqIsFmgeB6P96W4ozKQzIuokwBbTKCX//ZYXyxwXkB5rqS+8HL5/zcGyStdO+QVEDN4n3t6DNZt++J3LJxyt9NP/50yVFW+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299903; c=relaxed/simple;
	bh=1aQffbD5DMoCKiXNSwwNkCZVxemNMrJY/ACPZMlKFnU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LXxYZog2lScEMeJVqE56/IdJLZHSqPIyIX8klHNNuq4W+2f6GxSIdg8BhT9NvBRyjOCtQUSYGvHwaHH9L9SfMXoGaOfZkDjh/0T7/TXuUCsJSnJ82oxUPSa3X0TsM1BlpG2hSk0o7qYMxcPjlBr4O0DgiK5agCq3CoV/ahqg+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbndFcwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbndFcwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493D8C32786;
	Tue, 30 Jul 2024 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299903;
	bh=1aQffbD5DMoCKiXNSwwNkCZVxemNMrJY/ACPZMlKFnU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VbndFcwredBWmZUodSfjCkfAVQEK4aZtAsRTqty2MPklyymP4016W8Un0kxL/8F99
	 J/cW65aNz9nef1+mFj28CaDr0SXdni54+lJs4QlPHrLerCe906hr2gIlGsNuart+YV
	 bCa8yPUkThiOPgm1teWrRseBvG24foYfAahYTS7Ipt3AkWdTPwUHyg4Mx39alo2QTa
	 KTVLQpJzRdJtO8iBmq657uApGheHI9tfUeVcHnpFaJBZ58Uulj1X0PHMt8XKKWJsyT
	 AKrVzNgorXQc80mwmW59u4zQdg88XaOQUbJ0eE1cJ44ER0MnPw+5xdnBmVpZYb5UiM
	 V2bp0jOVDCR/A==
Date: Mon, 29 Jul 2024 17:38:22 -0700
Subject: [PATCH 056/115] xfs: define parent pointer ondisk extended attribute
 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843231.1338752.8854547612082746685.stgit@frogsfrogsfrogs>
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

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 8337d58ab2868f231a29824cd86d2e309bd36fa9

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

name={dirent name}
value={parent inumber, parent inode generation}
hash=xfs_dir2_hashname(dirent name) ^ (parent_inumber)

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the name-value lookup mode in the extended attribute code to
match parent pointers using both the xattr name and value, we can
identify the exact parent pointer EA we need to modify/remove in
rename/unlink operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |   13 +++++++++++++
 libxfs/xfs_ondisk.h    |    1 +
 2 files changed, 14 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 0c80f7ab9..1395ad193 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -890,4 +890,17 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name contains the dirent name.
+ * The xattr value encodes the parent inode number and generation to ease
+ * opening parents by handle.
+ * The xattr hashval is xfs_dir2_namehash() ^ p_ino
+ */
+struct xfs_parent_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+} __packed;
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 81885a6a0..25952ef58 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -119,6 +119,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

