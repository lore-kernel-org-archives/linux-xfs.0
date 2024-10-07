Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBE576036
	for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2024 05:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728279385; cv=none; b=CO9LJG24McS/SxeWJr9xPn4CCmcg+PLM+AKqrOkn/Uu42sEmkVhHczh73cbpIfbqddk2L5oVcR7uuyRWXjlxh1DPNvayYzvmTTnmDbqRAEN1Oj2zj6hUPN8lck4gvoIeevEKalxFFobBBZ75x8HJSQzt0rz8CfMw4wFvtOMba1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728279385; c=relaxed/simple;
	bh=KRPdGFwAaLkfIeM+qmukKMdUHAF5E5Hwn30K03RYcFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nf2v4qOPrk5nv1SuZBEMsGcFNUB0/8w/zXciuN4hpmIqAr3wg2LgQMcjK6MWOQ3vni5SOURP5gunbSAa1LWeZchaYBjOTKdAUedsgg0DMeEHJP4W0HaulGKC0WUAMo8i4FTJU9SBmCREz6ArW+MXtGd0MLu4Cy9/Q5/GSDmmcYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=f7vqi/SZ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="f7vqi/SZ"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c87ab540b3so8925705a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 22:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728279381; x=1728884181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmuRDQ+789Dxrdbe7Plu2amgbdeY0UDHzLyD3KlOvB4=;
        b=f7vqi/SZ8G7RzEJ4lKWlRLJk0OVeA6OXIk+KvaQEkC3uS0ZeRwpQR3SCCQHMQfZ9om
         Ib7WJz6LK0MAOz/M52iGv1Unu9fKbZ+YJzLHkmD/LCcWcTtxTw6sDJ4kJ0pU8QLNCrKD
         /gEZjm4LRmkHyI+Lo1XLmkfQctry5UMjnGFdpmLJTDRAG+fwKyuRZX6nP2uWXfzUepLc
         rBB3gcZq45+xG+QzpPrNLWZAxbjwtCxnSOnjmDElrsgFvRYL+SPcurbS/bFuzRV7ohJY
         s4eZTv0Az2DO+8fWkV1+b8g0Rk9jS44opQTOBvhwPgYEj3Y6/IMhHkWPvkrEl2miWRP9
         hnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728279381; x=1728884181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmuRDQ+789Dxrdbe7Plu2amgbdeY0UDHzLyD3KlOvB4=;
        b=Fnnh6aqtuKEhfhnCmM8mt6mp0r9DiuFjFlauSD1aPsOddA+udgOC5DRZzXlZkXklwH
         jgIUl67124iQI+S66Ap5uzk9rH79FZkZs4qKpPBIdMRXXEsvTQxLrea3DhzD7O4x0DoT
         O/p2N0Eb2mBKqw8wZTxEShERSNLHhNcgGt8w1Yjiw5acbMoWhyhEZF0Ix+ja8edrGasf
         BxEuCfVafkQATJifIW7lwZvyUVchz338wA4ZWKUNikY4j4Oz7dheDDXFJOWlorl8vRA9
         mMH5OR2EBgodv4deMDvvGqDZ17WpznozZX1cg9GsAZN/L0gv14wN9SHsRRL6OMhCOuUx
         0u8w==
X-Forwarded-Encrypted: i=1; AJvYcCVFeKfgAV2kDlJvpawnPwdXrJJBROZrBcn0V1bNPtbVki9rZzpS4neBmLI5xJRuEXdRv0S+A+7EuOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6McOYSDj8IYhDS1azqEPx0ELrfCH5VBj7jfQDjnIP7ertFTfW
	/rYEtVdlwx3PJpuEJv6/l0/BdlNw9M8u/av3gXpzjdtyzeo7VXCUZeo412EmNzrLMxFCNcjoQF3
	ayyTjgS22oW8Esu8tehPQo16J1q7dlwei20U9sw==
