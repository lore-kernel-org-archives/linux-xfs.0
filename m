Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C6B19B5A3
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 03:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776309402; cv=none; b=jxSwdexrlUPo6AbiU4gLGv5J2ko1giZgeIC3FmC+d9wZ5Y3TNhPxrJv9yuJMecH2jJ51SR+PTa/9lbXAlLdBhy+A+Au+8K+NAOhFYuX7HE90MFqaTHb3roXo1aQCPS/McZfkGbTuNzLcEQjKSVQX/wbsWH0sSmLUrwd+4VYzMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776309402; c=relaxed/simple;
	bh=UX7ckDv0VlBHbW/LbC9WYb59J3AtFFa+/7fccWGzgeM=;
	h=In-Reply-To:References:Cc:From:To:Subject:Mime-Version:
	 Content-Type:Date:Message-Id; b=CfqqxuKq0IopAPEuk0DsZ1R7wN7olqlC0rsuDCD/IiwvTzfnDQ1KdsSSvueGmfSRL23BGspoytGXnTh7vu2lWbEWlVgy1pbZve7Pd3ZZ3fVkFdfg4liZl3zWG6lRawDaRRnNcavFJG7CLhKz8fiQNDtdAlCZsyFu6VeM59pBNvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=TZ+2hDIZ; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="TZ+2hDIZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1776309388; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UX7ckDv0VlBHbW/LbC9WYb59J3AtFFa+/7fccWGzgeM=;
 b=TZ+2hDIZ/0MeTlLoDppi0IGNLxTARNS32nTXGSzXgkCR2UR0no/ix+8DSt4BB1HsCmIC1i
 zVapgYuI+toWiLoa1SCYUzEG3UNmkiBCHmrRuSb+hTy3fmGr0YHxvjVNs8cZPEWXLTXT5g
 xyp34tL3f4qodFhJIAIbl7iskfvWN1XZTd5Q3La2LR/KzFeONDwqNRsSwtAoCrRNSw04yp
 oKCCqbScmjv9RZljwjgwSOmcnWGwh1HJZUkFWIXI62inX3LT/u2PixB5DKzqU6ooEv2DRk
 /gTDmlsSozSG9FX6RIHc1SjkgX+m1QAyVSGgCLST2FqQtgjQn5cU3ObtXpTuHg==
In-Reply-To: <ad867C8dlaQGLS97@infradead.org>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
	<ad867C8dlaQGLS97@infradead.org>
Content-Transfer-Encoding: quoted-printable
Cc: "Fengnan Chang" <fengnanchang@gmail.com>, "brauner" <brauner@kernel.org>, 
	"djwong" <djwong@kernel.org>, "linux-xfs" <linux-xfs@vger.kernel.org>, 
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>, 
	"linux-ext4" <linux-ext4@vger.kernel.org>, <lidiangang@bytedance.com>
From: "changfengnan" <changfengnan@bytedance.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+169e0548b+d36ed1+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Apr 2026 11:16:23 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.eee197c0.e67e.40c8.bd15.8fab5bbb42db@bytedance.com>


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Wed, Apr 15, 2026, 15:15
> Subject:=C2=A0 Re: [RFC PATCH] iomap: add fast read path for small direct=
 I/O
> To: "Fengnan Chang"<fengnanchang@gmail.com>
> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <linux-xfs@vger.kernel.org=
>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <lidianga=
ng@bytedance.com>, "Fengnan Chang"<changfengnan@bytedance.com>
> On Tue, Apr 14, 2026 at 08:26:47PM +0800, Fengnan Chang wrote:
> > 1. Allocating the `bio` and `struct iomap_dio` together to avoid a
> > =C2=A0 =C2=A0separate kmalloc. However, because `struct iomap_dio` is r=
elatively
> > =C2=A0 =C2=A0large and the main path is complex, this yielded almost no
> > =C2=A0 =C2=A0performance improvement.
>=C2=A0
> One interesting bit here would be a slab for struct iomap_dio, and
> the previously discussed per-cpu allocation of some form.
Hi Christoph:
Thank you for your thorough review; it has given me greater confidence
that we are on the right path. This patch still needs a lot of work to be
perfected,=C2=A0 I hope it will be worth it.
Yes, but use a new slab for struct iomap_dio doesn't help.

