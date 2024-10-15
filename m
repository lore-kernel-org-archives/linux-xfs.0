Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F91D1CB9EB
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729007829; cv=none; b=ZQ4lsG8SjBCJuuKUCUgi7P8DPMnkZ7wbcaCwh32esgG3RoJPMhgSTovr0/KfvNSYJ8c2DaDfDDQx3nKJeRTFvuwZCfv64GVfriiokT+kW7IT80eWjet/GbwNeVEjfum+wZxMcsPy669ssV6S97cyWNX4lADLoSqvDg+FvPlG6L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729007829; c=relaxed/simple;
	bh=I++sLSg92ksMRsQ1Q/oUNG5b2NyHNbEECrd5KqM75KM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sy6xv++zyl7B0He6WulFr1cXvfn0HThx2jqo1cFZaFuGEdFMceXyid4++DpximCaOgMd/sWveh41Waj8pvNWCdScqaDA8WuIanz4z10bdoQMz8c9MW3RtYwLitflfQT8mVXigMBsgGweW10fgnq/exjTTZvgJQl2SFrzd9iHzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPLAVBXr; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPLAVBXr"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-288d4da7221so541124fac.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729007826; x=1729612626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3db/KaFaTc6cAyYNYdFeV/Op6ANSh6qonhWsNHUfKYs=;
        b=mPLAVBXrETIPfaJpbFCYTFf06tFuyFPg77a2OzlhwYzdUrjT3Ep/gyc9qY0Ngl2yGB
         X7u12dpRY1rpcv5MRIa3ULdQQaLL91FLIgajqJuRf59sxGhOJw4VJaDmc9Gz9LcAuEZN
         5WhzN8+2o7InpIQVuWWBteuB0YVGQwXPAErFW0QQoVwGiTLGWwCLbUew6NNgMvgiVWRW
         Q481HXzxw6si8ilUX4QmPZyLZY2kv1YX8QPrQTazfD4+8HaIB7yJdRbtdlpQA99RN/HE
         Z6+xkwvp6H1EZ1PGanHgdJxsC/KGDy/UdTY6zvAw1UeN3HvORIlUJJD5GK2Kw3h4FH5i
         IjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729007826; x=1729612626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3db/KaFaTc6cAyYNYdFeV/Op6ANSh6qonhWsNHUfKYs=;
        b=pIZddwwbQa/692lJIsl0Hv7C3+Dqg4yn9g17dG5wooON7/J/wNCCcdGHvoscMKjzPL
         PicxOBU1i+dk7PwCc2eD/ik9YykFI1ETk9Xi0DqDoqInju53jrKsQtqieFdHDqTXs3JT
         FC9aHAVtR1FAJHGVsJHaRWkWCzND3AtcOuyl1rzLvnEdAUKdugcYTBynhnr/cF13xCiJ
         OVWmOeeEoX/R7ttf24igptbkxamYCa2Ws+p7H1n+UE1wrtLTBQPYNcPHe+dAYi9ciOtC
         9knPDLUBQWHLyXEFUteFbLEvMfTzHT9KT39n2VPqemNdVqCyuI2012i+NVy587ypSw7d
         K8CA==
X-Forwarded-Encrypted: i=1; AJvYcCVro2iD62yi6i1uHMAvjVRnnHVn5nA0X4nDNznAShJz52Lmp5Xj2IyAw3B7rBSYWHwoh/IfWnEmZdA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzuo6cXSUihO2MkVIRg1G5CKCH2/cv7C5Lfe+pM4IuDoq9oelp
	Mxm6y0sGy1UjUQ7HGRfsGbEs7hm2Cbu1KJ8Z/nJR0ln1vScEdgxa9S51h19xsurmUT1aUVSBqUJ
	cF49jNPSQ3K1KXBmZROHitt385MZTzYee0GUf1g==
