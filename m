Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6336403F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917467; cv=none; b=r5AybytiXmipKEjl8+b6J0AXasXfjcYbgJFGe3OFAiDhLaaG84HJWuu1OgG7xVDUbhUHpshtTC+cb997jABysDH2NnaEhpEVg80nF7HKcMy4XqLEOJDeM+tGSb0sh0z4WaHlVyR1StYPbMt8HvbgbD7IGx3ZOFIYdA6+g8oMH9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917467; c=relaxed/simple;
	bh=VQRttzYiE6Sl1yA7jxlTQLcgDRbQOH3ORooLCT4LoTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hClDVy+dKAH/90iNW2Sh6ZuyNnG1yzIAdmJFfkOweyqDJ4OwrJ+Vla0U1gA9N/G0KZHkua7XHJd+XUHqI48jbakGiFF9Vk6epq5Yo1YfOwDcmn/tI6NvsE76rtt6Y+N3LzcD0hXkpGSEaWRqWh8kdn4EDSwmUJMqzUkHd3SdHGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3u19iDI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtSdzdqx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3u19iDI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtSdzdqx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJyZVvxBdT+pYdlwtVxNGCQqG7Y7KHKqoxLEx8sAHhg=;
	b=T3u19iDIj6RfcArttmyxLOFniGhGYVY14Wup7P+nVmATTY14UMWxYqyZ2pgQy6VauUWKij
	wyCmcjhGmfvnwXU3buYXSxmMOodQU1sp3ToppOuzls72wUpiKFS04yySXaAuCqL42i475R
	dEqhLX1RgxBfJRc0Gyj35MFyYW93iSQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-2PqMeLdFOuypwidNEsQdig-1; Tue, 24 Feb 2026 02:17:42 -0500
X-MC-Unique: 2PqMeLdFOuypwidNEsQdig-1
X-Mimecast-MFC-AGG-ID: 2PqMeLdFOuypwidNEsQdig_1771917461
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aad3f8367bso60762925ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917461; x=1772522261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJyZVvxBdT+pYdlwtVxNGCQqG7Y7KHKqoxLEx8sAHhg=;
        b=EtSdzdqxHDtqjuf0tTGDIzr0WzCjF16mBX28jF9x5eUZXGTClzWC/oVyDhaIdbR2RR
         AJipdwaZjooJX+1Lm3NipA9AiLJPOKUMKQnYcVMTwclBjRUJBxkGGg3Fe+CoaOHuPnBW
         rWxLH7MI2VwGxTIJvaeIYB7p+i7KkqdnxhGjUAcN+BF2fQXwplImkxzdYMEAEWQXV56y
         eYQ/ELtSqL5u2BUvW7dvfyMOUcBXFYGdxXY/yZVxwBuZ5DzNYqv7d9PcRYNyF5LQoToo
         syWag2MHFPxwMwLB57XMBt0ej7MgEXmuuzzdckwh79xR26p84osWR0V8iXHyh0ijhA4b
         ZtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917461; x=1772522261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xJyZVvxBdT+pYdlwtVxNGCQqG7Y7KHKqoxLEx8sAHhg=;
        b=NUWnDNyQzUeZ3vukrs9zP1JJOwdYxF466o5JkzmbULPKBJZORzTAKKzp0tuOAggSeI
         SN2R3EhaK1DYlVvVHDXOZiJ99GeEdD265NCooRq8uy2BSeIWZuMFkq+ICLET+YsfJIQT
         fNFvD+zqHhl6uYQvoC4kD7KnnBHxZ/wVNma+FG5yEL+SFYAf9qJ6iohqdgcpyYYA2enS
         LiFTZi1HkMZOVy/LHo2BU77y1h8hlHaRqwX4bRwSacp3K//NAwrHLqBVXk+6k5u9cQ//
         6IST70+mCvqyfQQSdxHazhQ1e1uv0iupPGKPXisjDkaQ/3W6fjxI6kyppEvI5kR4tAh3
         S8OA==
X-Gm-Message-State: AOJu0YwdU7iflTg5tIfVwR9X9J6s6ckoBa4i9FxygGcg5kMA8CjRKlnP
	xEk1IyQdITDJfC4ehs6MXA36lyOxp6CAa7bDnyqMyuNWBAZ8ZL3tMRL7m6k61iMlfRmT/TNpjaY
	qd/TrY39Tf94FzcLem7DOjNkqcslYp38J3mEPgLvtHMG20dhh/KbwDlelaIvdHL2GQoH5ZjzsCh
	KseEPmXAoBclIbA7vAlBRN3+hU70sx3+ZA/F3zDinQMRnClw==
