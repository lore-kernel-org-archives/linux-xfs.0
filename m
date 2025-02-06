Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4302417E2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882622; cv=none; b=Eg1uTx5LAixk1od4eXIgE3rUhQpwhVQy0vPStnlT2dUCyhV5GSBm0ah6HxMB3dcPHrKmllRYdJmsYerCSVOciZy7uY3GlIQpbbqW2XQiDBHQWvj+91188fJlJXceBM+jMwAZOKUCsY6CfqDMSJiQK7seWX2DAaoByJ8ANVnzH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882622; c=relaxed/simple;
	bh=t+x3oYrFcR51PS/fc62bLZuXP2esQ05If2Egij+4Z3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogRRPgIbfOfXvS7R69I3EIKuPd3bQznzAJgRwcXzcaT+ffSKNsLFfNY1Y5UzWPPpEi6E0YEm8/NKHoXdcF8uDBM7FEV1HcBkdOG5JixSdkkVI9YgJ7D6mcD+YH4rfqguRGErbZu0smWv6vwSVSg/XW9xcbcBgiscAAuAmZ69bTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlBqvdNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlBqvdNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8E0C4CEDF;
	Thu,  6 Feb 2025 22:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882622;
	bh=t+x3oYrFcR51PS/fc62bLZuXP2esQ05If2Egij+4Z3k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hlBqvdNO1Dysn/loQrelu8Xz6EqpECCI7ZxOGXZgoayBKmquGyebFa7/i7CGWA/Q1
	 XkBylKiSKk5BcMJ0jcYbGwGc3Xe3/K1yjdxSUybfuXzqcqnuGgJT4SpJau8cQtMk2P
	 gFsZGnrMZJBoNalcyFMDXaEyYnNkI9VOx6+3Namac4HTQg5YDIHWcZXYKbVYThIjGE
	 nsIpuScFDedm3tADoHfsyr0Qt2Pt7MqhGP+GxYOTtjYomuS2VaSwhuX0zcY3fIIHro
	 +cCe5RDHQec5thbyC9puFhLRmyVVGH4ZDRB5IDcRquer5RzkDZNOHvycgjZNgyQfMt
	 yKHRPV+M7x2Fg==
Date: Thu, 06 Feb 2025 14:57:01 -0800
Subject: [PATCH 01/22] libxfs: compute the rt refcount btree maxlevels during
 initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088950.2741962.6915597562604311279.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Compute max rt refcount btree height information when we set up libxfs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index f92805620c33f1..00bd46a6013e28 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -597,7 +597,8 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
+	mp->m_rtbtree_maxlevels = max(mp->m_rtrmap_maxlevels,
+				      mp->m_rtrefc_maxlevels);
 }
 
 /* Compute maximum possible height of all btrees. */
@@ -615,6 +616,7 @@ libxfs_compute_all_maxlevels(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);

