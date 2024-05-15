Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE363987D
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752652; cv=none; b=qdeBbOkXvAlC6nlfSEi21/g9557bCiqM/7LbkRc3vVaAaosY4E5C+y5r2LX1WiQ9cZPNu7mZx14iwq2Y40cOtfhl+CHlmC3A5wSHec0fIQEdZr5aznNYZqDE1fJRiof4l1nKOhKXlAO8nMPxqUmj1VkBfvUnOmsUVEh7S919R/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752652; c=relaxed/simple;
	bh=LbHXRH3uynyrF2ZrxbNky16a2MNX8zziwc3x2Ic5eD0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=Y3r9N/9r4gCa4OwIHnPYG0MLmVv5qC/okDtxRIWCtUQk35TmRdZbLxk0TRqDRgUP9ZugLXCMj5TH0OZpEqTcgMdk3GimK++jt8fIOFdDgXxuksypggUKsMyQPv8EcZK1rMwzL5yw9v5jMGvKynHh262kU+nbx8GljLtj3WvKndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sqVMr3yB; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sqVMr3yB"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055727euoutp020522c8bf468b2ea1ee913070250f0557~Pk-E5qDkP1334513345euoutp02N
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055727euoutp020522c8bf468b2ea1ee913070250f0557~Pk-E5qDkP1334513345euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752647;
	bh=6AbpwZVsLVgVT3CkKdkc06GB5sYOIf3QpK6XfswU18c=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=sqVMr3yBGELFFcJQXx0N/7y7+cX9+En6CeWCTEo1+I3rKtkXEW9MQtk9NRR80EnHe
	 DR9jCayKCg+OHmQNrfe7y5HawvCC2YF4IrFRHU3vz3S+vekavEixFiCcrvEz0abgp8
	 g1KQMmmn3s7V4rXYxTgsGJ1/gMkcN3GcVX2Ml/UA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055726eucas1p2328d05eecfcf5f4f66f26a0b452caf86~Pk-EhwvNb1215012150eucas1p2R;
	Wed, 15 May 2024 05:57:26 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id A0.D8.09875.6CE44466; Wed, 15
	May 2024 06:57:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240515055726eucas1p2a795fc743373571bfc3349f9e1ef3f9e~Pk-EEVLoG1154511545eucas1p2I;
	Wed, 15 May 2024 05:57:26 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240515055726eusmtrp1bf43dd20643a60993f5e52ab44b8af56~Pk-EDnfqX0390703907eusmtrp1u;
	Wed, 15 May 2024 05:57:26 +0000 (GMT)
X-AuditID: cbfec7f4-131ff70000002693-d8-66444ec66dea
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 75.F1.09010.6CE44466; Wed, 15
	May 2024 06:57:26 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055726eusmtip1afeac5310d50bc39c07e1816d5c07585~Pk-D02d7J0235902359eusmtip1R;
	Wed, 15 May 2024 05:57:26 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:25 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:25 +0100
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
Subject: [PATCH 02/12] shmem: add per-block uptodate tracking for large
 folios
Thread-Topic: [PATCH 02/12] shmem: add per-block uptodate tracking for large
	folios
