Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309B14D7978
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789574327; cv=none; b=txqBnVVFfKZ9HUPgvNURPwFOjlkIpd3j61Ak27EAgX+B10QxHcSVMT/pHQkL0d8v9fpC8OZV1uacuzXAKVGXDdBQsQehOysGD8pmgWZuIVXmlVstR4gjOVy5hFn4znXvOAtZ9tjVmI+AWjyyBzVQ2w2YEYva4bdz0renkCPZftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789574327; c=relaxed/simple;
	bh=+6aMjHH+Jl+Ml/kjCyAc+ni40OSaFZs1senFwZLmkis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkvYLJOf9xvJ4jYD8vwecZZmcdV7T+Ic29C7p7+X6JOaxLH7lrWtnyhx06mQiB/ExILnUtitL0E21eikBHN0b8AYMvVgvqoSAQM/5oxGXOA2iuUUnGicUcGJgf/+q4SSigYYYI3BDuvNbA+vEScJKpGQsgZFQYMrWzjT6BG81Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=mxy947Qa; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="mxy947Qa"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe208so11092386d6.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 08:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789574314; x=1790179114; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bjcBGUR39i2CtxsYZA+y8R1kv00jh+PXwHXxQnV1eiQ=;
        b=mxy947Qail07AL9t2Ag0dSp7kFCQr+bAzVIypiyzW0zASsfINssXUmISG1WGaiaxL9
         zMAIp6+RhmhTn4fPH+98BVQ7RIBBHGYvMJyFE+4/n6rubXroqjT1ofD3x7gSLqKAsZIL
         Sq92DQFsU8zhBvSCtlYaBNSrEQh18Awe6Omn32t82761kFBwE7EL0rqpnQ4QvucznX+z
         o8o1c48JZ+9pIgd8xih/5XrUvEGwFXbv3XaphihX05pMeqPSiqKen08/YeZdeXsOBFdD
         Tvnxc2uOOrhqL56m59ngfpsIWwWFEH4NN1GvRoGx6uZ82TmniIt7+/aD/m5d6CO3Xwhi
         bGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789574314; x=1790179114;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjcBGUR39i2CtxsYZA+y8R1kv00jh+PXwHXxQnV1eiQ=;
        b=ifpeswpeXK7FbetMr5MP/Jw1LAVaW9jkFxNZh/kjmY/z2SWkzngNl6obcVdX85nDy8
         TW0Fgg5Ce36FiP+ZWosKu/uREWJYn88nqmNN3XkzHA32pIdo5vdT1Lt7YUmdEqkxgzSI
         6GSTrcm63yoCKnkQYuDsERJVuHn3BnENpdrkmj1evEgc+tGTLpoOD8g/e4Dsb1BvJ5gw
         00LcsgvBknb9FvBeNw02sxysZN0dUBj5ylMpG1VHUiah5HL75E69t/toOiPY9cbBz2ur
         tgzHnCO2gt0529DBYXZ4Kdzj8wR0sDqQwTkhXSf7N79ejvHH5Pczr2qyzk5/wC0eNs1V
         3qlA==
X-Forwarded-Encrypted: i=1; AKwUvBymAPYUy9NqRaUrv+5KUZm86F0R2abKGCgYgvQ81imukQf+lz4fJdjkFvG6bfscdHaYPA75EpeZyys=@vger.kernel.org
X-Gm-Message-State: AFuF++k7Toal1q1MKlnNYsDn5HSEybH8tQuuGLKflobDnVzhhGKE5Xzs
	v+2R9lh53dMvehdLyjsXA02HX2nrOrFBZNpsHQgKvGdqdTyoZ+2asMRJWFqZD2mYeXQ=
X-Gm-Gg: AYBFou3RA1oMwMtNAdS+q9Tm19xaQ7RhKSBwNqJxxI9sq4veFkfij/Zv0/3CSAA5aFr
	MUY1gavjgeZSNFyaO5N6eeYKFwa/xUOU2bMPd13ofr+Jwcjqqg/gVTVvDeObIzDlQh9kNGRoaXU
	FeJE6qXvCKSfymHDNtxaVR9r0bcOX/6L3sCmk2dKgU1kE15JimNCPtwkMbRzWezWS6rIkqB7ghC
	cyV05k8XmTvmKbYA319jglpJaGp4193AmFNQvLWVUa6SF/DOzRUZ01VsrKlosBjsLKjqr31v8Sr
	ctc7cPinX3rX3Q6Syu/B3tEfT7eJ0IfrVs5DaQSaV+O8huUEhP3aEe6/LZ8qPa327UbsXZJYpH0
	z6x95YpOWA6VjR4i/Oi4LzDH/+YpB28s3oIFKLES+Rncor+kHdnZ2fU+qsPk5rm42KmNGU6IKbu
	PtQZo0Qt1VkSIqGg+xhzhYLEmTNTJDL1ZYCMv+XZLeIZo1Ph7ncBduOXNKQD2J1DFv5Odngw==
X-Received: by 2002:a05:6214:1248:b0:90e:96d1:40d3 with SMTP id 6a1803df08f44-9123d7a5b32mr54271566d6.20.1789574313980;
        Wed, 16 Sep 2026 08:58:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be609dcsm28537916d6.15.2026.09.16.08.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:58:32 -0700 (PDT)
Date: Wed, 16 Sep 2026 11:58:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqq8pWI0u1IZNWHT@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>

On Wed, Sep 16, 2026 at 01:24:31PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/11/26 17:59, Johannes Weiner wrote:
> > The access to
> > MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
> > seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
> > into the highatomic reserves as well, for example.
> 
> I don't follow this part. For ALLOC_HIGHATOMIC you need __GFP_HIGH in
> alloc_flags_nonblocking(). So GFP_TRANSHUGE_LIGHT won't get the access, no?

rmqueue_buddy() has this:

			/*
			 * If the allocation fails, allow OOM handling and
			 * order-0 (atomic) allocs access to HIGHATOMIC
			 * reserves as failing now is worse than failing a
			 * high-order atomic allocation in the future.
			 */
			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

It says "atomic", but it's checking only ALLOC_NON_BLOCK, which is
broader than GFP_ATOMIC. alloc_flags_nonblocking();

	if (gfp_mask & __GFP_DIRECT_RECLAIM)
		return 0;

	if (gfp_mask & __GFP_NOMEMALLOC)
		return 0;

	alloc_flags |= ALLOC_NON_BLOCK;

	if (order > 0 && (gfp_mask & __GFP_HIGH))
		alloc_flags |= ALLOC_HIGHATOMIC;

So this can apply to random !direct_reclaim requests, no?

I have to correct myself on GFP_TRANSHUGE_LIGHT because it happens to
include __GFP_NOMEMALLOC, and so won't actually get ALLOC_NON_BLOCK.

But what about random GFP_NOWAIT and & ~__GFP_DIRECT_RECLAIM sites?
Those explicitly don't get watermark exemptions already, and weren't
the intent of the rmqueue_buddy() exemption above.

Something like this?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..c79cc7aa4dff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3246,7 +3246,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && ((alloc_flags & ALLOC_OOM) ||
+				      ((alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..11714ddca254 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flag combination from GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*

> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> concerns can be dismissed and then indeed v4 is the better version.

It looks like a real issue to me, but one that already exists
independent of Salvatore's change.
