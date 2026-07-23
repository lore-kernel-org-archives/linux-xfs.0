Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427C299A82
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 02:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784773082; cv=none; b=TcZMSbUSA2vjSqwLQmDUVMFbKM+U1Szb5ZUsry52Rgk++sywPBxV4Y862KJllAPg6s9SD8gQgD9ti/RchVtbsOc0UeMLZMOEf+1LQX7hB9wPk3Icp+E3hFzNzYFT9q2Ql2Mv5/eG/+RpreKKNavU1dROE3QoFMgLQxAJf4dYdms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784773082; c=relaxed/simple;
	bh=RCqbINI8NC4BCaa4QfcvEM8T+JVXJdkfL0WkdmbYtQw=;
	h=Mime-Version:In-Reply-To:References:Date:Message-Id:Cc:
	 Content-Type:To:Subject:From; b=soAH7MJER87jr6/8kbxIRO0Lnr9zUkpX7x8hwhfwBeVKF8xegIzc+lZWYhqvnrzn0HAgMezvviE/Gm7LTGVNJCa8Iuk2ef1Yqxj0ogWbPLb2IUnYaYif9PqqNJge/dYnTiYby5iiw0uO9J9JaGAko6DJmd26ch55vHC+ivkoUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UtQP1t75; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UtQP1t75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784773074; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=RCqbINI8NC4BCaa4QfcvEM8T+JVXJdkfL0WkdmbYtQw=;
 b=UtQP1t75pvlNsk1DoRjhvTXVDzZ1LQUTCDCrGNluZvX2+UeZIwqmX+RroaETvk9zuhUh/N
 /oG19CHX8n+VCzvEiIG6hDAJItx1xU7pBPr/7jLLbnKd4f8uKJkPqZmq73SD7dQHJdLPck
 wgWcaXRbc8snaRCzkR3ItWx/xwnqoQVCqgS7WqV4PXqEIo/48CMeGMJDSUAmK7EEq2sv1v
 AI5zXnnFTmimpmjuZ06jHUCKDOGVhrRTH1brog02ushagCAE3t1NyH/V5RHC1ZQTmWTGP+
 BP5WhWYlz25eZgh2xX7RdZAMV8tnTZm+ZqZBAdlCE03tihciDkvNBOFahaRO1w==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a6179d0+904d33+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-3-hch@lst.de>
	<CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
Date: Thu, 23 Jul 2026 10:17:49 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.fb281486.dc82.4049.92e1.5b912f7e663c@bytedance.com>
Cc: "Christoph Hellwig" <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Joanne Koong" <joannelkoong@gmail.com>
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from iomap_dio_rw
From: "changfengnan" <changfengnan@bytedance.com>


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Thu, Jul 23, 2026, 03:04
> Subject:=C2=A0 Re: [PATCH 2/3] iomap: decouple simple direct I/O reads fr=
om iomap_dio_rw
> To: "Christoph Hellwig"<hch@lst.de>
> Cc: <changfengnan@bytedance.com>, "Darrick J. Wong"<djwong@kernel.org>, "=
Christian Brauner"<brauner@kernel.org>, "Theodore Ts'o"<tytso@mit.edu>, "Ca=
rlos Maiolino"<cem@kernel.org>, <linux-ext4@vger.kernel.org>, <linux-xfs@vg=
er.kernel.org>, <linux-fsdevel@vger.kernel.org>
> On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wr=
ote:
> >
> > The pending iomap_iter_next conversion creates performance issues for t=
he
> > new simple direct I/O read fast path, because it assumes a model where
> > the iterator must be advanced at the end, which the direct I/O read fas=
t
> > path tries to avoid.
> >
> > Side step this by splitting the simple path from iomap_dio_rw, and
> > require the file systems to call into it explicitly, and pass only a
> > ->begin callback. =C2=A0This allows to drop various checks for incompat=
ible
> > features while creating a requirement for the file system to only call
> > the simple path for cases that it can handle.
>=C2=A0
> Nice, this approach looks cleaner to me.
>=C2=A0
> >
> > As a side-benefit we can now inline the initial part of the simple
> > direct I/O read fast path and let the compiler convert the indirect cal=
l
> > to ->begin into a direct call.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 3 +
> > =C2=A0fs/ext4/file.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 4 +-
> > =C2=A0fs/ext4/inode.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 2 +-
> > =C2=A0fs/iomap/direct-io.c =C2=A0| 209 ++++++++++----------------------=
----------
> > =C2=A0fs/xfs/xfs_file.c =C2=A0 =C2=A0 | =C2=A014 +--
> > =C2=A0fs/xfs/xfs_iomap.c =C2=A0 =C2=A0| =C2=A0 2 +-
> > =C2=A0fs/xfs/xfs_iomap.h =C2=A0 =C2=A0| =C2=A0 4 +
> > =C2=A0include/linux/iomap.h | =C2=A065 +++++++++++++
> > =C2=A08 files changed, 133 insertions(+), 170 deletions(-)
> >
> > index 3df851d0f76b..810dc4b8dc94 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> >
> > +/*
> > + * Fast path for small, block-aligned direct I/Os that map to a single
> > + * contiguous on-disk extent.
> > + *
> > + * @iter must describe a non-empty READ no larger than the inode block=
 size:
> > + * writes, zero-length I/O, and larger requests need the generic iomap=
 direct
> > + * I/O path.
> > + *
> > + * Does not support iomap_dio_ops, dio_flags, done_before or private d=
ata.
> > + * The range must also stay within i_size and encrypted inodes must us=
e the
> > + * generic iomap direct I/O path.
> > + *
> > + * -ENOTBLK inidicates the generic path must be used by the caller ins=
tead.
> > + * Any other errno is a real result and is propagated as-is, in partic=
ular
> > + * -EAGAIN for IOCB_NOWAIT must reach the caller.
> > + *
> > + * The caller can only provide an iomap begin handler, and the iterato=
r
> > + * is never advanced.
> > + */
> > +ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap_iter *i=
omi);
>=C2=A0
> Might be nice to have _read_ in this name as well, eg __iomap_dio_read_si=
mple
>=C2=A0
> > +static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *ioc=
b,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iov_iter *ite=
r, iomap_iter_begin_fn begin)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct iomap_iter iomi =3D {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .inode =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D file_inode(iocb->ki_filp),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pos =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .len =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iov_iter_count(iter),
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .flags =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> > + =C2=A0 =C2=A0 =C2=A0 };
> > + =C2=A0 =C2=A0 =C2=A0 ssize_t ret;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (!iomi.len)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Simple dio is an optimization for small =
IO. Filter out large IO
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* early as it's the most common case to fa=
il for typical direct IO
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* workloads.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 if (iomi.len > iomi.inode->i_sb->s_blocksize)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOTBLK;
> > + =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_pos + iomi.len > i_size_read(iomi.i=
node))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOTBLK;
> > + =C2=A0 =C2=A0 =C2=A0 if (IS_ENCRYPTED(iomi.inode))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOTBLK;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 ret =3D kiocb_write_and_wait(iocb, iomi.len);
> > + =C2=A0 =C2=A0 =C2=A0 if (ret)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_flags & IOCB_NOWAIT)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi.flags |=3D IOMA=
P_NOWAIT;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 inode_dio_begin(iomi.inode);
> > + =C2=A0 =C2=A0 =C2=A0 ret =3D begin(iomi.inode, iomi.pos, iomi.len, io=
mi.flags, &iomi.iomap,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 &iomi.srcmap);
> > + =C2=A0 =C2=A0 =C2=A0 if (!ret)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D __iomap_dio_=
simple(iocb, iter, &iomi);
> > + =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0 && ret !=3D -EIOCBQUEUED)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(iomi.i=
node);
>=C2=A0
> afaict, the inode_dio_end() error handling has to be done by
> __iomap_dio_simple() to properly account for the synchronous case. I
> ran into this earlier when doing the iomap_next_fn inlining. For the
> synchronous case, __iomap_dio_simple() calls
> iomap_dio_simple_complete() which calls inode_dio_end() even on
> errors.