>=C2=A0
> > 2. Reducing unnecessary state resets in the iomap state machine (e.g.,
> > =C2=A0 =C2=A0skipping `iomap_iter_reset_iomap` where safe). This provid=
ed a ~5%
> > =C2=A0 =C2=A0IOPS boost, which is helpful but still falls far short of =
closing
> > =C2=A0 =C2=A0the gap with the raw block device.
>=C2=A0
> But it already is a major improvement, and one that would apply outside
> of narrow special cases. =C2=A0So I'd really like to see that patch.
You can see this in:
https://lore.kernel.org/linux-fsdevel/20260416030642.26744-1-changfengnan@b=
ytedance.com/T/#u
>=C2=A0
> > The fast path is triggered when the request satisfies:
> > - Asynchronous READ request only for now.
>=C2=A0
> I think you really should handle synchronous reads as well.
I'll include support for it in the next version.
>=C2=A0
> > - I/O size is <=3D inode blocksize (fits in a single block, no splits).
>=C2=A0
> Makes sense, and I suspect this is the main source of speedups.
>=C2=A0
> > - Aligned to the block device's logical block size.
>=C2=A0
> All direct I/O requires this.
>=C2=A0
> > - No bounce buffering, fscrypt, or fsverity involved.
> > - No custom `iomap_dio_ops` (dops) registered by the filesystem.
>=C2=A0
> I'm really curious at what difference this makes. =C2=A0It removes a few
> branches, but should not have much of an effect while limiting the
> applicability a lot.
Yes, the impact shouldn=E2=80=99t be significant.=C2=A0
Since this is just a RFC version to confirm that I=E2=80=99m on the right p=
ath, there
are many aspects that haven=E2=80=99t been fully thought through yet. I hav=
en=E2=80=99t
tested these scenarios yet, but I=E2=80=99ll add support for them later to
check=C2=A0 exactly what the impact is.
>=C2=A0
> > After this optimization, the heavy generic functions disappear from the
> > profile, replaced by a single streamlined execution path:
> > =C2=A0 4.83% =C2=A0[kernel] =C2=A0[k] iomap_dio_fast_read_async.isra.31
> >=C2=A0
> > With this patch, 4K random read IOPS on ext4 increases from 1.9M to
> > 2.3M.
>=C2=A0
> That is still a lot slower than the block device path. =C2=A0A big part o=
f
> it should be the extent lookup and locking associated with it, but
> I'd expect things to be a bit better. =C2=A0Do you have XFS version as we=
ll?
Yes, still a lot slower, I believe the other reason is due to the lookup of
the extent mapping.
XFS and ext4 perform similarly=EF=BC=8C 1.92M IOPS to 2.32M IOPS.=C2=A0

>=C2=A0
> > However, I am submitting this patch to validate whether this
> > optimization direction is correct and worth pursuing. I would appreciat=
e
> > feedback on how to better integrate these ideas into the main iomap
> > execution path.
>=C2=A0
> I think a <=3D block size fast path makes a lot of sense, just like we
> have a simple version on the block device, but it needs more work.
Agree, I came up with this patch after being inspired by the way block
devices are handled.=C2=A0

