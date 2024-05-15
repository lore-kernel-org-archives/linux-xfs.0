Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1BF4EB3C
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715752662; cv=none; b=qHLpDn8WQU/YvbB/na5BDY19memc0ElCJoIn0anPLzvjVeYVKZY0923Uzy2rfi+KsqPffvzbcPiRA1VW9dpp3fs0YC8cE0u2sefcUJ6zRzei9ihFx8+Eicm5V5CupLO/EaFCD7KkSxBE6nvU0YztH8a6H5gKNpx2f6tqqTIZFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715752662; c=relaxed/simple;
	bh=ysNTQu2FZmxm2DeMyyYooKIt081V6zV0r+ddDudM9pQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=Oy+1d1R/h9RwyzqvaVvmYC9pyIMt66B6K/xlD2C8Q7jeB1ZhuQOTF/IngGsta5tbKaBE5WnhC599Lx7QUAnYbRkK12c0mmLwEQrgXJGoyX9u0spts07fC0I3vnDdeJhkyPijZ4gC3VtlxvvHS790abM7B7HiDWlVUj4WyQbqD5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=U9Enp2W+; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U9Enp2W+"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240515055739euoutp0283df8f5c448a2808fb2aeb7fdf6826b7~Pk-P6Xhp11566715667euoutp02A
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 05:57:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240515055739euoutp0283df8f5c448a2808fb2aeb7fdf6826b7~Pk-P6Xhp11566715667euoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715752659;
	bh=YnJglILKqFkdTEiFzR72jsMog/cpgSZTzUSnpJww0Pw=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=U9Enp2W+Lk709O62hv/eifsGkq8F1T0sf+tU1Dy4hamOZKVWmPbcclBPJ+kNHSU0N
	 2O5HlteJ/HiOo9ctcvkG9N5/pZXo9EH7pTbAZAN5SdB+2gXHGu7Yz2xNahommkyvfu
	 uUR15N41Ab7XFV4FDD9ghctG+FI6p7gfoQCz81cI=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240515055738eucas1p2ee046cb2cbd220fc7d567cbe8c42157c~Pk-PmR0te1241412414eucas1p2E;
	Wed, 15 May 2024 05:57:38 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id B3.97.09620.2DE44466; Wed, 15
	May 2024 06:57:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055738eucas1p15335a32c790b731aa5857193bbddf92d~Pk-POZAf12872228722eucas1p1l;
	Wed, 15 May 2024 05:57:38 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240515055738eusmtrp2b09bc45b45a944e66f031ac0931385d5~Pk-PNwuEc0256302563eusmtrp2U;
	Wed, 15 May 2024 05:57:38 +0000 (GMT)
X-AuditID: cbfec7f5-d31ff70000002594-cf-66444ed2cdbd
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id C4.26.08810.2DE44466; Wed, 15
	May 2024 06:57:38 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240515055738eusmtip13dda217c4b57766f5e88e5a9ca71a2c7~Pk-O_ejJe0562305623eusmtip1V;
	Wed, 15 May 2024 05:57:38 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Wed, 15 May 2024 06:57:37 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Wed, 15 May
	2024 06:57:37 +0100
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
Subject: [PATCH 11/12] shmem: add file length arg in shmem_get_folio() path
Thread-Topic: [PATCH 11/12] shmem: add file length arg in shmem_get_folio()
	path
