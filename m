Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048281373
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300467; cv=none; b=fVtR4m0BpVLI4Cg9MZdFMtDKpmtLZmpaxfSaFFntR0sEl1pTefhJqIq4HT7FkIDRl1/dId55dV6strQlTJoFQl5tn+FrMOD7U/9fre5xs54Z/ViE4W5/+6rU0dDxNcV20kssYcD+/RzPswG5CuAWl5m/6I+Aq9FpaN1ILg2+DUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300467; c=relaxed/simple;
	bh=BGoTx7vBBksmNCYEzPnqGAsR7e3h5jMVCkt8VOG0szY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RY0WxzpBzt7LIE/f34MvEvCZecPB76Cl/j4HEdgxdJ+yn1a1EtM3E8JPdc1m8FNuNnTM6VxvQ50rq1ExITO/onydf1Sj/hHLCqIZ7J/SSOmsczfLQDsW/tfme7V/JCafgLWH7qThQuDoLNVpFhyTAr7IKzIUqIxPCsrBM+RifYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGSsN7Zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGSsN7Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6979C32786;
	Tue, 30 Jul 2024 00:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300466;
	bh=BGoTx7vBBksmNCYEzPnqGAsR7e3h5jMVCkt8VOG0szY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NGSsN7Zsb8hq7RNxGbYlXqLjo8exDvOobUqT4ZpTXTCoPtayTSVBvnSWORkvZ3d9m
	 PKCxgucZgj6aHEF+p9B8B0iHYJVRn/kR1GiksUXkuIh+RLq1KiQsDu2Flcd/uNEyrB
	 io3sCSawzdOYJKfwevyiW08CcyGdFFAkPlgCXZCcjkl17j74+XQpcaCEKbiUw7HJMz
	 PokphTBHNQtbXRlx//ooVCdpzHyODyeWk+0c/iValdrSGGEi5/xAPHQrM8yEw3AYSd
	 6phz3JmIRdDlVGmW2ANTsyHeJgxCi+9hJIE/XgZdWkCA+y2VljhaEWtsf7rjKEDegc
	 H79Ai4lUfwKtg==
Date: Mon, 29 Jul 2024 17:47:46 -0700
Subject: [PATCH 092/115] xfs: make the seq argument to
 xfs_bmapi_convert_delalloc() optional
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229843758.1338752.17838555738859832583.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zhang Yi <yi.zhang@huawei.com>

Source kernel commit: fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index def73fd50..33d0764a0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4642,7 +4642,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4693,7 +4694,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);

