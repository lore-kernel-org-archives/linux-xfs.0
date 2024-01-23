Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7A35BAEB
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 08:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705999966; cv=none; b=KcSH4f8PwHM1RCSY6kpdDLvx6dhqWhIsrZv26Go4Z6CJLkAWWsTfAuEEgBTTEp0yqsSzTtLtUythxHmE4ieoSQGAs82qEKC2AFOcafVfId+pQA06canLbyZ+/a7Lltw066c0NfeGS9EHZ/rksbkzHEy/aANeajmgaIEQyzSmMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705999966; c=relaxed/simple;
	bh=zCMObol4b12cq/cEWDKuJLeayppKKIXxi/Yv2nee210=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=CVsWufHu3ql5oePLbEu5bgFojZRqLKY7zTYfcOhC2l+l3WVN22AjyG+iQbgv66GzjT7uoc9YocX0jkNgdg8b87JBKsK3c2l0Nr1PqcRAWqcYj8+TRQWCezsPGDUTeKnPG0Qg8e3YQkwJ6c7RF9hxmlWvZzvErj8tgYHczp4F2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DdIVAt9O; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DdIVAt9O"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240123085241euoutp01b4ca76e41fa199da71b9ecadfd5ffdd7~s7e01zME-1106711067euoutp01G
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 08:52:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240123085241euoutp01b4ca76e41fa199da71b9ecadfd5ffdd7~s7e01zME-1106711067euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705999961;
	bh=fVyd12SgA25HZ/4Y6a3Pb/lWglH2MBlmPqT52L5l9a0=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=DdIVAt9O7jcMdliU7+nn1+2AkD5QLqQG8n38o5P63R6kmBO1bSpKpTevsonUaJz/9
	 0czMKMXx1GeKPU1OAfKSWOhRAakTT/cWmdeC+NUhkyYO+Q14mUd8MVHfq9eAqGtRxv
	 sOWd0tjy4tKRWR+C/PRWlBckViEXQvWNduBF7qEA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240123085241eucas1p24a0275737fbe0bd314aaa0e4738a1d3b~s7e0rVo9e1254112541eucas1p2D;
	Tue, 23 Jan 2024 08:52:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 7B.B4.09552.95E7FA56; Tue, 23
	Jan 2024 08:52:41 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240123085241eucas1p20e4f3568f634213c469737b626f8ce64~s7e0SrWVD3053230532eucas1p2p;
	Tue, 23 Jan 2024 08:52:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240123085241eusmtrp2457249366e4aa6c11531d119710801ba~s7e0R6laz0751907519eusmtrp2G;
	Tue, 23 Jan 2024 08:52:41 +0000 (GMT)
X-AuditID: cbfec7f5-853ff70000002550-eb-65af7e59736e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id B1.7A.10702.95E7FA56; Tue, 23
	Jan 2024 08:52:41 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240123085241eusmtip2c7f634f940bcd39b29b89d87dc592259~s7e0F7fec1989719897eusmtip21;
	Tue, 23 Jan 2024 08:52:41 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 23 Jan 2024 08:52:40 +0000
