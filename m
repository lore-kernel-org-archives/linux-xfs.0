Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387B513B58A
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311410; cv=pass; b=mhBjqTlKSMmszGv5AbhDJJIXXS/xGHcVBTTfr8CleeTRja3lsxoXRlpGAezQ5o5gTc/cpiVCMGZW5jdlERL1xJPUJ0cyF8MNYvW8D4qeMjIflJcP0CtRVQoBt1lpyBIEME0lrj4MouqC9P6PTxbCTQ+WqpHGaCoGOLC18qUJlJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311410; c=relaxed/simple;
	bh=RpBC65bdovXusXADyGwc238tThmOsMBqeOZ0Lg60lug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5oLtc88cxRVYZf9LzM+XAPyRoGX66gzQxHSMhzKqT5Y6oHK2//Me+SuMmAqb+FsviwQcfKxwkbsiv0gERuVZxG9iktnLKy6bwNBX1IBkxgjFqGhI966XAW9Mk9IcyIyzv+HjZLvYVgX3gYYsVI77SBXgEOxxbd9UkxQO9UobJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=bR24r/lf; arc=pass smtp.client-ip=23.83.223.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="bR24r/lf"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id AE535901DFD
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a231.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 585D4903876
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 20:27:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718310463; a=rsa-sha256;
	cv=none;
	b=1HjiGjhantU04IE4XSoEeTTtSnP66/7cODvJzWaoUNoGZaFc2ABxIYrOcUT58MoIXbc1T/
	aNAzQdeB1pXkmr7/hndcKIaa/4aAghD33a3+sQ9LX0et7JBEaiIHh/CqH5GQxe3fhkhFsI
	HFI8uJUAJNKDQAKqFyqRbAC0LaoRx+sIxLbg6sBek6mO1poX3Evx7UfXARJBLJ1auG9ni2
	7blwYL4Q/0X1sQ6oCvspnDDzijw01Ztl9Z15niY34mIbTHwz+zDPpbhjsG0d2W6tjV1OVY
	Yc5AszT+gAM5spHimTnPf0yvydeJ7ol96B89+Gj9ZNufYaE0I7L43ki3BWppbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718310463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBs+17Ij2599xPvqLbg1BwkejzoMnVt6qu+0xtH1bYc=;
	b=l/Usl0GHcim6Mavu6u1rdw6uO2Zk/s5F1UigNlKOLhu5GQemwKrCvoMZgeD+UrvB/79ZtZ
	BsE1qIWV0Gi9UHTPr1LPbLUaW7UKHURMQ8C6TZsszD/1l+2wrUoYSvbY/i2d2K7AE+PDDW
	LLGtD0BtFdZese/TWjZNVgq36dazgbmHPBmdp7rJkyl5A6iawkKGhhh6xhG66d7iXK9N7Z
	knEriasIYOVuOUtCXLXSDMoHsK9B2NFVqFCoLi/DDf9VmWz+ctkbq09ocavrUgQiyouRHo
	xCdBKyCP1oVWGEdlXDkKeAaWOw67wvGFPzXA/I8M8tKcHUeYwQMjdSl9BlUpEw==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-kt8wt;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Wiry-Juvenile: 3dec3ad1287c27ae_1718310463606_2212892820
X-MC-Loop-Signature: 1718310463606:3050848005
X-MC-Ingress-Time: 1718310463606
Received: from pdx1-sub0-mail-a231.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.83.163 (trex/6.9.2);
	Thu, 13 Jun 2024 20:27:43 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a231.dreamhost.com (Postfix) with ESMTPSA id 4W0Yqz0pw9z58
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 13:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718310463;
	bh=ZBs+17Ij2599xPvqLbg1BwkejzoMnVt6qu+0xtH1bYc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=bR24r/lf0sy8wcatMWHtgXya6xj4UuiRe6B4NWzbY4Dkz3xN/ARi9wogbNCEKWMGG
	 a8MKHSwGeB/TXB222LCFH6tmkXcuGN7rGsifWmwum4nt+ruiU13dWH2E+8juxzyfHA
	 zZV3pDbaLcxfKW/2fH3JztzpyaPf/2GCysg9+Tu18cQ3v2Ee+Is9cCXF17bnlIMQkW
	 uC1Oi8YIKN9fXK6nonbcSrCAH0PMF29uLCsYOE3avf1i/8uQ9G4WBF7LdxluWz4kxl
	 XN5Lh56qX2GHhSh2vJEhA54vwqQ7ht0hWDf4zOs4+1Uhqrb1TPflZuztJqj0K75y4D
	 hXpYrT3roQ0tg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e006b
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 13 Jun 2024 13:27:34 -0700
Date: Thu, 13 Jun 2024 13:27:34 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-xfs@vger.kernel.org
Subject: [RFC PATCH 2/4] xfs: modify xfs_alloc_min_freelist to take an
 increment
