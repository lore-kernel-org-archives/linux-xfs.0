Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD35A4E13FD
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365544; cv=none; b=mPtX40mMuItKHcVoTAGNCf0OFucNshOMonYX6AvVHNwO8uKK97uQwebjMqmjBLNOMCRxoYm6ngHJW7ZJDA/MPsK1ggiR70e4n0t0lCUGe9ZSZYI6qo0z2/cMjhZrMQhJJ4CDzS0CbosJyEWcPwBTta/0cWF6fG9h4twjBum/tmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365544; c=relaxed/simple;
	bh=xKn845IggG+lE14yyNBFuwKlQeuCPJ8LVlxyny/+1Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/kfYPcw3vbzqw+l2NZfozAU7iJsojc9fp2yX4rMaX0YoMmGJeGM0fXbDE9xeHz59yFP6Hmvg/JbSmO1dS3jnbLH04owcrWCRgjI3i+jeX3CLCyduUh35lCLUZSOHCndZkFRS57ea9YuTapqKQqOZSJ6VPoJSe9mNGJ62yVWgr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DmvnOMRi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a94irAEI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DmvnOMRi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a94irAEI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790365541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zq+HlA0cUt3GPp6lhXZssKPcxSjCKz1UtV+Nwf00U2s=;
	b=DmvnOMRixYZE/u3o87YFPVceap/UXg0wro3KIA9Eh901CTsP4q78yP0BBpRRsLHV7wZjOq
	oXMeQLEczQp9uX54p583dFTMXS5Dvhx/AwKCbYL7Zcz9XykFWCGecabQoH0pnnt94mV5BU
	IIOwZy7jqPrT5TBAhVWeTVTT/uLSGDU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-vVeJBRcMOTKEVVGtq6sOrg-1; Fri, 25 Sep 2026 15:45:40 -0400
X-MC-Unique: vVeJBRcMOTKEVVGtq6sOrg-1
X-Mimecast-MFC-AGG-ID: vVeJBRcMOTKEVVGtq6sOrg_1790365540
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530e5b709b1so25971061cf.0
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 12:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790365540; x=1790970340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zq+HlA0cUt3GPp6lhXZssKPcxSjCKz1UtV+Nwf00U2s=;
        b=a94irAEI2kc3infpQwEz9WgBGe2np1VJPx4v3tOcJNIK1e6WpvpLwkG8gPtjJ0oPCq
         ITmkBmCQO8NE0KweWMHwN3sd3HnMuTwoSl1KWuZqoRCjry0dKDpkRKcYgLG47UZsSLeo
         Q/dTObJsiX7lj3bz5JVUuF4yU1Ka+m1ANORlpS4WBLCMsSOsfESykBaSZjJSyfJNi3C/
         wW7xd198UhZLqW0gUbES9VFnzI6p1rqsaogZ60q4O53nH2Mh1yF37v7MDsKhcmKjbZd0
         jGnYXJmUd883GJP1FFTaj8NsrZaQ3ZBlGFuh1iCnOGtCr6Vx5MM51v/WVHKZryIQ5KbY
         uhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790365540; x=1790970340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zq+HlA0cUt3GPp6lhXZssKPcxSjCKz1UtV+Nwf00U2s=;
        b=IK/rxl0sTbdrCgiVIBxb+JWICft31zTuL5xCro7b3kjQNWD/MkzFG/PCN8r4Dn4KKA
         WWumhwvmTjrogAwLVttyfVzLhLzO+Mnkp/uKeePxOQvwmMt87UMiZ1k+UYpvoyGB/cuP
         2GTzGdC3pCSjjq6KR9jukdB1v1AYGxbKKCEYcHbPJ32vTuonRsw+ISJRuP7c2A7az4k6
         ewpZf1136M78n3xOMVZUrmvrEq0qJK+zN49qfw1W1E2ZSYGmFegVkaI3Zk3N7NVsa+Ou
         EICz4OxhR3pnWOH0XZKl2kdbyt38b/dmnShrf6JvEBl+V2Uy7tkwXIFSGcElneVkT1VB
         LSUw==
X-Gm-Message-State: AFuF++lKjsze7G2kF0TF9MbDGDGmpCe27FkiUlhZrCix9xWKo+wuWvFJ
	9RWEIU+wAGc/x/tE/DvBShBY3L81fUeVmqaCspSXt1jK6dasXKH8sYL85LYVf7nRlI2FylB0zrm
	9vFQTU7/MRvKM3jiMvmSRKOKevkdcGFahRUsLP5ihIGUVIamkfaVqKIrjr+l0HPSs6h6egO7ljV
	kX5YKfT93DHK+AFN8WLF4v8FVdY5+uq78ETv34UI8k3wj+8Z0=
