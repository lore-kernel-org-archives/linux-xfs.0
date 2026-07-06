Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A10C3D7D67
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jul 2026 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783366056; cv=pass; b=Lx+ZZg6o7fgN93jFs4tn7T+dYsIrBuaagT3OLOX61/IoMLdTXzTGxV7yrLHuXLS4TovgRMgoR9NnQMqgZuuasxZu9QxmPNNWn651slSxPGGTqwlwNISPLzCn7aSRwBqM7mjWWB3hv+u7sISI9tdutCstIGgQ78Ov+49PxO7aGJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783366056; c=relaxed/simple;
	bh=UEp1H297s8BL6RXQN/cEh9zJy/urjediMCl/3GCsJfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=igMZjG5G15TXC6wYAp0yQ/qic/1in2ZoGE1XBX4YVhN3zjtD8umMT8+ydz6IC5z1pNDSgPqncNxbVHV0oQb8G8Akm/avv8LH9ky3uQ+6r3EMGUWfMTncaT9I6G/ihqI//jg3yve2BM15Zghv8XBfqNqSwAphJAsI3RDumYOZ7i4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZ7Aogcs; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZ7Aogcs"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47d70879764so1180784f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2026 12:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783366052; cv=none;
        d=google.com; s=arc-20260327;
        b=n6BDBUhcCb5YAJ3RWJVRdT3TW6yLQ5aQcmmcLS7FJfPQsoM3+JKNrDwxSoMCM3Rwa8
         D/JZfdVrbO2prxJS3l3gI2coR0wrA5Jgw6z0Ft0VQcdyDxsJWzrqrz452ju7FiZnJzav
         1Fgtrdalc3Eoq+cP5z+KVioAhQuBOCbSirJs3U/KLETQ+XOosTJIyaO060wcyQdhpQxj
         /LUT2o6SlmRvwpiqxradyC4CdrLmnSy0yBhgJ+R1+jT8aTEr7YkRTP0j51bDCui69fSE
         E60yUdXl4HpXk6wP9QYJbtN6WRlm0bdTMmoDm3vq3TV+yO2C33WdtQfvXup/4Y4jWnRT
         sxqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iyQHcU6V6Cxqv2PDXzv1or+GFLINi1F+iyT8k1hYsa0=;
        fh=lZrcGV53QWBijF3pRviLS7wOQtKgki11Amy//cm/Ftg=;
        b=M2Co45RZowlEXelDm+ZM2qjXu8PB3QQ2SQ8NXd8MvmI4uxFBJcUq0wEhJqvE7AvkW1
         zOuhhjB4349Yes/V4xuK7pzvD9gNYQzhNPKy0RiFp88kpaGLcS6/YK+nI/tprCbOIdzS
         YiZ2CFF7w0EnDBjVYC8O5W1fMGcDbz0KpmLAHi0VR7mBsat8xcS8LYRINt+5kZpJsq7h
         b2zrVTJBlSPoDpVbs/yPzcd/WbeB6l2L3BsN1s9wEYzVgloKoTAoNw2QkP+7tEShZB40
         /V3Q79BDr3JMVyng4traljv/gimHk0ERxN4mgrN0oseCzDpRbdcp6ziXsftP5+G6PzPb
         BP/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783366052; x=1783970852; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iyQHcU6V6Cxqv2PDXzv1or+GFLINi1F+iyT8k1hYsa0=;
        b=MZ7AogcswF4Njo8VlaKLqkHLaVTzqkHUouDQymedsXaZmXiwNaYf2F1GrUz1LW2UJm
         i452/LX5gX1hY0dEuRIaLQWxkku5q9ringgByhjXHUGKf0Qsv5HYRr5QLK9Oh6/L49w6
         YjcV+FaD4BnryQg6fc137M1BOcfFQRXLAc+TeshRTWUhn5lYUVHqdJOgolJvEq/5Zae8
         MAjgQ37AXpUMhwKxzHMTn8SiBq3HhAneEG/mBhHNK/Pt6DCzP5G8M1XHdLMj0h3SHeU7
         5mGtW/UlKWv4mpPoG7AwrrNiXP3BYVS/3HyXU+iI7snxvsb2UYT3JHqw13/WgsAw+OHR
         2GCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783366052; x=1783970852;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyQHcU6V6Cxqv2PDXzv1or+GFLINi1F+iyT8k1hYsa0=;
        b=cfM3t7CaXbcmrhk5NdHwSBcrOM12FGoS0mMhyLcXfNOYsbOFcMwt77y9O9XQ7BycLg
         jYNpFFUo8s0F4w+BtM/lAWq5yO+zntXnra5tZy3zSIOiFKLWcj1tpvlCqH2ISh1RlM/3
         ZdnNx+J5tydYyTn1tX2F+J8muRpO11eonSL0LiUDaXmF7o62hVFthSozCi7XW2eMNeUr
         T3OLBU5EhqwQUd0qaJS6QZLs/fT2l7UU2MgS5blyNshzYhPDWtHC8p/xD8mXH2xMZU3f
         Qbx8/OlyTl5nswx0nAY2JV8K9VbUG7DhDdA9ZYvD+1mgdQPlz6RXA+e7BTwBSciJ6cHW
         uXtA==
