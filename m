Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC8213C68E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441928; cv=none; b=HUVBbOX+BVkdRX3EyMIIfItYo6xIWCDh0ge2py2qc+rUQOcVyqGGj2VPRY0xPuV0zH9Erz8Zn7Z6LqMFgyerxBWN+HfE4JQ9qyVMPf0tO76CzR1KgeRwyXrSTlRqMJZy/xlg1qEC8R0fZs2PezzppWqstRlyJf4CtUWMhoO474s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441928; c=relaxed/simple;
	bh=TtTN8gVLcCL5BKZSSRm176AWn7+nwY8QmwiD3b2rHXc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGqrAuvkNnaq4h2f09yvU2EA+kBhZnYcEpfG1U+L1RHXwiCwiBJ/VjOPPwMiv3djcFaBw1Wwuo+r5j1J4F3nzhJKXS4XSwI6C6zkm26+Ot4zo4Bun1hb0slkw3ouiWWVEDOM3K96ryeYiZpDEsO/iOyEq2H9yHT2T3a5EuGDtuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9lyAouz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9lyAouz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29149C2BD10;
	Mon,  3 Jun 2024 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441928;
	bh=TtTN8gVLcCL5BKZSSRm176AWn7+nwY8QmwiD3b2rHXc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q9lyAouzkJRcO24Q5lX5dbbXEVS38Ykvnd+bE1/1Y91C1SoKSAQvXLmBXIeGj6rn4
	 JGS2uI1E+hj3P7++mg/VI0yrbtZq+TKEcB/xB1YW+3egQgmNSEV67xAlUdmvM/7ZtN
	 BJSVmLgJ3AI//FcGQx/OxQyM1AwJXqkHlCBuwPFpMM8CWgBG05sM0NDCvWZWrqo4pa
	 iHyr7q+N4w8qDorzBbRPXWhKIt1liLi+m6M6XXq4PJyJWuSsNEDfvWJWX+N2LE1yw1
	 WCU8fj7eRGZW2rV+PkuiZwpdGVYIkM5yEUakEMUkxl8pjRBwjUZS4Wysi+wo3WesjD
	 4RGfVNctEsGcA==
Date: Mon, 03 Jun 2024 12:12:07 -0700
Subject: [PATCH 077/111] xfs: open code xfs_btree_check_lptr in
 xfs_bmap_btree_to_extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040528.1443973.4272321276655621061.stgit@frogsfrogsfrogs>
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

Source kernel commit: fb0793f206701a68f8588a09bf32f7cf44878ea3

xfs_bmap_btree_to_extents always passes a level of 1 to
xfs_btree_check_lptr, thus making the level check redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2d332989b..86643f4c3 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -562,7 +562,7 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1))) {
+	if (XFS_IS_CORRUPT(cur->bc_mp, !xfs_verify_fsbno(mp, cbno))) {
 		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}