X-Google-Smtp-Source: AGHT+IHumQKH1bOsiaayrAg7k2hm2g73dgfMQ6is4NTlqnip9bKUMaUk0YMHbvAgLLZUHMLPx/hJ1DR9hJX/UKcQC90=
X-Received: by 2002:a05:6870:f816:b0:260:eb3a:1be with SMTP id
 586e51a60fabf-288edfb6b4emr908651fac.34.1729007825567; Tue, 15 Oct 2024
 08:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240429061529.1550204-1-hch@lst.de> <20240429061529.1550204-2-hch@lst.de>
 <CAEJPjCu5CWEMHHpLS2yB7tk9Hh52EsQ5npifKiw--U-50PLEng@mail.gmail.com> <CAEJPjCuj2AH2iUh4fcL9Ux-D52utREpXp7XGVdhGwYnDNuDMSA@mail.gmail.com>
In-Reply-To: <CAEJPjCuj2AH2iUh4fcL9Ux-D52utREpXp7XGVdhGwYnDNuDMSA@mail.gmail.com>
From: =?UTF-8?B?5YiY6YCa?= <lyutoon@gmail.com>
Date: Tue, 15 Oct 2024 23:56:54 +0800
Message-ID: <CAEJPjCugoLMefnVEyDAi08Yd=fPctPW6g5oN2xZ-vUTsx7n7Xw@mail.gmail.com>
Subject: Re: [PATCH 1/9] xfs: fix error returns from xfs_bmapi_write
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Linux maintainers!

I hope this message finds you well. Apologies for taking up your time.
I recently noticed that the bug I reported
(https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv=
29tNHK76Cgg@mail.gmail.com/)
has been fixed and merged into the main branch=E2=80=94thank you for your h=
ard
work!

I was wondering if it would be possible to receive a CVE number for
this issue. I'm not familiar with how Linux handles CVE assignments. I
would greatly appreciate it if you could either assign a CVE or simply
reply to this email. Thank you!

Best regards,
Tong

=E5=88=98=E9=80=9A <lyutoon@gmail.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=B8=80 20:39=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello!
>
> Thank you for promptly fixing this issue. May I ask if it's possible
> to assign a CVE to this vulnerability?
> Once again, thank you for your efforts in fixing this vulnerability!
>
> Wish you all the best.
>
> Tong
>
>
> =E5=88=98=E9=80=9A <lyutoon@gmail.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=886=
=E6=97=A5=E5=91=A8=E4=B8=80 20:24=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hello!
> >
> > Thank you for promptly fixing this issue. May I ask if it's possible to=
 assign a CVE to this vulnerability?
