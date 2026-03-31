Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A44657CD;
	Tue, 31 Mar 2026 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992551; cv=none; b=UOVOtCpBjmyS/Hmi6fX7OST5FI+cvA5y+ktMnwvjtadQMZ4SiWmk/IjnrIT+GmjmhGmm1nJ7MMuF0bASmNPb7HM/gNvbhmSOfRKccepnOomJC476u4RRGGib5LL+1KqERlI0If1t1DizzBRuPHfsWxiJpX6XbBnr/drNh2IByGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992551; c=relaxed/simple;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vm4jAvn51xtL5jFopVzcbZ/EeTg8WDzuxw23Bub/tCduZdeOtC9+cbeqMWb9sTdTKSOgvU7eTIrfUSBtruXCm3Q1SKSB1OxMlFVI7rf5iIo15+xbr23oMsdq7NPs4v3mOfQeWhrfj9ux/eAc0MYRL7122+/a9TIbAuUxabY7BIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVBoqJks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVBoqJks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D9BC2BC9E;
	Tue, 31 Mar 2026 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992551;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVBoqJkshjGFgttNf9VtoNPjgn7uqVxzmiMf5GEfU8FdSLogM0d21/0lK9I4z+eHJ
	 S68Ceej719UIZ9mvMvfZSIl6QCKNv+wRe7IRkg84+sEPCLTmOiYk7fAieVp73It/W7
	 Bs0DBWiKtLbJyCsMGa5uk+aN1KHs8G/NeYG5n3GVJIUQ5mhnRixQJ1qNv6TfJ16oD4
	 Dp0HBkoXe3+mthJAElhZIraCipj4uGHFo1fBCyJcH8CkN73M4hxNHsQsQLXBVDXa31
	 Oq0OJoS6ih5/w6V0XjQx2O53djq7MqapQn3blLXaiKi7wPoRhQ6fiLBh8+AuMltKBy
	 2D70IGft3QjuQ==
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
Subject: [PATCH v6 12/22] xfs: disable direct read path for fs-verity files
Date: Tue, 31 Mar 2026 23:28:13 +0200
Message-ID: <20260331212827.2631020-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a980ac5196a8..6fa9835f9531 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -282,7 +282,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -333,6 +334,14 @@ xfs_file_read_iter(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	/*
+	 * In case fs-verity is enabled, we also fallback to the buffered read
+	 * from the direct read path. Therefore, IOCB_DIRECT is set and need to
+	 * be cleared (see generic_file_read_iter())
+	 */
+	if (fsverity_active(inode))
+		iocb->ki_flags &= ~IOCB_DIRECT;
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
-- 
2.51.2

