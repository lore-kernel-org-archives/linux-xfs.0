Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC3E33D8
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231076; cv=none; b=kivpulzzt9G/YZ+SUBAsFC43xTIvlhUrlfr//1nmLArclG79zg9tmj2fgTnt9eKJEp616l8bpUBHHI5+87M34mP0FZETuLVwjcSEpvCwXSv3kENgeJU4pRhptawnzqrJYjKpPkYjotVJa+ifIIX1V3SiPwbyRu7N4GdUBM33wlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231076; c=relaxed/simple;
	bh=5A/OT0yZAwFfdLP9Urt9vJ6iVLC125ts9rNHxS9kZ9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpQVK/k7cxssg1CRdlltw+QS5DxTaFhEbXJW7Phoe2zKbDUG3T2rOssDOKHUi9q3i4KD6JSiSYn7bV3WvrDy1cF9edYeAdAN3Qe3KHgEBc6PtmdzcVDmEF0DUIllovpMYUWWEg3gu90FCwYdkIo9sYX7NB6ETLkxqOtjUbqWewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2LmRSPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2LmRSPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC88DC113CC;
	Tue, 16 Apr 2024 01:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231075;
	bh=5A/OT0yZAwFfdLP9Urt9vJ6iVLC125ts9rNHxS9kZ9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t2LmRSPEuir66hR/e5gOSVXeWBcnc/uu5zi7XmKVVKvPHylnT+fbypKxsNbcfmgnr
	 aviTg/LGw1VjBvbRsKKWDnbQwltxcb2OV4zz9bzdEpSz2IhX++lmq9cqeaTmDzFFtK
	 lx7gpF94vfAaBmi7l4SxghIv85orpSPODf8AGSE+7OUKVk8SOjGpAdGN06LCehmNEI
	 cpnZKuCM/aE6TYhTsOkvfe6NHtLnP1W/p2srK3lCXT9k608a6DEjYBJA1Kdf2yND2F
	 xzLFI+NpN/M0uvSS7IJuGzyGXO6Nipvhdjbs+dXqTZ05n8ofpseEWtO0POuICHQcoA
	 UgP9Asy+L3Kqw==
Date: Mon, 15 Apr 2024 18:31:15 -0700
Subject: [PATCH 20/31] xfs: Add parent pointers to xfs_cross_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028113.251715.7186887095665065567.stgit@frogsfrogsfrogs>
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

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea619f5140739..766cbb8b7be51 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2971,15 +2971,17 @@ xfs_cross_rename(
 	struct xfs_inode	*dp1,
 	struct xfs_name		*name1,
 	struct xfs_inode	*ip1,
+	struct xfs_parent_args	*ip1_ppargs,
 	struct xfs_inode	*dp2,
 	struct xfs_name		*name2,
 	struct xfs_inode	*ip2,
+	struct xfs_parent_args	*ip2_ppargs,
 	int			spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	int			error = 0;
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
 	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
@@ -3048,6 +3050,21 @@ xfs_cross_rename(
 		}
 	}
 
+	/* Schedule parent pointer replacements */
+	if (ip1_ppargs) {
+		error = xfs_parent_replacename(tp, ip1_ppargs, dp1, name1, dp2,
+				name2, ip1);
+		if (error)
+			goto out_trans_abort;
+	}
+
+	if (ip2_ppargs) {
+		error = xfs_parent_replacename(tp, ip2_ppargs, dp2, name2, dp1,
+				name1, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -3264,10 +3281,10 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
-		xfs_iunlock_rename(inodes, num_inodes);
-		return error;
+				src_ppargs, target_dp, target_name, target_ip,
+				tgt_ppargs, spaceres);
+		nospace_error = 0;
+		goto out_unlock;
 	}
 
 	/*

