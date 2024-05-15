Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A83D38E
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752664; cv=none; b=sSct22jEGZlmx4taS2jsFGHa2gECNJhkOWn1p8ApMSGDUJ4o9tXa7wHQ6HHRdWxTo+tLD0JLFbpfj1IUf8X4Uo3u01InGc+TV58kct5WxgIMR4fJ3aafJNmn8bZZbiRO800kyG4DOWrhUjx+CNObMlx+TgyH4yuui1lm6+owpxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752664; c=relaxed/simple;
	bh=GTJH/8ICMJ+xrFPIDY3SHirDZMutD6vtJowQ3Y1pmXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=FeYZ4CTRHNcx9czVAIrwTYOf60wu5FeuKUnNj+k6DX4OKgpff+dCQFB+0ZGLnlAf31qrzyg0z1qKPgDKYjG/1K7nVc5CidwPlv74lBMuMr9pLlmX0aWsxEHTdfSjdaKTL7Ra0PItOdXOfhABfeSMQYeTXiVd1N0tTghfGo+SW3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SONL4RGQ; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SONL4RGQ"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055741euoutp01e7e0daf9b1444275275b08d3fb916e88~Pk-R4ev372237822378euoutp01G
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240515055741euoutp01e7e0daf9b1444275275b08d3fb916e88~Pk-R4ev372237822378euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752661;
	bh=SA7vsxMb4nPPaawAJ345Tbdd6TJyw9vmKosmLEJCqb4=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=SONL4RGQ+3aW3BkT0h8/QH6hsaAX39vkj1HmfbOJsXx4+FG0cBs7IWKZDx2H4DvD9
	 D+BoEZCaxUDJODjN/sJEd/u6Scd+J7FkcMoGZKyY2WYTjlU9aFRg3TraxXWA70yTqz
	 c+bkaCxk3K/DrjoJGBNQ+uai9RzZsu82Mle5zQQs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055740eucas1p25652a13d9ff1daf6170721db7d20973d~Pk-RhccWA1242112421eucas1p2K;
	Wed, 15 May 2024 05:57:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 62.CC.09624.4DE44466; Wed, 15
	May 2024 06:57:40 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055740eucas1p1bf112e73a7009a0f9b2bbf09c989a51b~Pk-RFZpih2872228722eucas1p1q;
	Wed, 15 May 2024 05:57:40 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055740eusmtrp1f762462ac90672e4ece458eafc17f138~Pk-RDcVyU0411404114eusmtrp1E;
	Wed, 15 May 2024 05:57:40 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-6c-66444ed47f04
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id EF.F1.09010.4DE44466; Wed, 15
	May 2024 06:57:40 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055740eusmtip1c1c5c7fdc67df03cf35207303023806f~Pk-Q1q2AV0512205122eusmtip1d;
	Wed, 15 May 2024 05:57:40 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:39 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:39 +0100
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
Subject: [PATCH 12/12] shmem: add large folio support to the write and
 fallocate paths
Thread-Topic: [PATCH 12/12] shmem: add large folio support to the write and
	fallocate paths
