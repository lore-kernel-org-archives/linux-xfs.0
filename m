Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E9A3B79F
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752653; cv=none; b=eJKOK22O3cEwuP7y7nLb4U5tBmWK1sbX2VQtWbMxe5H/yYPnpC5kAEnDaxJGvObbrnzcqaUKEFmTuVBfMXL3OHHTR6EBPC8bn+K8oNaAlsPgE1g+cR1qhAnGS4rBKlMaEjpPimy55VpNiTgRSt961b5bY6xZ0aXIzVfkNPwJ2Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752653; c=relaxed/simple;
	bh=nKWtereSLnu+oADE1O/ufkjOx3uZ4D3VDRJRS1eEsrU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=IXhiq2Z5Y2skmsASMytq0PlTukvYr6pPBTtIF7lGX4jWtpynpUIMEsOTjSkHm5YMGavEY7W2n0b2QO9nhdtG50PFzxdN0Ue/Zhba5MBRFC0hrF7eFLYjQ3hyzgsyp4dzHBw23nlHdQqYwYSUm+v7cxC+t7x3yNeGj6M7VfDA+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u4gdewf9; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u4gdewf9"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055730euoutp022866c13aa86ac67bad51f8caa2d17464~Pk-HoGjk11630116301euoutp024
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055730euoutp022866c13aa86ac67bad51f8caa2d17464~Pk-HoGjk11630116301euoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752650;
	bh=LR6zBAqCV5AW0imgsMiCR7+GSDVrb77Uvzm1KnB3t5Q=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=u4gdewf9aJ1/hhtGBiE/AmTK+E5NWKJWqtb2PRSlRy83TSAxt4f3BpHcof9oHbueN
	 MzhWqh/cQJSDFsGv8sy8w4ztloQ2ME+6LaNnRwvwsRd6kpdoAxXP4czSSaz95blMV0
	 +IyiWcyKqbhQsY6Q5tpyQPHYqJ/qj4t9yFEv2zHE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240515055729eucas1p1783caa60b5809909e5f5f02340a8b5e9~Pk-HRYZK_2872228722eucas1p1g;
	Wed, 15 May 2024 05:57:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id BB.BC.09624.9CE44466; Wed, 15
	May 2024 06:57:29 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055729eucas1p14e953424ad39bbb923c64163b1bbd4b3~Pk-Gop9GA2569725697eucas1p19;
	Wed, 15 May 2024 05:57:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055729eusmtrp1fe48c4be7bfa2cd516577c63c5d4fcec~Pk-GoCb900390703907eusmtrp15;
	Wed, 15 May 2024 05:57:29 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-56-66444ec9e21e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 4C.16.08810.9CE44466; Wed, 15
	May 2024 06:57:29 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055728eusmtip16c7550411a40722fd434edbb57cdb6d4~Pk-GdPs9a0562305623eusmtip1T;
	Wed, 15 May 2024 05:57:28 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:28 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:28 +0100
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
Subject: [PATCH 05/12] shmem: clear_highpage() if block is not uptodate
Thread-Topic: [PATCH 05/12] shmem: clear_highpage() if block is not uptodate
Thread-Index: AQHapozEyRWHtpwfgE2CvOQjrDJhgA==
Date: Wed, 15 May 2024 05:57:28 +0000
Message-ID: <20240515055719.32577-6-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djPc7on/VzSDJrmGlrMWb+GzeL/3mOM
	Fq8Pf2K0uHRUzuJs3282i6/rfzFbXH7CZ/H0Ux+LxezpzUwWl3fNYbO4t+Y/q8WuPzvYLfa9
	3stscWPCU0aLg6c62C1+/wDKbt8V6SDosXPWXXaPBZtKPTav0PLYtKqTzWPTp0nsHidm/Gbx
	2PnQ0mPyjeWMHh+f3mLxeL/vKpvHmQVH2D0+b5IL4InisklJzcksSy3St0vgyph04zxbwVa2
	ireXO5gaGBewdjFyckgImEjcvjydrYuRi0NIYAWjxJX5x5lBEkICXxglLswKhUh8ZpQ4s2om
	G0zH6rWPoTqWM0pcunKRFa7qXet+Joj2M0CZkw4QiZWMEk9PLGAESbAJaErsO7mJHSQhInAb
	KHHqDJjDLHCSVeLP5p0sIFXCAu4STed+soPYIgI+EvdvrmaCsPUkFnS+BYuzCKhKfOleCfYG
	r4ClRO+2HjCbU8BK4u78r2DHMgrISjxa+QusnllAXOLWk/lMEE8ISiyavYcZwhaT+LfrIdRz
	OhJnrz9hhLANJLYu3ccCYStLrH/XxgQxR0/ixtQpbBC2tsSyha+ZIW4QlDg58wkLyDMSAju5
	JF4e/gq1zEXiU+sFqAXCEq+Ob2GHsGUkTk/uYZnAqD0LyX2zkOyYhWTHLCQ7FjCyrGIUTy0t
	zk1PLTbMSy3XK07MLS7NS9dLzs/dxAhMlqf/Hf+0g3Huq496hxiZOBgPMUpwMCuJ8IqkOacJ
	8aYkVlalFuXHF5XmpBYfYpTmYFES51VNkU8VEkhPLEnNTk0tSC2CyTJxcEo1MGWvaBKVV2Fw
	6+RxjpydYJVu9D2l8jirv/BigYac69UyKtOUPv/YbfPI3KvGckpxue2PC9bP5t2f0Xnk9NlM
	XfGLc0Wt3haXOjbd+HzEK7pd9dEPx6nZVg/jzx383DBbQ//SxVszBRe111fJsVrMWtGQ8EWX
	//GvPYJvS3SijL/1Xig9XbBubeF32cCjE+c1Byx/brCkNz8ibsmSJdvigzNf/9j16sOh2Qts
	Kp4LbPtf/mPq9s8ttlY1C5duFOsRLunjCWdkTd926s6Kwrl+X3o6ptZm6vXu1E/bMjVZWpBD
	eMP92Gbbl48eXhP8+d3BRWle84rADtE+pdCNgSb1kYfDc1Zz+rvoOT/8YWD7RomlOCPRUIu5
	qDgRAEUOKUQFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t/xu7on/VzSDKbtZrOYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzHpxnm2gq1sFW8vdzA1MC5g7WLk5JAQMJFY
	vfYxWxcjF4eQwFJGiSf7prJDJGQkNn65ClUkLPHnWhdU0UdGiRnTr7BAOGcYJVad62WEcFYy
	SvyZ84kJpIVNQFNi38lN7CAJEYHbjBJPT50Bc5gFTrJKHDj9GWyJsIC7RNO5n2C2iICPxP2b
	q5kgbD2JBZ1vweIsAqoSX7pXgh3CK2Ap0butB8wWArIvvdrOCGJzClhJ3J3/lQ3EZhSQlXi0
	8hdYL7OAuMStJ/OZIJ4QkFiy5zwzhC0q8fLxP6jndCTOXn/CCGEbSGxduo8FwlaWWP+ujQli
	jp7EjalT2CBsbYllC18zQ9wjKHFy5hOWCYzSs5Csm4WkZRaSlllIWhYwsqxiFEktLc5Nzy02
	1CtOzC0uzUvXS87P3cQITHnbjv3cvINx3quPeocYmTgYDzFKcDArifCKpDmnCfGmJFZWpRbl
	xxeV5qQWH2I0BYbRRGYp0eR8YNLNK4k3NDMwNTQxszQwtTQzVhLn9SzoSBQSSE8sSc1OTS1I
	LYLpY+LglGpgypv91ajndmjpQ9E6vgCli63sYQJCl4s6r5hmy5jOPnzn469rEh0HJ5//MD2V
	/1z3j6vy+zatb9tetmHDwtdyeR/TH/y7FM/LeD7ipUp8tliX1v9dP1ae4CtNe+8/b4Gn0xKV
	upnWjmVN3xba37+leDcw3rH9VcTv2ZYWNT+TbJIYdyuqdk/bVHb66eKq5c2K9wwCrBn1NSf+
	SAi/Ubx757y8O0oOyc7mvtcTUlWVDHjCxPr2u7XbrLQLqok/V+47xX+t+KJNTX3Tz7z4GSCx
	MJ8z7GnU6bcZrHE9v3/+DJ6nYqmSFrd5Dc+N9erB95w+193devD39GXbeZ7K1E1sfq132CyP
	g2P/l4jzER/eK7EUZyQaajEXFScCAKuYz08CBAAA
X-CMS-MailID: 20240515055729eucas1p14e953424ad39bbb923c64163b1bbd4b3
X-Msg-Generator: CA
X-RootMTR: 20240515055729eucas1p14e953424ad39bbb923c64163b1bbd4b3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055729eucas1p14e953424ad39bbb923c64163b1bbd4b3
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055729eucas1p14e953424ad39bbb923c64163b1bbd4b3@eucas1p1.samsung.com>

clear_highpage() is called for all the subpages (blocks) in a large
folio when the folio is not uptodate. Do clear the subpages only when
they are not uptodate.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 69f3b98fdf7c..04992010225f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2256,7 +2256,8 @@ static int shmem_get_folio_gfp(struct inode *inode, p=
goff_t index,
 		long i, n =3D folio_nr_pages(folio);
=20
 		for (i =3D 0; i < n; i++)
-			clear_highpage(folio_page(folio, i));
+			if (!shmem_is_block_uptodate(folio, i))
+				clear_highpage(folio_page(folio, i));
 		flush_dcache_folio(folio);
 		shmem_set_range_uptodate(folio, 0, folio_size(folio));
 	}
--=20
2.43.0
