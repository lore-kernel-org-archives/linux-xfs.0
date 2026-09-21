Received: from mail-qv2-f19.google.com (mail-qv2-f19.google.com [74.125.230.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC384A4990
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790001502; cv=none; b=eG7FlXYosM4hMZ9DT6DebD4p7yWwl711IEJNOGhTq9C0UlrXs8phL/R6iUp0Yhg6fpCUo40E9keebPiGF1QB2ACZ/SJ/uAd+/yl82EziqiW4Sbf5W0qvyydbP4hbLBQemjMZ5l6pD30b0WAXOvjBV5imay/9+l1YdCKROpI9Mas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790001502; c=relaxed/simple;
	bh=WD2Yp3+EWE2mTGIAQwbqodX+js0JKlX9BFhVIlsMEPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZBSBA32ZjkalIa4y88Tq0QbqSCSgFlqyQSXSKjgLJtQYEYgk8AmKnZU9ojiBC6jtVkcs+DUpKK2m8Yal9wX+SDDUJpuaYCl3W3a42Hjo70AO/vSUg3oIV4RDzTwyasb3eLbZ6gwfIe8mwN9xiAySUz+mEUnXdBO+OiOQzTBm+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=oqtCdEvM; arc=none smtp.client-ip=74.125.230.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="oqtCdEvM"
Received: by mail-qv2-f19.google.com with SMTP id 6a1803df08f44-910399d8b09so12292336d6.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 07:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790001500; x=1790606300; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1QYjUrUl2qml9sF2K+z/e51JYen5+cjRMt5pW8NsvQc=;
        b=oqtCdEvMQNUL8GQdomNeE+mERuYN6IIEB+RW7v5q0dx5rrI3tz6qZpTzYMgj2IELeI
         Tlzww7+taQ+v2fsUhpExKDeHTkfAe1LHaI9K8NvrMUEskYfYTJ+hbpJDbnTrNM+a27Rg
         hg/X9V5TMcNNNayMC4D2LbdDRrzbzJbKdgwsva/q/73HkRuELFiwSIwJwM6mYI4hbgUI
         YpHBG01WACyZbclEu1wO5xpO5L7Mq3gY/xUGzB+J1hEbuvTZv3pKRjgVEcnU/y87bAlY
         mnIKmZfjQXzIwzKlTjtARlTx3mgspj5J+bTG0jU6FTL3hYMXQ5hMY1185FfvfXcmD4os
         WxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790001500; x=1790606300;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1QYjUrUl2qml9sF2K+z/e51JYen5+cjRMt5pW8NsvQc=;
        b=2xNkulW0te5Kn8HPFQriji2uRPnesZXFteugtyfbS+miuztyf8mi2El6jxa0xFoedL
         55UlG9+fQll0/U610CEIBrIt73FFJRfaocWZ5kaYbHdo9gc17P/faSpAs90pTwnKMEew
         iFS90jAaLtZoHOm0Er2rjq4EfBYVUUKziTwgbqmRnccwpCXs4UzPOhJRWRefZI5+Bz/h
         Z636/IDdcqXFOI8gJx50bfNQkxFIin1/vWLZ1K/VaUxan0icS2OxI0u6DEBob3G3Cdhj
         K1hAHqipczXd7FdouCyAYu7kGuRzpoGsnDg86WswcKsBBxxAICk7H33VJ3+iNdWLUxTd
         DGFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHd1CBSs6w66qKMthOOU8FDb7ZjqYu/u8k67L45/v1kJrWksusRyOiG94xIAxJNK+zLrUIAeFryQU=@vger.kernel.org
X-Gm-Message-State: AFuF++lUEoM3JDYJYfNGqR1/1Ve2dFaVA9WC1dC7eBO1M2R00NzpkY37
	FOkeuNEG3cLnqcWe7Jd95Phce0vBauND27j4vRJBreuHvclbY3Z08R7+M/6uIQx9/y0=
X-Gm-Gg: AYBFou1JLkQ3au9dUCjf6bD5r0OC4BWVk6GwiVNdewlNVu2lOSK/GVbrdkOrVgNeqTB
	HU+uay+sczrJSvr+E8PslCBOkfydBPwj/75GB82e/6gNbh77HHpV7bMkfsdkdwq/VQHgVWCkQH1
	osn33cFnzNjUVMhUzd0Qt20m0Jy1qF+F97P+6nYI8DP6uYSCl3rAq++jPJLsNjBmaIuOgTtmE+X
	BLbK8R4FGGxg5EUyl0Fa6SS57M4Bh6x5hFtL48V95WmSychJDutp/cAI8coXBMSSUII+55om2sK
	kAwBKPv98MjhfNTi2VFTnbZIKrBL+I6k+ZcmKyFIRc0+wDqkPvBDS9zaGBx+zRBQGYhGTyIE7OQ
	uN8yXcOebTfjPPXfPEweLGrFQJ6tiM0Tb685l7ADQ34W1UmfMj0flVSKpspmGXEftGMPdf36BvY
	Pwi/25QfcrvFveDkfoJF2PwcDVmS56Ms2wYHMcBhsY8l/RE4KjYsed0V5qusCP9zLckZW34Q==
X-Received: by 2002:a05:6214:f25:b0:910:3c08:fc6c with SMTP id 6a1803df08f44-913fc8c6d74mr9199966d6.22.1790001499563;
        Mon, 21 Sep 2026 07:38:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a85c7bsm68848416d6.32.2026.09.21.07.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:38:18 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:38:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
Message-ID: <arFBWvzXPYrKuIYi@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFBJdYaRx_iJNDA@cmpxchg.org>

281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
highatomic reserves") accidentally gave all non-blocking allocation
requests access to highatomic reserves, which includes GFP_NOWAIT and
other sites clearing __GFP_DIRECT_RECLAIM.

While this improved atomic request success rate, it's unintentionally
broad and can actually worsen highatomic requests by squandering the
reserves on requests that don't need it.

There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
for costly order __GFP_NORETRY requests, which would have then also
fall into this exemption and deplete reserves even faster.

What GFP_ATOMIC has over the others is __GFP_HIGH, which
alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.

Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
ALLOC_MIN_RESERVE.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 4 +++-
 mm/page_alloc.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..7b46d0ac3a56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page &&
+			    ((alloc_flags & ALLOC_OOM) ||
+			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..ad89f83d1dab 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
-- 
2.55.0

