Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754502417CE
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882388; cv=none; b=nvHTiqcZynzX0sbpFSjWehhASbneQrnab/s0psh1jxy3JvTbDJEe1zlTGKOcxLgP/ojCHysPRt9M6sFSX9Y3tQxgT72urx+Zmo5jSxpMyhAFfnNgc2ZvIZUSNPrzzCMEWM1pmB0f9Ge3dERFZVJ3XyfkMUO/JTN6hEpaTPvmq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882388; c=relaxed/simple;
	bh=YLyowX5C8VNPHcIV6TapJcMcqIrffdnvchR31XYEAno=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QHTXMk5s7cyGTZ/TkHew23D397l9OhLBy9kKPJWdKo/dpPj3L8hYZQCOIqWCU2w4CfNHs0zPZfvo+1h4wtChdBA2RPO30xFxAdfuLQ1buvHyO0Ys8qKI1kcOtHGNdlhg2dKJfFnBOF1p7IiloPz1rbKOuDwxbylpfSRcMkfPitU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/rHLR2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/rHLR2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC414C4CEDD;
	Thu,  6 Feb 2025 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882387;
	bh=YLyowX5C8VNPHcIV6TapJcMcqIrffdnvchR31XYEAno=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i/rHLR2uprrCYQcCK/yH6RJKv+Sj5H2V8BaWumecJQLFpvuqz7enM7pjVFskyqne7
	 DzDjOWGmEQsK48lWWAWyZyA4OmdChnMraYpufezi55Ol23Xu4oRIvKGtC8IxD73eAd
	 Eow3o8i8P15RB9LNnUuU/UlNzxCqBv0yJny5Zcv7C6vpp1RgjLP/+AOxlgsWEjgzyq
	 Dc6rFNL4xifAIujr4FcdX6oNrW9GkVn94vMIiJ01ZSIxpfQ5HtF7BS30rDHMBNdh5n
	 kM5y5lZGdWzEFp/s1puR3L6QXKWgWUdiBCg0L/+RYuFeSbAeKtblDnC4nM+CmwA6e2
	 cFad0Y22qMF8A==
Date: Thu, 06 Feb 2025 14:53:07 -0800
Subject: [PATCH 13/27] xfs_repair: tidy up rmap_diffkeys
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088295.2741033.4604651348658562209.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Tidy up the comparison code in this function to match the kernel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index bd91c721e20e4e..2065bdc0b190ba 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1267,7 +1267,6 @@ rmap_diffkeys(
 {
 	__u64			oa;
 	__u64			ob;
-	int64_t			d;
 	struct xfs_rmap_irec	tmp;
 
 	tmp = *kp1;
@@ -1277,9 +1276,10 @@ rmap_diffkeys(
 	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
 	ob = libxfs_rmap_irec_offset_pack(&tmp);
 
-	d = (int64_t)kp1->rm_startblock - kp2->rm_startblock;
-	if (d)
-		return d;
+	if (kp1->rm_startblock > kp2->rm_startblock)
+		return 1;
+	else if (kp2->rm_startblock > kp1->rm_startblock)
+		return -1;
 
 	if (kp1->rm_owner > kp2->rm_owner)
 		return 1;

