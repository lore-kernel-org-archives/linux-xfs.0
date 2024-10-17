Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF720CCE9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190912; cv=none; b=mkauOShUq9IpsJ8Mnt1gbsMn5bohC0FATu4w/usYLoEDwJjrHJas6TaAWhHVfbEjaRCn0xFozkXfcYC6d1Fkwm9cK8KGLXcOTix9GhjwNG3jcfzOmrQv07OV3tzp7bg4583JSsb0VT55npKcpg7SQ+WuBjMryGTx2A3QxuaayX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190912; c=relaxed/simple;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqEx7aamAcRZmc0XjCzFws8Dljzjb1nEHqzJGxQH+18OUqF8r9Rlaq94Es3oIRhdq1I7QZl7W81SZ7v4bknscVj1Ked42ebdJ0jYbUbJ5RmY6eswbX0pGuiPfVtUf5miyBKhDxZlFDCo3JtOOSFsOyEgZclm6Sg3r3iH4JD8fu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEiUBxpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEiUBxpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ED6C4CEC3;
	Thu, 17 Oct 2024 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190911;
	bh=3+caWbk4l0nsPF7ulopl76K4vcv9Q3PyTkjW0O0UfRw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mEiUBxpUmVskX2kK6qKduROkfuAuCZIsQXSw5JpeVSXDRaYQeK8kYlO6hqaSpCG1y
	 pbXqA06eL1rSTFhBYYrP4dqFzxCDJArX6R3DgSeE6D9/N67bgkCudizqDtjyo5o+bw
	 N6x/s6CUQQWpsd1zOrOsUumDBlrqY5VjpBsegpmZ40skOZsU2t5IyRNHyGptznO48H
	 ecpxQX3ILoJ1UKW6snmSRzBw9riXmcL2cYf20qmzA7gmVrob7P1BowL9IH4GtADAmj
	 C5t9WEW19KbgBQWRZxioe9j4nSW2z4DEnKMxK5IxbiLgK6nxcCffFiKOG6bzrwLgGX
	 Md8AjKqnBAuoQ==
Date: Thu, 17 Oct 2024 11:48:31 -0700
Subject: [PATCH 04/22] xfs: pass a pag to xfs_difree_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067925.3449971.15587129301933111680.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
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

