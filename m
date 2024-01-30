Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837160874
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 13:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706620694; cv=none; b=d0PEIzWbWXi1IjGEijfUo4p4Plz84wfa7it+rReHl88B9bWHvYv7zem6hQM4ZdiEDiYC6jvk/euL6LZ0bvoeL7ZP/paMsH/OOUJg+XG1B7BEYuggil4UXxsYtT+YInFtOgRcv134TvpcnHKv0uHzj+S0H+zvBZqRDAf11YD3C9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706620694; c=relaxed/simple;
	bh=7noXzSg3eR3LKSyOs9PmxZmkgbN6BoRHdkA+Ytdtbjs=;
	h=Message-ID:Date:MIME-Version:From:Subject:CC:To:Content-Type:
	 References; b=LCsBU11rdjM5ITFv3aDzDcc5vMSlQvcURzCn59R4IaLDlrUvCTxax7HSEdj+nQubI3Gd7fwXL/E6+9Yoxz4lcvFaF1joSFD2t3ZbFaHu2+gJQaD6YMirc76IDKB0ireVTTJI1ZsSt+F3JLwvG6LpVBIckC9rKrtHavVrW4RFb98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=InfQ8K9W; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="InfQ8K9W"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240130131804euoutp01d93c0c40742d03733d8b9fe7bbe71d0f~vInhopGiH2852528525euoutp01y
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 13:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240130131804euoutp01d93c0c40742d03733d8b9fe7bbe71d0f~vInhopGiH2852528525euoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706620684;
	bh=nchtKpFK/wfJqMktIbKPjhJtONuMwGvChv/TS4CLgbw=;
	h=Date:From:Subject:CC:To:References:From;
	b=InfQ8K9WLs/y/lajQEJt999l7cF/y8rDgNC0DYNolYISNH70+3AkEd0MVegUeWhK+
	 sC0SwCwHZtiAhFRuF3c+hDwx8gYIGhvo9j8t6jpL7hmEdQpuIvfqj07Ow5jA8Poz2/
	 EOsSiE5CpvobbiKpo8LgX6Pjmd6xAI39ACYRCn8E=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240130131803eucas1p289f79fdaf6dc0e7561c9b314056ca7ff~vInhSOOR60247902479eucas1p2u;
	Tue, 30 Jan 2024 13:18:03 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 1B.F1.09539.B07F8B56; Tue, 30
	Jan 2024 13:18:03 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820~vIngoAWK_0239902399eucas1p2P;
	Tue, 30 Jan 2024 13:18:03 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240130131803eusmtrp290acbbd79033749fce87fa9756f8aa22~vIngnUriN1988119881eusmtrp2G;
	Tue, 30 Jan 2024 13:18:03 +0000 (GMT)
X-AuditID: cbfec7f2-52bff70000002543-f0-65b8f70bdd63
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id A5.6A.09146.B07F8B56; Tue, 30
	Jan 2024 13:18:03 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240130131803eusmtip111428a3363982ffffddbcd3d76b40995~vIngeEx1s0365203652eusmtip1x;
	Tue, 30 Jan 2024 13:18:03 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.241) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 30 Jan 2024 13:18:02 +0000
