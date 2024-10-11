Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF71F1372
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607171; cv=none; b=jXR5AbsurrSSTzG9vdL+tS3Gy7bIkz5TZtNPwtmKsEDYMTfVcOdfX+vwytWxMU/T2ohCMxNOrxpAjStGukMd2uU5yloHtWYD14u88Bi3FnDZyuSPsHASSyFJ+6wcr911FzWYoGsETeWigUg4z8ulMsKGmSG3YkBM93/iZRXUrII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607171; c=relaxed/simple;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMjSGY33Ssm3KP5b5g5qpyv3zUqVd3Q/UZc64kXKCpQFY6/RFHMfXjPOhlgrV3UpFXb9AXG1P/eBGqtUdb8D6Nlrf1szvT7Zb9slGm/9BlxXxCBCqomIdYiwAFuTfcyJo+838eKjkDPmmgcUvZTLztvvhiurgM3meZUOGgq6CQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj+2e00d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj+2e00d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B9CC4CEC5;
	Fri, 11 Oct 2024 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607170;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bj+2e00dMEsWmqoZhVsgyZaUP9EeeCwitUIHI/LMmf3Jes5lEGcc97Miv63CH1dky
	 onbqWqUkwH8evlcDZOq7WknM2MNQRmvM3C6qonnfP/Xl7mp5Eb/lgn5KnqV3p0zLvE
	 L9wJ45f42wH20WokxBJsbFq0yuysGjCdAzJ0infDG57QWQIa85UJDfdchUXpe26rLu
	 JwWVHaBwtBMEVTToh/mFLXzcJMdRXG1QfaGqM1tz1PdvEXmDbb7pmUoMkdFjemUMF0
	 QCvxYXrWn2WweVPBwgtAAIzoinIRncXKwWovGpRvNXOZtrw9yAvZ62cnzTyCN04HaW
	 YmApJnD7vtnLw==
Date: Thu, 10 Oct 2024 17:39:30 -0700
Subject: [PATCH 07/25] xfs: pass a pag to xfs_difree_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640528.4175438.13938970864021699946.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
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

