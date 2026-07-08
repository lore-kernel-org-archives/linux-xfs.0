Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88A34028E8
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 08:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783500157; cv=none; b=V1HeptwiX8mGrJeo8i76VAfo/4JCs2OzNZTiK/+wlcX1GJoNWNkYtsaJ7CFOmDCaLnaBdTFit76oZ6fOJ2D1YUzeUIPQLkPY9j2uus8VmAC/Ct+xBk+vfRXRyQAn5IYxhC7fEYcknUABRGVIbMB6nLSsac95OrqOdSbWc0LrdZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783500157; c=relaxed/simple;
	bh=klCRkZ3Jm/Z7K0OU9wfUJyWt0kV1An8nNeN9cR4DT6Y=;
	h=Message-Id:To:Cc:From:Mime-Version:References:Content-Type:Date:
	 In-Reply-To:Subject; b=bdQ3fkusj4E6vsTSwLo1Sc8aj8bDWr7z/8gBDtuXcOA4VDm5J4RoX0EXFdAkCTrBN/UxMmDgnakz1RTBFpyjExNYPgyarhD3q4VqhSey23q8kaOrsRa9wV9uvo8laB6dkoTFHB/pZ+gt95iuqyQZc4cMB/3SkN4DnaHUWGnIw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=A/6NjTTR; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="A/6NjTTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783500147; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=klCRkZ3Jm/Z7K0OU9wfUJyWt0kV1An8nNeN9cR4DT6Y=;
 b=A/6NjTTRbi8phgJLRfYcuJe72Y+qBpQViY1pMtdUgQXvt76nVbQ03eIxBiclEGGbid2TXD
 jX3DCaBfdShQhZuw1Oe7qmz/WsS3quL+mx2ClWCCV1gG+wEQt3ElttlNxfIuj3Ibq4nPwS
 2ogrkJpIQpBqlHS8b3KsiMJfBXv1hvhPDPxAh5ik/Z7oB2tyLCXNgZFk7qtqHlC9PYZQDq
 OTboClbgbdJuO6m0emAiuubQUrTMKcKgAloWIx45YqrZxTQOe370hlNt8n02+mfxYvGW3y
 P844cKranmHSyscpo91Nj6e/KRgRs7e/MAJvSWO/N/DzIlfP/CLkvAHZcXwf/Q==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.415a9a6d.e936.40be.8db9.f087f85da92f@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: "Christoph Hellwig" <hch@infradead.org>, "brauner" <brauner@kernel.org>, 
	"djwong" <djwong@kernel.org>, "ojaswin" <ojaswin@linux.ibm.com>, 
	"dgc" <dgc@kernel.org>, "linux-xfs" <linux-xfs@vger.kernel.org>, 
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>, 
	"linux-ext4" <linux-ext4@vger.kernel.org>, 
	"linux-kernel" <linux-kernel@vger.kernel.org>, 
	<lidiangang@bytedance.com>, "pankaj.raghav" <pankaj.raghav@linux.dev>, 
	"Brian Foster" <bfoster@redhat.com>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com> <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org> <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org> <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com> <akettUm5gBD8nj56@infradead.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com> <CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.20f172db.1248.4925.882c.ef1d31b23985@bytedance.com>
	<CAJnrk1aPS3Z_N+6Fto_B=Sgo6Wt62Cr6XHEwa-KzqjtQWyJ4Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 16:42:22 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJnrk1aPS3Z_N+6Fto_B=Sgo6Wt62Cr6XHEwa-KzqjtQWyJ4Vg@mail.gmail.com>
