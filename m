Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717344E80D7
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365546; cv=none; b=F6ldfL5hqa+xKfWred6LRo++BC0yz74mL+x7orcwQiAysxpQZaKRY01V+B6GgBbNCyOGDDMBnUqJYd9qwAGroshsRVurjY1CpEHnULLUtGh1Iv7aFivajBH9w3yvezTgFYChi2cDCynu5xDvcLJvvkyDw0tKtB42rfi/OIwh1FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365546; c=relaxed/simple;
	bh=5CE8Er/XWWAMt+h7d/Eu3hfjqRqWv8bmbwY2GdUgnpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mawK/u9vpynTPmW3Cr7YbbMVqUjFW3ekD5wda6ODxIlZJ593dgq87koq80m+tlPdqnTjDhBHqS1Hz8MVNLcaMOGbuJn2I6r0qVeSWL0KhQ9K6T/gggD4FOwh8NpNl1O+T0GLrVKwk2IWhpc4+/pmE6TQ8ey4uwEP7ZSgEn9cgQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VX4it46v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eW68SYj4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VX4it46v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eW68SYj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790365544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mUCzp9WorFkseCLmLwq3SZ7W5zi52nrMrzKMN8l6vug=;
	b=VX4it46vJnDSskdbZO+pOyf9mjdaMbHfG+W2orkydO7uoNa1otWjV0Yl5sN0tXC8VU3eQm
	lDnaiwu2T0F1hfourope87Qe/hW5ZHcbykMU49a5ZktO63REoSYNh+8JMFYbR+KcWDgPGN
	8LbUIoSanOh5DzHRB9shWFabwfh8iF8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-ly0aIceSOeKI2GwFKQlTnA-1; Fri, 25 Sep 2026 15:45:41 -0400
X-MC-Unique: ly0aIceSOeKI2GwFKQlTnA-1
X-Mimecast-MFC-AGG-ID: ly0aIceSOeKI2GwFKQlTnA_1790365541
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939c30aa9a0so131140485a.0
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 12:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790365541; x=1790970341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mUCzp9WorFkseCLmLwq3SZ7W5zi52nrMrzKMN8l6vug=;
        b=eW68SYj406fBe2ixBvnNc5ikziWlt1LKE4Wld0jJagha26BaLx21WXDyXctZVT4r3O
         93zd/WJREHNG5gOO930sI+9u1c4N6njxpMaLg37oOIk2DwKNtF7EEd8RyoBV8+ZO+t5N
         0GKWLNfCp8nsutlM2iLCi1e0zPC1oruyxbeOBZlIwlhY2JvsIuWxkk8FQVx9Qck4s7JE
         js/fVR/8SISHVy68TfIkA9VWmbXwCX2O3DsBE3b5IsLWiKpnmkz8HPSAsDzd3CBrZH3r
         wjmJrhG9y7m+CXoD0SXsM9cee+mHVtfnY2QhR61NsL+6NIRbXKguhQOqwSPHUqoqI+PO
         xZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790365541; x=1790970341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mUCzp9WorFkseCLmLwq3SZ7W5zi52nrMrzKMN8l6vug=;
        b=Ti0eoxIsVPqALd3G8ALGB+6qvK4LOqT5oi/19cN4X8DIMKsWgmpOp2XyouhmEeQs56
         B48uDkfURDV7LMpCY+U0MkgcaHqnjI1giQjrq7Xyik31weWzdiTh+L3K2YYq6AVoDX+c
         A2303nzkaPkRWwT7VM+fle30ljAWsms7qaam3RvxTCT/gOcFZ35ljoK7iIZ0Hu4Fcyit
         QchXXIm1HyBaaJTs4MGSjarc6a2QcmAzmF/LcC+iutuy4klO0y7h9CEqazwiIULlXIlM
         lh5k6cCUOIZ2oLxqzfYHMkcln1jeowXFYaLZE1vs4BzkroBT7sGMOxLCvOiwkWBV+mU/
         a92w==