Thread-Index: AQHapozCeJW3qmZrtEOp+8upfVo2+A==
Date: Wed, 15 May 2024 05:57:24 +0000
Message-ID: <20240515055719.32577-3-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7rH/FzSDI4161rMWb+GzeL/3mOM
	Fq8Pf2K0uHRUzuJs3282i6/rfzFbXH7CZ/H0Ux+LxezpzUwWl3fNYbO4t+Y/q8WuPzvYLfa9
	3stscWPCU0aLg6c62C1+/wDKbt8V6SDosXPWXXaPBZtKPTav0PLYtKqTzWPTp0nsHidm/Gbx
	2PnQ0mPyjeWMHh+f3mLxeL/vKpvHmQVH2D0+b5IL4InisklJzcksSy3St0vgymhpm8hY0OBS
	0fe9g6mB8aB5FyMnh4SAicT5ef/Zuxi5OIQEVjBKrDz5gA3C+cIocbq/jwnC+cwosXvTfTaY
	ltudhxkhEssZJU5cO8ACV7Xo+B1mCOcMo8TyNUtYIZyVjBILdj1kB+lnE9CU2HdyE9hKEYHb
	jBJPT50Bc5gFTrJK/Nm8E2gYB4ewQIBEzz5DEFNEIFTi6p8gkF4RAT2JFet3MYOEWQRUJa41
	BoKEeQUsJdb2b2UBsTkFrCTuzv8KdiqjgKzEo5W/wNYyC4hL3HoynwniBUGJRbP3MEPYYhL/
	dj2Eek1H4uz1J4wQtoHE1qX7WCBsZYn179qYIOboSdyYOoUNwtaWWLbwNTPEDYISJ2c+AYeE
	hMBBLon/z7azQjS7SEzYtw9qqLDEq+Nb2CFsGYnTk3tYJjBqz0Jy3ywkO2Yh2TELyY4FjCyr
	GMVTS4tz01OLjfJSy/WKE3OLS/PS9ZLzczcxAlPl6X/Hv+xgXP7qo94hRiYOxkOMEhzMSiK8
	ImnOaUK8KYmVValF+fFFpTmpxYcYpTlYlMR5VVPkU4UE0hNLUrNTUwtSi2CyTBycUg1MzG4H
	X9Q05rXOamb4cMgmuv3Rno8y8ce/XbHyOmbNcLTEzn1n5eI4oydFDxofeEzjj3+tmHCjzexc
	HdshvWWNX2ZnsIlfkK10PvV8m5+JzOz+edscPigc9dq6svy7yY3dT3iYbsgm5hjwbdZ9m/dS
	8G/E7VMMZbHb5j1X3VVxqfpWrHbvqfn6Dpl/WwsrflSIz5nRmZrE/NmSKfPsLI+fc1UUDyZL
	/JyyyP6myQ/3GgU+5S0qFU8DtExLd10tfr7v1oEFgUanj2rec2E0W23s433UeebNQqkb+cmf
	UlY/u5P96tTCGVxSUoKR2SHhcraaO7Z+rnzLcs/55YYvdYrHmOOkMg6YM3kc/LlNzeatEktx
	RqKhFnNRcSIAOTw8zQQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t/xu7rH/FzSDP5cELSYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBOlZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
	oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl9HSNpGxoMGlou97B1MD40HzLkZODgkBE4nb
	nYcZQWwhgaWMEpNui0PEZSQ2frnKCmELS/y51sXWxcgFVPORUeLNur8sEM4ZRonZW7YxQzgr
	GSUePWpmBmlhE9CU2HdyEztIQkTgNqPE01NnwBxmgZOsEgdOf2YHqRIW8JOYunsZ2BIRgVCJ
	PXubmSBsPYkV63cBTeLgYBFQlbjWGAgS5hWwlFjbv5UF4lZLiUuvtoPdzSlgJXF3/lc2EJtR
	QFbi0cpfYOOZBcQlbj2ZzwTxg4DEkj3nmSFsUYmXj/9B/aYjcfb6E0YI20Bi69J9LBC2ssT6
	d21MEHP0JG5MncIGYWtLLFv4mhniHkGJkzOfsExglJ6FZN0sJC2zkLTMQtKygJFlFaNIamlx
	bnpusZFecWJucWleul5yfu4mRmC623bs55YdjCtffdQ7xMjEwXiIUYKDWUmEVyTNOU2INyWx
	siq1KD++qDQntfgQoykwiCYyS4km5wMTbl5JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6Yklq
	dmpqQWoRTB8TB6dUA1PwQyvn3HrXnjO/RQR3blKfHnY5+IaEic41pxMJqy9v/rGTa+/iiG9c
	/MuiSjeuCXuRyKHbeLFmx6y3kW5fFz6/qnYuae9npvAVGj6y1rsdNlZ/vT3BxKvmmE7r+XDZ
	C1NtNJV0Fr3a2lU4RegB03o5qzcTBJvnm8YstzP/Ulb/8HyB24tc0wLFfTOstLo/38xX+Oug
	fEb+j7WHHu+ttfJxd3xqL1+yX+xjLfpey/Lgwdrb3B+3uEt+kTwl/+1639X4t0pK0cqvP6Yu
	OsC5vnP6acYl/RbvH0StzF++iE/USPPmbabGQoXky8v3bTARTGiJz2yxX/DKS2aBrXTw2qpo
	bsXgufNu9u7611vvNU2JpTgj0VCLuag4EQBY2qAJAAQAAA==
X-CMS-MailID: 20240515055726eucas1p2a795fc743373571bfc3349f9e1ef3f9e
X-Msg-Generator: CA
X-RootMTR: 20240515055726eucas1p2a795fc743373571bfc3349f9e1ef3f9e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055726eucas1p2a795fc743373571bfc3349f9e1ef3f9e
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055726eucas1p2a795fc743373571bfc3349f9e1ef3f9e@eucas1p2.samsung.com>

Based on iomap per-block dirty and uptodate state track, add support
for shmem_folio_state struct to track the uptodate state per-block for
large folios.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 mm/shmem.c | 195 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 189 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 94ab99b6b574..4818f9fbd328 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -131,6 +131,124 @@ struct shmem_options {
 #define SHMEM_SEEN_QUOTA 32
 };
