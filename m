Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B46539A04D
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 11:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787312388; cv=none; b=VG2lqbVJT90a/QaiDP+sVIZ8Yedp3/PeMF75cDnXqeum+kVU0rgZYMVMmmE/m16EYyAsblMSD7qIJZ9plh97VTBF+TTFjRbwlyBDxHudyJK8CL/W4xYLrfShv2GQcqwIJwhOYUbcmIuztbYfAsOMEGHun/uM+itD2E5PDl5s+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787312388; c=relaxed/simple;
	bh=yfXVRFlpvmMYanoHlJB/z0+rBqLnZTjIcI0tlxOU9ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=RP7v9+5xMjm/KjSNN4WIrJybglPHPEDSU19+PC5rBsuQIYkCx9Wut7pnVxVtZAya/tUaM68C4DfdVS31stynIs4Wua6bDwq6X3FMELI7WxAbgM9aB5J+oQe+va0AW+27feA61sc5gX6wY2RZN7Ks/llIWQMKryutPFYG4LZ94Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gEHkLydw; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gEHkLydw"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260821113933epoutp01d4ae667c4b97d8a48ea58923e8f57658~NzyJghch90563205632epoutp01H
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 11:39:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260821113933epoutp01d4ae667c4b97d8a48ea58923e8f57658~NzyJghch90563205632epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787312373;
	bh=zsly40hwKJoSQYE06LEwkYarxgdUhAAdPrroUKxUzUQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=gEHkLydw3j07PJtWAt+xiBbUrTIKxnz8ISvjAtkVGAdeNL0wcFNBgxwTTdbAEnyDk
	 on42Q4t0Ns0+jaZW2e2dlBmLOk7lWUYM1eya5rtfW61KX9ilJMC9upVAXv+Jmmwjwt
	 /nM2m9BuDmTEJTS0vu0EyoTxPVFOFxhcCosfgA8Y=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260821113932epcas5p311c69d6f2eeec397a6b57eec41706826~NzyIYX_3n2466124661epcas5p3_;
	Fri, 21 Aug 2026 11:39:32 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hRJHl3WMGz3hhT3; Fri, 21 Aug
	2026 11:39:31 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260821113930epcas5p30bb6be9b05cc273481a2fae8f179d846~NzyG4jSZK2466124661epcas5p37;
	Fri, 21 Aug 2026 11:39:30 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260821113928epsmtip2810b1f9b747eb2e367236ece8fd95ce4~NzyE_PY1P1875918759epsmtip2Z;
	Fri, 21 Aug 2026 11:39:28 +0000 (GMT)
Message-ID: <8a2a765e-1cab-4c6b-8a58-3ddbef3862f3@samsung.com>
Date: Fri, 21 Aug 2026 17:09:27 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] xfs: implement write-stream management support
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj1072538@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260819072407.GH1541@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260821113930epcas5p30bb6be9b05cc273481a2fae8f179d846
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c@epcas5p3.samsung.com>
	<20260717125538.508925-4-joshi.k@samsung.com> <20260819072407.GH1541@lst.de>

On 8/19/2026 12:54 PM, Christoph Hellwig wrote:
>> +	nr_streams = bdev_max_write_streams(mp->m_ddev_targp->bt_bdev);
> Returning to this.  Given that we are talking about pure software
> write streams, does this make sense?  This limits the use to devices
> that do report hardware write streams despite not using those.  Most
> devices will not report those.
> 

Yeah, I enabled hardware streams first and define software streams as a 
fallback when the block device has none. I can swap the order if that 
reads better.