X-Google-Smtp-Source: AGHT+IFmB9y6/+kQL6KjsmY8/EdfpVKJMGg25s2uWIbdIaizpuU4BwX+luKVWgAn+4aggb52o4zBWQfQLDFbETfCjoI=
X-Received: by 2002:a05:6402:34c5:b0:5c8:9f3e:5efc with SMTP id
 4fb4d7f45d1cf-5c8c0a0f606mr15771857a12.6.1728279380643; Sun, 06 Oct 2024
 22:36:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006152849.247152-1-yizhou.tang@shopee.com>
 <20241006152849.247152-4-yizhou.tang@shopee.com> <20241006163013.GN21853@frogsfrogsfrogs>
In-Reply-To: <20241006163013.GN21853@frogsfrogsfrogs>
From: Tang Yizhou <yizhou.tang@shopee.com>
Date: Mon, 7 Oct 2024 13:36:09 +0800
Message-ID: <CACuPKxkceb0zARj-B_ZuYbSH70rZHwgrJzjhjxpKFf53C9GNRg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] xfs: Let the max iomap length be consistent with
 the writeback code
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: jack@suse.cz, hch@infradead.org, willy@infradead.org, 
	akpm@linux-foundation.org, chandan.babu@oracle.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 12:30=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sun, Oct 06, 2024 at 11:28:49PM +0800, Tang Yizhou wrote:
> > From: Tang Yizhou <yizhou.tang@shopee.com>
> >
> > Since commit 1a12d8bd7b29 ("writeback: scale IO chunk size up to half
> > device bandwidth"), macro MAX_WRITEBACK_PAGES has been removed from the
> > writeback path. Therefore, the MAX_WRITEBACK_PAGES comments in
> > xfs_direct_write_iomap_begin() and xfs_buffered_write_iomap_begin() app=
ear
> > outdated.
> >
> > In addition, Christoph mentioned that the xfs iomap process should be
> > similar to writeback, so xfs_max_map_length() was written following the
> > logic of writeback_chunk_size().
> >
> > v2: Thanks for Christoph's advice. Resync with the writeback code.
> >
> > Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
> > ---
> >  fs/fs-writeback.c         |  5 ----
> >  fs/xfs/xfs_iomap.c        | 52 ++++++++++++++++++++++++---------------
> >  include/linux/writeback.h |  5 ++++
> >  3 files changed, 37 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index d8bec3c1bb1f..31c72e207e1b 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -31,11 +31,6 @@
> >  #include <linux/memcontrol.h>
> >  #include "internal.h"
> >
> > -/*
> > - * 4MB minimal write chunk size
> > - */
> > -#define MIN_WRITEBACK_PAGES  (4096UL >> (PAGE_SHIFT - 10))
> > -
> >  /*
> >   * Passed into wb_writeback(), essentially a subset of writeback_contr=
ol
> >   */
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 1e11f48814c0..80f759fa9534 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -4,6 +4,8 @@
> >   * Copyright (c) 2016-2018 Christoph Hellwig.
> >   * All Rights Reserved.
> >   */
> > +#include <linux/writeback.h>
> > +
> >  #include "xfs.h"
> >  #include "xfs_fs.h"
> >  #include "xfs_shared.h"
> > @@ -744,6 +746,34 @@ xfs_ilock_for_iomap(
> >       return 0;
> >  }
> >
> > +/*
> > + * We cap the maximum length we map to a sane size to keep the chunks
> > + * of work done where somewhat symmetric with the work writeback does.
> > + * This is a completely arbitrary number pulled out of thin air as a
> > + * best guess for initial testing.
> > + *
> > + * Following the logic of writeback_chunk_size(), the length will be
> > + * rounded to the nearest 4MB boundary.
> > + *
> > + * Note that the values needs to be less than 32-bits wide until the
> > + * lower level functions are updated.
> > + */
> > +static loff_t
> > +xfs_max_map_length(struct inode *inode, loff_t length)
> > +{
> > +     struct bdi_writeback *wb;
> > +     long pages;
> > +
> > +     spin_lock(&inode->i_lock);
>
> Why's it necessary to hold a spinlock?  AFAICT writeback_chunk_size
> doesn't hold it.
>

Since the caller of writeback_chunk_size(), writeback_sb_inodes(), already =
holds
wb->list_lock. According to the function comments of inode_to_wb(),
holding either
inode->i_lock or the associated wb's list_lock is acceptable.

> > +     wb =3D inode_to_wb(wb);
>
> Hmm, it looks like you're trying to cap writes based on storage device
> bandwidth instead of a static limit.  That could be nifty, but does this
> work for a file on the realtime device?  Or any device that isn't the
> super_block s_bdi?
>

I'm not very sure. Considering that the implementation of
writeback_chunk_size() in
the writeback path has remained unchanged for many years, I believe
its logic works
well in various scenarios.

> > +     pages =3D min(wb->avg_write_bandwidth / 2,
> > +                 global_wb_domain.dirty_limit / DIRTY_SCOPE);
> > +     spin_unlock(&inode->i_lock);
> > +     pages =3D round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_P=
AGES);
> > +
> > +     return min_t(loff_t, length, pages * PAGE_SIZE);
> > +}
>
> There's nothing in here that's xfs-specific, shouldn't this be a
> fs-writeback.c function for any other filesystem that might want to cap
> the size of a write?
>

