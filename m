Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8071B4B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646872; cv=none; b=uvBb65TS/XirwqXiQj8TSfbca51nNUJg5dEarRBd1xtlGNLJcc9WvIs7R85GI7YD/M/ROdQMe02AteBT14gKQrnMFTmAQk92341I0PU4yKgX9LtssSAou6CO72zLtsJ5jao3YXZvN2LUwDaqqwFgYHxmuaFdwHKbLDWizqzDN4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646872; c=relaxed/simple;
	bh=MOEgyBy6AQ2cE+HPMjcNafFOzCKvQU1BfR+gkChA+wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=BJgx7GgwXKIZ9r/KzPahIteN3ANGdnL10rWkYjvRx6uRx7qMTkK7vX1O53bFb5oDiEz2XwyEL25MnduC2G+LfaXP23KzWmR/h0L7HXEMrkD87MKfLbfrdQ8eZX/1W+czsxT49zTkHn5CcYFZn0GlCryHxQ70PIs3KCCXDKxb2qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HDarB+w5; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HDarB+w5"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240130203427euoutp026806163f2c51add48d5c67ff5b649566~vOkifdC3Y0836408364euoutp02W
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 20:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240130203427euoutp026806163f2c51add48d5c67ff5b649566~vOkifdC3Y0836408364euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706646867;
	bh=rza+BIR8Pk1YeanUjAZtj1WSy7ZOJqDGs1bm3qSTE6U=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=HDarB+w5f0yi8TUBtNeZm8VbAAAOg1c6/QH8uc7Yjgpx8yALhyv8H+o6Buuawv+T6
	 hRPuenw4hvnFTYVumYXKFC3w7w/dGsfM8Dr1kb3YUsC37dLxjr7Vw7UYKfgLaYP2Ez
	 DDGbQccysCXCWlpPh2LFcmz6d+gfZtqVbwOKLF84=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240130203426eucas1p1903f6f935ffc466524c4be17d6973299~vOkhWOnn91096610966eucas1p1w;
	Tue, 30 Jan 2024 20:34:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id E3.6A.09814.25D59B56; Tue, 30
	Jan 2024 20:34:26 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240130203425eucas1p2096458b56eac69cb64c4f729df15390e~vOkgxlC4v0322003220eucas1p2y;
	Tue, 30 Jan 2024 20:34:25 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240130203425eusmtrp20a236d723aa46e947b8b94788bb183fb~vOkgxFQc50818408184eusmtrp2J;
	Tue, 30 Jan 2024 20:34:25 +0000 (GMT)
X-AuditID: cbfec7f4-727ff70000002656-ff-65b95d52300c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 64.2E.10702.15D59B56; Tue, 30
	Jan 2024 20:34:25 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240130203425eusmtip2664103d89b96fa49a54fcc6f1c4bfb80~vOkgkPOSj2853228532eusmtip2u;
	Tue, 30 Jan 2024 20:34:25 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.241) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 30 Jan 2024 20:34:24 +0000
