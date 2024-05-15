Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A823BBC1
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715753201; cv=none; b=OoMhxsJTyh0wfgNgr2d16iNhE2iYZsdrw6DhpW3uXpwP2aQ6t6ONvc4mCm8H/gmTZij6ZfEWjbF+f2m2J/Qq0O+EWhN1byFNPwRN6EovFdmaEfNGTbAOhTHJKns5c8/w5knjq7qFHB3tDm6cK8Ns71t8YamIncdfqIPp5NKednQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715753201; c=relaxed/simple;
	bh=FlIMro9fYHrIHzodGeEZAOYgcX95iofZaz0NigQDKVk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version:
	 References; b=nZG83LCFdXwylQXXOxQSXCr9hT29yIueID6e35W7o8R7h7d9bnEaxRVwl3TDp3TgxwOsKIVP/HxpmF2Gywz+TCCtCi1x3I9x0bxlAdxVBeT6sFD2uTBEkxGnubl7Y55DOksfMlUZVGW1Zf3o01wwCFfMN0tQNRlHT82qg1JwB+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qorcBNvu; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qorcBNvu"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055724euoutp019144cea76db9afe1db16c878930cada1~Pk-CfcaFs1504315043euoutp01T
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240515055724euoutp019144cea76db9afe1db16c878930cada1~Pk-CfcaFs1504315043euoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752644;
	bh=FlIMro9fYHrIHzodGeEZAOYgcX95iofZaz0NigQDKVk=;
	h=From:To:CC:Subject:Date:References:From;
	b=qorcBNvur3YVWTbSrc0YoFD4k5UkKq5+IclXWc4D3rcuCi09CMMLv9+/wjwMkx8nF
	 i5K8OUp0HKBJKK4ZnkwkT+VKDrJDo+P5tb4cCB+8yMt1QPreeo2PK3OBaiH4V3M7ms
	 BzL+/QIlep+gS5djRlkTldobroxialMzCN2gbOBo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240515055724eucas1p123d43735df756c930df03a15b9aaaa4c~Pk-CGVGgP2569225692eucas1p1P;
	Wed, 15 May 2024 05:57:24 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 54.BC.09624.4CE44466; Wed, 15
	May 2024 06:57:24 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055723eucas1p11bf14732f7fac943e688369ff7765f79~Pk-BBeao52507525075eucas1p17;
	Wed, 15 May 2024 05:57:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055723eusmtrp1998995defe173d8fde8f92b5cd4e1f29~Pk-A7fuAI0390703907eusmtrp1n;
	Wed, 15 May 2024 05:57:23 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-42-66444ec4ca43
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id C8.16.08810.2CE44466; Wed, 15
	May 2024 06:57:22 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055722eusmtip1230ca867291aac95f529f95e11eb5d21~Pk-As6CJR0512305123eusmtip1r;
	Wed, 15 May 2024 05:57:22 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:22 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:22 +0100
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
Subject: [PATCH 00/12] [LSF/MM/BPF RFC] shmem/tmpfs: add large folios
 support
Thread-Topic: [PATCH 00/12] [LSF/MM/BPF RFC] shmem/tmpfs: add large folios
	support