These logics are indeed not xfs-specific. However, I checked the
related implementations
in ext4 and btrfs, and it seems that these file systems do not require
similar logic to cap
the size. If we move the implementation of this function to
fs-writeback.c, the only user
would still be xfs.

Additionally, there are some differences in the implementation details
between this function
and writeback_chunk_size(), so it doesn't seem convenient to reuse the code=
.

Yi

> --D
>
> > +
> >  /*
> >   * Check that the imap we are going to return to the caller spans the =
entire
> >   * range that the caller requested for the IO.
> > @@ -878,16 +908,7 @@ xfs_direct_write_iomap_begin(
> >       if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY))
> >               goto out_unlock;
> >
> > -     /*
> > -      * We cap the maximum length we map to a sane size  to keep the c=
hunks
> > -      * of work done where somewhat symmetric with the work writeback =
does.
> > -      * This is a completely arbitrary number pulled out of thin air a=
s a
> > -      * best guess for initial testing.
> > -      *
> > -      * Note that the values needs to be less than 32-bits wide until =
the
> > -      * lower level functions are updated.
> > -      */
> > -     length =3D min_t(loff_t, length, 1024 * PAGE_SIZE);
> > +     length =3D xfs_max_map_length(inode, length);
> >       end_fsb =3D xfs_iomap_end_fsb(mp, offset, length);
> >
> >       if (offset + length > XFS_ISIZE(ip))
> > @@ -1096,16 +1117,7 @@ xfs_buffered_write_iomap_begin(
> >               allocfork =3D XFS_COW_FORK;
> >               end_fsb =3D imap.br_startoff + imap.br_blockcount;
> >       } else {
> > -             /*
> > -              * We cap the maximum length we map here to MAX_WRITEBACK=
_PAGES
> > -              * pages to keep the chunks of work done where somewhat
> > -              * symmetric with the work writeback does.  This is a com=
pletely
> > -              * arbitrary number pulled out of thin air.
> > -              *
> > -              * Note that the values needs to be less than 32-bits wid=
e until
> > -              * the lower level functions are updated.
> > -              */
> > -             count =3D min_t(loff_t, count, 1024 * PAGE_SIZE);
> > +             count =3D xfs_max_map_length(inode, count);
> >               end_fsb =3D xfs_iomap_end_fsb(mp, offset, count);
> >
> >               if (xfs_is_always_cow_inode(ip))
> > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> > index d6db822e4bb3..657bc4dd22d0 100644
> > --- a/include/linux/writeback.h
> > +++ b/include/linux/writeback.h
> > @@ -17,6 +17,11 @@ struct bio;
> >
> >  DECLARE_PER_CPU(int, dirty_throttle_leaks);
> >
> > +/*
> > + * 4MB minimal write chunk size
> > + */
> > +#define MIN_WRITEBACK_PAGES  (4096UL >> (PAGE_SHIFT - 10))
> > +
> >  /*
> >   * The global dirty threshold is normally equal to the global dirty li=
mit,
> >   * except when the system suddenly allocates a lot of anonymous memory=
 and
> > --
> > 2.25.1
> >
> >