X-Lms-Return-Path: <lba+16a4e0d71+36cf9d+vger.kernel.org+changfengnan@bytedance.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Wed, Jul 8, 2026, 10:07
> Subject:=C2=A0 Re: [PATCH v6 3/3] iomap: add simple dio path for small di=
rect I/O
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kernel.org>=
, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@=
kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<linux-=
fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-=
kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "pankaj.=
raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> On Mon, Jul 6, 2026 at 11:57=E2=80=AFPM changfengnan <changfengnan@byteda=
nce.com> wrote:
> >
> >
> > > From: "Joanne Koong"<joannelkoong@gmail.com>
> > > Date: =C2=A0Tue, Jul 7, 2026, 03:27
> > > Subject: =C2=A0Re: [PATCH v6 3/3] iomap: add simple dio path for smal=
l direct I/O
> > > To: "changfengnan"<changfengnan@bytedance.com>
> > > Cc: "Christoph Hellwig"<hch@infradead.org>, "brauner"<brauner@kernel.=
org>, "djwong"<djwong@kernel.org>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<=
dgc@kernel.org>, "linux-xfs"<linux-xfs@vger.kernel.org>, "linux-fsdevel"<li=
nux-fsdevel@vger.kernel.org>, "linux-ext4"<linux-ext4@vger.kernel.org>, "li=
nux-kernel"<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, "pan=
kaj.raghav"<pankaj.raghav@linux.dev>, "Brian Foster"<bfoster@redhat.com>
> > > On Mon, Jul 6, 2026 at 4:10=E2=80=AFAM changfengnan <changfengnan@byt=
edance.com> wrote:
> > > >
> > > > > From: "Christoph Hellwig"<hch@infradead.org>
> > > > > Date: =C2=A0Fri, Jul 3, 2026, 20:40
> > > > > Subject: =C2=A0Re: [PATCH v6 3/3] iomap: add simple dio path for =
small direct I/O
> > > > > To: "changfengnan"<changfengnan@bytedance.com>
> > > > > Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"<h=
ch@infradead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.or=
g>, "ojaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<li=
nux-xfs@vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>, "=
linux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.k=
ernel.org>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@linux=
.dev>, "Brian Foster"<bfoster@redhat.com>
> > > > > On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > > > > > taken, which introduced some overhead.
> > > > > > I implemented some optimizations based on Christoph=E2=80=99s s=
uggestions and
> > > > > > made some modifications to `iomap_process`;
> > > > > > Now, XFS performance is essentially unchanged, while ext4 still=
 shows a
> > > > > > 1.5% drop; I will continue to investigate the cause.. =C2=A0 I=
=E2=80=99ve attached the patch.
> > > > > > Actually, I had expected that switching to `iomap_next` would i=
mprove
> > > > > > performance, since it avoids an indirect call.
> > > > >
> > > > > I don't think it will for you - the direct I/O readers don't have
> > > > > iomap_end methods, so you still have the same number of indirect
> > > > > calls. =C2=A0What could help is to inline the iterator as seen in=
 Joannes'
> > > > > fist demo series. =C2=A0We could even look into doing that only f=
or simple
> > > > > dio in a first step, shifting the burden to use the simple method
> > > > > to the callers (at least for the POC).
> > > >
> > > > I'm not sure if this is what you had in mind, but I made some
> > > > adjustments referencing Joannes' first patch, and using this approa=
ch,
> > > > there was no performance degradation.
> > >
> > > Thanks, Fengnan. This is awesome that it got the degradation down to =
zero.
> > >
> > > Would you be able to test how this change performs on your benchmarks=
?:
> >
> > XFS basically has no performance degradation, while ext4 experiences
> > a 1-1.5% performance degradation.
> >
> > Round 1:
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0xfs : 2.04M, 2.05M, 2.04M, 2.04M,=
 2.04M =C2=A0avg=3D2.042M
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0ext4: 2.12M, 2.12M, 2.12M, 2.12M,=
 2.12M =C2=A0avg=3D2.120M
> > =C2=A0 =C2=A0 joanne86 xfs : 2.13M, 2.05M, 2.04M, 2.05M, 2.05M =C2=A0av=
g=3D2.064M
> > =C2=A0 =C2=A0 joanne86 ext4: 2.11M, 2.11M, 2.11M, 2.11M, 2.11M =C2=A0av=
g=3D2.110M
> >
> > =C2=A0 Round 2:
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0xfs : 2.05M, 2.05M, 2.05M, 2.05M,=
 2.05M =C2=A0avg=3D2.050M
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0ext4: 2.12M, 2.12M, 2.12M, 2.12M,=
 2.12M =C2=A0avg=3D2.120M
