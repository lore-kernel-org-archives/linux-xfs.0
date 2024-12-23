Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4DD18BBAC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991000; cv=none; b=JBXd/O7tgaLGNjqKJam+T+xr3hPYR23giIlvrXnwAVI6/lKI3yaTXtyFM63bif+5oC3QB2EjeXefMoiitscRGX6eIpR/K1YAjCr0lubIciTZLAEoL80WttIK/mXZQiUDzxcB9qIZBe6c46JX0kc8RXGQUiolrlhVSIZHcFaDH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991000; c=relaxed/simple;
	bh=Jy9I/ao4X/OfY0hJjjYxxU206rw9sl82DqSf45tabXw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kblby7fetN1OfUOaS1ltUSmFGXPqJUgp+bKXO2X9GPZr0xrcWu2u8+c1zl7oBVsKrDoGCpe7u6Wkpwb4j+7/ycmKQQlNmOFT9GBLttmwp8m0hfbxUMS+U8LISvZ8R1Ll8Agh9eb5NbFnwKxAwvnQJyw9Gvbrmy0+MuGjFCKMpHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2VIppOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2VIppOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D70C4CED3;
	Mon, 23 Dec 2024 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991000;
	bh=Jy9I/ao4X/OfY0hJjjYxxU206rw9sl82DqSf45tabXw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P2VIppOsJ5iY3j5tqsPOq2sCfj9CsdHF6M1fbN+R2W7e3GJIseYxeug9IGaeYoZLm
	 NjC9/v4dFS/jnMHEDgqLSWsRYH/5XTtPgrCdxpFA65qe5RWwyMieBvSHczvZr1wwft
	 RatvzGa/3Ex2Tg4BgSuVOP39SyBEP5SKtpDs8iIl4QnIm+kUjvypXbhT6jm6pzPMR8
	 yRbx8IG0qERtQscGjvf4Ai6C6Tc1ISkmOP+GIzdVqG13xQiTDgO9Fr37NssHm4inZG
	 hr/w/oVeIBFn/SGjVqrQc/kG17oRG/pdtEU/fvwE7KnBvV6ojWXpELY2CfR22EhSnU
	 Nd1qAxQJkOglg==
Date: Mon, 23 Dec 2024 13:56:39 -0800
Subject: [PATCH 39/41] xfs_repair: do not count metadata directory files when
 doing quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941566.2294268.6459977657374405160.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the offline quotacheck code in
xfs_repair and xfs_check to reflect this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/quotacheck.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index d9e08059927f80..11e2d64eb34791 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -217,6 +217,10 @@ quotacheck_adjust(
 		return;
 	}
 
+	/* Metadata directory files aren't counted in quota. */
+	if (xfs_is_metadir_inode(ip))
+		goto out_rele;
+
 	/* Count the file's blocks. */
 	if (XFS_IS_REALTIME_INODE(ip))
 		rtblks = qc_count_rtblocks(ip);
@@ -229,6 +233,7 @@ quotacheck_adjust(
 	if (proj_dquots)
 		qc_adjust(proj_dquots, ip->i_projid, blocks, rtblks);
 
+out_rele:
 	libxfs_irele(ip);
 }
 

