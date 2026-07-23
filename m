Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C6331960A
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 02:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772382; cv=none; b=AG36ZRsr5UCuAsforHP48CpL0fdInMaNo7Ug4TvQLCqfBad+3EEDKfkNkyl7GG8Y3wqoXGU9BjF2A/YYnfP3UuVQoyq/tyb8dBl6C7uZujvAlv/DcyLMCU3P2lT0RhiPLKvVfTbFNgBi3/1cqP1GXUYqx8/ieeCUaImgQGrNrpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772382; c=relaxed/simple;
	bh=iGBkjBp2/xn+vQvMSG1iWCxjFS+K50sCN3HZ+3ODLmw=;
	h=Content-Type:Message-Id:Cc:Mime-Version:References:In-Reply-To:
	 Date:To:Subject:From; b=QRhW+MmQ2KbDVtqY3Ljaw2dBLhsbxiW6q39vLmQcPuo7LREx2/+i1aIHmEa9yTkXkdVISYs52QZraB04CkEqMas1yMB0P7UGJLyn4cJflbCU1PpzjtkdBBd0zGwLYWAWGoWl/tZlOh4pdPP1gWaMK3Zay1DH7hBIJirw1IerC78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=oW8oS7l2; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="oW8oS7l2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784772367; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=iGBkjBp2/xn+vQvMSG1iWCxjFS+K50sCN3HZ+3ODLmw=;
 b=oW8oS7l2Np28t1PlepBAYr8AH4IZOrU7pu/xZzPSpyBnmUoRV50bVwzqM8qUigk7wa0PaX
 INraCYtorTjpVPPNUUD+qgjn3kkf0pZES/azfa6mqLTR4FJwWP+rhVo0sf3R6yH4bPWqGZ
 dUGujcm677dTPgkbXamsM+dHqN/i1Gyrf3Fu7/45ru+a3bxC+cuz+gN6wtsjVOCo+iveFc
 MmKgJ6QMrnK/BSbXvIBrWrUFuUMqYHgIXkDUFuh3ZIXskYgRPmt26byaAIpHABeZpeEzuR
 +3FolNMrx4Jn1AQppHCYn23GEWb0Z8CT/yEmSNkR3nEmd8J8sEcZKwpzhABVBA==
Content-Type: text/plain; charset=UTF-8
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.26e5a754.3f9e.4685.916f.c8a42bd9a5c8@bytedance.com>
Cc: "Joanne Koong" <joannelkoong@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260722124931.3159664-1-hch@lst.de>
	<20260722124931.3159664-2-hch@lst.de>
X-Lms-Return-Path: <lba+16a61770d+ab5a0a+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <20260722124931.3159664-2-hch@lst.de>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:06:02 +0800
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH 1/3] iomap: split iomap_iter() logic into iomap_iter_next()
From: "changfengnan" <changfengnan@bytedance.com>


> From: "Christoph Hellwig"<hch@lst.de>
> Date:=C2=A0 Wed, Jul 22, 2026, 20:49
> Subject:=C2=A0 [PATCH 1/3] iomap: split iomap_iter() logic into iomap_ite=
r_next()
> To: <changfengnan@bytedance.com>, "Joanne Koong"<joannelkoong@gmail.com>,=
 "Darrick J. Wong"<djwong@kernel.org>, "Christian Brauner"<brauner@kernel.o=
rg>
> Cc: "Theodore Ts'o"<tytso@mit.edu>, "Carlos Maiolino"<cem@kernel.org>, <l=
inux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vge=
r.kernel.org>
> From: Joanne Koong <joannelkoong@gmail.com>
>=C2=A0
> In preparation for changing iomap to use an in-iter (->iomap_next())
> model, move the iomap_iter() logic out into the new iomap_iter_next()
> helper function.
>=C2=A0
> iomap_iter_next() is added as an inlined helper so it can be called
> directly by ->iomap_next() implementations where the begin()/end()
> callbacks can be direct calls.
>=C2=A0
> The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
> also provided to generate the boilerplate ->iomap_next() wrapper
> functions that simply forward to iomap_iter_next() with the appropriate
> begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
> where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
> the case where there is an explicit end() callback.
>=C2=A0
> No functional change intended. The only code-level difference is that on
> the iomap_end() error path (ret < 0 && !advanced), the old code returned
> with iter.status left as the caller's last value whereas the new code
> zeroes it, but this is not observable in practice as there are no in-tree
> callers that read iter.status after the iteration loop.
>=C2=A0
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>

