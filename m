Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C48128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423627; cv=none; b=taGSxp3VXJRYeddH8ZqOXfj1cv7md6L5cNXeir/iYHQcWGFzxCXpbl2oUfAHG7fGEd30I+2tY3Z2ia6ufB9A08662TKSofjHxDnZ9HEiNYFSftJwdnttQJMHjFqkJaxoJr1jIKiJGD92D/UrjwGDjp2EbkMhZff1lT4uzoVOmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423627; c=relaxed/simple;
	bh=YYvaUc1afoBJ5+ZQ8ViiNhLFYQpm9bX9K9ROP0XVHDU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nBM2qRNf7DRc2/uZ70Cs6+VcN1TjnvRyRjqOYSj3DR5NcTI7Vqlr3d2fFU9yMSghzjvZAPXKk8aXYLrj0DMGl/bOtqw4/ZbwsevdwaxMcY8EgkxN767noa7Vm1SRn12nlhmyzH/zvnC5iZ2VhWbtIt8bmYPq80xevPwbNEcdla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGLA+y1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGLA+y1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C730DC433F1;
	Tue, 26 Mar 2024 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423626;
	bh=YYvaUc1afoBJ5+ZQ8ViiNhLFYQpm9bX9K9ROP0XVHDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UGLA+y1+VCIVg5LX3GZmt5VajxR5KvF1aO47BG7i+1ljexH/tO8WMiLVau1y9Y8H7
	 IZfJaKsb7PQcrXvkbqYA3LfydjxDqdK6OT+gZbecB2qMNr5BbfAtpJBqjm7DOT2ANz
	 /W8D/eRuHSJB6W12L3UGQQ3KzEvIOEwbsy5bnuxgWT9eB+Ig43hfrC0ghzTTBCoB1Z
	 Gn/qG5HjSn48ejLCq3CCReIw97y82O4eNHvKxDZrYuZPju/UaNz6oQD5j/7k/vPPe1
	 XiLwkwwLYG8Jt2qknz+jj5zfvKMFQTpF2azbdX4HP6UGHLCGmH5xS4VYFswaBXwbBD
	 ECwJhC3qXIQwA==
Date: Mon, 25 Mar 2024 20:27:06 -0700
Subject: [PATCH 6/8] xfs_repair: constrain attr fork extent count
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130441.2214793.17223190507849932925.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
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

Don't let the attr fork extent count exceed the maximum possible value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index b8f5bf4e550e..bf93a5790877 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2050,6 +2050,7 @@ process_inode_attr_fork(
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
 	struct blkmap		*ablkmap = NULL;
+	xfs_extnum_t		max_nex;
 	int			repair = 0;
 	int			err;
 	int			try_rebuild = -1; /* don't know yet */
@@ -2071,6 +2072,11 @@ process_inode_attr_fork(
 	}
 
 	*anextents = xfs_dfork_attr_extents(dino);
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dino),
+			XFS_ATTR_FORK);
+	if (*anextents > max_nex)
+		*anextents = 1;
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 

