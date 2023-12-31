Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99159BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMOCjjgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E651C433C8;
	Sun, 31 Dec 2023 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055976;
	bh=uOH/GGNHM80kkN8ob2khXThwkQOWbhJh4uQbHMQCpao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZMOCjjgQSzl7ZSQrK8Xmz9/sxVHz/hy+AY3Jwsz/zukzI6p+fwRYyoGvb43oBIjHM
	 w98fuuU5zftB8meckNwsGORjyyxauRlj9+Fkfmg2wYicVq0Cj2qavDFMlmd0+t+EvH
	 siF4VnWo5Mk/+nSuDSSAxjPt34PFqBRxjnu/Q2JXP7RgjUSr/tTabUfS0feCV2Sm20
	 Jxj/VZ6IMXO8lNWSj78HHBse0vpQKlgnHolQoA+oUelVnl6IvETM3gx4EoGcTyEzz6
	 GOuEE/QNeGkYkW7iHYj/WMFtKAxfkGuL5CxfCvDFAhoxt1uVs015rVkXCJZlsyd7QA
	 T+yh1ZNsrENfg==
Date: Sun, 31 Dec 2023 12:52:55 -0800
Subject: [PATCH 17/18] xfs: don't remove the attr fork when parent pointers
 are enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841311.1756905.5574521682852862097.stgit@frogsfrogsfrogs>
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

When an inode is removed, it may also cause the attribute fork to be
removed if it is the last attribute. This transaction gets flushed to
the log, but if the system goes down before we could inactivate the symlink,
the log recovery tries to inactivate this inode (since it is on the unlinked
list) but the verifier trips over the remote value and leaks it.

Hence we ended up with a file in this odd state on a "clean" mount.  The
"obvious" fix is to prohibit erasure of the attr fork to avoid tripping
over the verifiers when pptrs are enabled.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f7a4839e93e3f..2168747aaa2dc 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -913,7 +913,8 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -922,7 +923,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

