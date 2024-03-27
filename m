Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927651CD2B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504793; cv=none; b=Ut8tcyQ2nR4Zi18Gj5e+gQ54MTK7uoWEPdv6MjsxImbXT8+MDd4lB2bHhqYFLjPdG37mdp7Lqk30KKWYR5f6YyAU4XoigxVWBo4gCGQlemZCHZKSsPgw0vn7fBWp0sL35kwA1fO1MHvdh4n/pgUrgesxkxR0D/bcexs2uRvBQ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504793; c=relaxed/simple;
	bh=9Qf/VA6oeW3vtsX97uNv1aNMXVvY8NtGsNTTITEv19o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJlHDIFzlmOj7c+svH/nTL0I78kHp3dGscYQiM0J6FHvIhsvow4RsgNVBgxRwhVj1XxtrtD0Y91mVlLffZ4Cck3mARm/+7BNP1ye0fWpogWxeS2mvCcG/bqJWJEDgRaCUPnPWiF3xvPNm1N2bV6IsTst/C9kzh9Fa/T2tHaAs+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSA85MFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSA85MFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34605C43390;
	Wed, 27 Mar 2024 01:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504793;
	bh=9Qf/VA6oeW3vtsX97uNv1aNMXVvY8NtGsNTTITEv19o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BSA85MFVbGw3chy+Rnu/wWTTKWDQBaaL78BYON4/Le2SAPPMpgjJ/iCGkXwnOjA2W
	 8I/RiYRDv+S3qwjjq3jE0z9BtEOpDWmR4v/vEzlyaFMbhrWWCPITjDugaGgntYfVuC
	 hRrEnZEykYU6qieI4f5bq5mvc3bHe3u0uFPgcFyhfU6uOn1ak2TPKZgrWo/oLBhP0v
	 ECrqYu3Lo20iNI+t1s3a0vEliiukVw1nvwH3C2R5FpJv/7V0VOUIztrSFmp20W/YuB
	 jJ2/dB1WitqbjbvMs0Mx71AtIzPCDuG9ktNPauy9f9oiqjVs8PVKprTZ0kP4tNXTw7
	 6W4kK0EM6xRVA==
Date: Tue, 26 Mar 2024 18:59:52 -0700
Subject: [PATCH 05/10] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382208.3217370.16416051796991323160.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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
index 024895cc70299..a8de9dc1e998a 100644
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

