Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160223BBCF
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715753200; cv=none; b=Byct+i6FfLbtS1OOeOzV/dsvo6p5BppdhBpH1sjlzNKil15V8a1+Bw6MPG2wDHNt6Dq7eL0HGnEjYyxbmuhiJIhn9TrrGJAw1YRW8mrAvKWxGFmtGnAxcKkQlcZhIer8/V4vihZXEsLjVjFIEmAEiZ1H5CL11J2e789x4R0d3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715753200; c=relaxed/simple;
	bh=KNLDOdcMJHdonJIFbAEgulwCa2Oo/AmJi3h6ziGNLfs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=m0rJeCu4CIUUPnlflDOURsf1nrNrpgyu7DCQh4kKR0QtzZGzfs88R+xVcSf9rEdxN66oMC+8Y9VZYovFocK5U6hien4L3yJA6CvLPfUmO8w7jlNdgF0O3poeu5YKxQ4sEUz8CVPKS3alLoWohh9m/PlSQ9Kg92kOtdoma4YTmrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=iF9QYRA2; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iF9QYRA2"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055729euoutp01b0f54336d3eb0854bdfe902069230cbd~Pk-HWNCg_1504015040euoutp01R
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240515055729euoutp01b0f54336d3eb0854bdfe902069230cbd~Pk-HWNCg_1504015040euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752649;
	bh=TvwQ3/t0rLMlRSFpe0qm/SVRP0obWxz9NLqJPflU2UQ=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=iF9QYRA2fhupfZkTnrimDqeRi6wjYm0sMeOp0s5h8j692FXl0E3QjwQRodtCpRm64
	 +G8KcwQ2IAF7D+h2qGkK9eThiOsfeUH3RG8J/ThTzFnEU12i5NpznNNkBZPG70EGIv
	 EaQFp+sLI3WpGCwP9whM6ce+M1zVolcg4HrOvNR4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055729eucas1p25a1ae40ac6143a6c66beda0dcd46d6ac~Pk-GwWyTN0594605946eucas1p2R;
	Wed, 15 May 2024 05:57:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 99.BC.09624.8CE44466; Wed, 15
	May 2024 06:57:28 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055728eucas1p181e0ed81b2663eb0eee6d6134c1c1956~Pk-Fxtmp_2567425674eucas1p1T;
	Wed, 15 May 2024 05:57:28 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055728eusmtrp126de191b60d8f61e2ba129b4a88ba285~Pk-FxIF7h0390703907eusmtrp11;
	Wed, 15 May 2024 05:57:28 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-51-66444ec865cb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 18.F1.09010.8CE44466; Wed, 15
	May 2024 06:57:28 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055728eusmtip1e41b862dcb859f62ee1fd12a0cd79248~Pk-Fir1hx0512305123eusmtip1t;
	Wed, 15 May 2024 05:57:28 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:27 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:27 +0100
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
Subject: [PATCH 04/12] shmem: exit shmem_get_folio_gfp() if block is
 uptodate
Thread-Topic: [PATCH 04/12] shmem: exit shmem_get_folio_gfp() if block is
	uptodate
