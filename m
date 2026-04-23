Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2F7237713
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776910155; cv=none; b=uJpEhAnf0AoZ6vKKntXDnrGJfRcsoSODmlPDGNbZhP+VjnI0ew26hIKmtrZOKJ0GJZpgK/e16L5X0Ult34tRh7xI7q1/uleZTEdlnL5geH+HS2yzn9LnY9F8o076hZAbV0XMmMKIwTlN3oSg4S7cdTkEfYaFEpobpql9KRsbPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776910155; c=relaxed/simple;
	bh=jgiSgeoEuXwnwcW6uRucXZ2COxDXZIvhy0qWRCInLRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MDOjbcbDZv769w+ejVfnr5r1U2KKDyzkCGqYji/s8wqxXFLWaNk6e136L4cToSH/m6Ud1QbLy+JJyDLgL5jUIRJ8qXmDMcrbOAVcEbxePIXF/8Ofn02z7nIvOF5mND/oELotwvhJ+Cx9liYQqW9nh9OMM7BFg2XzdZbAoUcs02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=kVLgzB8B; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gz9uGN+S; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="kVLgzB8B";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gz9uGN+S"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 97E517A0253;
	Wed, 22 Apr 2026 22:09:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 22 Apr 2026 22:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1776910152;
	 x=1776996552; bh=XvGCx90RFlo/nf+hUmG390bg7ipfrFLbJwWem+ZaC6k=; b=
	kVLgzB8B0ggIITmgdejZbglN3F56JCcSXEnFmYKT1jCk0IlgavOakp3ohAK2cXa5
	273uS3bdo246zix6TivB5sMxElPbTFKoIpDhek5BgEOu9fpGiQpcsM6W9Evif5Ld
	aBTxUyVWeJousJ5PAdcISmHKVnwW5UcGhGvT6dlEKF4hbdluyoIqXQKz4+i8lb3j
	BN2XvdfEg+eFgXOiD+pfJeA51fPUUycMCh2XFs69xNfCF0fYb4+FMyD7UqcQb9hg
	a8bYMU/xLnIcDcwJLJofQ4JPfTDWWgpIOMt6P4opblds6rHxyXrvtxxMSazO4CQG
	Rk7aTQH3UjgIFJWfOf82yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776910152; x=
	1776996552; bh=XvGCx90RFlo/nf+hUmG390bg7ipfrFLbJwWem+ZaC6k=; b=g
	z9uGN+ShGpkVjUX6aieJR7r7fYLX7QF6m6cw9UaTBRyqyNPTUuWRprjjVVnvkqqm
	V4LM6b5ehwiahMwhtSBd/rNEEXkVBnK+uvQFNA18EeUPPHy2unYE4zgu++Z2IPUt
	JuWI6hs7kmgfONrHYVHtxFfDG6N52SxDTGxQ4VPjyFoYYfaxYA893XX9UEBIt3eK
	AigIDm762vWMzNuegRqrHmCtOaDDBXJq3bMvhUr8TY+SK0WHQc8cudhcs8fGN/RE
	ahb7yVAdgowQrUMAHOFe+ya+g1H6+lD9rHZ+wDxpNnH84vINg8HpHZZuoP4IGLqo
	coMJyk1j1ayv/DM7/ubKw==
X-ME-Sender: <xms:R3_paWeNG0KaQ34qxPsHA4PUr5CipAinq74DioUGuYa3989hS1wEYg>
    <xme:R3_paXq2i0V7BX0hZEBJkNlDmp-okRuchduhMPtikEdRz3H0QH_7EH0ztLf7NR6lz
    iQA9Qn9bCyrROx_m_Do0dbDxadOfovOzkEzia7B9nmwHePj_SaR7w>
X-ME-Received: <xmr:R3_paU5WZFu2j4zmlh7I0V9q9UNraxJNt78u1p0HkehlsL6KsTzFw9VGEZBbwFenQ5t_-WoQSmD-W5nSEQLUjauH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeiheeludcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfu
    rghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrth
    htvghrnhepveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueel
    hfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    grnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepfedpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepfigrnhhghihughhuihesvgduiedqthgvtghhrd
    gtohhmpdhrtghpthhtohepughgtgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:R3_padpW9Ss5-O6xFa-Ef9O7u5oCtonoOnFOwVhqxmOpgCi2IK8fug>
    <xmx:R3_paWhS16oXy9ybfqini-BTEVyF8LkafFrG5rHVDStnO1ZmGxkf6w>
    <xmx:R3_paXIHKWRm6u7K4UkOao6y-1fpsv88xp-v8TU7i68aB_r1WIXAEA>
    <xmx:R3_paWChE6ls8RpQUNPtI2ksx9gQYznDIpHI5U4ZaeM00o2U0O8_FA>
    <xmx:SH_pac4-KkUFpfAw40fJNp_1dDc4JeFl0Cisq9RrS-t9Pn0ZxNK_gBWd>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 22:09:11 -0400 (EDT)
Message-ID: <e7f42338-04f0-4f71-8b33-8f90f6bcfbf3@sandeen.net>
Date: Wed, 22 Apr 2026 21:09:10 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ RFC ] xfs: 4K inode support
To: Wang Yugui <wangyugui@e16-tech.com>, Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260421230515.2234-1-wangyugui@e16-tech.com>
 <aelAeiyiAyFiJUgQ@dread> <20260423070227.B2C6.409509F4@e16-tech.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260423070227.B2C6.409509F4@e16-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/26 6:02 PM, Wang Yugui wrote:
> Thanks a lot for these info.
> 
> the basic logic is that, for 4Kn device, the min io size is already 4K. 
> and 4Kn device(SSD and RAID) because more common now.

> On a 4Kn device, we can I/O one single inode of 4K size without interaction with
> other inode? so mabye better performance for high speed ssd such as pcie gen5/gen6?

We already do efficient reads of inodes, even on 4kn devices. As Dave
explained, "inodes are allocated in chunks of 64, and they are read and written
in clusters of 32 inodes." Even with the smallest 512-byte inodes, we do inode IO
in efficiently sized batches. Reading larger clusters of larger inodes filled with
mostly-zeros will not improve performance in any way. It will only waste IO,
memory, and disk space.

-Eric

> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2026/04/23

