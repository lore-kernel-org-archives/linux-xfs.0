Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4912339C007;
	Mon, 20 Apr 2026 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685688; cv=none; b=nEJMSgVZuLTTpKgp5PNvYGwj7QNainspN/kUWsDjAWB9iV7N4SHza81XDldB3mEWKw5s6ag1WW3GXr4YnJC+amkEnwWKB7+gyX4aygDWAOG+pOcNg4vkNbPk8aStveC+uxFyjq5GU4H+rKS/F3pDZ28lyKMKniY5gHLh0JsaC6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685688; c=relaxed/simple;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTxO+sK9TxhSeIMnV0JKsMSdkeXvVbcj7RzVD2qUpa/fs1/5t6pssfud27F1VgdYzkYEHMTXjT1I0TcqgTO8gshFwar1K2oNDN1N9rhNLWpRyqxIQJQVmR4nDi+dzudOgqmNfSn5QSMoj+RtnWuYlEBGNXUIWNy3w9cM1AtnxdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFLn+OSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFLn+OSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B53C19425;
	Mon, 20 Apr 2026 11:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685688;
	bh=gjzi4j4Cju/ktgfw/m2kII6LXPtWjZKRFOLxEgok6kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFLn+OSOIDs8tGf70Gkq2tuS/U75caGKS3Zd7LfOx+VAmeiPR3UbqdueecGEMVx3V
	 4Jx0GaUi2UYh4ct5WARGKAx/VsYPTbS+hbyvUSToR7MsCRPHn3Zz/QJiWCOfaZ+Y++
	 cwR4nD1b3Iiv3aRIIkPTssgYPkjze5JXwfHvpfmuIAgs7cpdfnuNWqDI09UOzs+Nv/
	 OdgNhTuNLDPuPRY+fXUxHMzFbkQ6xoWr4RhsCwomkdZ/kB+TYjFox33JLjf/IJB0S/
	 QfoTo+3EKvZS+b8geQehaPVUGcj4WNDwvgZ/MkcrCHNXd6kMAsmanmwAzgn3RsswSM
	 lB8qPJjBioLBQ==
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
Subject: [PATCH v8 11/22] xfs: initialize fs-verity on file open
Date: Mon, 20 Apr 2026 13:46:58 +0200
Message-ID: <20260420114714.1621982-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
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
 fs/xfs/xfs_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..a980ac5196a8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include <linux/fadvise.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1640,11 +1641,18 @@ xfs_file_open(
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
2.51.2

