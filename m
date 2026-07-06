Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5C3EFD0F
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 11:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783336203; cv=none; b=YnsBU87t/7nai+ozXoQYOP4OmmY8tNXn2L8vcVlYgyIGf9I8H5RABe7qQXWu4CGRGcaNdvJ7vZ7YZA1flZKUFVIDX3uIzBXRaC4o/S8Q7l2KLUmNVaPaPnCDABW2FOYbdYJhHL8pSzo9Bg7Pi5pEjk6t7yMto9ulMAoGKgyUv8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783336203; c=relaxed/simple;
	bh=kXOnXCoq0g6EQzEYEp/gegMS/8R08YlA8Lx1pYwtJf8=;
	h=Cc:Mime-Version:In-Reply-To:References:Date:Message-Id:To:Subject:
	 From:Content-Type; b=IWNsVG5CbWgdykP+x7u+uNiCV8m6WjhDJMc8VR+WfCLvhfkW1Y84hL2haSvFDSFwS6pYzdDo874RlsnOm5hQY8JKKIo3ny7k3+Lk5zxOjr7PwGEpYz190bCesEjyn3DJm5J05f+yopTRL/kbrT1AzcFAwL8GFWMfd4bHwOBbNdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dLbjWLHe; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dLbjWLHe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783336195; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kXOnXCoq0g6EQzEYEp/gegMS/8R08YlA8Lx1pYwtJf8=;
 b=dLbjWLHeSiqJs7vXogZ2udnyJJ/gHwJ5DkWVvR8ZTVUDwwXP1k1UbDzgBQSyVpMdpzvf09
 +j8NRm83t+qZPc0+KfB5dRaqM3qIKTlaIcs93yQYT0ajWLdvHn3X0qrjX00gzyC/kV2Kyx
 9icyXLW6c/5HaVUbH3qoUZXnU9vImNDGxrFI8OnGkfemxlNZku251eTMtqHH1GMRbQkkaT
 jmYhsQ9WZKkqhrBQ73iQqyvC1mIVkGvxCi4VBzoZdx4evB26PUhy149HnaidetZMcuu2Tf
 hzuGJOg+DtTd09yi3Z8mQsQ16DN/3wJ8jF8/qF6c1n5t1wZ23OUQhDDQaXv/fg==
Cc: "Joanne Koong" <joannelkoong@gmail.com>, 
	"Christoph Hellwig" <hch@infradead.org>, "brauner" <brauner@kernel.org>, 
	"djwong" <djwong@kernel.org>, "ojaswin" <ojaswin@linux.ibm.com>, 
	"dgc" <dgc@kernel.org>, "linux-xfs" <linux-xfs@vger.kernel.org>, 
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>, 
	"linux-ext4" <linux-ext4@vger.kernel.org>, 
	"linux-kernel" <linux-kernel@vger.kernel.org>, 
	<lidiangang@bytedance.com>, "pankaj.raghav" <pankaj.raghav@linux.dev>, 
	"Brian Foster" <bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <akettUm5gBD8nj56@infradead.org>
X-Lms-Return-Path: <lba+16a4b8d01+e2b9a2+vger.kernel.org+changfengnan@bytedance.com>
References: <20260701033253.46420-1-changfengnan@bytedance.com> <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org> <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com> <akZ3GErzJSTtOn-H@infradead.org> <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com>
	<akettUm5gBD8nj56@infradead.org>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 19:09:50 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
From: "changfengnan" <changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8


