Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C46E231A3F
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742590204; cv=none; b=Grn0LYdurETBZeUIFOgZsDEWkMX225mDBBUMAy97k1os9Jyz9oKbTHLNkSVT0IZjYib5Z0OT6pByLFZ0UE7vF8sfARfj1/hf9wPeKgCsBYDO50CHz4lbb/D8KRJLFgICzmf3Pd4CSgjQDkoEuy1aIaO3Nko2HjmBr+lRAnPmmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742590204; c=relaxed/simple;
	bh=zQprBolEu7+5ziuns1y8/cmgtyyu3cFsGlY5Ruo0YK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvcWCrKOxHDkzdWOtJNUfJaTuMVn3GQxRmli+fwkvu04XfXypeXU2xDrZYPbzSRpcHMgcm06QYzKFusH6ZBIqr0qfW+hx4LXvmbrKxmSoJVWulcxSunR4NPxT9f5SCoIYPdRh6iWGgDwads4VUbqhdPric588KuM6F2JZdfsw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ZtigSsI8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iVo+REzi; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ZtigSsI8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iVo+REzi"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 3F4F11382D7C;
	Fri, 21 Mar 2025 16:50:01 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 21 Mar 2025 16:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1742590201;
	 x=1742676601; bh=1U/qeA0ErOmmpuELD/caUZxmfRAP+xu9DDkaG0bCP5w=; b=
	ZtigSsI8mfinvHKPTSGupnvu3p1o8o8d0tp6glnj+UYc9tpxhqWY6EqpwvNR0dio
	6IH4vFjWuP0vyO5n1fSbrChQ7lBsb1feRMubfFfN8l1+zoFzj7bexS5iHL3GLGH3
	7KJsh6uqt9FHzMWA0DxxnMALa/w6HbkSYdGArjOfa2aYf+db3X9rD4QjRdSsdHs0
	2/dUlLDBXmXoackxvTPgvytcSuvzOKH5oJZwDWlKTlPwdqaJWjv6Ex/90vJXVnbj
	XhZzApgN15wv6djEdZO840xywNmGGwGPsFX666iawIq8sIzHT0Dx+5El49p05Bj+
	0A3NnaCkSI2X3cJGRrknlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1742590201; x=
	1742676601; bh=1U/qeA0ErOmmpuELD/caUZxmfRAP+xu9DDkaG0bCP5w=; b=i
	Vo+REziypgh7KU34sKm5TLcziP3zU1YA4MY5P8JwYwcuZ+SLJXOYyWDWyuePXDtv
	kNwfxPEKJldNvTOf8Gzq2Z2d2CFz9BicyUa6Hpo43Ul7z587ylf1M/8PNJBOsh2E
	vq1Rs27KI9CpSlufebuccCixiR3RCYyGZOTA35bodpxDLEstPKOdOd1un9VitM02
	2GSxVrG8ag/P/nNyOCnMyzFkSoEhhnQN806xy38BJ0qmiazoJMBr+dHh+33kNN0V
	Law0cqHnbSeCDGtIuJxEMaj8n7Z7mL1rXdI4reKhvCP7OX/jDblIgby47HMrh6jW
	b60VJVu2yyn1PDUoxqyTQ==
X-ME-Sender: <xms:-NDdZwAyb9n3pnhfALUProMnpLR17oNpHp6_TV6Fv3or21_1vG9e8Q>
    <xme:-NDdZyhmOtsJmIbHOgGiK6oz9stlVMy3nrZtvOEkY5K9a5dXk7M9ptmotNEDKAj3w
    OF07ZUkstz18Qqa7ZA>
X-ME-Received: <xmr:-NDdZznH5aNgUp41INVWrFLSF8B51xUEGPzLLODiPis87DXZbHdgolpHQIt8SPFitUcrVkbiR3G1oYUjm_YbY-Jy3bzZWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduhedvtdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhtghhsehinhhfrh
    gruggvrggurdhorhhg
X-ME-Proxy: <xmx:-NDdZ2x1QpXCByTPbC9XpQASa_MSG9pM6T73ewYKBxsmOEgoxu5M9w>
    <xmx:-NDdZ1TLnmYJ73O2co9uC2AwDtD1Ik5LEa-2VLSvy2kFkHHVBXBEEw>
    <xmx:-NDdZxanoCYiaCygbY6a3C1x_mOW6OBzpPsDjY5PeSYuR-dQKHhuKA>
    <xmx:-NDdZ-R5aleXqelSr3uwnIQL7qGkaP9OU-pf9p_Gu5oaxZ2kC26ASA>
    <xmx:-dDdZzPhU_VeL2peSY0G1iOai-Jn_i3uaPx28dBV_SVIT58HEGkNtmuY>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Mar 2025 16:50:00 -0400 (EDT)
Message-ID: <01ac135a-356f-4590-8a57-58ccae374db5@sandeen.net>
Date: Fri, 21 Mar 2025 15:49:59 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@infradead.org
References: <20250321142848.676719-2-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250321142848.676719-2-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 9:28 AM, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> In certain cases, if a block is so messed up that crc, uuid and magic
> number are all bad, we need to not only detect in phase3 but fix it
> properly in phase6. In the current code, the mechanism doesn't work
> in that it only pays attention to one of the parameters.
> 
> Note: in this case, the nlink inode link count drops to 1, but
> re-running xfs_repair fixes it back to 2. This is a side effect that
> should probably be handled in update_inode_nlinks() with separate patch.
> Regardless, running xfs_repair twice fixes the issue. Also, this patch
> fixes the issue with v5, but not v4 xfs.

Nitpick: IIRC V4 filesystems do not have UUIDs in metadata blocks,
so I think this problem is unique to corrupted V5 filesystems.

-Eric