X-Forwarded-Encrypted: i=1; AHgh+RodFtECzfbyYfcl5UZowHbrAkJyWwGw43f0WuxorOQm18Ht+lC4mqIfycgG16hXhfUbBW48nwIg8f0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwigGnfdYXcHmEQzE2fRFlWuOaaOt0VBrFEyOJqnTi4Mcn1dMsD
	sm5QLntAmg0oc1DK+zmhhPlqTL5FDbQZW6pqFV9IUwEAAd/Mfo+0stk8Lfs+V4gz5yJrStUEFNj
	VAS6VrAHyIi9TbIfgC88MwlWWB0D7zts=
X-Gm-Gg: AfdE7cmL13QQgN+kXs/45kdhDDIALHieKmTIJdrddIAFlcTCpkhxHdsHHc61a3d5Nfq
	JlQbDDPrcieY3q8tg053eNfNnAstBpRsuOiydw28Xd3e+R4lcTLLmICghdBh9AShJv1IOuwT8vC
	ORM2BHqRezH4fjc4ybPLqD5a/f4Nwo5OWlHTQKAKZI/9044oGwB/xhIP8cH+1DWARKi1D/VOA5k
	nH3NBk5XeRfu28lVNhyuG3ncKYAXxE2UH1TBo3dPNKz6xdNMoQXvbCeQtt/3d0kIYvb3kSdKUda
	527xb+Fz7RWMbknNLLapyPw7SvNYI/uz2ilh2OnaD6yEO28mbJsJ
X-Received: by 2002:a05:600c:3e1b:b0:493:bd66:3efb with SMTP id
 5b1f17b1804b1-493df09601dmr20498655e9.29.1783366052372; Mon, 06 Jul 2026
 12:27:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
 <akZ3GErzJSTtOn-H@infradead.org> <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com>
 <akettUm5gBD8nj56@infradead.org> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.a1148d7a.4a0d.4c6a.b14d.4583b6b728ce@bytedance.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 6 Jul 2026 12:27:19 -0700
X-Gm-Features: AVVi8Cep-qYKB7UFrbHJ6w1Ew_1ghih7o438HvX1-Pe_dluBLItJigcVM8wP9QA
Message-ID: <CAJnrk1avS6qra8OvJdbexqM0xGT-FVZxVKe+TH4ZkFgfFv_oEQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: changfengnan <changfengnan@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner <brauner@kernel.org>, djwong <djwong@kernel.org>, 
	ojaswin <ojaswin@linux.ibm.com>, dgc <dgc@kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	lidiangang@bytedance.com, "pankaj.raghav" <pankaj.raghav@linux.dev>, 
	Brian Foster <bfoster@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 6, 2026 at 4:10=E2=80=AFAM changfengnan <changfengnan@bytedance=