> > =C2=A0 =C2=A0 joanne86 xfs : 2.04M, 2.04M, 2.04M, 2.04M, 2.05M =C2=A0av=
g=3D2.042M
> > =C2=A0 =C2=A0 joanne86 ext4: 2.09M, 2.08M, 2.09M, 2.10M, 2.09M =C2=A0av=
g=3D2.090M
> >
> > =C2=A0 Round 3:
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0xfs : 2.04M, 2.04M, 2.04M, 2.04M,=
 2.05M =C2=A0avg=3D2.042M
> > =C2=A0 =C2=A0 d67 =C2=A0 =C2=A0 =C2=A0ext4: 2.12M, 2.12M, 2.11M, 2.12M,=
 2.12M =C2=A0avg=3D2.118M
> > =C2=A0 =C2=A0 joanne86 xfs : 2.04M, 2.05M, 2.04M, 2.04M, 2.04M =C2=A0av=
g=3D2.042M
> > =C2=A0 =C2=A0 joanne86 ext4: 2.09M, 2.09M, 2.08M, 2.09M, 2.09M =C2=A0av=
g=3D2.088M
> >
>=C2=A0
> Thanks. I'm not sure why it makes ext4 worse. Maybe it being inlined
> bloats it too much so it leads to more frontend stalls/icache misses
> than what the devirtualization helps with? Looking at the begin
> functions, ext4's is around 2.5x larger than xfs's. It also looks like
> ext4's read_iomap_begin function has 2 callers, so I think that may
> not get automatically inlined whereas xfs's will since
> xfs_read_iomap_begin just has 1 caller, though I don't know if that
> ends up mattering.

I ran two rounds of tests using your patch, and ext4 still showed a 1.5%
performance drop.
However, I think your analysis is correct=E2=80=94it=E2=80=99s likely cause=
d by too many
inline functions.=C2=A0 Inlining the simple DIO wrappers expands the filesy=
stem
read_iter hot path and increases frontend/register pressure. Keeping the
wrappers out of line adds only a cheap direct call, while preserving a smal=
ler
and better laid-out filesystem hot path.
So I made some changes, reverting `iomap_dio_rw()` and `iomap_dio_simple()`
to non-inline versions, and performance returned to normal.

