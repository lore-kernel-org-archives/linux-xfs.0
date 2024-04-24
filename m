Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0461B8F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928669; cv=none; b=srBy/FM9OtpKcKyU3tyFgSXWdxRD2as+0yebJzQTxDocBqZo7NCi6sYuKbeDF6OgfBPFTzvAbDDQd5dH/nsUPqjWFylR9Bl4s2TsJBLBnmXvNDq59NNVcL5eSpUSwuPlYNgfqTpi6mco/NO9FdNTqVjtoZ/6t9nx+S+m9OK+H1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928669; c=relaxed/simple;
	bh=00ax3IiCLtbEeHY2uXgxB+3B6+mAUup/0MnXgv1CSeQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmygaBa1ysJ9WAAzSKTeocMhXWB49PNmuUdVoUIXoa6/dyf0l4MCayIFuyrVpwrKKurATAFWbyBlsrS3r51wDxXvZtmaSpoaxmewmaS380OQEF3vxC5VlQtDC2vn9ynzfo+IfNpbzYfGk2PjqxOYKv6dXenTUlIeIWU9aSVaSt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etVGm2hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etVGm2hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3E0C116B1;
	Wed, 24 Apr 2024 03:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928668;
	bh=00ax3IiCLtbEeHY2uXgxB+3B6+mAUup/0MnXgv1CSeQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=etVGm2hng8MHrx1zQrRSCphCZz80Po9fdSwkq3Ulr7he3DDS8gKFRObFwk7xqT0Cg
	 kv81O3L5Cy2mGfJlHTpwj0lcok3mEBTKmfbWJ5/DF+wIDSwoWeV7ld01BjYsnLIOzv
	 0MO3/B4XolUvtno+GdBbwnDskzfAQevgvO/05xFrrhixch1cc8qQg9560Od964jmen
	 DSSrT7yYYABpVj5d85neYslRsrQ61sUWW7X/N28xfZyePl9259s2R7E8v42PwD1q8l
	 YrmnfIL00Lem2HbQAZN5aiHJv32L04oQ8AR/8jp7t2jb9LQB/Rrwodcg5nE6TIAcPs
	 tdTXyAdmj8tig==
Date: Tue, 23 Apr 2024 20:17:48 -0700
Subject: [PATCH 20/30] xfs: Add parent pointers to xfs_cross_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783607.1905110.5442513764677947394.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
index 59488c17e1c1..ebe2ce9bd9ee 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2972,15 +2972,17 @@ xfs_cross_rename(
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
@@ -3049,6 +3051,21 @@ xfs_cross_rename(
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
@@ -3265,10 +3282,10 @@ xfs_rename(
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

