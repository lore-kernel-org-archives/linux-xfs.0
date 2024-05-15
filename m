Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B13D38E
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752656; cv=none; b=dOh1gnYUsCDMtfM9Hl7BQCiNBrLblDa05J/gnPS9DzvgDmJAND7+ADDzcKeXwfC0CGsdqrB25BWNjX8ZtTULvh3rPYMexipfBMWvJpJLzZVkx8Hwcuf/6uuYqrYwBP+ClUkWo6s0GuXkJARR0uvmrLCB0CXJk2n+ajJPIuV7Iag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752656; c=relaxed/simple;
	bh=89+H9PvAC7hTsgg4Ho2crFN+biV5BGlsEVOQmKZxxZM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=aiYYSeIyEjOcdhlZt34JuSVVtIbOulGsqqu6oXpcAWVSO8qQ9QqIwHvAn6X/VZ8C99lskgEcA6Fsq+s1+xRT0yQYGVt+90CMF0oK1kzFDZ6l7VwkUVhBhG2W1h+onzNep6V7WIFTiDauNVIAQniQoLskR2gmt7vwQ5MvXYydga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZkVfT9z6; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZkVfT9z6"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055733euoutp025a06fbda482c617ac65a0f5215254713~Pk-K4EcPZ1335213352euoutp02a
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055733euoutp025a06fbda482c617ac65a0f5215254713~Pk-K4EcPZ1335213352euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752653;
	bh=ISz7TrEyCDZh2RGvxSi8e/BBnML+fSScyaJx5o0KWiw=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=ZkVfT9z6ael406ECJDYHpyFlabEiCh8WUVcXIkkarczOEAsRGOJCKZL52AYr75W6T
	 uoj03w0wf1/00ChFsPCnXmqb7wvsMWWgvMFpdaaBd+9vwh88jAYGaGo5zdxGfDZvGq
	 n4cOnWbLkoEb2Sax5KhYhWp7GXyMvKEyzmEpNi9A=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055733eucas1p2d44dc66c51ebcdde1ad1cb3160016f11~Pk-Kf7b9q1079110791eucas1p2e;
	Wed, 15 May 2024 05:57:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 35.D8.09875.DCE44466; Wed, 15
	May 2024 06:57:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055732eucas1p2302bbca4d60e2e811a5c59e34f83628d~Pk-JgremL1114511145eucas1p29;
	Wed, 15 May 2024 05:57:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055732eusmtrp1649bb55890ac4fc12b6b8f6506fb74b2~Pk-JfzHi20390703907eusmtrp1_;
	Wed, 15 May 2024 05:57:32 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-e9-66444ecdd352
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id DA.F1.09010.CCE44466; Wed, 15
	May 2024 06:57:32 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055732eusmtip20173b018d0674b7f27dab1c2ee4741f8~Pk-JRqiWL1596015960eusmtip2O;
	Wed, 15 May 2024 05:57:32 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:31 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:31 +0100
From: Daniel Gomez <da.gomez@samsung.com>
To: "hughd@google.com" <hughd@google.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "willy@infradead.org" <willy@infradead.org>,
	"jack@suse.cz" <jack@suse.cz>, "mcgrof@kernel.org" <mcgrof@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "djwong@kernel.org" <djwong@kernel.org>,
	"Pankaj Raghav" <p.raghav@samsung.com>, "dagmcr@gmail.com"
	<dagmcr@gmail.com>, "yosryahmed@google.com" <yosryahmed@google.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "chandan.babu@oracle.com"
	<chandan.babu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: [PATCH 07/12] shmem: check if a block is uptodate before splice
 into pipe
Thread-Topic: [PATCH 07/12] shmem: check if a block is uptodate before
	splice into pipe
