Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904D175BD
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714455978; cv=none; b=o0bg2+1wbMH7SMYt3thYOuylcSuvlikDupvRFWOo641if7uJkklZm5/pbmo5Uf4RakN+YWebXLD+jxIIT2IR4fJ9HsPpm/WuPi7NksB1PZUAN3h37GdfIAnSRPACyCuUC3Mn22+wuCBRCXbAWC/1L8cqUg5lJ3dE35zS+2wIlNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714455978; c=relaxed/simple;
	bh=rklAlcuzru+bqakhNde6fP9kM5F5zQ6q4kfJpIR2Mbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fa5PTp12Miz+JJT+67BRD7iAYYNsyOU96WectMmz++HweOjbWKUpaySMW/9vY9EFdfUJjaqdAM+eVB8oki92zEJPHukP2r8ci0Urkn+5qGh8Tiva1Pggv15y+9gdUVWjDqlsn6ZjvU3zQ69DTYOjW/DAOMREja6OgyELiYwYFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=w1PO5NiQ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="w1PO5NiQ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e86d56b3bcso48251155ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 22:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714455976; x=1715060776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afP6uLcLEQVtnVJJKaVxA8xiCeVS0XyPUQmW3bND5yY=;
        b=w1PO5NiQJm/oS2HpkM8Lq/XOS+EAfoLTHQyCnzw00vQ1GOBB/HErOLZgf+G+DmcSQU
         AdqPVFcFPtUO7NTwTPsbGsEW+5+3jkMqLESHie4A8IwWUcTA8x8gfERPhpLQY3CJbtvm
         jZAnC3NMVbSUzkRFXpLETY4SWhvKGWdTl2LYqGutiu0xp6bfK/1pj9BIwCL49hGwkPW+
         XWph/jLu0DRLVsFng0LdOPFAKqqNmAnf4LnvrqZxRyJnYa3MR9VbDRdYUdOVw1o/Jviu
         0XsSUSIKac0ZR5bKXsUObc8SFGnmn9K1oCojtH9R8t6Q/wWCrR1Ho/rf0dlE1F1ULYPG
         m4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714455976; x=1715060776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afP6uLcLEQVtnVJJKaVxA8xiCeVS0XyPUQmW3bND5yY=;
        b=GErcpY1jBYt+lruG+uGO1V06mChEgo5GfSBfP7QWfgqzSC9XGPnS8rvRbtXjXBxzRa
         ON+ANUhbK7K2yYe97B6kthi+QcOGKa8WN78183Fk3Hn2tpXp0nQVPBsXpnM7gSjyEjms
         YvKnKPoP3OL7VUZdlAZyeGC63KihqafxEqgZb0UuGxB0GYYxCH6BHFj6mBDKxPiEsl/g
         tNS2l2WfRXpT041QMfYCjtu4GhX3MqOwTEhbO2caONfkbn08fGC1yPNPS6o48FMrbZr+
         tVGcEDdoNpSVxLmgRMmoMubW3nUx7kKpgZ5Zy2bvKzpLLsGbop3yR0Oto3NOw/KeJOGH
         5yNg==
X-Forwarded-Encrypted: i=1; AJvYcCU7LQLOvMe8C2SqgXUZVC8sInnDxzwscfNQDOI2u7GZmETWXI2SBAd4+gXdu0EM6jPemrK3WDZ4Jj7bIOfofhGXKs/ln03M3YLY
X-Gm-Message-State: AOJu0YzVJTfaSoGn24rcATx/XUZyBbpt5lvF4eLV6v8UXT3ryr3ZnyU8
	/mddCMmvNc1nxop3HoKr6NFLDWjP/3UPz8hzK8G40S7MB5NlrRwwFWeZyMgLYVWcYC8CCX3dDAS
	N
X-Google-Smtp-Source: AGHT+IHfRat6F8yIN7+2x4pzgcpjky23ySzyPfrQ6r5F2OTC8Is4yOECP718T/VXfznbNFuUF0NMLw==
X-Received: by 2002:a17:902:f60f:b0:1eb:1af8:309f with SMTP id n15-20020a170902f60f00b001eb1af8309fmr2194540plg.4.1714455976018;
        Mon, 29 Apr 2024 22:46:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902b68d00b001e8a7ec6aabsm20267530pls.49.2024.04.29.22.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 22:46:14 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1s1gJg-00FsCE-20;
	Tue, 30 Apr 2024 15:46:12 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1s1gJg-0000000HUwp-0TU0;
	Tue, 30 Apr 2024 15:46:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	osalvador@suse.de,
	elver@google.com,
	vbabka@suse.cz,
	andreyknvl@gmail.com