Thread-Index: AQHapozJF6Lbb0RRX0KKO162vQDDlA==
Date: Wed, 15 May 2024 05:57:36 +0000
Message-ID: <20240515055719.32577-12-da.gomez@samsung.com>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7djP87qX/FzSDKbM0raYs34Nm8X/vccY
	LV4f/sRocemonMXZvt9sFl/X/2K2uPyEz+Lppz4Wi9nTm5ksLu+aw2Zxb81/Votdf3awW+x7
	vZfZ4saEp4wWB091sFv8/gGU3b4r0kHQY+esu+weCzaVemxeoeWxaVUnm8emT5PYPU7M+M3i
	sfOhpcfkG8sZPT4+vcXi8X7fVTaPMwuOsHt83iQXwBPFZZOSmpNZllqkb5fAlTH5YQd7QaNH
	xY6POxkbGM9YdjFyckgImEj0nO5nArGFBFYwSvyaodrFyAVkf2GUeNt+jxHC+cwocfDlYUaY
	jnPNn1kgEssZJT7N/M8MV9XxciMThHOGUaLxxy6ozEpGiVO/14H1swloSuw7uYkdJCEicJtR
	4umpM2AOs8BJVok/m3eygFQJC3hLHD+3ixXEFhEIkrh84yRQNweQrSfxcrIsSJhFQFXizZ0z
	zCA2r4CVxIfPX8FaOYHsu/O/soHYjAKyEo9W/mIHsZkFxCVuPZnPBPGEoMSi2XuYIWwxiX+7
	HrJB2DoSZ68/gXrUQGLr0n0sELayxPp3bUwQc/QkbkydwgZha0ssW/ga6gZBiZMzn4ADRkJg
	L5fElvZJUM0uEueOTIUaKizx6vgWdghbRuL/zvlMExi1ZyG5bxaSHbOQ7JiFZMcCRpZVjOKp
	pcW56anFxnmp5XrFibnFpXnpesn5uZsYgcny9L/jX3cwrnj1Ue8QIxMH4yFGCQ5mJRFekTTn
	NCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8qinyqUIC6YklqdmpqQWpRTBZJg5OqQYmacYDHDlq
	ymanV8UdnnfZaqNc7+vHk47LTdW8/VNf1urzx6W/o/fVTzYXWi+zRLYpTVsv3f3c7bpjolsv
	p6wznvTSxrtOI37Zt117IpRLDTRZef6onleod1dwPSr41Js3qDpY+uuvT7czsw1uKn3j0m38
	491x6Pwk1hxXPnWd/20/fe21Lln4HYxc16x5UeBk2vkZH6WKKvhWbjZf1uhnmn3v6at1GSU9
	MtfW2byePN2iY+r7e9rWTclK2bKhu3g9Nd4bp4b9aL7icH2jjo9Ci/y01Wret93vqqiZ20nt
	f7v/7v83F9Urg475MmUYcUUfe37zUK5kRNJ66W2yKxyeLP0okD75Qu/8GRUeX6KUWIozEg21
	mIuKEwHuP7eRBQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t/xu7qX/FzSDFqe81vMWb+GzeL/3mOM
	Fq8Pf2K0uHRUzuJs3282i6/rfzFbXH7CZ/H0Ux+LxezpzUwWl3fNYbO4t+Y/q8WuPzvYLfa9
	3stscWPCU0aLg6c62C1+/wDKbt8V6SDosXPWXXaPBZtKPTav0PLYtKqTzWPTp0nsHidm/Gbx
	2PnQ0mPyjeWMHh+f3mLxeL/vKpvHmQVH2D0+b5IL4InSsynKLy1JVcjILy6xVYo2tDDSM7S0
	0DMysdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5j8sIO9oNGjYsfHnYwNjGcsuxg5OSQETCTO
	NX9m6WLk4hASWMoosWPLazaIhIzExi9XWSFsYYk/17rYIIo+MkqcWfkSquMMo8Sutp/sEM5K
	RomNC2eDtbMJaErsO7kJLCEicJtR4umpM2AOs8BJVokDpz+zg1QJC3hLHD+3C2gJB1BVkMSb
	ZVwQpp7Ey8myIBUsAqoSb+6cYQaxeQWsJD58/soCYgsJWEpcerWdEcTmBIrfnf8VbC+jgKzE
	o5W/wKYzC4hL3HoynwniBQGJJXvOM0PYohIvH/+Dek1H4uz1J4wQtoHE1qX7WCBsZYn179qY
	IOboSdyYOoUNwtaWWLbwNdQ9ghInZz5hmcAoPQvJullIWmYhaZmFpGUBI8sqRpHU0uLc9Nxi
	Q73ixNzi0rx0veT83E2MwHS37djPzTsY5736qHeIkYmD8RCjBAezkgivSJpzmhBvSmJlVWpR
	fnxRaU5q8SFGU2AYTWSWEk3OBybcvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC
	1CKYPiYOTqkGJm3xhav3XuXjOtuTN9NX5kfootTNXQks34OZbrbM/y6zfd+FoM0OE2t2LZdo
	2DlppdhB9oPXZpp1C78vuOOqql2TdkP52CmrOx1HRV1n7+Rc9TVDSkvjqELZ4RPONmueKQb1
	i8ZtPtz/6ufRfxxZHe7N+7JSn1Uc3tqa7m6iEvpYcd4+/dCGtb9iq/g9lhkeWT97/3yHv+yv
	Nk5lLLs1b9KzRTGHd2qdTrqx+oXxvZQf/7ZtP75n4kdvhe99Uwv2LTvZtHryu+uGy+Q/+79+
	+f6s30/b+4rn1OuUHXRE7+oLcrvKf9VkvfuW44EF80UtXfNLPbskZgrZnstMe3VlY86cf99P
	6v26GbnStP9iqguHEktxRqKhFnNRcSIAJzOFFgAEAAA=