.com> wrote:
>
> > From: "Christoph Hellwig"<hch@infradead.org>
> > Date:  Fri, Jul 3, 2026, 20:40
> > Subject:  Re: [PATCH v6 3/3] iomap: add simple dio path for small direc=
t I/O
> > To: "changfengnan"<changfengnan@bytedance.com>
> > Cc: "Joanne Koong"<joannelkoong@gmail.com>, "Christoph Hellwig"<hch@inf=
radead.org>, "brauner"<brauner@kernel.org>, "djwong"<djwong@kernel.org>, "o=
jaswin"<ojaswin@linux.ibm.com>, "dgc"<dgc@kernel.org>, "linux-xfs"<linux-xf=
s@vger.kernel.org>, "linux-fsdevel"<linux-fsdevel@vger.kernel.org>, "linux-=
ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kernel.=
org>, <lidiangang@bytedance.com>, "pankaj.raghav"<pankaj.raghav@linux.dev>,=
 "Brian Foster"<bfoster@redhat.com>
> > On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> > > taken, which introduced some overhead.
> > > I implemented some optimizations based on Christoph=E2=80=99s suggest=
ions and
> > > made some modifications to `iomap_process`;
> > > Now, XFS performance is essentially unchanged, while ext4 still shows=
 a
> > > 1.5% drop; I will continue to investigate the cause..   I=E2=80=99ve =
attached the patch.
> > > Actually, I had expected that switching to `iomap_next` would improve
> > > performance, since it avoids an indirect call.
> >
> > I don't think it will for you - the direct I/O readers don't have
> > iomap_end methods, so you still have the same number of indirect
> > calls.  What could help is to inline the iterator as seen in Joannes'
> > fist demo series.  We could even look into doing that only for simple
> > dio in a first step, shifting the burden to use the simple method
> > to the callers (at least for the POC).
>
> I'm not sure if this is what you had in mind, but I made some
> adjustments referencing Joannes' first patch, and using this approach,
> there was no performance degradation.

Thanks, Fengnan. This is awesome that it got the degradation down to zero.

Would you be able to test how this change performs on your benchmarks?:

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index dbe073e181a7..bf0c18cf1017 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,8 @@ static ssize_t ext4_dio_read_iter(struct kiocb
*iocb, struct iov_iter *to)
                return generic_file_read_iter(iocb, to);
        }

-       ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NULL, 0, NULL, 0);
+       ret =3D iomap_dio_rw(iocb, to, ext4_iomap_next, NULL,
+                          IOMAP_DIO_NO_IOMAP_END, NULL, 0);
        inode_unlock_shared(inode);

        file_accessed(iocb->ki_filp);
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bcd3d4223464..bc3b87e57592 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -968,115 +968,38 @@ static void iomap_dio_simple_end_io(struct bio *bio)
        iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
 }

