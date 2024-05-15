Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CC44A99C
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752660; cv=none; b=vGRgvpTdHkRcEV7+RWhsF+qNjkFE6U2gYTTlvfcbIIoHLXuPXDVPHFOfMmpRh4CyUnzlemMesYrKSegiz+K4iL9Iaii5kTwUDzdiEu2OzBqWnIkYc55M9qjhVVXuhMMe360arW7RnfHSEzjz2l+s4IzA+FKwDFievw532FOdM6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752660; c=relaxed/simple;
	bh=lc5Bcuya4k9VDqOmugl/UQAcSKJ85TOXE7/4aly3gXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=Qdb786G4m3R2r1Rm1+989mQcoMsDapLYBAAOhJ+/tZsEuCLXQntdTzWvzY/CqzfrO5GoPyNe3nTwUu+gZfds6bPNugyv5TueEn4Bg8MjNlCVX55H4eeZxX+ZUIgsmAnKrysb4PQwSYDcZV2cw27VNvAG03zVxHuk4sf1xLHb1As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=V6X+pv4+; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="V6X+pv4+"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055737euoutp02d603b204e5ce7bf4b558875252c827bc~Pk-OSxnNG1630116301euoutp029
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055737euoutp02d603b204e5ce7bf4b558875252c827bc~Pk-OSxnNG1630116301euoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752657;
	bh=UpgQNcs3t+vPhgTbp5qaltdkcX9R16oQVfuTuAdyYIA=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=V6X+pv4+/cBmEU8T11EPsFfVxs/5YtIbbio/GJliZS3fM7HMZwpBQft9a7HilFsIz
	 /qDLPhHudz7k9wBLqS5fAM3LWbKlq6U0ooUrdtlKAtadGgKh1Xc9wvuCr2XSeVyU3b
	 kNBG7nrP+x1JpjG799YNIHCZI4DtXMyNL35DxE68=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055732eucas1p21f818cb2496ee822433ed04389e46e34~Pk-Jf679M0594605946eucas1p2V;
	Wed, 15 May 2024 05:57:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id A3.D8.09875.CCE44466; Wed, 15
	May 2024 06:57:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055731eucas1p12cbbba88e24a011ef5871f90ff25ae73~Pk-IlqFp62570125701eucas1p1D;
	Wed, 15 May 2024 05:57:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055731eusmtrp1cf7b95a0a73627267d00f9d9cd74d1b4~Pk-IkvrDl0390703907eusmtrp19;
	Wed, 15 May 2024 05:57:31 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-e5-66444ecc2765
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id B9.F1.09010.BCE44466; Wed, 15
	May 2024 06:57:31 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055730eusmtip2f331ce6df1efce75d1c8a5633c334c55~Pk-IU51Z-1596015960eusmtip2N;
	Wed, 15 May 2024 05:57:30 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:30 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:30 +0100
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
Subject: [PATCH 06/12] shmem: set folio uptodate when reclaim
Thread-Topic: [PATCH 06/12] shmem: set folio uptodate when reclaim
Thread-Index: AQHapozFha++cZmim0iVIxwtuJabGw==
Date: Wed, 15 May 2024 05:57:29 +0000
Message-ID: <20240515055719.32577-7-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7pn/FzSDBZP4rGYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAldG0JKVgBlvF
	0mMv2RoY+1m7GDk5JARMJJpmPWDpYuTiEBJYwShx49E1KOcLo8TZnd/ZIJzPjBI/fr9khGm5
	/2YzK0RiOaPEzgsTWeCquj92MUM4Zxgllq89ww7hrGSU2PjjPNhKNgFNiX0nN4ElRARuM0o8
	PQVRxSxwklXiz+adLCBVwgK2EosPH2QHsUUEnCRO7twGFOcAsvUk/qx1AwmzCKhKfOg9wQZi
	8wpYSvz6dwqsnFPASuLu/K9gcUYBWYlHK3+BxZkFxCVuPZnPBPGEoMSi2XuYIWwxiX+7HrJB
	2DoSZ68/gXrUQGLr0n0sELayxPp3bUwQc/QkbkydwgZha0ssW/iaGeIGQYmTM5+Aw0JCYCeX
	xKfTu8FulhBwkej4lA0xR1ji1fEt7BC2jMTpyT0sExi1ZyE5bxaSFbOQrJiFZMUCRpZVjOKp
	pcW56anFRnmp5XrFibnFpXnpesn5uZsYgany9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRFekTTn
	NCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8qinyqUIC6YklqdmpqQWpRTBZJg5OqQYmP61jsq6H
	aw5MPcXBpXuc219ZJ+3pmaXpphXtr4715JlI+Zq3J97cwCq38M7fIklT3zaXu2ZTzc4+b9+7
	svXMjFaFK10Gk8uVJad+m7KndL2P6bXPeYq38iON2Yp9HfmnzFsXcrjs8fkACWljq8nPll9q
	fJG3geXMYQvu1vgTybW2kp9uRoreeTRR8dwUJquPU/MPr9G1dlg+69zFg4m71i42uLKn3F/A
	ZNOn2sQp0du5t8tfXDzX/FDNd83/fZ99NrtOlY87xPSSN3daG5OM6i2tY49uvVfpUdRYfODk
	mXAjgYmaPxX2bp7R532LV1/DUnxevN/yiiqDcNajJtm55/6tnxOZzlXbONkyySdAiaU4I9FQ
	i7moOBEAuQwJ4gQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t/xe7qn/VzSDK68ZrOYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9G0JKVgBlvF0mMv2RoY+1m7GDk5JARMJO6/
	2Qxkc3EICSxllOh/vo4dIiEjsfHLVagiYYk/17rYIIo+MkpcPXmTBcI5wyhx6scrqPaVjBJd
	C7+BtbMJaErsO7mJHSQhInCbUeLpqTNgDrPASVaJA6c/g1UJC9hKLD58EMwWEXCSOLlzG9Bc
	DiBbT+LPWjeQMIuAqsSH3hNsIDavgKXEr3+nwMqFgOxLr7YzgticAlYSd+d/BathFJCVeLTy
	F1gNs4C4xK0n85kgfhCQWLLnPDOELSrx8vE/qN90JM5ef8IIYRtIbF26jwXCVpZY/66NCWKO
	nsSNqVPYIGxtiWULXzND3CMocXLmE5YJjNKzkKybhaRlFpKWWUhaFjCyrGIUSS0tzk3PLTbS
	K07MLS7NS9dLzs/dxAhMd9uO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8IqkOacJ8aYkVlalFuXH
	F5XmpBYfYjQFhtFEZinR5Hxgws0riTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgt
	gulj4uCUamAyP5nIsNs+Sk3q4tWcoqmO8rZzeZqnKJiwcKTWXSxTlzHmTdQ5NV99ptWzR90i
	mTrh10QfNq5kdNijvnb1/Inx2rlSfJMr31bUNpj/rbANFhD4/3hTwBxzh2S9R7+fWv+71a7y
	j/f6jA7ZbN8pdqsmSUtneD0NFNtutSahUGU257Jut4Z7wXfD3955fp138rKiUKv9Ez9Ld2du
	D9q0ircu/oxd11FtpdQySxvLr6uPshRyn781e0/e82ksX3N2BCswvj3/erX66y3FZ2fnzHtl
	L/G0LHvD+YRL2xzaHFr6fX2L1KYwMPhfb4np2llzK4n/1ad74f//H3twu+5oj23M4ps7TnPU
	rE37waKm06PEUpyRaKjFXFScCACpKEirAAQAAA==
X-CMS-MailID: 20240515055731eucas1p12cbbba88e24a011ef5871f90ff25ae73
X-Msg-Generator: CA
X-RootMTR: 20240515055731eucas1p12cbbba88e24a011ef5871f90ff25ae73
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055731eucas1p12cbbba88e24a011ef5871f90ff25ae73
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055731eucas1p12cbbba88e24a011ef5871f90ff25ae73@eucas1p1.samsung.com>

When reclaiming some space by splitting a large folio through
shmem_unused_huge_shrink(), a large folio is split regardless of its
uptodate status. Mark all the blocks as uptodate in the reclaim path so
split_folio() can release the folio private struct (shmem_folio_state).

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 04992010225f..68fe769d91b1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -842,6 +842,7 @@ static unsigned long shmem_unused_huge_shrink(struct sh=
mem_sb_info *sbinfo,
 			goto move_back;
 		}
=20
+		shmem_set_range_uptodate(folio, 0, folio_size(folio));
 		ret =3D split_folio(folio);
 		folio_unlock(folio);
 		folio_put(folio);
--=20
2.43.0
