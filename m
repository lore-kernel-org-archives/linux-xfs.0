Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8821C470E86
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747047; cv=pass; b=spONlomSufglgF8yba19liTriodOsx8kbp7xPkdXR3dCtU+EaDRczOTYEXI0GcEYRTB49cq/G6AvNnMDyfeV8FkZBt79L3SZyPw4rLDPUj806Ck5ppugR0Yq7wHNJ65pvWTy+FAXz6sCUqzqYb50WUIzDk+swtXqJyb3MbIvbXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747047; c=relaxed/simple;
	bh=RjR3jQi2gBsgZVeOwgl8/wj7aZVnQ+rqU4nHfVrQhFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8M1G30eN1WH9h+Ukz4GbAgF2JMJcz62Ln8hKnJf4WR+NK1gyeM+MgLB+8+0ymKeEF6xpVM7pQbf0m9QGtw83ByznjjlyaREJ6B26l4jmCgcPrGyJ+XJH+ZlZ8qWrE6ImPlcrJP6IR7J87V36OdGijGJ7lNXsBtL5lHW1kt7wQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ix/ullMc; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ix/ullMc"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4956242332dso30682925e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 12:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784747044; cv=none;
        d=google.com; s=arc-20260327;
        b=itgM3YCR9FUUARVdLLLqmnXpCGenZPT5kKOHBLbdiViDhY37e25SOYIuY6rsvzTAHo
         BVI5XzGnRRI3vVau4NFZbi730Q2RfnnVMiJQUNsC3YM0HKkyKwGmVjn357jNj/YXHauI
         X+M8vwnN59zLm1ro2XWe1iYXh3VX8j4ymwpKRZn4VCVjgOp1GzqnjK0AFS9l4Qef9NxF
         d2zrH+bA6WgDZEHnBvO8qakpxYIAu4TpakMSWwSAly2B1eJoNse35ocXkRzsMvGv35Zk
         k5AdWbGPpgWBmkmsCjJpc/UrO/5DgNCMdjIq6kZWZboDHiinax2NRvRMZU9zME51JyfX
         tGaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C2LthnWkKVdjJeBPBoDYS9yBolahYPpf7Sa0W7ibrK4=;
        fh=fAol7NLqPNPOZSLmccd4CJgvD009nGO+lTJM2QaO4ao=;
        b=jgtxzmTnwGWJmhxZCplH7hN3evjbZCeBCovqlOPqCUa6J+bf+jmV+EKcLkHb3TuA5V
         qYdnjp8UJZLZlTRtHGBEdK+mwAXZ8YtY+n3aFLvlIk5opIOvFqMGM9ngojMuFEzIVe37
         x/NdBBRJl9aCjBaq8I2cxbS42Ml2ClLs+fUnprrhQv1UrN9svgtuURYJ8vLrQvdc64YG
         xVpqMFre7orYgh4RZojzgssBkeVzuJ/zdAcLK4ZvZ0Qa6XgRIedPBAyZZpsfCxazwvfK
         LzEek8xZmT83hOCFQVDgzs1YVBcnnt/rYrl5H6HL5NvPK2vMINMe3uqtCkdmwOXFUt39
         mMCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784747044; x=1785351844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C2LthnWkKVdjJeBPBoDYS9yBolahYPpf7Sa0W7ibrK4=;
        b=ix/ullMcBoPPWF5e3ADzkZ+IywKoLmDjmefKgC8K00BRAsAajwslVRnKhHQfJwxHV1
         1JUxzvEx9uB8hUf2B1hjs0irEM9F0DiPPBaY0zndY+K9Obv7SrvPX8czdBRy31jrapxH
         78eEVQ32fNVxAdq3ERdTt29gFlUPQsSc4GE156RUSpAwjYtKz9cYbcx2NWLMDIzgYkYO
         YD8pYeAA9u0c3l4s8uHovb3vJiJ1B9WypCtxmRZcT64ooWBw86zoqh7o6okWyNpdDDqu
         3rnGkfbHlr+UWUTl+86Or3aIU0dMPy5rkc/9zeWOoQLXQyOnPnQBJzL1Yg1MQ1LV02hS
         jh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784747044; x=1785351844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C2LthnWkKVdjJeBPBoDYS9yBolahYPpf7Sa0W7ibrK4=;
        b=pPuzElaalBwHKZIAgZN8TADUJM4CyY+GVXhd6+7/5orj/aQcgzsHCbSnFD+m4xjQst
         gUPVhIOoZo1uvBQXNpCuGg0V9Jt+FKuJLvDxxdLtMEy1n6SDPC6hktPyWVynoZUC14Ci
         Xcrw6t8ky3vbceW/L9VD5inFZt2VdH1fiWvzvVs87Cm7Pe9kf7dWK2YOXqWj0Loc552S
         /uB7MYFS2jOpQBsaczfhfGLMq7VV1gRgGxtuGeILIT3NbGDULQ+TPnky010t5n3faJIw
         mjwImvnAKtZhqdMDaCyZ2oKdA0OmMqCJTdUwnFQKhaUH0g2I3jXO6JPMMrK3TiGTtTvj
         83/g==
X-Forwarded-Encrypted: i=1; AHgh+RqSaar/BadhGHtKeki8RZclUs7Tl27EY6qXJXym6DqtryGMV/pd+NOOIX3T17Cn4cFOgyzCwmyq69w=@vger.kernel.org
X-Gm-Message-State: AOJu0YytPaKjJ6HZ0EFEc+16/gvKvqJcyejSl/jvT/Qn2WLgWeTl2FQb
	M1ipEW/50yIHTyAJ4PXBsEo16unLxvusl+d+T0g2bc3CDhY7J0L37YO8AuL7IFdxAntpzETvDxm
	njyF7DQaAIJfVctYh7vfIM9gvmIoXNVk=