> ---
> =C2=A0fs/iomap/iter.c =C2=A0 =C2=A0 =C2=A0 | 123 +++++++++++++++++++++---=
------------------
> =C2=A0include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
> =C2=A02 files changed, 147 insertions(+), 78 deletions(-)
>=C2=A0
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index e4a29829591a..66ccb87441ab 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -6,15 +6,6 @@
> =C2=A0#include <linux/iomap.h>
> =C2=A0#include "trace.h"
> =C2=A0
> -static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> -{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH)=
 {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0folio_batch_rele=
ase(iter->fbatch);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0folio_batch_rein=
it(iter->fbatch);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->iomap.flag=
s &=3D ~IOMAP_F_FOLIO_BATCH;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -}
> -
> =C2=A0/* Advance the current iterator position and decrement the remainin=
g length */
> =C2=A0int iomap_iter_advance(struct iomap_iter *iter, u64 count)
> =C2=A0{
> @@ -40,51 +31,28 @@ static inline void iomap_iter_done(struct iomap_iter =
*iter)
> =C2=A0}
> =C2=A0
> =C2=A0/**
> - * iomap_iter - iterate over a ranges in a file
> - * @iter: iteration structue
> - * @ops: iomap ops provided by the file system
> + * iomap_iter_continue - decide whether iteration should continue
> + * @iter: iteration structure
> + * @iomap: the mapping that was just processed
> + * @srcmap: the source mapping that was just processed
> =C2=A0 *
> - * Iterate over filesystem-provided space mappings for the provided file=
 range.
> + * Helper normally called via iomap_iter_next(). Called after the previo=
us
> + * mapping has been finished to determine whether there is more of the f=
ile
> + * range left to process.
> =C2=A0 *
> - * This function handles cleanup of resources acquired for iteration whe=
n the
> - * filesystem indicates there are no more space mappings, which means th=
at this
> - * function must be called in a loop that continues as long it returns a
> - * positive value. =C2=A0If 0 or a negative value is returned, the calle=
r must not
> - * return to the loop body. =C2=A0Within a loop body, there are two ways=
 to break out
> - * of the loop body: =C2=A0leave @iter.status unchanged, or set it to a =
negative
> - * errno.
> + * Returns 1 if there is more work to do, in which case @iomap and @srcm=
ap are
> + * cleared so the caller can produce the next mapping; zero if the range=
 is
> + * fully consumed; or a negative errno on error. Any folio batch attache=
d to
> + * the mapping is released before returning.
> =C2=A0 */
> -int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iom=
ap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *sr=
cmap, int ret)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0bool stale =3D iter->iomap.flags & IOMAP_F_S=
TALE;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t advanced;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 olen;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_iter(iter, ops, _RET_IP_);
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!iter->iomap.length)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto begin;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Calculate how far the iter was advanced a=
nd the original length bytes
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * for ->iomap_end().
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0advanced =3D iter->pos - iter->iter_start_po=
s;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0olen =3D iter->len + advanced;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops->iomap_end) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ops->iom=
ap_end(iter->inode, iter->iter_start_pos,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_length_trim(iter, iter->iter=
_start_pos,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0olen),
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0advanced, iter->flags, &iter->ioma=
p);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0 && !=
advanced)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0const bool stale =3D iomap->flags & IOMAP_F_=
STALE;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0const ssize_t advanced =3D iter->pos - iter-=
>iter_start_pos;
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0/* detect old return semantics where this wo=
uld advance */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ON_ONCE(iter->status > 0))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->status =3D=
 -EIO;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0 && !advanced)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Use iter->len to determine whether t=
o continue onto the next mapping.
> @@ -92,25 +60,58 @@ int iomap_iter(struct iomap_iter *iter, const struct =
iomap_ops *ops)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * advanced at all (i.e. no work was do=
ne for some reason) unless the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * mapping has been marked stale and ne=
eds to be reprocessed.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iter->status < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ON_ONCE(iter->status > 0))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* detect old re=
turn semantics where this would advance */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EIO;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (iter->status < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ite=
r->status;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (iter->len =3D=3D 0 || (!advanc=
ed && !stale))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D 1;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_clean_fbatch(iter);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->status =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0folio_batch_rele=
ase(iter->fbatch);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0folio_batch_rein=
it(iter->fbatch);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap->flags &=
=3D ~IOMAP_F_FOLIO_BATCH;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret <=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->iomap, 0, sizeof(iter->iomap))=
;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->srcmap, 0, sizeof(iter->srcmap=
));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(iomap, 0, sizeof(*iomap));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(srcmap, 0, sizeof(*srcmap));
> =C2=A0
> -begin:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ops->iomap_begin(iter->inode, iter->=
pos, iter->len, iter->flags,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iter->iomap, &iter->srcmap);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_done(iter);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +}
> +EXPORT_SYMBOL_GPL(iomap_iter_continue);
> +
> +/**
> + * iomap_iter - iterate over ranges in a file
> + * @iter: iteration structure
> + * @ops: iomap ops provided by the filesystem
> + *
> + * Iterate over filesystem-provided space mappings for the provided file=
 range.
> + *
> + * This function handles cleanup of resources acquired for iteration whe=
n the
> + * filesystem indicates there are no more space mappings, which means th=
at this
> + * function must be called in a loop that continues as long it returns a
> + * positive value. =C2=A0If 0 or a negative value is returned, the calle=
r must not
> + * return to the loop body. =C2=A0Within a loop body, there are two ways=
 to break out
> + * of the loop body: =C2=A0leave @iter.status unchanged, or set it to a =
negative
> + * errno.
> + */
> +int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_iter(iter, ops, _RET_IP_);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_iter_next(iter, &iter->iomap, =
&iter->srcmap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ops->iomap_begin, ops->iomap_end);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->status =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret > 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_done(=
iter);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3582ed1fe236..3df851d0f76b 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -212,24 +212,27 @@ struct iomap_write_ops {
> =C2=A0#define IOMAP_ATOMIC =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(1 << 9) /* torn-write protection */
> =C2=A0#define IOMAP_DONTCACHE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0(1 << 10)
> =C2=A0
> -struct iomap_ops {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Return the existing mapping at pos, or re=
serve space starting at
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * pos for up to length, as long as we can d=
o it as a single mapping.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * The actual length is returned in iomap->l=
ength.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*iomap_begin)(struct inode *inode, loff=
_t pos, loff_t length,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0unsigned flags, struct iomap *iomap,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct iomap *srcmap);
> +/*
> + * Return the existing mapping at pos, or reserve space starting at pos =
for up
> + * to length, as long as we can do it as a single mapping.
> + * The actual length is returned in iomap->length.
> + */
> +typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loff_t length, u=
nsigned flags, struct iomap *iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *sr=
cmap);
> =C2=A0
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Commit and/or unreserve space previous al=
located using iomap_begin.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Written indicates the length of the succe=
ssful write operation which
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * needs to be commited, while the rest need=
s to be unreserved.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Written might be zero if no data was writ=
ten.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*iomap_end)(struct inode *inode, loff_t=
 pos, loff_t length,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ssize_t written, unsigned flags, struct iomap *iomap);