-static inline bool
-iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
-                          const struct iomap_dio_ops *dops,
-                          unsigned int dio_flags, size_t done_before)
+static inline void
+iomap_dio_simple_finish(struct iomap_iter *iomi, iomap_next_fn iomap_next,
+               size_t written)
 {
-       struct inode *inode =3D file_inode(iocb->ki_filp);
-       size_t count =3D iov_iter_count(iter);
-
-       if (dops || done_before)
-               return false;
-       if (iov_iter_rw(iter) !=3D READ)
-               return false;
-       if (!count)
-               return false;
-       /*
-        * Simple dio is an optimization for small IO. Filter out large IO
-        * early as it's the most common case to fail for typical direct IO
-        * workloads.
-        */
-       if (count > inode->i_sb->s_blocksize)
-               return false;
-       if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
-                        IOMAP_DIO_BOUNCE))
-               return false;
-       if (iocb->ki_pos + count > i_size_read(inode))
-               return false;
-       if (IS_ENCRYPTED(inode))
-               return false;
-
-       return true;
+       iomi->iter_start_pos =3D iomi->pos;
+       iomi->pos +=3D written;
+       iomi->len -=3D written;
+       iomap_next(iomi, &iomi->iomap, &iomi->srcmap);
 }

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
- * allocated from the filesystem-private @dops->bio_set (whose
front_pad sizes a
- * filesystem-private wrapper around the bio).  The fast path instead allo=
cates
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
- * I/O, or bouncing.  The range must also stay within i_size and encrypted
- * inodes must use the generic iomap direct I/O path.
- *
- * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
- * decides the request does not fit the fast path.  In that case we procee=
d to
- * the generic __iomap_dio_rw() slow path.  Any other errno is a real
result and
- * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach t=
he
- * caller.
- */
-static ssize_t
-iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
-                iomap_next_fn iomap_next, void *private,
-                unsigned int dio_flags)
+ssize_t
+__iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
+               struct iomap_iter *iomi, iomap_next_fn iomap_next,
+               unsigned int dio_flags)
 {
        struct inode *inode =3D file_inode(iocb->ki_filp);
        size_t count =3D iov_iter_count(iter);
        bool wait_for_completion =3D is_sync_kiocb(iocb);
-       struct iomap_iter iomi =3D {
-               .inode          =3D inode,
-               .pos            =3D iocb->ki_pos,
-               .len            =3D count,
-               .flags          =3D IOMAP_DIRECT,
-               .private        =3D private,
-       };
        struct iomap_dio_simple *sr;
        unsigned int alignment;
        struct bio *bio;
        ssize_t ret;

-       if (iocb->ki_flags & IOCB_NOWAIT)
-               iomi.flags |=3D IOMAP_NOWAIT;
-
-       ret =3D kiocb_write_and_wait(iocb, count);
-       if (ret)
-               return ret;
-
-       inode_dio_begin(inode);
-
-       ret =3D iomap_iter(&iomi, iomap_next);
-       if (ret <=3D 0) {
-               inode_dio_end(inode);
-               return ret ? ret : -EFAULT;
-       }
-
-       if (iomi.iomap.type !=3D IOMAP_MAPPED ||
-           iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
-           (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
+       if (iomi->iomap.type !=3D IOMAP_MAPPED ||
+           iomi->iomap.offset + iomi->iomap.length < iomi->pos + count ||
+           (iomi->iomap.flags & IOMAP_F_INTEGRITY)) {
                ret =3D -ENOTBLK;
                goto out_iomap_end;
        }

-       alignment =3D iomap_dio_alignment(inode, iomi.iomap.bdev, dio_flags=
);
-       if ((iomi.pos | count) & (alignment - 1)) {
+       alignment =3D iomap_dio_alignment(inode, iomi->iomap.bdev, dio_flag=
s);
+       if ((iomi->pos | count) & (alignment - 1)) {
                ret =3D -EINVAL;
                goto out_iomap_end;
        }
@@ -1092,14 +1015,14 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
        if (user_backed_iter(iter))
                dio_flags |=3D IOMAP_DIO_USER_BACKED;

-       bio =3D bio_alloc_bioset(iomi.iomap.bdev,
+       bio =3D bio_alloc_bioset(iomi->iomap.bdev,
                               bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
                               REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_p=
ool);
        sr =3D container_of(bio, struct iomap_dio_simple, bio);
        sr->iocb =3D iocb;
        sr->dio_flags =3D dio_flags;

-       bio->bi_iter.bi_sector =3D iomap_sector(&iomi.iomap, iomi.pos);
+       bio->bi_iter.bi_sector =3D iomap_sector(&iomi->iomap, iomi->pos);
        bio->bi_ioprio =3D iocb->ki_ioprio;

        ret =3D bio_iov_iter_get_pages(bio, iter, alignment - 1);
@@ -1124,8 +1047,8 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
                WRITE_ONCE(iocb->private, bio);
        }

-       iomap_iter_advance(&iomi, count);
-       iomap_iter(&iomi, iomap_next);
+       if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END))
+               iomap_dio_simple_finish(iomi, iomap_next, count);

        if (!wait_for_completion) {
                bio->bi_end_io =3D iomap_dio_simple_end_io;
@@ -1142,33 +1065,12 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
 out_bio_put:
        bio_put(bio);
 out_iomap_end:
-       iomap_iter(&iomi, iomap_next);
+       if (!(dio_flags & IOMAP_DIO_NO_IOMAP_END))
+               iomap_dio_simple_finish(iomi, iomap_next, 0);
        inode_dio_end(inode);
        return ret;
 }
-
-ssize_t
-iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-               iomap_next_fn iomap_next, const struct iomap_dio_ops *dops,
-               unsigned int dio_flags, void *private, size_t done_before)
-{
-       struct iomap_dio *dio;
-       ssize_t ret;
-
-       if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags,
-                                      done_before)) {
-               ret =3D iomap_dio_simple(iocb, iter, iomap_next,
private, dio_flags);
-               if (ret !=3D -ENOTBLK)
-                       return ret;
-       }
-
-       dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dops, dio_flags, pri=
vate,
-                            done_before);
-       if (IS_ERR_OR_NULL(dio))
-               return PTR_ERR_OR_ZERO(dio);
-       return iomap_dio_complete(dio);
-}
-EXPORT_SYMBOL_GPL(iomap_dio_rw);
+EXPORT_SYMBOL_GPL(__iomap_dio_simple);

 static int __init iomap_dio_init(void)
 {
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 984045af310a..1128f5b526ef 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -89,9 +89,6 @@ int iomap_iter_continue(const struct iomap_iter
*iter, struct iomap *iomap,
        bool stale =3D iomap->flags & IOMAP_F_STALE;
        ssize_t advanced =3D iter->pos - iter->iter_start_pos;

-       if (!iomap->length)
-               return 1;
-
        /*
         * Use iter->len to determine whether to continue onto the next map=
ping.
         * Explicitly terminate on error status or if the current iter has =
not
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index e1ea8392cf47..e43ca419b13a 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -127,7 +127,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
        {IOMAP_DIO_FORCE_WAIT,          "DIO_FORCE_WAIT" }, \
        {IOMAP_DIO_OVERWRITE_ONLY,      "DIO_OVERWRITE_ONLY" }, \
        {IOMAP_DIO_PARTIAL,             "DIO_PARTIAL" }, \
-       {IOMAP_DIO_FSBLOCK_ALIGNED,     "DIO_FSBLOCK_ALIGNED" }
+       {IOMAP_DIO_FSBLOCK_ALIGNED,     "DIO_FSBLOCK_ALIGNED" }, \
+       {IOMAP_DIO_NO_IOMAP_END,        "DIO_NO_IOMAP_END" }

 DECLARE_EVENT_CLASS(iomap_class,
        TP_PROTO(struct inode *inode, struct iomap *iomap),
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a987ffbf3c02..6a551efff66f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -251,7 +251,7 @@ xfs_file_dio_read(
        struct iov_iter         *to)
 {
        struct xfs_inode        *ip =3D XFS_I(file_inode(iocb->ki_filp));
-       unsigned int            dio_flags =3D 0;
+       unsigned int            dio_flags =3D IOMAP_DIO_NO_IOMAP_END;
        const struct iomap_dio_ops *dio_ops =3D NULL;
        ssize_t                 ret;

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3b41f123a92d..6213a3b1a0b9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -10,6 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
 #include <linux/folio_batch.h>
+#include <linux/pagemap.h>

 struct address_space;
 struct fiemap_extent_info;
@@ -605,15 +606,136 @@ struct iomap_dio_ops {
  */
 #define IOMAP_DIO_BOUNCE               (1 << 4)

-ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
-               iomap_next_fn iomap_next, const struct iomap_dio_ops *dops,
-               unsigned int dio_flags, void *private, size_t done_before);
+/* optimization hint for the simple fast path */
+#define IOMAP_DIO_NO_IOMAP_END         (1 << 5)
+
 struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter=
,
                iomap_next_fn iomap_next, const struct iomap_dio_ops *dops,
                unsigned int dio_flags, void *private, size_t done_before);
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 void iomap_dio_bio_end_io(struct bio *bio);

