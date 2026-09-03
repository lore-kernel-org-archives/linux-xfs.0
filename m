Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC47D3947AC
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 20:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467819; cv=none; b=Un1zrsyxUbtDc0Jw/VqMMxm9fGcE+lDAMeuqqivJoxhrF/1gQqrGgrfiOwPO41/xP9zWAtTNSn+32Hn8vuNYtNdwObgJmxKoSnpHP1GIXqsb3x+Xy5oosNhp9nrnWqkQ0Ojn2mGWEk6ifoJRJz0AFL95GfNHwk0aZafU2gEC7OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467819; c=relaxed/simple;
	bh=H407BUyMcf2oyyisxFqX+2jOaF5HoF1SQ/YApzclPd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh+6WQRIpSb/qa1JnFBy0mbq+4s8VZ51gjgBwdV2JLczXUWOuSWot28f3CyJNwFIj+i1VuJWI5zeuV3Hptniv0I9pQebd7CSOhTEIQHW4h7adbbCdgLHYJ3/FcDfhOwzvBYmdbEXNgIfz6pKWE8aOULZYyKJw3rlyeL15lqwMDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PyKMJjlt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t+7MM7U2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PyKMJjlt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t+7MM7U2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788467804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9O/eAUq4hB+sAeOEFssVvacALDKMr3XqpE9PYvjpFE=;
	b=PyKMJjltu9OM99uduRq/lOGwDgWFS1Usvz0V1hTyA7FTWHQOSNpXG+8CzvlWwNWXJ7Ar0R
	VLToGM8j+vaemD2Ew/plg8pJDpoDNR62TIs/7tmZw/dSCXJKiQyW/PurTdkTG+hVMKeyxv
	64iY/v5fzDWnZe7hULiKnQsSMN56jKk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-2hC-5zN9MqKbAFbEFbJmzg-1; Thu, 03 Sep 2026 16:36:43 -0400
X-MC-Unique: 2hC-5zN9MqKbAFbEFbJmzg-1
X-Mimecast-MFC-AGG-ID: 2hC-5zN9MqKbAFbEFbJmzg_1788467803
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939694871aaso42510685a.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2026 13:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788467802; x=1789072602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b9O/eAUq4hB+sAeOEFssVvacALDKMr3XqpE9PYvjpFE=;
        b=t+7MM7U2upu5jZQwZHjeAok2yQ8f5KmpvZiw/6IS1NUrpgmsvgo1eiyLOg2QcWejks
         pmOfQYbwVZZc/ARx7+/+oaF4psiEhLZVFCTIHLS3mXSJ8tapiStZOgOkhg2w7VxXQm8b
         3exPllPGT60o4kZvRLhTas5iiEetTCNGijK3ugD1GFfuvvnO7ABRjI5oQfnVB+CXY8g6
         DhYrx2VaFYFGj99f2HQqtPt92usdXHBjUIvjpTdmHL262Z3eqEv7FabzvXLbOdI0xLVZ
         GE/1QE9Igr6GawuHUay9RtaCjZqJf4OfqjgXgccTZknZxoxXGBmPr3wiuwaZGkxHVkPe
         dSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467802; x=1789072602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b9O/eAUq4hB+sAeOEFssVvacALDKMr3XqpE9PYvjpFE=;
        b=WEm2CUxBQiX6d19Vd+3ueiA3a7Q0+y3JkQaeJUhmYQAHMI20bzrWMEA4gdnGfv4Qnz
         izllLIMP0GQwD4ukAMwU3qCgxLHPb4Db0cT8wz/D7zbFI7CNDnG4/oX6FFT9sBEcM6Xz
         o89dSG2zIL91grARqVJwgbRolJt+NdCpThLSIbNV0Sb7CUVxoWVFEqMTSRwoNH1pWv2O
         lDP+1Ue0BBjb23cWcWXA3W+cfLbOYWj4RA1DyzDRqkmEF6eUgFujq/gHa3TAJI4KaWZ3
         anlTAnK3OOGyTagXVuxQYcuIX1YbGr+sDBP/IL/WcM1kMQfbV8BGcHzt5rMpsHbE7Npg
         3ckA==
X-Gm-Message-State: AFuF++l3j30yXf+d+UEHzj6ryNq/9Fu1JoTe7aSbl4aj1NYNivguJyGG
	PQ7aKKpdD3Nh4OiSewJptKnjrdu9ievu7SEQXg/fS1Km7WPhkvts2iFeIS39sLPo3X8XteOCpNg
	3TN4a0GbQR6d/JrzdR1P9fTEQtEd01NnUy7Rdr39p1BsQjEhpzw9uzff6OUZmqHHAno0mQZzVi7
	MyND5wSVK5c9CSPRssEmrrF75uHlPdsaNzpTIZRFJjRp2W
X-Gm-Gg: AYBFou1dJf7v9+jDMdAoDtu4Ubb+irTTURPluXOXupVjpcEXekhqeKXoVCUdDYCglPk
	eOuZS2DAIrqPXGhd7R2oMF5CPlfH7pbP6kfX87urr/V7q7Ur7xddPj36cnBmJ9rj+zWjqXQ28Rs
	VRtBUXJacp3fT4nEIU2x0Zn3sXNGQqi3I78yjF0ElXEidTcj7jwberEpdWlMHsemfa2pdeuRFbU
	Y3Mh8ThbkSEdCMvt6YWeWAzBXlou5JsUkPJPT8RxgRZQi1QZ5CV4iKrVwW5DL0dLlf9+D+pEJc2
	DgF1V9+yn78zgFHwv2wDuWLHddON72wxRWQae50J2rM07Fty0Px8G76fYZKS5QPdVTcyG6mQgfi
	uVZP1iPS1xU05voEPmH1aJEBBGnRcX2bbP/EOUDRw
