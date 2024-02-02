Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF551482FE
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706894319; cv=none; b=rqy8f00cMfzWJAH3EmI/iJ0a68UqEYjzVON96hlMoqjMqLSOWeD1Iyo9zVAjWFdGbG/VUFX9hbNQP/C+s0LnA6h/1XxXjpoF1+RaHwTJDiA8MmHP/BYjJYtcRH4qJelfEehqzfZujVU1FiG9tX1ljfttEx9NkoG3VYgVKi/rSMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706894319; c=relaxed/simple;
	bh=1ATuCyYNMsNdOcO84pLykDKK59ZrDRVYbQzKaoOWa2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=S0CCC9oq2zbv1ErUQjnWao62hr6OX/JGoP+MldlvU+8e2lwWi2QM2C/k2LXTQNHL+WccZrNaZIIaCaaeM9YRd+nPGIhOVC5/F1Sc757A/+82DEd8dmbzFjJC9tPZVAodnseBsNvi+jXHezmRz1evxomgoQQpfchm+vg03uUm+7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FOi784tn; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FOi784tn"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240202171834euoutp0109981a1e247d2ca2f0f8ffaf5e72078c~wG1XvhvBF2156121561euoutp01D
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 17:18:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240202171834euoutp0109981a1e247d2ca2f0f8ffaf5e72078c~wG1XvhvBF2156121561euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706894314;
	bh=teAIvMgdcx+J+DxlD91mFasQR7cbDW9Hc8S0t+wE7kU=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=FOi784tnOUrHxrg1wrOXgh2ECnJAnocjoNptAfNhJ3VUFZ2wv11DwRDs9W8ZxhGhy
	 EUwodeYIs2CHdBTY68Nsrfib6OshemJN6KP3PTdXv4kwivjDGBlU52mzLaJJdyFSvA
	 zg8trs7y9EEJqHHX9YW9025cV97J2lu6zPX260PY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240202171834eucas1p10af753a96222341cd48affe56d68b592~wG1XXwZr62904129041eucas1p16;
	Fri,  2 Feb 2024 17:18:34 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 11.A9.09552.AE32DB56; Fri,  2
	Feb 2024 17:18:34 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240202171833eucas1p2fa39cd004b2207b1c1b689005abc8757~wG1XBsDRo1985519855eucas1p2F;
	Fri,  2 Feb 2024 17:18:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240202171833eusmtrp10d0371d2da7c28ac07fc97105285583c~wG1XBHzZj0079700797eusmtrp1h;
	Fri,  2 Feb 2024 17:18:33 +0000 (GMT)
X-AuditID: cbfec7f5-83dff70000002550-f8-65bd23eaac49
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 2B.DB.10702.9E32DB56; Fri,  2
	Feb 2024 17:18:33 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240202171833eusmtip2fb1829840dcb0fedf224ba2fd242e0f0~wG1W3EW4o2332723327eusmtip2-;
	Fri,  2 Feb 2024 17:18:33 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.11) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 2 Feb 2024 17:18:32 +0000
