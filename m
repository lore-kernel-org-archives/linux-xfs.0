Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419233A1DC
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752650; cv=none; b=dQ5FkigzD+P35rYUQCAELKUEsyaS67/3Jak+gL+xStx9+oUH9DiCv8B4cO4E2wuQDu2b+1chw2hOf0grjKWxNTsU7unVRWydL6Sh/KgG9J0pGODFPhQvwNd8UVhg/Di+BN4G2+2AnxKt1N+ux+LEGLBgp8ij+tX71FF96AE70jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752650; c=relaxed/simple;
	bh=RH5M2Ft1yieIKx+BOHBf4ZaFqhptJPv2A+bAcQFaiHQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=RXPSOhJDw+9UyhhTYoZjCWn4jn7eFb5gffYW2/zn7mH7uqp3kzPkHCXw1KJBDpCsGdKtOwV8l3q0e7Y6zAF8B4cz6JxZP6J4OWCrVcgpicZePgivC8V7lKHd1Qd4HTV1ahNzQNziyx2bP7r8V5s+6kRnv2KPgrpJPaF+A7gRgpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ngyRgTVK; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ngyRgTVK"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055726euoutp021e499958ffdd8c97e79237574b9aeccf~Pk-EUSUOw1334513345euoutp02K
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055726euoutp021e499958ffdd8c97e79237574b9aeccf~Pk-EUSUOw1334513345euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752646;
	bh=dTnZOoNYjEenQBIjBgvJcx5/I/6R08XCA2XZxGoD7mw=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=ngyRgTVKgIg06q8/vI0Fid46l37RPLZvHru4oqaGh/1vminFbwPmV86npg8rgwWAv
	 RriHtUBW0RpYX6BP2vGsF19pKZsDEiYTWJ8lgrtshZXCeTRBWlb/vdteRyeGKLRgvs
	 m5ZiVX3BQToI7JU8pA0udsY+xeX3WVGdCT7J97kk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240515055724eucas1p14abe531cee8b71732d5f48dbf9cc26e6~Pk-CeXLbu2872228722eucas1p1Y;
	Wed, 15 May 2024 05:57:24 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 75.BC.09624.4CE44466; Wed, 15
	May 2024 06:57:24 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055724eucas1p1c502dbded4dc6ff929c7aff570de80c2~Pk-B985K61859218592eucas1p1C;
	Wed, 15 May 2024 05:57:24 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055724eusmtrp1eef596575f6b6795be5c3de034b524d3~Pk-B9Q91t0390703907eusmtrp1o;
	Wed, 15 May 2024 05:57:24 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-44-66444ec46294
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id E9.16.08810.4CE44466; Wed, 15
	May 2024 06:57:24 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055723eusmtip1edc9607f2a5ec529c7552cf4a0766878~Pk-Bw0UHM0235902359eusmtip1Q;
	Wed, 15 May 2024 05:57:23 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:23 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:23 +0100
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
Subject: [PATCH 01/12] splice: don't check for uptodate if partially
 uptodate is impl
Thread-Topic: [PATCH 01/12] splice: don't check for uptodate if partially
	uptodate is impl