+static inline bool
+iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
+                          const struct iomap_dio_ops *dops,
+                          unsigned int dio_flags, size_t done_before)
+{
+       struct inode *inode =3D file_inode(iocb->ki_filp);
+       size_t count =3D iov_iter_count(iter);
+
+       if (dops || done_before)
+               return false;
+       if (iov_iter_rw(iter) !=3D READ)
+               return false;
+       if (!count)
+               return false;
+       if (count > inode->i_sb->s_blocksize)
+               return false;
+       if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
+                        IOMAP_DIO_BOUNCE))
+               return false;
+       if (iocb->ki_pos + count > i_size_read(inode))
+               return false;
+       if (IS_ENCRYPTED(inode))
+               return false;
+       return true;
+}
+
+ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
+               struct iomap_iter *iomi, iomap_next_fn iomap_next,
+               unsigned int dio_flags);
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
+ * allocated from the filesystem-private @dops->bio_set (whose
front_pad sizes a
+ * filesystem-private wrapper around the bio).  The fast path instead allo=
cates
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
+ * I/O, or bouncing.  The range must also stay within i_size and encrypted
+ * inodes must use the generic iomap direct I/O path. IOMAP_DIO_NO_IOMAP_E=
ND is
+ * a fast-path optimization the caller can set if there is no work
that needs to
+ * be done after a mapping.
+ *
+ * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
+ * decides the request does not fit the fast path.  In that case we procee=
d to
+ * the generic __iomap_dio_rw() slow path.  Any other errno is a real
result and
+ * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach t=
he
+ * caller.
+ */
+static __always_inline ssize_t
+iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
+               iomap_next_fn iomap_next, void *private, unsigned int dio_f=
lags)
+{
+       struct inode *inode =3D file_inode(iocb->ki_filp);
+       size_t count =3D iov_iter_count(iter);
+       struct iomap_iter iomi =3D {
+               .inode          =3D inode,
+               .pos            =3D iocb->ki_pos,
+               .len            =3D count,
+               .flags          =3D IOMAP_DIRECT,
+               .private        =3D private,
+       };
+       ssize_t ret;
+
+       if (iocb->ki_flags & IOCB_NOWAIT)
+               iomi.flags |=3D IOMAP_NOWAIT;
+
+       ret =3D kiocb_write_and_wait(iocb, count);
+       if (ret)
+               return ret;
+
+       inode_dio_begin(inode);
+
+       ret =3D iomap_next(&iomi, &iomi.iomap, &iomi.srcmap);
+       if (ret <=3D 0) {
+               inode_dio_end(inode);
+               /* a zero return means no mapping, which should never happe=
n */
+               return ret ? ret : -EFAULT;
+       }
+
+       return __iomap_dio_simple(iocb, iter, &iomi, iomap_next, dio_flags)=
;
+}
+
+static __always_inline ssize_t
+iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, iomap_next_fn
iomap_next,
+               const struct iomap_dio_ops *dops, unsigned int dio_flags,
+               void *private, size_t done_before)
+{
+       struct iomap_dio *dio;
+       ssize_t ret;
+
+       if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags,
done_before)) {
+               ret =3D iomap_dio_simple(iocb, iter, iomap_next, private,
+                               dio_flags);
+               if (ret !=3D -ENOTBLK)
+                       return ret;
+       }
+
+       dio =3D __iomap_dio_rw(iocb, iter, iomap_next, dops, dio_flags, pri=
vate,
+                            done_before);
+       if (IS_ERR_OR_NULL(dio))
+               return PTR_ERR_OR_ZERO(dio);
+       return iomap_dio_complete(dio);
+}
+
 #ifdef CONFIG_SWAP
 struct file;
 struct swap_info_struct;
