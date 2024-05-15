Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11804AEDD
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752660; cv=none; b=CUiAYS8Afq7Us2ytavfABIdlCNs7dopPURiFP8XxjqoNydhgmvUNugKf/RvdhYmoKP0BnOi9adJyniDT7LnbiWjauZFPxb902FvGDqbGB7TOXphvWXh1T9cW5pF+xt98gmuhyqKJp1bETmwu2AX9AGPd8LMuhgKaoHDsV928aTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752660; c=relaxed/simple;
	bh=0RjdBokNWoS+vSi83hgJATS/2MIQWi5fahvmgWZkpmk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=tavBd/wcTkGANEMyYDvywVzOXkW4hP55DPJtKEZY5EL6+bbNgEQPqbI9HGNbG/ix34km8Xm9QZ11AeOee/phoWlZ/xGd88NPIrUvyrSl4hAzvlqVj4yR7CZZXfowkXizsOmDLJRCDDZC2ecbGLZ8q7+/9HFyuoWotTTm5kmoCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XE0WeUZ4; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XE0WeUZ4"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055737euoutp01bb0dd00b00eb3dfee23706a812c60540~Pk-OZp7k91508115081euoutp01L
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240515055737euoutp01bb0dd00b00eb3dfee23706a812c60540~Pk-OZp7k91508115081euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752657;
	bh=KSFa/00drIrpTPTVaHKTJFLNN4vEYokk0j2qhn9ASTY=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=XE0WeUZ4/fxHAxJkG/mIY/WGU0C4ZHUEw5qzBkuqT9YA+ux6u/VMvXpPQ5QfXZsCN
	 RAdqw8x6EFSJ3Uy0xmtAXcHqL9FipFkZbQdC03MkUvzvsQe44ht0ez97k3oK7S9HbB
	 ZKW8iyeunnHh5sOncAza29RBBZxrEoJLw6eIoNhE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055737eucas1p2687839099f1491893036e9edf50d6776~Pk-N8z2ap0810008100eucas1p2W;
	Wed, 15 May 2024 05:57:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 58.D8.09875.0DE44466; Wed, 15
	May 2024 06:57:36 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055736eucas1p1bfa9549398e766532d143ba9314bee18~Pk-NPUDB_1859218592eucas1p1L;
	Wed, 15 May 2024 05:57:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055736eusmtrp1cd38f7c68e33115cb0f700536a34b1e1~Pk-NOpRJH0411404114eusmtrp1C;
	Wed, 15 May 2024 05:57:36 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-f1-66444ed03f5f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 6D.F1.09010.0DE44466; Wed, 15
	May 2024 06:57:36 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055736eusmtip10c080390bd41a09baa29d247f828f893~Pk-NCedQq0562705627eusmtip1T;
	Wed, 15 May 2024 05:57:36 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:35 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:35 +0100
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
Subject: [PATCH 10/12] shmem: add order arg to shmem_alloc_folio()
Thread-Topic: [PATCH 10/12] shmem: add order arg to shmem_alloc_folio()
Thread-Index: AQHapozIzXRp8FIrX0Ow3XgDmWV32Q==
Date: Wed, 15 May 2024 05:57:35 +0000
Message-ID: <20240515055719.32577-11-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djP87oX/FzSDHZ9srSYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlTHv32L2gg3i
	Ff9/bmJpYOwU7mLk5JAQMJHYOuUDaxcjF4eQwApGid2LZ7ODJIQEvjBKvH2cDJH4zCjx9f1W
	dpiOWXcus0AkljNKzOxfyA5XtXDBaWYI5wyjxKO7kxghZq1klDjzUATEZhPQlNh3chNYh4jA
	bUaJp6fOgDnMAidZJf5s3skCUiUs4CSx93wLM4gtIuAucfTWLBYIW0/i9MsZYFNZBFQlJqz7
	AFbDK2AlsfTrObA4J5B9d/5XNhCbUUBW4tHKX2CHMwuIS9x6Mp8J4glBiUWz9zBD2GIS/3Y9
	ZIOwdSTOXn/CCGEbSGxduo8FwlaWWP+ujQlijp7EjalT2CBsbYllC19D3SAocXLmE6j6nVwS
	zTfrIGwXicPPzkADT1ji1fEtULaMxOnJPSwTGLVnITlvFpIVs5CsmIVkxQJGllWM4qmlxbnp
	qcVGeanlesWJucWleel6yfm5mxiBqfL0v+NfdjAuf/VR7xAjEwfjIUYJDmYlEV6RNOc0Id6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4ryqKfKpQgLpiSWp2ampBalFMFkmDk6pBiZ968YM2RfC+/uW
	qa32ejDZVVPRnO/thFTv1xU6D7ZdSzj7Oka3S+figs+OG55ppVx2SZ6pks0jdNV94fU1jS4+
	9/b9qJke42Ip4Glue3TaJb/p6tfr2LK/roismOIwx7LPxfYdX1K/WjDXmYiSH6Hp3JtsC6I+
	MyYtuxAd+9e8/dfS9Y43ZG2nHf/ZWvZLx+X269Z5NzUevt62KLT1o4XBg8dcV7vqXdkWnGGP
	uuh7KjJns6JfyfPIgBehU54Vvr/Oyhep9vnD4lPv5ixrun5lznkH9eXWegf+bZlSf//Z9Lt7
	rDzvdUSELf/Cc9PiekiKqFGqCMP8ZsGq30vKlRTs/qmEMv/K2Ffzab/xhh1KLMUZiYZazEXF
	iQABqfQhBAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t/xu7oX/FzSDH5u5rKYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzHv32L2gg3iFf9/bmJpYOwU7mLk5JAQMJGY
	decySxcjF4eQwFJGiWuX+tkgEjISG79cZYWwhSX+XOtigyj6yCjx88ICKOcMo8Sktf/AOoQE
	VjJK9LyNB7HZBDQl9p3cxA5SJCJwm1Hi6akzYA6zwElWiQOnP7ODVAkLOEnsPd/CDGKLCLhL
	HL01iwXC1pM4/XIGI4jNIqAqMWHdB7AaXgEriaVfzzFCbLOUuPRqO5jNCRS/O/8r2BWMArIS
	j1b+ApvPLCAucevJfCaIHwQkluw5zwxhi0q8fPwP6jcdibPXnzBC2AYSW5fuY4GwlSXWv2tj
	gpijJ3Fj6hQ2CFtbYtnC11D3CEqcnPmEZQKj9Cwk62YhaZmFpGUWkpYFjCyrGEVSS4tz03OL
	jfSKE3OLS/PS9ZLzczcxAhPetmM/t+xgXPnqo94hRiYOxkOMEhzMSiK8ImnOaUK8KYmVValF
	+fFFpTmpxYcYTYFhNJFZSjQ5H5hy80riDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1ML
	Uotg+pg4OKUamFgN7O6vOHnc/+p+pr9Ptq9pbzyg0zx7rvZNdukX8xz+sGyS/yXUdlXCLUG4
	RkrP3k0sIeRWWpYbp7W6+swXmryvFv1ct23Rokmt35dM1/51cvc13v/SKidS/eqTelQ6bjI+
	URAuN2Hnz2cKvxJ3SS3k8rTZgXsMYh8fPV67x6F5mtyMxX1dQW6nZq/iz/BW7C8NUJbcUZCm
	cd5f3z2ornxusa1H1MfPUpG3J5qfbeUTO/vqgdPit1Wf+n2VN683NlI+lXLmFzPfA2uuM3Wb
	RN26T/LqZJQ7Xdsp75R5I+DXvy2Kf9V/LLRl9HQS6FkyYVOQ/5cEt8SoGYFT1nilvJnKs9FW
	P/vf0+B+vnM8SizFGYmGWsxFxYkAp8+SoAEEAAA=
