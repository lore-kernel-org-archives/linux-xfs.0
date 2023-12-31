Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B433CC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1YeOZvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437C7C433C8;
	Sun, 31 Dec 2023 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062124;
	bh=CYIKi0GOhQyKeNYmsEJTwnfaCJrC01HjC5e4qlIAnwY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V1YeOZvAURIrO6M6NYjkbM/gzBv6dRcZpR8wvHDLeg3IfMG2hJPISRuqhYkGyvOXI
	 rV1tt+h1Y5mMAsnOgLQNWHo/OoWR8JaAO0af+4cJ3IgbzDS/iPoX9iNT8oeabZhDOF
	 NkBNYE45vwA0S03LpvCQ2r+W/Z0uTJyjn4lh8UecIRkNMXaYUxp8Mu3M3BjiUYsXnd
	 NtxidJUPd5pu1STuC2t3yqNsh/UDf1ZmbZe6QFOR0IIElUZChRExPy0k+B2JGX83eU
	 293ZmPzSp/PMTjNGvX/RoT64d6PtJ3Xl7Q5LtCH2FO5vqQUJWGUmFX9SxX1L1gYvvF
	 Zpuo/OduPpGTw==
Date: Sun, 31 Dec 2023 14:35:23 -0800
Subject: [PATCH 1/1] xfs: map xfile pages directly into xfs_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997970.1797094.13056398021609108212.stgit@frogsfrogsfrogs>
In-Reply-To: <170404997957.1797094.11986631367429317912.stgit@frogsfrogsfrogs>
References: <170404997957.1797094.11986631367429317912.stgit@frogsfrogsfrogs>
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

Map the xfile pages directly into xfs_buf to reduce memory overhead.
It's silly to use memory to stage changes to shmem pages for ephemeral
btrees that don't care about transactionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree_mem.h  |    6 ++++++
 libxfs/xfs_rmap_btree.c |    1 +
 2 files changed, 7 insertions(+)


diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
index 1f961f3f554..cfb30cb1aab 100644
--- a/libxfs/xfs_btree_mem.h
+++ b/libxfs/xfs_btree_mem.h
@@ -17,8 +17,14 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
+
+	/* XFBTREE_* flags */
+	unsigned int			flags;
 };
 
+/* buffers should be directly mapped from memory */
+#define XFBTREE_DIRECT_MAP		(1U << 0)
+
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index a378bd5daf8..7342623ed5e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -670,6 +670,7 @@ xfs_rmapbt_mem_create(
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
 		.owner		= agno,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);

