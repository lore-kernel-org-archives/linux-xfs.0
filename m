Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDCBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRwQxRou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF5AC433C7;
	Sun, 31 Dec 2023 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059950;
	bh=Mbee5DWekZSRT+ywVTraiP8+VFkYlVf8Lq2k09hGqgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rRwQxRouLsHTrXTo6RTwFEBwF080/P8SzH75JMeOUyIMQRkA/o3c9CPuEG0W9vNHs
	 h8PKVbNjm7wohcuirP6imtCHcgepC/zYyVh08Rm3I5/Ya8KVaF40oEKgQTIlZ7h1uX
	 t/1m8fJaFCD5DvI8onRBlduwf+MPKwWncknWCS+yvf7s5kXDEjWHopJ8xKvCp11hmg
	 +QYWMph480rMMOP0XT7++QBRQxRUw5bS3gpQYKQue1V6LfPFjD+Qe5oHlKj1ARz/7E
	 XUY7NspI8qM3xjMcVCBKuFGop3sj2ZQvj5QE6RjExjChYqu0o34Ni18fHFW1UAiSxf
	 tcj26ed/v1/ng==
Date: Sun, 31 Dec 2023 13:59:10 -0800
Subject: [PATCH 3/6] xfs: fix rt growfs quota accounting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404853223.1767666.13347327464674667016.stgit@frogsfrogsfrogs>
In-Reply-To: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
References: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
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

When growing the realtime bitmap or summary inodes, use
xfs_trans_alloc_inode to reserve quota for the blocks that could be
allocated to the file.  Although we never enforce limits against the
root dquot, making a reservation means that the bmap code will update
the quota block count, which is necessary for correct accounting.

Found by running xfs/521.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index cc83651636ecb..0af834897fad4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -842,15 +842,10 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc, resblks,
-				0, 0, &tp);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_growrtalloc,
+				resblks, 0, false, &tp);
 		if (error)
 			return error;
-		/*
-		 * Lock the inode.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -874,6 +869,7 @@ xfs_growfs_rt_alloc(
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
 		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
 		/*
@@ -886,15 +882,11 @@ xfs_growfs_rt_alloc(
 			/*
 			 * Reserve log for one block zeroing.
 			 */
-			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero,
-					0, 0, 0, &tp);
+			error = xfs_trans_alloc_inode(ip,
+					&M_RES(mp)->tr_growrtzero, 0, 0, false,
+					&tp);
 			if (error)
 				return error;
-			/*
-			 * Lock the bitmap inode.
-			 */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 			error = xfs_growfs_init_rtbuf(tp, ip, fsbno, buf_type);
 			if (error)
@@ -904,6 +896,7 @@ xfs_growfs_rt_alloc(
 			 * Commit the transaction.
 			 */
 			error = xfs_trans_commit(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			if (error)
 				return error;
 		}
@@ -917,6 +910,7 @@ xfs_growfs_rt_alloc(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1252,8 +1246,6 @@ xfs_growfs_rt(
 	/* Unsupported realtime features. */
 	if (!xfs_has_rtgroups(mp) && (xfs_has_rmapbt(mp) || xfs_has_reflink(mp)))
 		return -EOPNOTSUPP;
-	if (xfs_has_quota(mp))
-		return -EOPNOTSUPP;
 	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize) &&
 	    (XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) & ~PAGE_MASK))
 		return -EOPNOTSUPP;

