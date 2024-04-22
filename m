Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AB15381B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804048; cv=none; b=UJQTHr9mBHDJ+E88sbs5XykSKfeEsQB1OD0WjVCK5ZyRmhazTeJB8P6vmd1qhacfRbyiZ6PycCFzx9v5E0ZpQrtq/RFA0wGsI4gY0FFMthVD1B53tqRIgtzKw1xP41eQmyAwhd0eRBXhQOCbKfIoOJggIxCmo2kBdSKawrZDTpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804048; c=relaxed/simple;
	bh=YlAi+kr94f8AxIotiARGHP4DpvJjCtJwFSPXjiNhH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyqa5d81/8u2XVO2KqIFtJm6wyg8+knr0BDZWodL+wtrYmwM4Guc/cX1dg4SYA13agJVMcCi6Mq1WkuYKEnjjusaiDG0yxN1ti84fz84BLj0lKJCcbzlKG+3jbcWFyaifw/aqCU7SvLpbATd2R3Qyob68EYV3tnYILdQJ4iPcG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUYuKWNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUYuKWNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B463C32781;
	Mon, 22 Apr 2024 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804048;
	bh=YlAi+kr94f8AxIotiARGHP4DpvJjCtJwFSPXjiNhH7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUYuKWNJ70MIj/DqxSFh/O53hOFVQy6meQj57rd1YlPDg+PxgQUsh8aQR/awAXPKn
	 Io3LVSa/t/BqlEtHUS+YmpDL52Yz849oRTBabThOQG5XyFCL6LQX0XPza/jfYcIraV
	 zMG6aagxGrzT4y6ooCNG5UCqq7u0pSJ8uONC9Bf5ifiV7spPZJxrOauV5bTDsJog9+
	 OQim/XiXjoARgHzQEsi7l1xMVdhAVXbM4WsiLb97Zd5a/U6nrd3td64RclMBO0i552
	 DYvBXP5F8Kau8dbeWAZtbofF7OAPsFj5+rRuBFiNffuTC/5QtXviQ3b3kfLJcoaChV
	 qLxRlafROc8xQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 66/67] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Mon, 22 Apr 2024 18:26:28 +0200
Message-ID: <20240422163832.858420-68-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Source kernel commit: 82ef1a5356572219f41f9123ca047259a77bd67b

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1419846bd..630065f1a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,10 +419,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 
-- 
2.44.0