Message-ID: <fe7fec1c-3b08-430f-9c95-ea76b237acf4@samsung.com>
Date: Tue, 30 Jan 2024 14:18:01 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: fstest failure due to filesystem size for 16k, 32k and 64k FSB
CC: <mcgrof@kernel.org>, <gost.dev@samsung.com>,
	<linux-xfs@vger.kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: <fstests@vger.kernel.org>, <djwong@kernel.org>, <zlang@redhat.com>,
	"Dave Chinner" <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGe3fvtutq4zq/DipJy4qEpkLRBdM+ySFSgrVIKRt5WZLO2tJc
	VjOz0JmVlk2Hppj0IWFlbrrC0hVOl1H2obYsP5hZgaYuqUyttmvgf895fuccnvPyEpjwOtuX
	SFIcoZUKWbKIw8ONrb9erFr4o5EOKRxaQ9W3fkTUa7uAepbTxKU6vjhw6sF0I5fquTiEqBZr
	LpdqajexNxASaxVITPoPXEldTR5H8vzWRsm3R285Ekfd4hhOHG9dIp2clE4rgyP28Q7cL2rF
	DnV5ZbTnzOBZaEqgRW4EkKthsPwz0iIeISRvImj/0MNhiu8IrFl9GFM4ELQZX7D/j9TmTOEM
	uIHAbq5wAVdX7enNDHiIwNY9hZyAT0bAE/M9l8bJZXDj6VuM8d2hvdSOO7UXGQB9thKuU2Ok
	D9jsFSwtIggOGQSn8ly2BxkJ3QOjbOd+jDQgqByccAFPUgGPR7IxZnYlnGn4PbcnABpGyjAm
	9VK49rILMfoEWOttLOciIMcI+DT7jsuALZBfWMJitAd8tdTP+f7wx1Qx52fCUM9vjBnOQXDB
	dIfjTApkGJzvSGZ6NsLs1Uk2YwugZ8SdySOAIqMOY2w+5J4VXkSB+nkvoZ93vX7eNfp511Qi
	vAb50GmqFDmtClXQR8UqWYoqTSEX709NqUP/vtKzWctEIyr/Oi42IxaBzAgITOTJ/7XSQAv5
	iTL1MVqZmqBMS6ZVZuRH4CIf/rLEAFpIymVH6IM0fYhW/qcsws03i7V+9nJv2bEYQfH7u8/j
	xMM7Tq7x512NWbSrdc/E4e1BWWLFil6t+mPpkwVc0StHoK6APV6X1xKBNHlbrFJW/FjNleNe
	0w5dsEJ9gl3gvT999E9IRuPwzzBN/sClfvVTm5R+g/wSzNIhe6wkOjI79pFKsPzsjwiLRsoT
	y43XK/iHA/xuL4jftkd0x0CVSAtMbt73zweGdhYvCRf3mzuio/r7qzdP73ysO93r3bw1sFZj
	6Jbze/emAnUy35HdsjtbIOFTqcJ0i8i9S5+bWVqltcpj0v3Phd+dtITXGEKrGzaF+LdVzag1
	pmhp5LCxeVdns3JtnDJqx3h808xurFOEqw7IQoMwpUr2F/x5gl+5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/xu7rc33ekGiyaw2Ox5dg9RovLT/gs
	TrfsZbc48/Izi8WuPzvYLW5MeMpocfBUB7vF3pM7WR04PE4tkvDYOesuu8emVZ1sHmdXOnq8
	33eVzePzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy
	1CJ9uwS9jM2TjjEXXBOtONnyl6WB8RdfFyMnh4SAicS6ll8sILaQwFJGiTkNohBxGYmNX66y
	QtjCEn+udbF1MXIB1XxklNi2/hIThLObUWLRz5XMIFW8AnYShw9tZASxWQRUJZYfuQoVF5Q4
	OfMJ2AZRAXmJ+7dmsIPYzALiEreezAcaxMHBJqAl0dgJFhYWcJe4/vAdK8h8ZoGtjBJnFlwE
	6xURyJP4tPMlE0SvpkTr9t9Qc+Qltr+dwwxxqbLE4gvXGCHsWonPf58xTmAUnoXkjFlIVs9C
	MmoWklELGFlWMYqklhbnpucWG+oVJ+YWl+al6yXn525iBMbmtmM/N+9gnPfqo94hRiYOxkOM
	EhzMSiK8PzW3pgrxpiRWVqUW5ccXleakFh9iNAWGxURmKdHkfGByyCuJNzQzMDU0MbM0MLU0
	M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYJL+fcfuS+XlWbfqHCQPH73FxV+QmXCsR7Du
	vmXp0dwp0XeCvZYmuuUGnf+5bDfPS/lXuWkJq0QcDqemirHOjlnvXXwoxC25tGTJrMCa/2yc
	WT4+PavcuFZe1d5xcNn58lTNkPrd3Jv+zTY6uGjhgR4n2w+2+W+NLiT3LrXsvcKXa/Xu+pXs
	8smu/ZbBP9yieFQPWEdN02V8t4S7V6Tn3iczA5njZZxWl1y0SiatTTX7XL3On2XJpF9/ZDYo
	N7zd8XJH9STpsJker7iuXmnsCtv/ei17a+SCvOgT69MnPF+e4/pOccmuhetVGOS2im+y4wrs
	qzHi/zEzwuPBiu9i4gxva79+WMy6UPSiEcfP7UosxRmJhlrMRcWJAECr1zZWAwAA
X-CMS-MailID: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
X-Msg-Generator: CA
X-RootMTR: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820
References: <CGME20240130131803eucas1p280d9355ca3f8dc94073aff54555e3820@eucas1p2.samsung.com>

As I pointed out in my previous thread [1], there are some testcases
in fstests that are failing for FSB 16k, 32k and 64k due to the filesystem
**size** under test. These are failures **upstream** and not due to the ongoing
LBS work.

fstests creates a lot of tiny filesystems to perform some tests. Even though
the minimum fs size allowed to create XFS filesystem is 300 MB, we have special
condition in mkfs to allow smaller filesystems for fstest[2] (This took some time
to figure out as I was splitting my hair how fstest is able to create XFS on top of
25MB images).

The problem comes when we have FSB 16k, 32k and 64k. As we will
require more log space when we have this feature enabled, some test cases are failing
with the following error message:

max log size XXX smaller than min log size YYY, filesystem is too small

Most test cases run without this error message with **rmapbt disabled** for 16k and 64k (see
the test matrix below).

What should be the approach to solve this issue? 2 options that I had in my mind:

1. Similar to [2], we could add a small hack in mkfs xfs to ignore the log space
requirement while running fstests for these profiles.

2. Increase the size of filesystem under test to accommodate these profiles. It could
even be a conditional increase in filesystem size if the FSB > 16k to reduce the impact
on existing FS test time for 4k FSB.

Let me know what would be the best way to move forward.

Here are the results:

Test environment:
kernel Release: 6.8.0-rc1
xfsprogs: 6.5.0
Architecture: aarch64
Page size: 64k

Test matrix:

| Test        | 32k rmapbt=0 | 32k rmapbt=1 | 64k rmapbt=0 | 64k rmapbt=1 |
| --------    | ---------    | ---------    | ---------    | ---------    |
| generic/042 |     fail     |     fail     |     fail     |     fail     |
| generic/081 |     fail     |     fail     |     pass     |     fail     |
| generic/108 |     fail     |     fail     |     pass     |     fail     |
| generic/455 |     fail     |     fail     |     pass     |     fail     |
| generic/457 |     fail     |     fail     |     pass     |     fail     |
| generic/482 |     fail     |     fail     |     pass     |     fail     |
| generic/704 |     fail     |     fail     |     pass     |     fail     |
| generic/730 |     fail     |     fail     |     pass     |     fail     |
| generic/731 |     fail     |     fail     |     pass     |     fail     |
| shared/298  |     pass     |     pass     |     pass     |     fail     |

16k fails only on generic/042 for both rmapbt=0 and rmapbt=1


[1] https://lore.kernel.org/all/7964c404-bc9d-47ef-97f1-aaaba7d7aee9@samsung.com/
[2] xfsprogs commit: 6e0ed3d19c54603f0f7d628ea04b550151d8a262
-- 
Regards,
Pankaj
