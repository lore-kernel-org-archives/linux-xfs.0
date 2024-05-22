Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54C2C9D
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347942; cv=none; b=QMkmOvua9bSp3yGo0YkzD8wJAkFV6so3DeQY6wNfYryEdmpLA14LoMNAy6DqKySCRAcPTXJG9p2IQ1VegjJ4XiqnE+PmGdXhGJMyXGI/g2jAbVm6o0aLw3Ey0XXlRaR+xHlhdziet1aA+ex6pU5IwkEX/risENntTLZdcHKoQnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347942; c=relaxed/simple;
	bh=fUHlFzk/xuDnvaOl0sFIAmoBoxWbA9G7lcmCcOTYKkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S09z1sZTQZr+UQuIQowJaNYwFB/7pyM9ZzSMWvvkXMGhOu/UoQ/9zCdAnIsoITXqM+w9s2aexuwwliAdNMbO0xmoz4Lx+1f35RlJA9IkmdORQWxvd+SMdEpDZCPzg6hA9y37g+bkzfcF1LLfjTInmmnNFThOP1JN/OPe2xgYjQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKat5zsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKat5zsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C62DC2BD11;
	Wed, 22 May 2024 03:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347942;
	bh=fUHlFzk/xuDnvaOl0sFIAmoBoxWbA9G7lcmCcOTYKkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CKat5zsca2S1QbWIAtd0/Z9G3R6/i/VnP9uOrFRKRIZhG5fgDxSPumtX743UlJn7V
	 CarbKoqRjVzolGQ2tR6Ygtbhh4YmPXT3FQYOJDxlADc7mL+4R9HnQsB99t1me158EK
	 /BMETZTDEOnDqGTSEJMnPQTxOgK9Alxov26AEEctmcGUo5lbTqv5wbgBo30xf8yu49
	 4EajK1861TggeJH/JzDl25nv/TBFWtX0t9bA2IECjiCoG+yzq5GCR15k4Ip60Y9Vfx
	 Wt/5xr5sg7cgYaWCeMO4G7SDS2+GkmNNeH1orA50YtgDZXMHYgynJGPghciB+rmwIr
	 DlLjYaFbH7osg==
Date: Tue, 21 May 2024 20:19:01 -0700
Subject: [PATCH 1/1] libxfs: add a realtime flag to the bmap update log redo
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534094.2482738.10686344833127378876.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534079.2482738.13797016573790493405.stgit@frogsfrogsfrogs>
References: <171634534079.2482738.13797016573790493405.stgit@frogsfrogsfrogs>
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

