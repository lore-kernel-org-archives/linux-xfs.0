Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF3B4D7D2E
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013422; cv=none; b=k3Qr3IUSkGmveDOwEo5o4g7oUVg43XBk1vJslfyXW0rKAIm8jqzMKX0cuCVhd3rj1zuWi/5Esm8Sjmekdmnbgo0C6yzlosQKr6fsOR1faufBR/PyKNZcTPjO7f7ACioPoayql3czfKv+836bW45we4HCd+RV3PXNuTZpavzA7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013422; c=relaxed/simple;
	bh=5apKNpX+CcR0cAYrnlw+BTO7+52Mt1q1/iGhDHZEJ6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnTL5dcd1ZCqaVW+WuJ0cqLI3usw2ZKPvTcJpq7Qfblpx/qn6vTa2eh9BDxIfKKrjHQNk3kwUI0w/mhT92kdEjzaYD6rHjXRmfLEc3F119HQgmzPx1V1uaa0uRjNF0couWezCCjkIDGHDbaDf/Ntosq5Zl8Dr65wy+RVU+nseho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=T2W5YJMW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=u+I9cyoi; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="T2W5YJMW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="u+I9cyoi"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9343114000E0;
	Mon, 21 Sep 2026 13:56:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 21 Sep 2026 13:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790013419;
	 x=1790099819; bh=uYU8q4fXtN41KLKnQqkkaVOie8JplVyw4Z/lVL6gFhQ=; b=
	T2W5YJMWS5qSpXbgLcgxfyTmzD6cfmFK/+pPYI15hGR5LoSqPdYS60UR1A4OgCSp
	DyLZhKC7MBVBywi/hwdpENKps1qYryhBMTcLyF5lP/MHDmVFgZ6ZXI+8OwRDLjnk
	20ie/JSSj8RUapGtf2n0QCHPnaN3KTF4L4WNz/fXZbZ+X5xMog/KWFKOKX0RkpG1
	H9dWuro2+Svu/ZitJd8pnPxkdn8ugF5ipC5W9vHnyyz1hVa02XugW4nxEy/ZR9mV
	atFVrRl2Zkzaj4M43hAxv/75Mu7Vm7Yh8VazSKX0lnnDpp1ZhChvL79Hxxgn0eXY
	zrrFxbBWBUnhbMk4C+XJpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790013419; x=
	1790099819; bh=uYU8q4fXtN41KLKnQqkkaVOie8JplVyw4Z/lVL6gFhQ=; b=u
	+I9cyoiM4EXoxOosjKqDqnJglIMCL4k+LUXvAYzHLxEiocrtqcMozcplyY1aTc5T
	vj8suLHXnSjuTJsLYQJ3mrjtr6ucVeypomI6ttRQkceleZ+MJjJNsgs+/Qjw8dkn
	ujujRqcMAld2G9S9uTpnVKI6rBnq2Du6gNdNU4DV0Qwsgl6bfjAIcyvxKlopCJ24
	GsNbUobpCaMqLxA/0zlOkrzGO05xh70c7DIxS2MCuSobLtmaaGs35elqurXsAa+D
	/5BWhAf6yCyoQJyh4sguhPRgarRdUzltU8skIJjggmc8lI1ZJKUFw8OemyDijdtw
	nOGiuu895hkZ1yRE51iXg==
X-ME-Sender: <xms:62-xatFQGjxA-uUYkdLyyfMimtfsd2t_MQTtU1RbXHLLu06qVAEgWg>
    <xme:62-xapMVqRUzkcAO9vTYpp5GCMqt1RHcx157IrvArL_8suGBd69o0qU3pU67nIiVf
    jBC2Zu4cNOIpCMR1eINgtDjSPdudnHlcjNEjB_7eb9jvWfACzZLsBij_Q>
