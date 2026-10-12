Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31F4489FD7;
	Mon, 12 Oct 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815195; cv=none; b=P5zEj8AVbHLIWcYxjxoo8fTmE0AEHKnCjIK8uEB1u1HqQQKsSCINTH5Q6l1fDwLUgDQMcSTnoHbzGU+RgVVeBTuRqp/ZjUSypCy2J4MYCxypMvaY1GC9ZDEQsZTmZWkymL9VunC98GyOvy5PEF3mImeLSiT8Vk19vIjxH6qusoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815195; c=relaxed/simple;
	bh=V9s8sTVltmDrrjxYTb7b1u47UnWOBPXRe7IP98uqA6o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=jHE/rYuoGA8UYWzOnSHsDKnsTp++r6duyj4/d0lyO5LT931HpHAjgdXO8a+Cdpo2CvY0rqNf2WGZhOx+CnCSZw6CnsSdnubc9/zsR0+V4ZmafOukgtzH1TcDu5RqGScX3nQgAxRAV8EeqaZnoWL+3Z7ARangg5LV2e3JLqMWRVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKfdrdV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKfdrdV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBA1F0089D;
	Mon, 12 Oct 2026 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791815193;
	bh=t1gfwLW+DfMmO/MP4/Ltieejm8EJcRgi6V/IwvUl9YQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=HKfdrdV0lsDAx3GPI3aOL0ypGrsMFim8466/uUOka/9j28Pz5Ad7TSSzYiYwm/eDk
	 TZAPBwBZGr0qQrz0RHLuK4iOAhW7ROxJY1wcJu9fTBc5W7L2hTzg4irfDvPtAJce0B
	 OfrdXFRsjFnTa0VVFzfOGzUAveuMd21MaOXAIOj8R0lEfhJ3n+vMpngQEVYsGDXIQ7
	 cj048OUGgg2MqBlq3JbwMZXVOiW67thx+pAYAau6cG+tLHwr6M8fA3rhKlB8Zg8i7t
	 pmWHXY+nwsx8M3cfEK35KS/PkN9Ox/tLmFzywGlR5E2dMWxzz9e72D4hfAVoryGIvS
	 U7M6Z2RTo3aSA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 75EF5F4006A;
	Mon, 12 Oct 2026 10:26:32 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 12 Oct 2026 10:26:32 -0400
X-ME-Sender: <xms:GO7Maloc4DAcEfHi3Gg5phPSVrWT6BiIQ0C2syug4eI2AqeL9iPp2g>
    <xme:GO7MaifCazP9Ih4hYxgiRu8luee6V5gbuq3A9bdXl9eAN_P8SpAnSuk-NLSJ6Ubt8
    MW84ut1haROH4zAEgpwwuxYAUQOsr9jd1dTWWgz7gAIq_yxK76_fDmN>
X-ME-Proxy-Cause: dmFkZTGZALPHz+mTcNMTMzZXAq4Ny0BXTT8LBNncGYAjCpeVHrwWYu6PrMQsjyIq3l2fS2
    2E8imEiXbDJo7omRtakeG+1Qhexcn1koCBkbTaHKaQo95VxyvV07wqcYhKjxdjiRPmO4jJ
    ARc74sqhHRewjyd3qxpuhxusAfEXnPXS+a5Cj5BRC1BPm9DdQDrqfz+dcoD+hcnSbBHBow
    iBqef9vCCfpKEhk2LY8Lxu3g+8t00QV+WPbnhIL2GKqO+C02rQMe9PIuR9ENAl5dQnsc8j
    We3h5lWUZxLDeQWV5y3jRFCmFyR5MmvFl/10oeetgoIqOhjY9SkUg2aXbeAhfpq5y2qSOq
    2XXfhyShLv6lKTjAd+DO+wkRwSSiizlF5W1/EJ4773N2gF/GpAvvQZ13lldoAszFiqM69q
    8mhuG4ufHptnb6sZJPBPj366hgx92o7CNfRxTYV5fnGVrRe/LVo81qZDwMsWu5tJ5m+YvK
    RzD9i1JoAZEhACggBWdNhn5QfbaSj4rDZCcApGIju1eEkNg1cwfCVIFevesT1W22A53Iu9
    hrW9wBRG10lEDMHh3LlVOd3F9x0tXhM2pWtG8H+6W2qLQu8jG/cJtrMoRBNlbKt/kxq7p/
    xvi6OGvlZJXKkAm/pLK/aygO9TGGlFLgXVfzhD0L/dXlVl2XSvZ5GBPyVDxA