X-Gm-Gg: ATEYQzxOr7VdY5qWv1ofV2MLomoi6xxNPd/InbJ3+l/ELC8s/I4NmDrsxZy2N+q9HjB
	FajzlbdigE5vzYgbYfqdu0Lyut82EzUs3rJ0mfoBsD0Krp34kvvbjk4pD3U2hB/hgtNvRZlYnt2
	k3tsLpKY4/MtiFfB1c+g3f14WRJD7xkxyr7w8ONAUgKKary5we/YP9hk2Vq9cygXop7in8mj03s
	ne+7kRiHhI/YG8c3HKBW5F5277sHskVBKslzAB7vHdNCoRVEDLsZEMWhhpb0UAgSm8ycYs63aH2
	K1EOEJYhKrmXAS1+fOcbhiE1EqcXJL/Db0USWLEu7VcxFDJfojL/uxmlrhHZt4EPrTy0QLebteD
	MTwRBbZZuA5fFoVgEqyr92XKvqbNiJOBGMw==
X-Received: by 2002:a17:903:2a83:b0:2a9:5c0b:e5d3 with SMTP id d9443c01a7336-2ad74465376mr86141775ad.20.1771917460781;
        Mon, 23 Feb 2026 23:17:40 -0800 (PST)
X-Received: by 2002:a17:903:2a83:b0:2a9:5c0b:e5d3 with SMTP id d9443c01a7336-2ad74465376mr86141545ad.20.1771917460253;
        Mon, 23 Feb 2026 23:17:40 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:39 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 3/5] xfsrestore: include TREE_DEBUG all builds
Date: Tue, 24 Feb 2026 18:17:10 +1100
Message-ID: <20260224071712.1014075-4-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TREE_DEBUG guards additional tree debugging code, making it unavailable
for troubleshooting production issues in the field. Remove the define
and move the logging to level debug or nitty.

 xfsrestore -v tree=debug -f dump /tmp/testdir

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 restore/tree.c | 43 +++++++++++++++----------------------------
 restore/win.c  | 21 ++++++---------------
 2 files changed, 21 insertions(+), 43 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index 7e79ef2..bf89c6a 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1342,13 +1342,13 @@ noref_elim_recurse(nh_t parh,
 		grandcldh = cldp->n_cldh;
 		nextcldh = cldp->n_sibh;
 
-#ifdef TREE_DEBUG
-		ok = Node2path(cldh, path1, _("noref debug"));
-		mlog(MLOG_TRACE | MLOG_TREE,
-		      "noref: %s: isdir = %d, isreal = %d, isref = %d, "
-		      "isrenamedir = %d\n",
-		      path1, isdirpr, isrealpr, isrefpr, isrenamepr);
-#endif
+		if (mlog_level_ss[MLOG_SS_TREE] == MLOG_DEBUG) {
+			ok = Node2path(cldh, path1, _("noref debug"));
+			mlog(MLOG_DEBUG | MLOG_TREE,
+			      "noref: %s: isdir = %d, isreal = %d, isref = %d, "
+			      "isrenamedir = %d\n",
+			      path1, isdirpr, isrealpr, isrefpr, isrenamepr);
+		}
 
 		Node_unmap(cldh, &cldp);
 
@@ -3616,11 +3616,9 @@ adopt(nh_t parh, nh_t cldh, nrh_t nrh)
 	node_t *cldp;
 	node_t *sibp;
 
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_NITTY | MLOG_TREE,
 	   "adopt(parent=%llu,child=%llu,node=%llu): \n",
 	   parh, cldh, nrh);
-#endif
 
 	/* fix up our child - put at front of child list */
 	cldp = Node_map(cldh);
@@ -3921,10 +3919,8 @@ link_in(nh_t nh)
 	gen_t gen;
 	nh_t hardh;
 
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_NITTY | MLOG_TREE,
 	    "link_in(%llu): map in node\n", nh);
-#endif
 
 	/* map in the node to read ino and gen
 	 */