> > Once again, thank you for your efforts in fixing this vulnerability!
> >
> > Wish you all the best.
> >
> > Tong
> >
> > Christoph Hellwig <hch@lst.de> =E4=BA=8E2024=E5=B9=B44=E6=9C=8829=E6=97=
=A5=E5=91=A8=E4=B8=80 14:15=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> xfs_bmapi_write can return 0 without actually returning a mapping in
> >> mval in two different cases:
> >>
> >>  1) when there is absolutely no space available to do an allocation
> >>  2) when converting delalloc space, and the allocation is so small
> >>     that it only covers parts of the delalloc extent before the
> >>     range requested by the caller
> >>
> >> Callers at best can handle one of these cases, but in many cases can't
> >> cope with either one.  Switch xfs_bmapi_write to always return a
> >> mapping or return an error code instead.  For case 1) above ENOSPC is
> >> the obvious choice which is very much what the callers expect anyway.
> >> For case 2) there is no really good error code, so pick a funky one
> >> from the SysV streams portfolio.
> >>
> >> This fixes the reproducer here:
> >>
> >>     https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ=
0GCjVVCv29tNHK76Cgg@mail.gmail.com0/
> >>
> >> which uses reserved blocks to create file systems that are gravely
> >> out of space and thus cause at least xfs_file_alloc_space to hang
> >> and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.
> >>
> >> Note that this patch does not actually make any caller but
> >> xfs_alloc_file_space deal intelligently with case 2) above.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> Reported-by: =E5=88=98=E9=80=9A <lyutoon@gmail.com>
> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >> ---
> >>  fs/xfs/libxfs/xfs_attr_remote.c |  1 -
> >>  fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++------=
-
> >>  fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
> >>  fs/xfs/scrub/quota_repair.c     |  6 -----
> >>  fs/xfs/scrub/rtbitmap_repair.c  |  2 --
> >>  fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
> >>  fs/xfs/xfs_dquot.c              |  1 -
> >>  fs/xfs/xfs_iomap.c              |  8 ------
> >>  fs/xfs/xfs_reflink.c            | 14 ----------
> >>  fs/xfs/xfs_rtalloc.c            |  2 --
> >>  10 files changed, 57 insertions(+), 74 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_=
remote.c
> >> index a8de9dc1e998a3..beb0efdd8f6b83 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> >> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> >> @@ -625,7 +625,6 @@ xfs_attr_rmtval_set_blk(
> >>         if (error)
> >>                 return error;
> >>
> >> -       ASSERT(nmap =3D=3D 1);
> >>         ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
> >>                (map->br_startblock !=3D HOLESTARTBLOCK));
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> >> index 6053f5e5c71eec..f19191d6eade7e 100644
> >> --- a/fs/xfs/libxfs/xfs_bmap.c
> >> +++ b/fs/xfs/libxfs/xfs_bmap.c
> >> @@ -4217,8 +4217,10 @@ xfs_bmapi_allocate(
> >>         } else {
> >>                 error =3D xfs_bmap_alloc_userdata(bma);
> >>         }
> >> -       if (error || bma->blkno =3D=3D NULLFSBLOCK)
> >> +       if (error)
> >>                 return error;
> >> +       if (bma->blkno =3D=3D NULLFSBLOCK)
> >> +               return -ENOSPC;
> >>
> >>         if (bma->flags & XFS_BMAPI_ZERO) {
> >>                 error =3D xfs_zero_extent(bma->ip, bma->blkno, bma->le=
ngth);
> >> @@ -4397,6 +4399,15 @@ xfs_bmapi_finish(
> >>   * extent state if necessary.  Details behaviour is controlled by the=
 flags
> >>   * parameter.  Only allocates blocks from a single allocation group, =
to avoid
> >>   * locking problems.
> >> + *
> >> + * Returns 0 on success and places the extent mappings in mval.  nmap=
s is used
> >> + * as an input/output parameter where the caller specifies the maximu=
m number
> >> + * of mappings that may be returned and xfs_bmapi_write passes back t=
he number
> >> + * of mappings (including existing mappings) it found.
> >> + *
> >> + * Returns a negative error code on failure, including -ENOSPC when i=
t could not
> >> + * allocate any blocks and -ENOSR when it did allocate blocks to conv=
ert a
> >> + * delalloc range, but those blocks were before the passed in range.
> >>   */
> >>  int
> >>  xfs_bmapi_write(
> >> @@ -4525,10 +4536,16 @@ xfs_bmapi_write(
> >>                         ASSERT(len > 0);
> >>                         ASSERT(bma.length > 0);
> >>                         error =3D xfs_bmapi_allocate(&bma);
> >> -                       if (error)
> >> +                       if (error) {
> >> +                               /*
> >> +                                * If we already allocated space in a =
previous
> >> +                                * iteration return what we go so far =
when
> >> +                                * running out of space.
> >> +                                */
> >> +                               if (error =3D=3D -ENOSPC && bma.nalloc=
s)
> >> +                                       break;
> >>                                 goto error0;
> >> -                       if (bma.blkno =3D=3D NULLFSBLOCK)
> >> -                               break;
> >> +                       }
> >>
> >>                         /*
> >>                          * If this is a CoW allocation, record the dat=
a in
> >> @@ -4566,7 +4583,6 @@ xfs_bmapi_write(
> >>                 if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
> >>                         eof =3D true;
> >>         }
> >> -       *nmap =3D n;
> >>
> >>         error =3D xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logf=
lags,
> >>                         whichfork);
> >> @@ -4577,7 +4593,22 @@ xfs_bmapi_write(
> >>                ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
> >>         xfs_bmapi_finish(&bma, whichfork, 0);
> >>         xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mva=
l,
> >> -               orig_nmap, *nmap);
> >> +               orig_nmap, n);
> >> +
> >> +       /*
> >> +        * When converting delayed allocations, xfs_bmapi_allocate ign=
ores
> >> +        * the passed in bno and always converts from the start of the=
 found
> >> +        * delalloc extent.
> >> +        *
> >> +        * To avoid a successful return with *nmap set to 0, return th=
e magic
> >> +        * -ENOSR error code for this particular case so that the call=
er can
> >> +        * handle it.
> >> +        */
> >> +       if (!n) {
> >> +               ASSERT(bma.nallocs >=3D *nmap);
> >> +               return -ENOSR;
> >> +       }
> >> +       *nmap =3D n;
> >>         return 0;
> >>  error0:
> >>         xfs_bmapi_finish(&bma, whichfork, error);
> >> @@ -4684,9 +4715,6 @@ xfs_bmapi_convert_delalloc(
> >>         if (error)
> >>                 goto out_finish;
> >>
> >> -       error =3D -ENOSPC;
> >> -       if (WARN_ON_ONCE(bma.blkno =3D=3D NULLFSBLOCK))
> >> -               goto out_finish;
> >>         if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblo=
ck))) {
> >>                 xfs_bmap_mark_sick(ip, whichfork);
> >>                 error =3D -EFSCORRUPTED;
> >> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree=
.c
> >> index b13796629e2213..16a529a8878083 100644
> >> --- a/fs/xfs/libxfs/xfs_da_btree.c
> >> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> >> @@ -2297,8 +2297,8 @@ xfs_da_grow_inode_int(
> >>         struct xfs_inode        *dp =3D args->dp;
> >>         int                     w =3D args->whichfork;
> >>         xfs_rfsblock_t          nblks =3D dp->i_nblocks;
> >> -       struct xfs_bmbt_irec    map, *mapp;
> >> -       int                     nmap, error, got, i, mapi;
> >> +       struct xfs_bmbt_irec    map, *mapp =3D &map;
> >> +       int                     nmap, error, got, i, mapi =3D 1;
> >>
> >>         /*
> >>          * Find a spot in the file space to put the new block.
> >> @@ -2314,14 +2314,7 @@ xfs_da_grow_inode_int(
> >>         error =3D xfs_bmapi_write(tp, dp, *bno, count,
> >>                         xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAP=
I_CONTIG,
> >>                         args->total, &map, &nmap);
> >> -       if (error)
> >> -               return error;
> >> -
> >> -       ASSERT(nmap <=3D 1);
> >> -       if (nmap =3D=3D 1) {
> >> -               mapp =3D &map;
> >> -               mapi =3D 1;
> >> -       } else if (nmap =3D=3D 0 && count > 1) {
> >> +       if (error =3D=3D -ENOSPC && count > 1) {
> >>                 xfs_fileoff_t           b;
> >>                 int                     c;
> >>
> >> @@ -2339,16 +2332,13 @@ xfs_da_grow_inode_int(
> >>                                         args->total, &mapp[mapi], &nma=
p);
> >>                         if (error)
> >>                                 goto out_free_map;
> >> -                       if (nmap < 1)
> >> -                               break;
> >>                         mapi +=3D nmap;
> >>                         b =3D mapp[mapi - 1].br_startoff +
> >>                             mapp[mapi - 1].br_blockcount;
> >>                 }
> >> -       } else {
> >> -               mapi =3D 0;
> >> -               mapp =3D NULL;
> >>         }
> >> +       if (error)
> >> +               goto out_free_map;
> >>
> >>         /*
> >>          * Count the blocks we got, make sure it matches the total.
> >> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> >> index 0bab4c30cb85ab..90cd1512bba961 100644
> >> --- a/fs/xfs/scrub/quota_repair.c
> >> +++ b/fs/xfs/scrub/quota_repair.c
> >> @@ -77,8 +77,6 @@ xrep_quota_item_fill_bmap_hole(
> >>                         irec, &nmaps);
> >>         if (error)
> >>                 return error;
> >> -       if (nmaps !=3D 1)
> >> -               return -ENOSPC;
> >>
> >>         dq->q_blkno =3D XFS_FSB_TO_DADDR(mp, irec->br_startblock);
> >>
> >> @@ -444,10 +442,6 @@ xrep_quota_data_fork(
> >>                                         XFS_BMAPI_CONVERT, 0, &nrec, &=
nmap);
> >>                         if (error)
> >>                                 goto out;
> >> -                       if (nmap !=3D 1) {
> >> -                               error =3D -ENOSPC;
> >> -                               goto out;
> >> -                       }
> >>                         ASSERT(nrec.br_startoff =3D=3D irec.br_startof=
f);
> >>                         ASSERT(nrec.br_blockcount =3D=3D irec.br_block=
count);
> >>
> >> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_re=
pair.c
> >> index 46f5d5f605c915..0fef98e9f83409 100644
> >> --- a/fs/xfs/scrub/rtbitmap_repair.c
> >> +++ b/fs/xfs/scrub/rtbitmap_repair.c
> >> @@ -108,8 +108,6 @@ xrep_rtbitmap_data_mappings(
> >>                                 0, &map, &nmaps);
> >>                 if (error)
> >>                         return error;
> >> -               if (nmaps !=3D 1)
> >> -                       return -EFSCORRUPTED;
> >>
> >>                 /* Commit new extent and all deferred work. */
> >>                 error =3D xrep_defer_finish(sc);
> >> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> >> index 53aa90a0ee3a85..2e6f08198c0719 100644
> >> --- a/fs/xfs/xfs_bmap_util.c
> >> +++ b/fs/xfs/xfs_bmap_util.c
> >> @@ -721,33 +721,32 @@ xfs_alloc_file_space(
> >>                 if (error)
> >>                         goto error;
> >>
> >> -               error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
> >> -                               allocatesize_fsb, XFS_BMAPI_PREALLOC, =
0, imapp,
> >> -                               &nimaps);
> >> -               if (error)
> >> -                       goto error;
> >> -
> >> -               ip->i_diflags |=3D XFS_DIFLAG_PREALLOC;
> >> -               xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >> -
> >> -               error =3D xfs_trans_commit(tp);
> >> -               xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >> -               if (error)
> >> -                       break;
> >> -
> >>                 /*
> >>                  * If the allocator cannot find a single free extent l=
arge
> >>                  * enough to cover the start block of the requested ra=
nge,
> >> -                * xfs_bmapi_write will return 0 but leave *nimaps set=
 to 0.
> >> +                * xfs_bmapi_write will return -ENOSR.
> >>                  *
> >>                  * In that case we simply need to keep looping with th=
e same
> >>                  * startoffset_fsb so that one of the following alloca=
tions
> >>                  * will eventually reach the requested range.
> >>                  */
> >> -               if (nimaps) {
> >> +               error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
> >> +                               allocatesize_fsb, XFS_BMAPI_PREALLOC, =
0, imapp,
> >> +                               &nimaps);
> >> +               if (error) {
> >> +                       if (error !=3D -ENOSR)
> >> +                               goto error;
> >> +                       error =3D 0;
> >> +               } else {
> >>                         startoffset_fsb +=3D imapp->br_blockcount;
> >>                         allocatesize_fsb -=3D imapp->br_blockcount;
> >>                 }
> >> +
> >> +               ip->i_diflags |=3D XFS_DIFLAG_PREALLOC;
> >> +               xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >> +
> >> +               error =3D xfs_trans_commit(tp);
> >> +               xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >>         }
> >>
> >>         return error;
> >> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> >> index 13aba84bd64afb..43acb4f0d17433 100644
> >> --- a/fs/xfs/xfs_dquot.c
> >> +++ b/fs/xfs/xfs_dquot.c
> >> @@ -357,7 +357,6 @@ xfs_dquot_disk_alloc(
> >>                 goto err_cancel;
> >>
> >>         ASSERT(map.br_blockcount =3D=3D XFS_DQUOT_CLUSTER_SIZE_FSB);
> >> -       ASSERT(nmaps =3D=3D 1);
> >>         ASSERT((map.br_startblock !=3D DELAYSTARTBLOCK) &&
> >>                (map.br_startblock !=3D HOLESTARTBLOCK));
> >>
> >> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> >> index 9ce0f6b9df93e6..60463160820b62 100644
> >> --- a/fs/xfs/xfs_iomap.c
> >> +++ b/fs/xfs/xfs_iomap.c
> >> @@ -322,14 +322,6 @@ xfs_iomap_write_direct(
> >>         if (error)
> >>                 goto out_unlock;
> >>
> >> -       /*
> >> -        * Copy any maps to caller's array and return any error.
> >> -        */
> >> -       if (nimaps =3D=3D 0) {
> >> -               error =3D -ENOSPC;
> >> -               goto out_unlock;
> >> -       }
> >> -
> >>         if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) =
{
> >>                 xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> >>                 error =3D xfs_alert_fsblock_zero(ip, imap);
> >> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> >> index 7da0e8f961d351..5ecb52a234becc 100644
> >> --- a/fs/xfs/xfs_reflink.c
> >> +++ b/fs/xfs/xfs_reflink.c
> >> @@ -430,13 +430,6 @@ xfs_reflink_fill_cow_hole(
> >>         if (error)
> >>                 return error;
> >>
> >> -       /*
> >> -        * Allocation succeeded but the requested range was not even p=
artially
> >> -        * satisfied?  Bail out!
> >> -        */
> >> -       if (nimaps =3D=3D 0)
> >> -               return -ENOSPC;
> >> -
> >>  convert:
> >>         return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_n=
ow);
> >>
> >> @@ -499,13 +492,6 @@ xfs_reflink_fill_delalloc(
> >>                 error =3D xfs_trans_commit(tp);
> >>                 if (error)
> >>                         return error;
> >> -
> >> -               /*
> >> -                * Allocation succeeded but the requested range was no=
t even
> >> -                * partially satisfied?  Bail out!
> >> -                */
> >> -               if (nimaps =3D=3D 0)
> >> -                       return -ENOSPC;
> >>         } while (cmap->br_startoff + cmap->br_blockcount <=3D imap->br=
_startoff);
> >>
> >>         return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_n=
ow);
> >> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> >> index b476a876478d93..150f544445ca82 100644
> >> --- a/fs/xfs/xfs_rtalloc.c
> >> +++ b/fs/xfs/xfs_rtalloc.c
> >> @@ -709,8 +709,6 @@ xfs_growfs_rt_alloc(
> >>                 nmap =3D 1;
> >>                 error =3D xfs_bmapi_write(tp, ip, oblocks, nblocks - o=
blocks,
> >>                                         XFS_BMAPI_METADATA, 0, &map, &=
nmap);
> >> -               if (!error && nmap < 1)
> >> -                       error =3D -ENOSPC;
> >>                 if (error)
> >>                         goto out_trans_cancel;
> >>                 /*
> >> --
> >> 2.39.2
> >>