> From: "Christoph Hellwig"<hch@infradead.org>
> Date:=C2=A0 Fri, Jul 3, 2026, 20:40
> Subject:=C2=A0 Re: [PATCH v6 3/3] iomap: add simple dio path for small di=
rect I/O
> To: "changfengnan"<changfengnan@bytedance.com>
> Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"<hch@infra=
dead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.org>, "oja=
swin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<linux-xfs@=
vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>, "linux-ex=
t4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kernel.or=
g>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@linux.dev>, "=
Brian Foster"<bfoster@redhat.com>
> On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > taken, which introduced some overhead.=C2=A0
> > I implemented some optimizations based on Christoph=E2=80=99s suggestio=
ns and
> > made some modifications to `iomap_process`;=C2=A0
> > Now, XFS performance is essentially unchanged, while ext4 still shows a
> > 1.5% drop; I will continue to investigate the cause.. =C2=A0 I=E2=80=99=
ve attached the patch.
> > Actually, I had expected that switching to `iomap_next` would improve
> > performance, since it avoids an indirect call.
>=C2=A0
> I don't think it will for you - the direct I/O readers don't have
> iomap_end methods, so you still have the same number of indirect
> calls. =C2=A0What could help is to inline the iterator as seen in Joannes=
'
> fist demo series. =C2=A0We could even look into doing that only for simpl=
e
> dio in a first step, shifting the burden to use the simple method
> to the callers (at least for the POC).

I'm not sure if this is what you had in mind, but I made some
adjustments referencing Joannes' first patch, and using this approach,=C2=
=A0
there was no performance degradation.

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index c05849d305ae4..fd2aeabca892a 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -809,8 +809,8 @@ static ssize_t exfat_file_read_iter(struct kiocb *iocb,=
 struct iov_iter *iter)
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (iocb->ki_flags & IOCB_DIRECT) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file_accessed=
(iocb->ki_filp);
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
rw(iocb, iter, exfat_iomap_next, NULL, 0,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 NULL, 0);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
rw(iocb, iter, exfat_iomap_next, NULL,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IOMAP_DIO_NO_IOMAP_END, NULL,=
 0);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D gener=
ic_file_read_iter(iocb, iter);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 755fde1baf036..cf1be36fdb177 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4004,6 +4004,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_=
io_end_t *io_end)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 io_end->flag =
&=3D ~EXT4_IO_END_UNWRITTEN;
=C2=A0}
=C2=A0
+int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uns=
igned int flags, struct iomap *iomap,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 str=
uct iomap *srcmap);
=C2=A0int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *ioma=
p,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap =
*srcmap);
=C2=A0int ext4_iomap_next_report(const struct iomap_iter *iter, struct ioma=
p *iomap,
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index dbe073e181a7a..e08edabcdeaa0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,8 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, str=
uct iov_iter *to)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return generi=
c_file_read_iter(iocb, to);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next=
, NULL, 0, NULL, 0);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_rw_begin(iocb, to, ext4_ioma=
p_begin, ext4_iomap_next,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NULL, IOMAP_DIO_NO_IOMAP_END, NULL, =
0);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_unlock_shared(inode);
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 file_accessed(iocb->ki_filp);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4c30dd8dbec7a..479406c84ff61 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3770,9 +3770,9 @@ static int ext4_iomap_alloc(struct inode *inode, stru=
ct ext4_map_blocks *map,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
=C2=A0}
=C2=A0
-
-static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t len=
gth,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 unsigned flags, st=
ruct iomap *iomap, struct iomap *srcmap)
+int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uns=
igned int flags, struct iomap *iomap,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 str=
uct iomap *srcmap)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ext4_map_blocks map;
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index d08b7d3c52710..fa17e249b0b03 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -1000,6 +1000,40 @@ iomap_dio_simple_supported(struct kiocb *iocb, struc=
t iov_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;
=C2=A0}
=C2=A0
+static inline void
+iomap_dio_simple_iter_done(struct iomap_iter *iomi)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 WARN_ON_ONCE(iomi->iomap.offset > iomi->pos);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 WARN_ON_ONCE(iomi->iomap.length =3D=3D 0);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 WARN_ON_ONCE(iomi->iomap.offset + iomi->iomap.=
length <=3D iomi->pos);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 WARN_ON_ONCE(iomi->iomap.flags & IOMAP_F_STALE=
);
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 iomi->iter_start_pos =3D iomi->pos;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 trace_iomap_iter_dstmap(iomi->inode, &iomi->io=
map);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iomi->srcmap.type !=3D IOMAP_HOLE)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 trace_iomap_iter_s=
rcmap(iomi->inode, &iomi->srcmap);
+}
+
+static inline int
+iomap_dio_simple_begin_iter(struct iomap_iter *iomi,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 iomap_begin_fn iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 iomap_next_fn iomap_next)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 int ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 trace_iomap_iter(iomi, iomap_next, _RET_IP_);
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_begin(iomi->inode, iomi->pos, io=
mi->len, iomi->flags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=C2=A0 &iomi->iomap, &iomi->srcmap);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 iomi->status =3D 0;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret < 0)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_dio_simple_iter_done(iomi);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return 1;
+}
+
=C2=A0static int
=C2=A0iomap_dio_simple_finish_iter(struct iomap_iter *iomi,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn=
 iomap_next, size_t done)