@@ -3940,18 +3936,14 @@ link_in(nh_t nh)
 	 * of hard link (lnk) list.
 	 */
 	if (hardh == NH_NULL) {
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE,
+		mlog(MLOG_NITTY | MLOG_TREE,
 		    "link_in(): hash node in for ino %llu\n", ino);
-#endif
 		hash_in(nh);
 	} else {
 		nh_t prevh = hardh;
 		node_t *prevp = Node_map(prevh);
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE,
+		mlog(MLOG_NITTY | MLOG_TREE,
 		    "link_in(): put at end of hash list\n");
-#endif
 		while (prevp->n_lnkh != NH_NULL) {
 			nh_t nexth = prevp->n_lnkh;
 			Node_unmap(prevh, &prevp);
@@ -3967,10 +3959,8 @@ link_in(nh_t nh)
 	 */
 	np->n_lnkh = NH_NULL;
 	Node_unmap(nh, &np);
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_NITTY | MLOG_TREE,
 	    "link_in(%llu): UNmap in node\n", nh);
-#endif
 }
 
 static void
@@ -4362,11 +4352,9 @@ hash_find(xfs_ino_t ino, gen_t gen)
 		return NH_NULL;
 	}
 
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_NITTY | MLOG_TREE,
 	     "hash_find(%llu,%u): traversing hash link list\n",
 		ino, gen);
-#endif
 
 	/* walk the list until found.
 	 */
@@ -4382,10 +4370,9 @@ hash_find(xfs_ino_t ino, gen_t gen)
 	}
 	Node_unmap(nh, &np);
 
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_NITTY | MLOG_TREE,
 	    "hash_find(): return nh = %llu\n", nh);
-#endif
+
 	return nh;
 }
 
diff --git a/restore/win.c b/restore/win.c
index 64dae1a..8540a98 100644
--- a/restore/win.c
+++ b/restore/win.c
@@ -185,10 +185,9 @@ win_map(segix_t segix, void **pp)
 
 	CRITICAL_BEGIN();
 
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
+	mlog(MLOG_NITTY | MLOG_TREE | MLOG_NOLOCK,
 	     "win_map(segix=%u,addr=%p)\n", segix, pp);
-#endif
+
 	/* resize the array if necessary */
 	if (segix >= tranp->t_segmaplen)
 		win_segmap_resize(segix);
@@ -198,10 +197,8 @@ win_map(segix_t segix, void **pp)
 	 */
 	winp = tranp->t_segmap[segix];
 	if (winp) {
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
+		mlog(MLOG_NITTY | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): requested segment already mapped\n");
-#endif
 		if (winp->w_refcnt == 0) {
 			assert(tranp->t_lruheadp);
 			assert(tranp->t_lrutailp);
@@ -238,19 +235,15 @@ win_map(segix_t segix, void **pp)
 	 * otherwise reuse any descriptor on the LRU list.
 	 */
 	if (tranp->t_wincnt < tranp->t_winmax) {
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
+		mlog(MLOG_NITTY | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): create a new window\n");
-#endif
 		winp = (win_t *)calloc(1, sizeof(win_t));
 		assert(winp);
 		tranp->t_wincnt++;
 	} else if (tranp->t_lruheadp) {
 		__attribute__((unused)) int rval;
-#ifdef TREE_DEBUG
-		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
+		mlog(MLOG_NITTY | MLOG_TREE | MLOG_NOLOCK,
 		     "win_map(): get head from lru freelist & unmap\n");
-#endif
 		assert(tranp->t_lrutailp);
 		winp = tranp->t_lruheadp;
 		tranp->t_lruheadp = winp->w_nextp;
@@ -284,11 +277,9 @@ win_map(segix_t segix, void **pp)
 		OFF64MAX - segoff - (off64_t)tranp->t_segsz + 1ll);
 	assert(!(tranp->t_segsz % pgsz));
 	assert(!((tranp->t_firstoff + segoff) % (off64_t)pgsz));
-#ifdef TREE_DEBUG
-	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
+	mlog(MLOG_NITTY | MLOG_TREE | MLOG_NOLOCK,
 	     "win_map(): mmap segment at %lld, size = %llu\n",
 	    (off64_t)(tranp->t_firstoff + segoff), tranp->t_segsz);
-#endif
 	tranp->t_winmmaps++;
 	winp->w_p = mmap_autogrow(
 			    tranp->t_segsz,
-- 
2.47.3