> +/*
> + * Commit and/or unreserve space previously allocated by iomap_iter_begi=
n_fn.
> + * Written indicates the length of the successful write operation which =
needs
> + * to be committed, while the rest needs to be unreserved.
> + * Written might be zero if no data was written.
> + */
> +typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t=
 length,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t written,=
 unsigned flags, struct iomap *iomap);
> +
> +struct iomap_ops {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_begin_fn iomap_begin;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_end_fn iomap_end;
> =C2=A0};
> =C2=A0
> =C2=A0/**
> @@ -317,6 +320,71 @@ static inline const struct iomap *iomap_iter_srcmap(=
const struct iomap_iter *i)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return &i->iomap;
> =C2=A0}
> =C2=A0
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iom=
ap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *sr=
cmap, int ret);
> +
> +/**
> + * iomap_iter_next - finish the previous mapping and produce the next on=
e
> + * @iter: iteration structure
> + * @iomap: mapping to finish and then repopulate
> + * @srcmap: source mapping to finish and then repopulate
> + * @begin: callback that produces a mapping for the current position
> + * @end: optional callback that finishes the previous mapping, or NULL
> + *
> + * Inline helper that implements the common body of an ->iomap_next()
> + * callback: it finishes the previous mapping via @end (if present), dec=
ides
> + * via iomap_iter_continue() whether to keep going, and obtains the next
> + * mapping via @begin.
> + *
> + * This helper is marked __always_inline so that when a caller passes
> + * compile-time-constant @begin and @end callbacks, the compiler can cal=
l them
> + * directly, avoiding the indirect-call overhead.
> + *
> + * Returns 1 to continue iterating, 0 once the range is fully consumed, =
or a
> + * negative errno on error.
> + */
> +static __always_inline int iomap_iter_next(const struct iomap_iter *iter=
,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *io=
map, struct iomap *srcmap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_iter_begin=
_fn begin, iomap_iter_end_fn end)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomap->length) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (end) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 * Calculate how far the iter was advanced and the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 * original length bytes for end().
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ssize_t advanced =3D iter->pos - iter->iter_start_pos;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0loff_t len;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0len =3D iomap_length_trim(iter, iter->iter_start_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->=
len + advanced);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ret =3D end(iter->inode, iter->iter_start_pos, len,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0advanc=
ed, iter->flags, iomap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_it=
er_continue(iter, iomap, srcmap, ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret <=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return ret;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D begin(iter->inode, iter->pos, iter->=
len, iter->flags, iomap,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0srcmap);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret < 0 ? ret : 1;
> +}
> +
> +#define DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, end_fn) =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> +int name(const struct iomap_iter *iter, struct iomap *iomap, =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap *sr=
cmap) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> +{ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_iter_next(iter, iomap, srcmap, =
begin_fn, end_fn); =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> +}
> +
> +#define DEFINE_IOMAP_ITER_NEXT(name, begin_fn) =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, N=
ULL)
> +
> =C2=A0/*
> =C2=A0 * Return the file offset for the first unchanged block after a sho=
rt write.
> =C2=A0 *
> --=C2=A0
> 2.53.0
>=C2=A0
