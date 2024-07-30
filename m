Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660D965C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299293; cv=none; b=KFf7+8F0bL6vxHsIScxC5DolIHulWq/uUjhz63pq518OeBAtvKb0dbr+0dB6t2ZhEqBa/elbWGi5NfJc3hcdYPQXdt04yvzgKFky7Ae0U+7uNWSfC8gFUW63lonnD9w3eOgXfi0iPGRJP1kr/u4LBcoFr9uL35ZRXkxDT8On49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299293; c=relaxed/simple;
	bh=k2RH1NEQ85gI27BPhc2RwtKT74727sTVwp4vMsgbCrI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqRatnHFb8mKA5auS/87SPq98MNTovEq/TVzCPbs1fbOIItrwR/rg9W6P6S29OmM3wYAIKZQR7j22ZFroyybMoVpSfxbZwmHg+ysSFGsVySeZ43ihLtw6iqktk86kDIEMAkNksi9Q1/QRQrvrJkZvaPUwumK4tq5IhUYtZweCYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dw5ArKjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dw5ArKjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4896C32786;
	Tue, 30 Jul 2024 00:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299293;
	bh=k2RH1NEQ85gI27BPhc2RwtKT74727sTVwp4vMsgbCrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dw5ArKjcZ8LyXPAA7+7r7hVhha8e/Mws/CtkpbmV+DC2DjRzRk/H2Zi57IKkZCU8p
	 lEpNSZLnkP8nyog4c7G/Ld0T/DsT0yGMgixVq+/QvymOk4b/jwdyddlIN9UQyEaF9z
	 vorYNPz/GHLqGXpJxz8Vdp+IJu8SEHAHCWxmgzu5lTzENVrM+UWDij9b+CbrCIYkL4
	 Hym+ml1t2kjP/4cL/2rur2+q+cIjrEsm0lV1CX8HNQQlUoDoJjIzgBvOoXBc9HQr39
	 sixmp+Y7YAU6cfWPICk3206ukoPcWF7v9UTuYECrBSdky+0wMOTS03mMJrEwMC5h5f
	 1jk4TRbwhYe7A==
Date: Mon, 29 Jul 2024 17:28:12 -0700
Subject: [PATCH 017/115] xfs: validate attr remote value buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842681.1338752.6597168298216066484.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8c25dc728bd1ca9344001aa6ef4556885572baa4

Check the owner field of xattr remote value blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_remote.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 2787d3fa3..eb15b272b 100644
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