Yes, there is an issue with the handling of the inode_dio_end event in the
synchronization scenario.
How about this ?

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 3bdfbd0efa076..f6c8091a65ac9 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -994,18 +994,22 @@ ssize_t __iomap_dio_simple(struct kiocb *iocb, struct=
 iov_iter *iter,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (iomi->iomap.type !=3D IOMAP_MAPPED ||
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomi->iomap.offset + iomi->=
iomap.length < iomi->pos + iomi->len ||
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 (iomi->iomap.flags & IOMAP_F_INT=
EGRITY))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return -ENOTBLK;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 (iomi->iomap.flags & IOMAP_F_INT=
EGRITY)) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D -ENOTBLK;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 goto out_dio_end;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 alignment =3D iomap_dio_alignment(iomi->i=
node, iomi->iomap.bdev, 0);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if ((iomi->pos | iomi->len) & (alignment - 1))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return -EINVAL;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if ((iomi->pos | iomi->len) & (alignment - 1))=
 {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D -EINVAL;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 goto out_dio_end;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!iomi->inode->i_sb->s_dio_do=
ne_wq &&
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 !is_sync_kiocb(iocb))) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D sb_in=
it_dio_done_wq(iomi->inode->i_sb);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 return ret;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 goto out_dio_end;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 trace_iomap_dio_rw_begin(iocb, iter, 0, 0=
);
@@ -1013,8 +1017,10 @@ ssize_t __iomap_dio_simple(struct kiocb *iocb, struc=
t iov_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio =3D bio_alloc_bioset(iomi->iomap.bdev=
,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 bio_iov_vecs_to_alloc(iter, BIO_M=
AX_VECS),
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 REQ_OP_READ, gfp, &iomap_dio_simp=
le_pool);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!bio)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return -EAGAIN;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!bio) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D -EAGAIN;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 goto out_dio_end;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 sr =3D container_of(bio, struct iomap_dio=
_simple, bio);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 sr->iocb =3D iocb;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 sr->dio_flags =3D 0;
@@ -1060,6 +1066,8 @@ ssize_t __iomap_dio_simple(struct kiocb *iocb, struct=
 iov_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_release_pages(bio, false);
=C2=A0out_bio_put:
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_put(bio);
+out_dio_end:
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 inode_dio_end(iomi->inode);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
=C2=A0}
=C2=A0EXPORT_SYMBOL_GPL(__iomap_dio_simple);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 810dc4b8dc94d..3cdf475059048 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -732,11 +732,11 @@ static __always_inline ssize_t iomap_dio_read_simple(=
struct kiocb *iocb,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_begin(iomi.inode);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D begin(iomi.inode, iomi.pos, iomi.=
len, iomi.flags, &iomi.iomap,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &iomi.srcmap);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!ret)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D __iomap_di=
o_simple(iocb, iter, &iomi);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret <=3D 0 && ret !=3D -EIOCBQUEUED)
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end=
(iomi.inode);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return __iomap_dio_simple(iocb, iter, &iomi);
=C2=A0}
=C2=A0
=C2=A0#ifdef CONFIG_SWAP
>=C2=A0
> Thanks,
> Joanne
>=C2=A0
> > + =C2=A0 =C2=A0 =C2=A0 return ret;
> > +}
>=C2=A0
