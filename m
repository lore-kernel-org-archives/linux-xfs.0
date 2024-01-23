Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867E9481C7
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 16:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706027594; cv=none; b=bamQdqTEykFjv7bUz3DjzkLG/z0z1HCEIZixK909MpIHPRWGhpP9+2Met6zDbopxA2qngzcCzg8y6rQ3SzLDZ5vRtkUjr3tyllvHzNpJero5UKegAOEAlSiE2RPUKBRGxuuLrpTQIRRXtm500ea7dV0LOwZ3bUzSdmUCUQQy8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706027594; c=relaxed/simple;
	bh=Q77xxShNMeRs7BHWraYtqnEFudzFCKh+hitevxdkmrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=jeHB/the1Nj1+fhE0NflaspYgPjW6P2hGdSgVaWfk7nh8gb3rL24QLLBYCo9JsI87KaAPnu/jL5zLbcb/fNm7YhcjZXEhb52PlcCeveSTyMaCtyBYD6EKvDism5nUnAVQbHw5O1r6/ErmDYpSuHIRJeMT0MNUqkPPe+ZH3574dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cG6a8W9l; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cG6a8W9l"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240123163304euoutp01ff61d6f5dc442045e30c4122a9db2398~tBwypWSSx0433604336euoutp01J
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 16:33:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240123163304euoutp01ff61d6f5dc442045e30c4122a9db2398~tBwypWSSx0433604336euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706027584;
	bh=YHH43JjoVgeO5m+cc0VEKNzZa/AUKzzDp04vUVMVENs=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=cG6a8W9lNVXqBIrTgcwATu5z8fITNjoArE8Zaz2k66+QDh+MA9eUl/3KnKNxrF0YJ
	 o/OrnKFzG4qCFujWDlSedJeVBD/HWk8Xpjl+z9h3n10MrnVpDNJ2N6xm4D97/s7vll
	 4mm7MxfiSpEDPI+9roOX27UdsyBCZplSZkNi5r8A=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240123163304eucas1p19fe014f9e1ee04e02b69d603d372a8a7~tBwyaacjb1708617086eucas1p1i;
	Tue, 23 Jan 2024 16:33:04 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id F0.A4.09539.04AEFA56; Tue, 23
	Jan 2024 16:33:04 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240123163304eucas1p2e02805bd3768ed36f5a48dda83d402ff~tBwx-QrVY2815728157eucas1p2C;
	Tue, 23 Jan 2024 16:33:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240123163304eusmtrp16cb41bdc02ddcbf5030f9c853cc1c33b~tBwx_nk4V2482324823eusmtrp1k;
	Tue, 23 Jan 2024 16:33:04 +0000 (GMT)
X-AuditID: cbfec7f2-d90aea8000002543-7b-65afea4095e7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 59.F7.09146.F3AEFA56; Tue, 23
	Jan 2024 16:33:04 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240123163303eusmtip25e390eab88c272bd2c8329e3478054cc~tBwx0uowt2801328013eusmtip2O;
	Tue, 23 Jan 2024 16:33:03 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 23 Jan 2024 16:33:02 +0000