Thread-Index: AQHapozKay8vuuiPlUac1QtltK7AQQ==
Date: Wed, 15 May 2024 05:57:38 +0000
Message-ID: <20240515055719.32577-13-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG851zenporB5KtV/qxIBhQ9Ai0cUPZpRkGI9x2WayZRMv0K0H
	RKFAD53oNMGRzdkwws2pBSayMC4SScq9Qo2AKBQwchNELi6tl3YBKZJVIFTawxb++z3v877f
	877JR+GSWYGcilenshq1MsGfFBH1He96tw98Hhm748pwMCqsriKRq6UDIHubA6C++76oJ2uB
	RHPV8zjqt6xFVkcWgQquZmCo31hIovEqlwAZFxuFyGRvwdFwthWge12/CtGCc9ltMB6J8Gaa
	9GNCptigZWrKgxhD5WWSMThyhczDawsE0/Q8jMkbLgPMjPUpwUybBkmmu7hdyMwafL9cEyXa
	o2IT4n9gNSF7Y0Qn63MnBcmP5WnNjT1YOqhdrwNeFKR3wYmMS5gOiCgJXQ5gR1Mlzou3AJbm
	9wNezAJYZpggdIDyjDx6IefrZQA6x55g/zf99q5bwItuAF+PTxG8qABw4KqRdCeS9FZo6jQI
	3YaUHgXQ2tXtETjdKYCLNU2Eu8uH/haai+qAm6X0cag3DQl4VsCuyX5PnaAD4JRrAXezmA6H
	BY3tmJu9lnnsxpwnDdCb4N8V80I347QMPrXcwPi7vWFJQTPO8wa4ZHxO8rwN9jyxAJ53wLpS
	E8HzFlg99QvGv6OAw1fySZ6D4V837Ss7eMPO6xbPyZC+J4LNHeaV4UjY1/dsJcwH2h7UCnn+
	AJrzMolsEKxftZ9+VYZ+VYZ+VUYxICqBjNVyiXEsF6pmzyg4ZSKnVccpvk9KNIDlf2leeuBo
	BEW2GUUrwCjQCiCF+0vF0thPYyVilfLsOVaTFK3RJrBcK9hIEf4ycYBqMyuh45Sp7GmWTWY1
	/7kY5SVPx2LCjL+/yRk93ndpX3zGhgPrsgc3inPnBMz+ybMlsn2Z2vlP7AH1623abYsRL0cq
	NJEVUSk3yy9IRHvPX1adahvX1U54EdF/DgTacw4RhT9/pD324dTBkSW7X9z2z/af+7Em5eBA
	b7qdC7yQ3zw3GvLQWIXCDztfph12Bjm2eudEVUt/ivBJKrdcb5eD0lkDB8o04qMu9U5ZGzT2
	3l7Xbhtq+e7W4GDIiT/s4kdHvtG6bH6v23rvHrAWnY5WBkbfCQ5/9XWoI++La0FmZ2rJpKp4
	d21MXcJX076+nQ0jaXVRfkTmzpDIE8lhb4amZ/7NGvUTbxbodqekn3mbd1E2tOWfho/9Ce6k
	MjQI13DK9yV+jlYGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t/xu7pX/FzSDDZu5beYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7Ft0gPWgotSFXt2nGVqYNwi2sXIwSEhYCJx
	/plUFyMXh5DAUkaJroOtbF2MnEBxGYmNX66yQtjCEn+udbFBFH1klHj/8wwjhHOGUeL8+eXM
	EM5KRon9u74wg7SwCWhK7Du5iR0kISJwm1Hi6akzYA6zwElWiQOnP7ODVAkLREicnruVEcQW
	EYiVWD7jKwuErSdx6sFlsDiLgKrEu/+/wabyClhJzN5xhAnEFhKwlLj0ajtYDSdQ/O78r2CH
	MwrISjxa+QtsPrOAuMStJ/OZIJ4QkFiy5zwzhC0q8fLxP6jndCTOXn/CCGEbSGxduo8FwlaW
	WP+ujQlijp7EjalT2CBsbYllC19D3SMocXLmE5YJjNKzkKybhaRlFpKWWUhaFjCyrGIUSS0t
	zk3PLTbSK07MLS7NS9dLzs/dxAhMeNuO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8IqkOacJ8aYk
	VlalFuXHF5XmpBYfYjQFhtFEZinR5Hxgys0riTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJ
	zU5NLUgtgulj4uCUamCSV+c1TItZX7ko/miyb2O816/A+Id7bhksrta6mrb+2KPexS46SZWP
	5qhvLFgbdeGZ6LSrFbFRnrvmWrf+f7UrSeBFzsGjuo+lajJLeFMmPPqupudslZI1rTPyQtnq
	mKpji8QmLRNtmeRdfVuBaaO4Y53uIZ+Q7NQtc2oYZp05fnW/2vPMlbufHZp53pp1x4FNqtkb
	DZfkvzubtKTnS4ffxyNfPvqGrpj3WrHl6L7JNifXc9SdcT7zRTgkW8n5TnioxpaVtfcWTs9f
	+Z5xz9ZZU6xf5v31ObTrrpzcuocMQv/3rorfHbd4maFL228+jQC+F099nFZ01hZqLfNf9qLQ
	s7fpZJxNTcHaONfnj2/9VmIpzkg01GIuKk4EAM2Wut0BBAAA