X-CMS-MailID: 20240515055736eucas1p1bfa9549398e766532d143ba9314bee18
X-Msg-Generator: CA
X-RootMTR: 20240515055736eucas1p1bfa9549398e766532d143ba9314bee18
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055736eucas1p1bfa9549398e766532d143ba9314bee18
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055736eucas1p1bfa9549398e766532d143ba9314bee18@eucas1p1.samsung.com>

Add folio order argument to the shmem_alloc_folio(). Return will make
use of the new page_rmappable_folio() where order-0 and high order
folios are both supported.

As the order requested may not match the order returned when allocating
high order folios, make sure pages are calculated after getting the
folio.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7a6ad678e2ff..d531018ffece 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1828,18 +1828,18 @@ static struct folio *shmem_alloc_hugefolio(gfp_t gf=
p,
 	return page_rmappable_folio(page);
 }
=20
-static struct folio *shmem_alloc_folio(gfp_t gfp,
-		struct shmem_inode_info *info, pgoff_t index)
+static struct folio *shmem_alloc_folio(gfp_t gfp, struct shmem_inode_info =
*info,
+				       pgoff_t index, unsigned int order)
 {
 	struct mempolicy *mpol;
 	pgoff_t ilx;
 	struct page *page;
=20
-	mpol =3D shmem_get_pgoff_policy(info, index, 0, &ilx);
-	page =3D alloc_pages_mpol(gfp, 0, mpol, ilx, numa_node_id());
+	mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
+	page =3D alloc_pages_mpol(gfp, order, mpol, ilx, numa_node_id());
 	mpol_cond_put(mpol);
=20
-	return (struct folio *)page;
+	return page_rmappable_folio(page);
 }
