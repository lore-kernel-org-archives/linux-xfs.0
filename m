Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354D757E5
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716291526; cv=none; b=LB2bCGcQu6cQOrrpO07OGimgVr4EfAbBmrGs7ZcZ0nflTJCFz/sCjmYpBgLsZHoZTcnWidl32VBOzTJnv3wRg+NcEdxDFNChoflmughiSdZhS/SlXKQK3xi40Hm0qK7lCkNp+dNb0/6MNKIzaP+ninvN4GiZuzvHmnq5tYxFKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716291526; c=relaxed/simple;
	bh=i7RUFQ0OvW6yBTZbgzgjzKGToEQQuJmlSUjkVrhfnds=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=LKaeJUEBe9qdl/830QoK578OVDtZfSKQmSiok3DNaL7I7qZayIBiclRBy4G6hGx0UNRHmD1cyCSdpIXkdbwGIeaTFX7/W40d5VhmcFnU0VsZ9tGr0FNHLwKZmLfz0ahTl0Z+/1VzbSDdlE1AdfBpiwagk5Fb24XSDogi4za0jr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AUrpF+zG; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AUrpF+zG"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240521113836euoutp02667620e2eed1af080f267be6bf2e9676~RfgqJa_-Q3272832728euoutp02C
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 11:38:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240521113836euoutp02667620e2eed1af080f267be6bf2e9676~RfgqJa_-Q3272832728euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716291516;
	bh=/yWTkcNkIb+Uasg8OKBsKRx4DqCw/pjgipTunEEbc20=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=AUrpF+zGo5MCPoD+2+J3cdvWlkKWLRwomGUUsT46bC7auCe3i1r5PCSLmSofjwo81
	 kLP7amK8or+N26QvmVUYwcoB/g1FRBKLAMCFHqVAcmTugJtATY22yxBplZhZLbyrBy
	 paNnWJqReEPTiTMQDj8kPbbqAr5fSnw9/JqVDJhk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240521113836eucas1p198e54d163364d8beda1ff21a127bef87~RfgpttPTc1267012670eucas1p1Q;
	Tue, 21 May 2024 11:38:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id F3.4F.09620.CB78C466; Tue, 21
	May 2024 12:38:36 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240521113835eucas1p101f04327871b69cf06ff40a59366a656~RfgpRSoLI1132011320eucas1p1G;
	Tue, 21 May 2024 11:38:35 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240521113835eusmtrp2faf7a8adf691d03e2126412adf1cd10f~RfgpQMvBL2864328643eusmtrp2Q;
	Tue, 21 May 2024 11:38:35 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-96-664c87bc39c7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 32.BE.08810.BB78C466; Tue, 21
	May 2024 12:38:35 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240521113835eusmtip1ffd007125d034350263b223a37ba8cc5~RfgpA_OZK1617516175eusmtip1h;
	Tue, 21 May 2024 11:38:35 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Tue, 21 May 2024 12:38:34 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Tue, 21 May
	2024 12:38:34 +0100
From: Daniel Gomez <da.gomez@samsung.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "hughd@google.com" <hughd@google.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "willy@infradead.org" <willy@infradead.org>,
	"jack@suse.cz" <jack@suse.cz>, "mcgrof@kernel.org" <mcgrof@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Pankaj Raghav <p.raghav@samsung.com>,
	"dagmcr@gmail.com" <dagmcr@gmail.com>, "yosryahmed@google.com"
	<yosryahmed@google.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "ritesh.list@gmail.com"
	<ritesh.list@gmail.com>, "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"chandan.babu@oracle.com" <chandan.babu@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"brauner@kernel.org" <brauner@kernel.org>
Subject: Re: [PATCH 11/12] shmem: add file length arg in shmem_get_folio()
 path
Thread-Topic: [PATCH 11/12] shmem: add file length arg in shmem_get_folio()
	path
