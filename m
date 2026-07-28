Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9572F12A1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 03:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785207848; cv=none; b=oYHJ3S7Ug+l+luCL+Lu8KdTGsIic/3GFAdw7OXHezEMnWn6AuurpUyTv/cudn3Q0Uk8ck86sM/YRdhRBZE0oBeDqkLfZ8Dc6JwJbvxS+EPAK4OovJCzxjeRrubUrnCquvw4YESDWUwi5mdrrk+i4jFhuQ+RtMcf6rZUlLB7ujOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785207848; c=relaxed/simple;
	bh=0TWAjvoKseQ9JpSOHQgU+XQMJ/+3E2hNh/IjKkVftj4=;
	h=Message-Id:Cc:Subject:Mime-Version:In-Reply-To:Content-Type:Date:
	 From:References:To; b=mdGezf01sCkPMpAdYyoNmV6TPRAuEzq14CZ8E8s3ZS6Hv/q1ppmG7WJ8QEeJjzQFketmlvh6P7VJLyOBHi7I++0ZczRyKuQusrr/RMzue4jbbD75Q/v0L7O3eWJjFq+pd6EDs324jBuQgoC0ovTz+DygCn2iQaxBmO8xKBTr6aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dxBrUyjx; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dxBrUyjx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785207839; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0TWAjvoKseQ9JpSOHQgU+XQMJ/+3E2hNh/IjKkVftj4=;
 b=dxBrUyjxyw4NPca3wKJgVZAyuL3m8Kl71mykvcE3MxZxeGuIK5G+GE6v5e3H7JlDNdVEjb
 dZoujfrxyzPwCtZlXDxDHZt8bYr6gpqVGF8KfAYq1Ts3REQ2iX5H/0yTlDW3BwmQ4SmZBW
 5rd7XZNlF524cBpufUAZ54tHzHpy/GYYTIyFTpOFbQJdi2oKWAqCzD1tksnHjlhu+LN1jg
 I5KScqjSNUn7wlIdE7glaXBTgFsevQ/cQCtH/quUBn4W1G3R8XkGampyobsEGF2xPd7bCW
 b1/sk093hpK48H0WpzgHsUNgzSdwtJqEtKgybQ++eDYe5oiPAHuAe3ZQv3zX9w==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.18304f34.4a67.44d1.b331.9f18f1c35bb7@bytedance.com>
Cc: "Christian Brauner" <brauner@kernel.org>, <hch@lst.de>, 
	"Darrick J . Wong" <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<kbusch@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, 
	"Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, 
	"David Sterba" <dsterba@suse.com>, "Gao Xiang" <xiang@kernel.org>, 
	"Namjae Jeon" <linkinjeon@kernel.org>, <tytso@mit.edu>, 
	"Jaegeuk Kim" <jaegeuk@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>, 
	"Hyunchul Lee" <hyc.lee@gmail.com>, 
	"Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>, 
	"Carlos Maiolino" <cem@kernel.org>, 
	"Damien Le Moal" <dlemoal@kernel.org>, <libaokun@linux.alibaba.com>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 02/21] iomap: decouple simple direct I/O reads from iomap_dio_rw
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a681c1d+b7f4c2+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <20260727211758.1116539-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Jul 2026 11:03:54 +0800
Content-Transfer-Encoding: quoted-printable
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
	<20260727211758.1116539-3-joannelkoong@gmail.com>
