Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72F36CDE8
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 12:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291782; cv=none; b=IJTwqOsVjv1MirAXvb7dIGdusPKy44/J3gNFPyQ3c1zR5Bcdq5wEmzZYDZ4qQB+mf2fppzaZ1+r7QKYoaQzuf/qfFXJQKXGurdu4QJWegt3s2xqVw3Tu418eSZMACSmUeAGM1ma0rBs11mnKo/QdkqshoRmuBrsreomB/+rFeoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291782; c=relaxed/simple;
	bh=hK5oUgXp6lW1N9yIY211Z4m1ZJpYi10Z91MRAM6dA28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhOA4P3tSRdnBSJdc5FuHjp4S18b1rxktVVvqXD+RTIBCVYvRyOUvYp+cSbBdpYH9uOt2Qz3EvZsGFbq+xq91On/P9YlLYJHf7mDUbQO6CE2zFYx42i7vf/zkWCw3AtD3whxMIxnxZvu7/oHuMYWc0G37E7YmWim+HePYziuxhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtcyXklE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtcyXklE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED19C2BCB7;
	Mon, 27 Apr 2026 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777291781;
	bh=hK5oUgXp6lW1N9yIY211Z4m1ZJpYi10Z91MRAM6dA28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtcyXklEQOYyD/kZmp5R3WyChTHqZBBOCkmtzOY0kkXTC47hNd0MRs97ar8Q42So4
	 QAfmsh4IKHi3bimzUllv+O2zpVC5bWWgY/zCd4U0uzKO6MEenPI4QnA+9PenRuYIHe
	 bwX3Zr/vepY08n1xvUY8olzZWu3Wr3JIoJxjC7Ly4hDP2vWjUsqToAfp+Erq5w4ZIS
	 GjISODSF/WdPomrckzR8wZ+wE5Sv0wmRWTspWQBs2sZEcr0BYefcaAOCGJaXty2jdf
	 HaI85cQCm7rCUODYaeKuamsrRYwcYbaeYwbt/j+rCFzA/iqBMPUFSEEgyHf+20Z/Bt
	 LuPJ/F4tQUoaw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	leo.lilong@huawei.com,
	morbo@google.com,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 3/3] xfs: factor out xfs_attr3_leaf_init
Date: Mon, 27 Apr 2026 14:09:08 +0200
Message-ID: <20260427120908.52254-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427120908.52254-1-aalbersh@kernel.org>
References: <20260427120908.52254-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: e65bb55d7f8c2041c8fdb73cd29b0b4cad4ed847

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_attr_leaf.c | 22 ++++++++++++++++++++++
 libxfs/xfs_attr_leaf.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 90be21a38876..6aaa7ff10959 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1412,6 +1412,28 @@ xfs_attr3_leaf_create(
 	return 0;
 }
 
+/*
+ * Reinitialize an existing attr fork block as an empty leaf, and attach
+ * the buffer to tp.
+ */
+int
+xfs_attr3_leaf_init(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno)
+{
+	struct xfs_buf		*bp = NULL;
+	struct xfs_da_args	args = {
+		.trans		= tp,
+		.dp		= dp,
+		.owner		= dp->i_ino,
+		.geo		= dp->i_mount->m_attr_geo,
+	};
+
+	ASSERT(tp != NULL);
+
+	return xfs_attr3_leaf_create(&args, blkno, &bp);
+}
 /*
  * Split the leaf node, rebalance, then add the new entry.
  *
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index aca46da2bc50..72639efe6ac3 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -87,6 +87,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
 /*
  * Routines used for shrinking the Btree.
  */
+
+int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
+				xfs_dablk_t blkno);
 int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
 void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,
-- 
2.51.2