Thread-Index: AQHapozJF6Lbb0RRX0KKO162vQDDlLGbjZ6AgAX7VQA=
Date: Tue, 21 May 2024 11:38:33 +0000
Message-ID: <65qj4iqgdzebrg5cqwaocjzswenzzgoifdnewrhoipieqi3d5v@bxxupemsgsbs>
In-Reply-To: <20240517161741.GY360919@frogsfrogsfrogs>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-ID: <51A92AAB4390BC48AEED40182889A759@scsc.local>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7djPc7p72n3SDBpWsFvMWb+GzeL/3mOM
	Fq8Pf2K0uHRUzuJs3282i6/rfzFbXH7CZ/H0Ux+LxezpzUwWl3fNYbO4t+Y/q8WuPzvYLfa9
	3stscWPCU0aLg6c62C1+/wDKbt8V6SDosXPWXXaPBZtKPTav0PLYtKqTzWPTp0nsHidm/Gbx
	2PnQ0mPyjeWMHh+f3mLxeL/vKpvHmQVH2D0+b5IL4InisklJzcksSy3St0vgynj1oomtYEVq
	xe93y5gbGKf6dDFyckgImEhsPX2WpYuRi0NIYAWjxKnvpxkhnC+MEiv7lzKBVAkJfGaUONei
	1cXIAdbR0hkBUbOcUeLRzi+scDU7F/pCJM4wSqz41M8O4awEan43gwWkik1AU2LfyU3sILYI
	kH3k2zUmkCJmgUtsEgc3nwNLCAsESvxa/Y8NoihI4vKNk4wgq0UErCTebQoGCbMIqEps3PId
	rJxXwFdiets2ZhCbU8BM4tDFNjCbUUBW4tHKX2A1zALiEreezGeC+FlQYtHsPcwQtpjEv10P
	2SBsHYmz158wQtgGEluX7mOBsJUkfn/vZoOYoyOxYPcnKNtSYt3+2VDztSWWLXzNDHGPoMTJ
	mU/AYSohcJJL4v3FWVALXCT6F86FOkJY4tXxLewTGHVmIblvFpIds5DsmIVkxywkOxYwsq5i
	FE8tLc5NTy02zkst1ytOzC0uzUvXS87P3cQITJ+n/x3/uoNxxauPeocYmTgYDzFKcDArifBu
	2uKZJsSbklhZlVqUH19UmpNafIhRmoNFSZxXNUU+VUggPbEkNTs1tSC1CCbLxMEp1cDkfN/t
	58MJ0RH6UzduFZ+td+dx0rlUvQXJP7XvBv7Vv8KrvjI2ZwbT49aolKpsnv9TnTW23Nj/+8ja
	w9+2NIg+DU08t/7BHrGF9yQkc75PeClua8d3zeGOe+ndTbbHTj5ZG66xIn/ZtAzWSh7H/b+P
	L4mvNXyj7CflU1YuemCL4xLTOdPYsk7vkO+JPJzvr6hxjiPDLyGU33tOi3zrwrLjD5c/ylsf
	1fW+8s1pW8+CV7Jv1xXYOFll+UxskzL6lSETd3LmYocvWqLpMz3fB7Fu59BNuMWmF3L407Lu
	Qywlx0/xX2KwMF79I+HvNcmlxtui1O5uLtP0+P7n7c9MnjdXY5h43ZXfHUpccPXZ7KB4JZbi
	jERDLeai4kQAjzrOfg4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e/4Xd3d7T5pBt8b1C3mrF/DZvF/7zFG
	i9eHPzFaXDoqZ3G27zebxdf1v5gtLj/hs3j6qY/FYvb0ZiaLy7vmsFncW/Of1WLXnx3sFvte
	72W2uDHhKaPFwVMd7Ba/fwBlt++KdBD02DnrLrvHgk2lHptXaHlsWtXJ5rHp0yR2jxMzfrN4
	7Hxo6TH5xnJGj49Pb7F4vN93lc3jzIIj7B6fN8kF8ETp2RTll5akKmTkF5fYKkUbWhjpGVpa
	6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZbx60cRWsCK14ve7ZcwNjFN9uhg5OCQETCRa
	OiO6GDk5hASWMkq0zqgFsSUEZCQ2frnKCmELS/y51sXWxcgFVPORUeLS26eMEM4ZRonnp2az
	QDgrGSW+bN4N1sImoCmx7+QmdhBbBMg+8u0aE0gRs8AlNomDm8+BJYQFAiV+rf7HBnKGiECQ
	xJtlXBCmlcS7TcEgFSwCqhIbt3wHq+YV8JWY3raNGWLXK0aJ5c07wBKcAmYShy62MYPYjAKy
	Eo9W/gKLMwuIS9x6Mp8J4gUBiSV7zjND2KISLx//g3pNR+Ls9SeMELaBxNal+1ggbCWJ39+7
	2SDm6Egs2P0JyraUWLd/NtR8bYllC18zQxwnKHFy5hOWCYwys5CsnoWkfRaS9llI2mchaV/A
	yLqKUSS1tDg3PbfYUK84Mbe4NC9dLzk/dxMjMDVuO/Zz8w7Gea8+6h1iZOJgPMQowcGsJMK7
	aYtnmhBvSmJlVWpRfnxRaU5q8SFGU2DgTWSWEk3OBybnvJJ4QzMDU0MTM0sDU0szYyVxXs+C
	jkQhgfTEktTs1NSC1CKYPiYOTqkGptW6BWe8LK+tqbdry/9xlTO1dqvH9Vm1r55YVZ6YsnfK
	NeuNzprNrKcunld+YJjbe9L/mviFTRciVpR/PKLVWsGetGQPTz3v9RBLkw/qbJ8MJrDN4Ql+
	nnhS4auc1NzVF7a1y1ZXTS4NeTp5gw/HX9/tp1uVnm3MXi0QdbzBc9aUTxf5NW/26CTEvNjX
	bBn1nSNH4PaWqAPi/0rObS9NTQ+KEdpy4qJBVJvMjD91aWIHGbUWVd3zdmUFyoQcUJ51el3A
	5Pq7evzHRUVeCF91Obr1m2Xj0/0pmz7PqNtQJtp/udHcUOvyoZMnJ15kY5Z1tl9pxR9m1Lm+
	W0ifX8G6I72VKfTzWqZVjNH7vNyVWIozEg21mIuKEwF/4OiiFgQAAA==