Thread-Index: AQHapozD1A5s10K0O0aGF++xWBxX9g==
Date: Wed, 15 May 2024 05:57:27 +0000
Message-ID: <20240515055719.32577-5-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7djPc7on/FzSDB58t7SYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlbHi+hXmgm1c
	FXuuLGRvYNzL0cXIySEhYCLx+2YjWxcjF4eQwApGiffT7rJDOF8YJX7vnMcM4XxmlJh3uYsJ
	puVQ43tWiMRyRonW3j4muKo3D3ZAOWeAMv8fsIK0CAmsZJT480wUxGYT0JTYd3IT2BIRgduM
	Ek9PnQFzmAVOskr82byTpYuRg0NYwF/i3XoREFNEIETibo8xSK+IgJ7EjM8N7CBhFgFVibc7
	E0DCvAKWEtNXvGIHsTkFrCTuzv/KBmIzCshKPFr5CyzOLCAucevJfKgPBCUWzd7DDGGLSfzb
	9ZANwtaROHv9CSOEbSCxdek+FghbWWL9uzYmiDl6EjemTmGDsLUlli18zQxxg6DEyZlPWEA+
	kRDYyyXRtmADVLOLxIln36AWCEu8Or6FHcKWkTg9uYdlAqP2LCT3zUKyYxaSHbOQ7FjAyLKK
	UTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/dxMjMFGe/nf80w7Gua8+6h1iZOJgPMQowcGsJMIr
	kuacJsSbklhZlVqUH19UmpNafIhRmoNFSZxXNUU+VUggPbEkNTs1tSC1CCbLxMEp1cCkxWLA
	VvskyftBMm+Tq3FYW2MmW2izwjs/hda5CaU7xd/yLYoImNd1y4Xv0+zeJkZxi/dHTAp+L+/J
	fHGlPcd36/ZDC4zX1t27LZvPYRJQyf206otUnsITkamb+nw0khu/O70MmHJK9s0B3W/ydzwr
	3s2c++3qwZuNS+NWzdKZ9y/p82QZ09yIk3/8wh2suTtq5DlV+p9J+v/Ru6ncxFkoyvz46JfM
	J19UTVMYA/oXxZ3ruKEh86N/Z7bx9UMHOMy1X7kynf66KMl9kkTKw3CVc21F82b8O3zrqEj+
	7aw7Pate94WGhM7uy7R6n8PCZBj7mL/+2/5vTh9rH1hFT7Hhcii8GCe5f77zBoVP9UosxRmJ
	hlrMRcWJAD6ujNoDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t/xu7on/FzSDO7uYreYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7Hi+hXmgm1cFXuuLGRvYNzL0cXIySEhYCJx
	qPE9axcjF4eQwFJGiSMzPjBCJGQkNn65ygphC0v8udbFBlH0kVGi6csSdpCEkMAZRok/bwIh
	EisZJW43zWIDSbAJaErsO7mJHSQhInCbUeLpqTNgDrPASVaJA6c/g7ULC/hKTJzVCLZPRCBE
	4kBvEwuErScx43MDUA0HB4uAqsTbnQkgYV4BS4npK15BbbaUuPRqO1grp4CVxN35X8EWMwrI
	Sjxa+QushllAXOLWk/lMEC8ISCzZc54ZwhaVePn4H9RrOhJnrz+BetlAYuvSfSwQtrLE+ndt
	TBBz9CRuTJ3CBmFrSyxb+JoZ4h5BiZMzn7BMYJSehWTdLCQts5C0zELSsoCRZRWjSGppcW56
	brGRXnFibnFpXrpecn7uJkZgutt27OeWHYwrX33UO8TIxMF4iFGCg1lJhFckzTlNiDclsbIq
	tSg/vqg0J7X4EKMpMIgmMkuJJucDE25eSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZq
	akFqEUwfEwenVAPTikBz2+mSLnf+JpU2bIt7NfuxpcPCF8zP63gTuuSk17e6fN17Pn12kavR
	DzXxTzLdAnIOdnw/fsVLCZ55uXLj5j3MzLNFLSQ8rtqI/zWceEWsw3Byb7Gb3yTngqeTJp+d
	UDizXmX+h9Y4m7gXRw4LGJcuaxPP9wmqOTw3iuGTXv/NiuMLsnbbSq1bl9Mp/2nCz3JZ231e
	f8pvit7XeVqX9/PSF6HtEZGqQk812G9EnWI9JuXuLGnU7CIoK6/2I2jW1+0PFX/KnSy+5ml+
	fppV8HmTzIKln301JypvsPV8JqHF427yx8z3uUJ2X8zsRY61gfOU+9viwrNv3e5Qs7grkPz7
	dUlu7i62OY++31ZiKc5INNRiLipOBADETHQjAAQAAA==
X-CMS-MailID: 20240515055728eucas1p181e0ed81b2663eb0eee6d6134c1c1956
X-Msg-Generator: CA
X-RootMTR: 20240515055728eucas1p181e0ed81b2663eb0eee6d6134c1c1956
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055728eucas1p181e0ed81b2663eb0eee6d6134c1c1956
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055728eucas1p181e0ed81b2663eb0eee6d6134c1c1956@eucas1p1.samsung.com>

When we get a folio from the page cache with filemap_get_entry() and
is uptodate we exit from shmem_get_folio_gfp(). Replicate the same
behaviour if the block is uptodate in the index we are operating on.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 86ad539b6a0f..69f3b98fdf7c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -256,6 +256,16 @@ static inline bool shmem_is_any_uptodate(struct folio =
*folio)
 	return folio_test_uptodate(folio);
 }
=20
+static inline bool shmem_is_block_uptodate(struct folio *folio,
+					   unsigned int block)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	if (folio_test_large(folio) && sfs)
+		return sfs_is_block_uptodate(sfs, block);
+	return folio_test_uptodate(folio);
+}
+
 static void shmem_set_range_uptodate(struct folio *folio, size_t off,
 				     size_t len)
 {
@@ -2146,7 +2156,7 @@ static int shmem_get_folio_gfp(struct inode *inode, p=
goff_t index,
 		}
 		if (sgp =3D=3D SGP_WRITE)
 			folio_mark_accessed(folio);
-		if (folio_test_uptodate(folio))
+		if (shmem_is_block_uptodate(folio, index - folio_index(folio)))
 			goto out;
 		/* fallocated folio */
 		if (sgp !=3D SGP_READ)
--=20
2.43.0