Message-ID: <7964c404-bc9d-47ef-97f1-aaaba7d7aee9@samsung.com>
Date: Tue, 23 Jan 2024 17:33:02 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fstest changes for LBS
To: Zorro Lang <zlang@redhat.com>
CC: Dave Chinner <david@fromorbit.com>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>, <fstests@vger.kernel.org>, <djwong@kernel.org>,
	<mcgrof@kernel.org>, <gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240123134310.6mrzqdvs64ka6o6p@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzH+z7Pc3fP3dzt68r6kNxkF2Wl/Jin1ZL5dZjfFMq46emYu2p3
	5bdx0vRrHEk6mhhKS2eJrog5VrokRtvJ/FpXueOIC+MQ14P13+u79/v92ef92Zcmped4o+jN
	qRmsNlWpDuKLqGtN3x6ExTlNbITHEMDUNr1AzGO7hGk90Chg7jvcFNPwwyxgbIZuxNy25giY
	xpZ6XhytsJ4FRb3xuUBRU5nLV7RdnKn4cLODr3DXjFnKXyuKSWbVm7ey2kmxG0Sb8quf8NKv
	SrcXPrtD7UO14jwkpAFPBVv5DSIPiWgprkDw6vtznleQ4n4EZb0MJ7gRfM35jP4lzjVlUZxQ
	juDNkXbiv+uz/ouAe1xH8PZg1x+FpsU4FpxXIrxpCstB/7OM8rIYD4eWEvsgj8AyeNl5QuBl
	XzwJTl4+y/eyHx4LVd8ekd6ZJM4nwHHsPeEVSOwPnfbTg/P5OBT0uYNZIU6CiqwiirOEQHad
	R8CxDOpcp0ivHfA4KDq/gCuzB6y1nYP7Ay4UQu7DRwTnmQ3VJjnn8QVnc62A49HQWlhAcbwL
	um0eksseQHC43sTnstFw6L6a88wEx6f+vyMlYHMN57aRwNFrxaQByY1DDmEc0ss4pIBxSIEy
	RFUifzZTp1GxushUdlu4TqnRZaaqwjemaWrQn4/U+qv5kxmVOj+GWxBBIwsCmgzyE9tGVrNS
	cbJyx05Wm7Zem6lmdRYUQFNB/mJ5soyVYpUyg93Csums9p9K0MJR+wh55YKwqCrjcTpj4vyT
	jqj4IseApoKxzlqSf3G26vqzYQGSNQvdgS+s0yKL37oczvelulXihmDP3FCVO+th336bcaRP
	vytqpU/39JsTz19dn3BaGl9d3LH63g67fxfxctuEDZZTfXs6Ikwp1Jbmlp4zyFGY0NWXtoIO
	rjLPMO8s3b2sIZ7Qh+3tXcS2qU2JWV+bHcE+oTLcY8jxZAe+u1Au8VvOc+nz7Wf8qqZMP2KI
	jStJjB9IssQIx89obCFMt+5Obh+myKait9sPFax+feWEs30gSeZbs3Bdz685a98lU7tKFgem
	aBrgx4quCN684kxRXJkxJib9TvQlfYg5u/dpEKXbpIwMJbU65W9xKcMttwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xe7oOr9anGuz9y2ix5dg9RovLT/gs
	TrfsZbc48/Izi8WuPzvYLW5MeMpocfBUB7vF3pM7WR04PE4tkvDYOesuu8emVZ1sHmdXOnq8
	33eVzePzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy
	1CJ9uwS9jO51V1gLtgpVTL59mKWBcQtvFyMnh4SAicSSY80sXYxcHEICSxklDrw+xgyRkJHY
	+OUqK4QtLPHnWhcbRNFHRonr/b+hOnYzSuxY+5ixi5GDg1fATuLVZgOQBhYBVYnGvwtYQGxe
	AUGJkzOfgNmiAvIS92/NYAexhQX0JWZvWMQGYosIKEqs+XmRGWQms0A3k8TLKe+YIBYcZJL4
	/W0B2BnMAuISt57MZwJZxiagJdHYCTaIUyBGYkXzVBaIEk2J1u2/2SFseYntb+cwg5RLCChL
	TF3qBfFMrcTnv88YJzCKzkJy3iwkC2YhmTQLyaQFjCyrGEVSS4tz03OLDfWKE3OLS/PS9ZLz
	czcxAmN527Gfm3cwznv1Ue8QIxMH4yFGCQ5mJRHeG5LrUoV4UxIrq1KL8uOLSnNSiw8xmgLD
	aCKzlGhyPjCZ5JXEG5oZmBqamFkamFqaGSuJ83oWdCQKCaQnlqRmp6YWpBbB9DFxcEo1MC1o
	4eOJ52bP/zIvKOTFXFdOM33HFw+t/4o3sJwXUl3iwHL5mDmDVxnTTh9H0yjtFbFBjVMmxbfr
	7XZ6GfSosle45uwPdQb5D4dUD3L5PNLbqR6myaT35eSq1UK/Jia+0NnVvzj9dXWtxCKG6t/q
	KuxhN1jtS3wb8n5Mqn9ud3PBm8Ve02YYWobJf/N8FpzELDeJ7fj6t5Vick5lmef2551V7ko6
	ZxtmNPPyqgm6kwsCWOacSy4y/Nt4eptFyDt2v1OaPPmnCg8zvV2ex8KWFPGdP3DCqdaHG36c
	04rmEVzQdv6rn5a6NW/yppvXk/7OiYuWsbnGWn+PW2Bf1Ixy4a92c3pSp7/TvNfMeNxaiaU4
	I9FQi7moOBEAaNMWf24DAAA=
