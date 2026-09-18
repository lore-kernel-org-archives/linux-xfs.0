Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1882B4E2F0E;
	Fri, 18 Sep 2026 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730205; cv=none; b=Q2IUsB1VPkM38AtZ9cfTg373hN3efm70rJjenpQ4nErNQ+ZRV5uxTarpy21IiY5zaCqYlrBhMRZv9LyCdd2Js66S967OD5siwVw7dycnJEC5NTa7d2w2o79IuMCe9wQyuRTJY1mYJDwcVH0/WE862pMQBnpQ7tZzAjtSA4SFABY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730205; c=relaxed/simple;
	bh=6LzeMOZgSqk7X0dZt1145qUHKcU9xc7K0sSDHPbXy5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPcfh+J9cxgFR58JyaKnNJ9kVULFKCeNuQdTdnY3Gz/jm6oKejRsViS3JN5z32l0lthj/1xj1LTZpG+hg6/RMvb3ya5ifKVYRb2eXieTUyXIU5n7ZE1EaKr69tZ49FsWVhQvFgiJ+LocKgr0Ln87/htGi1GYgrsAXqDeZdHGm8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKI6hYkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKI6hYkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827D01F00893;
	Fri, 18 Sep 2026 11:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730203;
	bh=lfg52zb8DlfflgPU8kvIwpmUoI7GKK53PRBf16ii4Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKI6hYkYwVhRj+nacZenOqaeyKlFxrRNlKib+x4xTHPnj6IDM9SnYRBCylb76yWyA
	 uDNr6BQPR75xrv3cwPqUhNvTwjs6Yl5rhwn+yEewl46epRLsuFLzB1mq20/kpZwMmS
	 +c2kz+yA9GOCkNGSJ+rn0DDKV9PA/qvBWpjJzhfRXx7qRS3ByqQiZJQbltKviOkB9G
	 6m/l2p/8MQL/14FJ+6RArTw7CNTOhMIaNUgykHuNY/nCpSp+tdvesKLCf+V0PiRSP2
	 vECTD1WWGIcduJBKv180U+cxwlhD9EIKeAUFeItZC7ZP4IdkBSWOt05OYXqSG2vjgv
	 h+XeNmLydZa2A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v16 16/21] xfs: initialize fs-verity on file open
Date: Fri, 18 Sep 2026 13:15:28 +0200
Message-ID: <20260918111539.1003439-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
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
index 578ca6fb8292..e13390539f04 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1794,11 +1794,18 @@ xfs_file_open(
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