@@ -1053,8 +1087,8 @@ iomap_dio_simple_finish_iter(struct iomap_iter *iomi,
=C2=A0 */
=C2=A0static ssize_t
=C2=A0iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iom=
ap_next, void *private,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dio_=
flags)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn iom=
ap_next, iomap_begin_fn iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *private, un=
signed int dio_flags)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct inode *inode =3D file_inode(iocb->=
ki_filp);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t count =3D iov_iter_count(iter);
@@ -1080,7 +1114,11 @@ iomap_dio_simple(struct kiocb *iocb, struct iov_iter=
 *iter,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_begin(inode);
=C2=A0
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_iter(&iomi, iomap_next);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (iomap_begin)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple_begin_iter(&iomi, iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_next);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 else
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_iter=
(&iomi, iomap_next);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end=
(inode);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret ?:=
 -ENOTBLK;
@@ -1142,9 +1180,18 @@ iomap_dio_simple(struct kiocb *iocb, struct iov_iter=
 *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 WRITE_ONCE(io=
cb->private, bio);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_simple_finish_iter(&iomi, io=
map_next, count);
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret)
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 goto out_bio_relea=
se_pages_no_end;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 /*
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * The finishing iomap_iter() only runs the fi=
lesystem's ->iomap_end()
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * work and releases any attached folio batch.=
=C2=A0 When the caller promised
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * neither applies (IOMAP_DIO_NO_IOMAP_END), s=
kip it to avoid an extra
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * indirect ->iomap_next() call and the iomap_=
iter() frames on the hot
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 * read path.
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END)) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple_finish_iter(&iomi, iomap_next, count);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 goto out_bio_release_pages_no_end;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!wait_for_completion) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio->bi_end_i=
o =3D iomap_dio_simple_end_io;
@@ -1161,7 +1208,8 @@ iomap_dio_simple(struct kiocb *iocb, struct iov_iter =
*iter,
=C2=A0out_bio_put:
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_put(bio);
=C2=A0out_iomap_end:
- =C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_dio_simple_finish_iter(&iomi, iomap_next=
, 0);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_dio_simple_f=
inish_iter(&iomi, iomap_next, 0);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_dio_end(inode);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
=C2=A0out_bio_release_pages_no_end:
@@ -1181,8 +1229,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *ite=
r,
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (iomap_dio_simple_supported(iocb, iter=
, dops, dio_flags,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 done_=
before)) {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple(iocb, iter, iomap_next, private,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 dio_flags);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple(iocb, iter, iomap_next, NULL, private,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_flags);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret !=3D =
-ENOTBLK)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 return ret;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
@@ -1195,6 +1243,32 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *it=
er,
=C2=A0}
=C2=A0EXPORT_SYMBOL_GPL(iomap_dio_rw);
=C2=A0
+ssize_t
+iomap_dio_rw_begin(struct kiocb *iocb, struct iov_iter *iter,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_begi=
n_fn iomap_begin, iomap_next_fn iomap_next,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const stru=
ct iomap_dio_ops *dops, unsigned int dio_flags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *priv=
ate, size_t done_before)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 struct iomap_dio *dio;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ssize_t ret;
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if ((dio_flags & IOMAP_DIO_NO_IOMAP_END) &&
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 iomap_dio_simple_supported(iocb,=
 iter, dops, dio_flags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 done_before)) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
simple(iocb, iter, iomap_next, iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 private, dio_fl=
ags);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 if (ret !=3D -ENOT=
BLK)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 return ret;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 }
+
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 dio =3D __iomap_dio_rw(iocb, iter, iomap_next,=
 dops, dio_flags, private,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 done_before);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (IS_ERR_OR_NULL(dio))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return PTR_ERR_OR_=
ZERO(dio);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return iomap_dio_complete(dio);
+}
+EXPORT_SYMBOL_GPL(iomap_dio_rw_begin);
+
=C2=A0static int __init iomap_dio_init(void)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return bioset_init(&iomap_dio_simple_pool=
, 4,
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 984045af310a1..7dee4a7944071 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -15,16 +15,6 @@ static inline void iomap_iter_clean_fbatch(struct iomap_=
iter *iter)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0}
=C2=A0
-/* Advance the current iterator position and decrement the remaining lengt=
h */
-int iomap_iter_advance(struct iomap_iter *iter, u64 count)
-{
- =C2=A0 =C2=A0 =C2=A0=C2=A0 if (WARN_ON_ONCE(count > iomap_length(iter)))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return -EIO;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 iter->pos +=3D count;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 iter->len -=3D count;
- =C2=A0 =C2=A0 =C2=A0=C2=A0 return 0;
-}
-
=C2=A0static inline void iomap_iter_done(struct iomap_iter *iter)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 WARN_ON_ONCE(iter->iomap.offset > iter->p=
os);
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47d..e43ca419b13a8 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -127,7 +127,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_FORCE_WAIT, =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 "DIO_FORCE_WAIT" }, \
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_OVERWRITE_ONLY, =C2=A0 =C2=A0 =
=C2=A0=C2=A0 "DIO_OVERWRITE_ONLY" }, \
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 {IOMAP_DIO_PARTIAL, =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 "DIO_PARTIAL" }, \
- =C2=A0 =C2=A0 =C2=A0=C2=A0 {IOMAP_DIO_FSBLOCK_ALIGNED, =C2=A0 =C2=A0 =C2=
=A0=C2=A0 "DIO_FSBLOCK_ALIGNED" }
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 {IOMAP_DIO_FSBLOCK_ALIGNED, =C2=A0 =C2=A0 =C2=
=A0=C2=A0 "DIO_FSBLOCK_ALIGNED" }, \
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 {IOMAP_DIO_NO_IOMAP_END, =C2=A0 =C2=A0 =C2=A0=
=C2=A0 "DIO_NO_IOMAP_END" }
=C2=A0
=C2=A0DECLARE_EVENT_CLASS(iomap_class,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 TP_PROTO(struct inode *inode, struct ioma=
p *iomap),
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index a4f99128b46c5..babdfd0eff4f9 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -458,8 +458,8 @@ static ssize_t ntfs_file_read_iter(struct kiocb *iocb, =
struct iov_iter *to)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 file_accessed=
(iocb->ki_filp);
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
rw(iocb, to, ntfs_read_iomap_next, NULL, 0,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 NULL, 0);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_=
rw(iocb, to, ntfs_read_iomap_next, NULL,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IOMAP_DIO_NO_IOMAP_END, NULL,=
 0);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D gener=
ic_file_read_iter(iocb, to);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a987ffbf3c023..2d4dbd9fac7b4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -251,7 +251,7 @@ xfs_file_dio_read(
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iov_iter =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 *to)
=C2=A0{
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct xfs_inode =C2=A0 =C2=A0 =C2=A0=C2=
=A0 *ip =3D XFS_I(file_inode(iocb->ki_filp));
- =C2=A0 =C2=A0 =C2=A0=C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 dio_flags =3D 0;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=C2=A0 dio_flags =3D IOMAP_DIO_NO_IOMAP_END;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct iomap_dio_ops *dio_ops =3D N=
ULL;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 ssize_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 ret;
=C2=A0
@@ -269,8 +269,9 @@ xfs_file_dio_read(
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_ops =3D &=
xfs_dio_read_bounce_ops;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dio_flags |=
=3D IOMAP_DIO_BOUNCE;
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
- =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_rw(iocb, to, xfs_read_iomap_=
next, dio_ops, dio_flags,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=C2=A0 NULL, 0);
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 ret =3D iomap_dio_rw_begin(iocb, to, xfs_read_=
iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_read_iomap_next, dio_ops, dio_fl=
ags,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NULL, 0);
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 xfs_iunlock(ip, XFS_IOLOCK_SHARED);
=C2=A0
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 71c4bb024f042..dcc7f1fe2d52b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -2203,7 +2203,7 @@ xfs_buffered_write_iomap_next(
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 xfs_buffered_write_iomap_end);
=C2=A0}
=C2=A0
-static int
+int
=C2=A0xfs_read_iomap_begin(
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct inode =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=C2=A0 *inode,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 loff_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 offset,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 01875d20fb669..3db533e977e09 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -55,6 +55,9 @@ int xfs_direct_write_iomap_next(const struct iomap_iter *=
iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap =
*iomap, struct iomap *srcmap);
=C2=A0int xfs_zoned_direct_write_iomap_next(const struct iomap_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap =
*iomap, struct iomap *srcmap);
+int xfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t length=
,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 unsigned int flags, struct iomap *iomap,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct iomap *srcmap);
=C2=A0int xfs_read_iomap_next(const struct iomap_iter *iter, struct iomap *=
iomap,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct iomap =
*srcmap);
=C2=A0int xfs_seek_iomap_next(const struct iomap_iter *iter, struct iomap *=
iomap,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3b41f123a92d4..060051fc79b1f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -266,7 +266,6 @@ struct iomap_iter {
=C2=A0};
=C2=A0
=C2=A0int iomap_iter(struct iomap_iter *iter, iomap_next_fn iomap_next);
-int iomap_iter_advance(struct iomap_iter *iter, u64 count);
=C2=A0
=C2=A0/**
=C2=A0 * iomap_length_trim - trimmed length of the current iomap iteration
@@ -298,6 +297,16 @@ static inline u64 iomap_length(const struct iomap_iter=
 *iter)
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 return iomap_length_trim(iter, iter->pos,=
 iter->len);
=C2=A0}
=C2=A0
+/* Advance the current iterator position and decrement the remaining lengt=
h */
+static inline int iomap_iter_advance(struct iomap_iter *iter, u64 count)
+{
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 if (WARN_ON_ONCE(count > iomap_length(iter)))
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 return -EIO;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 iter->pos +=3D count;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 iter->len -=3D count;
+ =C2=A0 =C2=A0 =C2=A0=C2=A0 return 0;
+}
+
=C2=A0/**
=C2=A0 * iomap_iter_advance_full - advance by the full length of current ma=
p
=C2=A0 */
@@ -605,9 +614,23 @@ struct iomap_dio_ops {
=C2=A0 */
=C2=A0#define IOMAP_DIO_BOUNCE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0=C2=A0 (1 << 4)
=C2=A0
+/*
+ * The caller's ->iomap_next() has no ->iomap_end() work to run and this I=
/O
+ * does not use a folio batch, so the iomap_dio_simple() fast path may ski=
p
+ * the finishing iomap_iter() call entirely.=C2=A0 Only meaningful on the =
simple
+ * read fast path; ignored by the generic __iomap_dio_rw() slow path.
+ */
+#define IOMAP_DIO_NO_IOMAP_END =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0=C2=A0 BIT(5)
+
=C2=A0ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn=
 iomap_next, const struct iomap_dio_ops *dops,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int =
dio_flags, void *private, size_t done_before);
+ssize_t iomap_dio_rw_begin(struct kiocb *iocb, struct iov_iter *iter,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 iomap_begin_fn iomap_begin,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 iomap_next_fn iomap_next,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 const struct iomap_dio_ops *dops,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 unsigned int dio_flags, void *private,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 size_t done_before);
=C2=A0struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter =
*iter,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iomap_next_fn=
 iomap_next, const struct iomap_dio_ops *dops,
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int =
dio_flags, void *private, size_t done_before);
>=C2=A0