Message-ID: <36f4ac4967812331e275b8540859a9473e38153e.1718232004.git.kjlx@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1718232004.git.kjlx@templeofstupid.com>

xfs_alloc_min_freelist is used to determine the minimum size for the
AGFL based upon the current height of the bnobt, cnobt, and rmapbt.

In order to determine how much space needs to be in the AGFL reserve in
order to permit a transacation that may perform multiple allocations, it
is necessary to also know the minimum size of the AGFL after trees are
split and the level has incremented.

Let xfs_alloc_min_freelist take an increment so that callers may request
the minimum AGFL size based upon current + N.

This patch has no functional change.  A subsequent patch will bring new
users.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 21 +++++++++++++--------
 fs/xfs/libxfs/xfs_alloc.h  |  2 +-
 fs/xfs/libxfs/xfs_bmap.c   |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d70d027a8178..0b15414468cf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2325,17 +2325,22 @@ xfs_alloc_longest_free_extent(
 
 /*
  * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
- * return the largest possible minimum length.
+ * return the largest possible minimum length. If @level_inc is greater than
+ * zero, increment the level being computed by cur + level_inc.
  */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	unsigned int		level_inc)
 {
 	/* AG btrees have at least 1 level. */
-	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
-	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
-	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
+	const unsigned int	bno_level =
+	    pag ? pag->pagf_bno_level + level_inc : 1;
+	const unsigned int	cnt_level =
+	    pag ? pag->pagf_cnt_level + level_inc : 1;
+	const unsigned int	rmap_level =
+	    pag ? pag->pagf_rmap_level + level_inc : 1;
 	unsigned int		min_free;
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
@@ -2803,7 +2808,7 @@ xfs_alloc_agfl_calc_reserves(
 		return error;
 
 	agf = agbp->b_addr;
-	agfl_blocks = xfs_alloc_min_freelist(mp, NULL);
+	agfl_blocks = xfs_alloc_min_freelist(mp, NULL, 0);
 	list_len = be32_to_cpu(agf->agf_flcount);
 	xfs_trans_brelse(tp, agbp);
 
@@ -2861,7 +2866,7 @@ xfs_alloc_fix_freelist(
 		goto out_agbp_relse;
 	}
 
-	need = xfs_alloc_min_freelist(mp, pag);
+	need = xfs_alloc_min_freelist(mp, pag, 0);
 	if (!xfs_alloc_space_available(args, need, alloc_flags |
 			XFS_ALLOC_FLAG_CHECK))
 		goto out_agbp_relse;
@@ -2885,7 +2890,7 @@ xfs_alloc_fix_freelist(
 		xfs_agfl_reset(tp, agbp, pag);
 
 	/* If there isn't enough total space or single-extent, reject it. */
-	need = xfs_alloc_min_freelist(mp, pag);
+	need = xfs_alloc_min_freelist(mp, pag, 0);
 	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 8cbdfb62ac14..77347d69f797 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -74,7 +74,7 @@ unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
 		xfs_extlen_t need, xfs_extlen_t reserved);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
-		struct xfs_perag *pag);
+		struct xfs_perag *pag, unsigned int level_inc);
 int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, xfs_agblock_t *bnop, int	 btreeblk);
 int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c101cf266bc4..742ec4142fb0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3270,7 +3270,7 @@ xfs_bmap_longest_free_extent(
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(pag->pag_mount, pag),
+				xfs_alloc_min_freelist(pag->pag_mount, pag, 0),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 14c81f227c5b..30690b7965af 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -3047,7 +3047,7 @@ xfs_ialloc_calc_rootino(
 	first_bno += 1;
 
 	/* ...the initial AGFL... */
-	first_bno += xfs_alloc_min_freelist(mp, NULL);
+	first_bno += xfs_alloc_min_freelist(mp, NULL, 0);
 
 	/* ...the free inode btree root... */
 	if (xfs_has_finobt(mp))
-- 
2.25.1

