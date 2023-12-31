Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB816BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yaprtm2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA67C433C8;
	Sun, 31 Dec 2023 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055882;
	bh=DWGlmIFIEXkMWyOhQEJiMYy6mPESxCBebRmsXNBkcqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yaprtm2fiFMcUD52Eks46Zexh5/prlaGgnC3Q0ejgog+5tstccSR0d62S8LVsqBqV
	 r7o6NtyHGVuZr2wVBJVruI63HHuCpRsclkVXfq+CjBxKTmItTD/vxjjpEDCKsPCD+Z
	 t9+mClE/4jargfhSmfyixX6YqlkdifvSZ+VBUQoqhWy9Vv/7fEJT3r8IszLIFXMhQJ
	 oHng7l+ENVHA1jhmj6JXPjOb2XZLX096WpW72WZSgZE9HTB2JtK7kgctv7ulv0BGYn
	 w583dDepwAs4tcwt5F3FRDbBkTFWv+6xwPGVlT/YBwU5llrnX39Mkm1ZvB4PiyOR0j
	 +bnyity+Yinvg==
Date: Sun, 31 Dec 2023 12:51:22 -0800
Subject: [PATCH 11/18] xfs: Add parent pointers to xfs_cross_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841217.1756905.45527345331323865.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_inode.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3723b4bdc47c7..998df0d5dac3c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2967,15 +2967,17 @@ xfs_cross_rename(
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
@@ -3044,6 +3046,15 @@ xfs_cross_rename(
 		}
 	}
 
+	/* Schedule parent pointer replacements */
+	error = xfs_parent_replace(tp, ip1_ppargs, dp1, name1, dp2, name2, ip1);
+	if (error)
+		goto out_trans_abort;
+
+	error = xfs_parent_replace(tp, ip2_ppargs, dp2, name2, dp1, name1, ip2);
+	if (error)
+		goto out_trans_abort;
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -3260,10 +3271,10 @@ xfs_rename(
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

