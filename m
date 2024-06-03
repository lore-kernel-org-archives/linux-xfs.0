Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9D323A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442539; cv=none; b=DjQ/v7P88PO9XaWdwLxLWBaWxoyQy5ZEWI00cqpkDqKG6/B1VcJzKIJfEMnCFbGsyGEAYr1Vi8b14FWhGbsz11gPY3A2U2BGz8tJTpWPIRz3qWE/UYncuptn+p/7QkfRBYXRakdV0KD42Arw+KSbtZqRCWkzfqxOnbfsF42ZsBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442539; c=relaxed/simple;
	bh=fUHlFzk/xuDnvaOl0sFIAmoBoxWbA9G7lcmCcOTYKkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4esrBGwii1K42DxN1X4/LiuoIDfVGtseZoUmw7uVgjipDK/JzXMtNKvzmi0ZHBMdLoP/+8p8Os+tGFI/BZX38HACshoZqmACNxenguj9Mye9VlaV667xV9Yl3zlFlQ6QAY9O9amFE4us2QUcE58/8CdWNzrGL7LDtcpzKx+VzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzBu44jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzBu44jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5DCC2BD10;
	Mon,  3 Jun 2024 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442539;
	bh=fUHlFzk/xuDnvaOl0sFIAmoBoxWbA9G7lcmCcOTYKkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VzBu44jpVia+gZAHzHLu+MO4gRYD4TAazL56jqvK8ahHBXl4yc6bkmSzaVqaIfgtZ
	 HL7ozkSDjE4MqK/4WPIAOAm6nsOfkhI3+t5QJIJa9a4w/naD9syrF0Qa0MMKI6v1JR
	 XeYAcQS6g1w3tr10cRmPXstAj/gfxgkP1Zea9Xm8wplInEWQkbIPbp/j2aS4zRaYwT
	 dSPAHFbihebp2Hgw5eKQWR84YGK2Z4XOMEzR5lCHJ00gZTC9d/9CgXTsFCnLQ/NjpT
	 5mvlwUaouggtT37P47S3rVBPhWjOIks74usakD+CwZOBxTI7oCGE4fDgDEVkvXSKT2
	 SUcNdYJ0GxRhA==
Date: Mon, 03 Jun 2024 12:22:18 -0700
Subject: [PATCH 1/1] libxfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041745.1449579.12589704341986854728.stgit@frogsfrogsfrogs>
In-Reply-To: <171744041730.1449579.11894722565578033409.stgit@frogsfrogsfrogs>
References: <171744041730.1449579.11894722565578033409.stgit@frogsfrogsfrogs>
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

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fdb922f08..21dd1d0f4 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -490,6 +490,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
 	/*
@@ -519,10 +522,13 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
-/* Cancel a deferred rmap update. */
+/* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)

