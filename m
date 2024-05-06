Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595211DA5F
	for <linux-xfs@vger.kernel.org>; Mon,  6 May 2024 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999185; cv=none; b=rZSbxz9hBKi4eo0ledVP96Zl+LMsIlK3ADb++jZDh/sG+FyXJ1X3EpymkV/dzuvv5Dzp9mD5JouRrrd3274n+oZ7sCj2ESNBrpLlRHxbEvZ9q8GJbAP6OoSkwetKaRXgbc+UKOYi3LQRXw/jFN/vh3ycFVhtwhneqnYgI05MS54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999185; c=relaxed/simple;
	bh=9K5AlEs/yuMdfrCkFH/rxJ7qwKZKXT50yECAJOEHOFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VK4Fh+6UHQg+ZOXaAcmGI/HjR4KIWvfYOlorEvKrlGYzmMVO0VoTDc9MN/pLaJKO5Xd9gc76tME/hHLe0/bOYDD1Q/pZ41ylf5sLz9hkEMXd++gDIymj/ksGY1OEeqOzaZCrkZ/Iy1TWUxcyg6/d1RPN0uUIkdzoLQdn96kyYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhIAsh6W; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhIAsh6W"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5b209d564e0so750464eaf.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 05:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714999182; x=1715603982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3m2SKSiVN3jFw05rNele8TLz2y5wcBMS4qr5AUrRR4=;
        b=YhIAsh6Wp/XGrgXftqJL13z5VtOpjVVVclzcBGhx3jQridzr5MtGuRw9q55a4bpLWD
         VRwDt4G5FKNQz3l9str+rFvzorlODcX2M2/NqkUHNW2CTzwtHu6bzEHnmWKxH4NIA8Ur
         6d9WrgoCn2rFGJyZz+s6YpkO5WWGuK7vHLbxmvBVR6A7Ttqe6bWUuRyUw0ZrWApAlfRw
         V+VILdIu5q8lgeJXp2J7zQzXMaWn8fYTQ2Eb1Z3TMZ6FZTkX2qcHehYI5evtBZWgpeVc
         wyQfav/8xvCnrucf1E3UP6lrNcbrB84MTiedf32/0bAqNnr2us0sR4LfnI6qbxMW1HWQ
         BRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999182; x=1715603982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L3m2SKSiVN3jFw05rNele8TLz2y5wcBMS4qr5AUrRR4=;
        b=PjfZKn78hPAVZqlB/jaYZvmmhI1Ul4Zh1a8EJFc9c1CVHRudL86bL2dyqoV/QHkPxH
         Nzi4etUhfUAP/VZGSZtsQLxzB/NUyAFbzPt2W+DXipFLh/Y0alB44673eNpatEnbsrgH
         EwV7jZtBAmRAkA9OLPT9gOtcvp88z4dQtEf6mCl6dCc/yknblYHE7KQZIJuMamAXAoNf
         UkfKlLlsCbwMu/I6H7nXDOJI60Bz2MemA2zg7E32lLmVE4grhXjHFcmwx69vqii3yaMQ
         9CvWYY7S9tZCs2mRamL5Rs1gPKNNV2zLxekkCXRl6w7ftyc8+VdoLcYXhUyojtBa+Bzc
         AbHw==
X-Forwarded-Encrypted: i=1; AJvYcCWKGBdiauT12plvAR33PLoZZmpxBZM2+2XOqXNKWXFuGoQcAMbrzhL3bbJQHnaOcDIlzRrsoxkyZxzHtq0Y/VgWRsUqgk5Eg11V
X-Gm-Message-State: AOJu0YxICr6yemZagxrnMBi5xFUgmVUeOuqGN8LAFwamWNDLhnCg4efL
	wPZxihJqO8KZ+u1WTHTm2SawGW6Ezp/n20zCd2SJSQTi5+w0hLF2FIrxAwDgMs84EahNwOVURr1
	e1HA2l69GX36ZL55B70Vv1PydS3A=
