Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F87619ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527895; cv=none; b=Ung2uHWL9+54TVxF9Kv70Y1WAZfQKLDwT7hhp84ZNk8KD/dll+0ygYUGaO+WfzfRrRnfdgX7vPApoJtXHnAN0saHoKeyDiLlneoKmJXZofDpVweaRMWCz1vfgKR/+0lk4JaSThagkxl5OidxBmFFaNbbFx+rYsEfRA2GUQlmZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527895; c=relaxed/simple;
	bh=GfJ65CSgYgfbSRdIEUtWZHicj9onwQP8nkKgxveDk1k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qc/R/CeR5aMesoz/Ia2nt7FW9sKGkCAVUAn/dcFJpf5zAJEdzXkNmSTk2ryvNkS4UvYtiPsxdOYmOP5W5hqifSQnlr+DCdLctXxRwQRuOdn6dfF8QvOq5gOECM0LQgzt8JkBXuse0x4tfKk1EuxpfOt59uJrqag8g07P6DOgrmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+dJXkq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+dJXkq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFA8C4CED1;
	Fri,  6 Dec 2024 23:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527894;
	bh=GfJ65CSgYgfbSRdIEUtWZHicj9onwQP8nkKgxveDk1k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g+dJXkq1pkgEI4afRM/QSm75vandRLxUY6bvzilT6khI2ox8awEB/Cu5P1CuCLyTk
	 z3OXSgAWszWjX74arDCQSiBCToePi4KouTE71PrBHlqv5M6zQipB2gjcsFjx76Rod+
	 2KEF8yzGdbBEcGFoUfOmBPxgljmr3Zh0YYPF0E+tz7xTDF6+zTQyfx/yLckSTRYScN
	 /39ZoXwO0Nrdy54DlFAw73XCtV8TQl0sQdUqZVMsZiCzl0+cp8NFFLpd5cgF+2QN6K
	 bcRL/IIeBCfdQkHVoPMH+YYUaQ8RErodT5lNxla6fe8WluWPrKDPQhkU5fXN4f9l8/
	 HHQjANlhg6BvA==
Date: Fri, 06 Dec 2024 15:31:34 -0800
Subject: [PATCH 05/36] xfs: pass a pag to xfs_difree_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746958.121772.13626400528946092757.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 67ce5ba575354da1542e0579fb8c7a871cbf57b3

We'll want to use more than just the agno field in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 43af698fa90903..10d88eb0b5bc32 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1969,10 +1969,11 @@ xfs_dialloc(
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
@@ -2143,7 +2144,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		error = xfs_difree_inode_chunk(tp, pag, &rec);
 		if (error)
 			goto error0;
 	} else {