Thread-Index: AQHapozAuvAdxOGSXU+H5bqWWoTmfw==
Date: Wed, 15 May 2024 05:57:21 +0000
Message-ID: <20240515055719.32577-1-da.gomez@samsung.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <E28FC395BDDC1A43BF00B739EDFE2D8A@scsc.local>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7djP87pH/FzSDGZ95raYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlTG/8RlzwR2x
	iju9L1gaGCeIdTFyckgImEic6bvM0sXIxSEksIJR4vzqp2wQzhdGiT+btjNDOJ8ZJU48nwtU
	xgHW0ni5AqRbSGA5o8S988JwNWc6O6BGnWGU2P5+CROEs5JR4vL9dhaQFjYBTYl9JzexgyRE
	BG4zSjw9dQbMYRY4ySrxZ/NOsCphAX+Jtcv3MoPYIgIhEr3PXrFC2HoSa9suMoHYLAKqEvc7
	b7GB2LwClhIvH04Cq2EUkJV4tPIXO4jNLCAucevJfCaIVwUlFs3ewwxhi0n82/WQDcLWkTh7
	/QkjhG0gsXXpPhYIW1li/bs2JpCfmYGuXr9LH2KkpcS6/48ZIWxFiSndD9khThCUODnzCVTr
	Ti6Ju9cqIWwXiWMHz0PFhSVeHd/CDmHLSJye3MMygVF7FpJLZyFsm4Vk2ywk22Yh2baAkXUV
	o3hqaXFuemqxYV5quV5xYm5xaV66XnJ+7iZGYPo8/e/4px2Mc1991DvEyMTBeIhRgoNZSYRX
	JM05TYg3JbGyKrUoP76oNCe1+BCjNAeLkjivaop8qpBAemJJanZqakFqEUyWiYNTqoGpWZHT
	+7PNtMxOrVkbxW1uMj7/wS2v6u8hWTL1oumyGe2RbBPbv0n9XzXF+IAY++pTp3MFJ26b1HM3
	5PJDnZTLG/2iVJUPGMclNR7Qv9N5zjzkULvFaZ87LJ/Yw43PhRzIDJ1/xfAGl079kQpe53t/
	9HWTt82w9qx8Gnihv23dLaXP7anNU70FvoV29crpL1Lh3DBVjqmjbfaust7fmwR/tz7ou5Te
	YC7cFOAY+v117Py0iZenh7G87rHtm8a0rczp1saTomcEFyUqFovZRju2mVvcy1VOeJ65l63Z
	q7+Ts761me3SSqHwzZWn7nv93vC2t9fJyNhvhsJdO0lRTU8Jnje7p2bOl+Va2G3KocRSnJFo
	qMVcVJwIAO4ExIgOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/xu7qH/FzSDOY+tbSYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzG/8RlzwR2xiju9L1gaGCeIdTFycEgImEg0
	Xq7oYuTiEBJYyiixeP0y5i5GTqC4jMTGL1dZIWxhiT/XuthAbCGBj4wSn1ewQzScYZToPXuO
	GcJZySjxfPMdRpAqNgFNiX0nN4FViQjcZpR4euoMmMMscJJV4sDpz+wgu4UFfCV+3vQBaRAR
	CJFo7bnMBmHrSaxtu8gEYrMIqErc77wFFucVsJR4+XAS2EmMArISj1b+YgexmQXEJW49mc8E
	caqAxJI956FeEJV4+fgf1As6EmevP2GEsA0kti7dxwJhK0usf9fGBHIOM9DR63fpQ4y0lFj3
	/zEjhK0oMaX7ITvECYISJ2c+YZnAKDULyeZZCN2zkHTPQtI9C0n3AkbWVYwiqaXFuem5xYZ6
	xYm5xaV56XrJ+bmbGIGJbtuxn5t3MM579VHvECMTB+MhRgkOZiURXpE05zQh3pTEyqrUovz4
	otKc1OJDjKbAEJrILCWanA9MtXkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalF
	MH1MHJxSDUyHGi7umvXpRTFjOovJrZbXdzckuThvmC8yqXLygZb8fzHnhLpzw+0e2fzWYPc6
	cH/TqhlSVcXXZ3Cs433se/3PylOL3tczimtJfVvXe1dk9oLDP38XPolbLMzGkfZ/wWPRFQl+
	i94w2Dv7PMl8+++WX1mImIZRc+L2dOFeTsnd/ZdCg60Zen5tV75456Da/aDwibJMaZ+2qZ3K
	N5h1PXJ+zsawlweXHmW9IcT5rGvWwv1TOzRq1dT3a89O5qje/Jrznd5+bm4WFmPVSRe2aDjv
	Fzh7wznw+FrrSd0+K44/4r8YOmPd7eoTzVs2v1pzc9m5A/a375zJ5Dtnbrbo7+p576cfmKT9
	aOedbovbL3LZLJVYijMSDbWYi4oTAeKajqn9AwAA
X-CMS-MailID: 20240515055723eucas1p11bf14732f7fac943e688369ff7765f79
X-Msg-Generator: CA
X-RootMTR: 20240515055723eucas1p11bf14732f7fac943e688369ff7765f79
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055723eucas1p11bf14732f7fac943e688369ff7765f79
References: <CGME20240515055723eucas1p11bf14732f7fac943e688369ff7765f79@eucas1p1.samsung.com>

