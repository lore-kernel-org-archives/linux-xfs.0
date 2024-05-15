Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82504AEE0
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752660; cv=none; b=Tv4A2A8r08wDC67yKVP6iOPxfpC6fNSz4ov+wfo7o4wx6PPY6bWEv/OMeLMJP7USeUIRrM80EfW0KovjiLCP2wMt0ekdh4DnGEKAqiSsza2sIXscDzcmuFHYI/XnfENDo0aBZSjEsOmk470bOgSgJiojvheVeKxJ6yXOXYPpi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752660; c=relaxed/simple;
	bh=XBBTszZS8nSEUwCRzHqmScQZNOWKWiftnOHPAays+8Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=NG1JYLpW8PkDg6+5W8RMGIcb8rTJvQ6wRoIpJMbIHivEmVEmC0iQo1i1jwcoV6VHTY1sDi5uPyQc4WuvJWosHPpsDXxbtcjNo9lUR0ko0TqmcBOsynhiVA/Dl1ccqYqqgDhC+m/qgstCwDY8T3eYKBfMSuuXrm/NX42wOQg0ZV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HEognthI; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HEognthI"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055737euoutp02d828e3eaa4628fe4d29fc01700d17ba2~Pk-OgZ0Tl2017920179euoutp02O
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055737euoutp02d828e3eaa4628fe4d29fc01700d17ba2~Pk-OgZ0Tl2017920179euoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752657;
	bh=t+LtSI8A+WgybP8NqP+rojjUG/bT6woZXyJ+I7vfPH0=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=HEognthIkmnPhdriZmRVNdoD04/O3Jx12OyZQOvs8XEUQzLhmTjExcmavKd/QTIJ6
	 QD+bRgRur7e2X1q8N4G3leH8yfJKGyRPLzQtTWKsY3LrlnINuMIMKA15SFLMg9VqMU
	 HpWo8N22zTYQVCRt7km9m1RtlQ8/cMa9GMrkwhUQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055736eucas1p2f25fe01f090462c69e1148cea0c1d5a8~Pk-NBWHHN1079110791eucas1p2h;
	Wed, 15 May 2024 05:57:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 37.D8.09875.FCE44466; Wed, 15
	May 2024 06:57:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055735eucas1p2a967b4eebc8e059588cd62139f006b0d~Pk-MUqVPC0808808088eucas1p2V;
	Wed, 15 May 2024 05:57:35 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240515055735eusmtrp2b5840e2e22c2bff3b8f61569b97ef6b3~Pk-MUA_zl0256302563eusmtrp2P;
	Wed, 15 May 2024 05:57:35 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-ef-66444ecfdcc6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 5F.16.08810.FCE44466; Wed, 15
	May 2024 06:57:35 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055735eusmtip17eac0a1eafc6d97691a64a17f60abd3d~Pk-MHq1jo0512205122eusmtip1a;
	Wed, 15 May 2024 05:57:35 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:34 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:34 +0100
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
Subject: [PATCH 09/12] shmem: enable per-block uptodate
Thread-Topic: [PATCH 09/12] shmem: enable per-block uptodate
Thread-Index: AQHapozH2Ew2w2FSxkCziesEgQoVNA==
Date: Wed, 15 May 2024 05:57:33 +0000
Message-ID: <20240515055719.32577-10-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7djPc7rn/VzSDPbNtrKYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlbHpkl7BRdaK
	/s7TTA2Md1m6GDk5JARMJH5/bWMHsYUEVjBKzL7F1sXIBWR/YZRoef2WEcL5zCjx4soiuI65
	Mx6yQiSWM0o83vCJFaIdqOrydhGIxBlGidYHD9kgEisZJS421oHYbAKaEvtObmIHKRIRuM0o
	8fTUGTCHWeAkq8SfzTvBdggLmEtcWD4RrFtEwEbi4cYOdghbT+Jj43Uwm0VAVWLhghvMIDav
	gJXE1k2rGEFsTiD77vyvYL2MArISj1b+AqtnFhCXuPVkPhPED4ISi2bvYYawxST+7YK4VEJA
	R+Ls9SeMELaBxNal+6B+VpZY/66NCWKOnsSNqVPYIGxtiWULX0PdIChxcuYTFpBnJAR2cknM
	mLwGaoGLxNcdbawQtrDEq+Nb2CFsGYn/O+czTWDUnoXkvllIdsxCsmMWkh0LGFlWMYqnlhbn
	pqcWG+WllusVJ+YWl+al6yXn525iBCbK0/+Of9nBuPzVR71DjEwcjIcYJTiYlUR4RdKc04R4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzqqbIpwoJpCeWpGanphakFsFkmTg4pRqYItfPnKL13/N9
	3Mmj9yZ4LaooeBtY0ipsmMVQdb7qsIvZsWYzo38fKn3X7fWMUHt2lmu7WKivTCtnDOcfto1m
	nv+Spr3gMcyRN7rYF1G3voOlvfXGv7LMKeezHHy/Fbh8jRVS+CmRdPdh4sKLSxtWr47zt9uy
	bVrV481eTdGCDcZhexhuRvK5rFuwsXmjE7/G8gmrn1/9MLVr+azvN5z+OzPrfEyXKT1w0Nja
	b+sbcfUJp3juvK28zNs12S5AM/XT/1zDVPMpJ21cPTZom3S7zHCS94j8xn8vVGTF1x0tPzX6
	WPt27NyuK/TMp+j6aZlf/1eWd+46eMsg1P6x1CL+yhVJBtPjcgxkuUX1mdOVWIozEg21mIuK
	EwF2gxRSAwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t/xu7rn/VzSDJYs5baYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7Hpkl7BRdaK/s7TTA2Md1m6GDk5JARMJObO
	eMjaxcjFISSwlFFi19cfUAkZiY1frrJC2MISf651sUEUfWSUuL33AwuEc4ZRYsGa/cwQzkpG
	iZN7voK1sAloSuw7uYkdJCEicJtR4umpM2AOs8BJVokDpz+zg1QJC5hLXFg+kQ3EFhGwkXi4
	sYMdwtaT+Nh4HcxmEVCVWLjgBjOIzStgJbF10ypGEFtIwFLi0qvtYDYnUPzu/K9gcxgFZCUe
	rfwF1sssIC5x68l8JognBCSW7DnPDGGLSrx8/A/qOR2Js9efMELYBhJbl+6DBoCyxPp3bUwQ
	c/QkbkydwgZha0ssW/ga6h5BiZMzn7BMYJSehWTdLCQts5C0zELSsoCRZRWjSGppcW56brGh
	XnFibnFpXrpecn7uJkZgwtt27OfmHYzzXn3UO8TIxMF4iFGCg1lJhFckzTlNiDclsbIqtSg/
	vqg0J7X4EKMpMIwmMkuJJucDU25eSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFq
	EUwfEwenVAPTxKx7kpMdTk1gaEwzlotyMuPwMubXuvOr9bfb8lfK98zW6h0yT1/RGp7sZX1U
	ULTKx8Zo6ZzSZ+8/lRnKRiuclAj9+T+i5M5MI0WTF8mfJmyudbWVbgg22uCvtqYqS63nfGFV
	lkrQXDsldc5Y/2kvF1qkty7S2bWWP7ZapONfpPaluxHlT36ZbZC7GniT48RR9u2cBT/KhRfx
	3Up5KrRzYpAv1wf3qa8zV3EF8B8tf9fpoZipnSTX7rSAZc/dBW+yLNanvxRmnbNo/tSF9eVv
	DaTP79r1JHjf9Yr/N1Jir5df7pG3l2zWubP6iclxzeWxs9dcnetiVtXqfPFJ9sOUIJfnNqZt
	AlHiC/UXMSmxFGckGmoxFxUnAgA2YmL4AQQAAA==
X-CMS-MailID: 20240515055735eucas1p2a967b4eebc8e059588cd62139f006b0d
X-Msg-Generator: CA
X-RootMTR: 20240515055735eucas1p2a967b4eebc8e059588cd62139f006b0d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055735eucas1p2a967b4eebc8e059588cd62139f006b0d
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055735eucas1p2a967b4eebc8e059588cd62139f006b0d@eucas1p2.samsung.com>

In the write_end() function, mark only the blocks that are being written
as uptodate.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d5e6c8eba983..7a6ad678e2ff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2991,7 +2991,7 @@ shmem_write_end(struct file *file, struct address_spa=
ce *mapping,
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
=20
-	shmem_set_range_uptodate(folio, 0, folio_size(folio));
+	shmem_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
 	folio_mark_dirty(folio);
 	folio_unlock(folio);
 	folio_put(folio);
--=20
2.43.0
