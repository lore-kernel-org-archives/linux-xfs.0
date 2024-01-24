Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D77811E4
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 21:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706130427; cv=none; b=uA/y0XCXfK09aDHOEQNBAxciTRsesz5RoOcLyxo4azP5dPY3YtCoFWReS+AuQrCubYOLXXUS5EDmNWGinePFWC1SUzvBh0iRs0F4s7fDBXsKqEEV6w2shVSKp1oMPbHBxMAdZ8U6OhrdeIRa1aIMAowaoiMHgnh6qfk30UsGQWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706130427; c=relaxed/simple;
	bh=JHNh9Q0BFBWgfcKGghxlNnLwyGg4jg2TwZ4zLWeARQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=BEjG53OoDlR24aYDm46t11DqNcKKeU/DtvJvKONXyYUMusIjqQ3dMH4BN1a1SirsAHMLiUgIA5hXonu8OUABSIMWiyAHLP+AdZB+bLof2xyOu4fcnV5i+wAOgToNr2h1Lq2dLhhKFRJr95AVtH4z82suxBrC7vYwbZkCKVw2Z+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SZ4rqBZJ; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SZ4rqBZJ"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240124210657euoutp021f6b2a5c727c57508b48ab57bdd9cd71~tZJM6dGXx2855128551euoutp02b
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 21:06:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240124210657euoutp021f6b2a5c727c57508b48ab57bdd9cd71~tZJM6dGXx2855128551euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706130417;
	bh=OgdKF7VpSJGITwcb08EUfUDksMeLEH7mGRvue6x4pn4=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=SZ4rqBZJNDlOJujy/IdUMT37ePrATu+Y6sry8AsvlMWl7XjUZnuL1m0DAnqtN9DOQ
	 iens4+8EXEayyTMjcUKAY5B+tBMoFBVIcxUrvOmjq8GuyANJ98dSWM5RkO8fF3YY2d
	 tizNzFy8neCfDESqtLGE8+Djn/qlHkhoadaPHfA4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240124210656eucas1p122b5b7fa4c5ac8f74119bd10a6a97af6~tZJL62m0G1478714787eucas1p1f;
	Wed, 24 Jan 2024 21:06:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 9B.8A.09552.0FB71B56; Wed, 24
	Jan 2024 21:06:56 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240124210655eucas1p124049fc160428b3799354a7837f10d5c~tZJLfwSX-2301123011eucas1p1J;
	Wed, 24 Jan 2024 21:06:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240124210655eusmtrp22be49531f994bf54bfce3dfac1812643~tZJLfMlZ80146201462eusmtrp23;
	Wed, 24 Jan 2024 21:06:55 +0000 (GMT)
X-AuditID: cbfec7f5-853ff70000002550-b5-65b17bf09273
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 8C.E7.10702.FEB71B56; Wed, 24
	Jan 2024 21:06:55 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240124210655eusmtip1eb51c210b119c4f87a8dbc6329e3aa52~tZJLSaPZ60328003280eusmtip1T;
	Wed, 24 Jan 2024 21:06:55 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Wed, 24 Jan 2024 21:06:54 +0000
