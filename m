Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049A2385D8B
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 06:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407450; cv=none; b=AhFd/ocnuKxMdeEIcDUlCvnE2COAJ0V12nsHcNp+IiAuQL2bJQTBaljONC4hn1irHNQe6Wmry9dVE5gSX+10IGjLzd5BlWdONXAjdGry3xmwRNB8iHHyzwtSPfZeOZFRhK31G1B46MtnUCDtyFM7e4/1pG5DOBU72vUUkAVOFhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407450; c=relaxed/simple;
	bh=jINND1fOAgu0/lAYAbxHICTbMIrC/3bz2hmq1zVRAZo=;
	h=Message-Id:To:Cc:Subject:From:References:In-Reply-To:Date:
	 Mime-Version:Content-Type; b=uk/thLQVsDk9x3+8Frt2NIA8SuACF6730TW4kxjKfCGvcSR0qBnDKFqLMKFdCmZYned04jKBQaKVHYh1wJcb/+cd1bWzHRRtgC6dKrYefQd7kjlRr4tQR28TGuWCht3x/mmKkcmnRxZK3cfP6SFlOEF3hPHA3QetndloBL67kbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=euAEKKws; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="euAEKKws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783407441; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jINND1fOAgu0/lAYAbxHICTbMIrC/3bz2hmq1zVRAZo=;
 b=euAEKKwsdDLBlei/UoUM1qnyE0RIkmm6E/KkA+YGzEJ6axuh9kO4CP7TpipnWfMIaX8C3y
 sFDVzaWF4bRKrZSstqN6Rp2jVoEkgOLUEHCv5plnWw4oaWOWzqoo8J578nWe8Fm+oukHL6
 9QxB9Q0obiQM/4OGtuu0KX9YVj6SjTb9HcYWtQmzzLIHIuYbCX0dIM3lu0VlswpJQeKv9p
 6lX0ahI2wrKgSLDxxXdrFljWwWA/paoNobc/fPovRhQYzplQd1jpqiugQ+MkgGHFx2yC8w
 9y3oSq9UAf0XDBxfVRulHTVEz6CY+i45wVP2iQrI6tR6AFa4S4yE938Lodm1Aw==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.20f172db.1248.4925.882c.ef1d31b23985@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: "Christoph Hellwig" <hch@infradead.org>, "brauner" <brauner@kernel.org>, 
	"djwong" <djwong@kernel.org>, "ojaswin" <ojaswin@linux.ibm.com>, 
	"dgc" <dgc@kernel.org>, "linux-xfs" <linux-xfs@vger.kernel.org>, 
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>, 
	"linux-ext4" <linux-ext4@vger.kernel.org>, 
	"linux-kernel" <linux-kernel@vger.kernel.org>, 
	<lidiangang@bytedance.com>, "pankaj.raghav" <pankaj.raghav@linux.dev>, 
	"Brian Foster" <bfoster@redhat.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260701033253.46420-1-changfengnan@bytedance.com> <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org> <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org> <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com> <akettUm5gBD8nj56@infradead.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com>
	<CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com>
In-Reply-To: <CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com>
Date: Tue, 07 Jul 2026 14:57:16 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a4ca34f+e826ea+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Tue, Jul 7, 2026, 03:27
> Subject:=C2=A0 Re: [PATCH v6 3/3] iomap: add simple dio path for small di=
rect I/O
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kernel.org>=
, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@=
kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<linux-=
fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-=
kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "pankaj.=
raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> On Mon, Jul 6, 2026 at 4:10=E2=80=AFAM changfengnan <changfengnan@bytedan=
ce.com> wrote:
> >
> > > From: "Christoph Hellwig"<hch@infradead.org>
> > > Date: =C2=A0Fri, Jul 3, 2026, 20:40
> > > Subject: =C2=A0Re: [PATCH v6 3/3] iomap: add simple dio path for smal=
l direct I/O
> > > To: "changfengnan"<changfengnan@bytedance.com>
> > > Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"<hch@i=
nfradead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.org>, =
"ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<linux-=
xfs@vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>, "linu=
x-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kerne=
l.org>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@linux.dev=
>, "Brian Foster"<bfoster@redhat.com>
> > > On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > > > taken, which introduced some overhead.
> > > > I implemented some optimizations based on Christoph=E2=80=99s sugge=
stions and
> > > > made some modifications to `iomap_process`;
> > > > Now, XFS performance is essentially unchanged, while ext4 still sho=
ws a
> > > > 1.5% drop; I will continue to investigate the cause.. =C2=A0 I=E2=
=80=99ve attached the patch.
> > > > Actually, I had expected that switching to `iomap_next` would impro=
ve
> > > > performance, since it avoids an indirect call.
> > >
> > > I don't think it will for you - the direct I/O readers don't have
> > > iomap_end methods, so you still have the same number of indirect
> > > calls. =C2=A0What could help is to inline the iterator as seen in Joa=
nnes'
> > > fist demo series. =C2=A0We could even look into doing that only for s=
imple
> > > dio in a first step, shifting the burden to use the simple method
> > > to the callers (at least for the POC).
> >
> > I'm not sure if this is what you had in mind, but I made some
> > adjustments referencing Joannes' first patch, and using this approach,
> > there was no performance degradation.
>=C2=A0
> Thanks, Fengnan. This is awesome that it got the degradation down to zero=
.
>=C2=A0
> Would you be able to test how this change performs on your benchmarks?:

XFS basically has no performance degradation, while ext4 experiences
a 1-1.5% performance degradation.

Round 1:
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 xfs : 2.04M, 2.05M, 2.04M, 2.04M=
, 2.04M=C2=A0 avg=3D2.042M
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 ext4: 2.12M, 2.12M, 2.12M, 2.12M=
, 2.12M=C2=A0 avg=3D2.120M
=C2=A0=C2=A0=C2=A0 joanne86 xfs : 2.13M, 2.05M, 2.04M, 2.05M, 2.05M=C2=A0 a=
vg=3D2.064M
=C2=A0=C2=A0=C2=A0 joanne86 ext4: 2.11M, 2.11M, 2.11M, 2.11M, 2.11M=C2=A0 a=
vg=3D2.110M

=C2=A0 Round 2:
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 xfs : 2.05M, 2.05M, 2.05M, 2.05M=
, 2.05M=C2=A0 avg=3D2.050M
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 ext4: 2.12M, 2.12M, 2.12M, 2.12M=
, 2.12M=C2=A0 avg=3D2.120M
=C2=A0=C2=A0=C2=A0 joanne86 xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M=C2=A0 a=
vg=3D2.042M
=C2=A0=C2=A0=C2=A0 joanne86 ext4: 2.09M, 2.08M, 2.09M, 2.10M, 2.09M=C2=A0 a=
vg=3D2.090M

=C2=A0 Round 3:
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 xfs : 2.04M, 2.04M, 2.04M, 2.04M=
, 2.05M=C2=A0 avg=3D2.042M
=C2=A0=C2=A0=C2=A0 d67 =C2=A0 =C2=A0=C2=A0 ext4: 2.12M, 2.12M, 2.11M, 2.12M=
, 2.12M=C2=A0 avg=3D2.118M
=C2=A0=C2=A0=C2=A0 joanne86 xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M=C2=A0 a=
vg=3D2.042M
=C2=A0=C2=A0=C2=A0 joanne86 ext4: 2.09M, 2.09M, 2.08M, 2.09M, 2.09M=C2=A0 a=
vg=3D2.088M