Message-ID: <69e73772-80e2-4cfe-a95d-d680d7686e3c@samsung.com>
Date: Tue, 23 Jan 2024 09:52:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fstest changes for LBS
To: Dave Chinner <david@fromorbit.com>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <djwong@kernel.org>,
	<mcgrof@kernel.org>, <gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <Za8HXDfoIK+lyMvR@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7djP87qRdetTDZ4+0LbYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAWxSXTUpqTmZZapG+XQJXxsyLU1gLnnFVnFq0kLmB8TxHFyMnh4SAicSL138Z
	uxi5OIQEVjBK/Fm1nh3C+cIocfxhLzOE85lR4lfDRzaYloVfLjCD2EICyxklunbHwhVt/tbB
	AuHsZpR48fA/WAevgJ3E5XefwGwWAVWJ3ZcXsELEBSVOznzCAmKLCshL3L81gx3EFhbQl5i9
	YRFQPQeHiECsxJ3VWSAzmQWOMEp8/P6aCaSGWUBc4taT+UwgNWwCWhKNnWCtnALGEn33zjFC
	lGhKtG7/zQ5hy0tsfzuHGaRcQkBZYupSL4hfaiVObbnFBDJeQqCfU+JKdzMLRMJF4sOqm6wQ
	trDEq+Nb2CFsGYn/O+czQdjVEk9v/GaGaG5hlOjfuZ4NYoG1RN+ZHIgaR4mXn74wQYT5JG68
	FYQ4h09i0rbpzBMYVWchBcQsJI/NQvLBLCQfLGBkWcUonlpanJueWmycl1quV5yYW1yal66X
	nJ+7iRGYkk7/O/51B+OKVx/1DjEycTAeYpTgYFYS4b0huS5ViDclsbIqtSg/vqg0J7X4EKM0
	B4uSOK9qinyqkEB6YklqdmpqQWoRTJaJg1OqgclxZ78t5/rSyLJJ813f7vi1IPzgwvWTdpiy
	zre0qjjOn5TwLH3akuacdzPm/K/4NnPhHTWWnL5dMbXvzlxOf7ri1o6GPsczv5Z6JZUzNxxY
	cXs3P6vYYvGwcwXGy6rirnoUX9H12rNe27j49YwChR0z3j/ZqFXXapLWGPu03fP1IWn+BVed
	ryw87trvvfLzku2WzGvid1tH5v09UPox/9Tpsu3aOkd6jRj+xB9ySl/urLh4ibqRnGmQ5zfz
	B7xelytS6jt/iSw6bfDB9pjta9ZpzZGvjf0Xs/x2O7048fSU+u1u1UcfKa0xOupy9Mo0Lxfu
	alXDUBWVFlOFRIEzZXferr9wUX3mtjOdxbMs2B2VWIozEg21mIuKEwE6aBEmuAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xe7qRdetTDTqm8VlsOXaP0eLyEz6L
	0y172S3OvPzMYrHrzw52ixsTnjJaHDzVwW6x9+ROVgcOj1OLJDx2zrrL7rFpVSebx9mVjh7v
	911l8/i8SS6ALUrPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7Ms
	tUjfLkEvY+bFKawFz7gqTi1ayNzAeJ6ji5GTQ0LARGLhlwvMXYxcHEICSxklzp9YwAqRkJHY
	+OUqlC0s8edaFxtE0UdGieaXf1khnN2MEkue72IEqeIVsJO4/O4TG4jNIqAqsfsyxCReAUGJ
	kzOfsIDYogLyEvdvzWAHsYUF9CVmb1gEVM/BISIQK3FndRbITGaBI4wSH7+/ZoJYsAvIWXIU
	bAGzgLjErSfzmUAa2AS0JBo7weZwChhL9N07B1WiKdG6/Tc7hC0vsf3tHGaQcgkBZYmpS70g
	nqmV+Pz3GeMERtFZSK6bhWTBLCSTZiGZtICRZRWjSGppcW56brGRXnFibnFpXrpecn7uJkZg
	LG879nPLDsaVrz7qHWJk4mA8xCjBwawkwntDcl2qEG9KYmVValF+fFFpTmrxIUZTYBBNZJYS
	Tc4HJpO8knhDMwNTQxMzSwNTSzNjJXFez4KORCGB9MSS1OzU1ILUIpg+Jg5OqQamtVp1cRoN
	VS4bn1f/vemcdyf5c6qE0ptPDdP9j8StnzXvkOtSzagXN/kVV894kpf46FffS423AVNiUnKF
	RN0Kdn6IUVY+8E2DmUvd4SnD//aFpR2vOdxe553zKk041f00u119s/rah5F8FyLLVwTLHjgw
	/+br7uS90+M6nWc4bubPPMjNGd9tn7yd4cyMLY0xK/edvXvo73+ZBaINzn/02pye3RbNPrFu
	t89E/eXrph/zeTVDPXPqWbdP1UllrGXNU7bbNj0VfFT/9+4l70jZ/6nTs58nXZrxsKcg1/pz
	Y/W7U8E2hcs1r012fmsuK687WWnu3qeTy3w2v73HqRqaYnDlUfQN+a4X7zkD2sWvKLEUZyQa
	ajEXFScCAJyBKepuAwAA
X-CMS-MailID: 20240123085241eucas1p20e4f3568f634213c469737b626f8ce64
X-Msg-Generator: CA
X-RootMTR: 20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6
References: <20240122111751.449762-1-kernel@pankajraghav.com>
	<CGME20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6@eucas1p1.samsung.com>
	<Za8HXDfoIK+lyMvR@dread.disaster.area>

On 23/01/2024 01:25, Dave Chinner wrote:
> On Mon, Jan 22, 2024 at 12:17:49PM +0100, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> Some tests need to be adapted to for LBS[1] based on the filesystem
>> blocksize. These are generic changes where it uses the filesystem
>> blocksize instead of assuming it.
>>
>> There are some more generic test cases that are failing due to logdev
>> size requirement that changes with filesystem blocksize. I will address
>> them in a separate series.
>>
>> [1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>>
>> Pankaj Raghav (2):
>>   xfs/558: scale blk IO size based on the filesystem blksz
>>   xfs/161: adapt the test case for LBS filesystem
> 
> Do either of these fail and require fixing for a 64k page size
> system running 64kB block size?
> 
> i.e. are these actual 64kB block size issues, or just issues with
> the LBS patchset?
> 

I had the same question in mind. Unfortunately, I don't have access to any 64k Page size
machine at the moment. I will ask around if I can get access to it.

@Zorro I saw you posted a test report for 64k blocksize. Is it possible for you to
see if these test cases(xfs/161, xfs/558) work in your setup with 64k block size?

CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.
