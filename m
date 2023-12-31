Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6ED518
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZIK2Ql2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AEEC433C8;
	Sun, 31 Dec 2023 23:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064360;
	bh=GHPaI7DYe8ZMMq2rPXwpMHHLA8XeIzH9certDSh9zKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZZIK2Ql2jsQIDkS8nUXUMUacvqEDan2pTehyKDEDCWaxhuceQnbWsWsszo1n2Mr27
	 cc8vVGT/EtxECQUHPLr/A5XCUQVJsqUFgPfrPbLlbh0WEfXwfmSfJcyPwVTAcD6DYd
	 p0sfuNYxTfAMq2XyP6CLGabKXKrL4UgWBag/C5qlzYKpwEcISmZ1/REt30NdxwVA2U
	 glD7dHoyXG8vrfjC+8eW8l9MOV/jW/kAmxdNxfbBFfgfctHNPbDzFQ1qgr2GDJ4ZC8
	 c44WKHU0m5UlNDcQUHm6TSS0/1GQDnEQi26sXa9ocyE75JYJZ0hQNQj1g5eGXz2vMM
	 oXaXbml0lREMw==
Date: Sun, 31 Dec 2023 15:12:39 -0800
Subject: [PATCH 29/32] libxfs: create new files with attr forks if necessary
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006487.1804688.17023432522673020395.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

Create new files with attr forks if they're going to have parent
pointers.  In the next patch we'll fix mkfs to use the same parent
creation functions as the kernel, so we're going to need this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    4 ++++
 libxfs/util.c |   14 ++++++++++++++
 2 files changed, 18 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index b6b1282201c..397ce088d3a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -655,14 +655,18 @@ void
 libxfs_compute_all_maxlevels(
 	struct xfs_mount	*mp)
 {
+	struct xfs_ino_geometry *igeo = M_IGEO(mp);
+
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
+
 }
 
 /*
diff --git a/libxfs/util.c b/libxfs/util.c
index 03191ebcd08..5106a6433da 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -340,6 +340,20 @@ libxfs_init_new_inode(
 		ASSERT(0);
 	}
 
+	/*
+	 * If we need to create attributes immediately after allocating the
+	 * inode, initialise an empty attribute fork right now. We use the
+	 * default fork offset for attributes here as we don't know exactly what
+	 * size or how many attributes we might be adding. We can do this
+	 * safely here because we know the data fork is completely empty and
+	 * this saves us from needing to run a separate transaction to set the
+	 * fork offset in the immediate future.
+	 */
+	if (xfs_has_parent(tp->t_mountp) && xfs_has_attr(tp->t_mountp)) {
+		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+	}
+
 	/*
 	 * Log the new values stuffed into the inode.
 	 */