Patch based on https://github.com/joannekoong/linux/commits/iomap_simple_di=
o_iomap_next_ext4/=C2=A0
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bc3b87e57592a..d0f7ef8ac140a 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -968,6 +968,33 @@ static void iomap_dio_simple_end_io(struct bio *bio)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 iocb->ki_complete(iocb, iomap_dio_simple_=
complete(sr));
=C2=A0}
=C2=A0
+static bool iomap_dio_simple_supported(struct kiocb *iocb,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iov_iter=
 *iter,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct io=
map_dio_ops *dops,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int di=
o_flags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t done_bef=
ore)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 struct inode *inode =3D file_inode(iocb->ki_fi=
lp);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 size_t count =3D iov_iter_count(iter);
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (dops || done_before)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iov_iter_rw(iter) !=3D READ)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!count)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (count > inode->i_sb->s_blocksize)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_=
DIO_PARTIAL |
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 IOMAP_DIO_BOUNCE))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iocb->ki_pos + count > i_size_read(inode))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (IS_ENCRYPTED(inode))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return true;
+}
+
=C2=A0static inline void
=C2=A0iomap_dio_simple_finish(struct iomap_iter *iomi, iomap_next_fn iomap_=
next,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t writte=
n)
@@ -978,7 +1005,7 @@ iomap_dio_simple_finish(struct iomap_iter *iomi, iomap=
_next_fn iomap_next,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next(iomi, &iomi->iomap, &iomi->src=
map);
=C2=A0}
=C2=A0
-ssize_t
+static ssize_t
=C2=A0__iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap_=
iter *iomi, iomap_next_fn iomap_next,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int =
dio_flags)
@@ -1070,7 +1097,97 @@ __iomap_dio_simple(struct kiocb *iocb, struct iov_it=
er *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
=C2=A0}
-EXPORT_SYMBOL_GPL(__iomap_dio_simple);
+
+/*
+ * Fast path for small, block-aligned direct I/Os that map to a single
+ * contiguous on-disk extent.
+ *
+ * iomap_dio_simple_supported() enforces the cheap up-front constraints be=
fore
+ * entering this path.
+ *
+ * @dops must be NULL: a non-NULL @dops means the caller wants its
+ * ->end_io / ->submit_io hooks invoked, and in particular wants its bios =
to be
+ * allocated from the filesystem-private @dops->bio_set (whose front_pad s=
izes a
+ * filesystem-private wrapper around the bio).=C2=A0 The fast path instead=
 allocates
+ * from the shared iomap_dio_simple_pool, whose front_pad matches struct
+ * iomap_dio_simple; the two wrappers are not interchangeable, so we must =
fall
+ * back to __iomap_dio_rw() in that case.
+ *
+ * @done_before must be zero: a non-zero caller-accumulated residual canno=
t be
+ * carried through a single-bio inline completion.
+ *
+ * @iter must describe a non-empty READ no larger than the inode block siz=
e:
+ * writes, zero-length I/O, and larger requests need the generic iomap dir=
ect
+ * I/O path.
+ *
+ * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, or
+ * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial di=
rect
+ * I/O, or bouncing.=C2=A0 The range must also stay within i_size and encr=
ypted
+ * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP_E=
ND is
+ * a fast-path optimization the caller can set if there is no work that ne=
eds to
+ * be done after a mapping.
+ *
+ * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
+ * decides the request does not fit the fast path.=C2=A0 In that case we p=
roceed to
+ * the generic __iomap_dio_rw() slow path.=C2=A0 Any other errno is a real=
 result and
+ * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach t=
he
+ * caller.
+ */
+static ssize_t iomap_dio_simple(struct kiocb *iocb,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iov_iter *iter, iomap_next_fn =
iomap_next,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 void *private, unsigned int dio_flags=
)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 struct inode *inode =3D file_inode(iocb->ki_fi=
lp);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 size_t count =3D iov_iter_count(iter);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_iter iomi =3D {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .inode =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D inode,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .pos =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D iocb->ki_pos,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .len =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D count,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .flags =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D IOMAP_DIRECT,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .private =C2=A0 =
=C2=A0 =C2=A0=C2=A0 =3D private,
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 };
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ssize_t ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iocb->ki_flags & IOCB_NOWAIT)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 iomi.flags |=3D IO=
MAP_NOWAIT;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D kiocb_write_and_wait(iocb, count);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 inode_dio_begin(inode);
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.s=
rcmap);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret <=3D 0) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 inode_dio_end(inod=
e);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 /* a zero return m=
eans no mapping, which should never happen */
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret ? ret :=
 -EFAULT;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return __iomap_dio_simple(iocb, iter, &iomi, i=
omap_next, dio_flags);
+}
+
+ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iom=
ap_next_fn iomap_next, const struct iomap_dio_ops *dops,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uns=
igned int dio_flags, void *private, size_t done_before)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_dio *dio;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ssize_t ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iomap_dio_simple_supported(iocb, iter, dop=
s, dio_flags, done_before)) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple(iocb, iter, iomap_next, private,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_flags);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret !=3D -ENOT=
BLK)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 return ret;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 dio =3D __iomap_dio_rw(iocb, iter, iomap_next,=
 dops, dio_flags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 private, done_before);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (IS_ERR_OR_NULL(dio))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return PTR_ERR_OR_=
