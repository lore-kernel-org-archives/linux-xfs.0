Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF6A33D5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300952; cv=none; b=AWkezCKYNLz9DeygN0B8jyOG75QDkXH56z3hPJgfBm8qlrbWzYNuwWJHJrr4n43TmJFC0bAPaTIpydN9hjbd6jABg3P3RMYI2MTrDbKzhqdfsB3DNZgIAsSrSBQTzujIgy+guEzCukkfX93+/8c954VJ4RPPB75lBfXE/pnEFE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300952; c=relaxed/simple;
	bh=GnAymvVKFVTj+0fzQyxe5pr8dmrMsCvFnOtVoCqCxko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpuDGZJ2KI/cJQXpy/fYmbz/hd/8itFPDdnZlfak7FZFtWLTPHeAa5xGX0SbjdHzo0cIdZWhTmtbhvdAA1OfsXLDpOMkLO6EAGZ3OAqs4pb2AvJuWxJ1jY8upE980MCFLv51IFUxJEnX+xEBymVF3DMTB1lwF9jFdovh8oSphBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/H3eLpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/H3eLpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1741DC32786;
	Tue, 30 Jul 2024 00:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300952;
	bh=GnAymvVKFVTj+0fzQyxe5pr8dmrMsCvFnOtVoCqCxko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f/H3eLpukOHFd1ljUleccKIVYzMYoJSLXmFQlxe0RPlCqQ2Zb7Rxb8p65q9JHpwxJ
	 iE0qp0a2m2wixULIc7LLQxx0RioG3ocfk6Z2+De2FaHqiFixBif79L6UifMafcxNMm
	 SlSUV2yVCgZL+szIyhoWPs4Yi2HZ8GXGRZzvnUcH2wFfmVOYOsUVmKRA3ab8qg3p7d
	 i/pcMT/NtHLlKTc7KwnNBha49VJ0+5qF8CikCy5bBqgwsVlhl/TFFRvIW2O8beBI0m
	 hITFuFxB2/+ejOi/w4+PrjkHRkkD5ZSrZKudhhEJ6qXfAU/J5GBSnDRcaNAc99p47h
	 2VMeC5uxGbt+g==
Date: Mon, 29 Jul 2024 17:55:51 -0700
Subject: [PATCH 08/12] xfs_fsr: skip the xattr/forkoff levering with the newer
 swapext implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844508.1344699.3886872839098101255.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

The newer swapext implementations in the kernel run at a high enough
level (above the bmap layer) that it's no longer required to manipulate
bs_forkoff by creating garbage xattrs to get the extent tree that we
want.  If we detect the newer algorithms, skip this error prone step.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fsr/xfs_fsr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index c6dbfb22a..22e134adf 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -999,6 +999,20 @@ fsr_setup_attr_fork(
 	if (!(bstatp->bs_xflags & FS_XFLAG_HASATTR))
 		return 0;
 
+	/*
+	 * If the filesystem has the ability to perform atomic file mapping
+	 * exchanges, the file extent swap implementation uses a higher level
+	 * algorithm that calls into the bmap code instead of playing games
+	 * with swapping the extent forks.
+	 *
+	 * This new functionality does not require specific values of
+	 * bs_forkoff, unlike the old fork swap code.  Leave the extended
+	 * attributes alone if we know we're not using the old fork swap
+	 * strategy.  This eliminates a major source of runtime errors in fsr.
+	 */
+	if (fsgeom.flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE)
+		return 0;
+
 	/*
 	 * use the old method if we have attr1 or the kernel does not yet
 	 * support passing the fork offset in the bulkstat data.

