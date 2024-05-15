Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD13BBCE
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715753200; cv=none; b=TzkWr5lhip4/lBWGDshiogDQcRJrrXVI1VFJpSTCavhqw+CFSMsUXRRK61e4t3dsBgxfAKlYb2lwUIxmauwSlGDcWG+66gcb6nJgGlDYGeJB5ZZnxRn9yQwFpOz0+QQSI/9FPSIY4b9LUiYY+jv+7FIdgcQF1BQHoIBnh25w9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715753200; c=relaxed/simple;
	bh=3rCXLWBXfZfMLO9t81QDeCVXjTEwchdPf8WSGMNAQ1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=PFb1eLgVHPPbh/E+k35HgFnTyRWHETEfdpy9+Lnx64mVmZuEUXz2Q+pLN4kyBE2gOVGi/mKm3PD3gomw4NQv2w2XNtXiMFz07dD/+kTis5WayfCObMs1MQH8M7dI1ZyvxN3eS8i6VBaO84I6bWjToFreV8i+8XCFz/+fv7kuV+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=q4A3cBzV; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q4A3cBzV"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055728euoutp014556076a5b69424e9d0284e9722b2e4a~Pk-FlY6qe1504315043euoutp01Z
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240515055728euoutp014556076a5b69424e9d0284e9722b2e4a~Pk-FlY6qe1504315043euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752648;
	bh=seKa6sjLynK9cdKjqPABBz7tIQiUkhLa6rE9aIXSk0U=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=q4A3cBzVn9KE2ydc+PwPCpAz6s/hUrGumb4IqYJW7f4Ed9Y3y7Eg2TL0CNMlxnV+N
	 aV/2w1EHQIxJYkiie0OXg73ruCyKvawmsL0Qa8iNP1M+YkbXf1ybCmfIGNQb360oDW
	 8fRKS8sJ+PtJ9+0mqjKHY9TJhGyK9/GrYMbiDH1M=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240515055727eucas1p1cce4046f8f5533c6eea17fae56ae77c7~Pk-FRrwRp2649226492eucas1p1m;
	Wed, 15 May 2024 05:57:27 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 48.BC.09624.7CE44466; Wed, 15
	May 2024 06:57:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055727eucas1p2413c65b8b227ac0c6007b4600574abd8~Pk-E2YLc31177811778eucas1p2O;
	Wed, 15 May 2024 05:57:27 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055727eusmtrp12a11692dcfa90fab16fe695c42ed0ffa~Pk-E1UwJs0390703907eusmtrp1z;
	Wed, 15 May 2024 05:57:27 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-4f-66444ec7cb92
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id E6.F1.09010.7CE44466; Wed, 15
	May 2024 06:57:27 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055727eusmtip2fc68020aac0eb188bacb160d886bb72a~Pk-EpQJBJ1596015960eusmtip2L;
	Wed, 15 May 2024 05:57:27 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:26 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:26 +0100
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
Subject: [PATCH 03/12] shmem: move folio zero operation to write_begin()
Thread-Topic: [PATCH 03/12] shmem: move folio zero operation to
	write_begin()