Thread-Index: AQHapozBbWbHWLdhTE2QsNHTwXO1jw==
Date: Wed, 15 May 2024 05:57:23 +0000
Message-ID: <20240515055719.32577-2-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTGfe+9vfdS1nmp3XgDQ0wNfwha1JntRYm6TJObaSYmJsavaCMX
	JAOUWytM50JkIasiY3VDbZkFKxQKhtiCQIUqDEE+NESmI4AkLO0yymJLEfzoFWZ7ceG/35Pz
	nPOckxwal7+QRNEZ2Sc5PludqSSlxO2u14/WdH69LW3t8MuVqKy+jkTzbV0ATf7uB+jx/eXo
	YXGARDP1b3A06PoQuf3FBDJeLsDQoKOMRGN18xLkEJop5Jxsw9FQiRug9t4fKRR49a7a5Ni3
	NYJtMTyj2HKblrVXx7M2q45kbX49xT64EiDYlvEk9tKQBbBT7mGC9TqfkGx/eSfFTtuWp3yw
	X5qcymVmnOL4xM1HpMf6TBXYiaeyvEaDlcgHI9LzIIyGzAZonJigzgMpLWeqAbzYdYUUxQsA
	C2vnMVFMA3jj70r8fUvA5wViwQKgebQB/99lLnu1MKwfQNMjHyGKGgA9/1aF+klmFXT22EIu
	BTMCoLu3PyRwpkcCBXsLEXQtY/ZCvfAPFmQFcxCW1tbhIqvgjZtuSZAJJg56Al4qyDImCfqa
	PCFPGLMRPjPNkEEGTAz8q+ZNyIMzkXDYZcLEKyLgdWPrwkUfwznHOCnyavjwTxcQeS1srHQS
	Iq+E9c8LMXGOCg79+gspcgKsqpjExR0iYM9VV+hkyLRL4c/FryVi8zb4eGRiIWwZ9HQ3UCJ/
	AvsuFRElIMGwaD/DogzDogzDooxyQFhBJKfVZKVzmnXZXK5Ko87SaLPTVUePZ9nAu8fsm+v2
	N4PfPFOqDoDRoANAGlcqZIq0L9PkslT1t6c5/vhhXpvJaTpANE0oI2VxqbGcnElXn+S+4bgT
	HP++itFhUflYbMrY27ndJZu2nPa9VOT8MXWhtihmcE9O9VmEG5gVquly/QFjzZKleZsHcs9F
	nX3bbL8jfzBeWbBi+5miDZZdLaXAsrUzOXEaPpVYBfOFu6c+N/vWWDP0vFmo6olDR/JdG4sO
	5UlQLxtfKWsdbNSariWjGEfv3YL2Ercj1jPWsD551mvkvhdQ96c5c7guScnUfnZ7fpTy44Wb
	DiXNrPoBfkU7nPe+cDcI58J94+H89oEuFB5Zer8/JgG7E92XezXH5ya9TYm6jy4OGM/wwk+X
	h+Jad7bt0KWYiqvW3xqNT6y4DrbMPrHvmNXqc9mpJUT0d4b9Hc/th3XVFkFJaI6p18XjvEb9
	HxozJSkHBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsVy+t/xu7pH/FzSDNZ+YraYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3F6/kKmgmu8FVtnrWJpYLzN1cXIySEhYCLx
	+8N7xi5GLg4hgaWMEpP/bGGDSMhIbPxylRXCFpb4c62LDaLoI6PEse+LWUASQgJnGCW6f2tA
	JFYySjy8cZsRJMEmoCmx7+QmdpCEiMBtRomnp86AOcwCJ1klDpz+zA5SJSwQLnHwz1RmEFtE
	IEZixb117BC2nsSStU/BdrMIqEq8+v0eLM4rYCnxYfsrZojVlhKXXm0H28YpYCVxd/5XsLsZ
	BWQlHq38BVbPLCAucevJfCaIHwQkluw5zwxhi0q8fPwP6jcdibPXnzBC2AYSW5fuY4GwlSXW
	v2tjgpijJ3Fj6hQ2CFtbYtnC18wQ9whKnJz5hGUCo/QsJOtmIWmZhaRlFpKWBYwsqxhFUkuL
	c9Nziw31ihNzi0vz0vWS83M3MQIT3rZjPzfvYJz36qPeIUYmDsZDjBIczEoivCJpzmlCvCmJ
	lVWpRfnxRaU5qcWHGE2BYTSRWUo0OR+YcvNK4g3NDEwNTcwsDUwtzYyVxHk9CzoShQTSE0tS
	s1NTC1KLYPqYODilGpg2yrb7cwj5fbGbxGB7J6p2gv4kXYPW1xlqJ7769l2PluSbqXrhRdVV
	93UlZ1LU9h15sLGWK3B+tW3vncdNCxbuunfjjscP46fZ2i/4FxgeOG+2bPtseQHBV0Ec0v5K
	bvInslnC9j3IyFzbUC9gkH5zvvgTFvevN+vunJst8NxW3/9Qe9q0Ay0rv+ls+nixePI9h9s3
	H1042bX/HPcUwbbbRiUexxbaMO0NO33shYj661K5T1zCPGV3tSqbdL4btf61t/Jf2rfBP/+4
	juT8nx8yAhmZCiYIbTn4fvvWZuZVidK5zhsiHdZOmjh50hcH0a2pWTsMUj+9S04pXLHJPbD2
	zq6ftQYnjf0Ft0+/fSxNiaU4I9FQi7moOBEAoCBM4wEEAAA=
X-CMS-MailID: 20240515055724eucas1p1c502dbded4dc6ff929c7aff570de80c2
X-Msg-Generator: CA
X-RootMTR: 20240515055724eucas1p1c502dbded4dc6ff929c7aff570de80c2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055724eucas1p1c502dbded4dc6ff929c7aff570de80c2
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055724eucas1p1c502dbded4dc6ff929c7aff570de80c2@eucas1p1.samsung.com>

From: Pankaj Raghav <p.raghav@samsung.com>

When a large folio is alloced, splice will zero out the whole folio even
if only a small part of it is written, and it updates the uptodate flag
of the folio.

Once the per-block uptodate tracking is implemented for tmpfs,
pipe_buf_confirm() only needs to check the range it needs to splice to
be uptodate and not the whole folio as we don't set uptodate flag for
partial writes.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 fs/splice.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 218e24b1ac40..e6ac57795590 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -120,7 +120,9 @@ static int page_cache_pipe_buf_confirm(struct pipe_inod=
e_info *pipe,
 				       struct pipe_buffer *buf)
 {
 	struct folio *folio =3D page_folio(buf->page);
+	const struct address_space_operations *ops;
 	int err;
+	off_t off =3D folio_page_idx(folio, buf->page) * PAGE_SIZE + buf->offset;
=20
 	if (!folio_test_uptodate(folio)) {
 		folio_lock(folio);
@@ -134,12 +136,21 @@ static int page_cache_pipe_buf_confirm(struct pipe_in=
ode_info *pipe,
 			goto error;
 		}
=20
+		ops =3D folio->mapping->a_ops;
 		/*
 		 * Uh oh, read-error from disk.
 		 */
-		if (!folio_test_uptodate(folio)) {
-			err =3D -EIO;
-			goto error;
+		if (!ops->is_partially_uptodate) {
+			if (!folio_test_uptodate(folio)) {
+				err =3D -EIO;
+				goto error;
+			}
+		} else {
+			if (!ops->is_partially_uptodate(folio, off,
+							buf->len)) {
+				err =3D -EIO;
+				goto error;
+			}
 		}
=20
 		/* Folio is ok after all, we are done */
--=20
2.43.0