ZERO(dio);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return iomap_dio_complete(dio);
+}
+EXPORT_SYMBOL_GPL(iomap_dio_rw);
=C2=A0
=C2=A0static int __init iomap_dio_init(void)
=C2=A0{
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6213a3b1a0b93..d6028722c54b2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -615,126 +615,9 @@ struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, =
struct iov_iter *iter,
=C2=A0ssize_t iomap_dio_complete(struct iomap_dio *dio);
=C2=A0void iomap_dio_bio_end_io(struct bio *bio);
=C2=A0
-static inline bool
-iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 const struct iomap_dio_ops *dops,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 unsigned int dio_flags, size_t done_before)
-{
- =C2=A0 =C2=A0 =C2=A0=C2=A0 struct inode *inode =3D file_inode(iocb->ki_fi=
lp);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 size_t count =3D iov_iter_count(iter);
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (dops || done_before)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iov_iter_rw(iter) !=3D READ)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!count)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (count > inode->i_sb->s_blocksize)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_=
DIO_PARTIAL |
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 IOMAP_DIO_BOUNCE))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iocb->ki_pos + count > i_size_read(inode))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (IS_ENCRYPTED(inode))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return false;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 return true;
-}
-
-ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_iter =
*iomi, iomap_next_fn iomap_next,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 unsigned int dio_f=
lags);
-
-/*
- * Fast path for small, block-aligned direct I/Os that map to a single
- * contiguous on-disk extent.
- *
- * iomap_dio_simple_supported() enforces the cheap up-front constraints be=
fore
- * entering this path.
- *
- * @dops must be NULL: a non-NULL @dops means the caller wants its
- * ->end_io / ->submit_io hooks invoked, and in particular wants its bios =
to be
- * allocated from the filesystem-private @dops->bio_set (whose front_pad s=
izes a
- * filesystem-private wrapper around the bio).=C2=A0 The fast path instead=
 allocates
- * from the shared iomap_dio_simple_pool, whose front_pad matches struct
- * iomap_dio_simple; the two wrappers are not interchangeable, so we must =
fall
- * back to __iomap_dio_rw() in that case.
- *
- * @done_before must be zero: a non-zero caller-accumulated residual canno=
t be
- * carried through a single-bio inline completion.
- *
- * @iter must describe a non-empty READ no larger than the inode block siz=
e:
- * writes, zero-length I/O, and larger requests need the generic iomap dir=
ect
- * I/O path.
- *
- * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, or
- * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial di=
rect
- * I/O, or bouncing.=C2=A0 The range must also stay within i_size and encr=
ypted
- * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP_E=
ND is
- * a fast-path optimization the caller can set if there is no work that ne=
eds to
- * be done after a mapping.
- *
- * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
- * decides the request does not fit the fast path.=C2=A0 In that case we p=
roceed to
- * the generic __iomap_dio_rw() slow path.=C2=A0 Any other errno is a real=
 result and
- * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach t=
he
- * caller.
- */
-static __always_inline ssize_t
-iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_next_fn ioma=
p_next, void *private, unsigned int dio_flags)
-{
- =C2=A0 =C2=A0 =C2=A0=C2=A0 struct inode *inode =3D file_inode(iocb->ki_fi=
lp);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 size_t count =3D iov_iter_count(iter);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_iter iomi =3D {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .inode =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D inode,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .pos =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D iocb->ki_pos,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .len =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D count,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .flags =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =3D IOMAP_DIRECT,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 .private =C2=A0 =
=C2=A0 =C2=A0=C2=A0 =3D private,
- =C2=A0 =C2=A0 =C2=A0=C2=A0 };
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ssize_t ret;
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iocb->ki_flags & IOCB_NOWAIT)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 iomi.flags |=3D IO=
MAP_NOWAIT;
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D kiocb_write_and_wait(iocb, count);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret;
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 inode_dio_begin(inode);
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.s=
rcmap);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret <=3D 0) {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 inode_dio_end(inod=
e);
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 /* a zero return m=
eans no mapping, which should never happen */
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret ? ret :=
 -EFAULT;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 }
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 return __iomap_dio_simple(iocb, iter, &iomi, i=
omap_next, dio_flags);
-}
-
-static __always_inline ssize_t
-iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, iomap_next_fn ioma=
p_next,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 const struct iomap=
_dio_ops *dops, unsigned int dio_flags,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 void *private, siz=
e_t done_before)
-{
- =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_dio *dio;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ssize_t ret;
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iomap_dio_simple_supported(iocb, iter, dop=
s, dio_flags, done_before)) {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple(iocb, iter, iomap_next, private,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 dio_flags);
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret !=3D -ENOT=
BLK)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 return ret;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 }
-
- =C2=A0 =C2=A0 =C2=A0=C2=A0 dio =3D __iomap_dio_rw(iocb, iter, iomap_next,=
 dops, dio_flags, private,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 done_before);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (IS_ERR_OR_NULL(dio))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return PTR_ERR_OR_=