=20
 static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
@@ -1848,6 +1848,7 @@ static struct folio *shmem_alloc_and_add_folio(gfp_t =
gfp,
 {
 	struct address_space *mapping =3D inode->i_mapping;
 	struct shmem_inode_info *info =3D SHMEM_I(inode);
+	unsigned int order =3D 0;
 	struct folio *folio;
 	long pages;
 	int error;
@@ -1856,7 +1857,6 @@ static struct folio *shmem_alloc_and_add_folio(gfp_t =
gfp,
 		huge =3D false;
=20
 	if (huge) {
-		pages =3D HPAGE_PMD_NR;
 		index =3D round_down(index, HPAGE_PMD_NR);
=20
 		/*
@@ -1875,12 +1875,13 @@ static struct folio *shmem_alloc_and_add_folio(gfp_=
t gfp,
 		if (!folio)
 			count_vm_event(THP_FILE_FALLBACK);
 	} else {
-		pages =3D 1;
-		folio =3D shmem_alloc_folio(gfp, info, index);
+		folio =3D shmem_alloc_folio(gfp, info, index, order);
 	}
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
=20
+	pages =3D folio_nr_pages(folio);
+
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
=20
@@ -1976,7 +1977,7 @@ static int shmem_replace_folio(struct folio **foliop,=
 gfp_t gfp,
 	 */
 	gfp &=3D ~GFP_CONSTRAINT_MASK;
 	VM_BUG_ON_FOLIO(folio_test_large(old), old);
-	new =3D shmem_alloc_folio(gfp, info, index);
+	new =3D shmem_alloc_folio(gfp, info, index, folio_order(old));
 	if (!new)
 		return -ENOMEM;
=20
@@ -2855,7 +2856,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
=20
 	if (!*foliop) {
 		ret =3D -ENOMEM;
-		folio =3D shmem_alloc_folio(gfp, info, pgoff);
+		folio =3D shmem_alloc_folio(gfp, info, pgoff, 0);
 		if (!folio)
 			goto out_unacct_blocks;
=20
--=20
2.43.0
