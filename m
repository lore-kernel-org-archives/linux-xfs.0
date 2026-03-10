Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCED4D90C2
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143764; cv=none; b=sbO3dTJuCM2jUwIVpx6KMzSv5PuOjJIq9X1q5TgapDmb177tumHbZZh3Ak2S3Kk+ql47l4otyG0rKE+fZU77Fy5TtiCTwWiy6fVIh5FqNHCtH2FI1Ukgd78QoPiNZkrLakrZ92eemtlSoIEpbJcrmWENTUDgSkhZZib49RE4kd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143764; c=relaxed/simple;
	bh=j9x6hHXee+E3oBJMoFk+pHaIgrmfuao5rqgw6eonJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHbO5mQ8FrI6WDXzWp597I+7Q0ITm2cE2ZcaGmtdveUFNSE78AX4jSrpq4ETkCqg4WiUDVURZTsed2GjuENBTIX91At4ib27ma5LHLSlyDqHgtwxmB6nvvHWmENkpI0qCGfrNQvN+BhFYXzQvz46SQbFA/WA8wXBlBzQnu5fzFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ux4FbmKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux4FbmKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B84CC19423;
	Tue, 10 Mar 2026 11:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773143763;
	bh=j9x6hHXee+E3oBJMoFk+pHaIgrmfuao5rqgw6eonJtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux4FbmKOIaQRPSe4HKTN+ofxtMUyZWFja/i692eAef7scBSo2cuB+pk1eytsm/Gj0
	 imHdV2S1jOnGtvzNtEugVp2ERmKZ0h/TBnoLhVhpzYsYdFyiH4sr/NaG3cWBDqeUUh
	 eCgXNUjYTXGCbAHgPaNOuhurW2cTV0Ucx9BG6EqnkjypOzf1fWZOatRuWruCImHB34
	 azHfjUxTRs+KgAOZMUtOVnigLO32AqI0TyMUgwCZb1lDJehRbNFXf1Gdxe6H7Lbeoq
	 NX+yD329nK7k7EdQ0DoUJYhEo/B8ZEuhoZ9st21s2Tbqkvi8e8kWwdiDofpxh8j/Rq
	 l3DSUDRzw+nww==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH 1/4] xfs: factor out isize updates from xfs_dio_write_end_io
Date: Tue, 10 Mar 2026 12:55:04 +0100
Message-ID: <20260310115555.114197-2-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310115555.114197-1-cem@kernel.org>
References: <20260310115555.114197-1-cem@kernel.org>
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
 fs/xfs/xfs_file.c | 59 +++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6246f34df9fd..45ecd743fa32 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -560,6 +560,41 @@ xfs_zoned_write_space_reserve(
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
+	if (offset + size > i_size_read(inode)) {
+		i_size_write(inode, offset + size);
+		spin_unlock(&ip->i_flags_lock);
+	} else {
+		spin_unlock(&ip->i_flags_lock);
+	}
+
+	return xfs_setfilesize(ip, offset, size);
+}
+
 static int
 xfs_dio_write_end_io(
 	struct kiocb		*iocb,
@@ -623,30 +658,8 @@ xfs_dio_write_end_io(
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

