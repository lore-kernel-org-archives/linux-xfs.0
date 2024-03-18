Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576F59B42
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798293; cv=none; b=h4AP5pvz1Lw6oRV0KUQK3Tawu6tE7MdHglvcr4caP5FW6oQLZaju+a5pKWZTQ1k3ii4x6OifgqtmvvlsEwALXcP/qDn8j4CpBbbyICaCNEyul7lkQEmavUe7zDcJepRT7l7yEZhu+lKLDRhQ4PbiweXMLzekXmzrPpnbz1FxU0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798293; c=relaxed/simple;
	bh=AXHjwKdh5jeoIkCSvh8/ajIM7OgT8Y4n6T7iYZXWym0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=scjatWq9XnwNOABaeNs+XZQRePsXQVd3dVCOXXZ7IXgtxiWLHNc1iyi07AR4SOyUmrvz8PupbX0dchlifyjMYHZ2d091XjAPXTVOx4dg6WZ2axaT8FLF7fufn6az7Zl9l5cf+ZiGKuWA0CzYw4ckoWfm1J5AD9guVcaJEf6g/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dj10huv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dj10huv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83626C433C7;
	Mon, 18 Mar 2024 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798292;
	bh=AXHjwKdh5jeoIkCSvh8/ajIM7OgT8Y4n6T7iYZXWym0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dj10huv7C+/NGvRlzL3FG0tS16bBsAqVhHvF2f/rjeZAKMLeDxc5BP7yWO24IRMof
	 1XX5W/xPKhrcIdl2hXSjf/Gxq7IMEFELD37g5og8pZjlyJu4a5QOL3NaOjh94E3f8j
	 vutXVHBjkJt8r2PYkYfFpNJpvPyvgPMh1L9C/YiTKmRo4EKb9PsQVocTiGW1HztEND
	 9DS+1Al+uBztpm16GY3W6/9zVgAkoGuN7fcB+o+eZgiKjAtp7AP3MgdGHrcJwjPSzF
	 duU04vpuVrNjy3S0JDbHFEAvKPBx6c9owIgefUNcu/qdbWd+Gvo8pD/6jLtKj1nzVO
	 UN3S10MJa67tw==
Date: Mon, 18 Mar 2024 14:44:52 -0700
Subject: [PATCH 11/23] xfs: Add parent pointers to xfs_cross_rename
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802054.3806377.1080885289618860088.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
index 534569bf89619..8ce68a7dc2e8a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2976,15 +2976,17 @@ xfs_cross_rename(
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
@@ -3053,6 +3055,15 @@ xfs_cross_rename(
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
@@ -3269,10 +3280,10 @@ xfs_rename(
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