X-CMS-MailID: 20240515055738eucas1p15335a32c790b731aa5857193bbddf92d
X-Msg-Generator: CA
X-RootMTR: 20240515055738eucas1p15335a32c790b731aa5857193bbddf92d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055738eucas1p15335a32c790b731aa5857193bbddf92d
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055738eucas1p15335a32c790b731aa5857193bbddf92d@eucas1p1.samsung.com>

In preparation for large folio in the write and fallocate paths, add
file length argument in shmem_get_folio() path to be able to calculate
the folio order based on the file size. Use of order-0 (PAGE_SIZE) for
read, page cache read, and vm fault.

This enables high order folios in the write and fallocate path once the
folio order is calculated based on the length.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 fs/xfs/scrub/xfile.c     |  6 +++---
 fs/xfs/xfs_buf_mem.c     |  3 ++-
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          |  3 ++-
 mm/shmem.c               | 35 ++++++++++++++++++++---------------
 mm/userfaultfd.c         |  2 +-
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 8cdd863db585..4905f5e4cb5d 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -127,7 +127,7 @@ xfile_load(
 		unsigned int	offset;
=20
 		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-				SGP_READ) < 0)
+				SGP_READ, PAGE_SIZE) < 0)
 			break;
 		if (!folio) {
 			/*
@@ -197,7 +197,7 @@ xfile_store(
 		unsigned int	offset;
=20
 		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-				SGP_CACHE) < 0)
+				SGP_CACHE, PAGE_SIZE) < 0)
 			break;
 		if (filemap_check_wb_err(inode->i_mapping, 0)) {
 			folio_unlock(folio);
@@ -268,7 +268,7 @@ xfile_get_folio(
=20
 	pflags =3D memalloc_nofs_save();
 	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
+			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ, PAGE_SIZE);
 	memalloc_nofs_restore(pflags);
 	if (error)
 		return ERR_PTR(error);
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 9bb2d24de709..784c81d35a1f 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -149,7 +149,8 @@ xmbuf_map_page(
 		return -ENOMEM;
 	}
=20
-	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
+	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE,
+				PAGE_SIZE);
 	if (error)
 		return error;
=20
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 3fb18f7eb73e..bc59b4a00228 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -142,7 +142,7 @@ enum sgp_type {
 };
=20
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **fol=
iop,
-		enum sgp_type sgp);
+		enum sgp_type sgp, size_t len);
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 		pgoff_t index, gfp_t gfp);
=20
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 38830174608f..947770ded68c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1863,7 +1863,8 @@ static int collapse_file(struct mm_struct *mm, unsign=
ed long addr,
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index,
-						&folio, SGP_NOALLOC)) {
+						    &folio, SGP_NOALLOC,
+						    PAGE_SIZE)) {
 					result =3D SCAN_FAIL;
 					goto xa_unlocked;
 				}
diff --git a/mm/shmem.c b/mm/shmem.c
index d531018ffece..fcd2c9befe19 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1134,7 +1134,7 @@ static struct folio *shmem_get_partial_folio(struct i=
node *inode, pgoff_t index)
 	 * (although in some cases this is just a waste of time).
 	 */
 	folio =3D NULL;
-	shmem_get_folio(inode, index, &folio, SGP_READ);
+	shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE);
 	return folio;
 }
=20
@@ -1844,7 +1844,7 @@ static struct folio *shmem_alloc_folio(gfp_t gfp, str=
uct shmem_inode_info *info,
=20
 static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
 		struct inode *inode, pgoff_t index,
-		struct mm_struct *fault_mm, bool huge)
+		struct mm_struct *fault_mm, bool huge, size_t len)
 {
 	struct address_space *mapping =3D inode->i_mapping;
 	struct shmem_inode_info *info =3D SHMEM_I(inode);
@@ -2173,7 +2173,7 @@ static int shmem_swapin_folio(struct inode *inode, pg=
off_t index,
  */
 static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-		struct vm_fault *vmf, vm_fault_t *fault_type)
+		struct vm_fault *vmf, vm_fault_t *fault_type, size_t len)
 {
 	struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
 	struct mm_struct *fault_mm;
@@ -2258,7 +2258,7 @@ static int shmem_get_folio_gfp(struct inode *inode, p=
goff_t index,
 		huge_gfp =3D vma_thp_gfp_mask(vma);
 		huge_gfp =3D limit_gfp_mask(huge_gfp, gfp);
 		folio =3D shmem_alloc_and_add_folio(huge_gfp,
-				inode, index, fault_mm, true);
+				inode, index, fault_mm, true, len);
 		if (!IS_ERR(folio)) {
 			count_vm_event(THP_FILE_ALLOC);
 			goto alloced;
@@ -2267,7 +2267,8 @@ static int shmem_get_folio_gfp(struct inode *inode, p=
goff_t index,
 			goto repeat;
 	}
=20
-	folio =3D shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, false);
+	folio =3D shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, false,
+					  len);
 	if (IS_ERR(folio)) {
 		error =3D PTR_ERR(folio);
 		if (error =3D=3D -EEXIST)
@@ -2377,10 +2378,10 @@ static int shmem_get_folio_gfp(struct inode *inode,=
 pgoff_t index,
  * Return: 0 if successful, else a negative error code.
  */
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **fol=
iop,
-		enum sgp_type sgp)
+		enum sgp_type sgp, size_t len)
 {
 	return shmem_get_folio_gfp(inode, index, foliop, sgp,
-			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
+			mapping_gfp_mask(inode->i_mapping), NULL, NULL, len);
 }
 EXPORT_SYMBOL_GPL(shmem_get_folio);
