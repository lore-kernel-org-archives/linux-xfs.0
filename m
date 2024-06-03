Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5D135A46
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441975; cv=none; b=Vn1wctXUdDkJD/1URa1lWCFamU795KIjiCJFzV2olakZyRuri/wVr1G1UckddsCuaZCtgtt31AGsOJrfIvv9/fz1zWVlZtRHkd2HMu+SgrPLTc71UGDrDuyizk0DBF0FfpDpdJUP5Z3nt65l2N4Rcd0dyAcIhFdPOGxw4IfwnmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441975; c=relaxed/simple;
	bh=SAsleszdM6wquGyXnaFMGWX33mE245b7lepcj+Fffck=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ja0VkZxrlVd1w7HDy3v8RdSKiDgTufY/8IUcxWpvPmIxvRuJl/MFTaaFYV7m5vUgHNPfo/llM8wgLg+eoJNplcHyshbkSbn9wX8Oi7FHI+K6jXqHwdlvXv6EH1AyvzrNnN6cYJ2nBQHmdDmDhDSptSiL33Jiaz3WT6PP18H5xLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EP5qfQ3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EP5qfQ3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D34C2BD10;
	Mon,  3 Jun 2024 19:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441975;
	bh=SAsleszdM6wquGyXnaFMGWX33mE245b7lepcj+Fffck=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EP5qfQ3CwNEbrwoSupEUhLsadC8VeDAJer7Eqjg9G4MILjcDQG1e1irmM8GyT+8Xg
	 x6WGsp3/VaFjtakipQGA75GOgCSnMS9A/ozam7lcqas6uR0M65FGWECGyrEfEVRHeX
	 JWadBJI5EQY/q3RyH0rMhizHSwG3IQRSYF2ItOB2yjXaFO6beyY/8ZxgFGsFhkAA5e
	 iTE/Y1dZVOyGUJ/MC0aJnl7qcCV+fHiglofPfzkfKgkyDFXxfLeYnKnfG31DCDDdld
	 faoizwQ1ImYZ26DOkVxH7T25STN5cPDbQM9TLuak12ls7Z+RHjVYWmst8ru6OaqQZr
	 ffD/eflgA05jw==
Date: Mon, 03 Jun 2024 12:12:54 -0700
Subject: [PATCH 080/111] xfs: remove the crc variable in
 __xfs_btree_check_lblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040573.1443973.12298334156630577282.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