X-ME-Proxy: <xmx:GO7Mah3jMRfmnpZo79MkWiGFjaKajADEE9qI3k_LqQKF6dyJ0PwDNw>
    <xmx:GO7MakCASoA_VaUT7P3gMZyox1VmymB5arL3M4jyf3x5Js_gOqmuVw>
    <xmx:GO7MaoC30wypbTMwaCYkPNoSX4hRI-82X6ZKgFgXa61T6BYgRtycMQ>
    <xmx:GO7MalP6p_lyKXYrOhnR1CTG9ebujnNA6z2o12ACa_i5iitjhYzExw>
    <xmx:GO7MaiParwJ3R8wILniQoK-Ru4G2QNtD83LcFQTurdZOtdtWLJnXKeTB>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 54AF178273C; Mon, 12 Oct 2026 10:26:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AwUdQ4Q3F35V
Date: Mon, 12 Oct 2026 10:26:12 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Carlos Maiolino" <cem@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Dave Chinner" <dgc@kernel.org>,
 "Sergey Bashirov" <sergeybashirov@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
 "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <b31fd2ce-3b1f-4cf5-9af9-70ea89a4d67c@app.fastmail.com>
In-Reply-To: 
 <20261012024846epcms2p7cccc5c988b2553b3f831070eb17e0455@epcms2p7>
References: <4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67>
 <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
 <20261008-xfs-nfsd-map-blocks-v1-7-560026cdccb6@samsung.com>
 <CGME20261008163812epcas2p120bb86754876aa75cd744bd63258c465@epcms2p7>
 <20261012024846epcms2p7cccc5c988b2553b3f831070eb17e0455@epcms2p7>
Subject: Re: (2) [PATCH 7/8] xfs: map the whole range of a pNFS layout in one
 ->map_blocks call
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sun, Oct 11, 2026, at 10:48 PM, Daejun Park wrote:
> On Thu, Oct 08, 2026 at 12:37:46PM -0400, Chuck Lever wrote:
>> The same freeing can happen to blocks a client holds a write layout
>> for, AFAICS. But that is not new. Commit 527851124d10 handed out the
>> same blocks.
>>
>> This is however the patch where a fix could go.
>
> Yes. xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC only when
> it allocates, so a write layout past EOF over blocks that buffered
> writes preallocated leaves the inode unmarked, and blockgc frees those
> blocks while the client holds them.
>
> With pynfs as the client on nfsd-testing: a file grown to 1 MiB by two
> buffered writes on the server had 960 KiB preallocated past EOF, and an
> RW LAYOUTGET for that range got it as one INVALID_DATA extent, without
> the inode being marked. About 300 seconds later, with the default
> speculative_prealloc_lifetime, blockgc freed the 960 KiB while the
> layout was still held. Small files written on the server after that, and
> after a sync so that the freed extents were no longer busy, got those
> blocks, and the client's write through the layout replaced 978944 bytes
> of their data. The LAYOUTCOMMIT then got NFS4ERR_IO, as
> xfs_iomap_write_unwritten() allocated for the hole with no blocks
> reserved, and XFS shut down with "Corruption of in-memory data (0x8)
> detected at xfs_trans_mod_sb", in six runs out of six. Committing 30
> seconds after the LAYOUTGET, before blockgc, works.
>
> I would rather fix it on its own, before the series, so that it can go
> to stable: mark the inode as preallocated also when a write mapping
> ends past EOF and nothing was allocated. With that, the same test keeps
> the blocks and the LAYOUTCOMMIT succeeds. I will send it to the XFS
> list, and patch 7 of v2 will keep the check for the mappings of the
> whole call.

Sensible, thanks.

-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