X-Google-Smtp-Source: AGHT+IHjAbtljH0O3eT69psTJOX3BT7CTzyrW8GkM/6mBYG1zqQ1hrnAgx3WiKNHY724Jou4AePDA2JzoFQS9JSvS04=
X-Received: by 2002:a4a:4804:0:b0:5aa:4b31:50c5 with SMTP id
 p4-20020a4a4804000000b005aa4b3150c5mr10450939ooa.2.1714999181664; Mon, 06 May
 2024 05:39:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240429061529.1550204-1-hch@lst.de> <20240429061529.1550204-2-hch@lst.de>
 <CAEJPjCu5CWEMHHpLS2yB7tk9Hh52EsQ5npifKiw--U-50PLEng@mail.gmail.com>
In-Reply-To: <CAEJPjCu5CWEMHHpLS2yB7tk9Hh52EsQ5npifKiw--U-50PLEng@mail.gmail.com>
From: =?UTF-8?B?5YiY6YCa?= <lyutoon@gmail.com>
Date: Mon, 6 May 2024 20:39:30 +0800
Message-ID: <CAEJPjCuj2AH2iUh4fcL9Ux-D52utREpXp7XGVdhGwYnDNuDMSA@mail.gmail.com>
Subject: Re: [PATCH 1/9] xfs: fix error returns from xfs_bmapi_write
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

Thank you for promptly fixing this issue. May I ask if it's possible
to assign a CVE to this vulnerability?
Once again, thank you for your efforts in fixing this vulnerability!

Wish you all the best.

Tong


