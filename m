Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D694E36D1
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607929; cv=none; b=oFy+LpSYsXkTOk/+kzvO658t4xaAjTd7BKKczplVDenDdQuaCldZ/MmbcKrGuovUaxS7kA1/qU1pMXjxKpj2eQV+X2drPIuFWJKTV9jV0zCMLT0bqhyQgem1sXvS+RKsXk4JmF45r6hB57LQRYRP559nJnXi53dc6DhH1+I1yoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607929; c=relaxed/simple;
	bh=7yMsLmsC12+LlWPS3+wd+uajBSI3FhxyFW2GmkB3TWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eH6eW27XU2HYRh19RqU25dDBAzKJNoAkqt/C+VrA23Yo/mQfGPM3OyEvJ43m63gqG1CQrmq3uYBOIAd/+oOZWCRzrVJ42TDp+32GcGjZUSAW6s59wbXc812A8zQT7oxKy8xDGHFoNpNSpq964C5n51qhyDFGjhA6jhIOX990tZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=XWX3xBpd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CGq7uLyn; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="XWX3xBpd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CGq7uLyn"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id F0CE91D000D2;
	Mon, 28 Sep 2026 11:05:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 28 Sep 2026 11:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790607926;
	 x=1790694326; bh=rtIZhUdXj1U7yCpknGYWk83Jq4+tkdm8JEK4TgD8MSI=; b=
	XWX3xBpdTzUdDNRq0Q8MOdJShKrduXP9cSD4q64kXpgCZnRHXgiQh6HdIXuz04Um
	uq5psUW4czndrj0JWYGy89cZCC7EFOFWXxzaTL3AFuqQewlPVjquWA9TZk3v3A09
	c5DzKLiNfPD8q5+J/3fIq3+wx0QEA/xdahyhonG7YwnOjokRP5uSItLcFpy0Vxla
	ocKIcD32lKg5SKaQULEbH5BTN4CmEs4P4XctX4n4DbIleU6Xlvq+G5XUWYRDIWw7
	lH/3CrzRrnfR6bHV5X5MaL5CbOeZhGPi5G7PDST4mrpjdKqYi7qvHcu4iWZfSXCn
	SE+Q9ebFfBUnMdX+EVMKKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790607926; x=
	1790694326; bh=rtIZhUdXj1U7yCpknGYWk83Jq4+tkdm8JEK4TgD8MSI=; b=C
	Gq7uLyn98t0wwAVUv1/s5wgQ3ymQ34bb4Kn9+vQdNhOi2cZ7Q5fpjrpsRcTuBVI2
	isqg8lct6/17SD9bTkNZdOifhpTAw8YTvO0Fs/r0amPVrI3ewM2Bzw0IcHTwMLlz
	X9wRvyhV+WO7yK0nkpSfprH2Rw6Y8C1Wq7J4eWatcdrBfrc+u3UmiPcga86Z9T4Y
	J7BO9Obd+o6pE1hzHpv5EN/E7+FfAfIh+hmGk7DkrPJs5lOD9AWeHiTmUNIVOPRU
	w6NjVsuSBj5JvMu0DvM960UJBJlYX8c5Lqoy4CN7NvS+3l8LKMEcz7OVFp8kC+0C
	o325FsusC4g6ZQm1aGJ5A==
X-ME-Sender: <xms:NoK6akePC9ANz_QfSm5M_zu5VuqTwHSd3-4SUhqQ-6yXwFsWryLbNA>
    <xme:NoK6atGxRrpHDqOg-SwavFogsDpzq1xjzGuBH7oVWm9zEZ3dIF_SQ0B-BGJ56loU4
    iDTRvIJnKciesIZCW3KOVT6WqlXOUNNy9aczrdx1Nvd1CwJXnS3No-f>
