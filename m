Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBB364942
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 03:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876082; cv=none; b=U7z8JHL3TKC6/0mkYEHNWnBL3JQcquBcmi+QbkNw2BNDxQheARvtSD9OdP37cqALFfQnvtNMD9KuprZa9wQqAIjA/C24YHvFnGethYa6epTQ1hNuIE7KpKfcrN35CvZv5zUcSBvDmY1Xf70ztcPU2sj9ffgIWxe3y9vMIf/V1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876082; c=relaxed/simple;
	bh=wpJbvL4JrvOzZTBw60HtNPTGM903OJ2RaEfQdR3JyoI=;
	h=Date:Message-Id:To:In-Reply-To:Content-Type:Cc:Subject:From:
	 Mime-Version:References; b=byaIA97P1PmxUqByyi6/+yVETFm28rVSTUnoD5+12qpEbUK9J3YDR9i/u0xBMWu0mYIyi1gm2w7GCCkf6nd3S5Dl2tFJBX0IFsyZq2ERmBgSwduDng/amjQZPaInnpzpxEScblRFqf2C0e3Olfa22yD1nn7LKZwgs+l3rG2jVio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=PYXJTQfn; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="PYXJTQfn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782876069; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wpJbvL4JrvOzZTBw60HtNPTGM903OJ2RaEfQdR3JyoI=;
 b=PYXJTQfnyeRVBUv4KR9wQHQfddvmftuVvKn/TFwlMOSNl4vKnEl9isHCFXFURGqnvhN498
 1x0Kjyf6c5wtZ+J5UbNlNoVThzbOrX9q2hbivcKBgLT1unw7swyssDAfae0NbM0RQYyRQ4
 SYjxJHwAKDhyk0EjuTsU63wAr4PpRlGEKOIek5djGm4PdZJARLe/gD2xilpF/JK7BYzUqt
 MdaPzuDLCLrtuGBQwlv28WAzrje4hWSPHQLqcuU0/Jn2CJQ3xh9LTQ3cRtc1NPyJt8c+v3
 hB4S3VuOtLW3JPXv9l1Bltoc3nIY1sy7/zQIEZMsG4tmi7VdJCggBkkOlxL7sQ==
Date: Wed, 01 Jul 2026 11:21:04 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.d073d334.1a3b.4298.a7c5.ebe721e67448@bytedance.com>
To: "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <akOtG5_gNb8btWCx@infradead.org>
X-Lms-Return-Path: <lba+16a4487a3+c1752c+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Subject: Re: [PATCH v5 4/4] iomap: add simple dio path for small direct I/O
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260629120124.25223-1-changfengnan@bytedance.com> <20260629120124.25223-5-changfengnan@bytedance.com>
	<akOtG5_gNb8btWCx@infradead.org>


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Tue, Jun 30, 2026, 19:49
> Subject:=C2=A0 Re: [PATCH v5 4/4] iomap: add simple dio path for small di=
rect I/O
> To: "Fengnan Chang"<changfengnan@bytedance.com>
> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <ojas=
win@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, <linux-f=
sdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-kernel@vger.k=
ernel.org>, <lidiangang@bytedance.com>, <pankaj.raghav@linux.dev>
> On Mon, Jun 29, 2026 at 08:01:24PM +0800, Fengnan Chang wrote:
> > +#include <linux/kobject.h>
> > +#include <linux/sysfs.h>
>=C2=A0
> I don't think these two headers are actually used by the new code.

Debug code, will delete in next version.

>=C2=A0
> > +struct iomap_dio_simple {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0*iocb;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0dio_flags;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct work_struct =C2=A0 =C2=A0 =C2=A0 =
=C2=A0work;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Align @bio to a cacheline boundary so t=
hat, combined with the
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * front_pad passed to bioset_init(), the =
bio sits at the start of
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * a cacheline in memory returned by the (=
HWCACHE-aligned) bio
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * slab. =C2=A0This keeps the hot fields b=
lock layer touches on submit
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * and completion (bi_iter, bi_status, ...=
) within a single line.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =
____cacheline_aligned_in_smp;
>=C2=A0
> Add an extra tab here so it aligns with the fields above the comment?

All comments will fix in next version, thanks.

>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0int error =3D blk_status_to_errno(bio->bi_=
status);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret =3D error;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!ret)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sr->si=
ze;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_pos +=
=3D ret;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (should_report_dio_fserror(ret))=
 {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fserror_report=
_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->size, ret, GFP_NOFS);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_bio_release_pages(bio, sr->dio_f=
lags, ret < 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_complete(iocb, error, ret)=
;
>=C2=A0
> I think some of this could be micro-optimized a bit more and
> cleaned up at the same time:
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(bio->bi_status) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D blk_statu=
s_to_errno(bio->bi_status);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (should_report=
_dio_fserror(ret)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 fserror_report_io(inode, FSERR_DIRECTIO_READ,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iocb->ki=
_pos, sr->size, ret,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_NOFS=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D sr->size;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iocb->ki_pos +=3D=
 ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_dio_bio_release_pages(bio, sr->dio_flag=
s, ret < 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 trace_iomap_dio_complete(iocb, ret < 0 ? ret =
: 0, ret);
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>=C2=A0
> > +
> > +static void iomap_dio_simple_complete_work(struct work_struct *work)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple *sr =3D
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0container_of(work, struct iomap_dio_simple, work);
>=C2=A0
> A single tab indent is enough here. (and used in the next function)
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool wait_for_completion =3D is_sync_kiocb=
(iocb);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
>=C2=A0
> Nitpick: keep variables initialized at declaration time above those
> that are not initalized.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Fast path for small, block-aligned dire=
ct I/Os that map to a
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * single contiguous on-disk extent.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * @dops must be NULL: a non-NULL @dops me=
ans the caller wants its
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * ->end_io / ->submit_io hooks invoked, a=
nd in particular wants its
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * bios to be allocated from the filesyste=
m-private @dops->bio_set
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * (whose front_pad sizes a filesystem-pri=
vate wrapper around the
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * bio). =C2=A0The fast path instead alloc=
ates from the shared
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * iomap_dio_simple_pool, whose front_pad =
matches
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * struct iomap_dio_simple; the two wrappe=
rs are not
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * interchangeable, so we must fall back t=
o __iomap_dio_rw() in
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * that case.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * @done_before must be zero: a non-zero c=
aller-accumulated residual
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * cannot be carried through a single-bio =
inline completion.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * -ENOTBLK is the private sentinel return=
ed by iomap_dio_simple()
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * when it decides the request does not fi=
t the fast path.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * In that case we proceed to the generic =
__iomap_dio_rw() slow
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * path. =C2=A0Any other errno is a real r=
esult and is propagated as-is,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * in particular -EAGAIN for IOCB_NOWAIT m=
ust reach the caller.
>=C2=A0
> I think this documentation belongs above iomap_dio_simple, not
> here. =C2=A0And maye it should also mention that iomap_dio_simple_support=
ed
> enforces these limitations. =C2=A0Mostly anyway, and maybe the other two
> checks should go into that as well for completeness?
>=C2=A0