To: "Joanne Koong" <joannelkoong@gmail.com>


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Tue, Jul 28, 2026, 05:24
> Subject:=C2=A0 [PATCH v4 02/21] iomap: decouple simple direct I/O reads f=
rom iomap_dio_rw
> To: "Christian Brauner"<brauner@kernel.org>, <hch@lst.de>, "Darrick J . W=
ong"<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>
> Cc: <changfengnan@bytedance.com>, <kbusch@kernel.org>, "Matthew Wilcox"<w=
illy@infradead.org>, "Jan Kara"<jack@suse.cz>, "Jonathan Corbet"<corbet@lwn=
.net>, "David Sterba"<dsterba@suse.com>, "Gao Xiang"<xiang@kernel.org>, "Na=
mjae Jeon"<linkinjeon@kernel.org>, <tytso@mit.edu>, "Jaegeuk Kim"<jaegeuk@k=
ernel.org>, "Miklos Szeredi"<miklos@szeredi.hu>, "Andreas Gruenbacher"<agru=
enba@redhat.com>, "Mikulas Patocka"<mikulas@artax.karlin.mff.cuni.cz>, "Hyu=
nchul Lee"<hyc.lee@gmail.com>, "Konstantin Komarov"<almaz.alexandrovich@par=
agon-software.com>, "Carlos Maiolino"<cem@kernel.org>, "Damien Le Moal"<dle=
moal@kernel.org>, <libaokun@linux.alibaba.com>, <linux-ext4@vger.kernel.org=
>, <linux-xfs@vger.kernel.org>
> From: Christoph Hellwig <hch@lst.de>
>=C2=A0
> The pending iomap_iter_next conversion creates performance issues for the
> new simple direct I/O read fast path, because it assumes a model where
> the iterator must be advanced at the end, which the direct I/O read fast
> path tries to avoid.
>=C2=A0
> Side step this by splitting the simple path from iomap_dio_rw, and
> require the file systems to call into it explicitly, and pass only a
> ->begin callback. =C2=A0This allows to drop various checks for incompatib=
le
> features while creating a requirement for the file system to only call
> the simple path for cases that it can handle.
>=C2=A0
> As a side-benefit we can now inline the initial part of the simple
> direct I/O read fast path and let the compiler convert the indirect call
> to ->begin into a direct call.
>=C2=A0
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
> =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 3 +
> =C2=A0fs/ext4/file.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 4 +-
> =C2=A0fs/ext4/inode.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 2 +-
> =C2=A0fs/iomap/direct-io.c =C2=A0| 208 ++++++++++------------------------=
--------
> =C2=A0fs/xfs/xfs_file.c =C2=A0 =C2=A0 | =C2=A014 +--
> =C2=A0fs/xfs/xfs_iomap.c =C2=A0 =C2=A0| =C2=A0 2 +-
> =C2=A0fs/xfs/xfs_iomap.h =C2=A0 =C2=A0| =C2=A0 4 +
> =C2=A0include/linux/iomap.h | =C2=A066 ++++++++++++++
> =C2=A08 files changed, 136 insertions(+), 167 deletions(-)
>=C2=A0
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..e134c0193e2b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -4007,6 +4007,9 @@ static inline void ext4_clear_io_unwritten_flag(ext=
4_io_end_t *io_end)
> =C2=A0extern const struct iomap_ops ext4_iomap_ops;
> =C2=A0extern const struct iomap_ops ext4_iomap_report_ops;
> =C2=A0
> +int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned flags, =
struct iomap *iomap, struct iomap *srcmap);
> +
> =C2=A0static inline int ext4_buffer_uptodate(struct buffer_head *bh)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..f20d92255546 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -91,7 +91,9 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, s=
truct iov_iter *to)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return gene=
ric_file_read_iter(iocb, to);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_dio_rw(iocb, to, &ext4_iomap_o=
ps, NULL, 0, NULL, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_dio_read_simple(iocb, to, ext4=
_iomap_begin);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D -ENOTBLK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_unlock_shared(inode);
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0file_accessed(iocb->ki_filp);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..b48c54f3312b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3771,7 +3771,7 @@ static int ext4_iomap_alloc(struct inode *inode, st=
ruct ext4_map_blocks *map,
> =C2=A0}
> =C2=A0
> =C2=A0
> -static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t l=
ength,
> +int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned fl=
ags, struct iomap *iomap, struct iomap *srcmap)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index ca790239e5eb..36c976cf0848 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -894,6 +894,21 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *=
iter,
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(__iomap_dio_rw);
> =C2=A0
> +ssize_t
> +iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct iom=
ap_ops *ops, const struct iomap_dio_ops *dops,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int dio=
_flags, void *private, size_t done_before)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio *dio;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D __iomap_dio_rw(iocb, iter, ops, dops=
, dio_flags, private,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 done_before);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR_OR_NULL(dio))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR_O=
R_ZERO(dio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_dio_complete(dio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +
> =C2=A0struct iomap_dio_simple {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*iocb;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size;
> @@ -968,211 +983,88 @@ static void iomap_dio_simple_end_io(struct bio *bi=
o)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_complete(iocb, iomap_dio_simpl=
e_complete(sr));
> =C2=A0}
> =C2=A0
> -static inline bool
> -iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 const struct iomap_dio_ops *dops,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 unsigned int dio_flags, size_t done_before)
> -{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D iov_iter_count(iter);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dops || done_before)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iov_iter_rw(iter) !=3D READ)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!count)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Simple dio is an optimization for small I=
O. Filter out large IO
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * early as it's the most common case to fai=
l for typical direct IO
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * workloads.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (count > inode->i_sb->s_blocksize)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMA=
P_DIO_PARTIAL |
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 IOMAP_DIO_BOUNCE))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_pos + count > i_size_read(inode=
))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ENCRYPTED(inode))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;
> -}
> -
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
> - * allocated from the filesystem-private @dops->bio_set (whose front_pad=
 sizes a
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
al result and
> - * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach=
 the
> - * caller.
> - */
> -static ssize_t
> -iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct io=
map_ops *ops, void *private,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int di=
o_flags)
> +ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *ite=
r,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_ite=
r *iomi)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D iov_iter_count(iter);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bool wait_for_completion =3D is_sync_kiocb(i=
ocb);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_iter iomi =3D {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.inode =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D inode,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pos =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.len =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D count,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.flags =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.private =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D private,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple *sr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int alignment;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_flags & IOCB_NOWAIT)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.flags |=3D =
IOMAP_NOWAIT;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D kiocb_write_and_wait(iocb, count);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_begin(inode);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ops->iomap_begin(inode, iomi.pos, co=
unt, iomi.flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap, &iomi.srcmap);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(in=
ode);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomi.iomap.type !=3D IOMAP_MAPPED ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.iomap.offset + iomi.iomap=
.length < iomi.pos + count ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(iomi.iomap.flags & IOMAP_F_IN=
TEGRITY)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomi->iomap.type !=3D IOMAP_MAPPED ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi->iomap.offset + iomi->iom=
ap.length < iomi->pos + iomi->len ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(iomi->iomap.flags & IOMAP_F_I=
NTEGRITY)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EN=
OTBLK;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap_e=
nd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_dio_end=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D iomap_dio_alignment(inode, iom=
i.iomap.bdev, dio_flags);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iomi.pos | count) & (alignment - 1)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D iomap_dio_alignment(iomi->inod=
e, iomi->iomap.bdev, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iomi->pos | iomi->len) & (alignment - 1=
)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EI=
NVAL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap_e=
nd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_dio_end=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!wait_for_completion && unlikely(!inode-=
>i_sb->s_dio_done_wq)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sb_init_=
dio_done_wq(inode->i_sb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!iomi->inode->i_sb->s_dio_done_=
wq &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0!is_sync_kiocb(iocb))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sb_init_=
dio_done_wq(iomi->inode->i_sb);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0=
)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out_iomap_end;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out_dio_end;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_rw_begin(iocb, iter, dio_fla=
gs, 0);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (user_backed_iter(iter))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_flags |=3D I=
OMAP_DIO_USER_BACKED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_rw_begin(iocb, iter, 0, 0);
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =3D bio_alloc_bioset(iomi.iomap.bdev,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =3D bio_alloc_bioset(iomi->iomap.bdev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_iov_vecs_to_alloc(iter, BIO_MAX_=
VECS),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_OP_READ, GFP_KERNEL, &iomap_dio_=
simple_pool);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr =3D container_of(bio, struct iomap_d=
io_simple, bio);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->iocb =3D iocb;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->dio_flags =3D dio_flags;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->dio_flags =3D 0;
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_iter.bi_sector =3D iomap_sector(&iom=
i.iomap, iomi.pos);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_iter.bi_sector =3D iomap_sector(&iom=
i->iomap, iomi->pos);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_ioprio =3D iocb->ki_ioprio;
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D bio_iov_iter_get_pages(bio, ite=
r, alignment - 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(ret))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_bi=
o_put;
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio->bi_iter.bi_size !=3D count) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio->bi_iter.bi_size !=3D iomi->len) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iov_iter_re=
vert(iter, bio->bi_iter.bi_size);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EN=
OTBLK;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_bi=
o_release_pages;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->size =3D bio->bi_iter.bi_size;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_USER_BACKED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (user_backed_iter(iter)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_set_pag=
es_dirty(bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->dio_flags |=
=3D IOMAP_DIO_USER_BACKED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_flags & IOCB_NOWAIT)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_opf=
 |=3D REQ_NOWAIT;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iocb->ki_flags & IOCB_HIPRI) && !wait_f=
