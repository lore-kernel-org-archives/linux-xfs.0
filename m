Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7581ADC86
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988282; cv=none; b=AKtRrkaSf5kq2WRYBggdDqbYdVdhzVDGEKOzwUWtScfzuYqU0+fkGRQSJW7TVDQ08EPteC9qTCUDqZlYwKlnEPVGMoVNW8r7eaeH5m9do+zVvjOVGk8z+f9KO4fmsnaNqsXa8GOcf4yREDpAQlgGYZPOfR/IblXuqlLRUpA9ifE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988282; c=relaxed/simple;
	bh=0fzyFU1q0nnzP3wTh6Pnqytw6wbqimaIvNnudRX1oDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8qWwg+PCTpLOru6jOnpXJZKk8Ya0nIyONSUJV64H2NFPrSBNdxLjBStPbqkPI3fKbPvgIzKwqgN0AKJBXy6TF4laAafpRSGqTOGigJkRRpSnwIDpWpjPocRKBmCrvKSmWnbmI6pF6hQWTOQJ2XaDVKBpmlEJ/IYoP/ctOYHwmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=g9XhxqKG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sbLpHd6F; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="g9XhxqKG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sbLpHd6F"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id C1CF51D40F68;
	Wed, 19 Feb 2025 13:04:38 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 19 Feb 2025 13:04:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1739988278;
	 x=1739995478; bh=CESbb8PJFW9TehcLmqCA30puvb2xWZEaJzVdH9OC0hk=; b=
	g9XhxqKGP7uKr7gBCmi2w78juB+VKx5afbW9c1N0gFuBbIdoriaU8B9zlmz6LUsD
	9ES9X58Laa5kwTr1XxgK/pVyqCIKTMPLKAyBF5xsRJbMnWZeuzOjGggv+EftTXpo
	ScTTSdYI7MOhIo5sxQkMNMvD6a88Hlp6Cbfxq57Yp6d9+k2tB74Mr157x81obGow
	idOVgyMtbqKoZ8SoD10qcWCoJDyN+kVNzRA8R2/GZPmMRAEbGVQKzv9qJszmDEeb
	Wpq3yjAw+4TuPqHChALyXlKqjUjD/+7SIa12cSPEicrW4Tvw78kv+6vjVa7Inzwh
	PhJc2WX2tcL6Uy6UeaJ1QQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1739988278; x=
	1739995478; bh=CESbb8PJFW9TehcLmqCA30puvb2xWZEaJzVdH9OC0hk=; b=s
	bLpHd6FsgB3mZqQrw3nHcBcjsskPEQab89Lg9iJb9JZR2p9Y4E0bdTkGONfdB9+6
	M9BEtvxXFY0KCAM490iYW9Z2gfPHRl4q2dCbWUo7kv3mxxFqWg5Ps/eXt+1OlXVO
	GtEkxH6LeguFvh1dVCmtLAf4gStp/wwQHAqiXEoRvm4HPXm3xodzimN2uvAP3nO+
	lccP5yLSSBZcO35ozzPkz5bwzqzHmrrABKaQTegyk0IDzVJrqyahZx9cgOLBllSN
	kwShy0acctf5DGu4IwM+4uv9b3LHKhLPoCy0bSAE/YBAD+TryzbqXOcoJrD8ge4t
	cx0to6py1Axk6OxJLDbzQ==
X-ME-Sender: <xms:Nh22ZzQG97Qdb3sbBx5mXO6DY7lkwdxBEVjuXJpDSEJp2WFZPmnMQg>
    <xme:Nh22Z0x4phS8s_18GY41PnyT-q8KQmvDmdmUzrDjFOjCvJlF3p3cmu7xgip6VoAii
    6WBoQHY0ZT8KACRh40>
X-ME-Received: <xmr:Nh22Z43YZSD5q5nEua6HNdqaA9vmp_aXTlOKxG6t8XKHxw2yHKDHkeWMzClKNDJGE5_IkNd1iB5ctWXN0tNz5RSUxOduDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdeigeelgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvg
    gvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepveeikeeuteefueejtdehfeefvdegffei
    vdejjeelfffhgeegjeeutdejueelhfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgs
    pghrtghpthhtohephedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgthhesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheprggrlhgsvghrshhhsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehhtghhsehlshhtrdguvgdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Nh22ZzBOy3jcBRCA5lKNFhLJi273ECIhXs1-JeBxwR-DGI4cS-29Bw>
    <xmx:Nh22Z8guUwegI-XjjJ40OENnr_Efs7GVv1yrjsLJpMbIKRr57FMriA>
    <xmx:Nh22Z3o3ueu57WAI3mjskp701yABvNoyaFrs-yXNeG-TNmK8_9QGhQ>
    <xmx:Nh22Z3jMyShndFR2zcnaOrTiq6XXbcWak5DnUCD65VP4lN-MSNulPA>
    <xmx:Nh22Z_tMelOIHhamuUMfs8GYNQV_wta8xIZPYY2ycuVXmTtvVNVL-HsN>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Feb 2025 13:04:37 -0500 (EST)
Message-ID: <37ea5fed-c9ad-4731-9441-de50351a90d7@sandeen.net>
Date: Wed, 19 Feb 2025 12:04:36 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <Z7RGkVLW13HPXAb-@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/18/25 12:36 AM, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 03:03:32PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Aheada of deprecating V4 support in the kernel, let's give people a way
>> to extract their files from a filesystem without needing to mount.
> 
> So I've wanted a userspace file access for a while, but if we deprecate
> the v4 support in the kernel that will propagte to libxfs quickly,
> and this code won't help you with v4 file systems either.  So I don't
> think the rationale here seems very good.

I agree. And, I had considered "migrate your V4 fs via an older kernel" to
be a perfectly acceptable answer for the v4 deprecation scenario.

Christoph, can you say more about why you're eager for the functionality?

Thanks,
-Eric
