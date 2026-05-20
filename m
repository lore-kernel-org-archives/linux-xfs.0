Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308363E1D19;
	Wed, 20 May 2026 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280681; cv=none; b=FwwfMFw/ItAXxqDRlaQ5uo6sXmYMYPjeraPI1/2+SG5ozwbg4FOuVMqyO0IKh0sDod6WF/saD2v4WuQ7YccjxejJKblJP47GBempeXvtrSx1oUhg25O7ogDVeoFYjQFWxg76wGShQgJWTRQei4x9ZlF5edYhdj7xWA56vnnxnh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280681; c=relaxed/simple;
	bh=hznJ9z3moGo3PQExhNYjGzN6OfHHvMeRYu21TBhj7yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXX4vV4BKEvL4hLtir6QCueYDkVmITLiORHo07ChRziFuS+BxQZr0th+Qpfsh5/OOvE+neoznvRi+UP7htzWzluQtToSQAeg/IrK5oVcv674EljyK75TINIj4SeZ/JySGfijpxLwHnaVVr4v6NzL8NiMLHuS/FtSgJIZ2qUitvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRKXai55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRKXai55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D634E1F00893;
	Wed, 20 May 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280677;
	bh=1DHHkbgWsldiFzDBohMOCibrE/jcCaw8Lz0td95bxyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRKXai55KPHdXoSF1SgA7EMzJPc1BMAysLhGwQrlta1BIkj+sNr0V/T7d8AHLsrOS
	 bd1v9iOaxht824zX6/RpRumfLOXEWsWGhF5Zq9unP9PYgQ/J8AFrACzTsjsHcAT+9U
	 vJz/s/N07ayoVpXlNL5B74+euEWv2XVNwU/kzV6ZX9ziPpevXA63WhOPYn+WctfBVV
	 hNixN3HydHu+UjAfzFshayfr6qyDhJwhaFeq4JxukRFp+aE/fZ6xL1a6Wp+I9k7Ppc
	 2EVa2Js2BHy7/ofpIiFUM4m/LFoi+mvYitEGGJRDqljR4jLsvLjylsEm9TJLb3bc4z
	 ANmdEb3mw8kvA==
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
Subject: [PATCH v10 12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Wed, 20 May 2026 14:37:10 +0200
Message-ID: <20260520123722.405752-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 25c6e1d08cdc..99ce8bc12840 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1370,6 +1370,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.51.2