Thread-Index: AQHapozDwSlh4G2vDEmdcsveZO13yA==
Date: Wed, 15 May 2024 05:57:25 +0000
Message-ID: <20240515055719.32577-4-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djP87rH/VzSDOZeUrGYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlXHrzD+mgueC
	FZt/LWNsYLzP18XIySEhYCLxYsNC5i5GLg4hgRWMEjPaFrGBJIQEvjBK9J2QhEh8ZpR4N+U0
	M0zH8uYLUEXLGSV+n+KCK5r7azMjhHOGUWLOoh9QzkpGiXtvbrCCtLAJaErsO7mJHSQhInCb
	UeLpqTNgDrPASVaJP5t3soBUCQt4SKz79gKsQ0TAX2LHs1dMELaexJELC8GWswioSkxd9wfs
	KF4BS4kPi/8zgticAlYSd+d/BathFJCVeLTyFzuIzSwgLnHryXwmiCcEJRbN3gP1kJjEv10P
	2SBsHYmz158wQtgGEluX7mOBsJUl1r9rY4KYoydxY+oUNghbW2LZwtdQNwhKnJz5hAXkGQmB
	nVwS92+3QC1zkdjway3UAmGJV8e3sEPYMhKnJ/ewTGDUnoXkvllIdsxCsmMWkh0LGFlWMYqn
	lhbnpqcWG+allusVJ+YWl+al6yXn525iBCbL0/+Of9rBOPfVR71DjEwcjIcYJTiYlUR4RdKc
	04R4UxIrq1KL8uOLSnNSiw8xSnOwKInzqqbIpwoJpCeWpGanphakFsFkmTg4pRqYmCYlvmqf
	2BX/pKslgLO6o3D+ueP/jUIWslu7zrafwJwVIyN3+5Xdwo3MzForZyTs1PqUvzrn0Vr9uTrq
	Xr2zzJScuravuZKjYJPMZtBx8tBRj6ZamfW3pj070K5R93kWB4+AXtIza7WnsY6Pzit5BDG8
	mJxxZfqLKlfPCAmvaUa7Z6+IfXxmW3DNDtUJ3+989vwSbCk//37y2n034uOZHZRqXTZsN8yb
	/ForqPfdnG95fk0v/2Y25m45cJAnsXr1OoVlb84Kd54uOPElTm3PkY/X1bu4Vh67vKPN9dTB
	vTHvi1rao/k7/A0Z7Ot4g92P1AizfOrZfzGmsKBFa/PGlk2H7wS4qS1+W6+ya91eJZbijERD
	Leai4kQA+VA/VwUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t/xe7rH/VzSDF4e4rSYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3HrzD+mgueCFZt/LWNsYLzP18XIySEhYCKx
	vPkCWxcjF4eQwFJGid72uUwQCRmJjV+uskLYwhJ/rnVBFX1klHj1eyIzhHOGUeLPpkZWCGcl
	o8Tpno9sIC1sApoS+05uYgdJiAjcZpR4euoMmMMscJJV4sDpz+wgVcICHhLrvr0AWyIi4Cux
	cstfFghbT+LIhYVgk1gEVCWmrvvDDGLzClhKfFj8nxHEFgKyL73aDmZzClhJ3J3/FayeUUBW
	4tHKX2DzmQXEJW49mQ/1kIDEkj3nmSFsUYmXj/9BPacjcfb6E0YI20Bi69J9LBC2ssT6d21M
	EHP0JG5MncIGYWtLLFv4GuoeQYmTM5+wTGCUnoVk3SwkLbOQtMxC0rKAkWUVo0hqaXFuem6x
	kV5xYm5xaV66XnJ+7iZGYMrbduznlh2MK1991DvEyMTBeIhRgoNZSYRXJM05TYg3JbGyKrUo
	P76oNCe1+BCjKTCMJjJLiSbnA5NuXkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampB
	ahFMHxMHp1QDU7DFr4ynt03ZQ3pmz/l8xSdR4nEwv8OhrRldjYnsFks9VMR7Hk6Tnrt5kuTy
	v/wd/51LljyQmLDNyX6lY+KDpPiq3fx/nc9N8bMP4LitsN2qvfzDPF4RVpWaG1P6tzziVI10
	eyT/R5DzT8oPXdEj0zZwMR14JndEe6Hw+RcbJrqWzWDyu3TJ6MW0Po3MeI/G2mSNC5FuUhtO
	NK7lWZ0nnPnwfkco55RkbUau8OKNkRm9mxfafH8SkX0vYAVX/3TuujN3V0Q+f/n1M//Nizlx
	uw6cqV0sGN8dLJjAMmWxPqdXvAvf77AdzSuVFhn/Tp5xq2JLq1GlQ4iPQvRDnb/VShvXRztM
	Xy48YU+l0b56JZbijERDLeai4kQAdnZNzAIEAAA=
X-CMS-MailID: 20240515055727eucas1p2413c65b8b227ac0c6007b4600574abd8
X-Msg-Generator: CA
X-RootMTR: 20240515055727eucas1p2413c65b8b227ac0c6007b4600574abd8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055727eucas1p2413c65b8b227ac0c6007b4600574abd8
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055727eucas1p2413c65b8b227ac0c6007b4600574abd8@eucas1p2.samsung.com>

Simplify zero out operation by moving it from write_end() to the
write_begin(). If a large folio does not have any block uptodate when we
first get it, zero it out entirely.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4818f9fbd328..86ad539b6a0f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -149,6 +149,14 @@ static inline bool sfs_is_fully_uptodate(struct folio =
*folio)
 	return bitmap_full(sfs->state, i_blocks_per_folio(inode, folio));
 }
=20
+static inline bool sfs_is_any_uptodate(struct folio *folio)
+{
+	struct inode *inode =3D folio->mapping->host;
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	return !bitmap_empty(sfs->state, i_blocks_per_folio(inode, folio));
+}
+
 static inline bool sfs_is_block_uptodate(struct shmem_folio_state *sfs,
 					 unsigned int block)
 {
@@ -239,6 +247,15 @@ static void sfs_free(struct folio *folio, bool force)
 	kfree(folio_detach_private(folio));
 }
=20
+static inline bool shmem_is_any_uptodate(struct folio *folio)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	if (folio_test_large(folio) && sfs)
+		return sfs_is_any_uptodate(folio);
+	return folio_test_uptodate(folio);
+}
+
 static void shmem_set_range_uptodate(struct folio *folio, size_t off,
 				     size_t len)
 {
@@ -2872,6 +2889,9 @@ shmem_write_begin(struct file *file, struct address_s=
pace *mapping,
 	if (ret)
 		return ret;
=20
+	if (!shmem_is_any_uptodate(folio))
+		folio_zero_range(folio, 0, folio_size(folio));
+
 	*pagep =3D folio_file_page(folio, index);
 	if (PageHWPoison(*pagep)) {
 		folio_unlock(folio);
@@ -2894,13 +2914,6 @@ shmem_write_end(struct file *file, struct address_sp=
ace *mapping,
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
=20
-	if (!folio_test_uptodate(folio)) {
-		if (copied < folio_size(folio)) {
-			size_t from =3D offset_in_folio(folio, pos);
-			folio_zero_segments(folio, 0, from,
-					from + copied, folio_size(folio));
-		}
-	}
 	shmem_set_range_uptodate(folio, 0, folio_size(folio));
 	folio_mark_dirty(folio);
 	folio_unlock(folio);
--=20
2.43.0
