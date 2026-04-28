Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358BA3D648F;
	Tue, 28 Apr 2026 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365301; cv=none; b=hxrA1xYkBA23cD/RAmv59F6th2aIvTYKwBnfUTYLTpwpZwuRGy0yUA64CHSnpB0axCyCMhjKDmPD4+U1FV+K+jZpisSYeK9CXZ+bs3OePu77pC8gTED0Uc0nqinuJ9qP9jRhlnIdQrFWr1w7ijhc8PvIq/7TWx02FGp6FR30HqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365301; c=relaxed/simple;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro84F+A6JIUVvIdVjARQsWgs+s0fzKp/DyFtWz1ahi10iBIRcB4RokkurZJCipKRFlOTCfQl15X2en81nmb2Gnr88kRyLTH4/CINVUmgnhVZ3ryEQ+q9hV1UDA0Mr2fAyszXvb892RQm8vXK5vV56WsW7Kar24vEtOOj3eSrI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ur86l8qH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ur86l8qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498E0C2BCB5;
	Tue, 28 Apr 2026 08:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365300;
	bh=ED63hkK8etbxautcxx1u5AO9FSZT6ssFdgXiGIlo5Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ur86l8qHsHNK/DsGAq+jbCQjcJQbpchNoy0cCg4If3r2vIi6XG2QODPglvVCfby8Y
	 FvtRBT5whNcm+bTJ0HZxIC6orB9MjuEv2lb4uTaqYjVhGEWs8NYQKO/VaAYY4cK586
	 JBzciAtfyNrhQ2XD9vzAe9ezw+p4Dz9n9wmQKvOchqG7x4j+MrLockxQWBLlKiIeeH
	 Qtnkpz/MHG44v0qLmehZDRvwQ4j9Ugtge+Cwyc5Q0p0+24mNPgsGWIMCValX9hVTi2
	 PHcuJpIv37fuA4k3S3UqDfewFJrSqRqoDLHa2mgrdxGK/+2JPK5Y2eUpa+zCAVbGa5
	 iWIK5zjNRl6rQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 22/22] xfs: enable ro-compat fs-verity flag
Date: Tue, 28 Apr 2026 10:33:28 +0200
Message-ID: <20260428083332.768693-23-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: add spaces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4dff29659e40..0ce46c234b9c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,8 +378,9 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.51.2

