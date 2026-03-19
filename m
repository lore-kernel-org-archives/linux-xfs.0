Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E0D3EF0BA;
	Thu, 19 Mar 2026 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939799; cv=none; b=WCg5lzZZBKcJ9G9uavDC5SSqxSUOVq/kR0lUXdNi96BdZIFni09ucqv8495Qdg9RGvSCsy8TjsKC32ARTtgdOGOfHfd4a7gr0UIoUS43s8mx2mSkXjaTHaJO34yO51DDuI1L24t9qW2XfJfLg/JUJAJTzMGIwojevVL/aZq0yuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939799; c=relaxed/simple;
	bh=lqiWxmPeHWhGkJFkjgaMjq3gNeSNuKAtoV63HQNkS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ei5SUkmIF/vV2tGUaRuw1OnTdt3Y6on5eIoDot8w3nRBBXDqN6ZjahuboT7LZOpRSHX4HPscMnr47ED+b3RCIB+gYP0lsoAdeGcxivfKWCNTRFlEQRg7bfZvjXh1TsOY0TBV0/LAtgZ93gQeF6/s16hJho4rkYAALgWEkJni8i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfrOAKBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfrOAKBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADEBC2BCAF;
	Thu, 19 Mar 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939799;
	bh=lqiWxmPeHWhGkJFkjgaMjq3gNeSNuKAtoV63HQNkS1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfrOAKBezktOAniN8UHvifkvT/PRsv4c24x2dGtYr+Fy3IOCEWj2FEArwvuUlrfjm
	 VpMo8AUdaimVjtJmzk5YWnqJm72huG0My2IOmCVo6G/Dyy4g88cyLIpaH1YEVEcTwR
	 ASrvznJW5XA8m+EymuxOYlufFj5TLJQ/6KDrbezXQkt8whxFUb3e9HKnvZAQ+pYfuu
	 nVdYv2IJrnEnF8A0T/2JemGcbPoHkcJXe9pVtrPVQL54q/Sdlz1aECqVwL4aY5bD8J
	 NAxiOwT7D209+lhmbDAVqfKaN4ObDXNErdoQr5uk+ji5MRoZTHqZ/QDVYuy9Gcw+6X
	 eL0t6BOjbD1gA==
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
Subject: [PATCH v5 15/25] xfs: disable direct read path for fs-verity files
Date: Thu, 19 Mar 2026 18:02:02 +0100
Message-ID: <20260319170231.1455553-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
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