X-CMS-MailID: 20240521113835eucas1p101f04327871b69cf06ff40a59366a656
X-Msg-Generator: CA
X-RootMTR: 20240515055738eucas1p15335a32c790b731aa5857193bbddf92d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240515055738eucas1p15335a32c790b731aa5857193bbddf92d
References: <20240515055719.32577-1-da.gomez@samsung.com>
	<CGME20240515055738eucas1p15335a32c790b731aa5857193bbddf92d@eucas1p1.samsung.com>
	<20240515055719.32577-12-da.gomez@samsung.com>
	<20240517161741.GY360919@frogsfrogsfrogs>

On Fri, May 17, 2024 at 09:17:41AM -0700, Darrick J. Wong wrote:
> On Wed, May 15, 2024 at 05:57:36AM +0000, Daniel Gomez wrote:
> > In preparation for large folio in the write and fallocate paths, add
> > file length argument in shmem_get_folio() path to be able to calculate
> > the folio order based on the file size. Use of order-0 (PAGE_SIZE) for
> > read, page cache read, and vm fault.
> >=20
> > This enables high order folios in the write and fallocate path once the
> > folio order is calculated based on the length.
> >=20
> > Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> > ---
> >  fs/xfs/scrub/xfile.c     |  6 +++---
> >  fs/xfs/xfs_buf_mem.c     |  3 ++-
> >  include/linux/shmem_fs.h |  2 +-
> >  mm/khugepaged.c          |  3 ++-
> >  mm/shmem.c               | 35 ++++++++++++++++++++---------------
> >  mm/userfaultfd.c         |  2 +-
> >  6 files changed, 29 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> > index 8cdd863db585..4905f5e4cb5d 100644
> > --- a/fs/xfs/scrub/xfile.c
> > +++ b/fs/xfs/scrub/xfile.c
> > @@ -127,7 +127,7 @@ xfile_load(
> >  		unsigned int	offset;
> > =20
> >  		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > -				SGP_READ) < 0)
> > +				SGP_READ, PAGE_SIZE) < 0)
>=20
> I suppose I /did/ say during LSFMM that for the current users of xfile.c
> and xfs_buf_mem.c the order of the folio being returned doesn't really
I not sure if I understood you well. Could you please elaborate on this?

