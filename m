Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F703C943F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164387; cv=none; b=GNXYelifdKTg9pCqWqm5mjtpapgM3HF+V4zAaiwpNHBPxKK1y5wpQ1XwXAexCYuixJeWXEI51kvZ8gap+3A0cXhK/7z+ZLSVtdztVzsePTNRw8/Qhrnp/4NbLLnpmtOTROmPbZEemvVZyUhnqgn1UvNxerwMTtlS4uDraiHcxIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164387; c=relaxed/simple;
	bh=k1wilBVXWoZdqi5+7mIHWaU8lsYpUYXRmedk5KkmBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxAIkfS6ie1TtoGEwL63bXCHKWveXikN1IF7HOTFi7R8XIdYpfmqzuI07Bjzqm3ZE5/awChr5ayqhme8+jwVmsqp6ecU9NtU/CTz/aDcldD6i7gWMEHTXkzQpjqVvphUmHtvCWXjSvb8ZxLG+XMhvvSfJclC4wNx0J1hmlZvYHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4Z1iI5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4Z1iI5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132F5C2BC87;
	Tue, 10 Mar 2026 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164387;
	bh=k1wilBVXWoZdqi5+7mIHWaU8lsYpUYXRmedk5KkmBEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Z1iI5inqlRvbYkSOB4z9MZcXePxHUOWtkpLC8xy9mnrHtASZouB+I0EXTuy9exv
	 BaYvXJ/A9sU2gY3/4wYLX1mmbIHph8zRm5FW1v2TcJSessRxDtPw9hvEM+UUiWsWrw
	 KmT7j7hRv8uxYFPq/SJLl/PxQYXGA7S4ityz+zi+BrIXKRRbEz2HeH4PqnCb6KANHi
	 pi4KZac60fM0ulM8ZYcHNVbn+/3AZTGVE9gHWFVmI+1yXwt2nGehReK8wqmUgS188V
	 QoE5eQQfmT8gzmr4kKnwnK2MULEzfyUcQrMvJYWGGLJPE6F8t0XHRixu0ZvtG1vNnL
	 HK4ym5O6rTvYQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH v2 1/4] xfs: factor out isize updates from xfs_dio_write_end_io
Date: Tue, 10 Mar 2026 18:36:46 +0100
Message-ID: <20260310173709.457047-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310173709.457047-1-cem@kernel.org>
References: <20260310173709.457047-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the only code needed for zoned inodes, so factor it out so
we can move zoned inodes ioend to its own callback.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
v2: Don't call xfs_setfilesize() unnecessarily

 fs/xfs/xfs_file.c | 60 +++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..fce6be55d90c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -560,6 +560,42 @@ xfs_zoned_write_space_reserve(
 			flags, ac);
 }
 
+/*
+ * We need to lock the test/set EOF update as we can be racing with
+ * other IO completions here to update the EOF. Failing to serialise
+ * here can result in EOF moving backwards and Bad Things Happen when
+ * that occurs.
+ *
+ * As IO completion only ever extends EOF, we can do an unlocked check
+ * here to avoid taking the spinlock. If we land within the current EOF,
+ * then we do not need to do an extending update at all, and we don't
+ * need to take the lock to check this. If we race with an update moving
+ * EOF, then we'll either still be beyond EOF and need to take the lock,
+ * or we'll be within EOF and we don't need to take it at all.
+ */
+static int
+xfs_dio_endio_set_isize(
+	struct inode		*inode,
+	loff_t			offset,
+	ssize_t			size)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+
+	if (offset + size <= i_size_read(inode))
+		return 0;
+
+	spin_lock(&ip->i_flags_lock);
+	if (offset + size <= i_size_read(inode)) {
+		spin_unlock(&ip->i_flags_lock);
+		return 0;
+	}
+
+	i_size_write(inode, offset + size);
+	spin_unlock(&ip->i_flags_lock);
+
+	return xfs_setfilesize(ip, offset, size);
+}
+
 static int
 xfs_dio_write_end_io(
 	struct kiocb		*iocb,
@@ -623,30 +659,8 @@ xfs_dio_write_end_io(
 	 * with the on-disk inode size being outside the in-core inode size. We
 	 * have no other method of updating EOF for AIO, so always do it here
 	 * if necessary.
-	 *
-	 * We need to lock the test/set EOF update as we can be racing with
-	 * other IO completions here to update the EOF. Failing to serialise
-	 * here can result in EOF moving backwards and Bad Things Happen when
-	 * that occurs.
-	 *
-	 * As IO completion only ever extends EOF, we can do an unlocked check
-	 * here to avoid taking the spinlock. If we land within the current EOF,
-	 * then we do not need to do an extending update at all, and we don't
-	 * need to take the lock to check this. If we race with an update moving
-	 * EOF, then we'll either still be beyond EOF and need to take the lock,
-	 * or we'll be within EOF and we don't need to take it at all.
 	 */
-	if (offset + size <= i_size_read(inode))
-		goto out;
-
-	spin_lock(&ip->i_flags_lock);
-	if (offset + size > i_size_read(inode)) {
-		i_size_write(inode, offset + size);
-		spin_unlock(&ip->i_flags_lock);
-		error = xfs_setfilesize(ip, offset, size);
-	} else {
-		spin_unlock(&ip->i_flags_lock);
-	}
+	error = xfs_dio_endio_set_isize(inode, offset, size);
 
 out:
 	memalloc_nofs_restore(nofs_flag);
-- 
2.53.0

