Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CA6EB64DC
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 03:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjFZDSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 23:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjFZDSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jun 2023 23:18:31 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1BA11C
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 20:18:29 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2b588fa06d3so5684251fa.1
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 20:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687749508; x=1690341508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eqh2lEFJW7qzYey6Vp9BxMSITWDx8dOTTaMjVWMBfaE=;
        b=psN+E4O5ZIlE3BkuCFbkpeovkYEjqVpMy6lLzrirC9ZyEpMViaGX2FqXorZ4u6jePu
         3NCh+9y08n6JUw58bB608TD2QQx9jWnPu9rqKfhES7Y6Vv7Z6OsPhUjLwthtRTZkPO71
         PFr9DESKtFwIDmMwGnuRoKyxvyBq1GDirufCFBR9cdtylI74CWgVgcJX6W+7yeu5Er1Z
         rStwl4mvZb9HJbBMxJlCLVSTrTrHF8UoQofj7sj1cocaE4oPc8/K5Ba4UJHSl2SW22Oj
         KrSIRhr4Qr7/B2fXa+tGgQr6Tarh2+GwtGeyuqq+TD7XU0W6MwVJ7wNEa7OdMfeYt1wP
         8pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687749508; x=1690341508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eqh2lEFJW7qzYey6Vp9BxMSITWDx8dOTTaMjVWMBfaE=;
        b=fY7boofiiJCv29qqwXH02DjAlMN5pcXsbUIytrELDcjZt9oreB7BJv1dmQ1foVzNXv
         xXGs/4XC4l0XXEjjj5iOVPSA48zqjca3Dee0l4UcMu8eveEdvNuAyaIEnZCvefFtgQmb
         AkQ+cIRh+iUAiHp/JlLlMkBvIui+0q15IogyeNJFnU30JKEVI6Bi1xhdfl9nzhcz9lMQ
         pGkHvqMhEQTIIb5WD0PgI75sN2dj6AgZMjrm3SdW3T8HvAOl3glxS3+Da778g/OT/U/p
         4ADN8BNhqUTyHvo/BC+/qAEH4BCx8adEvFjrbNby7FRDxoAYGddpJJKfb3Dqi94plF3f
         HtOQ==
X-Gm-Message-State: AC+VfDwunFyhSVfSIhXfVu4qtOnF7TWOHiWWYH3lSBeh830GOP0slNqp
        2K0zPlGY5hh28LLunBPQ0BKdcH8t5JmaSOM2gQqzd2QysZI=
X-Google-Smtp-Source: ACHHUZ51oHECKLHOQqs48RfZwWVxZo7anzEtTr/6D1B6KmksZg8PjPtQaK0fwLsGCzd6tMsUeRk56jvs1g/A1h3G9Do=
X-Received: by 2002:a05:651c:1192:b0:2b6:999f:b16c with SMTP id
 w18-20020a05651c119200b002b6999fb16cmr1182969ljo.4.1687749507477; Sun, 25 Jun
 2023 20:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
In-Reply-To: <ZJTrrwirZqykiVxn@dread.disaster.area>
From:   Masahiko Sawada <sawada.mshk@gmail.com>
Date:   Mon, 26 Jun 2023 12:17:50 +0900
Message-ID: <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
Subject: Re: Question on slow fallocate
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 23, 2023 at 9:47=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
> > Hi all,
> >
> > When testing PostgreSQL, I found a performance degradation. After some
> > investigation, it ultimately reached the attached simple C program and
> > turned out that the performance degradation happens on only the xfs
> > filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> > program alternately does two things to extend a file (1) call
> > posix_fallocate() to extend by 8192 bytes
>
> This is a well known anti-pattern - it always causes problems. Do
> not do this.
>
> > and (2) call pwrite() to
> > extend by 8192 bytes. If I do only either (1) or (2), the program is
> > completed in 2 sec, but if I do (1) and (2) alternatively, it is
> > completed in 90 sec.
>
> Well, yes. Using fallocate to extend the file has very different
> constraints to using pwrite to extend the file.
>
> > $ gcc -o test test.c
> > $ time ./test test.1 1
> > total   200000
> > fallocate       200000
> > filewrite       0
>
> No data is written here, so this is just a series of 8kB allocations
> and file size extension operations. There are no constraints here
> because it is a pure metadata operation.
>
> > real    0m1.305s
> > user    0m0.050s
> > sys     0m1.255s
> >
> > $ time ./test test.2 2
> > total   200000
> > fallocate       100000
> > filewrite       100000
> >
> > real    1m29.222s
> > user    0m0.139s
> > sys     0m3.139s
>
> Now we have fallocate extending the file and doing unwritten extent
> allocation, followed by writing into that unwritten extent which
> then does unwritten extent conversion.
>
> This introduces data vs metadata update ordering constraints to the
> workload.
>
> The problem here in that the "truncate up" operation that
> fallocate is doing to move the file size. The "truncate up" is going
> to move the on-disk file size to the end of the fallocated range via
> a journal transaction, and so it will expose the range of the
> previous write as containing valid data.
>
> However, the previous data write is still only in memory and not on
> disk. The result of journalling the file size change is that if we
> crash after the size change is made but the data is not on disk,
> we end up with lost data - the file contains zeros (or NULLs) where
> the in memory data previously existed.
>
> Go google for "NULL file data exposure" and you'll see this is a
> problem we fixed in ~2006, caused by extending the file size on disk
> without first having written all the in-memory data into the file.
> And even though we fixed the problem over 15 years ago, we still
> hear people today saying "XFS overwrites user data with NULLs!" as
> their reason for never using XFS, even though this was never true in
> the first place..
>
> The result of users demanding that we prevent poorly written
> applications from losing their data is that users get poor
> performance when their applications are poorly written. i.e. they do
> something that triggers the data integrity ordering constraints that
> users demand we work within.

