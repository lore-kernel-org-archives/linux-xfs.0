Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13255259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441334; cv=none; b=kemN6AkgldqFo4Vkrt6CHio4NfyxjMs8AppVgFxfcZAjQFVxuepqlepXNKLbCkLOaGCo7fGaziYjIOdBqyEdJEUskA0DYQ7B4DAdBmOaghbmI1twPsqOwY2pETrOEtrZUEwW4JUuPb6Z/WMbwZ/X/4uCUOuurNeXhXhMNxf0kio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441334; c=relaxed/simple;
	bh=+GlWnCb+Nv09399QUt5Ha6Vz73iftcJPfPL3b0XObZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PiBJIgt0hsi+SYaL2uxxfAiPdp3/IdPpnSpkShyRTIaHjjyDD6y3fE2qArhxLDEU5sDpPAeOMH5mN/Vfz799GnjWldXjzAGeqwIPsviE56tU7gCblGzGVAuI09+NdJh8M29GEWgzFmDawn/yJC7CNTLWv6NbHa6/mzi1oBrOSCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFCXGDWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFCXGDWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06DDC2BD10;
	Mon,  3 Jun 2024 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441334;
	bh=+GlWnCb+Nv09399QUt5Ha6Vz73iftcJPfPL3b0XObZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WFCXGDWXVCrNeE/hrd2jgDn+Dy0w6w0oPoY9e1Gwd3OwjOAPjqXqeyajtlmNzBDvJ
	 /mMom/4uhu3+gzFcnvZQwS9X78Vd7hoSDT6ORBg9qnDeYLnyx82531q3DFy6LdEikG
	 aXdx6u9g3kMbYwRJKGyZ416hCmOtQ4XS1iPWNXqfq6TPZc0QL828GRZTn1ZJQ2Pta1
	 JK1oXMZMwKjCkob9plizOgBPeDOh4UzK9aLpWI2hgP+0aNGgL0TGuGsyLa0WqTAC9r
	 sz6IndKh5hfS0ML8PulRCuGsjGuJl/3nqHbRGo7MUzP9c7sOeStcAQk5j4j9qQx2dr
	 DtGhDY/o+15LQ==
Date: Mon, 03 Jun 2024 12:02:13 -0700
Subject: [PATCH 039/111] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039958.1443973.213812311787619621.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 7771f7030007e3faa6906864d01b504b590e1ca2

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 541f2336c..372a521c1 100644
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