X-Gm-Message-State: AFuF++l1lpcwhVE4o0lzAnpSGAHXbyDT0cDtpoMG6MWm1mRU/+575+Fa
	SYea6/pixEEi9d2ZegrZUHR0hoVTw7hmwR3G7WLYHlS146N0jFeFGyY5dz5dUwG6S7CHCcCqN/v
	sKFp+ZBMQUDYOdwpTOh7egyZBreF0NwL6K4oyOueaPDp80FtfJBPfSCWncL3Ep3A+cmO3D6Vz19
	8PDdGe8Ll3EJnyWqpFpMR04LlRF4ZkKDGiGJq1RoAKDQQ2v3w=
X-Gm-Gg: AYBFou0rlGW3vljLm4pLy16bIQirAXF7KqTbza6uwu7F9q4nsZ3JTYETrTUwBe5tCa+
	Pb+0kALf+yrbtJnpDDcL0DrerCc9NcXWxm+0kA+aMFw8L08WY2iXUooDUfCWCNpZ/twQF187ZrW
	rhaiwPOeSruNGq4jIgLxRiJftmyVWN0qMYXtzFPRyl1SsiGckm9eyMKvk8jNoC5FJ6KAiRX8SAB
	7ltV3RTL2FW471gv42KcYahZHWNA6LoHvBuP25mhWw6lvIfnX4roCfjpJhlrBYVOlETLEEHMRfz
	Nw05Awixvuz9FzJoIYitKMr76K5/XflpYAcCRj0KhOeDZtgf7is8GQkbHO5RrZJAQtCCRQWr4yp
	1Qx+sCzPN1ByZ7MyzceL7y7T526zKquhnVlyV2A==
X-Received: by 2002:a05:620a:2628:b0:93c:2223:7dc with SMTP id af79cd13be357-93c43cf0074mr677011985a.48.1790365541258;
        Fri, 25 Sep 2026 12:45:41 -0700 (PDT)
X-Received: by 2002:a05:620a:2628:b0:93c:2223:7dc with SMTP id af79cd13be357-93c43cf0074mr677004685a.48.1790365540435;
        Fri, 25 Sep 2026 12:45:40 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c474fcfc2sm227375785a.10.2026.09.25.12.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:45:39 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	aalbersh@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] libxfs: do not allow cache growth to overflow
Date: Fri, 25 Sep 2026 14:41:45 -0500
Message-ID: <20260925194535.397036-4-sandeen@redhat.com>
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

Nothing stops cache_expand() from growing c_maxcount (via *2)
repeatedly until it overflows.

Add a bounds check here and return failure if for any reason we try to
grow too much.

With the prior fixes, we should never get this far, but it's worth
defending against anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 60bfcdc5..03b62bc7 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -79,16 +79,24 @@ cache_init(
 	return cache;
 }
 
-static void
+/* Double the cache size limit; return false if it would overflow. */
+static bool
 cache_expand(
 	struct cache *		cache)
 {
+	bool			expanded = false;
+
 	pthread_mutex_lock(&cache->c_mutex);
+	if (cache->c_maxcount <= UINT_MAX / 2) {
 #ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
+		fprintf(stderr, "doubling cache size to %u\n",
+				2 * cache->c_maxcount);
 #endif
-	cache->c_maxcount *= 2;
+		cache->c_maxcount *= 2;
+		expanded = true;
+	}
 	pthread_mutex_unlock(&cache->c_mutex);
+	return expanded;
 }
 
 void
@@ -375,7 +383,8 @@ __cache_node_purge(
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
  * Returns zero if hit in cache, one if a new node was allocated.  Returns
- * -ENOMEM if allocation fails after cache shaking is exhausted.
+ * -ENOMEM if allocation fails after cache shaking is exhausted, or if the
+ * cache cannot be expanded further without overflowing.
  */
 int
 cache_node_get(
@@ -485,8 +494,9 @@ next_object:
 			 */
 			if (error < 0)
 				return error;
+			if (!cache_expand(cache))
+				return -ENOMEM;
 			priority = 0;
-			cache_expand(cache);
 		}
 	}
 
-- 
2.55.0

