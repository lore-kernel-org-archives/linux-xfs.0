Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00B43D552
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752657; cv=none; b=s9oJdWx54pfcAsGgItCcX0piemRaRh/lrbAgjB7NhGzF0Jx0lT9bDvq+BrTTtNztLbfNfAGOYXo9/IBN6Ho0rlScMYFD0jL6Umf897sEZbYTwHbP4fzGpVkcX235iQI+wt6y5FYoSGIVeIG0ybErp10OFhQDxqllPmPo64SnuCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752657; c=relaxed/simple;
	bh=ctPb7XxM+TWxPhd3Fu6+Fa+0hskhZ7PD8nkromhva34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=LuFdUXFO2z/eyQcGVo6oAXNZtTEQUi78rnzlbz64kqsjU4bG3c/67nQNsSxO3C9LjMmzI6oyL9nbHbI/EJ3Rj1EHAln2oVuXmSmzPxGRLRQAIFsGkzhjr0+Uv9l6Ta3aSvSmL/KEBkoFGYu1nr9p7i1qTt47AL8gSyWjukgD1AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kKiv/K/0; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kKiv/K/0"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055734euoutp0278b1c9acf8b08413057fb494843d4bc7~Pk-LLHOWK2018620186euoutp02J
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055734euoutp0278b1c9acf8b08413057fb494843d4bc7~Pk-LLHOWK2018620186euoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752654;
	bh=Yzf34yJLjjOZ5L6S/TOvcg7MvQWva+m/QvkKTJ1hVb4=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=kKiv/K/0A8lf09vqiaIlDRS+gML5VtHlI2Q7RrAPMGRgI+49KSIhBA+ip3dV2J9Fz
	 zsXZ9z/AXfGOPn/puBP6qb4iY8y+Z7Kir1jke0oh1ezzjLcJqzMhbN4drL/MHLvsUl
	 MxraXULuMzNCaydYXN/bliQ0l4wfGqBZmBlUbQZ8=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055733eucas1p2a521a9e0623f0531a8272ecfb655f5b7~Pk-K2bw-B0810008100eucas1p2S;
	Wed, 15 May 2024 05:57:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id FC.BC.09624.DCE44466; Wed, 15
	May 2024 06:57:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055733eucas1p2804d2fb5f5bf7d6adb460054f6e9f4d8~Pk-KcM6iH1245212452eucas1p2C;
	Wed, 15 May 2024 05:57:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055733eusmtrp129539bea3fb8883a5d82c38a09701dcf~Pk-Kbl7An0411404114eusmtrp1B;
	Wed, 15 May 2024 05:57:33 +0000 (GMT)
