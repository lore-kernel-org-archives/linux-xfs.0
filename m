Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CCE175A7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714455978; cv=none; b=fyr/TbXAq/7Ie5TPPZYhBh58c/X5VXklPbVPKBJpxv7nIGXPTqoHzwb6Mh9CZMB018fjybVw6KLGk+ukd/d8Y+olFcs+H/ey9kx4G7X1UrKg0L2pdnFjRKJFb7rM7xjjz/wOgF0Usexqug3WWy7cg1Hlv5GeflHJ/wlvUPZsah0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714455978; c=relaxed/simple;
	bh=cbI4L5jmM7a0F1T3otBiU/y8RaR/WpEJH581bx8VU7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kODhoXh4zsE5r8eYux9sNUyu4UMoGBFSr9UJR92WMv8KltJINtHbMk1SneT5/81wJpduh4G2GgArGVDoBsFqqIAZhFoJJ+RPy+Rvvpc3cYrvVGUqPXZuFKRQnAiO4Gcgylo6rTuCi7KSpg1WqiuUz3BHAkEFTMeanAWz7buI28U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AH0si/FA; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AH0si/FA"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1ec44cf691aso1235685ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 22:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714455976; x=1715060776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhVbG6l51s2wWUsaX4UmS6UBTYaIND28KaQonxVRDmk=;
        b=AH0si/FAqdYeH6lMhqgK6JeKpobMK1QC/dL7agk6jQzSWMgows15oaPYF3iGU/2Ejb
         8hef9tJICif+clw5PmqTQooac8QAalBaix4KAdW6SPf9NHGYSr1ztuqaMF3MzxvjfsuI
         iH3XOPkY+gAWFe5r8pXLYFPhPcbTqqpA4YF6RxjVH9cM1xcLkA1nxrGIuOHjcEIOXabS
         oM+2ERgzyzZ51UuMA38XzEUakyR/tcIjOv+4O+rWzpIzXF8+A3goJdw35oVcm4s++6gb
         aQ4AcjvdgeSrkqVNhOSLyNq34GnfAXGGUMnU/tVMB6vgkfsXD756AYYj0t7JowMLoQv/
         epZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714455976; x=1715060776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhVbG6l51s2wWUsaX4UmS6UBTYaIND28KaQonxVRDmk=;
        b=us6qCVporQgDuyTJ0a/5uVYKA8LS6f9QSdi4/uDEA14nsxh6CVYhfbs7zTBcfXiDOo
         sjOGBvK6m4mJqIUth7uWZZaZBgrnLxMU6XNVgRTV639TMHrymQ9fjiyL59ne4oSueCVF
         QlfDcHVtXOgcB9GEEPtAVg9RZZNcCg5JzAa+VKITLwr31gvcz66OCFiWgom3txrTSiV1
         165dWON89dXb4Qg4UvgwFrFDUSCwcTdY1sas/dZup1ZIMwYjUZRfu+dmNYqGGiy62keY
         bK0YR2MQqqi6IIB0JpeH9BkhuLJprcoAqcbWKr517D2FnbkJQDqHizF+7ovU9qMWWDci
         fuTA==
X-Forwarded-Encrypted: i=1; AJvYcCW7u+X3DxOKoz1UGfvTh+UwE3kS3EItbS9D84AVWBiJbzLpE1E/+qXb4O44ZiTWves/YjAXc50Kwp69Fo7npDh+btCMxDawXFqo
X-Gm-Message-State: AOJu0YySGPNJfJr6pRjTK9kno6OpSkLKyi0o5AZ9xl2SQQ+Gvfq18LpK
	m+Da4JeTTUZXsCvnYW28j3FJRpbrTxzUiV3s8WN6sdRqKYHFBAjXM2SgpF73LeY=
X-Google-Smtp-Source: AGHT+IGmMVzjdjiJtHH11D0+CMXFMdRq/n5W1OeXzYwklrE0Jb2BQaYNgr6A90Q1Xy+u7Oi5ZpFZFQ==
X-Received: by 2002:a17:903:11cf:b0:1e5:e5e8:73f5 with SMTP id q15-20020a17090311cf00b001e5e5e873f5mr2610844plh.2.1714455975707;
        Mon, 29 Apr 2024 22:46:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902a70300b001e83a718d87sm21480895plq.19.2024.04.29.22.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 22:46:14 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1s1gJg-00FsCH-2H;
	Tue, 30 Apr 2024 15:46:12 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1s1gJg-0000000HUwu-0eif;
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
Subject: [PATCH 2/3] stackdepot: use gfp_nested_mask() instead of open coded masking
Date: Tue, 30 Apr 2024 15:28:24 +1000
Message-ID: <20240430054604.4169568-3-david@fromorbit.com>
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

The stackdepot code is used by KASAN and lockdep for recoding stack
traces. Both of these track allocation context information, and so
their internal allocations must obey the caller allocation contexts
to avoid generating their own false positive warnings that have
nothing to do with the code they are instrumenting/tracking.

We also don't want recording stack traces to deplete emergency
memory reserves - debug code is useless if it creates new issues
that can't be replicated when the debug code is disabled.

Switch the stackdepot allocation masking to use gfp_nested_mask()
to address these issues. gfp_nested_mask() also strips GFP_ZONEMASK
naturally, so that greatly simplifies this code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 lib/stackdepot.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 68c97387aa54..0bbae49e6177 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -624,15 +624,8 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	 * we won't be able to do that under the lock.
 	 */
 	if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
-		/*
-		 * Zero out zone modifiers, as we don't have specific zone
-		 * requirements. Keep the flags related to allocation in atomic
-		 * contexts and I/O.
-		 */
-		alloc_flags &= ~GFP_ZONEMASK;
-		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
-		alloc_flags |= __GFP_NOWARN;
-		page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
+		page = alloc_pages(gfp_nested_mask(alloc_flags),
+				DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
-- 
2.43.0

