Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C647B1FF7AF
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844467; cv=none; b=mfNJyrRXd2U5T1znno09TEIqDKPPYKFKML9MbagATSP1lC0RMgHeMP75+eP9a9viNG8lsWT4NmE4J31IuHFBO7ffVkET8VypnCZqjJL/9hHiu+AdxmhMNYiXNKLKTvtzNrTK1vHK5DgJvS7rtj5G7trnC24ak2EItEm/FpfAprU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844467; c=relaxed/simple;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhhdNx5bMim6G061aBA7Q/+79yeQGQiXPPqGxQvjsi4Fuy7dRpTMfPUu6Dydah5dFgABFv6OQzf52P0Ws3nfd5PxGABqlYpIt24lHv/d6M2J4huYAOXmaFkm8cJ9+jJOw0HVcj5XjE9ZjU6fYG5Dmts/Gn5NagZFsReFcGFfLtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W481JPVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W481JPVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6CDC4CECF;
	Tue,  5 Nov 2024 22:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844467;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W481JPVWT7xU2vJ/OReVp5vEP5R8OgiKfG8GVueoZTyLmYLc9iwejGh4mae1jpgju
	 kKocXk/WGYzugVUSY8uM28mi1fcRk8+TTeohqK/dRzipojBA3m2Z6X/zAAAuZY33Bx
	 PAixbSAk7YaM9w/TDaHxI2l2FCEWl3URPFVavVwfZxy6BFLQV9Lgk5k2Bz16ZtV9qq
	 JuspUo67nCAcEO/Dc6YCQtiKaJtMSe7MzjsmCFUIumicOWikoGPhUWlgtteUZ8Q73c
	 iVy6nf4vE/aNg8WPVqFQpX4T5PFx2GOzVAN+LAQYXThSMwKn3/cLku5tLc6+C0aPLx
	 NKGhmgfPG/x9A==
Date: Tue, 05 Nov 2024 14:07:47 -0800
Subject: [PATCH 05/23] xfs: pass a pag to xfs_difree_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394534.1868694.12940830946489525522.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

We'll want to use more than just the agno field in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 271855227514cb..a58a66a77155c6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1974,10 +1974,11 @@ xfs_dialloc(
 static int
 xfs_difree_inode_chunk(
 	struct xfs_trans		*tp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	struct xfs_inobt_rec_incore	*rec)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			sagbno = XFS_AGINO_TO_AGBNO(mp,
 							rec->ir_startino);
 	int				startidx, endidx;
@@ -2148,7 +2149,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		error = xfs_difree_inode_chunk(tp, pag, &rec);
 		if (error)
 			goto error0;
 	} else {