X-ME-Received: <xmr:62-xanfU9iLLx95ra0QNK-QQ3LhC_HIjlcHElXPEYvcMwjtUEB5fMBEdN2tEbhExPGRTKcqB3r15VRu-f9iH22VjW-sQeA>
X-ME-Proxy-Cause: dmFkZTE5Dm7B85PvvqGyQ5FiW+f9OIJilMbQvZYKDVEjVloyy/Opcv8Yni4+KE/YSnlV7j
    p7VEy7VlqHb6MtEgFhB9qHUiwlEejzdktesqHojGRfWZQFpeQO/MJe+rfH5dv6Yljh4ZzY
    UQj/aNAHu1mUcH8ANW2/hPaaq6V7RZDwku6nJwMPnDCVCq9fDlJjGlyn9p3pwvI1vcyAxg
    HMrbEucPNooPDJtVdAarfvQcuAFO7yxGa+XnG1PzVWntYULr53To5CyvF3dso0ArB2Yz65
    CU2lTis4mXUBE+oNxqPVMc0w5GPT7PZN/SmpjTzSPi3u/uAP+Js+TNuMmLb4hrxfe47Nl9
    4Jgn1+ewdMFKuQ5H2XrD2eLWHxiYmtA5FVggbXyf8C2VGDBHcYqlnjjowEAWaks6tjr2m/
    d48QoSJKeQC7unNKxJ8vpBP6z9/a4Yysd0VCNMH6T8cWcaU6hahA/r+DeRiytEFn4P0K9b
    T6jNZDg6utGgcnwNDnTPZmIreyblZk/1FvEZXBo11+rl5weks1EiytNU+1X0Ir7lBdJQZ5
    1qlIJ6sOwzemd7EmL6T7Kf6MDXCu84ZWG6O8asBSjkY15EKNFUz5jrZbFrb12d8+BgHHkR
    A/467DnU8IQYil3G789QRX/fS8/NsydHFblCo5V7OM8gy5V2GxhGWILhsDuQ
X-ME-Proxy: <xmx:62-xauuKUDtcMcDyd12rapdf8Dy4WesxcKEv7SKIeLLuNC9nmU6c9Q>
    <xmx:62-xagkF1K3wtVdF6jipLhSoetLIbuU8ory25UZ6it_7xmi9SBnS1g>
    <xmx:62-xaoyUFPajeq8rsZynTU8XVnyfr1hK1b-Oh2ZEDqDieNWliWoFTQ>
    <xmx:62-xaqNPgvNEHUaCdfu45z97sRrCDCPcWuppUHrerjWQ_jj9oXtBdw>
    <xmx:62-xatGEhAuyouSbHA0ZmfZ35YqQ7xJQeb6ZDiFSMbfn4pW1Tcdvw_FQ>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Sep 2026 13:56:58 -0400 (EDT)
Message-ID: <9d77197e-4d5e-49f3-a7cf-fdaf33c285cf@sandeen.net>
Date: Mon, 21 Sep 2026 12:56:58 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] xfs: dedupe realtime rmap btree code
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
 cem@kernel.org
References: <20260918181324.2472127-1-sandeen@redhat.com>
 <20260921034003.GG2705364@frogsfrogsfrogs> <arDprUJAb7QP1EVx@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <arDprUJAb7QP1EVx@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/21/26 3:24 AM, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 08:40:03PM -0700, Darrick J. Wong wrote:
>> In general this looks good to me, though I'll add that the same sort of
>> code deduplication could likely be done to the refcount btree code too.
> 
> I thought the same while reading over the patches.  Also the exported
> in patch 1 threw me off, but it didn't actually export anything.
> 
> I'd be tempted to just merge the two patches as that's easier to follow,
> but otherwise this looks good to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Oh, ok - I can merge them if folks prefer. (I kinda thought a prep patch
/ use patch was simpler to follow but I really don't care either way.)

And yeah, you're both right about the refcount code, I should have thought
of that. It's much shorter functions and my duplicate code scan was looking
for bigger chunks, but I didn't fully engage my brain.

Happy to send V2 with both, and merge each into a single patch if that's
what people want.

-Eric
