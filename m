Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E002CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548343; cv=none; b=ZVslshLF1JeDn75Q5lwVGQEk0+9TVnU+x8CYqleIcYBVxrnFu+KY3fGSTij8X3SxOdeJyghx1QHKSMf2ktodUrOCs7qYNS7rcA7RMWWleIkpbXdEJAX/oocA9GP7KJs5CCfw7u6P4652aTWK/bjyeQ01g7ae+3UI9JB+AU09mlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548343; c=relaxed/simple;
	bh=Qmn9OrxK4wzDuVTLItqmshC7ZRAaMO3p3BfMEhMTcD0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FDw7LGwHvpdHAInBZxtfiepKqiQx9EFUaiOrTk/D7/CbxmxpVedyOy3W72ke8z5ktKCeSAKyHljfc+frwD3ggtvW4DyeCSvoUG6mIqbWiQ5MitemFrS8+gAwtHMlzeAtQjsONdoaSiH2NfijS/RH50ZOiTqOUbVI/RX2VqTDd6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYDcY0x/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYDcY0x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BF1C4CEE4;
	Mon, 21 Oct 2024 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548343;
	bh=Qmn9OrxK4wzDuVTLItqmshC7ZRAaMO3p3BfMEhMTcD0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nYDcY0x/hXPt42bGsWegifEgNKEnwqmBNguo5INefxMQjqnJ4lV4ODttv2+f9g0tY
	 PVOn9ksi4Ik2LFFFN1xqRiOgU+g4LjAxNKFOdJmH2RuyiAxu+YUu+PHXT+hbG19Wi0
	 YEvu+2287Bzn8w2PcV7Nb+cD7oG3r1oIfmAwHwPMViFOf4dS75sPr56i+d1xKhydqh
	 R6/qX2R6Ms12roSWYghO27ob10YXvHbZShjrtmRF1RatbOuJfZf3WYkkyB1hjXYVzH
	 DJ0rMPNZ8LW4sP77de2ExoBR0578Fq2Y1C++6yl5U10Sz2LjL6yz/f/+/VlJtWzxzw
	 yPvYHvzy2509Q==
Date: Mon, 21 Oct 2024 15:05:42 -0700
Subject: [PATCH 26/37] xfs: move the tagged perag lookup helpers to
 xfs_icache.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783864.34558.8851584390068717884.stgit@frogsfrogsfrogs>
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

Source kernel commit: f48f0a8e00b67028d4492e7656b346fa0d806570

The tagged perag helpers are only used in xfs_icache.c in the kernel code
and not at all in xfsprogs.  Move them to xfs_icache.c in preparation for
switching to an xarray, for which I have no plan to implement the tagged
lookup functions for userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c |   51 ---------------------------------------------------
 libxfs/xfs_ag.h |   11 -----------
 2 files changed, 62 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 1b65ba983ad542..a63d9c0dc6fe44 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -54,31 +54,6 @@ xfs_perag_get(
 	return pag;
 }
 
-/*
- * search from @first to find the next perag with the given tag set.
- */
-struct xfs_perag *
-xfs_perag_get_tag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
-	unsigned int		tag)
-{
-	struct xfs_perag	*pag;
-	int			found;
-
-	rcu_read_lock();
-	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
-	if (found <= 0) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	trace_xfs_perag_get_tag(pag, _RET_IP_);
-	atomic_inc(&pag->pag_ref);
-	rcu_read_unlock();
-	return pag;
-}
-
 /* Get a passive reference to the given perag. */
 struct xfs_perag *
 xfs_perag_hold(
@@ -125,32 +100,6 @@ xfs_perag_grab(
 	return pag;
 }
 
-/*
- * search from @first to find the next perag with the given tag set.
- */
-struct xfs_perag *
-xfs_perag_grab_tag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			found;
-
-	rcu_read_lock();
-	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
-	if (found <= 0) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	trace_xfs_perag_grab_tag(pag, _RET_IP_);
-	if (!atomic_inc_not_zero(&pag->pag_active_ref))
-		pag = NULL;
-	rcu_read_unlock();
-	return pag;
-}
-
 void
 xfs_perag_rele(
 	struct xfs_perag	*pag)
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index d62c266c0b44d5..d9cccd093b60e0 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -153,15 +153,11 @@ void xfs_free_perag(struct xfs_mount *mp);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
-struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
-		unsigned int tag);
 struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
 void xfs_perag_put(struct xfs_perag *pag);
 
 /* Active AG references */
 struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
-struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
-				   int tag);
 void xfs_perag_rele(struct xfs_perag *pag);
 
 /*
@@ -263,13 +259,6 @@ xfs_perag_next(
 	(agno) = 0; \
 	for_each_perag_from((mp), (agno), (pag))
 
-#define for_each_perag_tag(mp, agno, pag, tag) \
-	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
-		(pag) != NULL; \
-		(agno) = (pag)->pag_agno + 1, \
-		xfs_perag_rele(pag), \
-		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
-
 static inline struct xfs_perag *
 xfs_perag_next_wrap(
 	struct xfs_perag	*pag,