=20
+/*
+ * Structure allocated for each folio to track per-block uptodate state.
+ *
+ * Like buffered-io iomap_folio_state struct but only for uptodate.
+ */
+struct shmem_folio_state {
+	spinlock_t state_lock;
+	unsigned long state[];
+};
+
+static inline bool sfs_is_fully_uptodate(struct folio *folio)
+{
+	struct inode *inode =3D folio->mapping->host;
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	return bitmap_full(sfs->state, i_blocks_per_folio(inode, folio));
+}
+
+static inline bool sfs_is_block_uptodate(struct shmem_folio_state *sfs,
+					 unsigned int block)
+{
+	return test_bit(block, sfs->state);
+}
+
+/**
+ * sfs_get_last_block_uptodate - find the index of the last uptodate block
+ * within a specified range
+ * @folio: The folio
+ * @first: The starting block of the range to search
+ * @last: The ending block of the range to search
+ *
+ * Returns the index of the last uptodate block within the specified range=
. If
+ * a non uptodate block is found at the start, it returns UINT_MAX.
+ */
+static unsigned int sfs_get_last_block_uptodate(struct folio *folio,
+						unsigned int first,
+						unsigned int last)
+{
+	struct inode *inode =3D folio->mapping->host;
+	struct shmem_folio_state *sfs =3D folio->private;
+	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
+	unsigned int aux =3D find_next_zero_bit(sfs->state, nr_blocks, first);
+
+	/*
+	 * Exceed the range of possible last block and return UINT_MAX if a non
+	 * uptodate block is found at the beginning of the scan.
+	 */
+	if (aux =3D=3D first)
+		return UINT_MAX;
+
+	return min_t(unsigned int, aux - 1, last);
+}
+
+static void sfs_set_range_uptodate(struct folio *folio,
+				   struct shmem_folio_state *sfs, size_t off,
+				   size_t len)
+{
+	struct inode *inode =3D folio->mapping->host;
+	unsigned int first_blk =3D off >> inode->i_blkbits;
+	unsigned int last_blk =3D (off + len - 1) >> inode->i_blkbits;
+	unsigned int nr_blks =3D last_blk - first_blk + 1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sfs->state_lock, flags);
+	bitmap_set(sfs->state, first_blk, nr_blks);
+	if (sfs_is_fully_uptodate(folio))
+		folio_mark_uptodate(folio);
+	spin_unlock_irqrestore(&sfs->state_lock, flags);
+}
+
+static struct shmem_folio_state *sfs_alloc(struct inode *inode,
+					   struct folio *folio)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+	unsigned int nr_blocks =3D i_blocks_per_folio(inode, folio);
+	gfp_t gfp =3D GFP_KERNEL;
+
+	if (sfs || nr_blocks <=3D 1)
+		return sfs;
+
+	/*
+	 * sfs->state tracks uptodate flag when the block size is smaller
+	 * than the folio size.
+	 */
+	sfs =3D kzalloc(struct_size(sfs, state, BITS_TO_LONGS(nr_blocks)), gfp);
+	if (!sfs)
+		return sfs;
+
+	spin_lock_init(&sfs->state_lock);
+	if (folio_test_uptodate(folio))
+		bitmap_set(sfs->state, 0, nr_blocks);
+	folio_attach_private(folio, sfs);
+
+	return sfs;
+}
+
+static void sfs_free(struct folio *folio, bool force)
+{
+	if (!folio_test_private(folio))
+		return;
+
+	if (!force)
+		WARN_ON_ONCE(sfs_is_fully_uptodate(folio) !=3D
+			     folio_test_uptodate(folio));
+
+	kfree(folio_detach_private(folio));
+}
+
+static void shmem_set_range_uptodate(struct folio *folio, size_t off,
+				     size_t len)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+
+	if (sfs)
+		sfs_set_range_uptodate(folio, sfs, off, len);
+	else
+		folio_mark_uptodate(folio);
+}
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -1487,7 +1605,7 @@ static int shmem_writepage(struct page *page, struct =
writeback_control *wbc)
 		}
 		folio_zero_range(folio, 0, folio_size(folio));
 		flush_dcache_folio(folio);
-		folio_mark_uptodate(folio);
+		shmem_set_range_uptodate(folio, 0, folio_size(folio));
 	}
=20
 	swap =3D folio_alloc_swap(folio);
