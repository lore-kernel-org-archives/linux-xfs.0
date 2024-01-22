Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68671537EF
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944205; cv=none; b=FgSYGdJoqcmVyvKOAPaiTHWNJjrMqCozUObmLe+n1SSDww9huePoqkrEdP8ElKokaXNI8hsSjm2uDEhoVrAauLzvMctuM5ODLfY1fdMYTW4lIYY4y94hd4foZh31kMi+E+tAPww1FWk7szEFKvN+8UHKQxUOSuoXBvvv2OKRxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944205; c=relaxed/simple;
	bh=ccVq4iGRwR8pUoUKcsw6rNhTaOJ/vhBoYkNnYgdUTMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=gUBUVAS80toxJRFmtYrldxqToArmLSuRKIPdfxWvltW5Luj0t+GafXFTXH+kEFfS3oLy9sghsfRSTprSUvadmn2IPYWe29owAoMcJaD3phJlDTh+VJUnMpnzlnqUVpihAGMjLTedj4CS+lKeBp4ETEjU8AQOUa4J6yB796i12Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HgKUi7x0; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HgKUi7x0"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240122172321euoutp023c01ca79e61b66ecf4619016d5797b55~suzZzC00K3061930619euoutp02y
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 17:23:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240122172321euoutp023c01ca79e61b66ecf4619016d5797b55~suzZzC00K3061930619euoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1705944201;
	bh=sfX4nRusXl4Dv4T3rJymtxDSLAj3omMNW8dmpNN+9Kk=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=HgKUi7x0xdDBKmfL5zZ9Ocax/nXuz+OXBFuJ0M5wB+elEuSokmwX89CtDKxKo8HTo
	 yugEO8bB6FapOgVnJnNO7u1I5lk1sBBsJF7I2Vl+ScbWIFNmW+xcKflCb8tKFieGAQ
	 O5cKEwKYfnoDXPt5lxO+uxGNYzyKpbh+CEVrJpxw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240122172320eucas1p2bcc866472dc3bb1b725261e44c266a3d~suzYg381C3110531105eucas1p2p;
	Mon, 22 Jan 2024 17:23:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 9F.E4.09814.784AEA56; Mon, 22
	Jan 2024 17:23:19 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240122172319eucas1p2a2b5902e83d424e95a4f3f815c80b89a~suzYJk8Ov3111431114eucas1p2l;
	Mon, 22 Jan 2024 17:23:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240122172319eusmtrp1f3b10500bc76cbd8d69236153b16e5c8~suzYI-_yC3050130501eusmtrp1S;
	Mon, 22 Jan 2024 17:23:19 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-84-65aea4870ca8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id BA.12.10702.784AEA56; Mon, 22
	Jan 2024 17:23:19 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240122172319eusmtip1293f9096c2c9881dade037e57dfb9e9e~suzYAW6tR0573305733eusmtip15;
	Mon, 22 Jan 2024 17:23:19 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 22 Jan 2024 17:23:18 +0000
Message-ID: <cb8a9359-6678-4692-a76c-545f8bb44b00@samsung.com>
Date: Mon, 22 Jan 2024 18:23:16 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs/558: scale blk IO size based on the filesystem
 blksz
