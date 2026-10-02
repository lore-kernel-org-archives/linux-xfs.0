Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5B3C4555;
	Fri,  2 Oct 2026 22:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980690; cv=none; b=pQd/4ibCgpPNheAZu1UXCLwToil7EwU+b4viXg0la5SHhUmjmvcxkGuM8BEzX2CoabqPa4XrzUQDUfJHtIef0RDz1LqKjlkCmk89j/NzWquw0UOq/3roy2pF8Rtt737HOuUu8YWmxCgGKA75i5J9aJmK7jaO7KsIdy228OnYWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980690; c=relaxed/simple;
	bh=6LzeMOZgSqk7X0dZt1145qUHKcU9xc7K0sSDHPbXy5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPDcI3VdIBJypnqb+T3Ltbm2axcu2sy5ZSaO8ADMbTU7JA/FQBpMhufLtsuoMZ7KWgIrr+ciOqO4q845KN7X5kx6oRX+iaBwOAU3p7RGXcbJJKRSatkbyN4z5JiWHIgVV9hdl9uvInVMUT5UpzULQ3pKTc6KXps3oSqmNZa3dO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8XOx/n/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8XOx/n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C901F000FF;
	Fri,  2 Oct 2026 22:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980689;
	bh=lfg52zb8DlfflgPU8kvIwpmUoI7GKK53PRBf16ii4Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8XOx/n/zCvUR4MwqSio1FINgu934XZOccwlfOyOhVAxRLgQ2vItJcIlkOM+3BhlH
	 5cMn/LN449BTuqYy+ZFVk63Aa5XkHARzLCXN7PJVvF2QPk1Bl17mrUHzK8OwKwOAne
	 fyMNDoY3lsGKxA2bK/5dM6mOniQFf7XjN6OWqsqPPsScCfgy8NI6dKsR6l/Ft7xrHE
	 l8BQXizyQP0rXmsLpW2SBSbLQZl2hZ5ivsD7wplYvvqTkUPpoKHA1sDcwRge3rR9ao
	 d+Wuu75p4uYjWP/mGd7tzX9RfyFxOGl4w/fB630wkabWKeVqQLSS+sdySXuozauvTQ
	 AVW/srWyw/8vA==
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
Subject: [PATCH v17 16/21] xfs: initialize fs-verity on file open
Date: Sat,  3 Oct 2026 00:36:57 +0200
Message-ID: <20261002223705.2175542-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
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