@@ -678,21 +800,22 @@ static __always_inline int iomap_process(const
struct iomap_iter *iter,
 {
        int ret =3D 0;

-       if (iomap->length && end) {
-               ssize_t advanced =3D iter->pos - iter->iter_start_pos;
-               loff_t len;
+       if (iomap->length) {
+               if (end) {
+                       ssize_t advanced =3D iter->pos - iter->iter_start_p=
os;
+                       loff_t len;

-               len =3D iomap_length_trim(iter, iter->iter_start_pos,
-                               iter->len + advanced);
+                       len =3D iomap_length_trim(iter, iter->iter_start_po=
s,
+                                       iter->len + advanced);

-               ret =3D end(iter->inode, iter->iter_start_pos, len, advance=
d,
-                               iter->flags, iomap);
+                       ret =3D end(iter->inode, iter->iter_start_pos,
len, advanced,
+                                       iter->flags, iomap);
+               }
+               ret =3D iomap_iter_continue(iter, iomap, srcmap, ret);
+               if (ret <=3D 0)
+                       return ret;
        }

-       ret =3D iomap_iter_continue(iter, iomap, srcmap, ret);
-       if (ret <=3D 0)
-               return ret;
-
        ret =3D begin(iter->inode, iter->pos, iter->len, iter->flags, iomap=
,
                        srcmap);

I put the changes in a git tree [1] in case that's is more convenient
for you. I think this ends up devirtualizing the iomap_next callback:

before:
$ objdump -dr fs/xfs/xfs.ko | awk '/<xfs_file_dio_read>:/{f=3D1}
f{print} f&&/^$/{exit}'  | grep -E 'iomap_next|iomap_begin|thunk'
                          a9ac3: R_X86_64_PLT32   __x86_return_thunk-0x4
                          a9b4b: R_X86_64_32S     xfs_read_iomap_next
                          a9b9c: R_X86_64_PLT32   __x86_return_thunk-0x4

after:
$ objdump -dr fs/xfs/xfs_iomap_next_inlined.ko | awk
'/<xfs_file_dio_read>:/{f=3D1} f{print} f&&/^$/{exit}' | grep -E
'iomap_next|iomap_begin|thunk'
                          aa083: R_X86_64_PLT32   __x86_return_thunk-0x4
                          aa1d4: R_X86_64_PLT32   xfs_read_iomap_next-0x4
                          aa1ec: R_X86_64_32S     xfs_read_iomap_next
                          aa232: R_X86_64_32S     xfs_read_iomap_next


I was unsure how much bloat this adds but I didn't see a noticable
impact when I ran ./scripts/bloat-o-meter:

$ ./scripts/bloat-o-meter fs/xfs/xfs.ko fs/xfs/xfs_iomap_next_inlined.ko
add/remove: 0/0 grow/shrink: 11/1 up/down: 589/-4 (585)
Function                                     old     new   delta
xfs_file_dio_read                            309     685    +376
xfs_file_dio_write_aligned                   355     402     +47
xfs_file_dio_write_unaligned                 545     591     +46
xfs_file_dio_write_atomic                    457     502     +45
xfs_dax_write_iomap_next                     267     291     +24
xfs_atomic_write_cow_iomap_next             1151    1175     +24
xfs_zoned_direct_write_iomap_next            217     224      +7
xfs_direct_write_iomap_next                   77      84      +7
xfs_buffered_write_iomap_next                373     379      +6
xfs_xattr_iomap_next                         360     365      +5
xfs_seek_iomap_next                          665     667      +2
xfs_read_iomap_next                          681     677      -4
Total: Before=3D1977941, After=3D1978526, chg +0.03%

where the baseline xfs.ko was built at the commit in [2] and the
xfs_iomap_next_inlined.ko was built at the commit in [3].  If these
changes are acceptable to you, then I'll put this into v3 of the
iomap_next series.

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commits/iomap_simple_dio_iomap_nex=
t/
[2] https://github.com/joannekoong/linux/commit/1e82c8988ee56e9e7202d5ee09c=
7f7ea7ac7a832
[3] https://github.com/joannekoong/linux/commit/86ecc9de53bb1b8b1287950fbb7=
45a5a8e49f736
