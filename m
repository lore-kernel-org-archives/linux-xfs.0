Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5488E3F0777;
	Mon,  9 Mar 2026 19:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084300; cv=none; b=NWCfAXptBvyWl4eTLa4Wz9Nq1JPoZCpvUtA2r/P25Rd6SK4afo2T+RHdPuRry8lmw5lnZjwRI+0J+SL9ivbaKPLZkc3XMrDjqr49H+02EfnHAMsv3qzEo1dxvhetMl63QxzSkHMfBQaHH468Lj/BaW8WbG3WkNrGmzlS0tjo4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084300; c=relaxed/simple;
	bh=lqiWxmPeHWhGkJFkjgaMjq3gNeSNuKAtoV63HQNkS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPjoiioNTp1hflT3Fsgda6s565/9qfbtO6F8Jl/2mQ9mGsxqVA7dsJNZdSQ9/Up/ehIldtW/dLdlFuWmx4xDf3RToQUDdJDEWCe9CHWBbthgHXGZ+Mg8teOC+Mkms6z2GsW6NVFU976y06pX/Cdd1C3xXM3XP06uPhQsjJdMzzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaEIiXL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaEIiXL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D3FC2BC87;
	Mon,  9 Mar 2026 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084299;
	bh=lqiWxmPeHWhGkJFkjgaMjq3gNeSNuKAtoV63HQNkS1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaEIiXL0iRNBp2wvZkHX1eS06bA54MSZBrQOB60YoywBswMI2FHf9Eu5ElWQrL6NY
	 USQuqPL+ZpnXjwR8b0cNjoQtLXh671gt42X3qrbyz1HiktxS3jqYqgd1Iqxgzg4TB7
	 0CtEWwrVbRDHcdb2NQaXYerRsQDY3wtYHxLHdGfC2w42Ik2Bq7+VM/Dh4FwukM6ZFV
	 RxEAgfhdz2wJtn9OAapNgy/mgPI9D5WN1tSQmcIKOKJWHmCRI6hhqIErsiRpV/omJE
	 0T17WGo5gcfULJrf0sJydG2NN+ZnBHoTEvF668RVNY0ApKYI/abfi5xEiSW+HP2HEl
	 pjzlsdadVwO9Q==
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
Subject: [PATCH v4 15/25] xfs: disable direct read path for fs-verity files
Date: Mon,  9 Mar 2026 20:23:30 +0100
Message-ID: <20260309192355.176980-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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
[djwong: fix braces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

