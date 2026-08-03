Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA913ACEF4;
	Mon,  3 Aug 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787797; cv=none; b=H3keFP6Cr+Pmr/BYuJVWYv5hrTwiOMU9NrS3LgZBz7gw8MWWlHxunbv34k0OIVy7DNiLsiJbyVW2MReUWTSuwZQJcUIpesY/pCV6/q+lQvjfTtu5C5NTWzycJu8OnucNKpZF3NJDX1CVisprNQZVAxy1Fz1xCevm7zDe07VTmOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787797; c=relaxed/simple;
	bh=p/zGoSXQIAIdXercph786/GQF/D6VGH2v66YHhoN7bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMrQLBXilG5Bk7+gRfzVXp4VsHCHV1PRVflArwV3mIYPdOdXHuOfHGBY9yso0T1uz8BTgXPtx9RuIjsZE8IXJHMU8+9fsTvBol3VmX2lakV57lDaQhNSOc4P9L0wcieSpYGNDQF4lIpjVSvi02PCIF1RhMIfl++WSXyK4+lKhW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jErhP0kO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jErhP0kO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADB21F00A3A;
	Mon,  3 Aug 2026 20:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787796;
	bh=XYiFsFX7rZIZ+NM4yzl+CfRY3gAtOLbmDgiEslfJgig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jErhP0kO6bvJI4W38MBU2AlfusQheOOyZpkpn7x/VNh+9XXI7aPqDiLKwu5cOSd37
	 RiBuekaOKE5TtPTb1evjzdf00NElJKuzVgAQE1Uk+ZLrgUtE03pRPLK416dCrFFO3A
	 60LEm7uE9YjM8eyG5XLn5+vRuvXW79VitFWv/ki4Yy9pGET3PUwEVCOc68gBBuQrk4
	 PnC6HlxeEhu91N9rq2705JLQHdoftzqhnRzHTya5NIuEnvV9Df9GwG/39Qm278TkVz
	 QkfyjX1rbIEk4nPQHoPSxJAvGyGPuZKTqsM9GbUckN04wK3WfQBet53n1t+xkPc2zB
	 JcO6x1cv5lCAg==
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
	djwong@kernel.org
Subject: [PATCH v14 16/21] xfs: initialize fs-verity on file open
Date: Mon,  3 Aug 2026 22:08:06 +0200
Message-ID: <20260803200820.393203-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 43b8fd5a25c5..34160eeb29bf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1719,11 +1719,18 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
-- 
2.54.0

