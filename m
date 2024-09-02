Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DACD19CC1A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301638; cv=none; b=gx/MZTnfedBGKQk6DDQh1YD0T6DZjym5RfRNFuElFdV8umtAKC1bXXYFm3SHxKlIAwzd0LVvEJy/6nVci/q91GQRDRz/NINvv7quuWH38iyL9wrOugWkZFALqHibpeu9eU079O/8KpwhKneA5wAj/+QO/y9ezBwMceLpppMNyjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301638; c=relaxed/simple;
	bh=Xq2CVfXq5/jH5OWoyy+QoB4g7ZrcptOrUS/7WMrWFMk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQK7UwkA72eIaYQ5jhwdldDRsm1L7AKsvPj2E/isoROAItpKjeqMi9C2llUoDbtugkEn1UVMx0UtxogSJ+M0qOZ5hpaR7WcWnmu3+B//V7vBu1icMwO0rxXNWoiIlspw2661PjW0BPULU+gMh/GLAltz7wY/uCfDL5Z2YjN3t2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWEoYQe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWEoYQe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD4C4CEC2;
	Mon,  2 Sep 2024 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301638;
	bh=Xq2CVfXq5/jH5OWoyy+QoB4g7ZrcptOrUS/7WMrWFMk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JWEoYQe45okZqm9NSSADBUyTBtt9ZxxZE8YwTQ/xo8IDVeTZQ9SfJsginFN3DYSdj
	 NEj4KiJEQUm+nYDkVmB9fF5plHtAkS/MJmHlQ0q8FnGhhHsFsW+HsR34L/9qZvVWbF
	 27jyH0LmDb2p/s1Xfrq5efXR7MLdSig/Gdweek5ldP+okZDC1l7KBIv3VDt67/38sa
	 c+sYavk7adTPFuDaJb9roxTMWr757NudSFutNojl6KDRazLl4auLcvz/qZi+IThvUt
	 /5d1leB60iPSZocmk6xmfB5rvakEj0QEjSxYgzXT4yNHAfXF5pK9r/yPFiHHJok8H7
	 sU4A7zCxVTm5w==
Date: Mon, 02 Sep 2024 11:27:17 -0700
Subject: [PATCH 01/10] xfs: use the recalculated transaction reservation in
 xfs_growfs_rt_bmblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106275.3325667.10445292103387033909.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
References: <172530106239.3325667.7882117478756551258.stgit@frogsfrogsfrogs>
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

After going great length to calculate the transaction reservation for
the new geometry, we should also use it to allocate the transaction it
was calculated for.

Fixes: 578bd4ce7100 ("xfs: recompute growfsrtfree transaction reservation while growing rt volume")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d290749b0304..a9f08d96f1fe 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -730,10 +730,12 @@ xfs_growfs_rt_bmblock(
 		xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
 			nmp->m_sb.sb_rbmblocks));
 
-	/* recompute growfsrt reservation from new rsumsize */
+	/*
+	 * Recompute the growfsrt reservation from the new rsumsize, so that the
+	 * transaction below use the new, potentially larger value.
+	 * */
 	xfs_trans_resv_calc(nmp, &nmp->m_resv);
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtfree, 0, 0, 0,
+	error = xfs_trans_alloc(mp, &M_RES(nmp)->tr_growrtfree, 0, 0, 0,
 			&args.tp);
 	if (error)
 		goto out_free;

