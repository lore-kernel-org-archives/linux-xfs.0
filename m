Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382FE57872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998956; cv=none; b=I6bAecA4tujwuTa2VOm2UHxOorFt48/IuHvlRxvT1xDnKlFnvnQyQqROXWUO6CyGna+2gMbe8YPywbr4TJNBBUPjOwppVNNyHWYVifxS9k4uhBlPatmlSJT2zSP1+vpU1hr/hxBBowYRCwpQhFY5bm4RTyNIARWZyfptBAud3sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998956; c=relaxed/simple;
	bh=iwDMepkuoscv3NdEa0bdBQ71P/lOFy4WfEClCFIYWls=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bazk/AK5h/kod/nMoXB7EWTh2XB0X6ss7JXu6d9OpaxxW1PU/T1Bmmb7ViYgmlizSfFLzGksto57EKnhnnEA4bptvMOhfh0PyBF1ZIauDBfoUXWwwR+/Q1xHwsLhetQcg3bDs592Uo4oo992BHHdRY7nCXklzl/XgeNUovvLFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjfOdRLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjfOdRLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150D3C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998955;
	bh=iwDMepkuoscv3NdEa0bdBQ71P/lOFy4WfEClCFIYWls=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BjfOdRLKgW5I2f79X4D8xYoHnBBDQBzQDs6rIjlynvCPZO8qmAbJN4KuK+JQjIDT5
	 ZpXh3YjLXhWZKPGyp9NBD61pwsha1rmunsDb6afZ2iHu2MYZMUBRDOnrGQK2k9vRLP
	 74k5rzH0VJzP4oL5KCPWWsCl7soUa/sPvwbsORj0XURbm6n/x72dSVGoj0lXfuFxfc
	 ZTW3NR46oxzyLN+x7O9T5rDH7stfioQ4Lck2N9A+TOM6hRW2zNHv05MM8K2jQKTc0I
	 mPyrMeN1exYmZIaDPqiydJQTi1lx9nyNmhRLLhSI5keTfvUCBLdsUPaX2mk8HjxVuJ
	 4vBpbB5WY4kXg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 01/35] xfs: bump max fsgeom struct version
Date: Thu, 15 Feb 2024 13:08:13 +0100
Message-ID: <20240215120907.1542854-2-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 9488062805943c2d63350d3ef9e4dc093799789a

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index a5e14740e..19134b23c 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
-- 
2.43.0