Subject: [PATCH 1/3] mm: lift gfp_kmemleak_mask() to gfp.h
Date: Tue, 30 Apr 2024 15:28:23 +1000
Message-ID: <20240430054604.4169568-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240430054604.4169568-1-david@fromorbit.com>
References: <20240430054604.4169568-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Any "internal" nested allocation done from within an allocation
context needs to obey the high level allocation gfp_mask
constraints. This is necessary for debug code like KASAN, kmemleak,
lockdep, etc that allocate memory for saving stack traces and other
information during memory allocation. If they don't obey things like
__GFP_NOLOCKDEP or __GFP_NOWARN, they produce false positive failure
detections.

kmemleak gets this right by using gfp_kmemleak_mask() to pass
through the relevant context flags to the nested allocation
to ensure that the allocation follows the constraints of the caller
context.

KASAN recently was foudn to be missing __GFP_NOLOCKDEP due to stack
depot allocations, and even more recently the page owner tracking
code was also found to be missing __GFP_NOLOCKDEP support.

We also don't wan't want KASAN or lockdep to drive the system into
OOM kill territory by exhausting emergency reserves. This is
something that kmemleak also gets right by adding (__GFP_NORETRY |
__GFP_NOMEMALLOC | __GFP_NOWARN) to the allocation mask.

Hence it is clear that we need to define a common nested allocation
filter mask for these sorts of third party nested allocations used
in debug code. So to start this process, lift gfp_kmemleak_mask() to
gfp.h and rename it to gfp_nested_mask(), and convert the kmemleak
callers to use it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/gfp.h | 25 +++++++++++++++++++++++++
 mm/kmemleak.c       | 10 ++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index c775ea3c6015..a4ca004f3b8e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -154,6 +154,31 @@ static inline int gfp_zonelist(gfp_t flags)
 	return ZONELIST_FALLBACK;
 }
 
+/*
+ * gfp flag masking for nested internal allocations.
+ *
+ * For code that needs to do allocations inside the public allocation API (e.g.
+ * memory allocation tracking code) the allocations need to obey the caller
+ * allocation context constrains to prevent allocation context mismatches (e.g.
+ * GFP_KERNEL allocations in GFP_NOFS contexts) from potential deadlock
+ * situations.
+ *
+ * It is also assumed that these nested allocations are for internal kernel
+ * object storage purposes only and are not going to be used for DMA, etc. Hence
+ * we strip out all the zone information and leave just the context information
+ * intact.
+ *
+ * Further, internal allocations must fail before the higher level allocation
+ * can fail, so we must make them fail faster and fail silently. We also don't
+ * want them to deplete emergency reserves.  Hence nested allocations must be
+ * prepared for these allocations to fail.
+ */
+static inline gfp_t gfp_nested_mask(gfp_t flags)
+{
+	return ((flags & (GFP_KERNEL | GFP_ATOMIC | __GFP_NOLOCKDEP)) |
+		(__GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN));
+}
+
 /*
  * We get the zone list from the current node and the gfp_mask.
  * This zone list contains a maximum of MAX_NUMNODES*MAX_NR_ZONES zones.
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 6a540c2b27c5..b723f937e513 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -114,12 +114,6 @@
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
-/* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
-					   __GFP_NOLOCKDEP)) | \
-				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
-				 __GFP_NOWARN)
-
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
 	struct hlist_node node;
@@ -463,7 +457,7 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
 
 	/* try the slab allocator first */
 	if (object_cache) {
-		object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
+		object = kmem_cache_alloc(object_cache, gfp_nested_mask(gfp));
 		if (object)
 			return object;
 	}
@@ -947,7 +941,7 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 	untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
 
 	if (scan_area_cache)
-		area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
+		area = kmem_cache_alloc(scan_area_cache, gfp_nested_mask(gfp));
 
 	raw_spin_lock_irqsave(&object->lock, flags);
 	if (!area) {
-- 
2.43.0