X-CMS-MailID: 20240515055740eucas1p1bf112e73a7009a0f9b2bbf09c989a51b
X-Msg-Generator: CA
X-RootMTR: 20240515055740eucas1p1bf112e73a7009a0f9b2bbf09c989a51b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055740eucas1p1bf112e73a7009a0f9b2bbf09c989a51b
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055740eucas1p1bf112e73a7009a0f9b2bbf09c989a51b@eucas1p1.samsung.com>

Add large folio support for shmem write and fallocate paths matching the
same high order preference mechanism used in the iomap buffered IO path
as used in __filemap_get_folio().

Add shmem_mapping_size_order() to get a hint for the order of the folio
based on the file size which takes care of the mapping requirements.

Swap does not support high order folios for now, so make it order-0 in
case swap is enabled.

Skip high order folio allocation loop when reclaim path returns with no
space left (ENOSPC).

Add __GFP_COMP flag for high order folios allocation path to fix a
memory leak.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fcd2c9befe19..9308a334a940 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1836,23 +1836,63 @@ static struct folio *shmem_alloc_folio(gfp_t gfp, s=
truct shmem_inode_info *info,
 	struct page *page;
=20
 	mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
-	page =3D alloc_pages_mpol(gfp, order, mpol, ilx, numa_node_id());
+	page =3D alloc_pages_mpol(gfp | __GFP_COMP, order, mpol, ilx,
+				numa_node_id());
 	mpol_cond_put(mpol);
=20
 	return page_rmappable_folio(page);
 }
=20
+/**
+ * shmem_mapping_size_order - Get maximum folio order for the given file s=
ize.
+ * @mapping: Target address_space.
+ * @index: The page index.
+ * @size: The suggested size of the folio to create.
+ *
+ * This returns a high order for folios (when supported) based on the file=
 size
+ * which the mapping currently allows at the given index. The index is rel=
evant
+ * due to alignment considerations the mapping might have. The returned or=
der
+ * may be less than the size passed.
+ *
+ * Like __filemap_get_folio order calculation.
+ *
+ * Return: The order.
+ */
+static inline unsigned int
+shmem_mapping_size_order(struct address_space *mapping, pgoff_t index,
+			 size_t size, struct shmem_sb_info *sbinfo)
+{
+	unsigned int order =3D ilog2(size);
+
+	if ((order <=3D PAGE_SHIFT) ||
+	    (!mapping_large_folio_support(mapping) || !sbinfo->noswap))
+		return 0;
+
+	order -=3D PAGE_SHIFT;
+
+	/* If we're not aligned, allocate a smaller folio */
+	if (index & ((1UL << order) - 1))
+		order =3D __ffs(index);
+
+	order =3D min_t(size_t, order, MAX_PAGECACHE_ORDER);
+
+	/* Order-1 not supported due to THP dependency */
+	return (order =3D=3D 1) ? 0 : order;
+}
+
 static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
 		struct inode *inode, pgoff_t index,
 		struct mm_struct *fault_mm, bool huge, size_t len)
 {
 	struct address_space *mapping =3D inode->i_mapping;
 	struct shmem_inode_info *info =3D SHMEM_I(inode);
-	unsigned int order =3D 0;
+	unsigned int order =3D shmem_mapping_size_order(mapping, index, len,
+						      SHMEM_SB(inode->i_sb));
 	struct folio *folio;
 	long pages;
 	int error;
=20
+neworder:
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		huge =3D false;
=20
@@ -1937,6 +1977,11 @@ static struct folio *shmem_alloc_and_add_folio(gfp_t=
 gfp,
 unlock:
 	folio_unlock(folio);
 	folio_put(folio);
+	if ((error !=3D -ENOSPC) && (order > 0)) {
+		if (--order =3D=3D 1)
+			order =3D 0;
+		goto neworder;
+	}
 	return ERR_PTR(error);
 }
=20
--=20
2.43.0
