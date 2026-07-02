Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869C33CFF4C
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022393; cv=none; b=tI72qbyXl9HHxuEHlk15d7UquvsZ0dk5fxctSaNIBPtR8D5pyTVFxwCVvz8cCAkUuV+Ejza/nLuXxMdyQYtOIWBLOCtuFdbZb3EjOhmC46geZajLU7F4pWhuCAtX1P0fxsvHhBR0uBzbIglXiz5SxlOobmfzfy+2Z4gff4ZSJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022393; c=relaxed/simple;
	bh=Td9PuCrPd1oSCHsTu4cOxACmbS+wvuHs/0d2KaIAF7A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INE+ne0t6Tcc98WDLkGGRo7PDdc239F7eSeAWcE0Y4PHEBDiKEMG8NbTSAeMDWCcDNTmaDsoue31q27+JoPxZfm5HW2R1suwTsZJBX081JPBVC2y4D2REbWJ2nOtdMQposFc0ojWyurFdk7fMAL7KfUNaX06/pa/q68qFhbRPHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwPytqrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwPytqrO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A695B1F000E9;
	Thu,  2 Jul 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022390;
	bh=Yzd9ZZdOC6PwrIQEYiBJ0iTWhb8QAdqId4Vn/NzDrZ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CwPytqrOUL/6/RIXzt8yUPj958Vt0aGRoZakWzmUoI0unTdo8Dt4RhWN2O2i3Lq3E
	 Bjos3I3fBmcH1mD3XhEr5RndKvGZ+BQv4b+TSi/qjXtQhbFJcys/O1w5Mz7c5pPPyD
	 gQP7xAPsD4GDPVpElKTbWOMc+aiogTUVGm3VBfjdAKhh7IMydylsK/25m7QVQJdzyH
	 72K0gxgZbZAKP4nwAgevmHpv/M2N+H5eRtAByCx/Rh2e5z0uQowvCJ1T8xrGUCgbFK
	 NGz3yYxEZIL0J4y76LWHBHS2IJ3jpYCncUy4lRdL342JqShSpJCJJnCPiwe3x4NooS
	 Rzl6sj0tbUNuw==
Date: Thu, 02 Jul 2026 12:59:50 -0700
Subject: [PATCH 3/5] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: alexjlzheng@tencent.com, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178302225961.845293.2405986102744501792.stgit@frogsfrogsfrogs>
In-Reply-To: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
References: <178302225882.845293.16022494313921827307.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

Source kernel commit: bfb4dc533d0abaca07013dd71e6b5c6f182232b3

In xfs_refcount_finish_one(), there's no need to pass
XFS_ALLOC_FLAG_FREEING to xfs_alloc_read_agf().

So remove it.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_refcount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 036497dbb22b70..1d45160789f036 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1412,8 +1412,7 @@ xfs_refcount_finish_one(
 	if (rcur == NULL) {
 		struct xfs_perag	*pag = to_perag(ri->ri_group);
 
-		error = xfs_alloc_read_agf(pag, tp,
-				XFS_ALLOC_FLAG_FREEING, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
 		if (error)
 			return error;
 

