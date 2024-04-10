Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF801621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710756; cv=none; b=NfvkmmLt7hwBVJCNo+aFB2rZHyTnw8WBUEcC4cbFbqD+mzfzTmOspkCfYOOWogou8WB4lNevCHlEaXBLboKFQY5jrzFKFl5HeeeDhvxJe97DS9PGVteQfB1mzpik3bLHfFdU2RCpgirP8XT7wngIcK46RyY9xqK3PAi/VDCyYBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710756; c=relaxed/simple;
	bh=uP9kK6nFxA96HcRh/zy6QMTVhXnROs8f97p5JfgWKpI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTKth5IqrwGZPkQEts8l/dhC6GITEDmz3xTchm0h9M8+uJrVVc+Ogk7cON5PssWscah7WjlWNbBQ91Nf8Mm1T8cmA0qJFotvvFoxM57fkTwMVuRFxEQY2NzetKUpZdTz8z4qJNWLB3kTtJ/pfeiM6lxRk/SH1cZFPCj7z+kMLUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqQNmOWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqQNmOWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709DFC433C7;
	Wed, 10 Apr 2024 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710755;
	bh=uP9kK6nFxA96HcRh/zy6QMTVhXnROs8f97p5JfgWKpI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eqQNmOWV2DKy9DdtTS981d5LM2H5TqBhTwrzn9FLOJl4Bb3zB0qpaQ+NUlIiS2WMv
	 ukIEXRTEZ+GR2KCYC30eD5QSHq1J/Gnt44GpNPb4jA4hOKe5lfsMt9g2kzLX3S9AIf
	 8h6K2Rej1HelV4FWi3SWJEEgaS3un73ch5ZPLumFnbC672hzqWc4oXU35/wIvbCC17
	 xcJtMllyW49RB8fGum1iP9z3CSvskp8DgTJv+kXHIZ/rZZRpHpGl+2e9rhjTumIm8n
	 SKpc8VCuxmqyGBWAS9Qf3wzQ6rMNIlogakp3AgapTIysCYEnEGimayidaFnJmY8816
	 9tuf1BcrrO5bw==
Date: Tue, 09 Apr 2024 17:59:14 -0700
Subject: [PATCH 22/32] xfs: Add parent pointers to xfs_cross_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969925.3631889.2928122008436370702.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