Message-ID: <6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
Date: Tue, 30 Jan 2024 21:34:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <fstests@vger.kernel.org>, <zlang@redhat.com>, Dave Chinner
	<david@fromorbit.com>, <mcgrof@kernel.org>, <gost.dev@samsung.com>,
	<linux-xfs@vger.kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240130195602.GJ1371843@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzH973nubun49rjXLvPQpFOaVM64TFmMrYjSyubRuimr9NcV7uT
	36zmWCKdyHFZVGspYd1SHQqnxFWyuOSGjAtlJ1w15OfTE+u/1+fzeb8/3+/7uy9FSEr5vlSy
	djvWaVWaAIGIrLn3rX1W7AYrnl2Qx2eq771EzGOXN9NiqBcyrb0ekrn+o07IdBl7EHPHniVk
	6h9Y+Usopb0YlFbzC6HSUnFEoGwrj1T2NzgESo/FL0awTrQoCWuSd2Bd2OJE0da7X8VppdJd
	Vd9vExmoSZyNvCigI6CzvpvMRiJKQl9EYHl3ks8VAwiemp4KucKDoKb3guCfxdBtGVWVITB+
	yhf8V5VmfUBccQOBx9zxd0JRYnoxHHfIWTdJy8E6YBOyLKYnwIOzLpJlH9ofup1nRvoT6Sho
	77tFsCylZ0LjUCeP3UnQ2TzoyeTMBC0Dp+s8j90voEMg84iQRS96Pnws2cIpZsKh2uFRtT/U
	us8RXIDpUPKoE3G8H+zVzpH1QOd6Qe3BApIbLINiZ8OoYSL0NVcLOZ4Mv63ssSzvhZ6uYYIz
	GxDkWq+O5AV6IRxv1XCaSPhVOMjn2t7Q5Z7A3ccb8mpMhBHJzWNewjwmmHlMBPOYCBcQWYFk
	OF2fosZ6hRbvDNWrUvTpWnXo5tQUC/r7k1p+NQ/UobK+z6E2xKOQDQFFBEjF5X5WLBEnqXbv
	wbrUTbp0Ddbb0CSKDJCJ5Un+WEKrVdvxNozTsO7flEd5+WbwCreNv+6KMYdbVyorTuVEKwJ7
	ZiPDpS32Z1N6q64FpX70e1Gummu3uQ/y8ThH5pWCnIQF95VxYTjjhOHY71W7B5sOzLiYvL4s
	2tbZd225r7FmDlG3xkeSd1MRgl+5nvPijdKpTe9PR7QNHLrP9ylcq2gstw+tDxnaVWTS9gcl
	KlTHJI6snw6Y1O95EpT8tb058WHC29eXW4JbO3aG+7Q91xyd81MWU3Qg98t59WvTqtjUN0/G
	LY17t2SFK1FcFlapH7qzMerty0D33A9nJ5taK2SWfN3mw/L8Rwlxq+MZu7tBejiuIzg6xxlI
	TRte9LCrct7J6fsG80VJ6rWexrv+OZHtAaR+qyo8hNDpVX8A4gYQIbgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/xe7qBsTtTDY4tlbTYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAW5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
	apG+XYJexuEfvAVLRSo2/jrA3MB4lLeLkZNDQsBEouX+JtYuRi4OIYGljBIL3v5mgkjISGz8
	cpUVwhaW+HOtiw2i6COjxK3NX6Gc3YwS33c9Z+9i5ODgFbCT6LuqCtLAIqAqsfPLIXYQm1dA
	UOLkzCcsILaogLzE/VszwOLCAt4S51/tZwaxRQQ0JY58u8YEMpNZoItJ4mkjSDPIgv2MEos2
	nmADqWIWEJe49WQ+E8gyNgEticZOsL2cAuYS7xanQVRoSrRu/80OYctLbH87hxniAWWJxReu
	MULYtRKf/z5jnMAoOgvJebOQLJiFZNQsJKMWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93E
	CIzkbcd+btnBuPLVR71DjEwcjIcYJTiYlUR4V8rtTBXiTUmsrEotyo8vKs1JLT7EaAoMo4nM
	UqLJ+cBUklcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwKSt6GP9
	+/aR6MBG2egVDs9zLsrwCSgt1tu3eXPuUckHLcUT68wi+D9sWM0x78jlmQ8YX74T3rGx7pl5
	QLrOPSmrHMnVG0y0WW2PX/gs1Wjw+/X9R2KP59pXZZjEsp0w+10i5cWzfv0R3ZVvpJ2vPP/9
	0e1N5AORyj3RNn2GSjM81jAsFHnrefDFE9k5+sXn397T8PY5zqVl99KtYuWnSc7vnJb7sp/s
	7m/n967RYFm8JfYXz/+v+58LH0zZmKh68XutQuijtHddxs7HsoJz5LOEGjcfa097F8dRdHLG
	Zfm2HFWmjohTS6xrP+/9Iv71seqM/Bnr01f0enukOEu4vPbcI8Jmkyrz+aGRSoz+XyWW4oxE
	Qy3mouJEAEZEiV1tAwAA
X-CMS-MailID: 20240130203425eucas1p2096458b56eac69cb64c4f729df15390e
X-Msg-Generator: CA
X-RootMTR: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
	<fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
	<20240130195602.GJ1371843@frogsfrogsfrogs>

>> What should be the approach to solve this issue? 2 options that I had in my mind:
>>
>> 1. Similar to [2], we could add a small hack in mkfs xfs to ignore the log space
>> requirement while running fstests for these profiles.
>>
>> 2. Increase the size of filesystem under test to accommodate these profiles. It could
>> even be a conditional increase in filesystem size if the FSB > 16k to reduce the impact
>> on existing FS test time for 4k FSB.
>>
>> Let me know what would be the best way to move forward.
>>
>> Here are the results:
>>
>> Test environment:
>> kernel Release: 6.8.0-rc1
>> xfsprogs: 6.5.0
>> Architecture: aarch64
>> Page size: 64k
>>
>> Test matrix:
>>
>> | Test        | 32k rmapbt=0 | 32k rmapbt=1 | 64k rmapbt=0 | 64k rmapbt=1 |
>> | --------    | ---------    | ---------    | ---------    | ---------    |
>> | generic/042 |     fail     |     fail     |     fail     |     fail     |
>> | generic/081 |     fail     |     fail     |     pass     |     fail     |
>> | generic/108 |     fail     |     fail     |     pass     |     fail     |
>> | generic/455 |     fail     |     fail     |     pass     |     fail     |
>> | generic/457 |     fail     |     fail     |     pass     |     fail     |
>> | generic/482 |     fail     |     fail     |     pass     |     fail     |
>> | generic/704 |     fail     |     fail     |     pass     |     fail     |
>> | generic/730 |     fail     |     fail     |     pass     |     fail     |
>> | generic/731 |     fail     |     fail     |     pass     |     fail     |
>> | shared/298  |     pass     |     pass     |     pass     |     fail     |
> 
> I noticed test failures on these tests when running djwong-wtf:
> generic/042
> generic/081
> generic/108
> generic/219
> generic/305
> generic/326
> generic/562
> generic/704
> xfs/093
> xfs/113
> xfs/161
> xfs/262
> xfs/508
> xfs/604
> xfs/709
> 

Ok, there are some more tests that I didn't catch. I will check them out.

> Still sorting through all of them, but a large portion of them are the
> same failure to format due to minimum log size constraints.  I'd bump
> them up to ~500M (or whatever makes them work) since upstream doesn't
> really support small filesystems anymore.

Thanks for the reply. So we can have a small `if` conditional block for xfs
to have fs size = 500M in generic test cases.

We do this irrespective of filesystem blocksizes right? If we do that, then we can
remove the special conditional that allows tiny filesystems for fstests in mkfs
as well.

--
Pankaj