X-Received: by 2002:a05:620a:7087:b0:939:7f87:ff22 with SMTP id af79cd13be357-9398045fd75mr117917685a.36.1788467802514;
        Thu, 03 Sep 2026 13:36:42 -0700 (PDT)
X-Received: by 2002:a05:620a:7087:b0:939:7f87:ff22 with SMTP id af79cd13be357-9398045fd75mr117913085a.36.1788467801873;
        Thu, 03 Sep 2026 13:36:41 -0700 (PDT)
Received: from big24.tailafb26a.ts.net (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397faf927bsm51152485a.8.2026.09.03.13.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:36:41 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs_repair: distinguish true ENOMEM from "not found" in cache_node_get
Date: Thu,  3 Sep 2026 13:42:43 -0500
Message-ID: <20260903203638.1094907-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903203638.1094907-1-sandeen@redhat.com>
References: <20260903203638.1094907-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When cache_node_get() needs a new node it calls cache_node_allocate(),
which returns NULL for two very different reasons:

 - the cache is already full (c_count has reached c_maxcount), or
 - an underlying allocation actually failed with ENOMEM.

These require different responses. A full cache should be shaken to free
slots and, failing that, expanded. An actual ENOMEM should be returned
to the caller to deal with.

To achieve this, make cache_node_allocate() say which case occurred via
a new *enomem parameter, set true only for a real allocation failure.
Cache shaking still happens before returning ENOMEM, as this may actually
free memory and allow new allocations to succeed.

Also fix the stale return-value comment, which had the hit/new-node
cases backwards.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index d5d9ba56..21e4c0c0 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -284,15 +284,26 @@ cache_shake(
 /*
  * Allocate a new hash node (updating atomic counter in the process),
  * unless doing so will push us over the maximum cache size.
+ *
+ * Returns NULL on failure.  A NULL return can mean two different things:
+ * either the cache is already full (c_count has reached c_maxcount), or
+ * the underlying allocation genuinely failed with ENOMEM.  These call for
+ * very different responses from the caller, so report which one happened
+ * via *enomem: it is set true only for a real allocation failure, and
+ * left false when we cannot allocate another node in the current cache
+ * size.
  */
 static struct cache_node *
 cache_node_allocate(
 	struct cache *		cache,
-	cache_key_t		key)
+	cache_key_t		key,
+	bool			*enomem)
 {
 	unsigned int		nodesfree;
 	struct cache_node *	node;
 
+	*enomem = false;
+
 	pthread_mutex_lock(&cache->c_mutex);
 	nodesfree = (cache->c_count < cache->c_maxcount);
 	if (nodesfree) {
@@ -309,6 +320,7 @@ cache_node_allocate(
 		pthread_mutex_lock(&cache->c_mutex);
 		cache->c_count--;
 		pthread_mutex_unlock(&cache->c_mutex);
+		*enomem = true;
 		return NULL;
 	}
 	pthread_mutex_init(&node->cn_mutex, NULL);
@@ -366,8 +378,9 @@ __cache_node_purge(
  * hit, in which case this will all be over quickly and painlessly.
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
- * Returns one if hit in cache, otherwise zero.  A node is _always_
- * returned, however.
+ * Returns zero if hit in cache, one if a new node was allocated.  If
+ * allocation fails with a genuine ENOMEM we return -1 with a NULL
+ * *nodep; in every other case a node is returned.
  */
 int
 cache_node_get(
@@ -384,6 +397,8 @@ cache_node_get(
 	unsigned int		hashidx;
 	int			priority = 0;
 	int			purged = 0;
+	int			ret;
+	bool			enomem = false;
 
 	hashidx = cache->hash(key, cache->c_hashsize, cache->c_hashshift);
 	hash = cache->c_hash + hashidx;
@@ -457,7 +472,7 @@ next_object:
 		/*
 		 * not found, allocate a new entry
 		 */
-		node = cache_node_allocate(cache, key);
+		node = cache_node_allocate(cache, key, &enomem);
 		if (node)
 			break;
 		priority = cache_shake(cache, priority, false);
@@ -467,6 +482,18 @@ next_object:
 		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
 		 */
 		if (priority > CACHE_MAX_PRIORITY) {
+			/*
+			 * We've shaken every priority level and still can't
+			 * allocate.  If the last attempt failed with a real
+			 * ENOMEM rather than simply a full cache, then neither
+			 * shaking nor growing the cache can help - give up and
+			 * let the caller handle the failure.
+			 */
+			if (enomem) {
+				node = NULL;
+				ret = -1;
+				goto out;
+			}
 			priority = 0;
 			cache_expand(cache);
 		}
@@ -479,7 +506,9 @@ next_object:
 	hash->ch_count++;
 	list_add(&node->cn_hash, &hash->ch_list);
 	pthread_mutex_unlock(&hash->ch_mutex);
+	ret = 1;
 
+out:
 	if (purged) {
 		pthread_mutex_lock(&cache->c_mutex);
 		cache->c_count -= purged;
@@ -487,7 +516,7 @@ next_object:
 	}
 
 	*nodep = node;
-	return 1;
+	return ret;
 }
 
 void
-- 
2.55.0

