Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E370B3B7B71;
	Thu,  9 Apr 2026 13:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740490; cv=none; b=Bv5QwdnsIHHXEJFaoQ9U57MC6bE5gDwE/XlzGDKliIWuzgd97F0GVIaGEQMH0T9NyPW8nwQEKqEFFek0+qaSQce6SMhXYWugiPC1HOImaEFIAudpqUX6YHGTYzet6DzqtrgtgwpfC+cVDQxbUHCdUwqJnCNQZxKWoKSK5nBJIK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740490; c=relaxed/simple;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j59p26ZTNi2Evpxhzcm2dmkzCthjJ+Z47FQv+r33PrKF4VerEG8d5/AGD/OX6/DhtUYIkud+CYmHeIxF8TD2vCbNd1zVvCEz09StYK86YEa/HDHzORFgav7+CbiE8MnxbwtikeFPiewHoK/PgfLJDUKMeL52cbPzdFO1T30yZ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJ4s8HyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJ4s8HyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3614C4CEF7;
	Thu,  9 Apr 2026 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740489;
	bh=l2TuE4Dq3W00QnGqh26ac7WtX/eqBCa3lcQ4ZM8TF1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ4s8HyYV75KHwcaqCCKhXiuuEKo2ecMsEbRxEAJoqzJJgLXUmg/C9rnLiaPMlj0T
	 X3ti136pw9u6p0BDwMdQJR++WswgCmum67Diyxknx6PbYLOkFgWE/AtbynCfKjh756
	 pL3vuuwTzNKRlcEsdb97WvRKU4OMv1AOmw+IPatWEDySXM92rlbYO8mGP79MX39uMC
	 bE6MyPcGqkUChr3/O30SA0nMgHBh2nuvs/MVWm300RdN0a44MED8JS5wKjObLmwH+m
	 tJ+XtEfLc6StJB9YSkYZhUGi33LQ0wzfK6QcSj7MZZUjziy9dQvS9VpwxDT3jtnaIn
	 IJMGeF1fVJnlA==
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
Subject: [PATCH v7 13/22] xfs: disable direct read path for fs-verity files
Date: Thu,  9 Apr 2026 15:13:45 +0200
Message-ID: <20260409131404.1545834-14-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

