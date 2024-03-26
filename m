Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E83128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424942; cv=none; b=qVDGWEGgH6ldMiVV5aHgzXl91Rx7GM6fihkHIDcd0hAsNbm9HfSBagrGCW7CZEd3a6+VXq7kVkzMB++GOsyVXL2vAd8avFqLS6SiBC8E5DlKp0Odb242H3qrcrR5afsOBeaIAg/nGxImXCMip4uQfx0BnHWfifHiG0sRVEzAr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424942; c=relaxed/simple;
	bh=R4A35X0x+0lYoYtFZhlDEB4pCRbFU18gop066FMJdPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Auqh8jdJ3Dl4T4my8nXS8IkYcLzRxZHS9KbdJMjcFsMeRVTFvCva9+KjJQzQvD2stLTdRlu3zOqGWN5tE5LUzkk436Y6jtjt1S2TweOvPyXaQCLp7ZuG3qeKbI51DxmauhmAxY7lOPHtmvywx6kHWY1iImgPsEX2OqjDwMyTtwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azHMkejp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azHMkejp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9502AC433F1;
	Tue, 26 Mar 2024 03:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424942;
	bh=R4A35X0x+0lYoYtFZhlDEB4pCRbFU18gop066FMJdPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=azHMkejpk2f3Pl7kJu3gxeEJFjyIKzDKuoM7XfVzc0cu/epFX+Xe7advryVmlF900
	 SPjZpLUXJYHMxqCO0EA0iOcbT579rCSEBvkyPsgKkxZFwxE7CDKgaUakYJCbqeHHBl
	 uKxLYW8k7HpLryE36IAzcM1iA4QPPdM0IvKL/lpF3ZZKZYZ/pbCG2pYE+T0agriXT8
	 1mrH+43ul8ExCPuQu3G+qiP6bQNYcINw77cCvH8440aG8LTEf1XV+ng2Tqm11sJver
	 SDzUWgGlJGdZbpwYqAvTAsudfiXf05r+TRNgk9HCi+cQjnkJDrCzLz5OaXBrHgdn6W
	 KukcJwVkejQ2A==
Date: Mon, 25 Mar 2024 20:49:02 -0700
Subject: [PATCH 079/110] xfs: misc cleanups for __xfs_btree_check_sblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132518.2215168.12683051580570281477.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 43be09192ce1f3cf9c3d2073e822a1d0a42fe5b2

Remove the local crc variable that is only used once and remove the bp
NULL checking as it can't ever be NULL for short form blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4fb167f57f8a..359125a21b18 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -170,15 +170,13 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
-	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agblock_t		agbno;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (block->bb_u.s.bb_blkno !=
-		    cpu_to_be64(bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL))
+		if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 			return __this_address;
 	}
 
@@ -190,9 +188,7 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)