=20
@@ -2475,7 +2476,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
=20
 	WARN_ON_ONCE(vmf->page !=3D NULL);
 	err =3D shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
-				  gfp, vmf, &ret);
+				  gfp, vmf, &ret, PAGE_SIZE);
 	if (err)
 		return vmf_error(err);
 	if (folio) {
@@ -2954,6 +2955,9 @@ shmem_write_begin(struct file *file, struct address_s=
pace *mapping,
 	struct folio *folio;
 	int ret =3D 0;
=20
+	if (!mapping_large_folio_support(mapping))
+		len =3D min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
+
 	/* i_rwsem is held by caller */
 	if (unlikely(info->seals & (F_SEAL_GROW |
 				   F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
@@ -2963,7 +2967,7 @@ shmem_write_begin(struct file *file, struct address_s=
pace *mapping,
 			return -EPERM;
 	}
=20
-	ret =3D shmem_get_folio(inode, index, &folio, SGP_WRITE);
+	ret =3D shmem_get_folio(inode, index, &folio, SGP_WRITE, len);
 	if (ret)
 		return ret;
=20
@@ -3083,7 +3087,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *ioc=
b, struct iov_iter *to)
 				break;
 		}
=20
-		error =3D shmem_get_folio(inode, index, &folio, SGP_READ);
+		error =3D shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE);
 		if (error) {
 			if (error =3D=3D -EINVAL)
 				error =3D 0;
@@ -3260,7 +3264,7 @@ static ssize_t shmem_file_splice_read(struct file *in=
, loff_t *ppos,
 			break;
=20
 		error =3D shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio,
-					SGP_READ);
+					SGP_READ, PAGE_SIZE);
 		if (error) {
 			if (error =3D=3D -EINVAL)
 				error =3D 0;
@@ -3469,7 +3473,8 @@ static long shmem_fallocate(struct file *file, int mo=
de, loff_t offset,
 			error =3D -ENOMEM;
 		else
 			error =3D shmem_get_folio(inode, index, &folio,
-						SGP_FALLOC);
+						SGP_FALLOC,
+						(end - index) << PAGE_SHIFT);
 		if (error) {
 			info->fallocend =3D undo_fallocend;
 			/* Remove the !uptodate folios we added */
@@ -3822,7 +3827,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, str=
uct inode *dir,
 	} else {
 		inode_nohighmem(inode);
 		inode->i_mapping->a_ops =3D &shmem_aops;
-		error =3D shmem_get_folio(inode, 0, &folio, SGP_WRITE);
+		error =3D shmem_get_folio(inode, 0, &folio, SGP_WRITE, PAGE_SIZE);
 		if (error)
 			goto out_remove_offset;
 		inode->i_op =3D &shmem_symlink_inode_operations;
@@ -3868,7 +3873,7 @@ static const char *shmem_get_link(struct dentry *dent=
ry, struct inode *inode,
 			return ERR_PTR(-ECHILD);
 		}
 	} else {
-		error =3D shmem_get_folio(inode, 0, &folio, SGP_READ);
+		error =3D shmem_get_folio(inode, 0, &folio, SGP_READ, PAGE_SIZE);
 		if (error)
 			return ERR_PTR(error);
 		if (!folio)
@@ -5255,7 +5260,7 @@ struct folio *shmem_read_folio_gfp(struct address_spa=
ce *mapping,
 	int error;
=20
 	error =3D shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
-				    gfp, NULL, NULL);
+				    gfp, NULL, NULL, PAGE_SIZE);
 	if (error)
 		return ERR_PTR(error);
=20
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3c3539c573e7..540a0c2d4325 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -359,7 +359,7 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 	struct page *page;
 	int ret;
=20
-	ret =3D shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC);
+	ret =3D shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC, PAGE_SIZE);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
 	if (ret =3D=3D -ENOENT)
 		ret =3D -EFAULT;
--=20
2.43.0