X-CMS-MailID: 20240123163304eucas1p2e02805bd3768ed36f5a48dda83d402ff
X-Msg-Generator: CA
X-RootMTR: 20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6
References: <20240122111751.449762-1-kernel@pankajraghav.com>
	<CGME20240123002508eucas1p16e632cbdbc7abf62fc1fde342bbaa3d6@eucas1p1.samsung.com>
	<Za8HXDfoIK+lyMvR@dread.disaster.area>
	<69e73772-80e2-4cfe-a95d-d680d7686e3c@samsung.com>
	<20240123134310.6mrzqdvs64ka6o6p@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

>> @Zorro I saw you posted a test report for 64k blocksize. Is it possible for you to
>> see if these test cases(xfs/161, xfs/558) work in your setup with 64k block size?
> 
> Sure, I'll reserve one ppc64le and give it a try. But I remember there're more failed
> cases on 64k blocksize xfs.
> 

Thanks a lot, Zorro. I am also having issues with xfs/166 with LBS. I am not sure if this exists
on a 64k base page size system.

FYI, there are a lot of generic tests that are failing due to the filesystem size being too small
to fit the log with 64k block size. At least with LBS (I am not sure about 64k base page system),
these are the failures due to filesystem size:

generic/042, generic/081, generic/108, generic/455, generic/457, generic/482, generic/704,
generic/730, generic/731, shared/298.

For example in generic/042 with 64k block size:

max log size 388 smaller than min log size 2028, filesystem is too small
Usage: mkfs.xfs
/* blocksize */         [-b size=num]
/* config file */       [-c options=xxx]
/* metadata */          [-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,
                            inobtcount=0|1,bigtime=0|1]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
                            (sunit=value,swidth=value|su=num,sw=num|noalign),
                            sectsize=num
/* force overwrite */   [-f]
/* inode size */        [-i perblock=n|size=num,maxpct=n,attr=0|1|2,
                            projid32bit=0|1,sparse=0|1,nrext64=0|1]
/* no discard */        [-K]
/* log subvol */        [-l agnum=n,internal,size=num,logdev=xxx,version=n
                            sunit=value|su=num,sectsize=num,lazy-count=0|1]
/* label */             [-L label (maximum 12 characters)]
/* naming */            [-n size=num,version=2|ci,ftype=0|1]
/* no-op info only */   [-N]
/* prototype file */    [-p fname]
/* quiet */             [-q]
/* realtime subvol */   [-r extsize=num,size=num,rtdev=xxx]
/* sectorsize */        [-s size=num]
/* version */           [-V]
                        devicename
<devicename> is required unless -d name=xxx is given.
<num> is xxx (bytes), xxxs (sectors), xxxb (fs blocks), xxxk (xxx KiB),
      xxxm (xxx MiB), xxxg (xxx GiB), xxxt (xxx TiB) or xxxp (xxx PiB).
<value> is xxx (512 byte blocks).

--
Pankaj
