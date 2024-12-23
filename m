Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E713FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991939; cv=none; b=FPlBsoHYRE9Hbh+eVz/7iiHR63MIoRbCEqPYGJ262pb/fQoXVGmp4qYwZSX96SgFnOO3PsiCQkaGmLC6J+k2JiE5McMwiHm5MB8oLmM8HMFJAHYph8QhZgziLzsKq1CFLj+PM8oUcBnrJVihkq+S2UzkU3I+DiFBAtrBQB76Sgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991939; c=relaxed/simple;
	bh=fS4tJ6fqtIkAj0b/gMkHxHOfnKkYBcTmQPFzmU7UrTY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DUVAj2KjdA1kMLpFbiJi37T6JWvcXj/OAiG85qffm5R/5/oTySXMXJQtWfv27XAwCqBEQS6d0FLqEqYm4Bykv15YKo800xSRQ3JOMkBAqjl3eFPOrmnJRouh8zErBMeE6vZtTjNJ/7dZkzlrgXfStUeQ47XEy8GXiLr7rBQFncY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aES+jmra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aES+jmra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB483C4CED3;
	Mon, 23 Dec 2024 22:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991938;
	bh=fS4tJ6fqtIkAj0b/gMkHxHOfnKkYBcTmQPFzmU7UrTY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aES+jmra0ohhT0eM7oI2+X+3ZIaqGUtwcfUenXynKvTvV/OgcKa8GZv/g4bHvdkHM
	 b+5qm52Jokk1XvvPDmFExCuSlxE/aWbmQryI4kfJ/RVQJXFPQrUA+cn5Nfe68KL1m2
	 2SiB95rAkYl/TVsKR5sdFa+olYBb78l88vsDsBZoHhiKZz7riUHj2JoAcEpcL0jyZu
	 cpnNE+APe6AH4oBm9pzl4F1n+XoUtxMo7jnWqZVWLD3VPV0OTttkGljEXTTWrStapo
	 i55lHI+sc/ENMmJbJ6x4jIkKN2L64KeVfsMq2TMgeSv44dl722BLQTPkX3p+kiH/JZ
	 ro8ww+fHez6FQ==
Date: Mon, 23 Dec 2024 14:12:17 -0800
Subject: [PATCH 02/51] libxfs: adjust xfs_fsb_to_db to handle segmented
 rtblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943834.2297565.8720957741513792049.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update this function to handle segmented xfs_rtblock_t, just like we did
for the kernel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index ed48e2045b484b..4a9dd254083a63 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -433,7 +433,7 @@ static xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
 	if (XFS_IS_REALTIME_INODE(ip))
-		 return XFS_FSB_TO_BB(ip->i_mount, fsb);
+		 return xfs_rtb_to_daddr(ip->i_mount, fsb);
 	return XFS_FSB_TO_DADDR(ip->i_mount, (fsb));
 }
 