To: "Darrick J. Wong" <djwong@kernel.org>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <mcgrof@kernel.org>,
	<gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240122165336.GA6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsWy7djP87rtS9alGixZZGFx+QmfxemWvewW
	Z15+ZrHY9WcHu8WNCU8ZLfae3MnqwOaxaVUnm8fZlY4e7/ddZfP4vEkugCWKyyYlNSezLLVI
	3y6BK+Pr/sWsBa/4K84t2MvcwPiSp4uRg0NCwETix1yHLkYuDiGBFYwSl+fsZoNwvjBKfNt2
	lQnC+cwose/oD/YuRk6wjs6Vz1kgEssZJVad3cwOV3V1yhSo/t2MEjcfrmQEaeEVsJPYfnkP
	mM0ioCqx+s5Rdoi4oMTJmU9YQGxRAXmJ+7dmgMWFBYIlek+/YAOxRQQSJC5dm8wKYjML1Er8
	erqBGcIWl7j1ZD4TyBNsAloSjZ1grZxA1508uZQJokRTonX7b3YIW15i+9s5zBA/K0tMXeoF
	8UytxKktt8C+lBB4wyHx/ed2NoiEi8TdiwuYIWxhiVfHt0B9LyNxenIPC4RdLfH0xm9miOYW
	Ron+nevZIBZYS/SdyYGocZQ4uO8JO0SYT+LGW0GIc/gkJm2bzjyBUXUWUkDMQvLYLCQfzELy
	wQJGllWM4qmlxbnpqcVGeanlesWJucWleel6yfm5mxiByeb0v+NfdjAuf/VR7xAjEwfjIUYJ
	DmYlEd4bkutShXhTEiurUovy44tKc1KLDzFKc7AoifOqpsinCgmkJ5akZqemFqQWwWSZODil
	GpgmV7f+FVR7U8N5e4FZnPiypYEZ+w9kHrFzFdr9ooexIaf3h1ZK83TulwfvJT64vrbu7a+5
	Dy4e1bJpMYw+mTJnQui39ZrLCgL+5/5ok72YGzF3n60dB88c73fNuXq3d58vfWnNetdBLPXa
	6z7VigU+yTo/nltNbdGW0pawCWD82aHMttzh/t/4ir5Dd/7aufX1vt2yQsKETStjxZFgqaMT
	tubvSEhvSvq68/6jLCu7V0xf9h1p2bfxvZmVFKeLb4fSjbQVJwTrZp0QP132/syyiNz9GhFG
	Eo4fjSRYv4Zaf109I/nFkX65FRrCXm9ZW063q209+L7q4ym/O1uYaw89jOw7uT2ierfsa7+m
	uNtKLMUZiYZazEXFiQAu7MSHpQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xu7rtS9alGjQtUra4/ITP4nTLXnaL
	My8/s1js+rOD3eLGhKeMFntP7mR1YPPYtKqTzePsSkeP9/uusnl83iQXwBKlZ1OUX1qSqpCR
	X1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl/F1/2LWglf8FecW7GVu
	YHzJ08XIySEhYCLRufI5SxcjF4eQwFJGiZez57BAJGQkNn65ygphC0v8udbFBlH0kVHizLKp
	zBDObkaJVdNvs4FU8QrYSWy/vIcRxGYRUJVYfecoO0RcUOLkzCdgU0UF5CXu35oBFhcWCJbo
	Pf0CrFdEIEHi0rXJYNuYBWolfj3dALXgPaPE9hVv2SAS4hK3nsxn6mLk4GAT0JJo7ASbwwn0
	wsmTS5kgSjQlWrf/Zoew5SW2v53DDFIuIaAsMXWpF8QztRKf/z5jnMAoOgvJdbOQLJiFZNIs
	JJMWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzSbcd+btnBuPLVR71DjEwcjIcYJTiY
	lUR4b0iuSxXiTUmsrEotyo8vKs1JLT7EaAoMoonMUqLJ+cA0kVcSb2hmYGpoYmZpYGppZqwk
	zutZ0JEoJJCeWJKanZpakFoE08fEwSnVwLQiNljnZnl07saPU4N3dv6eKrlF5rSJXtgyicg4
	5ne+pW9CNxn4z711PehLdLL2kooHHbN913XEb3Lhq5zldeZCgMgJhu+zdnoUrHcrSeF85XLN
	KuJc/AuvFQKrJt7Q0xRmSvq05aLb70UvWa1S75zZLfvv3+3WPymqB9kuSRZ0tImE68pdXroj
	3b5P8cVkx63+08yiGv2Mql/zS03VMPT6upfhy4M8br2cif4Ni+yEnusovXO9XefqeZfNr2lj
	ZZVM9ow1RQenMcjGR0tbZLi/WjXTdXfqdd6Qds35J0qPXtXva/AXF8x8EH7BkNfRUnRl/jL9
	Lfeeei1isPT6x5mZsc45Vf7500rJzr19SizFGYmGWsxFxYkAvPZsOVsDAAA=
X-CMS-MailID: 20240122172319eucas1p2a2b5902e83d424e95a4f3f815c80b89a
X-Msg-Generator: CA
X-RootMTR: 20240122165342eucas1p2ad68d6c116aeae8673ac04d84ab54356
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240122165342eucas1p2ad68d6c116aeae8673ac04d84ab54356
References: <20240122111751.449762-1-kernel@pankajraghav.com>
	<20240122111751.449762-2-kernel@pankajraghav.com>
	<CGME20240122165342eucas1p2ad68d6c116aeae8673ac04d84ab54356@eucas1p2.samsung.com>
	<20240122165336.GA6226@frogsfrogsfrogs>

On 22/01/2024 17:53, Darrick J. Wong wrote:
> On Mon, Jan 22, 2024 at 12:17:50PM +0100, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
>> system(see LBS efforts[1]). Scale the `blksz` based on the filesystem
> > Fails how, specifically?

I basically get this in 558.out.bad when I set filesystem block size to be 64k:
QA output created by 558
Expected to hear about writeback iomap invalidations?
Silence is golden

But I do see that iomap invalidations are happening for 16k and 32k, which makes it pass
the test for those block sizes.

My suspicion was that we don't see any invalidations because of the blksz fixed
at 64k in the test, which will contain one FSB in the case of 64k block size.

Let me know if I am missing something.

> 
> --D
> 
>> block size instead of fixing it as 64k so that we do get some iomap
>> invalidations while doing concurrent writes.
>>
>> Cap the blksz to be at least 64k to retain the same behaviour as before
>> for smaller filesystem blocksizes.
>>
>> [1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>>  tests/xfs/558 | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/tests/xfs/558 b/tests/xfs/558
>> index 9e9b3be8..270f458c 100755
>> --- a/tests/xfs/558
>> +++ b/tests/xfs/558
>> @@ -127,7 +127,12 @@ _scratch_mount >> $seqres.full
>>  $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
>>  _require_pagecache_access $SCRATCH_MNT
>>  
>> -blksz=65536
>> +min_blksz=65536
>> +file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
>> +blksz=$(( 8 * $file_blksz ))
>> +
>> +blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
>> +
>>  _require_congruent_file_oplen $SCRATCH_MNT $blksz
>>  
>>  # Make sure we have sufficient extent size to create speculative CoW
>> -- 
>> 2.43.0
>>