X-Gm-Gg: AR+sD12/lEkg0RgHibcjCEeA/OmYPU8khQ8EbGOT+tG1Lz+S5B/FGndY7KXLrAh0qD8
	GrXviTUXp/GqlOsw8wyI9S2qyBFiKVa2VWVijNyVzZyVd3be4vlLYC/AA648zLoBISA1Yr/eI+t
	h4W/MpvEhJuBqxVk4WCHz5JKvBSoYOflV6IFCRBy165cUgEtM3+6f/ug7qli+dAqC9/zgp5enQf
	vnR4PuNxZlwe6ywCVUVpzfslJUJsbTPxfT+kXIhVJxG/AvioWcIRLtSayb2u+H5eJ2X52p8CQ/T
	kVd5rx0/bJSmx97gzrV9vdgim2D/GIGu5zX7K/tVXQ==
X-Received: by 2002:a05:600c:6dd6:b0:493:eed4:7210 with SMTP id
 5b1f17b1804b1-49573cc97c2mr12295e9.11.1784747043588; Wed, 22 Jul 2026
 12:04:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-3-hch@lst.de>
In-Reply-To: <20260722124931.3159664-3-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 22 Jul 2026 12:03:49 -0700
X-Gm-Features: AUfX_mxCN-UiJvZqNWKKnJg-a9PvQboW-uvuAIlNOX_o9tC053nEiX26K1BE1v8
Message-ID: <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from iomap_dio_rw
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, "Darrick J. Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> The pending iomap_iter_next conversion creates performance issues for the
> new simple direct I/O read fast path, because it assumes a model where
> the iterator must be advanced at the end, which the direct I/O read fast
> path tries to avoid.
>
> Side step this by splitting the simple path from iomap_dio_rw, and
> require the file systems to call into it explicitly, and pass only a
> ->begin callback.  This allows to drop various checks for incompatible
> features while creating a requirement for the file system to only call
> the simple path for cases that it can handle.

Nice, this approach looks cleaner to me.

>
> As a side-benefit we can now inline the initial part of the simple
> direct I/O read fast path and let the compiler convert the indirect call
> to ->begin into a direct call.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ext4/ext4.h        |   3 +
>  fs/ext4/file.c        |   4 +-
>  fs/ext4/inode.c       |   2 +-
>  fs/iomap/direct-io.c  | 209 ++++++++++--------------------------------
>  fs/xfs/xfs_file.c     |  14 +--
>  fs/xfs/xfs_iomap.c    |   2 +-
>  fs/xfs/xfs_iomap.h    |   4 +
>  include/linux/iomap.h |  65 +++++++++++++
>  8 files changed, 133 insertions(+), 170 deletions(-)
>
> index 3df851d0f76b..810dc4b8dc94 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
>
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
> + * -ENOTBLK inidicates the generic path must be used by the caller inste=
ad.
> + * Any other errno is a real result and is propagated as-is, in particul=
ar
> + * -EAGAIN for IOCB_NOWAIT must reach the caller.
> + *
> + * The caller can only provide an iomap begin handler, and the iterator
> + * is never advanced.
> + */
> +ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> +               struct iomap_iter *iomi);

Might be nice to have _read_ in this name as well, eg __iomap_dio_read_simp=
le

> +static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
> +               struct iov_iter *iter, iomap_iter_begin_fn begin)
> +{
> +       struct iomap_iter iomi =3D {
> +               .inode          =3D file_inode(iocb->ki_filp),
> +               .pos            =3D iocb->ki_pos,
> +               .len            =3D iov_iter_count(iter),
> +               .flags          =3D IOMAP_DIRECT,
> +       };
> +       ssize_t ret;
> +
> +       if (!iomi.len)
> +               return 0;
> +
> +       /*
> +        * Simple dio is an optimization for small IO. Filter out large I=
O
> +        * early as it's the most common case to fail for typical direct =
IO
> +        * workloads.
> +        */
> +       if (iomi.len > iomi.inode->i_sb->s_blocksize)
> +               return -ENOTBLK;
> +       if (iocb->ki_pos + iomi.len > i_size_read(iomi.inode))
> +               return -ENOTBLK;
> +       if (IS_ENCRYPTED(iomi.inode))
> +               return -ENOTBLK;
> +
> +       ret =3D kiocb_write_and_wait(iocb, iomi.len);
> +       if (ret)
> +               return ret;
> +
> +       if (iocb->ki_flags & IOCB_NOWAIT)
> +               iomi.flags |=3D IOMAP_NOWAIT;
> +
> +       inode_dio_begin(iomi.inode);
> +       ret =3D begin(iomi.inode, iomi.pos, iomi.len, iomi.flags, &iomi.i=
omap,
> +                       &iomi.srcmap);
> +       if (!ret)
> +               ret =3D __iomap_dio_simple(iocb, iter, &iomi);
> +       if (ret <=3D 0 && ret !=3D -EIOCBQUEUED)
> +               inode_dio_end(iomi.inode);

afaict, the inode_dio_end() error handling has to be done by
__iomap_dio_simple() to properly account for the synchronous case. I
ran into this earlier when doing the iomap_next_fn inlining. For the
synchronous case, __iomap_dio_simple() calls
iomap_dio_simple_complete() which calls inode_dio_end() even on
errors.

Thanks,
Joanne

> +       return ret;
> +}
