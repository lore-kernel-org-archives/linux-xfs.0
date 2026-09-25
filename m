Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCED49E5F5
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365543; cv=none; b=eeLrvO7HnfkE6EI1vgCzHCd6e4Gfs03m09iL4K6AhJab5rg6FvHEmGMsDkbkPTgJMo5r90y0dgzRFJozI1SLbpK6DwB24f9varhAabsyNyB3p6F1+LXfSqAjYjY5vLhPYdLFVZSlLhX97xnngIl80PK7CC6ZwEio+xe1JszpMCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365543; c=relaxed/simple;
	bh=JEQEeJPZS8k6LxaNpQAnT0OBbIq0SndhNoX/8c++LNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s74ogm8IrAg3vin07DwgcC/mTfvnebDSaZqWMgWolRNvqelDRz9O8P5QJzZTn/xzdOZTXA5MLPRGEKeegLlsnqEP3UN0BJRf6Gl0GByev1nmyBMNF6nbnDuNjqLzRphWvL8Hyr/fDFb7vFhJYS6Asohb1pLRP+r+kgpGoYLB5rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V2pGoSDD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uip73fCF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2pGoSDD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uip73fCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790365541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXckLT1/JEuOzWikQ1byygmr8syrxnk2JrrgGxcgMmc=;
	b=V2pGoSDDi/sDxVbxB+WvDQYvnzkvdRGPpahDr17u8p3A2103Jlzqg3E5nYW1fV20X4rYDK
	geEfJCozTwSiAQYmnUPVBsPhB4Kz7wocLExqyRwmKoI1ZxilwJt9P4tVXI/NmLfW4LNsYX
	p52YnObZ25kyPZwshEp++lZzZd0zz6k=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-P825WKYfPuCi9VMD8Q7TPw-1; Fri, 25 Sep 2026 15:45:39 -0400
X-MC-Unique: P825WKYfPuCi9VMD8Q7TPw-1
X-Mimecast-MFC-AGG-ID: P825WKYfPuCi9VMD8Q7TPw_1790365539
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-939062ecda9so237177785a.1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 12:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790365539; x=1790970339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EXckLT1/JEuOzWikQ1byygmr8syrxnk2JrrgGxcgMmc=;
        b=Uip73fCFAZIG033lj/VBpmqr/O/t9QEjoRIWZ+F5J1UFp2Uecbh+w0dVko0iwRfeCx
         TSiOmza5BAHGGFdfJjttgzonkFCXreGBvB6eOCWHJcKQCDTqiWqavVY8KwKjtyELJ65H
         6IE7BaVTZXptz1OS2qQpXkykYKzPONIK8Q8PjU4+AkbAxcJBp3wjU5fHAdDf42SS5TMq
         NED9pH/6KyLKrGbst+POv4iubuhwP80otWfxwG5XrlpeQiLm60OYuo7VSAjLsH1vOA5V
         ltsLFwfo21giLfD9ObDHRbFrpYKboER7qxCoheYCpQpEqKfJanXZQ7t/lnSvUexO+ckn
         S0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790365539; x=1790970339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EXckLT1/JEuOzWikQ1byygmr8syrxnk2JrrgGxcgMmc=;
        b=C0XFc8SdE4qvhJ+Q37rjqzXWowHSayoEBQGBK5TD4ZhcXdZHpWD0rUR9sSf04ZkbwW
         CYMQaB/feKy/N5EfroUtEoqv0FM0uMkEExGh93zkeueB6FlWDZeBWUuOpwtsRadI+TIH
         u/chbUcUWOIj7pRa1PSLgxB9INcvPMkfh4t1ATADbNSGEEPbCm41WSpEdGmM6aFYW8BP
         fnKHfj3jO+9RmL0gQhii+c5ytwYB5YAq14gaz549ipQVcJIjzUeixCzje3X2dnRffxbM
         o1lD6YVTYrsUPIeCsRbH4AAVea1OQy4oyop2gmtkuMiOQNzXASUElyGzqjT/K5K2eQOZ
         fbZA==
X-Gm-Message-State: AFuF++nbJqPc4o8sE3MWJcO6SAIjeI7iRGkqC5inwFCrub/suShalmoy
	Z3uP+YYbY/Bi9tmQ5BwKfm9ODdDQ6ZnfqYxk2AQhjm+msCk9VhVhvc6H6h/jnC54FSM6m9FFRJb
	ZWbl6no+zHzYgqtce7xcdHTI5ciwDq16nUh68XYANJcq3AM7c4UmY96E+MTFrrjjstnj7OhO36k
	yil9xuOr0fuODeF0a6x1QftNOUeFjQNtIbw7nlkqPMnRIpR0M=
