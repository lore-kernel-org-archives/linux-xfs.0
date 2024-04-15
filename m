Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E839158A23
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224871; cv=none; b=sWHlzVArTYiohvAcu4NSDLvKKzn2PBUpq0ecUzFl7Kn6sVHycvcXY1bm4ZGX+dDxXiSQfYpxcaHfuuyEzCGglTXw1nsPXlwy0y2Lb5schkXV0eEXvuqk9+tWoELqtv6GzqfqQUGzzmUEe+HOHn0EgiCE/nl+bBT2OrzHDS1kVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224871; c=relaxed/simple;
	bh=c+tz8DDQwrl8P1TXiWp8qYqRWkVaQIKif3L13IbjlZU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtGIhat57MXx1vv7Fzq7NLh++YaGKiCiqWzcRcwoBOePpkwALt5akeRfLVbbakMls8Y1XyX8CR+MuDvCFydgdRIb7Ol903M4yn7CBkXD0sp7eKBS0CvuiU2UwSYfNMb94JesxUVDj2UYrTmNXsq3CJKmbZabpISjj+qIhhRjHXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ad9xgOsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ad9xgOsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B21C113CC;
	Mon, 15 Apr 2024 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224870;
	bh=c+tz8DDQwrl8P1TXiWp8qYqRWkVaQIKif3L13IbjlZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ad9xgOsqL2QBO3Dk/IDOCzEgtoVG7prajCiROTIq2AHSdXyPqpyzaICe038H9ns8V
	 Ibdv+bSWoH4HvSmVN9pDGLhb0lbP0mO1AnSLxhQdz6fA6XODfK3AkHbs3wg+StSFsJ
	 dh+QGfu7jgrGv4EEUYE3ZCCkQDaO3KiWHm3nATYOfz9Cn5qwBUpnvw6C70BH0NnGIR
	 HNXwk+ZuCyyQvGih6s8HUWHhsP2UoX81Ux+1OQz3UoGt0GGBiUCc3UCOh7WoNfj2pB
	 q1z2j52P94ZMzULtunlVPOOMmrpxd8COw6gndmh2LS4SQC9zhkjtkPX8BMV4uTnSzf
	 mnyWEIUyAyTBw==
Date: Mon, 15 Apr 2024 16:47:50 -0700
Subject: [PATCH 05/10] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382664.88250.2626474578859443989.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check the owner field of xattr remote value blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 024895cc7029..a8de9dc1e998 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -280,12 +280,12 @@ xfs_attr_rmtval_copyout(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	int			*offset,
 	int			*valuelen,
 	uint8_t			**dst)
 {
 	char			*src = bp->b_addr;
-	xfs_ino_t		ino = dp->i_ino;
 	xfs_daddr_t		bno = xfs_buf_daddr(bp);
 	int			len = BBTOB(bp->b_length);
 	int			blksize = mp->m_attr_geo->blksize;
@@ -299,11 +299,11 @@ xfs_attr_rmtval_copyout(
 		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_has_crc(mp)) {
-			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
+			if (xfs_attr3_rmt_hdr_ok(src, owner, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
-					bno, *offset, byte_cnt, ino);
+					bno, *offset, byte_cnt, owner);
 				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
@@ -427,8 +427,7 @@ xfs_attr_rmtval_get(
 				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
-							&offset, &valuelen,
-							&dst);
+					args->owner, &offset, &valuelen, &dst);
 			xfs_buf_relse(bp);
 			if (error)
 				return error;

