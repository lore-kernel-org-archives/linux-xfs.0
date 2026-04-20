Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F739EF06;
	Mon, 20 Apr 2026 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685694; cv=none; b=F2HCyVRXlAqTpnKXeDeag63w1mCx96ghgl78skLzpGvrEiZU4jVZu8N52bekbguNePMDo5iFDW1zCJ0l5mbGVvPETDbdO7RHxOJV0UAgGkmfoVO3fN3yv3XmH2cNx7C6ZIpL3OrqVMchpQP3YrpnXkbbupiMi1RkU/jCEG/wW0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685694; c=relaxed/simple;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5qGD0sIM1+Duv1bgcqghQ75qZamRJb2wOA60zGQwkD9Sql0dJp5O6Bswpi3qBNX/xgdW/SECqadGGvdUX2wuC6FJlIWZuZPWg7VN3H4gRqGntZ7goE6xVlSHsAal8mKJMU4+VuSEklyy2DicmzGMBf6+JbK2epqW9r8tfUNyUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbsiTSsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbsiTSsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC13C19425;
	Mon, 20 Apr 2026 11:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685693;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbsiTSsXmj626FnFRrw/igFrrEYPaX8L5UWJkEq/dlac3+x7BrEwPYORLk6mrcR49
	 9Ig8/DDh87c0hZ9mqeqxdHd23pYazUkbxfE5RiPVP2XpBBycAccCH1mX3zqi5LaND/
	 embWPtsbiuBNLI3EYaLrsK0g2bozSeS2p0LQzn509RzJNmTDY7uiqvA0Y21GiXSslt
	 uQJHg9buU6MT9m/k2/+b4elUUK+uNmGagHJGTYZiED0nhwxYMuz1X6U9a5dbKkDEwW
	 EV6AK4/xkP0BZhEQn6Dr56vz3QnsrSQ1gzXe2fWDHvR0jSOgXsFlZU58LWPeGYvtkr
	 eB9W0uT0J+yOg==
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
Subject: [PATCH v8 13/22] xfs: disable direct read path for fs-verity files
Date: Mon, 20 Apr 2026 13:47:00 +0200
Message-ID: <20260420114714.1621982-14-aalbersh@kernel.org>
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

