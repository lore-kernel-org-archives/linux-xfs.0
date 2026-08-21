Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811D2D738F
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787351203; cv=none; b=WD1aUZP90L9bISCxneNvT+ZBawVMYuD3xKVbvmr/3rgb7aj1p6ZCUDvOZkCZ99iInzZsyxEdlNDGVGoWFWVsY6Xu1Hlnfxkk7iK0cRJsYEjf87TDQ+8EhFfF9arrRFv8DsikV1nGUzWJWYEAHM5cBOwmBOB+x3AMUCvMFj7IiQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787351203; c=relaxed/simple;
	bh=SdX7FKMP1tr9sactshL1v2mGmOg6RyCasWsGJN/f3Po=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=hKw2zJ8hsiJKpGb4dgiWNl+V4Ks8TlzmIXKRf0bxelQ5od2Wdo/oaKe0//0mNv2lcIBHiVh37mv7LoIMthv0ojmUkESojq5JgDUj+vgkyIIFzq88SPb+yn9dEEiaihZ30dmq82AjBDf2I4ElFWZYGGJGn3GisaJd53KvT6sSmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=YLwT1HHG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g8KpsaFG; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="YLwT1HHG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g8KpsaFG"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id E30E7EC01A2;
	Fri, 21 Aug 2026 18:26:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 21 Aug 2026 18:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1787351200; x=1787437600; bh=SU
	k4J2OhWpDSgc+XBnSAxjw7zaT4DKu9gfQqll2pV0E=; b=YLwT1HHGrPOOXVVVcq
	bWjsNhMoIjnmTLNiaxouUvQkV4AmqD/9daItu13CIA5M9LQdKANWLK2MTRbDpyY7
	WaxzP+u2gj/FaIN82fVkNw7PBbEuMZ8IMp0ZWeMMIeLeQDjuDfIYbvoQCBOGBrqj
	HFxgdJAffWfkraMH2t1XX2R42TPvmNqvYEgNmHQj4VtdGook8dsGwUzSt3Lq4fxH
	4QYLtkXhh5D0T7xCb/WbPbsCXKjDG0UznDyv56Kd1hzUBk/ntzMUNiKXiVXHQQpR
	MNhbmF2Wz0/6O4EqLZixxENxtC+U9xAH512IWvW1K066r6jJ8yEM6i3hCPWQkPp0
	4qKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1787351200; x=1787437600; bh=SUk4J2OhWpDSgc+XBnSAxjw7zaT4
	DKu9gfQqll2pV0E=; b=g8KpsaFG8Xevd3zsyqiJMSUIUWMt24a/qZOPQ/bNM40l
	CK2caykyDwjgMOZPL2l17fEj/O97o0TK/bQrZuagm+1yu8jWQhXaR4mteAfTJwjR
	qCJEBheESffItan1+qeK2N6n3nka9vI1wAVaWKmslD+tCAGIa+fxeK20p4+GlP9d
	zRzMWa6b2DKA9++rxeoc3eydN1m8SSuDO19+zNJ+K7SWIlPusGzygOa2+/WGL397
	pfe75wNjx3ueuvCUE1IBJzzmGaFpqA8hwx4sYPQV6TwDoLHuvee2xCBzxdEtY1qR
	9ex4dp1Sbq2rgr875h9U83zTgx20bTXt7rEGRMonDg==
X-ME-Sender: <xms:oNCIamXVikd5raw3krap_uZ6qYxciTNir9K2ONvaaC44KyeXjZPq1A>
    <xme:oNCIaok5hVmMJbjhyt8b29PAtUPnHELyMtjxkNQxoJ1GeL3J0X2ZWBJ35x1ugsR23
    gNl6TCn-Ym22ILC97Ek0vnRAKaelfoXXe0b0hk00Aa6oXcC2QBW>
X-ME-Received: <xmr:oNCIaoCL_9tLCMjjdKKDvaqjnsUSVBQJa6BkT5nP-cx02-IX6lDDCtSTYD5bg1COm0l48yeJ-H2LL77bPLpOykTm>
X-ME-Proxy-Cause: dmFkZTFgheFmPBI72l1GcuDFoq3TQx1pYRhCk7yPNz3xsT0slVQAL1zNiEWVqv5U5qmBL7
    kwOjUogqwVmo0OPwxv35yVZZfb04E8uWlaGTSTr6VXYNXlySXGcbPbUgWMLV0sHVwWHy57
    4mvz6SvDWXhNjv33B/FR+fpg7G6f8EPqPoCvsZZtCl/ZEExKJSF+gWj3UJBPz9cvKL41cj
    i3GIWMx+TX3IkDqvQe82D521mzsE7HR+R5W4m8rAnMCMZzlMjbDqiVTNMUOxS7rT6BKDE/
    AfzJsW4yecU3ahH0ReS23vk4N4jfdVDcHw7fqZ3eyuced7To2UITiH63SaXfkqy6qVN9OL
    j/AiSAkwzRrK7RM66BYKtqik80qdP6P7qA74m+vgLF5T1gz/DRDDugepi0RgPy7HtLH0Gv
    tk3x5PQFuHY7XOQAfDaSFcyjmhotrgvCshqefDPV+qll5nm35H355JssWXwnioQ9DBgOT5
    L1W1vmQJaz/Nbqzq/pZ1u3CuN/uoedWdWu959HDqu3L+ZJrwSIlhHnua9D/LWoJjC2BnfZ
    MGWk6+Z1O5ywNkVaGRX8v0+56anNgdrxiQpEMA8sLB/oLcSTDmfYjh/heohFR8Y1IS5+yc
    4DzGrwTDTpiKVAd2L7tx3fGhWaf4xfekHHKylj+w5csC96sQTRd8fetLCjrg
X-ME-Proxy: <xmx:oNCIaoeu_QQYInPZR2KtiRdzhVYLmIKCtLtP6tnhysCK6wySdSYxzw>
    <xmx:oNCIajIXC-szEJV5pch4ORVxsfVEbFxa6vKLs_ya-xXAR98WkNknpA>
    <xmx:oNCIare3P2bq7ukVCmH4n-ow90BD9HDcI-G0a2cenElqNyxHnst1nA>
    <xmx:oNCIaq1VeLLoyE9uznmlODLNHviLj75ErcEFLypbkImi1RY5YogAfw>
    <xmx:oNCIakode0qy8H7X3yzOV-pPvEWy5GfhGlpo6RcKbxDgLJss_JR0KSIc>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 18:26:40 -0400 (EDT)
Message-ID: <ce64892a-c991-486d-8650-d40a6452699e@sandeen.net>
Date: Fri, 21 Aug 2026 17:26:39 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH v2] xfs: mark slab-allocated xfs_buf backing memory as
 __GFP_RECLAIMABLE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

xfs_bufs have a shrinker and are therefore reclaimable, as is the memory
backing them. Mark slab-allocated backing memory as __GFP_RECLAIMABLE in 
the kmalloc path so that it is accounted properly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

The other part of this (non-slab-allocated backing memory) is thornier
but I think this patch is simple, correct, and stands alone, so let's
see if it can move forward.

V2: tidy up title/commit log to clarify this is about the /backing/ memory,
    and add hch's RVB

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 48d7dfd3e15f..2e00a33ebb62 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
 	ASSERT(is_power_of_2(size));
 	ASSERT(size < PAGE_SIZE);
 
-	bp->b_addr = kmalloc(size, gfp_mask);
+	bp->b_addr = kmalloc(size, gfp_mask | __GFP_RECLAIMABLE);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
