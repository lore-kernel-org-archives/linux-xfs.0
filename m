Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93ABBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQJRo80r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414D2C433C7;
	Sun, 31 Dec 2023 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056774;
	bh=1WWaxfEjB7riMGIa1Y6EcP9Yk6U735Zp/bPGcdF0RtQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQJRo80rJs7v6skZKjL12AlR/2vMZrnL4q6kINcL/FCxOxylNdpHy/4J/2JpUwJdW
	 zvjwLU7MxGrRxKpgPbJAKG+J7OqD/TQAfPnKYFEhx9wdeXmpgC2RXSuq4DC6qGJhCL
	 2LmeMOJPUMiSysLyrgi4UONgxGK/1rXN2x4bGGbLmKldtVIFWslXUSuRcxpSE3HK7k
	 1j7s/Y/qKsJ/c9JwROM1GRz/1NrKBTwHxWwpMA2ZFcLqIZmMnUc3ka62cHfweANhwQ
	 ahZaw7SKt9Xw0ga+k/pCrQxzAh2PpmHQ2f0wcDk6k7myoKghoHa5rpABVZNV84K/vN
	 hJQHhGKg2K5Qw==
Date: Sun, 31 Dec 2023 13:06:13 -0800
Subject: [PATCH 21/21] xfs: get rid of trivial rename helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844391.1759932.10960666315666314639.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

Get rid of the largely pointless xfs_cross_rename and xfs_finish_rename
now that we've refactored its parent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   77 +++++++++-------------------------------------------
 1 file changed, 14 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bafa13ae3c1d7..789b9603989c5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2152,63 +2152,6 @@ xfs_sort_inodes(
 	}
 }
 
-static int
-xfs_finish_rename(
-	struct xfs_trans	*tp)
-{
-	/*
-	 * If this is a synchronous mount, make sure that the rename transaction
-	 * goes to disk before returning to the user.
-	 */
-	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
-		xfs_trans_set_sync(tp);
-
-	return xfs_trans_commit(tp);
-}
-
-/*
- * xfs_cross_rename()
- *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
- */
-STATIC int
-xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_parent_args	*ip1_ppargs,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	struct xfs_parent_args	*ip2_ppargs,
-	int			spaceres)
-{
-	struct xfs_dir_update	du1 = {
-		.dp		= dp1,
-		.name		= name1,
-		.ip		= ip1,
-		.ppargs		= ip1_ppargs,
-	};
-	struct xfs_dir_update	du2 = {
-		.dp		= dp2,
-		.name		= name2,
-		.ip		= ip2,
-		.ppargs		= ip2_ppargs,
-	};
-	int			error;
-
-	error = xfs_dir_exchange_children(tp, &du1, &du2, spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	return xfs_finish_rename(tp);
-
-out_trans_abort:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /*
  * xfs_rename_alloc_whiteout()
  *
@@ -2402,11 +2345,11 @@ xfs_rename(
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
-		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-				du_src.ppargs, target_dp, target_name,
-				target_ip, du_tgt.ppargs, spaceres);
-		nospace_error = 0;
-		goto out_unlock;
+		error = xfs_dir_exchange_children(tp, &du_src, &du_tgt,
+				spaceres);
+		if (error)
+			goto out_trans_cancel;
+		goto out_commit;
 	}
 
 	/*
@@ -2484,7 +2427,15 @@ xfs_rename(
 		VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
 	}
 
-	error = xfs_finish_rename(tp);
+out_commit:
+	/*
+	 * If this is a synchronous mount, make sure that the rename
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
 	nospace_error = 0;
 	goto out_unlock;
 

