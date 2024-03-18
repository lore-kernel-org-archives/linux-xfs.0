Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05F95A7B7
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798464; cv=none; b=KLdTl4oUg/bjZTvhxHcAsCan3r6DkUyc/cvRqguxBQtkB/rZbg/FWyLV1XaOL5qRVgQnh3S/k+a+hkFelO9m7oSwaJjL6RJfIwpdHgMgYPM/mg1QmlBpdSGsaS2kP4bYTzDI/LdGGxmFAPkoxd90IblEGNPGXE6FzDo4BPrCkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798464; c=relaxed/simple;
	bh=Rhh1bNQiGK80Dq0OkOl5v+WGuP5AZR1M8K9ABik/aag=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmkZKGC5IzvoKhG0HXvFR1eRG03unPzx5sJLoh0OAvKk2RM5gMR5gQA5gIKKbaKjv107PLfkZ882do9/tAo8f0C6YuSKHCTFxvqz3LubJ4COgqBlbHb28SymKptvAp+oifPYn82DkSAf9QPNAL0TXrI5l7cVi7YirQ1jDHVrbdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V31nw9oP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V31nw9oP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84C6C433C7;
	Mon, 18 Mar 2024 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798464;
	bh=Rhh1bNQiGK80Dq0OkOl5v+WGuP5AZR1M8K9ABik/aag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V31nw9oPEKigh5fPVFL625wyL2gJ1R287vO00Fh3Efa0ayO6KPpPBJB+CjNBy9gbs
	 QBUtatnDBLLASQW4ONOvm8xCI0mY0U/AesNFKOt41IAHIAqmLqi0dQd88LYHufFWEa
	 vKNzTvga0zbSKstLy3gkQ5w4J1ZNLqVxwb7Dd6OLt54NS1e00nPth0PouNE7vWp9N8
	 veF1ntCMni/bMT2780Q9MQY/7Wx7O/iXZNhYEeqpDL15ElARvkbY4xgiHGzkwsCP6j
	 9KiNJbbUwt+e6FXb0DS/o5jF9tJz7xMQE248MV9YiSCFKvp4Y05XcMdSZHoPnlrbcC
	 KS/28OLxcFnLA==
Date: Mon, 18 Mar 2024 14:47:44 -0700
Subject: [PATCH 22/23] xfs: make XFS_SB_FEAT_INCOMPAT_LOG_XATTRS sticky for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802233.3806377.350982395892791225.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Directory parent pointers require logged extended attribute updates to
maintain referential integrity with dirent updates.  Make sure that the
log incompat bit never goes away.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8d56ec1779f26..62351fdde2c80 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -620,6 +620,31 @@ xfs_agbtree_compute_maxlevels(
 	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
 }
 
+/*
+ * Mark certain log incompat feature bits as sticky, and make sure they're
+ * enabled.
+ */
+STATIC int
+xfs_mountfs_set_perm_log_features(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_parent(mp)) {
+		/*
+		 * Directory parent pointers require logged extended attribute
+		 * updates to maintain referential integrity with dirent
+		 * updates.  Set the LARP bit.
+		 */
+		mp->m_perm_log_incompat |= XFS_SB_FEAT_INCOMPAT_LOG_XATTRS;
+	}
+
+	/* Make sure the permanent bits are set in the ondisk primary super. */
+	if ((mp->m_sb.sb_features_log_incompat & mp->m_perm_log_incompat) ==
+						 mp->m_perm_log_incompat)
+		return 0;
+
+	return xfs_add_incompat_log_features(mp, mp->m_perm_log_incompat);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -826,6 +851,12 @@ xfs_mountfs(
 		goto out_inodegc_shrinker;
 	}
 
+	error = xfs_mountfs_set_perm_log_features(mp);
+	if (error) {
+		xfs_warn(mp, "setting permanent log incompat features failed");
+		goto out_inodegc_shrinker;
+	}
+
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
 	xfs_blockgc_start(mp);