or_completion) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_opf |=3D=
 REQ_POLLED;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(iocb-=
>private, bio);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops->iomap_end)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->iomap_end(i=
node, iomi.pos, count, count, iomi.flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!wait_for_completion) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_end_io =
=3D iomap_dio_simple_end_io;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0submit_bio(bio);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_=
rw_queued(inode, iomi.pos, count);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIOCBQUE=
UED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_sync_kiocb(iocb)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0submit_bio_wait(=
bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_dio=
_simple_complete(sr);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0submit_bio_wait(bio);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_dio_simple_complete(sr);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iocb->ki_flags & IOCB_HIPRI)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_opf |=3D=
 REQ_POLLED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(iocb-=
>private, bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_end_io =3D iomap_dio_simple_end_io;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0submit_bio(bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_rw_queued(iomi->inode, iocb-=
>ki_pos, iomi->len);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIOCBQUEUED;
> =C2=A0
> =C2=A0out_bio_release_pages:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_release_pages(bio, false);
> =C2=A0out_bio_put:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> -out_iomap_end:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops->iomap_end)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->iomap_end(i=
node, iomi.pos, count, 0, iomi.flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(inode);
> +out_dio_end:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(iomi->inode);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
> -
> -ssize_t
> -iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct iom=
ap_ops *ops, const struct iomap_dio_ops *dops,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int dio=
_flags, void *private, size_t done_before)
> -{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio *dio;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomap_dio_simple_supported(iocb, iter, d=
ops, dio_flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 done_before)=
) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_simple(iocb, iter, ops, private, dio_flags);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret !=3D -EN=
OTBLK)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D __iomap_dio_rw(iocb, iter, ops, dops=
, dio_flags, private,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 done_before);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR_OR_NULL(dio))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR_O=
R_ZERO(dio);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_dio_complete(dio);
> -}
> -EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +EXPORT_SYMBOL_GPL(__iomap_dio_read_simple);
> =C2=A0
> =C2=A0static int __init iomap_dio_init(void)
> =C2=A0{
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..b733225d2864 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -251,8 +251,6 @@ xfs_file_dio_read(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iov_iter =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*to)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct xfs_inode =C2=A0 =C2=A0 =C2=A0 =
=C2=A0*ip =3D XFS_I(file_inode(iocb->ki_filp));
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0dio_flags =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct iomap_dio_ops *dio_ops =3D NULL=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret;
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_xfs_file_direct_read(iocb, to);
> @@ -266,11 +264,15 @@ xfs_file_dio_read(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mapping_stable_writes(iocb->ki_filp=
->f_mapping)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_ops =3D &xfs=
_dio_read_bounce_ops;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_flags |=3D I=
OMAP_DIO_BOUNCE;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_rw(iocb, to, &xfs_read_iomap_ops,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&xfs_dio_read_bounce_ops, IOMAP_DI=
O_BOUNCE,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_read_simple(iocb, to, xfs_read_iomap_begin);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D -=
ENOTBLK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ret =3D iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00, NUL=
L, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_dio_rw(iocb, to, &xfs_read_iom=
ap_ops, dio_ops, dio_flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0NULL, 0);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 225c3de88d03..0536e2aeddcc 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -2173,7 +2173,7 @@ const struct iomap_ops xfs_buffered_write_iomap_ops=
 =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.iomap_end =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D xfs_buffered_write_iomap_end,
> =C2=A0};
> =C2=A0
> -static int
> +int
> =C2=A0xfs_read_iomap_begin(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*inode,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0offset,
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ebcce7d49446..cffcec532ea6 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -49,6 +49,10 @@ xfs_aligned_fsb_count(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return count_fsb;
> =C2=A0}
> =C2=A0
> +int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_t length, u=
nsigned flags, struct iomap *iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *sr=
cmap);
> +
> =C2=A0extern const struct iomap_ops xfs_buffered_write_iomap_ops;
> =C2=A0extern const struct iomap_ops xfs_direct_write_iomap_ops;
> =C2=A0extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 36490c08d6e9..80832edc7ec2 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/mm_types.h>
> =C2=A0#include <linux/blkdev.h>
> =C2=A0#include <linux/folio_batch.h>
> +#include <linux/pagemap.h>
> =C2=A0
> =C2=A0struct address_space;
> =C2=A0struct fiemap_extent_info;
> @@ -675,6 +676,71 @@ struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb,=
 struct iov_iter *iter,
> =C2=A0ssize_t iomap_dio_complete(struct iomap_dio *dio);
> =C2=A0void iomap_dio_bio_end_io(struct bio *bio);
> =C2=A0
> +/*
> + * Fast path for small, block-aligned direct I/Os that map to a single
> + * contiguous on-disk extent.
> + *
> + * @iter must describe a non-empty READ no larger than the inode block s=
ize:
> + * writes, zero-length I/O, and larger requests need the generic iomap d=
irect
> + * I/O path.
> + *
> + * Does not support iomap_dio_ops, dio_flags, done_before or private dat=
a.
> + * The range must also stay within i_size and encrypted inodes must use =
the
> + * generic iomap direct I/O path.
> + *
> + * -ENOTBLK indicates the generic path must be used by the caller instea=
d.
> + * Any other errno is a real result and is propagated as-is, in particul=
ar
> + * -EAGAIN for IOCB_NOWAIT must reach the caller.
> + *
> + * The caller can only provide an iomap begin handler, and the iterator
> + * is never advanced.
> + */
> +ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *ite=
r,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_ite=
r *iomi);
> +static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iov_iter =
*iter, iomap_iter_begin_fn begin)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_iter iomi =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.inode =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D file_inode(iocb->ki_fil=
p),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pos =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.len =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iov_iter_count(iter),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.flags =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!iomi.len)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Simple dio is an optimization for small I=
O. Filter out large IO
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * early as it's the most common case to fai=
l for typical direct IO
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * workloads.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomi.len > iomi.inode->i_sb->s_blocksize=
)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOTBLK;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_pos + iomi.len > i_size_read(io=
mi.inode))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOTBLK;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ENCRYPTED(iomi.inode))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOTBLK;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D kiocb_write_and_wait(iocb, iomi.len)=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_flags & IOCB_NOWAIT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.flags |=3D =
IOMAP_NOWAIT;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_begin(iomi.inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D begin(iomi.inode, iomi.pos, iomi.len=
, iomi.flags, &iomi.iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0&iomi.srcmap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(io=
mi.inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return __iomap_dio_read_simple(iocb, iter, &=
iomi);
> +}
> +
> =C2=A0#ifdef CONFIG_SWAP
> =C2=A0struct file;
> =C2=A0struct swap_info_struct;
> --=C2=A0
> 2.52.0
>=C2=A0