Thread-Index: AQHapozGTHnkaf4XgkaJL36kMuhxtQ==
Date: Wed, 15 May 2024 05:57:31 +0000
Message-ID: <20240515055719.32577-8-da.gomez@samsung.com>
In-Reply-To: <20240515055719.32577-1-da.gomez@samsung.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djPc7pn/VzSDCavFLCYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAldF74CRbwWPe
	iklvoxoY73N1MXJySAiYSCz5/puli5GLQ0hgBaPEj1vvmCCcL4wSj/tnQzmfGSUerL/ABNPy
	58U9ZojEckaJTZfbGeGq7i49yArhnGGUeN7wix3CWcko8ff5Y3aQfjYBTYl9JzeBJUQEbjNK
	PD11BsxhFjjJKvFn804WkCphgRCJA7P6GUFsEYFIiV9H9jFD2HoS9y+vBbNZBFQlepY3g9Xz
	ClhKPG6cC3Yhp4CVxN35X9lAbEYBWYlHK3+BbWYWEJe49WQ+1BeCEotm72GGsMUk/u16yAZh
	60icvf6EEcI2kNi6dB8LhK0ssf5dGxPEHD2JG1OnsEHY2hLLFr5mhrhBUOLkzCdQ9Xu5JO58
	roawXSQ+XPgBtVdY4tXxLewQtozE6ck9LBMYtWchOW8WkhWzkKyYhWTFAkaWVYziqaXFuemp
	xUZ5qeV6xYm5xaV56XrJ+bmbGIHJ8vS/4192MC5/9VHvECMTB+MhRgkOZiURXpE05zQh3pTE
	yqrUovz4otKc1OJDjNIcLErivKop8qlCAumJJanZqakFqUUwWSYOTqkGJpUdHuviq2+m9e/m
	lJkvmcVk+ERVxvhZ0w4GpQreTV17FJ9drbNPuWdSuM588hOGldfeqC8VuVpZtJ/lbPWS8P/V
	JwP697Q8uF0yqX2qPde9VQ0ntvz6W727U6PG/cl2ea2ere6s0msCHt//vbGudcleOSkZQ8bM
	jDghVYb8XT3TDYy1l99Jz1pqyta1cbFkuHvSHcn6tjT/UGuPtsS/c2P9zzFePCdZKC6R2FC9
	XLooWf0Ik1e64oWaviKrteoTwv1sFUIYX0TmLX2wkjnc4OTON6plZr9ixKa8dlkg+rns5CzX
	Gt1SXZP0GKZ1sy9pWWsYZUzjMm2Yd2FNbjX/mes1+Wr/98f0S13If6PEUpyRaKjFXFScCACX
	pvCdBQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t/xe7pn/FzSDG5/ZbeYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9F74CRbwWPeiklvoxoY73N1MXJySAiYSPx5
	cY+5i5GLQ0hgKaPEvq477BAJGYmNX66yQtjCEn+udbFBFH1klDj2+gQThHOGUeJJ1wR2CGcl
	o8TtmW0sIC1sApoS+05uAkuICNxmlHh66gyYwyxwklXiwOnPYEuEBUIketZOBesQEYiUaGmb
	zQZh60ncv7yWGcRmEVCV6FneDFbDK2Ap8bhxLhOILQRkX3q1nRHE5hSwkrg7/ytYL6OArMSj
	lb/A5jMLiEvcejKfCeIJAYkle84zQ9iiEi8f/4N6Tkfi7PUnjBC2gcTWpftYIGxlifXv2pgg
	5uhJ3Jg6hQ3C1pZYtvA1M8Q9ghInZz5hmcAoPQvJullIWmYhaZmFpGUBI8sqRpHU0uLc9Nxi
	I73ixNzi0rx0veT83E2MwIS37djPLTsYV776qHeIkYmD8RCjBAezkgivSJpzmhBvSmJlVWpR
	fnxRaU5q8SFGU2AYTWSWEk3OB6bcvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC
	1CKYPiYOTqkGplU//CuSpmf5LipLiN28uVB/f/v0l1nNC/OPrb9txbRuyt6vK1auYJr3sNRt
	y5/WHzW982bNyDl5eum8Hk3DzB97O16XTrU9+mEzQ4/erR333e7mOTz6ki353ifS5X4P2zqR
	mMyF7yIfSMS9fPD+zp8z26dvfrE52/hF/zWDdJ2k6U/+Lm+y32fPf7dlee92nk+rC5eu/D+H
	0UPXqK064afl7WLTHU9EbB6wXck/PDVOtHHp/ztvfwgvSpkWZWOR/lQwYTJf3IbHHJZetnu4
	Fzz4JTd59TYWC0XBRdeXs6guu/3e+DrLAtmLmku9vhxR6/pUNWv7z23K97YE/y/SN2t67v5P
	M7r3h27eT0aj2IWvlFiKMxINtZiLihMBeBCgoAEEAAA=
X-CMS-MailID: 20240515055732eucas1p2302bbca4d60e2e811a5c59e34f83628d
X-Msg-Generator: CA
X-RootMTR: 20240515055732eucas1p2302bbca4d60e2e811a5c59e34f83628d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055732eucas1p2302bbca4d60e2e811a5c59e34f83628d
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055732eucas1p2302bbca4d60e2e811a5c59e34f83628d@eucas1p2.samsung.com>

The splice_read() path assumes folios are always uptodate. Make sure
all blocks in the given range are uptodate or else, splice zeropage into
the pipe. Maximize the number of blocks that can be spliced into pipe at
once by increasing the 'part' to the latest uptodate block found.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 68fe769d91b1..e06cb6438ef8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3223,8 +3223,30 @@ static ssize_t shmem_file_splice_read(struct file *i=
n, loff_t *ppos,
 		if (unlikely(*ppos >=3D isize))
 			break;
 		part =3D min_t(loff_t, isize - *ppos, len);
+		if (folio && folio_test_large(folio) &&
+		    folio_test_private(folio)) {
+			unsigned long from =3D offset_in_folio(folio, *ppos);
+			unsigned int bfirst =3D from >> inode->i_blkbits;
+			unsigned int blast, blast_upd;
+
+			len =3D min(folio_size(folio) - from, len);
+			blast =3D (from + len - 1) >> inode->i_blkbits;
+
+			blast_upd =3D sfs_get_last_block_uptodate(folio, bfirst,
+								blast);
+			if (blast_upd <=3D blast) {
+				unsigned int bsize =3D 1 << inode->i_blkbits;
+				unsigned int blks =3D blast_upd - bfirst + 1;
+				unsigned int bbytes =3D blks << inode->i_blkbits;
+				unsigned int boff =3D (*ppos % bsize);
+
+				part =3D min_t(loff_t, bbytes - boff, len);
+			}
+		}
=20
-		if (folio) {
+		if (folio && shmem_is_block_uptodate(
+				     folio, offset_in_folio(folio, *ppos) >>
+						    inode->i_blkbits)) {
 			/*
 			 * If users can be writing to this page using arbitrary
 			 * virtual addresses, take care about potential aliasing
--=20
2.43.0
