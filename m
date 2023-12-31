Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB2C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIuRVpSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27426C433C8;
	Sun, 31 Dec 2023 22:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061999;
	bh=rhojsQ00PYyMx2awWG/I6XvSzJMnRGgWDzBcRff6T64=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VIuRVpSYHdR6V0k9PGSaP40JuNB65wIQ2YWXaMu5oKe6m84TDA0D5f8u49ett0/Pn
	 GGx315woH2gmaqt5RTMbbULHi/a69zfHiqV/IBdtv4WU8OA6pfvSx3miUu0rV2DPe7
	 VtLeJrCGX3sDmPW8wsTk80ahBj/pqMcsUXZHJkCjrOF32lSI1Ckf6HXnZY/jScxqN0
	 blFB3aercptfgCK73d6Y6jOfDGODGUlsWHiKeolkVaXXC0nBwK7Z4cWaPboaLE4+UF
	 4wevSGLwq5uALLyY55GeGi0ISpRJ9HfMgViRHSNEpYLeszjNS7Q4rccNFEdo4gA+dN
	 hs02R0+lfAK9Q==
Date: Sun, 31 Dec 2023 14:33:18 -0800
Subject: [PATCH 4/9] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996921.1796662.5388176482911414319.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
References: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index bc58dc6fa34..f4d71430df4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -279,12 +279,12 @@ xfs_attr_rmtval_copyout(
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
@@ -298,11 +298,11 @@ xfs_attr_rmtval_copyout(
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
@@ -426,8 +426,7 @@ xfs_attr_rmtval_get(
 				return error;
 
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
-							&offset, &valuelen,
-							&dst);
+					args->owner, &offset, &valuelen, &dst);
 			xfs_buf_relse(bp);
 			if (error)
 				return error;

