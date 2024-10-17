Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9327E219C89
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190890; cv=none; b=d0F7WjaemCWP3oAXmSSKqAS5+hIc68WxOAPKJWWuZ8ZdEASS8ZcWkdCzxZQ5LK9kniqQq4aP8tYD5NExVc5/XHk2sJISS0LyoTu2o3dFnW64bYeNyJpU/86gUcAzeiq156pFgTeeGaJhDNj9WVQqOE6bAgOpHjldkRdUGaultg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190890; c=relaxed/simple;
	bh=Op8sWsLEsWygD8tX4YMG0vmZ4PYO3717zlTu6KKAKOc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9JM+hileQHKtUPeDmrVS2XYT+zxLZU5LtUhSu60QpBg1B/6nXeKOtbN9Gu3mjImkCHzj8mJowfKRVYe2IM23uC+t/A/FWQUTLdZqFkfKwPgpo8v6lJZo4bOtMz2WIIspOcEsYDKkgdDUGmegS/t1ffuaQTLuGfpq6RxT0PnS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxOmuKfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxOmuKfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B6BC4CED0;
	Thu, 17 Oct 2024 18:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190890;
	bh=Op8sWsLEsWygD8tX4YMG0vmZ4PYO3717zlTu6KKAKOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PxOmuKfOF8fpgN+S0M7tG7e+OeSn02orYWWVOqNYY8OUUZ3I63c4zoccf2lPO1XOH
	 KYS2p6q+c+iLLAdJsEzwQRW9HwhWCZKdr3eVxAPCG7Z3vb7NdKidqynvwEpkm132nR
	 fRCqjVSFG+O03jYAY6JwF7+u1GyKXz4/Qh7eXSgIwcqm18e1yo1DIt0+sFl1mjMpcI
	 7Rdwz8kHSSB1QBx9x4uAcDS4Yjr18nv1JMbaZvju+mEFdAvCisLB5USjmBmDVwZD4v
	 /RWyc44TEYHtOf6x/KiwezlCxaFU809bFBkwBv/+Giq1Cyfa9OuKv2srwnkYrpShwp
	 bswo/yEbtP3WA==
Date: Thu, 17 Oct 2024 11:48:09 -0700
Subject: [PATCH 02/22] xfs: remove the unused pagb_count field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067891.3449971.15213913302758383284.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    1 -
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a9b9b328649f50..6fb0b698504c81 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -331,7 +331,6 @@ xfs_initialize_perag(
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
 		init_waitqueue_head(&pag->pag_active_wq);
-		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4ae19379035462..c02d6cb8f2df7d 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -55,7 +55,6 @@ struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 
-	int		pagb_count;	/* pagb slots in use */
 	uint8_t		pagf_refcount_level; /* recount btree height */
 
 	/* Blocks reserved for all kinds of metadata. */