X-Gm-Gg: AYBFou1kqA8M3fm66sOtBTsqQEWnPp35KvGc2vNKdCXBvsxmghWb9Fe21OMyGPPBM+j
	bap3/ejDBMWthG3K2vrbFQf5H3RTz4eShZMBU6VCi4JtTJbBvEQTkOo+ysJC9SLTsNy77LqbWNt
	tydMW7pa+ZECEP9C/zDkPd5fnx2LNc0ozKf60TDwHUy2rFDagFEG81onvgpri33B15cFURreubO
	NuTUSW8WOepH7vcTDC1LJ3ZNSZ1pAAFczA/oQCJR3y0HRQaOuBsjfWuCySvaVoT1CucDTppcNpV
	ClAD844+UHhYkVh0APsjZfNkltox6yzZ0FLnfsuhiL6U8VWTWV/CxveQSOKO/7tfD/LsWbE5/jB
	EtnXpdB8s00/Zij19kOs8cQL4YGk3ZguC+4e36A==
X-Received: by 2002:a05:620a:4492:b0:939:2c5c:7977 with SMTP id af79cd13be357-93c43c75a3emr658294685a.20.1790365538845;
        Fri, 25 Sep 2026 12:45:38 -0700 (PDT)
X-Received: by 2002:a05:620a:4492:b0:939:2c5c:7977 with SMTP id af79cd13be357-93c43c75a3emr658290785a.20.1790365538280;
        Fri, 25 Sep 2026 12:45:38 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c474fcfc2sm227375785a.10.2026.09.25.12.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:45:37 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	aalbersh@kernel.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] libxfs: change cache_node_allocate function signature
Date: Fri, 25 Sep 2026 14:41:43 -0500
Message-ID: <20260925194535.397036-2-sandeen@redhat.com>
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

Modify cache_node_allocate() so that it returns a 0 / 1 status for
cache miss / cache hit, with the cache node itself as a parameter. This
will allow the next patches to properly differentiate underlying states
and error conditions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index d5d9ba56..a6dabf92 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -284,11 +284,14 @@ cache_shake(
 /*
  * Allocate a new hash node (updating atomic counter in the process),
  * unless doing so will push us over the maximum cache size.
+ * Return 1 with nodep set on success.
+ * Return 0 and NULL nodep otherwise (cache full, or alloc failure)
  */
-static struct cache_node *
+static int
 cache_node_allocate(
 	struct cache *		cache,
-	cache_key_t		key)
+	cache_key_t		key,
+	struct cache_node **	nodep)
 {
 	unsigned int		nodesfree;
 	struct cache_node *	node;
@@ -302,21 +305,25 @@ cache_node_allocate(
 	}
 	cache->c_misses++;
 	pthread_mutex_unlock(&cache->c_mutex);
-	if (!nodesfree)
-		return NULL;
+	if (!nodesfree) {
+		*nodep = NULL;
+		return 0;
+	}
 	node = cache->alloc(key);
 	if (node == NULL) {	/* uh-oh */
 		pthread_mutex_lock(&cache->c_mutex);
 		cache->c_count--;
 		pthread_mutex_unlock(&cache->c_mutex);
-		return NULL;
+		*nodep = NULL;
+		return 0;
 	}
 	pthread_mutex_init(&node->cn_mutex, NULL);
 	list_head_init(&node->cn_mru);
 	node->cn_count = 1;
 	node->cn_priority = 0;
 	node->cn_old_priority = -1;
-	return node;
+	*nodep = node;
+	return 1;
 }
 
 int
@@ -366,8 +373,8 @@ __cache_node_purge(
  * hit, in which case this will all be over quickly and painlessly.
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
- * Returns one if hit in cache, otherwise zero.  A node is _always_
- * returned, however.
+ * Returns zero if hit in cache, one if a new node was allocated.  A node
+ * is always returned.
  */
 int
 cache_node_get(
@@ -457,9 +464,10 @@ next_object:
 		/*
 		 * not found, allocate a new entry
 		 */
-		node = cache_node_allocate(cache, key);
+		cache_node_allocate(cache, key, &node);
 		if (node)
 			break;
+
 		priority = cache_shake(cache, priority, false);
 		/*
 		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
-- 
2.55.0