X-Gm-Gg: AYBFou24c16IOR7BUWZYIKX1i1+Dgxknfth1ZCNWBo38Dp90gyy/6+Vn6Gel0OxOAP4
	xF+TjfU6RRP4TIdXdy9TkF6rtqnpO/Sc6ZPErZOFdiMrpVK/UBKKvxQVPWpmaXbcXzprpfEpkco
	2oSaGvm45G9GCISc1d2LG51M9U/CyJD/ZuSDljbGqE5b5ojjFEBU/8hw5PrE5IbJoExSD2YuPRt
	FW33xIz8UD0drgbsSLYb8aAq9mNcgHXj/djmXTwSUfQFGVsCqsaDmcjm4XfEhR2h885JudsaLKW
	Fku9O5kgm5F0vKsPcyyUMp09H+TD9fkBoA+Kvea11MkJHjiShyQKVk257XHYHX83kXABvOCuNDW
	h8/slHH5XaBfmzfin+BVjON+zQQew3H/Fzedo0w==
X-Received: by 2002:a05:620a:4387:b0:939:d78c:eb0c with SMTP id af79cd13be357-93c43b80c62mr622781185a.11.1790365539774;
        Fri, 25 Sep 2026 12:45:39 -0700 (PDT)
X-Received: by 2002:a05:620a:4387:b0:939:d78c:eb0c with SMTP id af79cd13be357-93c43b80c62mr622775885a.11.1790365539193;
        Fri, 25 Sep 2026 12:45:39 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c474fcfc2sm227375785a.10.2026.09.25.12.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:45:38 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	aalbersh@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] libxfs: Return -ENOMEM on actual cache node allocation failures
Date: Fri, 25 Sep 2026 14:41:44 -0500
Message-ID: <20260925194535.397036-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925194535.397036-1-sandeen@redhat.com>
References: <20260925194535.397036-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Today, if we get an underlying ENOMEM from an actual cache node
allocation attempt, it's indistinguishable from "current cache size
is filled" and we'll keep doubling cache size to no avail until the
size itself overflows.

This patch differentiates "no node returned" between the "cache full;
grow it" case and the "underlying allocation actually got ENOMEM" case
so that the caller can do the right thing, and return true ENOMEM
up the stack for callers to handle.

Finally, actually check this returned error at the cache_node_get
callsite (in __cache_lookup).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 22 ++++++++++++++++------
 libxfs/rdwr.c  |  9 ++++-----
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index a6dabf92..60bfcdc5 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -285,7 +285,8 @@ cache_shake(
  * Allocate a new hash node (updating atomic counter in the process),
  * unless doing so will push us over the maximum cache size.
  * Return 1 with nodep set on success.
- * Return 0 and NULL nodep otherwise (cache full, or alloc failure)
+ * Return 0 and NULL nodep if the cache is full (caller should shake/expand).
+ * Return -ENOMEM and NULL nodep if the underlying allocation failed.
  */
 static int
 cache_node_allocate(
@@ -315,7 +316,7 @@ cache_node_allocate(
 		cache->c_count--;
 		pthread_mutex_unlock(&cache->c_mutex);
 		*nodep = NULL;
-		return 0;
+		return -ENOMEM;
 	}
 	pthread_mutex_init(&node->cn_mutex, NULL);
 	list_head_init(&node->cn_mru);
@@ -373,8 +374,8 @@ __cache_node_purge(
  * hit, in which case this will all be over quickly and painlessly.
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
- * Returns zero if hit in cache, one if a new node was allocated.  A node
- * is always returned.
+ * Returns zero if hit in cache, one if a new node was allocated.  Returns
+ * -ENOMEM if allocation fails after cache shaking is exhausted.
  */
 int
 cache_node_get(
@@ -391,6 +392,7 @@ cache_node_get(
 	unsigned int		hashidx;
 	int			priority = 0;
 	int			purged = 0;
+	int			error = 0;
 
 	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
 	hash = cache->c_hash + hashidx;
@@ -464,8 +466,8 @@ next_object:
 		/*
 		 * not found, allocate a new entry
 		 */
-		cache_node_allocate(cache, key, &node);
-		if (node)
+		error = cache_node_allocate(cache, key, &node);
+		if (error > 0)
 			break;
 
 		priority = cache_shake(cache, priority, false);
@@ -475,6 +477,14 @@ next_object:
 		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
 		 */
 		if (priority > CACHE_MAX_PRIORITY) {
+			/*
+			 * We've shaken every priority level.  If the last
+			 * attempt failed with a real ENOMEM rather than a
+			 * full cache, neither shaking nor growing can help;
+			 * return the error to the caller.
+			 */
+			if (error < 0)
+				return error;
 			priority = 0;
 			cache_expand(cache);
 		}
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 90f2d566..d8ba832e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -411,17 +411,16 @@ __cache_lookup(
 	struct cache_node	*cn = NULL;
 	struct cache		*bcache = key->buftarg->bcache;
 	struct xfs_buf		*bp;
+	int			ret;
 
 	*bpp = NULL;
 
-	cache_node_get(bcache, key, &cn);
-	if (!cn)
-		return -ENOMEM;
+	ret = cache_node_get(bcache, key, &cn);
+	if (ret < 0)
+		return ret;
 	bp = container_of(cn, struct xfs_buf, b_node);
 
 	if (use_xfs_buf_lock) {
-		int		ret;
-
 		ret = pthread_mutex_trylock(&bp->b_lock);
 		if (ret) {
 			ASSERT(ret == EAGAIN);
-- 
2.55.0

