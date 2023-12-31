Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7186F9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3Yw/0JC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3B5C433C8;
	Sun, 31 Dec 2023 20:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054818;
	bh=0PUlb3sIN/3rPW+RtRNW4EkJMqh0sPN95Bm9VneLfqs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u3Yw/0JCmTOBvkGyCQbke6s3aKfMGjbxqulHKNnUjPbHG7+Au4zwFwd9GKnvPdKlM
	 ZwyQfGcMt2CjdHRpSGYCwMPsvCvObBpfTlJsyki/CqJIMF+qvqExblHzVOivRHQKuJ
	 L0aPuolt5txMAX/gecLddnB2GNLvBHruuqICkXimp47weSEf9FqyPgj8990S9aEeq+
	 zXTGXBZ53eBe8+zyTMOH9xuQollBL9QyW4xAiF7MKIaxe9TQ2Jg0sYYWbuG9i9XoBN
	 NAu+fY3E8tgHd1U1n8nP0g5/gRtS9knUOErum2J2hRSRQlYXe6matRfnbChp8IKHV+
	 nZHc9S3YEHH0w==
Date: Sun, 31 Dec 2023 12:33:37 -0800
Subject: [PATCH 4/9] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834765.1753044.15886029902068377056.stgit@frogsfrogsfrogs>
In-Reply-To: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
References: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b8cdd15c4e1af..3dd0b6b0956c0 100644
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