X-AuditID: cbfec7f2-bfbff70000002598-5c-66444ecd6288
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id FB.F1.09010.DCE44466; Wed, 15
	May 2024 06:57:33 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055733eusmtip1aa61160f14684c57a464d66ecebdd55b~Pk-KOVfKq0235902359eusmtip1T;
	Wed, 15 May 2024 05:57:33 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:32 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:32 +0100
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
Subject: [PATCH 08/12] shmem: clear uptodate blocks after PUNCH_HOLE
Thread-Topic: [PATCH 08/12] shmem: clear uptodate blocks after PUNCH_HOLE
Thread-Index: AQHapozGSURBX17ZzUyZscS7mtN1hQ==
Date: Wed, 15 May 2024 05:57:32 +0000
Message-ID: <20240515055719.32577-9-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djPc7pn/VzSDH6/UbaYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAldHeuJG14Kh6
	xb+jrYwNjB/kuxg5OSQETCRebWtj6WLk4hASWMEoMelDOztIQkjgC6PEtGWGEPZnRomZW7Jg
	Ghp/zmGCaFjOKLF4YgMjhANU9O36HTYI5wyjxIMzJ1khnJWMEjOOv2AB6WcT0JTYd3ITO0hC
	ROA2o8TTU2fAHGaBk6wSfzbvBKsSFnCRuL7rFhuILSLgKfFr4V5WCFtPYvraZWBxFgFVicYn
	7xlBbF4BS4m3i+eB1XAKWEncnf8VrIZRQFbi0cpfYB8xC4hL3HoynwniC0GJRbP3MEPYYhL/
	dj1kg7B1JM5ef8IIYRtIbF26jwXCVpZY/66NCWKOnsSNqVPYIGxtiWULXzND3CAocXLmE3BQ
	Sgjs5JJYdmot1AIXiaaG2VCLhSVeHd/CDmHLSJye3MMygVF7FpL7ZiHZMQvJjllIdixgZFnF
	KJ5aWpybnlpsmJdarlecmFtcmpeul5yfu4kRmCxP/zv+aQfj3Fcf9Q4xMnEwHmKU4GBWEuEV
	SXNOE+JNSaysSi3Kjy8qzUktPsQozcGiJM6rmiKfKiSQnliSmp2aWpBaBJNl4uCUamCyuyT0
	g1erRuSxldT9olc6/CcERZSc254s6bvLJMm5LqF/haLB88tpG2O02pgMVlRt941L/Hb6jyrL
	s2cpuo69/CfNom5PadrxqiMgV2utzi4f2cuzWNOC7l9+ekbhdnTwyYXPEv2lgoVOPRC7u+2A
	Q/2dQ62fu+q21irfi138af7TN37TJ4pxJVWm103VyW7iFlq9zCd9lcwthdgXl1Z+eVm4JNXT
	ouX3l2vhvfvLV5g6OQTqXFdNuLh5d2KB+pulVyZVaysKGb6fYc5T8MbhpecOMetK/dV/oiUE
	v8c3/Phrkye38AXThlk8OxwMghfyzXB/dmOdutHq/X4zf1be7Zy14POuy7Ga8s6f7jEosRRn
	JBpqMRcVJwIAMlm+KwUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t/xu7pn/VzSDF4c4LSYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9HeuJG14Kh6xb+jrYwNjB/kuxg5OSQETCQa
	f85h6mLk4hASWMoosevjaTaIhIzExi9XWSFsYYk/17rYIIo+MkpM3NAM5ZxhlJi18yKUs5JR
	oufFHbB2NgFNiX0nN7GDJEQEbjNKPD11BsxhFjjJKnHg9Gd2kCphAReJ67tugXWICHhK/Fq4
	lxXC1pOYvnYZWJxFQFWi8cl7RhCbV8BS4u3ieWA1QkD2pVfbweKcAlYSd+d/BatnFJCVeLTy
	F9h8ZgFxiVtP5jNBPCEgsWTPeWYIW1Ti5eN/UM/pSJy9/oQRwjaQ2Lp0HwuErSyx/l0bE8Qc
	PYkbU6ewQdjaEssWvmaGuEdQ4uTMJywTGKVnIVk3C0nLLCQts5C0LGBkWcUoklpanJueW2yk
	V5yYW1yal66XnJ+7iRGY8rYd+7llB+PKVx/1DjEycTAeYpTgYFYS4RVJc04T4k1JrKxKLcqP
	LyrNSS0+xGgKDKOJzFKiyfnApJtXEm9oZmBqaGJmaWBqaWasJM7rWdCRKCSQnliSmp2aWpBa
	BNPHxMEp1cCUm9kkv/Tirt2rGp0XzUvlNb3EuObMWwe7L/3l2zNkDhT9i7Ge6PHl5Nz8SGX/
	W3JP1JMbzn861xzFFlnEX6/24eUj3viQ2LcVAoJ9Sa2fLzCq/55VZXmi8fQOfqFvpveKZ3wR
	2DPlDIOvrMyRLJmwuxzaxQujVUsW71eRTXo56ep+pgnGgvsTmp7mNz0JEb6h5i3HMifwxfa7
	a5jWC0z/HPt1o5LU2zfpsnL6T+r6/9+ytve5ofq116RCvE7lm/VTec62wAcpV0+W35fO+Pzz
	1TbD6W+3Hvj+s1H8LkMXS2bTwkBfXjvjv8smra4992eR1P4Srud3cvSlmlfF1UR4Skh3H/vS
	ZbH48P1f0iJKLMUZiYZazEXFiQBTKjItAgQAAA==
X-CMS-MailID: 20240515055733eucas1p2804d2fb5f5bf7d6adb460054f6e9f4d8
X-Msg-Generator: CA
X-RootMTR: 20240515055733eucas1p2804d2fb5f5bf7d6adb460054f6e9f4d8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055733eucas1p2804d2fb5f5bf7d6adb460054f6e9f4d8
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055733eucas1p2804d2fb5f5bf7d6adb460054f6e9f4d8@eucas1p2.samsung.com>

In the fallocate path with PUNCH_HOLE mode flag enabled, clear the
uptodate flag for those blocks covered by the punch. Skip all partial
blocks as they may still contain data.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e06cb6438ef8..d5e6c8eba983 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -209,6 +209,28 @@ static void sfs_set_range_uptodate(struct folio *folio=
,
 	spin_unlock_irqrestore(&sfs->state_lock, flags);
 }
