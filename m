Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3001991DB
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548327; cv=none; b=EWwNr/BFnQgmqPrncGa6tIh3B/vHiDqyAOAloGx6agXKfM6m4MTw7VOqEv5SMOE+zSRV5kRoxdwK/5gNE0Jcwj/2BicqVl623NfY8IXVRG+syeXyUEz35I6yWpKct8hwQogKvv1dJipb8RlM9Feo+VzdJgGMS52L2YNYNl+cr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548327; c=relaxed/simple;
	bh=AMqM1j5GaO/aiseja1ns/LzFZ/uFcNUULdpBuFYEq/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toIB7zMtmrfVZzST6qw7M2ZsAYr5e75OfUciafHIX5UHGHGoJIFyyTWLmR7e+yMmQRQFL5GNEFFzVC9NWuSOmEdgUWrLJluzeDYcaVHXIrqLTDtKpmNZhUzVwDU6ojt27OYIZZrmQrTWNG0j6V33qpieI1ile+im2q/054Av95E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNbVjQGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNbVjQGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C2C4CEC3;
	Mon, 21 Oct 2024 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548327;
	bh=AMqM1j5GaO/aiseja1ns/LzFZ/uFcNUULdpBuFYEq/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LNbVjQGwSsj6LdJE63mKVzuUTMfhPdruLDcXLGBrJmP/MxEp+zo3qCAIeiWkdI9lh
	 OgpTfzuPocWNwb+lljop/T3OsrwTS8CbBgj31aMVc1vyYbEXytMI7foJG0ImxzzzKr
	 HNoIf9djsIXUywZJlQRtzZxzZ5ug3caG5y1G9OzMndw6qtEa4eibnSTB9mmHISyISo
	 9dyEu68I8c/QWH97R/UxiujzGfBeo3W877M8sz2jCuiqmLWn9Ong9uwEDVacLK9mV5
	 6iOIUoi9h8h66Dd+C7RBBj7GfzRDXerQRKApHicg37PPgHsRnl617ZxpTI88EJQcBW
	 att73v1fIhTLg==
Date: Mon, 21 Oct 2024 15:05:27 -0700
Subject: [PATCH 25/37] xfs: use kfree_rcu_mightsleep to free the perag
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783849.34558.10330735119806284063.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4ef7c6d39dc72dae983b836c8b2b5de7128c0da3

Using the kfree_rcu_mightsleep is simpler and removes the need for a
rcu_head in the perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/kmem.h  |    5 +++++
 libxfs/xfs_ag.c |   12 +-----------
 libxfs/xfs_ag.h |    3 ---
 3 files changed, 6 insertions(+), 14 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 8739d824008e2a..16a7957f1acee3 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -71,6 +71,11 @@ static inline void kvfree(const void *ptr)
 	kfree(ptr);
 }
 
+static inline void kfree_rcu_mightsleep(const void *ptr)
+{
+	kfree(ptr);
+}
+
 __attribute__((format(printf,2,3)))
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ed9ac7f58d1aba..1b65ba983ad542 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -233,16 +233,6 @@ xfs_initialize_perag_data(
 	return error;
 }
 
-STATIC void
-__xfs_free_perag(
-	struct rcu_head	*head)
-{
-	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
-
-	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	kfree(pag);
-}
-
 /*
  * Free up the per-ag resources associated with the mount structure.
  */
@@ -268,7 +258,7 @@ xfs_free_perag(
 		xfs_perag_rele(pag);
 		XFS_IS_CORRUPT(pag->pag_mount,
 				atomic_read(&pag->pag_active_ref) != 0);
-		call_rcu(&pag->rcu_head, __xfs_free_perag);
+		kfree_rcu_mightsleep(pag);
 	}
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 35de09a2516c70..d62c266c0b44d5 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -63,9 +63,6 @@ struct xfs_perag {
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-
 	/* Precalculated geometry info */
 	xfs_agblock_t		block_count;
 	xfs_agblock_t		min_block;

