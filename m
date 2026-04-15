Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2172627
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278753; cv=none; b=NMX2F6Mlbkrpx5HuwSMfjHnEelgsJMlQPIw4Ne4H7d1y95044quT/9pDUsJAl6j+cgtu5OuziI48GbnLilsM7NF873qGxgr3REIxIMysmrRSIcg/0ndx9Xol61Vu5dPUGGk6sfFhsAtIazsyoLGy68N9fspHg0/3hKSV2YJKjYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278753; c=relaxed/simple;
	bh=tQPCaCy/AfcHccWtInJWfFq9CjF8Wl+Ve9krO68YHV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmUnwFbl3qwGHSeZXeQ6FCfqmcfOCSgjzpPr2Qg67p50K5QkbKrQqxd4CQYxBp/ieJRpJTAwpZwPNlamhTg7s9tybGnVqnlL5avv0u3fwk0Bek4awQi4vOwg8Kb/uTcgBS0LIBYZnKQ9YtIWtm+MiQVWcoYGW1fDO73udEpqwgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=bdroZgDW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sCUnDORf; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="bdroZgDW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sCUnDORf"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A7D08140007D;
	Wed, 15 Apr 2026 14:45:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 15 Apr 2026 14:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1776278750;
	 x=1776365150; bh=IC5sBwQI3k2+4fbs+/38WR76h6t/cVxa1XY9Uriu1NY=; b=
	bdroZgDWVqFfsBrtNPShWAsj0EAaxriCP1RBQS0ZSBS4Hbe1YlECc0eIVqTTQnCy
	VLuulh/HpB7gPL1/Mpra8oDmFofIdHhsUJ9GW9vy6EVb73luwR3ghewFf8LrdLUx
	/aLVMGqzgyuhhyiLOZpVxO4T9qc0lnQF74n1vvSwDxLPu0/qx0xn+pBn2G9hJW0B
	iyPrJaSDuSBzgu440rVIZ1OKQSKXf05lGsUep/3T63ANYG50guyGBXfO6+UzLZV/
	MNPCiZhRRQqYKcBpewJM+KkLPL57fVinpSPYYALDaRWg+uqAPPrWKmsECD+pFYJv
	NXNx5MVhs7IbzKqUdvce8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776278750; x=
	1776365150; bh=IC5sBwQI3k2+4fbs+/38WR76h6t/cVxa1XY9Uriu1NY=; b=s
	CUnDORfIN92BvbEluY3Wp/3X2BvfnqwLbjIt8JD8R2/s1XY3alaS3sEv6yZU4m1i
	VULY5AOTFgiXUmjKDUQt5x3zGHmKlvmx/38P9OCUheoXUl2xiI9z+gcITcugEQjo
	qS2WLALyme1MeWmPQ32YjmI+J54KDi7qLR4So5Dx5XW2W9XGJp9sMieTvo9LxBDW
	NwARm4Rc6UffL8hhjBqkhzA8A01IIWIHWQ9n11sdbo0gZNQsn0bCg/jd0RFVdQAF
	QElxmCvZtEFKDAM20xJ9vro2hw4vjBBwNxWAJ+N9EG/nIqrEsSg+gpTs3PjmPv4N
	Nrk9GJ3Obzq+I0ilPMR1Q==
X-ME-Sender: <xms:3tzfaQHjbl1NOCINM3KC8HJin2wWndtKvPs-qZj36tGyJZO4c9noVQ>
    <xme:3tzfafUsqWPNzb3Ogr4VoqdsjtWLOKATPN2CNGWpIjQGuK3oJCOr0kli0kpPNGJry
    sXymTgW4FMQ_Pt1XtytBHcSu5eghLS7G80sfY9PybmRPtf1GMJ6u_Q>
X-ME-Received: <xmr:3tzfaXw4kYkcqmKHBKiGpUsQ_2T_Q87_JRCWGruT7BGVGY_GE6cYdRMDPeSS36eVJ-yHXRVObpT5nfgHPWvekM8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeggeekiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertd
    dtvdejnecuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghn
    uggvvghnrdhnvghtqeenucggtffrrghtthgvrhhnpedvkeduuddvleelheeggefhuddvfe
    ejheetueefjeefudfgueejhfejgefgffeihfenucffohhmrghinhepghhithhhuhgsrdgt
    ohhmpdgsthhrfhhsrdhmugenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphht
    thhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegtvghmsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:3tzfadO9vs18OlLW259eaWi6gMYiTT0VMwHLTtAimu40VgtgVGmCdg>
    <xmx:3tzfaY7iDNuF5jOTLzW32egKt8X9jgnmVHwKiyCsHAgM7sKr4HUmwQ>
    <xmx:3tzfaeP1h3Q8qr0gGBHYZcgqHpuYVNF3qH0NRe1-Am1BHzpD1r0FvA>
    <xmx:3tzfaWlWpic58asElgCXCytqmtTffro5A7Umz7NxWuI_W3I3cyOIbg>
    <xmx:3tzfaQYsxPQTPSoC4AdCCGs4qz3EUAQ-dcLFE_yYnjD19oQ-FvzmHuD2>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Apr 2026 14:45:50 -0400 (EDT)
Message-ID: <814a7536-fb34-426a-8c04-6eb4671a3a8a@sandeen.net>
Date: Wed, 15 Apr 2026 13:45:49 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Should we hook up sashiko.dev?
To: Carlos Maiolino <cem@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
 <ad_axvVel2tpEcLq@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ad_axvVel2tpEcLq@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/26 1:40 PM, Carlos Maiolino wrote:
> On Wed, Apr 15, 2026 at 11:49:50AM -0500, Eric Sandeen wrote:
>> Hi all - 
>>
>> "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
>>
>> This is something built by Chris Mason and others, with Google providing the LLM and tokens.
>>
>> The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.
>>
>> We could send a PR to request adding linux-xfs, and I think we should try it.
>>
>> However, if you look at the config, for example for linux-ext4:
>> https://github.com/sashiko-dev/sashiko/commit/d921c59
>>
>> there are options to:
>>
>> 1) reply back to the patch other (or not), and
>> 2) automatically cc: one more more people on every review if desired
>>
>> so before single-handedly making this decision for every future patch author
>> and/or possible cc: individuals, what do we think?
>>
>> (One can drive Sashiko from the command line, too, with or without the list
>> subscription mentioned above, see the github repo for details.)
>>
>> Oh, and I guess we could add xfs-specific review prompts, too, see
>> https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/btrfs.md
>> for example. EXT4, OTOH, does not have this. (and the btrfs prompt looks quite
>> limited right now.) Maybe we could distill the xfs documentation into prompts...
>> but I'm getting ahead of myself now.
>>
> 
> I think it's a fair idea. I've been talking with Mason about it and it's
> on my todo list pile to look into it for a while, but I didn't come to
> that yet. I have an initial concern on who will be reviewing its output,
> but I didn't really put any thoughts about it yet.

I don't think there's any obligation for anyone to review its output, but it's
there for whoever would like to. I would expect that the patch author would be
first to look, and probably anyone who decided to do a human review might
find it useful as well.

FWIW I am also playing with using claude to generate a set of xfs-specific
review prompts based on documentation, code, and ~500 prior "fixes" commits
that fixed things presumably missed on review. That in itself probably also
would need review. ;)

-Eric

>> Thanks,
>> -Eric
>>
> 

