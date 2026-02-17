Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56225221FCF;
	Tue, 17 Feb 2026 23:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370472; cv=none; b=KRmVxCGSv4kgFVuI0XLUd1MbolsD9cyI/So32TMiW63OPnbK43qFax+I6HGG/jFiMmf6NUNb+WC7SfLQiLS1nCQS/fqV6goOz2fDhzmiLPnIxFtw7yZb95paqGy3yXMsdPZl97V16I8HcDINSIwR4IDjaMd23gHMPXzLHeE0Tao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370472; c=relaxed/simple;
	bh=qEvbcygzps7ISLi+6GenSLwSvV3vuE20wcyB15UW0yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXR+a0rE6/aLBEqb5Pd2kBb2DDIDyvqt/gfrvJpF1zh58y9UhIcdeokfqYUjhz6wrDZLgFzZ5MPKNUkrfYvhc+M1KzP5tStXXrDBMKktTJDUnNAjEDdhf7Ei2LgpY26kMC0y5r6WI8Qcs95dj1SMFF9zVx+UgR6q+dBy3220T18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sl48IwCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sl48IwCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C62EC4CEF7;
	Tue, 17 Feb 2026 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370471;
	bh=qEvbcygzps7ISLi+6GenSLwSvV3vuE20wcyB15UW0yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl48IwCEYr98K6ErydTxlFlrZU2ElcTqdtoFdRtnMzcbh9xMnQeSfWGt3CjSd0yUQ
	 rzFzy6pRTv71h/YwJ9r+LmA56+Mw+3Jt1LZEiyba5EFrPD+jn986wc8gN7Gntkztxr
	 2ZIt5ASEri0TXum+7S7z8EUCfP5E6u11motdsdcegqAttYswULT10alyaryoMXLDpR
	 KKnauv7Wg8odZdDn8aH+Z/9oncEyUmIJ2+J/Qn6/RSXr7XoBNvPmaIuuXP0+jgjwzM
	 pYAXMZ2PIUwcFaR5MOVvt84qflcOJMaD9NMDDBIyOZJwa9e+xSp1po8Jvh7N5+4/Vd
	 29k9oBhMQXeBg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 18/35] xfs: disable direct read path for fs-verity files
Date: Wed, 18 Feb 2026 00:19:18 +0100
Message-ID: <20260217231937.1183679-19-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix braces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 693d298ac388..78a65926de43 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -281,7 +281,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -332,6 +333,14 @@ xfs_file_read_iter(
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