=20
+static void sfs_clear_range_uptodate(struct folio *folio,
+				     struct shmem_folio_state *sfs, size_t off,
+				     size_t len)
+{
+	struct inode *inode =3D folio->mapping->host;
+	unsigned int first_blk, last_blk;
+	unsigned long flags;
+
+	first_blk =3D DIV_ROUND_UP_ULL(off, 1 << inode->i_blkbits);
+	last_blk =3D DIV_ROUND_DOWN_ULL(off + len, 1 << inode->i_blkbits) - 1;
+	if (last_blk =3D=3D UINT_MAX)
+		return;
+
+	if (first_blk > last_blk)
+		return;
+
+	spin_lock_irqsave(&sfs->state_lock, flags);
+	bitmap_clear(sfs->state, first_blk, last_blk - first_blk + 1);
+	folio_clear_uptodate(folio);
+	spin_unlock_irqrestore(&sfs->state_lock, flags);
+}
+
 static struct shmem_folio_state *sfs_alloc(struct inode *inode,
 					   struct folio *folio)
 {
@@ -276,6 +298,19 @@ static void shmem_set_range_uptodate(struct folio *fol=
io, size_t off,
 	else
 		folio_mark_uptodate(folio);
 }
+
+static void shmem_clear_range_uptodate(struct folio *folio, size_t off,
+				     size_t len)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	if (sfs)
+		sfs_clear_range_uptodate(folio, sfs, off, len);
+	else
+		folio_clear_uptodate(folio);
+
+}
+
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -1103,12 +1138,33 @@ static struct folio *shmem_get_partial_folio(struct=
 inode *inode, pgoff_t index)
 	return folio;
 }
=20
+static void shmem_clear(struct folio *folio, loff_t start, loff_t end, int=
 mode)
+{
+	loff_t pos =3D folio_pos(folio);
+	unsigned int offset, length;
+
+	if (!(mode & FALLOC_FL_PUNCH_HOLE) || !(folio_test_large(folio)))
+		return;
+
+	if (pos < start)
+		offset =3D start - pos;
+	else
+		offset =3D 0;
+	length =3D folio_size(folio);
+	if (pos + length <=3D (u64)end)
+		length =3D length - offset;
+	else
+		length =3D end + 1 - pos - offset;
+
+	shmem_clear_range_uptodate(folio, offset, length);
+}
+
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocat=
e.
  */
 static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t le=
nd,
-								 bool unfalloc)
+			     bool unfalloc, int mode)
 {
 	struct address_space *mapping =3D inode->i_mapping;
 	struct shmem_inode_info *info =3D SHMEM_I(inode);
@@ -1166,6 +1222,7 @@ static void shmem_undo_range(struct inode *inode, lof=
f_t lstart, loff_t lend,
 	if (folio) {
 		same_folio =3D lend < folio_pos(folio) + folio_size(folio);
 		folio_mark_dirty(folio);
+		shmem_clear(folio, lstart, lend, mode);
 		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
 			start =3D folio_next_index(folio);
 			if (same_folio)
@@ -1255,9 +1312,17 @@ static void shmem_undo_range(struct inode *inode, lo=
ff_t lstart, loff_t lend,
 	shmem_recalc_inode(inode, 0, -nr_swaps_freed);
 }
=20
+static void shmem_truncate_range_mode(struct inode *inode, loff_t lstart,
+				      loff_t lend, int mode)
+{
+	shmem_undo_range(inode, lstart, lend, false, mode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	inode_inc_iversion(inode);
+}
+
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
-	shmem_undo_range(inode, lstart, lend, false);
+	shmem_undo_range(inode, lstart, lend, false, 0);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	inode_inc_iversion(inode);
 }
@@ -3342,7 +3407,7 @@ static long shmem_fallocate(struct file *file, int mo=
de, loff_t offset,
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
-		shmem_truncate_range(inode, offset, offset + len - 1);
+		shmem_truncate_range_mode(inode, offset, offset + len - 1, mode);
 		/* No need to unmap again: hole-punching leaves COWed pages */
=20
 		spin_lock(&inode->i_lock);
@@ -3408,9 +3473,10 @@ static long shmem_fallocate(struct file *file, int m=
ode, loff_t offset,
 			info->fallocend =3D undo_fallocend;
 			/* Remove the !uptodate folios we added */
 			if (index > start) {
-				shmem_undo_range(inode,
-				    (loff_t)start << PAGE_SHIFT,
-				    ((loff_t)index << PAGE_SHIFT) - 1, true);
+				shmem_undo_range(
+					inode, (loff_t)start << PAGE_SHIFT,
+					((loff_t)index << PAGE_SHIFT) - 1, true,
+					0);
 			}
 			goto undone;
 		}
--=20
2.43.0