Thank you for the detailed explanation.

>
> So, how to avoid the problem?
>
> With 'posix_fallocate(fd, total_len, 8192);':
>
> $ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 1
> total   200000
> fallocate       200000
> filewrite       0
>
> real    0m2.557s
> user    0m0.025s
> sys     0m2.531s
> $ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 2
> total   200000
> fallocate       100000
> filewrite       100000
>
> real    0m39.564s
> user    0m0.117s
> sys     0m7.535s
>
>
> With 'fallocate(fd, FALLOC_FL_KEEP_SIZE, total_len, 8192);':
>
> $ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 1
> total   200000
> fallocate       200000
> filewrite       0
>
> real    0m2.269s
> user    0m0.037s
> sys     0m2.233s
> $ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 2
> total   200000
> fallocate       100000
> filewrite       100000
>
> real    0m1.068s
> user    0m0.028s
> sys     0m1.040s
>
> Yup, just stop fallocate() from extending the file size and leave
> that to the pwrite() call that actually writes the data into the
> file.
>
> As it is, using fallocate/pwrite like test does is a well known
> anti-pattern:
>
>         error =3D fallocate(fd, off, len);
>         if (error =3D=3D ENOSPC) {
>                 /* abort write!!! */
>         }
>         error =3D pwrite(fd, off, len);
>         ASSERT(error !=3D ENOSPC);
>         if (error) {
>                 /* handle error */
>         }
>

The test.c and what PostgreSQL does are slightly different from the
above pattern actually: it calls fallocate and pwrites for different
8kB blocks. For example, it calls fallocate to extend the file from 0
byte to 8192 bytes, and then calls pwrite to extend the file from 8192
bytes to 16384 bytes. But it's also not a recommended use, right?

> Why does the code need a call to fallocate() here it prevent ENOSPC in th=
e
> pwrite() call?
>
> The answer here is that it *doesn't need to use fallocate() here*.
> THat is, the fallocate() ENOSPC check before the space is allocated
> is exactly the same as the ENOSPC check done in the pwrite() call to
> see if there is space for the write to proceed.
>
> IOWs, the fallocate() call is *completely redundant*, yet it is
> actively harmful to performance in the short term (as per the
> issue in this thread) as well as being harmful for file fragmentation
> levels and filesystem longevity because it prevents the filesystem
> from optimising away unnecessary allocations. i.e. it defeats
> delayed allocation which allows filesystem to combine lots of
> small sequential write() calls in a single big contiguous extent
> allocation when the data is getting written to disk.
>
> IOWs, using fallocate() in the way described in this test is a sign
> of applicaiton developers not understanding what preallocation
> actually does and the situations where it actually provides some
> kinds of benefit.
>
> i.e. fallocate() is intended to allow applications to preallocate
> space in large chunks long before it is needed, and still have it
> available when the application actually needs to write to it. e.g.
> preallocate 10MB at a time, not have to run fallocate again until the
> existing preallocated chunk is entirely used up by the next thousand
> 8KB writes that extend the file.
>
> Using fallocate() as a replacement for "truncate up before write" is
> *not a recommended use*.

FYI, to share the background of what PostgreSQL does, when
bulk-insertions into one table are running concurrently, one process
extends the underlying files depending on how many concurrent
processes are waiting to extend. The more processes wait, the more 8kB
blocks are appended. As the current implementation, if the process
needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
details). We don't use fallocate() for small extensions as it's slow
on some filesystems. Therefore, if a bulk-insertion process tries to
extend the table by say 5~10 blocks many times, it could use
poxis_fallocate() and pwrite() alternatively, which led to the slow
performance as I reported.

>
> > Why does it take so long in the latter case? and are there any
> > workaround or configuration changes to deal with it?
>
> Let pwrite() do the file extension because it natively handles data
> vs metadata ordering without having to flush data to disk and wait
> for it. i.e. do not use fallocate() as if it is ftruncate(). Also,
> do not use posix_fallocate() - it gives you no control over how
> preallocation is done, use fallocate() directly. And if you must use
> fallocate() before a write, use fallocate(fd, FALLOC_FL_KEEP_SIZE,
> off, len) so that the file extension is done by the pwrite() to
> avoid any metadata/data ordering constraints that might exist with
> non-data write related file size changes.
>

Thanks. Wang Yugui reported that this slow performance seems not to
happen on newer kernel versions, but is that right?

Fortunately, this behavior is still beta (PG16 beta). I will discuss
alternative solutions in the PostgreSQL community.

Regards,

[1] https://github.com/postgres/postgres/blob/master/src/backend/storage/sm=
gr/md.c#L577

--=20
Masahiko Sawada
Amazon Web Services: https://aws.amazon.com