>=C2=A0
> > +struct iomap_dio_fast_read {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb =C2=A0 =C2=A0 =C2=A0 =C2=A0*i=
ocb;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0size;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0should_dirty;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct work_struct =C2=A0 =C2=A0 =C2=A0 =
=C2=A0work;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =
____cacheline_aligned_in_smp;
>=C2=A0
> Does the cache line alignment matter here? =C2=A0If yes, can you explain =
why
> in a comment?

I copy this from struct blkdev_dio , I'll do some test to verfiy.=C2=A0
>=C2=A0
> > +static struct bio_set iomap_dio_fast_read_pool;
>=C2=A0
> In general I'd prefer to stick to simple as in the block device version
> instead of fast.

Simple is better name.
>=C2=A0
> > +static void iomap_dio_fast_read_complete_work(struct work_struct *work=
)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_fast_read *fr =3D
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(w=
ork, struct iomap_dio_fast_read, work);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb *iocb =3D fr->iocb;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->k=
i_filp);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool should_dirty =3D fr->should_dirty;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio =3D &fr->bio;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(iocb->private, NULL);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!bio->bi_status)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D fr->si=
ze;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_pos +=
=3D ret;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D blk_st=
atus_to_errno(bio->bi_status);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fserror_report=
_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fr->size, ret, GFP_NOFS);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (should_dirty) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_check_page=
s_dirty(bio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_release_pa=
ges(bio, false);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(inode);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_complete(iocb, ret < 0 ? r=
et : 0, ret > 0 ? ret : 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_complete(iocb, ret);
>=C2=A0
> This is a lot of duplicate cork. =C2=A0Can we somehow share it by passing
> more arguments or embedding the simple context into the bigger one?

I'll try. There are still many issues below, which I will address in the ne=
xt version.
>=C2=A0
> > +static inline bool iomap_dio_fast_read_supported(struct kiocb *iocb,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0struct iov_iter *iter,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0unsigned int dio_flags,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0size_t done_before)
>=C2=A0
> Please stick to two-tab indents for prototype continuations, which is
> both more readable and easier to modify later.
Get.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (count < bdev_logical_block_size(inode-=
>i_sb->s_bdev))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
>=C2=A0
> Sub-sector reads (unlike writes) don't require any special handling, so
> I don't see why they are excluded.
Agree, Sub-sector reads can handle too.

>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D =
i_blocksize(inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D =
bdev_logical_block_size(inode->i_sb->s_bdev);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iocb->ki_pos | count) & (alignment - =
1))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
>=C2=A0
> Factor this into a helper?
Get.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_begin(inode);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ops->iomap_begin(inode, iomi.pos, =
count, iomi.flags,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap, &iomi.srcmap);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(=
inode);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=C2=A0
> If we can I'd much prefer avoiding the open coded iomap_begin
> invocation, as that is a real maintenance burden.
It seems we need introduce a new helper to do this.

>=C2=A0
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomi.iomap.type !=3D IOMAP_MAPPED ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.iomap.offset > iomi.pos=
 ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.iomap.offset + iomi.iom=
ap.length < iomi.pos + count ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(iomi.iomap.flags & IOMAP_F_=
ANON_WRITE)) {
>=C2=A0
> IOMAP_F_ANON_WRITE (as the name implies) only applies to writes.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EAGAI=
N;
>=C2=A0
> -EAGAIN is a bad status code, as we already use to indicate that a
> non-blocking read blocks.
Agree.

>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D bio_iov_iter_get_pages(bio, iter,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bdev_logical_block=
_size(iomi.iomap.bdev) - 1);
>=C2=A0
> Overly long line. =C2=A0Also this needs to use the calculated alignment
> value.
Get.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(ret)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap=
_end;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio->bi_iter.bi_size !=3D count) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iov_iter_rever=
t(iter, bio->bi_iter.bi_size);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_release_pa=
ges(bio, false);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EAGAI=
N;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap=
_end;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>=C2=A0
> Share the bio_put with a new goto label, and maybe also move all
> the other cleanup code out of the main path into a label?
Get.
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dops && iomap_dio_fast_read_supported=
(iocb, iter, dio_flags, done_before)) {
>=C2=A0
> Overly long line. =C2=A0But we should not make the fast path conditional
> on an option anyway.
Get.
>=C2=A0