=E5=88=98=E9=80=9A <lyutoon@gmail.com> =E4=BA=8E2024=E5=B9=B45=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=B8=80 20:24=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello!
>
> Thank you for promptly fixing this issue. May I ask if it's possible to a=
ssign a CVE to this vulnerability?
> Once again, thank you for your efforts in fixing this vulnerability!
>
> Wish you all the best.
>
> Tong
>
> Christoph Hellwig <hch@lst.de> =E4=BA=8E2024=E5=B9=B44=E6=9C=8829=E6=97=
=A5=E5=91=A8=E4=B8=80 14:15=E5=86=99=E9=81=93=EF=BC=9A
>>
>> xfs_bmapi_write can return 0 without actually returning a mapping in
>> mval in two different cases:
>>
>>  1) when there is absolutely no space available to do an allocation
>>  2) when converting delalloc space, and the allocation is so small
>>     that it only covers parts of the delalloc extent before the
>>     range requested by the caller
>>
>> Callers at best can handle one of these cases, but in many cases can't
>> cope with either one.  Switch xfs_bmapi_write to always return a
>> mapping or return an error code instead.  For case 1) above ENOSPC is
>> the obvious choice which is very much what the callers expect anyway.
>> For case 2) there is no really good error code, so pick a funky one
>> from the SysV streams portfolio.
>>
>> This fixes the reproducer here:
>>
>>     https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0G=
CjVVCv29tNHK76Cgg@mail.gmail.com0/
>>
>> which uses reserved blocks to create file systems that are gravely
>> out of space and thus cause at least xfs_file_alloc_space to hang
>> and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.
>>
>> Note that this patch does not actually make any caller but
>> xfs_alloc_file_space deal intelligently with case 2) above.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Reported-by: =E5=88=98=E9=80=9A <lyutoon@gmail.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>  fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>>  fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++-------
>>  fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
>>  fs/xfs/scrub/quota_repair.c     |  6 -----
>>  fs/xfs/scrub/rtbitmap_repair.c  |  2 --
>>  fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
>>  fs/xfs/xfs_dquot.c              |  1 -
>>  fs/xfs/xfs_iomap.c              |  8 ------
>>  fs/xfs/xfs_reflink.c            | 14 ----------
>>  fs/xfs/xfs_rtalloc.c            |  2 --
>>  10 files changed, 57 insertions(+), 74 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_re=
mote.c
>> index a8de9dc1e998a3..beb0efdd8f6b83 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -625,7 +625,6 @@ xfs_attr_rmtval_set_blk(
>>         if (error)
>>                 return error;
>>
>> -       ASSERT(nmap =3D=3D 1);
>>         ASSERT((map->br_startblock !=3D DELAYSTARTBLOCK) &&
>>                (map->br_startblock !=3D HOLESTARTBLOCK));
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 6053f5e5c71eec..f19191d6eade7e 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -4217,8 +4217,10 @@ xfs_bmapi_allocate(
>>         } else {
>>                 error =3D xfs_bmap_alloc_userdata(bma);
>>         }
>> -       if (error || bma->blkno =3D=3D NULLFSBLOCK)
>> +       if (error)
>>                 return error;
>> +       if (bma->blkno =3D=3D NULLFSBLOCK)
>> +               return -ENOSPC;
>>
>>         if (bma->flags & XFS_BMAPI_ZERO) {
>>                 error =3D xfs_zero_extent(bma->ip, bma->blkno, bma->leng=
th);
>> @@ -4397,6 +4399,15 @@ xfs_bmapi_finish(
>>   * extent state if necessary.  Details behaviour is controlled by the f=
lags
>>   * parameter.  Only allocates blocks from a single allocation group, to=
 avoid
>>   * locking problems.
>> + *
>> + * Returns 0 on success and places the extent mappings in mval.  nmaps =
is used
>> + * as an input/output parameter where the caller specifies the maximum =
number
>> + * of mappings that may be returned and xfs_bmapi_write passes back the=
 number
>> + * of mappings (including existing mappings) it found.
>> + *
>> + * Returns a negative error code on failure, including -ENOSPC when it =
could not
>> + * allocate any blocks and -ENOSR when it did allocate blocks to conver=
t a
>> + * delalloc range, but those blocks were before the passed in range.
>>   */
>>  int
>>  xfs_bmapi_write(
>> @@ -4525,10 +4536,16 @@ xfs_bmapi_write(
>>                         ASSERT(len > 0);
>>                         ASSERT(bma.length > 0);
>>                         error =3D xfs_bmapi_allocate(&bma);
>> -                       if (error)
>> +                       if (error) {
>> +                               /*
>> +                                * If we already allocated space in a pr=
evious
>> +                                * iteration return what we go so far wh=
en
>> +                                * running out of space.
>> +                                */
>> +                               if (error =3D=3D -ENOSPC && bma.nallocs)
>> +                                       break;
>>                                 goto error0;
>> -                       if (bma.blkno =3D=3D NULLFSBLOCK)
>> -                               break;
>> +                       }
>>
>>                         /*
>>                          * If this is a CoW allocation, record the data =
in
>> @@ -4566,7 +4583,6 @@ xfs_bmapi_write(
>>                 if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
>>                         eof =3D true;
>>         }
>> -       *nmap =3D n;
>>
>>         error =3D xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logfla=
gs,
>>                         whichfork);
>> @@ -4577,7 +4593,22 @@ xfs_bmapi_write(
>>                ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
>>         xfs_bmapi_finish(&bma, whichfork, 0);
>>         xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
>> -               orig_nmap, *nmap);
>> +               orig_nmap, n);
>> +
>> +       /*
>> +        * When converting delayed allocations, xfs_bmapi_allocate ignor=
es
>> +        * the passed in bno and always converts from the start of the f=
ound
>> +        * delalloc extent.
>> +        *
>> +        * To avoid a successful return with *nmap set to 0, return the =
magic
>> +        * -ENOSR error code for this particular case so that the caller=
 can
>> +        * handle it.
>> +        */
>> +       if (!n) {
>> +               ASSERT(bma.nallocs >=3D *nmap);
>> +               return -ENOSR;
>> +       }
>> +       *nmap =3D n;
>>         return 0;
>>  error0:
>>         xfs_bmapi_finish(&bma, whichfork, error);
>> @@ -4684,9 +4715,6 @@ xfs_bmapi_convert_delalloc(
>>         if (error)
>>                 goto out_finish;
>>
>> -       error =3D -ENOSPC;
>> -       if (WARN_ON_ONCE(bma.blkno =3D=3D NULLFSBLOCK))
>> -               goto out_finish;
>>         if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock=
))) {
>>                 xfs_bmap_mark_sick(ip, whichfork);
>>                 error =3D -EFSCORRUPTED;
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> index b13796629e2213..16a529a8878083 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.c
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -2297,8 +2297,8 @@ xfs_da_grow_inode_int(
>>         struct xfs_inode        *dp =3D args->dp;
>>         int                     w =3D args->whichfork;
>>         xfs_rfsblock_t          nblks =3D dp->i_nblocks;
>> -       struct xfs_bmbt_irec    map, *mapp;
>> -       int                     nmap, error, got, i, mapi;
>> +       struct xfs_bmbt_irec    map, *mapp =3D &map;
>> +       int                     nmap, error, got, i, mapi =3D 1;
>>
>>         /*
>>          * Find a spot in the file space to put the new block.
>> @@ -2314,14 +2314,7 @@ xfs_da_grow_inode_int(
>>         error =3D xfs_bmapi_write(tp, dp, *bno, count,
>>                         xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_=
CONTIG,
>>                         args->total, &map, &nmap);
>> -       if (error)
>> -               return error;
>> -
>> -       ASSERT(nmap <=3D 1);
>> -       if (nmap =3D=3D 1) {
>> -               mapp =3D &map;
>> -               mapi =3D 1;
>> -       } else if (nmap =3D=3D 0 && count > 1) {
>> +       if (error =3D=3D -ENOSPC && count > 1) {
>>                 xfs_fileoff_t           b;
>>                 int                     c;
>>
>> @@ -2339,16 +2332,13 @@ xfs_da_grow_inode_int(
>>                                         args->total, &mapp[mapi], &nmap)=
;
>>                         if (error)
>>                                 goto out_free_map;
>> -                       if (nmap < 1)
>> -                               break;
>>                         mapi +=3D nmap;
>>                         b =3D mapp[mapi - 1].br_startoff +
>>                             mapp[mapi - 1].br_blockcount;
>>                 }
>> -       } else {
>> -               mapi =3D 0;
>> -               mapp =3D NULL;
>>         }
>> +       if (error)
>> +               goto out_free_map;
>>
>>         /*
>>          * Count the blocks we got, make sure it matches the total.
>> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
>> index 0bab4c30cb85ab..90cd1512bba961 100644
>> --- a/fs/xfs/scrub/quota_repair.c
>> +++ b/fs/xfs/scrub/quota_repair.c
>> @@ -77,8 +77,6 @@ xrep_quota_item_fill_bmap_hole(
>>                         irec, &nmaps);
>>         if (error)
>>                 return error;
>> -       if (nmaps !=3D 1)
>> -               return -ENOSPC;
>>
>>         dq->q_blkno =3D XFS_FSB_TO_DADDR(mp, irec->br_startblock);
>>
>> @@ -444,10 +442,6 @@ xrep_quota_data_fork(
>>                                         XFS_BMAPI_CONVERT, 0, &nrec, &nm=
ap);
>>                         if (error)
>>                                 goto out;
>> -                       if (nmap !=3D 1) {
>> -                               error =3D -ENOSPC;
>> -                               goto out;
>> -                       }
>>                         ASSERT(nrec.br_startoff =3D=3D irec.br_startoff)=
;
>>                         ASSERT(nrec.br_blockcount =3D=3D irec.br_blockco=
unt);
>>
>> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repa=
ir.c
>> index 46f5d5f605c915..0fef98e9f83409 100644
>> --- a/fs/xfs/scrub/rtbitmap_repair.c
>> +++ b/fs/xfs/scrub/rtbitmap_repair.c
>> @@ -108,8 +108,6 @@ xrep_rtbitmap_data_mappings(
>>                                 0, &map, &nmaps);
>>                 if (error)
>>                         return error;
>> -               if (nmaps !=3D 1)
>> -                       return -EFSCORRUPTED;
>>
>>                 /* Commit new extent and all deferred work. */
>>                 error =3D xrep_defer_finish(sc);
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 53aa90a0ee3a85..2e6f08198c0719 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -721,33 +721,32 @@ xfs_alloc_file_space(
>>                 if (error)
>>                         goto error;
>>
>> -               error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
>> -                               allocatesize_fsb, XFS_BMAPI_PREALLOC, 0,=
 imapp,
>> -                               &nimaps);
>> -               if (error)
>> -                       goto error;
>> -
>> -               ip->i_diflags |=3D XFS_DIFLAG_PREALLOC;
>> -               xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> -
>> -               error =3D xfs_trans_commit(tp);
>> -               xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> -               if (error)
>> -                       break;
>> -
>>                 /*
>>                  * If the allocator cannot find a single free extent lar=
ge
>>                  * enough to cover the start block of the requested rang=
e,
>> -                * xfs_bmapi_write will return 0 but leave *nimaps set t=
o 0.
>> +                * xfs_bmapi_write will return -ENOSR.
>>                  *
>>                  * In that case we simply need to keep looping with the =
same
>>                  * startoffset_fsb so that one of the following allocati=
ons
>>                  * will eventually reach the requested range.
>>                  */
>> -               if (nimaps) {
>> +               error =3D xfs_bmapi_write(tp, ip, startoffset_fsb,
>> +                               allocatesize_fsb, XFS_BMAPI_PREALLOC, 0,=
 imapp,
>> +                               &nimaps);
>> +               if (error) {
>> +                       if (error !=3D -ENOSR)
>> +                               goto error;
>> +                       error =3D 0;
>> +               } else {
>>                         startoffset_fsb +=3D imapp->br_blockcount;
>>                         allocatesize_fsb -=3D imapp->br_blockcount;
>>                 }
>> +
>> +               ip->i_diflags |=3D XFS_DIFLAG_PREALLOC;
>> +               xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> +
>> +               error =3D xfs_trans_commit(tp);
>> +               xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>         }
>>
>>         return error;
>> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
>> index 13aba84bd64afb..43acb4f0d17433 100644
>> --- a/fs/xfs/xfs_dquot.c
>> +++ b/fs/xfs/xfs_dquot.c
>> @@ -357,7 +357,6 @@ xfs_dquot_disk_alloc(
>>                 goto err_cancel;
>>
>>         ASSERT(map.br_blockcount =3D=3D XFS_DQUOT_CLUSTER_SIZE_FSB);
>> -       ASSERT(nmaps =3D=3D 1);
>>         ASSERT((map.br_startblock !=3D DELAYSTARTBLOCK) &&
>>                (map.br_startblock !=3D HOLESTARTBLOCK));
>>
>> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
>> index 9ce0f6b9df93e6..60463160820b62 100644
>> --- a/fs/xfs/xfs_iomap.c
>> +++ b/fs/xfs/xfs_iomap.c
>> @@ -322,14 +322,6 @@ xfs_iomap_write_direct(
>>         if (error)
>>                 goto out_unlock;
>>
>> -       /*
>> -        * Copy any maps to caller's array and return any error.
>> -        */
>> -       if (nimaps =3D=3D 0) {
>> -               error =3D -ENOSPC;
>> -               goto out_unlock;
>> -       }
>> -
>>         if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
>>                 xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>>                 error =3D xfs_alert_fsblock_zero(ip, imap);
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index 7da0e8f961d351..5ecb52a234becc 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -430,13 +430,6 @@ xfs_reflink_fill_cow_hole(
>>         if (error)
>>                 return error;
>>
>> -       /*
>> -        * Allocation succeeded but the requested range was not even par=
tially
>> -        * satisfied?  Bail out!
>> -        */
>> -       if (nimaps =3D=3D 0)
>> -               return -ENOSPC;
>> -
>>  convert:
>>         return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now=
);
>>
>> @@ -499,13 +492,6 @@ xfs_reflink_fill_delalloc(
>>                 error =3D xfs_trans_commit(tp);
>>                 if (error)
>>                         return error;
>> -
>> -               /*
>> -                * Allocation succeeded but the requested range was not =
even
>> -                * partially satisfied?  Bail out!
>> -                */
>> -               if (nimaps =3D=3D 0)
>> -                       return -ENOSPC;
>>         } while (cmap->br_startoff + cmap->br_blockcount <=3D imap->br_s=
tartoff);
>>
>>         return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now=
);
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index b476a876478d93..150f544445ca82 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -709,8 +709,6 @@ xfs_growfs_rt_alloc(
>>                 nmap =3D 1;
>>                 error =3D xfs_bmapi_write(tp, ip, oblocks, nblocks - obl=
ocks,
>>                                         XFS_BMAPI_METADATA, 0, &map, &nm=
ap);
>> -               if (!error && nmap < 1)
>> -                       error =3D -ENOSPC;
>>                 if (error)
>>                         goto out_trans_cancel;
>>                 /*
>> --
>> 2.39.2
>>
