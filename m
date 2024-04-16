Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F901C10
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229318; cv=none; b=dNDS7i4CybK5LT8BCrOh20N9u2vSJaVhdh/xVSuC9gZKHhckpW29U/jfQVot6o2GHVMfFyJ3C173nEpHydI6Jstt9fMUCcTeC4KE1S+aThrfzOsmJLWALHuCLYAwikK3ro+/9+zQc8MfRZw9/yZ02rzbyKZfRJmIOvaI1af/0Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229318; c=relaxed/simple;
	bh=UEljtf9sIK7el4HmgNludF4tt3Ia9Xw2RVigQ9TeNPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRr04mI20zQ/gKBO64nYofqJZuGtrjpiEo4M4UKyQV1GuG67+xwRtF9Z9QmXxxI2HV46jhprFrevn2ZADsYhsXnkOnu02eRoE++txc8IOl9FqJl8oedEFC90zk/2Sdf643AmJbTyDGu3/GnUm2IQL66H+yzeV9f4WJvUPakXmw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkLzbP04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkLzbP04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF171C113CC;
	Tue, 16 Apr 2024 01:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229317;
	bh=UEljtf9sIK7el4HmgNludF4tt3Ia9Xw2RVigQ9TeNPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UkLzbP04fdpDkjfXMt8rQN+7HE1EqlI8Lc3Q4MIcd6YpE25tqUxkfhNbsc15qwrIk
	 SX7++IsX9Z4Tl1zb1pmZjHB3x2FxNtvzKUydSO3Hb6h6GW0Ld7W11jrQhEoMmKvZBm
	 7dUyb1qIqWXDPofBl/p/XoCBK1FU8FaFhqpdYGgL8JOhjR5dLHtr651BCTEMSa22iO
	 epAjdpS1nb22jnbltgwC6h8JytWWSxWso3SFofJJuLpmrxMBcBdHx3gm+XUUZaupKz
	 jIUtHW3No1BRBG3FM8b2pYa3VVTpPVYY9mx+C/StcYg0hy2DdR9k0y1w1x9MIpsYE9
	 cCbW3QPxdSUHg==
Date: Mon, 15 Apr 2024 18:01:57 -0700
Subject: [PATCH 3/4] libxfs: reuse xfs_bmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884137.214718.16353340802853919533.stgit@frogsfrogsfrogs>
In-Reply-To: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
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

Reuse xfs_bmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d19322a0b255..36811c7fece1 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -522,6 +522,17 @@ xfs_bmap_update_put_group(
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bi = bi_entry(item);
+
+	xfs_bmap_update_put_group(bi);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -539,8 +550,7 @@ xfs_bmap_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
+	xfs_bmap_update_cancel_item(item);
 	return error;
 }
 
@@ -551,17 +561,6 @@ xfs_bmap_update_abort_intent(
 {
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_bmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_bmap_intent		*bi = bi_entry(item);
-
-	xfs_bmap_update_put_group(bi);
-	kmem_cache_free(xfs_bmap_intent_cache, bi);
-}
-
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.name		= "bmap",
 	.create_intent	= xfs_bmap_update_create_intent,