>=C2=A0
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index dbe073e181a7..bf0c18cf1017 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -91,7 +91,8 @@ static ssize_t ext4_dio_read_iter(struct kiocb
> *iocb, struct iov_iter *to)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return generic_fi=
le_read_iter(iocb, to);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NU=
LL, 0, NULL, 0);
> + =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NU=
LL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0IOMAP_DIO_NO_IOMAP_END, NULL, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_unlock_shared(inode);
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 file_accessed(iocb->ki_filp);
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index bcd3d4223464..bc3b87e57592 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -968,115 +968,38 @@ static void iomap_dio_simple_end_io(struct bio *bi=
o)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 iocb->ki_complete(iocb, iomap_dio_simple_comp=
lete(sr));
> =C2=A0}
>=C2=A0
> -static inline bool
> -iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0const struct iomap_dio_ops *dops,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0unsigned int dio_flags, size_t done_before)
> +static inline void
> +iomap_dio_simple_finish(struct iomap_iter *iomi, iomap_next_fn iomap_nex=
t,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t written)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file_inode(iocb->ki_filp);
> - =C2=A0 =C2=A0 =C2=A0 size_t count =3D iov_iter_count(iter);
> -
> - =C2=A0 =C2=A0 =C2=A0 if (dops || done_before)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 if (iov_iter_rw(iter) !=3D READ)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 if (!count)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* Simple dio is an optimization for small IO=
. Filter out large IO
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* early as it's the most common case to fail=
 for typical direct IO
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* workloads.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 if (count > inode->i_sb->s_blocksize)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_=
PARTIAL |
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0IOMAP_DIO_BOUNCE))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_pos + count > i_size_read(inode))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> - =C2=A0 =C2=A0 =C2=A0 if (IS_ENCRYPTED(inode))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> -
> - =C2=A0 =C2=A0 =C2=A0 return true;
> + =C2=A0 =C2=A0 =C2=A0 iomi->iter_start_pos =3D iomi->pos;
> + =C2=A0 =C2=A0 =C2=A0 iomi->pos +=3D written;
> + =C2=A0 =C2=A0 =C2=A0 iomi->len -=3D written;
> + =C2=A0 =C2=A0 =C2=A0 iomap_next(iomi, &iomi->iomap, &iomi->srcmap);
> =C2=A0}
>=C2=A0
> -/*
> - * Fast path for small, block-aligned direct I/Os that map to a single
> - * contiguous on-disk extent.
> - *
> - * iomap_dio_simple_supported() enforces the cheap up-front constraints =
before
> - * entering this path.
> - *
> - * @dops must be NULL: a non-NULL @dops means the caller wants its
> - * ->end_io / ->submit_io hooks invoked, and in particular wants its bio=
s to be
> - * allocated from the filesystem-private @dops->bio_set (whose
> front_pad sizes a
> - * filesystem-private wrapper around the bio). =C2=A0The fast path inste=
ad allocates
> - * from the shared iomap_dio_simple_pool, whose front_pad matches struct
> - * iomap_dio_simple; the two wrappers are not interchangeable, so we mus=
t fall
> - * back to __iomap_dio_rw() in that case.
> - *
> - * @done_before must be zero: a non-zero caller-accumulated residual can=
not be
> - * carried through a single-bio inline completion.
> - *
> - * @iter must describe a non-empty READ no larger than the inode block s=
ize:
> - * writes, zero-length I/O, and larger requests need the generic iomap d=
irect
> - * I/O path.
> - *
> - * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, =
or
> - * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial =
direct
> - * I/O, or bouncing. =C2=A0The range must also stay within i_size and en=
crypted
> - * inodes must use the generic iomap direct I/O path.
> - *
> - * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when =
it
> - * decides the request does not fit the fast path. =C2=A0In that case we=
 proceed to
> - * the generic __iomap_dio_rw() slow path. =C2=A0Any other errno is a re=
al
> result and
> - * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach=
 the
> - * caller.
> - */
> -static ssize_t
> -iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_next_fn io=
map_next, void *private,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int dio=
_flags)
> +ssize_t
> +__iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap_iter *iom=
i, iomap_next_fn iomap_next,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_flags=
)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file_inode(iocb->ki_f=
ilp);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t count =3D iov_iter_count(iter);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool wait_for_completion =3D is_sync_kiocb(io=
cb);
> - =C2=A0 =C2=A0 =C2=A0 struct iomap_iter iomi =3D {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .inode =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D inode,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pos =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .len =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D count,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .flags =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .private =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D private,
> - =C2=A0 =C2=A0 =C2=A0 };
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap_dio_simple *sr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int alignment;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct bio *bio;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_flags & IOCB_NOWAIT)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi.flags |=3D IOMAP_=
NOWAIT;
> -
> - =C2=A0 =C2=A0 =C2=A0 ret =3D kiocb_write_and_wait(iocb, count);
> - =C2=A0 =C2=A0 =C2=A0 if (ret)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> -
> - =C2=A0 =C2=A0 =C2=A0 inode_dio_begin(inode);
> -
> - =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_iter(&iomi, iomap_next);
> - =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret ? ret : -EF=
AULT;
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> - =C2=A0 =C2=A0 =C2=A0 if (iomi.iomap.type !=3D IOMAP_MAPPED ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi.iomap.offset + iomi.iomap.lengt=
h < iomi.pos + count ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (iomi.iomap.flags & IOMAP_F_INTEGRIT=
Y)) {
> + =C2=A0 =C2=A0 =C2=A0 if (iomi->iomap.type !=3D IOMAP_MAPPED ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi->iomap.offset + iomi->iomap.len=
gth < iomi->pos + count ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (iomi->iomap.flags & IOMAP_F_INTEGRI=
TY)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -ENOTBLK;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_iomap_en=
d;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 alignment =3D iomap_dio_alignment(inode, iomi.ioma=
p.bdev, dio_flags);
> - =C2=A0 =C2=A0 =C2=A0 if ((iomi.pos | count) & (alignment - 1)) {
> + =C2=A0 =C2=A0 =C2=A0 alignment =3D iomap_dio_alignment(inode, iomi->iom=
ap.bdev, dio_flags);
> + =C2=A0 =C2=A0 =C2=A0 if ((iomi->pos | count) & (alignment - 1)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -EINVAL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_iomap_en=
d;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> @@ -1092,14 +1015,14 @@ iomap_dio_simple(struct kiocb *iocb, struct
> iov_iter *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (user_backed_iter(iter))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_flags |=3D IO=
MAP_DIO_USER_BACKED;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 bio =3D bio_alloc_bioset(iomi.iomap.bdev,
> + =C2=A0 =C2=A0 =C2=A0 bio =3D bio_alloc_bioset(iomi->iomap.bdev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_iov_vecs_to_alloc(iter, BIO_MAX_V=
ECS),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0REQ_OP_READ, GFP_KERNEL, &iomap_dio_s=
imple_pool);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sr =3D container_of(bio, struct iomap_dio_sim=
ple, bio);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sr->iocb =3D iocb;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sr->dio_flags =3D dio_flags;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 bio->bi_iter.bi_sector =3D iomap_sector(&iomi.ioma=
p, iomi.pos);
> + =C2=A0 =C2=A0 =C2=A0 bio->bi_iter.bi_sector =3D iomap_sector(&iomi->iom=
ap, iomi->pos);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio->bi_ioprio =3D iocb->ki_ioprio;
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D bio_iov_iter_get_pages(bio, iter, ali=
gnment - 1);
> @@ -1124,8 +1047,8 @@ iomap_dio_simple(struct kiocb *iocb, struct
> iov_iter *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 WRITE_ONCE(iocb->=
private, bio);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 iomap_iter_advance(&iomi, count);
> - =C2=A0 =C2=A0 =C2=A0 iomap_iter(&iomi, iomap_next);
> + =C2=A0 =C2=A0 =C2=A0 if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_dio_simple_finis=
h(iomi, iomap_next, count);
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!wait_for_completion) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio->bi_end_io =
=3D iomap_dio_simple_end_io;
> @@ -1142,33 +1065,12 @@ iomap_dio_simple(struct kiocb *iocb, struct
> iov_iter *iter,
> =C2=A0out_bio_put:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_put(bio);
> =C2=A0out_iomap_end:
> - =C2=A0 =C2=A0 =C2=A0 iomap_iter(&iomi, iomap_next);
> + =C2=A0 =C2=A0 =C2=A0 if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_dio_simple_finis=
h(iomi, iomap_next, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0}
> -
> -ssize_t
> -iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iomap_ne=
xt, const struct iomap_dio_ops *dops,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_flags=
, void *private, size_t done_before)
> -{
> - =C2=A0 =C2=A0 =C2=A0 struct iomap_dio *dio;
> - =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
> -
> - =C2=A0 =C2=A0 =C2=A0 if (iomap_dio_simple_supported(iocb, iter, dops, d=
io_flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0done_before))=
 {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_simp=
le(iocb, iter, iomap_next,
> private, dio_flags);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D -ENOTBLK)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return ret;
> - =C2=A0 =C2=A0 =C2=A0 }
> -
> - =C2=A0 =C2=A0 =C2=A0 dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dop=
s, dio_flags, private,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0done_before);
> - =C2=A0 =C2=A0 =C2=A0 if (IS_ERR_OR_NULL(dio))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR_OR_ZERO=
(dio);
> - =C2=A0 =C2=A0 =C2=A0 return iomap_dio_complete(dio);
> -}
> -EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +EXPORT_SYMBOL_GPL(__iomap_dio_simple);
>=C2=A0
> =C2=A0static int __init iomap_dio_init(void)
> =C2=A0{
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index 984045af310a..1128f5b526ef 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -89,9 +89,6 @@ int iomap_iter_continue(const struct iomap_iter
> *iter, struct iomap *iomap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool stale =3D iomap->flags & IOMAP_F_STALE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t advanced =3D iter->pos - iter->iter_s=
tart_pos;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 if (!iomap->length)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Use iter->len to determine whether to=
 continue onto the next mapping.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Explicitly terminate on error status =
or if the current iter has not
> diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
> index e1ea8392cf47..e43ca419b13a 100644
> --- a/fs/iomap/trace.h
> +++ b/fs/iomap/trace.h
> @@ -127,7 +127,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_FORCE_WAIT, =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0"DIO_FORCE_WAIT" }, \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_OVERWRITE_ONLY, =C2=A0 =C2=A0 =C2=
=A0"DIO_OVERWRITE_ONLY" }, \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_PARTIAL, =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 "DIO_PARTIAL" }, \
> - =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_FSBLOCK_ALIGNED, =C2=A0 =C2=A0 "DIO_FSB=
LOCK_ALIGNED" }
> + =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_FSBLOCK_ALIGNED, =C2=A0 =C2=A0 "DIO_FSB=
LOCK_ALIGNED" }, \
> + =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_NO_IOMAP_END, =C2=A0 =C2=A0 =C2=A0 =C2=
=A0"DIO_NO_IOMAP_END" }
>=C2=A0
> =C2=A0DECLARE_EVENT_CLASS(iomap_class,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 TP_PROTO(struct inode *inode, struct iomap *i=
omap),
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a987ffbf3c02..6a551efff66f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -251,7 +251,7 @@ xfs_file_dio_read(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iov_iter =C2=A0 =C2=A0 =C2=A0 =C2=A0 *=
to)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct xfs_inode =C2=A0 =C2=A0 =C2=A0 =C2=A0*=
ip =3D XFS_I(file_inode(iocb->ki_filp));
> - =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0dio_flags =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0dio_flags =3D IOMAP_DIO_NO_IOMAP_END;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct iomap_dio_ops *dio_ops =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 ret;
>=C2=A0
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3b41f123a92d..6213a3b1a0b9 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/mm_types.h>
> =C2=A0#include <linux/blkdev.h>
> =C2=A0#include <linux/folio_batch.h>
> +#include <linux/pagemap.h>
>=C2=A0
> =C2=A0struct address_space;
> =C2=A0struct fiemap_extent_info;
> @@ -605,15 +606,136 @@ struct iomap_dio_ops {
> =C2=A0 */
> =C2=A0#define IOMAP_DIO_BOUNCE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 (1 << 4)
>=C2=A0
> -ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iomap_ne=
xt, const struct iomap_dio_ops *dops,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_flags=
, void *private, size_t done_before);
> +/* optimization hint for the simple fast path */
> +#define IOMAP_DIO_NO_IOMAP_END =C2=A0 =C2=A0 =C2=A0 =C2=A0 (1 << 5)
> +
> =C2=A0struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_ite=
r *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iom=
ap_next, const struct iomap_dio_ops *dops,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_=
flags, void *private, size_t done_before);
> =C2=A0ssize_t iomap_dio_complete(struct iomap_dio *dio);
> =C2=A0void iomap_dio_bio_end_io(struct bio *bio);
>=C2=A0
> +static inline bool
> +iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0const struct iomap_dio_ops *dops,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0unsigned int dio_flags, size_t done_before)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file_inode(iocb->ki_filp);
> + =C2=A0 =C2=A0 =C2=A0 size_t count =3D iov_iter_count(iter);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (dops || done_before)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (iov_iter_rw(iter) !=3D READ)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (!count)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (count > inode->i_sb->s_blocksize)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_=
PARTIAL |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0IOMAP_DIO_BOUNCE))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_pos + count > i_size_read(inode))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ENCRYPTED(inode))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
> + =C2=A0 =C2=A0 =C2=A0 return true;
> +}
> +
> +ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap_iter *iom=
i, iomap_next_fn iomap_next,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_flags=
);
> +
> +/*
> + * Fast path for small, block-aligned direct I/Os that map to a single
> + * contiguous on-disk extent.
> + *
> + * iomap_dio_simple_supported() enforces the cheap up-front constraints =
before
> + * entering this path.
> + *
> + * @dops must be NULL: a non-NULL @dops means the caller wants its
> + * ->end_io / ->submit_io hooks invoked, and in particular wants its bio=
s to be
> + * allocated from the filesystem-private @dops->bio_set (whose
> front_pad sizes a
> + * filesystem-private wrapper around the bio). =C2=A0The fast path inste=
ad allocates
> + * from the shared iomap_dio_simple_pool, whose front_pad matches struct
> + * iomap_dio_simple; the two wrappers are not interchangeable, so we mus=
t fall
> + * back to __iomap_dio_rw() in that case.
> + *
> + * @done_before must be zero: a non-zero caller-accumulated residual can=
not be
> + * carried through a single-bio inline completion.
> + *
> + * @iter must describe a non-empty READ no larger than the inode block s=
ize:
> + * writes, zero-length I/O, and larger requests need the generic iomap d=
irect
> + * I/O path.
> + *
> + * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, =
or
> + * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial =
direct
> + * I/O, or bouncing. =C2=A0The range must also stay within i_size and en=
crypted
> + * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP=
_END is
> + * a fast-path optimization the caller can set if there is no work
> that needs to
> + * be done after a mapping.
> + *
> + * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when =
it
> + * decides the request does not fit the fast path. =C2=A0In that case we=
 proceed to
> + * the generic __iomap_dio_rw() slow path. =C2=A0Any other errno is a re=
al
> result and
> + * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach=
 the
> + * caller.
> + */
> +static __always_inline ssize_t
> +iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iomap_ne=
xt, void *private, unsigned int dio_flags)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file_inode(iocb->ki_filp);
> + =C2=A0 =C2=A0 =C2=A0 size_t count =3D iov_iter_count(iter);
> + =C2=A0 =C2=A0 =C2=A0 struct iomap_iter iomi =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .inode =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D inode,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pos =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .len =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D count,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .flags =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .private =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D private,
> + =C2=A0 =C2=A0 =C2=A0 };
> + =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_flags & IOCB_NOWAIT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi.flags |=3D IOMAP_=
NOWAIT;
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D kiocb_write_and_wait(iocb, count);
> + =C2=A0 =C2=A0 =C2=A0 if (ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 inode_dio_begin(inode);
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.srcma=
p);
> + =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* a zero return means=
 no mapping, which should never happen */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret ? ret : -EF=
AULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return __iomap_dio_simple(iocb, iter, &iomi, iomap=
_next, dio_flags);
> +}
> +
> +static __always_inline ssize_t
> +iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, iomap_next_fn
> iomap_next,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct iomap_dio=
_ops *dops, unsigned int dio_flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *private, size_t =
done_before)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct iomap_dio *dio;
> + =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (iomap_dio_simple_supported(iocb, iter, dops, d=
io_flags,
> done_before)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_simp=
le(iocb, iter, iomap_next, private,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D -ENOTBLK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return ret;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dop=
s, dio_flags, private,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0done_before);
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR_OR_NULL(dio))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR_OR_ZERO=
(dio);
> + =C2=A0 =C2=A0 =C2=A0 return iomap_dio_complete(dio);
> +}
> +
> =C2=A0#ifdef CONFIG_SWAP
> =C2=A0struct file;
> =C2=A0struct swap_info_struct;
> @@ -678,21 +800,22 @@ static __always_inline int iomap_process(const
> struct iomap_iter *iter,
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 if (iomap->length && end) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t advanced =3D i=
ter->pos - iter->iter_start_pos;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t len;
> + =C2=A0 =C2=A0 =C2=A0 if (iomap->length) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (end) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ssize_t advanced =3D iter->pos - iter->iter_start_pos;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 loff_t len;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D iomap_length_t=
rim(iter, iter->iter_start_pos,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iter->len + advanced);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 len =3D iomap_length_trim(iter, iter->iter_start_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iter->len + =
advanced);
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D end(iter->inod=
e, iter->iter_start_pos, len, advanced,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iter->flags, iomap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ret =3D end(iter->inode, iter->iter_start_pos,
> len, advanced,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iter->flags,=
 iomap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_iter_con=
tinue(iter, iomap, srcmap, ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_iter_continue(iter, iomap, srcmap, r=
et);
> - =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D begin(iter->inode, iter->pos, iter->l=
en, iter->flags, iomap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 srcmap);
>=C2=A0
> I put the changes in a git tree [1] in case that's is more convenient
> for you. I think this ends up devirtualizing the iomap_next callback:
>=C2=A0
> before:
> $ objdump -dr fs/xfs/xfs.ko | awk '/<xfs_file_dio_read>:/{f=3D1}
> f{print} f&&/^$/{exit}' =C2=A0| grep -E 'iomap_next|iomap_begin|thunk'
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 a9ac3: R_X86_64_PLT32 =C2=A0 __x86_return_thunk-0x4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 a9b4b: R_X86_64_32S =C2=A0 =C2=A0 xfs_read_iomap_next
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 a9b9c: R_X86_64_PLT32 =C2=A0 __x86_return_thunk-0x4
>=C2=A0
> after:
> $ objdump -dr fs/xfs/xfs_iomap_next_inlined.ko | awk
> '/<xfs_file_dio_read>:/{f=3D1} f{print} f&&/^$/{exit}' | grep -E
> 'iomap_next|iomap_begin|thunk'
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 aa083: R_X86_64_PLT32 =C2=A0 __x86_return_thunk-0x4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 aa1d4: R_X86_64_PLT32 =C2=A0 xfs_read_iomap_next-0x4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 aa1ec: R_X86_64_32S =C2=A0 =C2=A0 xfs_read_iomap_next
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 aa232: R_X86_64_32S =C2=A0 =C2=A0 xfs_read_iomap_next
>=C2=A0
>=C2=A0
> I was unsure how much bloat this adds but I didn't see a noticable
> impact when I ran ./scripts/bloat-o-meter:
>=C2=A0
> $ ./scripts/bloat-o-meter fs/xfs/xfs.ko fs/xfs/xfs_iomap_next_inlined.ko
> add/remove: 0/0 grow/shrink: 11/1 up/down: 589/-4 (585)
> Function =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 old =C2=A0 =
=C2=A0 new =C2=A0 delta
> xfs_file_dio_read =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0309 =C2=A0 =C2=A0 685 =C2=A0 =C2=
=A0+376
> xfs_file_dio_write_aligned =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 355 =C2=A0 =C2=A0 402 =C2=A0 =C2=A0 +47
> xfs_file_dio_write_unaligned =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 545 =C2=A0 =C2=A0 591 =C2=A0 =C2=A0 +46
> xfs_file_dio_write_atomic =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0457 =C2=A0 =C2=A0 502 =C2=A0 =C2=A0 +45
> xfs_dax_write_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 267 =C2=A0 =C2=A0 291 =C2=A0 =C2=A0 +24
> xfs_atomic_write_cow_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 1151 =C2=A0 =C2=A01175 =C2=A0 =C2=A0 +24
> xfs_zoned_direct_write_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0217 =C2=A0 =C2=A0 224 =C2=A0 =C2=A0 =C2=A0+7
> xfs_direct_write_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 77 =C2=A0 =C2=A0 =C2=A084 =C2=A0 =C2=A0 =C2=A0+7
> xfs_buffered_write_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0373 =C2=A0 =C2=A0 379 =C2=A0 =C2=A0 =C2=A0+6
> xfs_xattr_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 360 =C2=A0 =C2=A0 365 =C2=A0 =C2=A0 =C2=A0+=
5
> xfs_seek_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0665 =C2=A0 =C2=A0 667 =C2=A0 =C2=A0 =
=C2=A0+2
> xfs_read_iomap_next =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0681 =C2=A0 =C2=A0 677 =C2=A0 =C2=A0 =
=C2=A0-4
> Total: Before=3D1977941, After=3D1978526, chg +0.03%
>=C2=A0
> where the baseline xfs.ko was built at the commit in [2] and the
> xfs_iomap_next_inlined.ko was built at the commit in [3]. =C2=A0If these
> changes are acceptable to you, then I'll put this into v3 of the
> iomap_next series.
>=C2=A0
> Thanks,
> Joanne
>=C2=A0
> [1] https://github.com/joannekoong/linux/commits/iomap_simple_dio_iomap_n=
ext/
> [2] https://github.com/joannekoong/linux/commit/1e82c8988ee56e9e7202d5ee0=
9c7f7ea7ac7a832
> [3] https://github.com/joannekoong/linux/commit/86ecc9de53bb1b8b1287950fb=
b745a5a8e49f736
>=C2=A0
