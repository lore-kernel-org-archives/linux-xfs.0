Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B91743147
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347379; cv=none; b=Mg199NGkgcM9qPjdgeNERdqqqG37CjvAOSiZsp39nZAtg58eWurG0hx64gkmpTbLcMQuN+yULvaiEuQAZAF3uVf6U1FQJyN1gRYKOBAjFanTV6/y2UrVWnyNUm8jpJdq8zCR29NYLUJCASdSbMSK+wduDl/MPbZ1VoV/xyLluxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347379; c=relaxed/simple;
	bh=KEscUk9/lk5nyjpX2rf0YcO/n0UGiwanmnXxv0ND43g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uii4xKfTKhzpjmdT0DMxQ2UDTqBw+z9KR3STGCOKB7wmKwDQrPsVEj1TqW4WoZpyn0pyi0VM2N2U92msUQERWnAGYmndmTWb7m/g0U08NEdfbT0E3SL+2d4dYPuz/+l0vULh+MAABcvNF8peISzer3Q9c6XtHAjYtbXHJzCRrsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geU/lxw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geU/lxw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94C9C2BD11;
	Wed, 22 May 2024 03:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347378;
	bh=KEscUk9/lk5nyjpX2rf0YcO/n0UGiwanmnXxv0ND43g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=geU/lxw42m12Eh+50qxs6hAysvWje1RPdhbqgNkvbseL8KJhmHb0v8JY51vkVnMVh
	 Xx4VjV7Pk0+THEhSLzegEma8/7UZG51D4pt4wF6q9ku5JJmI4KPD3Diy0qweko5Uwz
	 njfVsaiq7nPjZo9F0J4+6Mnm4FUOkq3ZMPbiucVxuuEN/Oy7sOLUmngwOt06iCjblM
	 uBUM96O2WQYe250SQrpJDwGyW2vU4FeSYlCWFsHvmGGo2/y3rc8NQJQhrUa46tY5f6
	 M0S2FN2buYusA4uf0nqKPQAxvdMVFOGgBsJRlruVHta8UMRUburZ1eP6E9Gd3JnEMa
	 KMmSry2C4wgfA==
Date: Tue, 21 May 2024 20:09:38 -0700
Subject: [PATCH 080/111] xfs: remove the crc variable in
 __xfs_btree_check_lblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532898.2478931.18340907909352564184.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: bd45019d9aa942d1c2457d96a7dbf2ad3051754b

crc is only used once, just use the xfs_has_crc check directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 359125a21..0b5002540 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -103,11 +103,10 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (block->bb_u.l.bb_blkno !=