Message-ID: <aa37283d-227f-48af-a639-43dc7113a483@samsung.com>
Date: Fri, 2 Feb 2024 18:18:32 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: fstest failure due to filesystem size for 16k, 32k and 64k FSB
To: "Darrick J. Wong" <djwong@kernel.org>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>
CC: <fstests@vger.kernel.org>, <zlang@redhat.com>, Dave Chinner
	<david@fromorbit.com>, <mcgrof@kernel.org>, <gost.dev@samsung.com>,
	<linux-xfs@vger.kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20240202164644.GK616564@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+3bO2c5Ws+M28+2io+WiwkuajZEhGUUTiRSh6KYtd1BzTtu0
	K5XVjBKp0SBriKkZ6SqNYa0F07KL6DQjNcxMTeellViYVmiSx1Pgf7/3e573e7/n5SMxURmx
	hEzVZdF6nVor4wrwR69+vw7yrHDSa5855iurX3UjZavbS+kyOnnKps9juPLJ1GOessM0gJTP
	Gi/ylM4GB7GJVDWWgsph+chT2ayXuKrmiijVaE07VzVm84/l7hFs1NDa1CO0PiTygCCleaiY
	m/lVcqzd/J3IQVUL8xBJAhUOd3oT8hCfFFHlCPor4/KQYIZ/IDCNvsdYYQzBtVIFw4z/j6cL
	saY7CG4YpzhsMWPKGXURbOFAMGgbwZkRQioSrr+OZ7pxKgAqa34TDAspb2i44cYZ9qGk0NN5
	ncewmIqBFk/t7GQJdQDevjPP3olRrQj6ppwcRsAoX+h03+Qw93OpNXD20mwvn1JAxaD7n2U1
	5NoneSxLwT5SiLEJZND2pZfH8ilorO6cDQBUAR+uXXiLWGELTLzPJ1gWg6e++l/DMnCZ83GW
	T8JAxyTGNhsRXHFUcdmdRsDlJi3riYLponGCPfaCjhFv9j1ecPVRAWZCcsucVVjmJLPMiWCZ
	E6EY4VbkS2cb0pNpwzodfTTYoE43ZOuSg5My0m1o5iO5puvHH6Nyz/fgOsQhUR0CEpNJhCax
	kxYJNerjJ2h9RqI+W0sb6tBSEpf5CuUaKS2iktVZdBpNZ9L6/yqH5C/J4WgkCyQHs+KSLvZt
	7btVbN3G/9mSb93vPOi/39498ULf5y17cD5hvCWwZa88WnzGFljIbQj6UZtUebW51NXfQZdt
	UjQNj35OM4adiX0u9Avwmd8WrbDeDl24Z/heV/zQ5iLKP3JBRIhfw6GHlbCLuEt6uyYzZOYd
	PhMVkeuldVUC+7fg/pfO7uZFhzJTngY2KvhE64aunzHnzEZNbHZX3LSnbV9aL0H5h9vDdhtX
	5u6scJREXzksN0XFy4nhavHZhL3bS1qJpfFYmG25YnmEekDbs0xE6LxiEreJd60Lrf+wMTfz
	2CfZm/D7v2qzPn20vglyh/j69YzdXnV83uLTlicy3JCiDl2D6Q3qv0+QbiW3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xe7ovlfemGqxvMbbYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAW5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
	apG+XYJextnnC9gK3ohUXJ38kbWBcT1/FyMnh4SAicTfV3cYuxi5OIQEljJKfLiwgQ0iISOx
	8ctVVghbWOLPtS42iKKPjBK9+zczQTg7GSUebFjD0sXIwcErYCcx41wwSAOLgIrEun0/wZp5
	BQQlTs58wgJiiwrIS9y/NYMdxBYW8JY4/2o/M4gtIpAgcenaZFaQmcwClxklHv3ZywSSEBL4
	wyzx40oKiM0sIC5x68l8JpBdbAJaEo2dYHM4BcwkVj57wgRRoinRuv03O4QtL7H97RxmiAeU
	JK68fsAOYddKfP77jHECo+gsJOfNQrJhFpJRs5CMWsDIsopRJLW0ODc9t9hIrzgxt7g0L10v
	OT93EyMwlrcd+7llB+PKVx/1DjEycTAeYpTgYFYS4Z0gvDdViDclsbIqtSg/vqg0J7X4EKMp
	MIwmMkuJJucDk0leSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwfEwenVAOT
	T8YzXeFgsdSYUN4JhWdT+FduM9LPro78s3PvM+nSpRcf13+Itcu/eCPf/LWa7qNHES3hdiWv
	8w0rbY/4Se1hDexifXrp8hPm5fd2xqrrrmv9NINhVucy0RLzVqP9z9hfn13+Oe/q5OrdP3Sd
	GGa+/KnrHCasyVpW/PPsDZWWrylcnQUf32SdqjxpPSmpZHti5M9Nc64IyRz42Cm3wVAmUr4y
	78D04r4rNSouyb8l8ndKfq3m+mGsMvFx4CHpj9Uej8815Bz6s7u64rJb8MbpUiWBvluMEjdF
	PZ3290UzT3fjQ53nHX9841iEwz60PmFzknqQseRG0KGJ1QfXMH2uLE26dvNTqnxjyI44YWUl
	luKMREMt5qLiRAA+gtTtbgMAAA==
X-CMS-MailID: 20240202171833eucas1p2fa39cd004b2207b1c1b689005abc8757
X-Msg-Generator: CA
X-RootMTR: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>
	<fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
	<20240130195602.GJ1371843@frogsfrogsfrogs>
	<6bea58ad-5b07-4104-a6ff-a2c51a03bd2f@samsung.com>
	<20240131034851.GF6188@frogsfrogsfrogs>
	<yhuvl7u466fc6zznulfirtg35m7fteutzhar2dhunrxleterym@3qxydiupxnsx>
	<20240131182858.GG6188@frogsfrogsfrogs>
	<f5wwi5oqok5p6somhubriesmmhlvvid7csszy5cmjqem37jy4g@2of2bw4azlvx>
	<20240202164644.GK616564@frogsfrogsfrogs>

>> I still see some errors in generic/081 and generic/108 that have been
>> modified in your patch with the same issue.
>>
>> This is the mkfs option I am using:
>> -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k
>>
>> And with that:
>> $ ./check -s 64k generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279
>>
>> ...
>> generic/081.out.bad:
>>  +max log size 1732 smaller than min log size 2028, filesystem is too small
>> ...
>> generic/108.out.bad:
>> +max log size 1876 smaller than min log size 2028, filesystem is too small
>> ...
>> SECTION       -- 64k
>> =========================
>> Ran: generic/042 generic/081 generic/108 generic/704 generic/730 generic/731 xfs/279
>> Failures: generic/081 generic/108
>> Failed 2 of 7 tests
>>
>> **Increasing the size** to 600M fixes all the test in 64k system.
> 
> Huh.  Can you send me the mkfs output (or xfs_info after the fact) so I
> can compare your setup with mine?  I'm curious about what's affecting
> the layout here -- maybe you have -s size=4k or something?
> 
> (I don't want to stray too far from the /actual/ mkfs minimum fs size of
> 300M.)
> 

I am using v6.8-rc2 with xfsprogs 6.5.0 and xfstests v2024.01.14 (with your patch on top)

Using oracle OCI instance with 64k page size support.

config:

[default]
FSTYP=xfs
RESULT_BASE=$PWD/results/$HOST/$(uname -r)
DUMP_CORRUPT_FS=1
CANON_DEVS=yes
RECREATE_TEST_DEV=true
TEST_DEV=/dev/sdb2
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sdb3
SCRATCH_MNT=/mnt/scratch
LOGWRITES_DEV=/dev/sdb4

[64k]
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=64k,'


If I use 600MB and if the tests run, then this is the xfs_info I am getting on
the test device (test device should have the same config as scratch as I use RECREATE_TEST_DEV=true):

[nix-shell:/mnt/linux/xfstests]$ sudo xfs_info /dev/sdb2
meta-data=/dev/sdb2              isize=512    agcount=4, agsize=102400 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=65536  blocks=409600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1
log      =internal log           bsize=65536  blocks=2613, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0

Let me know if you need more information.

--
Pankaj
