Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C9BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NP/L3mOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F83C433C7;
	Sun, 31 Dec 2023 21:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058996;
	bh=nvkEROWOAt1XEONyaUDvEHViGmqII8MzjuM/BYrX0VA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NP/L3mOgp1aN2IlFefFas6JcurxEVnPc4CtpvsTYMuziauJWcGkg1Ptb6MSvIlWNp
	 /O8ebsiQ0DkwF2FAQued7YA0w/6VcIEO01sja3QwGYKLT9CULAqpO5Ik+b1ZL60+gq
	 LQCYHWcaCo5OTrR0Lok8vRC8F1jOLvdCBL7GCD4yFU1d/bO/wdzvPif7qHpg8bZ/SB
	 qljIh8xyNG6FR5UCBZNhmSA/AZ1eEptdSg1cMH+QvODb8FjhVreAKOB5n7wLbn7BKl
	 Ko1ctk+ASU7skKpYKlTqXgPJngspRVqKvS6W5f4eiXcteQvDX02Hh8kayIvAsNXgv5
	 8XaVw6SEMWiqQ==
Date: Sun, 31 Dec 2023 13:43:16 -0800
Subject: [PATCH 05/10] xfs: remove xfs_trans_set_refcount_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850975.1765989.1196238202463641347.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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

Remove this single-use helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index ff1fdb759a8d2..b5087efa2ef28 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -243,25 +243,6 @@ xfs_refcount_update_diff_items(
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
-/* Set the phys extent flags for this reverse mapping. */
-static void
-xfs_trans_set_refcount_flags(
-	struct xfs_phys_extent		*pmap,
-	enum xfs_refcount_intent_type	type)
-{
-	pmap->pe_flags = 0;
-	switch (type) {
-	case XFS_REFCOUNT_INCREASE:
-	case XFS_REFCOUNT_DECREASE:
-	case XFS_REFCOUNT_ALLOC_COW:
-	case XFS_REFCOUNT_FREE_COW:
-		pmap->pe_flags |= type;
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
 /* Log refcount updates in the intent item. */
 STATIC void
 xfs_refcount_update_log_item(
@@ -282,7 +263,18 @@ xfs_refcount_update_log_item(
 	pmap = &cuip->cui_format.cui_extents[next_extent];
 	pmap->pe_startblock = ri->ri_startblock;
 	pmap->pe_len = ri->ri_blockcount;
-	xfs_trans_set_refcount_flags(pmap, ri->ri_type);
+
+	pmap->pe_flags = 0;
+	switch (ri->ri_type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		pmap->pe_flags |= ri->ri_type;
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
 static struct xfs_log_item *