ZERO(dio);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 return iomap_dio_complete(dio);
-}
+ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iom=
ap_next_fn iomap_next, const struct iomap_dio_ops *dops,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uns=
igned int dio_flags, void *private, size_t done_before);
=C2=A0
=C2=A0#ifdef CONFIG_SWAP
=C2=A0struct file;
--=C2=A0

>=C2=A0
> I'm seeing that ext4_iomap_begin is ~1570 bytes vs.
> xfs_read_iomap_begin is ~635 bytes. It looks like though
> ext4_iomap_begin is a combined read + write begin, whereas xfs's is a
> dedicated read-only begin. If we separate ext4_iomap_begin into
> dedicated read vs write begins, then I think this gets
> ext4_read_iomap_begin down to ~230 bytes.
>=C2=A0
> Would you be able to test if this improves the ext4 performance you're se=
eing?:
>=C2=A0
> change #1: separate out ext4_iomap_begin into ext4_read/write_iomap_begin
>=C2=A0
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4c30dd8dbec7..54cdecbc7539 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3771,8 +3771,46 @@ static int ext4_iomap_alloc(struct inode
> *inode, struct ext4_map_blocks *map,
> =C2=A0}
>=C2=A0
>=C2=A0
> -static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t l=
ength,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned flags, struct=
 iomap *iomap, struct iomap *srcmap)
