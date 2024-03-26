Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F421292E6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424316; cv=none; b=OEUlPXSLZb0HX1OciRm1qMiVdiUhebMXkoxhVpjmaRGD6LbweGDPj01uDTkdtrDq7F1SJrjzUzSNg5SdxMwBUpuG1Varec8o4WaZM7xnwM8qmpK4mNCUPYPRL6TE00Nb8Y8zTN27VUgOLCt3WXy6YhxUW/8FSVLaa4ieDVfI/xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424316; c=relaxed/simple;
	bh=8r0C1N9r3JjkTZQoRPz/IhGS52dbcFfybDI+uHTqGu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5Ob8xgRDX8yrI+TF/Mmztp8iEJoXajWu0y7UTYxSvX/iZjuiBbpqPR3S1WEteqh8D8t+wZo3OOuHCLSnd04ZanyG9dxGfysjWoSme21FxdZvGA1e1LGtRABQU8mCx0NXHJB5d2NBn1Ox8mP6TEdRu4WMHzyCZmKShfYxEpIBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpPa9Nx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpPa9Nx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B126EC433C7;
	Tue, 26 Mar 2024 03:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424315;
	bh=8r0C1N9r3JjkTZQoRPz/IhGS52dbcFfybDI+uHTqGu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NpPa9Nx3CpDej6xhraMCV2LtBaJuco7v01hUql30pM9Z2bxwyytIti6HUkCI+iUG1
	 QnbqJfwiCs2aigbmLD4omXSXo5/Pv4ACubWM2OzZE6oYmz4bPSZjL45eB4uauX+Lgv
	 DrSJMXVARY8o/hbciOHRsB4vJR2LsyI4Oin4DaqFMznjXIrzvkXxVMfAy8zEvIo1YQ
	 N8GWw3xBwbcx+xoB8eD91y8l58BCnEz5WRFUDuT3NvCl6HesQD9qjlA+6AooPHkm+W
	 rLVEmL19Gui2ZmLiOmUAVSwyku2MxmehwcBwzQ2vrBf29OpmUo2saOCXH/W7OxtM/k
	 47JCJmflI+YYw==
Date: Mon, 25 Mar 2024 20:38:35 -0700
Subject: [PATCH 039/110] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131947.2215168.3564500976799062116.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7771f7030007e3faa6906864d01b504b590e1ca2

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 541f2336c4d5..372a521c1af8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1225,8 +1225,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*

