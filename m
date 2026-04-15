Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64233E716F
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776271794; cv=none; b=k0z2SdFiydtScNRWnsGD4ZHrUvE6/niWQC+2cT7HZ7Rc94QhKIJY9KzjgHkXhpzCMb23gWLM4C9PBcIF68agTU/kjXqnmD0IfIR8a4E9uPXB3wwmu8Vo16A7p4pniPqWJDZdMzuqKFhJBk0KH4/aaTw5VmPwEBnZxYSy7D0uhYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776271794; c=relaxed/simple;
	bh=0X0Ipxtr+3sFDu2KJcrtIOsqT/wAb4k4TCR3ZR3iFeI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=E9LUqrM+FZjiQ4di9wMROoPy5pN7AxxHy2OSU+MNO+QfCrENHG3Mvh4ql37diGn25JmgwgMTTqYp0nSWpqysgcKQMXfy7QkZ/cZyQFDmaSB7tt5g5DI9LJV/vYmrgGOOoJVITkH3DwFKU7QNRegMarAWTkySlv1D9fP+20tZDGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=cDZRrR2E; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NmwLRao2; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="cDZRrR2E";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NmwLRao2"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D1C9D1400147
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 12:49:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 15 Apr 2026 12:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1776271791; x=1776358191; bh=udIra9UX7/
	7h43qLM3pGj2xhMY/F7Uw11TkOhlSFj20=; b=cDZRrR2EFOvVEMypxQxAx7LFWI
	/Wu3qMxgsx5rTOWXC5BiV6h1LsDYsVjNAVaDiJJnZhp151ms7VnFUCLvl2fCgL+f
	0eVQQxKaysnezQz7XWle1cjMPBwq86dTdZDN5+ZgjIQDHaB5XFms3C8Irqj/qi30
	eGlhS3TUrlqm8fgtZGJY+he+hGTSAEQQjwpcaHDn3DsoEzaXF+Pbm2+czwzofNx6
	2YvCkr+M/qDspa+g920LpiWg/K1FW1ik/xXypD/HVvsJd2fFbwoG9v8FjWLL0BeJ
	/LbYZqDiDBjoSiI+an3OguhecYvyfcVqc1JvLKGaXO9kqW7KTRP48IreKZkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776271791; x=1776358191; bh=udIra9UX7/7h43qLM3pGj2xhMY/F7Uw11Tk
	OhlSFj20=; b=NmwLRao2bhc3iy3iXm3uzswKS1CS/bguSfqCg8sF1HJvq11+4+c
	n0rbj5wah8QFkmfgufUEJ5FdHPtvvI0CCAt7LB3VpHxvuOnTVtgY96H9JOPZ/DDq
	GjBLpa5xn+j+jL32aVq+bCdSeupWxZCo2IHsiqBxum0377wkGBkApsFSe0qCDmNU
	W35e6TGZz2y9w1BluigyKCH9wkLuZzscpVcw9j/dM+FxryTYgE/KSjX7I4W/aImd
	KASjUyJP/kgSWoEOnwKYtEwAEmtZpUQe03cfhMPz/TaVgdISNkg0S1/W8oT0ovQM
	wx9YJgRk5qa3X629QShLWdgk3g0dvgKbArw==
X-ME-Sender: <xms:r8HfaVS2pbiBc-ZVJ5RzBztTqY8hpcvGUzr-JIyhVZbjd7E9WPsBNQ>
    <xme:r8HfaVsubhSIdEvzAYTDJ_xMy3urFA01mOiUacHJzCPn5v61vea60ZrENq5_zk4Zw
    XTLhJSS_BOY1EjciVSG_bCFSFARFzd9tC7LUnkAo0F4Ff9Cec9zW_8>
X-ME-Received: <xmr:r8HfaQfqldIWYhY3-i9iWxyf-oqtHkytWqnZAxxAZ_kfT0LHoEpqjGL2z5iQkyrLCoxIKjnJtyyy8aHvO4FacqE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeggeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepkfffgggfvffhufgtgfesthejredttddvje
    enucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvggv
    nhdrnhgvtheqnecuggftrfgrthhtvghrnhepteelkeefteevveeludfgkeefvedthefgie
    evveeutdeguefgffeggfeivedtffeknecuffhomhgrihhnpehgihhthhhusgdrtghomhdp
    sghtrhhfshdrmhgunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohep
    uddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvg
    hrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:r8HfaSJwAJOXddQZSP49h_KjrLJa7li1Wwvq4wM6nc2gbIYEmLuQVw>
    <xmx:r8HfaeY_a3h05tMQBkZYo9NRsQT8DR-IUSeSq8l8oF98yZUEuIN2-w>
    <xmx:r8HfadvFxb7YTPvEGuhBU74jO5r5cF_Y4L1nz0ttK0-OLBiRsaybmQ>
    <xmx:r8HfabsJ20ibc0OzVHw_8fPdshqmyZY3YUxu2NA4RXePiSpk3BjMwA>
    <xmx:r8HfaRQMWUUpqop0CaAA_XaObllhyZxLNb5Qt6BOgvl0oftnpvKZBr4X>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 12:49:51 -0400 (EDT)
Message-ID: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
Date: Wed, 15 Apr 2026 11:49:50 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Should we hook up sashiko.dev?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all - 

"Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."

This is something built by Chris Mason and others, with Google providing the LLM and tokens.

The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.

We could send a PR to request adding linux-xfs, and I think we should try it.

However, if you look at the config, for example for linux-ext4:
https://github.com/sashiko-dev/sashiko/commit/d921c59

there are options to:

1) reply back to the patch other (or not), and
2) automatically cc: one more more people on every review if desired

so before single-handedly making this decision for every future patch author
and/or possible cc: individuals, what do we think?

(One can drive Sashiko from the command line, too, with or without the list
subscription mentioned above, see the github repo for details.)

Oh, and I guess we could add xfs-specific review prompts, too, see
https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/btrfs.md
for example. EXT4, OTOH, does not have this. (and the btrfs prompt looks quite
limited right now.) Maybe we could distill the xfs documentation into prompts...
but I'm getting ahead of myself now.

Thanks,
-Eric
