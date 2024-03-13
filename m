Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A18FB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294908; cv=none; b=O7pKrGUkng+jiIIXnpSIN3TnjwavtsRvM18KdrkJ/EdusjTZrFyW8bUu/+vVZmv84dP0306Jt9nKehnPFAFdSuzAwgdbwO1faBRBvsL4berAcnNmMxdtDuCU5u1rQcjHrYTE8+d3/vphMthYhbDmIBjOVRsDLAkhDl8CuZyD4qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294908; c=relaxed/simple;
	bh=ULDR20Ykff54fhYfpobMhWNSMo6EvfXDGbCgyJRqnqM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2YiB9pSA/BAGcRTksG50H/Cb5VYEJbSSjMLuhRGOfLrk494jYpOnXqc7idai+/LXnnECav1/AHzU6OcWSNs5HndfhJxGQPNAEDadAnubXoeMcD/+y8xQRoCF0sgqZv5XSSDVwRpRHyLACU2hYB6bBSQ/tBk8bU9Wm9ZTJQZ8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np0Pnutw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np0Pnutw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CB1C433C7;
	Wed, 13 Mar 2024 01:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294908;
	bh=ULDR20Ykff54fhYfpobMhWNSMo6EvfXDGbCgyJRqnqM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=np0PnutwdtHnAq0nU6+Rj5sP/OgJBecPoOWf4Em2oMyEFtsz/JWNAKOsxqx1Wq+Xa
	 Jp1LpgU2q/Kd9RbMDdXtlxRxufsQxbvTsO3GgMwVYNERPcF4aNXDHsy9Nu6P7siBIO
	 Fkrof/gim28mOlYIra7U+T3ZUQz0NwZaZ6MBeHXF/T+cC4aSpw3cNli4h1JN0pYEIy
	 rPkOwZjoJZfJDrZyLptH0hNwoP/Lni4Od7XOgrv6YIa4ROWOGZqpwe0Ou70zQUTe3s
	 2Yfe4iovnkDeM2WREWZhnvqza8ANAogiosuyQVm49G3/bVeRM4bC4QO0CgWjKQOkGS
	 Axnk2FZwRIFPw==
Date: Tue, 12 Mar 2024 18:55:07 -0700
Subject: [PATCH 08/67] xfs: clean out XFS_LI_DIRTY setting boilerplate from
 ->iop_relog
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431309.2061787.2680477533721748462.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3e0958be2156d90ef908a1a547b4e27a3ec38da9

Hoist this dirty flag setting to the ->iop_relog callsite to reduce
boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 43117099cc4c..42e1c9c0c9a4 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -469,6 +469,8 @@ xfs_defer_relog(
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
+		struct xfs_log_item	*lip;
+
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -497,9 +499,12 @@ xfs_defer_relog(
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 
 		xfs_defer_create_done(*tpp, dfp);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
-				dfp->dfp_done, *tpp);
+		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
+				*tpp);
+		if (lip)
+			set_bit(XFS_LI_DIRTY, &lip->li_flags);
 		dfp->dfp_done = NULL;
+		dfp->dfp_intent = lip;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)