SW4gcHJlcGFyYXRpb24gZm9yIHRoZSBMU0YvTU0vQlBGIDIwMjQgZGlzY3Vzc2lvbiBbMV0sIHRo
ZSBwYXRjaGVzIGJlbG93IGFkZA0Kc3VwcG9ydCBmb3IgbGFyZ2UgZm9saW9zIGluIHNobWVtIGZv
ciB0aGUgd3JpdGUgYW5kIGZhbGxvY2F0ZSBwYXRocy4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC80a3RwYXl1NjZub2tsbGxwZHBzcGEzdm01Z2JtYjVib3hza2NqMnE2cW43bWQz
cHd3dEBrdmx1NjRwcXdqemwvDQp0ZXN0DQoNClRoaXMgdmVyc2lvbiBpbmNsdWRlcyBwZXItYmxv
Y2sgdXB0b2RhdGUgdHJhY2tpbmcgcmVxdWlyZWQgZm9yIGxzZWVrIHdoZW4NCmVuYWJsaW5nIHN1
cHBvcnQgZm9yIGxhcmdlIGZvbGlvcy4gSW5pdGlhbGx5LCB0aGlzIGZlYXR1cmUgd2FzIGludHJv
ZHVjZWQgdG8NCmFkZHJlc3MgbHNlZWsgZnN0ZXN0cyAoc3BlY2lmaWNhbGx5IGdlbmVyaWMvMjg1
IGFuZCBnZW5lcmljLzQzNikgZm9yIGh1Z2UgcGFnZXMuDQpIb3dldmVyLCBpdCB3YXMgc3VnZ2Vz
dGVkIHRoYXQsIGZvciBUSFAsIHRoZSB0ZXN0IHNob3VsZCBiZSBhZGFwdGVkIHRvIFBBR0VfU0la
RQ0KYW5kIFBNRF9TSVpFLiBOZXZlcnRoZWxlc3MsIHdpdGggYXJiaXRyYXJ5IGZvbGlvIG9yZGVy
cyB3ZSByZXF1aXJlIHRoZSBsb3dlc3QNCmdyYW51bGFyaXR5IHBvc3NpYmxlLiBUaGlzIHRvcGlj
IHdpbGwgYmUgcGFydCBvZiB0aGUgZGlzY3Vzc2lvbiBpbiB0b21vcnJvdydzDQpzZXNzaW9uLg0K
DQpGc3Rlc3RzIGV4cHVuZ2VzIHJlc3VsdHMgY2FuIGJlIGZvdW5kIGluIGtkZXZvcHMnIHRyZWU6
DQpodHRwczovL2dpdGh1Yi5jb20vbGludXgta2Rldm9wcy9rZGV2b3BzL3RyZWUvbWFpbi93b3Jr
Zmxvd3MvZnN0ZXN0cy9leHB1bmdlcy82LjkuMC1zaG1lbS1sYXJnZS1mb2xpb3Mtd2l0aC1ibG9j
ay10cmFja2luZy90bXBmcw0KaHR0cHM6Ly9naXRodWIuY29tL2xpbnV4LWtkZXZvcHMva2Rldm9w
cy90cmVlL21haW4vd29ya2Zsb3dzL2ZzdGVzdHMvZXhwdW5nZXMvNi44LjAtc2htZW0tbGFyZ2Ut
Zm9saW9zLXdpdGgtYmxvY2stdHJhY2tpbmcvdG1wZnMNCg0KRGFuaWVsDQoNCkRhbmllbCBHb21l
eiAoMTEpOg0KICBzaG1lbTogYWRkIHBlci1ibG9jayB1cHRvZGF0ZSB0cmFja2luZyBmb3IgbGFy
Z2UgZm9saW9zDQogIHNobWVtOiBtb3ZlIGZvbGlvIHplcm8gb3BlcmF0aW9uIHRvIHdyaXRlX2Jl
Z2luKCkNCiAgc2htZW06IGV4aXQgc2htZW1fZ2V0X2ZvbGlvX2dmcCgpIGlmIGJsb2NrIGlzIHVw
dG9kYXRlDQogIHNobWVtOiBjbGVhcl9oaWdocGFnZSgpIGlmIGJsb2NrIGlzIG5vdCB1cHRvZGF0
ZQ0KICBzaG1lbTogc2V0IGZvbGlvIHVwdG9kYXRlIHdoZW4gcmVjbGFpbQ0KICBzaG1lbTogY2hl
Y2sgaWYgYSBibG9jayBpcyB1cHRvZGF0ZSBiZWZvcmUgc3BsaWNlIGludG8gcGlwZQ0KICBzaG1l
bTogY2xlYXIgdXB0b2RhdGUgYmxvY2tzIGFmdGVyIFBVTkNIX0hPTEUNCiAgc2htZW06IGVuYWJs
ZSBwZXItYmxvY2sgdXB0b2RhdGUNCiAgc2htZW06IGFkZCBvcmRlciBhcmcgdG8gc2htZW1fYWxs
b2NfZm9saW8oKQ0KICBzaG1lbTogYWRkIGZpbGUgbGVuZ3RoIGFyZyBpbiBzaG1lbV9nZXRfZm9s
aW8oKSBwYXRoDQogIHNobWVtOiBhZGQgbGFyZ2UgZm9saW8gc3VwcG9ydCB0byB0aGUgd3JpdGUg
YW5kIGZhbGxvY2F0ZSBwYXRocw0KDQpQYW5rYWogUmFnaGF2ICgxKToNCiAgc3BsaWNlOiBkb24n
dCBjaGVjayBmb3IgdXB0b2RhdGUgaWYgcGFydGlhbGx5IHVwdG9kYXRlIGlzIGltcGwNCg0KIGZz
L3NwbGljZS5jICAgICAgICAgICAgICB8ICAxNyArLQ0KIGZzL3hmcy9zY3J1Yi94ZmlsZS5jICAg
ICB8ICAgNiArLQ0KIGZzL3hmcy94ZnNfYnVmX21lbS5jICAgICB8ICAgMyArLQ0KIGluY2x1ZGUv
bGludXgvc2htZW1fZnMuaCB8ICAgMiArLQ0KIG1tL2todWdlcGFnZWQuYyAgICAgICAgICB8ICAg
MyArLQ0KIG1tL3NobWVtLmMgICAgICAgICAgICAgICB8IDQ0MSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0NCiBtbS91c2VyZmF1bHRmZC5jICAgICAgICAgfCAgIDIgKy0N
CiA3IGZpbGVzIGNoYW5nZWQsIDQxNyBpbnNlcnRpb25zKCspLCA1NyBkZWxldGlvbnMoLSkNCg0K
LS0gDQoyLjQzLjANCg==