@@ -1769,13 +1887,16 @@ static int shmem_replace_folio(struct folio **folio=
p, gfp_t gfp,
 	if (!new)
 		return -ENOMEM;
=20
+	if (folio_get_private(old))
+		folio_attach_private(new, folio_detach_private(old));
+
 	folio_get(new);
 	folio_copy(new, old);
 	flush_dcache_folio(new);
=20
 	__folio_set_locked(new);
 	__folio_set_swapbacked(new);
-	folio_mark_uptodate(new);
+	shmem_set_range_uptodate(new, 0, folio_size(new));
 	new->swap =3D entry;
 	folio_set_swapcache(new);
=20
@@ -2063,6 +2184,12 @@ static int shmem_get_folio_gfp(struct inode *inode, =
pgoff_t index,
=20
 alloced:
 	alloced =3D true;
+
+	if (!sfs_alloc(inode, folio) && folio_test_large(folio)) {
+		error =3D -ENOMEM;
+		goto unlock;
+	}
+
 	if (folio_test_pmd_mappable(folio) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
 					folio_next_index(folio) - 1) {
@@ -2104,7 +2231,7 @@ static int shmem_get_folio_gfp(struct inode *inode, p=
goff_t index,
 		for (i =3D 0; i < n; i++)
 			clear_highpage(folio_page(folio, i));
 		flush_dcache_folio(folio);
-		folio_mark_uptodate(folio);
+		shmem_set_range_uptodate(folio, 0, folio_size(folio));
 	}
=20
 	/* Perhaps the file has been truncated since we checked */
@@ -2773,8 +2900,8 @@ shmem_write_end(struct file *file, struct address_spa=
ce *mapping,
 			folio_zero_segments(folio, 0, from,
 					from + copied, folio_size(folio));
 		}
-		folio_mark_uptodate(folio);
 	}
+	shmem_set_range_uptodate(folio, 0, folio_size(folio));
 	folio_mark_dirty(folio);
 	folio_unlock(folio);
 	folio_put(folio);
@@ -2782,6 +2909,59 @@ shmem_write_end(struct file *file, struct address_sp=
ace *mapping,
 	return copied;
 }
=20
+static void shmem_invalidate_folio(struct folio *folio, size_t offset,
+				   size_t len)
+{
+	/*
+	 * If we're invalidating the entire folio, clear the dirty state
+	 * from it and release it to avoid unnecessary buildup of the LRU.
+	 */
+	if (offset =3D=3D 0 && len =3D=3D folio_size(folio)) {
+		WARN_ON_ONCE(folio_test_writeback(folio));
+		folio_cancel_dirty(folio);
+		sfs_free(folio, true);
+	}
+}
+
+static bool shmem_release_folio(struct folio *folio, gfp_t gfp_flags)
+{
+	if (folio_test_dirty(folio) && !sfs_is_fully_uptodate(folio))
+		return false;
+
+	sfs_free(folio, false);
+	return true;
+}
+
+/*
+ * shmem_is_partially_uptodate checks whether blocks within a folio are
+ * uptodate or not.
+ *
+ * Returns true if all blocks which correspond to the specified part
+ * of the folio are uptodate.
+ */
+static bool shmem_is_partially_uptodate(struct folio *folio, size_t from,
+					size_t count)
+{
+	struct shmem_folio_state *sfs =3D folio->private;
+	struct inode *inode =3D folio->mapping->host;
+	unsigned int first, last;
+
+	if (!sfs)
+		return false;
+
+	/* Caller's range may extend past the end of this folio */
+	count =3D min(folio_size(folio) - from, count);
+
+	/* First and last blocks in range within folio */
+	first =3D from >> inode->i_blkbits;
+	last =3D (from + count - 1) >> inode->i_blkbits;
+
+	if (sfs_get_last_block_uptodate(folio, first, last) !=3D last)
+		return false;
+
+	return true;
+}
+
 static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *t=
o)
 {
 	struct file *file =3D iocb->ki_filp;
@@ -3533,7 +3713,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, str=
uct inode *dir,
 			goto out_remove_offset;
 		inode->i_op =3D &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
-		folio_mark_uptodate(folio);
+		shmem_set_range_uptodate(folio, 0, folio_size(folio));
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
 		folio_put(folio);
@@ -4523,7 +4703,10 @@ static const struct address_space_operations shmem_a=
ops =3D {
 #ifdef CONFIG_MIGRATION
 	.migrate_folio	=3D migrate_folio,
 #endif
-	.error_remove_folio =3D shmem_error_remove_folio,
+	.error_remove_folio    =3D shmem_error_remove_folio,
+	.invalidate_folio      =3D shmem_invalidate_folio,
+	.release_folio         =3D shmem_release_folio,
+	.is_partially_uptodate =3D shmem_is_partially_uptodate,
 };
=20
 static const struct file_operations shmem_file_operations =3D {
--=20
2.43.0