> +static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t length, unsigne=
d int flags, struct iomap *iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *srcmap)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> + =C2=A0 =C2=A0 =C2=A0 struct ext4_map_blocks map;
> + =C2=A0 =C2=A0 =C2=A0 u8 blkbits =3D inode->i_blkbits;
> +
> + =C2=A0 =C2=A0 =C2=A0 if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ERANGE;
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Calculate the first and last logical block=
s respectively.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 map.m_lblk =3D offset >> blkbits;
> + =C2=A0 =C2=A0 =C2=A0 map.m_len =3D min_t(loff_t, (offset + length - 1) =
>> blkbits,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> + =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* When inline encryption is enabled, sometim=
es I/O to an encrypted file
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* has to be broken up to guarantee DUN conti=
guity. =C2=A0Handle this by
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* limiting the length of the mapping returne=
d.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 map.m_len =3D fscrypt_limit_io_blocks(inode, map.m=
_lblk, map.m_len);
> +
> + =C2=A0 =C2=A0 =C2=A0 ext4_set_iomap(inode, iomap, &map, offset, length,=
 flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static int ext4_write_iomap_begin(struct inode *inode, loff_t offset,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t length, unsigne=
d int flags, struct iomap *iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *srcmap)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ext4_map_blocks map;
> @@ -3793,37 +3831,33 @@ static int ext4_iomap_begin(struct inode
> *inode, loff_t offset, loff_t length,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 orig_mlen =3D map.m_len;
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 if (flags & IOMAP_WRITE) {
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* We check here if the blocks are already al=
located, then we
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* don't need to start a journal txn and we c=
an directly return
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* the mapping information. This could boost =
performance
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* especially in multi-threaded overwrite req=
uests.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (offset + length <=3D i_size_read(inode)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_map_block=
s(NULL, inode, &map, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We check here =
if the blocks are already allocated, then we
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* don't need to =
start a journal txn and we can directly return
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the mapping in=
formation. This could boost performance
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* especially in =
multi-threaded overwrite requests.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* For DAX we con=
vert extents to initialized ones before
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* copying the da=
ta, otherwise we do it after I/O so
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* there's no nee=
d to call into ext4_iomap_alloc().
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (offset + length <=
=3D i_size_read(inode)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ret =3D ext4_map_blocks(NULL, inode, &map, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((map.m_flags & EXT=
4_MAP_MAPPED) ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!(flags=
 & IOMAP_DAX) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(m=
ap.m_flags & EXT4_MAP_UNWRITTEN))) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* For DAX we convert extents to initialized ones before
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* copying the data, otherwise we do it after I/O so
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* there's no need to call into ext4_iomap_alloc().
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* For atomic writes the entire requested
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* length should be mapped.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if ((map.m_flags & EXT4_MAP_MAPPED) ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 (!(flags & IOMAP_DAX) &&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0(map.m_flags & EXT4_MAP_UNWRITTEN))) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* For atomic writes the entire req=
uested
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* length should be mapped.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret =3D=3D orig_mlen ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (!(flags & IOMAP_ATOMIC) &=
& ret > 0))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 map.m_len =3D orig_mlen;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (ret =3D=3D orig_mlen ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 (!(flags & IOMAP_ATOMIC) && ret > 0))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_iomap_all=
oc(inode, &map, flags);
> - =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_map_block=
s(NULL, inode, &map, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 map.m_len =3D orig_mle=
n;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_iomap_alloc(inode, &map, flags);
>=C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> @@ -3850,6 +3884,16 @@ static int ext4_iomap_begin(struct inode
> *inode, loff_t offset, loff_t length,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> =C2=A0}
>=C2=A0
> +static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t l=
ength,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned flags, struct=
 iomap *iomap, struct iomap *srcmap)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (flags & IOMAP_WRITE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ext4_write_ioma=
p_begin(inode, offset, length, flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 iomap, srcmap);
> + =C2=A0 =C2=A0 =C2=A0 return ext4_read_iomap_begin(inode, offset, length=
, flags, iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0srcmap);
> +}
> +
> =C2=A0int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *io=
map,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *srcmap)
> =C2=A0{
>=C2=A0
>=C2=A0
> change #2: use ext4_read_iomap_next in iomap_dio_rw
>=C2=A0
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 755fde1baf03..bef2851d5466 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -4006,6 +4006,8 @@ static inline void
> ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>=C2=A0
> =C2=A0int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *io=
map,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *src=
map);
> +int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *io=
map,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *srcmap);
> =C2=A0int ext4_iomap_next_report(const struct iomap_iter *iter, struct io=
map *iomap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *src=
map);
>=C2=A0
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index bf0c18cf1017..48c6a76a16a1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -91,7 +91,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb
> *iocb, struct iov_iter *to)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return generic_fi=
le_read_iter(iocb, to);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=C2=A0
> - =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NU=
LL,
> + =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_dio_rw(iocb, to, ext4_read_iomap_nex=
t, NULL,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0IOMAP_DIO_NO_IOMAP_END, NULL, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_unlock_shared(inode);
>=C2=A0
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 54cdecbc7539..6e7c77276d58 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3771,9 +3771,9 @@ static int ext4_iomap_alloc(struct inode *inode,
> struct ext4_map_blocks *map,
> =C2=A0}
>=C2=A0
>=C2=A0
> -static int ext4_read_iomap_begin(struct inode *inode, loff_t offset,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t length, unsigne=
d int flags, struct iomap *iomap,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *srcmap)
> +static __always_inline int ext4_read_iomap_begin(struct inode *inode,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t offset, loff_t =
length, unsigned int flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap *iomap, s=
truct iomap *srcmap)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ext4_map_blocks map;
> @@ -3900,6 +3900,12 @@ int ext4_iomap_next(const struct iomap_iter
> *iter, struct iomap *iomap,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return iomap_process(iter, iomap, srcmap, ext=
4_iomap_begin, NULL);
> =C2=A0}
>=C2=A0
> +int ext4_read_iomap_next(const struct iomap_iter *iter, struct iomap *io=
map,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0struct iomap *srcmap)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return iomap_process(iter, iomap, srcmap, ext4_rea=
d_iomap_begin, NULL);
> +}
> +
> =C2=A0static int ext4_iomap_begin_report(struct inode *inode, loff_t offs=
et,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_t length, unsigned=
 int flags,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *iomap, st=
ruct iomap *srcmap)
>=C2=A0
> The github link for the changes are in [1].
>=C2=A0
> Thanks for your patience with this!
>=C2=A0
> [1] https://github.com/joannekoong/linux/commits/iomap_simple_dio_iomap_n=
ext_ext4/
>=C2=A0