> matter, but why wouldn't the last argument here be "roundup_64(count,
> PAGE_SIZE)" ?  Shouldn't we at least hint to the page cache about the
> folio order that we actually want instead of limiting it to order-0?

For v2, I'll include your suggestions. I think we can also enable large fol=
ios
in xfile_get_folio(), please check below:

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 8cdd863db585..df8b495b4939 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -127,7 +127,7 @@ xfile_load(
                unsigned int    offset;

                if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-                               SGP_READ) < 0)
+                               SGP_READ, roundup_64(count, PAGE_SIZE)) < 0=
)
                        break;
                if (!folio) {
                        /*
@@ -197,7 +197,7 @@ xfile_store(
                unsigned int    offset;

                if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-                               SGP_CACHE) < 0)
+                               SGP_CACHE, roundup_64(count, PAGE_SIZE)) < =
0)
                        break;
                if (filemap_check_wb_err(inode->i_mapping, 0)) {
                        folio_unlock(folio);
@@ -268,7 +268,8 @@ xfile_get_folio(

        pflags =3D memalloc_nofs_save();
        error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
-                       (flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
+                       (flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ,
+                       roundup_64(i_size_read(inode), PAGE_SIZE));
        memalloc_nofs_restore(pflags);
        if (error)
                return ERR_PTR(error);

>=20
> (Also it seems a little odd to me that the @index is in units of pgoff_t
> but @len is in bytes.)

I extended the shmem_get_folio() with @len to calculate folio order based o=
n
size (bytes). This is sent to ilog2() although I'm planning to use get_orde=
r()
instead (after fixing the issues mentioned during the discussion). @index i=
s
used for __ffs() (same as in filemap).

Would you use lofft for @len instead? Or what's your suggestion?

Thanks,
Daniel

>=20
> >  			break;
> >  		if (!folio) {
> >  			/*
> > @@ -197,7 +197,7 @@ xfile_store(
> >  		unsigned int	offset;
> > =20
> >  		if (shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > -				SGP_CACHE) < 0)
> > +				SGP_CACHE, PAGE_SIZE) < 0)
> >  			break;
> >  		if (filemap_check_wb_err(inode->i_mapping, 0)) {
> >  			folio_unlock(folio);
> > @@ -268,7 +268,7 @@ xfile_get_folio(
> > =20
> >  	pflags =3D memalloc_nofs_save();
> >  	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > -			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
> > +			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ, PAGE_SIZE);
> >  	memalloc_nofs_restore(pflags);
> >  	if (error)
> >  		return ERR_PTR(error);
> > diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> > index 9bb2d24de709..784c81d35a1f 100644
> > --- a/fs/xfs/xfs_buf_mem.c
> > +++ b/fs/xfs/xfs_buf_mem.c
> > @@ -149,7 +149,8 @@ xmbuf_map_page(
> >  		return -ENOMEM;
> >  	}
> > =20
> > -	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE=
);
> > +	error =3D shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE=
,
> > +				PAGE_SIZE);
>=20
> This is ok unless someone wants to use a different XMBUF_BLOCKSIZE.
>=20
> --D
>=20
> >  	if (error)
> >  		return error;
> > =20
> > diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> > index 3fb18f7eb73e..bc59b4a00228 100644
> > --- a/include/linux/shmem_fs.h
> > +++ b/include/linux/shmem_fs.h
> > @@ -142,7 +142,7 @@ enum sgp_type {
> >  };
> > =20
> >  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio *=
*foliop,
> > -		enum sgp_type sgp);
> > +		enum sgp_type sgp, size_t len);
> >  struct folio *shmem_read_folio_gfp(struct address_space *mapping,
> >  		pgoff_t index, gfp_t gfp);
> > =20
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 38830174608f..947770ded68c 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1863,7 +1863,8 @@ static int collapse_file(struct mm_struct *mm, un=
signed long addr,
> >  				xas_unlock_irq(&xas);
> >  				/* swap in or instantiate fallocated page */
> >  				if (shmem_get_folio(mapping->host, index,
> > -						&folio, SGP_NOALLOC)) {
> > +						    &folio, SGP_NOALLOC,
> > +						    PAGE_SIZE)) {
> >  					result =3D SCAN_FAIL;
> >  					goto xa_unlocked;
> >  				}
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index d531018ffece..fcd2c9befe19 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1134,7 +1134,7 @@ static struct folio *shmem_get_partial_folio(stru=
ct inode *inode, pgoff_t index)
> >  	 * (although in some cases this is just a waste of time).
> >  	 */
> >  	folio =3D NULL;
> > -	shmem_get_folio(inode, index, &folio, SGP_READ);
> > +	shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE);
> >  	return folio;
> >  }
> > =20
> > @@ -1844,7 +1844,7 @@ static struct folio *shmem_alloc_folio(gfp_t gfp,=
 struct shmem_inode_info *info,
> > =20
> >  static struct folio *shmem_alloc_and_add_folio(gfp_t gfp,
> >  		struct inode *inode, pgoff_t index,
> > -		struct mm_struct *fault_mm, bool huge)
> > +		struct mm_struct *fault_mm, bool huge, size_t len)
> >  {
> >  	struct address_space *mapping =3D inode->i_mapping;
> >  	struct shmem_inode_info *info =3D SHMEM_I(inode);
> > @@ -2173,7 +2173,7 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >   */
> >  static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >  		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
> > -		struct vm_fault *vmf, vm_fault_t *fault_type)
> > +		struct vm_fault *vmf, vm_fault_t *fault_type, size_t len)
> >  {
> >  	struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
> >  	struct mm_struct *fault_mm;
> > @@ -2258,7 +2258,7 @@ static int shmem_get_folio_gfp(struct inode *inod=
e, pgoff_t index,
> >  		huge_gfp =3D vma_thp_gfp_mask(vma);
> >  		huge_gfp =3D limit_gfp_mask(huge_gfp, gfp);
> >  		folio =3D shmem_alloc_and_add_folio(huge_gfp,
> > -				inode, index, fault_mm, true);
> > +				inode, index, fault_mm, true, len);
> >  		if (!IS_ERR(folio)) {
> >  			count_vm_event(THP_FILE_ALLOC);
> >  			goto alloced;
> > @@ -2267,7 +2267,8 @@ static int shmem_get_folio_gfp(struct inode *inod=
e, pgoff_t index,
> >  			goto repeat;
> >  	}
> > =20
> > -	folio =3D shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, fals=
e);
> > +	folio =3D shmem_alloc_and_add_folio(gfp, inode, index, fault_mm, fals=
e,
> > +					  len);
> >  	if (IS_ERR(folio)) {
> >  		error =3D PTR_ERR(folio);
> >  		if (error =3D=3D -EEXIST)
> > @@ -2377,10 +2378,10 @@ static int shmem_get_folio_gfp(struct inode *in=
ode, pgoff_t index,
> >   * Return: 0 if successful, else a negative error code.
> >   */
> >  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio *=
*foliop,
> > -		enum sgp_type sgp)
> > +		enum sgp_type sgp, size_t len)
> >  {
> >  	return shmem_get_folio_gfp(inode, index, foliop, sgp,
> > -			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
> > +			mapping_gfp_mask(inode->i_mapping), NULL, NULL, len);
> >  }
> >  EXPORT_SYMBOL_GPL(shmem_get_folio);
> > =20
> > @@ -2475,7 +2476,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vm=
f)
> > =20
> >  	WARN_ON_ONCE(vmf->page !=3D NULL);
> >  	err =3D shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
> > -				  gfp, vmf, &ret);
> > +				  gfp, vmf, &ret, PAGE_SIZE);
> >  	if (err)
> >  		return vmf_error(err);
> >  	if (folio) {
> > @@ -2954,6 +2955,9 @@ shmem_write_begin(struct file *file, struct addre=
ss_space *mapping,
> >  	struct folio *folio;
> >  	int ret =3D 0;
> > =20
> > +	if (!mapping_large_folio_support(mapping))
> > +		len =3D min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
> > +
> >  	/* i_rwsem is held by caller */
> >  	if (unlikely(info->seals & (F_SEAL_GROW |
> >  				   F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
> > @@ -2963,7 +2967,7 @@ shmem_write_begin(struct file *file, struct addre=
ss_space *mapping,
> >  			return -EPERM;
> >  	}
> > =20
> > -	ret =3D shmem_get_folio(inode, index, &folio, SGP_WRITE);
> > +	ret =3D shmem_get_folio(inode, index, &folio, SGP_WRITE, len);
> >  	if (ret)
> >  		return ret;
> > =20
> > @@ -3083,7 +3087,7 @@ static ssize_t shmem_file_read_iter(struct kiocb =
*iocb, struct iov_iter *to)
> >  				break;
> >  		}
> > =20
> > -		error =3D shmem_get_folio(inode, index, &folio, SGP_READ);
> > +		error =3D shmem_get_folio(inode, index, &folio, SGP_READ, PAGE_SIZE)=
;
> >  		if (error) {
> >  			if (error =3D=3D -EINVAL)
> >  				error =3D 0;
> > @@ -3260,7 +3264,7 @@ static ssize_t shmem_file_splice_read(struct file=
 *in, loff_t *ppos,
> >  			break;
> > =20
> >  		error =3D shmem_get_folio(inode, *ppos / PAGE_SIZE, &folio,
> > -					SGP_READ);
> > +					SGP_READ, PAGE_SIZE);
> >  		if (error) {
> >  			if (error =3D=3D -EINVAL)
> >  				error =3D 0;
> > @@ -3469,7 +3473,8 @@ static long shmem_fallocate(struct file *file, in=
t mode, loff_t offset,
> >  			error =3D -ENOMEM;
> >  		else
> >  			error =3D shmem_get_folio(inode, index, &folio,
> > -						SGP_FALLOC);
> > +						SGP_FALLOC,
> > +						(end - index) << PAGE_SHIFT);
> >  		if (error) {
> >  			info->fallocend =3D undo_fallocend;
> >  			/* Remove the !uptodate folios we added */
> > @@ -3822,7 +3827,7 @@ static int shmem_symlink(struct mnt_idmap *idmap,=
 struct inode *dir,
> >  	} else {
> >  		inode_nohighmem(inode);
> >  		inode->i_mapping->a_ops =3D &shmem_aops;
> > -		error =3D shmem_get_folio(inode, 0, &folio, SGP_WRITE);
> > +		error =3D shmem_get_folio(inode, 0, &folio, SGP_WRITE, PAGE_SIZE);
> >  		if (error)
> >  			goto out_remove_offset;
> >  		inode->i_op =3D &shmem_symlink_inode_operations;
> > @@ -3868,7 +3873,7 @@ static const char *shmem_get_link(struct dentry *=
dentry, struct inode *inode,
> >  			return ERR_PTR(-ECHILD);
> >  		}
> >  	} else {
> > -		error =3D shmem_get_folio(inode, 0, &folio, SGP_READ);
> > +		error =3D shmem_get_folio(inode, 0, &folio, SGP_READ, PAGE_SIZE);
> >  		if (error)
> >  			return ERR_PTR(error);
> >  		if (!folio)
> > @@ -5255,7 +5260,7 @@ struct folio *shmem_read_folio_gfp(struct address=
_space *mapping,
> >  	int error;
> > =20
> >  	error =3D shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
> > -				    gfp, NULL, NULL);
> > +				    gfp, NULL, NULL, PAGE_SIZE);
> >  	if (error)
> >  		return ERR_PTR(error);
> > =20
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 3c3539c573e7..540a0c2d4325 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -359,7 +359,7 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd=
,
> >  	struct page *page;
> >  	int ret;
> > =20
> > -	ret =3D shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC);
> > +	ret =3D shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC, PAGE_SIZE)=
;
> >  	/* Our caller expects us to return -EFAULT if we failed to find folio=
 */
> >  	if (ret =3D=3D -ENOENT)
> >  		ret =3D -EFAULT;
> > --=20
> > 2.43.0
> > =