Message-ID: <6d79f416-3119-4bf8-899b-88587d176475@samsung.com>
Date: Wed, 24 Jan 2024 22:06:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fstest changes for LBS
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Dave Chinner
	<david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	<zlang@redhat.com>, <fstests@vger.kernel.org>, <mcgrof@kernel.org>,
	<gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240124165813.GF6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURSF8zrTzrQCGQrIdUGSIokgm4hmXFPikiKu/DDGBLWxE0RbIB3B
	pWmCCSaK0RIFkQqCaKXWjU2kKChEikKNS5WlKovWhSouKWIUBaGjhn/fffec9+65eSQmvsCf
	Sian7GbUKXKlRCDCayw/HoZ/0VQwUY3tk+hqSzeibQ4vui2rnqCt/S6crvtVS9CdOW8Q3dh6
	iKDr75v5UlLWWgoys/4lIas0HRbIHlyMlX1ueCaQuSpnrBdsFi1WMMrkDEYduXSbaMfXfjuR
	1uyx11p4mchEP4TZSEgCFQP17+/h2UhEiikjgoKqRowrBhEM5Dn5XOFCYBw8K/hneW/oEnCN
	MgT5Izr8v2rk6FseV9xE8MR21W3xpJZCRaMTjTNOBcPd3F4ed+4N9wsc+Dj7UYHQYz9FjLMP
	FQmny0vdXl8qBO4OtbsvxahsHlTllbvNGOUPdkfxGJOkgAqFA4fdXuHYeIUXbvE5SQgcvDFM
	cBwINwYKsXE5UEGQZ1jFpdFCa7Wdx/EJIdQV7OF4OZR32BDHPuBsqSY4ng6j5uK/eg286Rx2
	7wuoLAQ68zUBd/8iOGZVcppY+Kkr+vusF3QOeHPTeMHxmnwsBwXrJyxCPyGXfkIA/YQAJQg3
	IX8mnVUlMezcFGZPBCtXsekpSRHbU1WVaOwrtY20fKtFRufXiCbEI1ETAhKT+HrGzKtgxJ4K
	+b79jDp1qzpdybBNaBqJS/w9gxWBjJhKku9mdjFMGqP+1+WRwqmZvCu523QZW5a1N8TZhdWp
	x6TrRzN6brfM9OmOjdZ2ZAX1bcgUlXc3077e2Vq/8Nld0UOTN8oro848GwzICVAYiz9q8sNA
	9CLuwWNJq+HRQrrLf8rrJb+pSJvB9OnsOUJxamXxApvEMKrfFNP3ENtviT1UujjkvH0jaXLF
	9O20rdY6NAmXrHOfSl9VjHioTrIlWqfqjotNPL9CS/S7cqtkM4YP9OpallmevLtlOWpcJ803
	VG1ITMPiX68pu9e8pKxwZ31NmF089KstkkjQdnfl6Lyj4z8k2II6h7VTOuabIED3XaqxOk7k
	zXoeei2ajW8K8DATDUfe9ZUp+WuvFyEJzu6QzwnF1Kz8D+CWDiS5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xu7rvqzemGqzv0bbYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAW5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
	apG+XYJexseXt9gLjvJUnJmzhr2B8SdnFyMnh4SAicSLpTfZuhi5OIQEljJKtHX9YYJIyEhs
	/HKVFcIWlvhzrYsNxBYS+Mgo0fBVGKJhN6PE7v1/wYp4BewkNh58xQhiswioShyZ8oAJIi4o
	cXLmExYQW1RAXuL+rRnsILawgL7E7A2LwIaKCGhKHPl2jQlkKLNAF5PE5qkbmCA2XGWUWDb9
	MdgkZgFxiVtP5gPZHBxsAloSjZ1ggziBXpizbA8rRImmROv23+wQtrzE9rdzmEHKJQSUJaYu
	9YJ4plbi899njBMYRWchOW8WkgWzkEyahWTSAkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmb
	GIGxvO3Yzy07GFe++qh3iJGJg/EQowQHs5IIr4npxlQh3pTEyqrUovz4otKc1OJDjKbAMJrI
	LCWanA9MJnkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUzzzveJ
	5kl/LPN4MWV2yETvyY6LP1t/PZ+tIv/hYpLMjXrZH1OmhwUJGVgU+1QlZfJsEd3pq+Xb3TXp
	0ouJL57O+3q1dv7HW9tXTZmsb7vtRpMas0PX1xYehYjFUeZHPu6eMPmb95PYBx6Bi7STX9au
	X7x36iIvGSOzwkMHZq3Y579o5+z+tE3GxbUdUxclWRva7sjr/WtxmfWVz1zFhfuZ1y2/MF+y
	Ven2g4UX17yXWiz8uWjub88zMznexc379eDcs85/uxt3BF2/u7tz3x1/HaH8vDV6Hzh3XMxx
	vpG/UWFj5CuxHbw8D7pzYy+s0lm+PCi6ma2v0CvSIubpLKl/vIxab5PPTE79ELDwev19XiWW
	4oxEQy3mouJEACh5cEFuAwAA
X-CMS-MailID: 20240124210655eucas1p124049fc160428b3799354a7837f10d5c
X-Msg-Generator: CA
X-RootMTR: 20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab
References: <CGME20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab@eucas1p2.samsung.com>
	<87frynkfao.fsf@doe.com> <d1cd9f19-21ed-430a-b146-906a6b6f0f70@samsung.com>
	<20240124165813.GF6226@frogsfrogsfrogs>

>> The issue is 'xfs_wb*iomap_invalid' not getting triggered when we have larger
>> bs. I basically increased the blksz in the test based on the underlying bs.
>> Maybe there is a better solution than what I proposed, but it fixes the test.
> 
> The only improvement I can think of would be to force-disable large
> folios on the file being tested.  Large folios mess with testing because
> the race depends on write and writeback needing to walk multiple pages.
> Right now the pagecache only institutes large folios if the IO patterns
> are large IOs, but in theory that could change some day.
> 

Hmm, so we create like a debug parameter to disable large folios while the file is
being tested?

The only issue is that LBS work needs large folio to be enabled.

So I think then the solution is to add a debug parameter to disable large folios
for normal blocksizes (bs <= ps) while running the test but disable this test
altogether for LBS(bs > ps)?


> I suspect that the iomap tracepoint data and possibly
> trace_mm_filemap_add_to_page_cache might help figure out what size
> folios are actually in use during the invalidation test.
> 

Cool! I will see if I can do some analysis by adding trace_mm_filemap_add_to_page_cache
while running the test.

> (Perhaps it's time for me to add a 64k bs VM to the test fleet.)
> 

I confirmed with Chandan that Oracle OCI with Ampere supports 64kb page sizes. We (Luis and I)
are also looking into running kdevops on XFS with 64kb page size and block size as it might
be useful for the LBS work to cross verify the failures.