X-ME-Received: <xmr:NoK6at0OmqFbNbHHBPtVzfX2__rnyo6hsd8wluKEcpnE-wisZz8303JbPvvXEtYiUV3pcFoGlkbySKxNw9qfTDNplasa5Q>
X-ME-Proxy-Cause: dmFkZTFhwObGEbQSwwe4s4508/8/XHWRLT/VRSjzlXJlIN61NXjKu4Q9gK/JQAsX57BDH4
    AjVOwRhnkWHQDxWpVv0BGT+FlUf5Td8QRnkQ5Lriyls7QzxizlN7PS/Ox6ZfYfm5YSHRdj
    CKpcvVyJ66jwh/kTK9nznWRu3LfPtMO5uUo0vAqWuStPq+owLKci1is5XUNwY/rr87Pm6H
    fFEc6vga8KEZLHRJTIDDg/i2FYU8M0w9dHCUQP+4l3EHsdCAbVJg0g9czRhIWQZ1V/fshF
    OUnj6SfdPHMgv8CYkAPyJnNnyFbcE/De4ii4FRMhn2WWWTp0BkXfZ2JUhm5EiqTyQ5l0Zx
    80etqsWwmzp7B6upMjxKgd0ZOM9jH8Xu/pVvpuhCJ+ywg+uBJHXrgcro7D2TXtJXg2irRS
    soUfGmGnQxnENs+5MQadR3aWmJcRs3s3jZsjDqHm7flMkEfhxHGu+sAjN8Ac/02ZSzf1sa
    GExTRRKQdAnOMrUh9WbGiSnKHkXN73kMPMZsZ3D48CIDOv5/sTD2Qz/q0Ol4zLag2hXD6n
    6EfGCXzC2T692XpYs/C9lp4JCl1CvaJELX2/Cl+Sbz34iWB5UoVeU88DTe0dihQZlpuu2e
    lgTQJm9azv6f6TYV65qksi4SVXizTlBawkJJokrKfX7TdxjswWwjg1n48n+Q
X-ME-Proxy: <xmx:NoK6alkMUBc7C_j9eMZtmxu-bSUSHfuf8OeSYaSdZwZ2IZSo5ziqXQ>
    <xmx:NoK6at_0Tp0et_4Z-3AKCXuX2XVQSxFui79psA_fk80VCGfa0hF7Vg>
    <xmx:NoK6aqr2Lg4eU8ZkUI5cr5BmmN14lzZWXQXd6CgvktmAhQaJM7Af8A>
    <xmx:NoK6amkKjWK3WIQu6Cqw-_AjIO_OxK3KIP6AtKqz0Y7z77nTIygLwA>
    <xmx:NoK6amq17HUoO0v7QxP3pxQTOqYQnkba-Co4iHEWpdmIHJQn51L5x2rY>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 11:05:26 -0400 (EDT)
Message-ID: <fdc58c69-3a64-4638-a415-9140b98f5d7b@sandeen.net>
Date: Mon, 28 Sep 2026 10:05:25 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3 V3] libxfs: better cache allocation error handling
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, aalbersh@kernel.org
References: <20260925194535.397036-1-sandeen@redhat.com>
 <aroiYIl-CQ34_qee@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <aroiYIl-CQ34_qee@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/26 3:16 AM, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 02:41:42PM -0500, Eric Sandeen wrote:
>> OK, 3rd try.
>>
>> This is to handle an underlying problem that an actual ENOMEM cache
>> node allocation failure is indistinguishable from "current cache full"
>> and so ENOMEM may send us into a pointless cache-expansion loop which
>> ultimately overflows the cache size variable, rather than just reporting
>> the bad news up the chain to callers.
>>
>> Darrick suggested "I think I'd almost rather we change cache_node_allocate
>> to return int and the cache node as an outparam since we do that elsewhere"
>>
>> on the last review cycle, and so I've done that here, I agree that it
>> is cleaner.
> 
> Sorry for chiming in so late, but wouldn't it make more sense to keep
> returning the node, and have a bool for what to if it is NULL?
> The 0/1/-errno pattern already requires a lot of attention in the kernel,
> but in userland where we have errno and -1 returns that are usually not
> specifically checked it feels like even more trouble waiting to happen.

Well, "[PATCH 1/2] xfs_repair: distinguish true ENOMEM from "not found" in 
ache_node_get" did this, which is what I think you're describing?

 static struct cache_node *
 cache_node_allocate(
 	struct cache *		cache,
-	cache_key_t		key)
+	cache_key_t		key,
+	bool			*enomem)

*shrug* I really don't care at this point, both versions are on the list.

We can merge either one, or none of them. I don't think this is worth any
more effort. :)

> That being said, the changes themselves do look correct, so this should
> not be a strong objection.

Fair enough :)

Thanks,
-Eric

