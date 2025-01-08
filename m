Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7691F9A84;
	Wed,  8 Jan 2025 11:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336012; cv=none; b=My2X2mcEWrhwtrEhA10bRXwVpAigkoHq9T7s3wd4c2PoNgi9yYLMaGSD3GunR8Y5bLXiDT7rFPp9bSLSpRrywDW/wBVtEJHWx7IOJKSlx1oQGobdLzVuUaiP7/FOTDOpddQHme1tj9jTZDOtiLwE0fxW2a5YGcmHMoaiJkf2WGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336012; c=relaxed/simple;
	bh=jSuH85WNiwFKLLKodZoY9zliP7OhXbjXtn6aEHM9SoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twRGgSVbEvv6LEm3bp/k7F9BlOzORoV0HCzomlv8luVhiiu4w5IaMAIj6fgJbscUqL+V2UjA6UkncKY+TvFlyFOCpR53igTeK7tobwO+NJI6Qf2G04gP7Ncu0zFzKPjP213gTQMEHffmQa8EaONzKn7bZfFcJ/hRH0/8H6KUczY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CSGgHqjA; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSGgHqjA"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaef00ab172so1938381766b.3;
        Wed, 08 Jan 2025 03:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736336008; x=1736940808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZ1ZyZ5Y5EKcPcBAf91GyYPCpvdtIctxMDxxTQKiPpA=;
        b=CSGgHqjAiVV/J3xit+B+RxfaYmTewusNATQGEZjVbvtr21Qklt3WCWD7O30tARm8dx
         pllOa9oP/Q+foQIJERcDdPazY0BmCySyc5aGinpO0g2RP6i/2ZcoomDMhgJnw/Dd21DK
         6tJgxs/Q93+/pnGE0fFQKaz0WvK8DKyyWsuhDn8rPW7cShDjfF6i17uvDtljxqBl5X/v
         7A+0fUBuSdneiPTKND5x3l4bnNQcHre4cix7NsPDTz67O2aj8z2eWUn2U7tGhdH+2ZVO
         LZ8wXV9skfHUNvVlkQUwVR19KFNxdXD3uqpwgznuFqoQuavfbPGBBqJe0uFErHVmjYSb
         xsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336008; x=1736940808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZ1ZyZ5Y5EKcPcBAf91GyYPCpvdtIctxMDxxTQKiPpA=;
        b=HiTb3bijPPCftSpoYcXNu9osJXjo4Ti0yOHkUfMXJ6c0EBBJTlBQZITX737hy1H6at
         McKJblofbCVSoqk39/x14DhYrLuw4yaZhGHrsg9S26NI26CQOCMbqFVNvtipaOjmFG1E
         xf4k150qukByutRMtuilrVq3G0VQ714zEQh4lFA8vSCgjE12I/l4P5K4mw2N6fMeUwP7
         L7XL79N3PKgyaeEqEgj7no7lLYzQjVQ81vj4r2I+kyOCbbAQCj/WmB3F4zk80wixSf8n
         D5MFO3GxnbVVO6NDBK/pF9AvMBUu4mzlJ9/VIenTPgsrZZR4XH23z1uIq91TU9kIlOqz
         pTGw==
X-Forwarded-Encrypted: i=1; AJvYcCVrnFYX5I4+ErV/TRinPI+KwZzyBfGpDTIBXbEYYmLkHPcVmXFHJNP/F7dbsxpZlxKCIGIEtSaD+NjNs0k=@vger.kernel.org, AJvYcCVwnikomvmbg/Gr5BFh+hM4Ntn/iYN5SL70K/FD63FSobVQRmabpk2jWFelrFSGvBuB1w5Ny5Tl407T@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs5/hh5+e2FebCznhcnpP+nx+yT1Y064iK/pW1jv+EcGKlzuNu
	uTTbad0JNfD+XTjPA1bWMJ9uc/FJNATyQ92LK/NOe5t1IrI3JlZseaFTXrP19TdZLJeDBy5X1z9
	POuKcFUSBA5WyFGfSvaXFztXNYGXQXsGhBzNiLg==
X-Gm-Gg: ASbGncuqDztIrtGxqLC3RLq8JaB1yurpQxU/Q5pJfb3ChP0jS1h42rc7nRwYr4zhISa
	ITHy2fKKpWYGo2cPMcx5/4BMR6XKhS/dEiaICug==
X-Google-Smtp-Source: AGHT+IGD6w3QPL/fCE+8taaArY6NgBB+ICf1cDTtEZHrE+NFTCU3jpKEkwX8MpabCXAsilReZw1DCljuAXXu6J5+nY4=
X-Received: by 2002:a05:6402:530f:b0:5d1:2377:5af3 with SMTP id
 4fb4d7f45d1cf-5d972e00027mr4810133a12.5.1736336007585; Wed, 08 Jan 2025
 03:33:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
In-Reply-To: <953b0499-5832-49dc-8580-436cf625db8c@163.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jan 2025 12:33:16 +0100
X-Gm-Features: AbW1kvaU3A53YpxiRbwxz7IbuZHsGf976DQT5PW0zyr1KHSudMWcg3nywnMnbm8
Message-ID: <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Chi Zhiling <chizhiling@163.com>, John Garry <john.g.garry@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 8:43=E2=80=AFAM Chi Zhiling <chizhiling@163.com> wro=
te:
>
> On 2025/1/7 20:13, Amir Goldstein wrote:
> > On Mon, Dec 30, 2024 at 3:43=E2=80=AFAM Chi Zhiling <chizhiling@163.com=
> wrote:
> >> On 2024/12/29 06:17, Dave Chinner wrote:
> >>> On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> >>>> On 2024/12/27 05:50, Dave Chinner wrote:
> >>>>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> >>>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
> >>>>>>
> >>>>>> Using an rwsem to protect file data ensures that we can always obt=
ain a
> >>>>>> completed modification. But due to the lock, we need to wait for t=
he
> >>>>>> write process to release the rwsem before we can read it, even if =
we are
> >>>>>> reading a different region of the file. This could take a lot of t=
ime
> >>>>>> when many processes need to write and read this file.
> >>>>>>
> >>>>>> On the other hand, The ext4 filesystem and others do not hold the =
lock
> >>>>>> during buffered reading, which make the ext4 have better performan=
ce in
> >>>>>> that case. Therefore, I think it will be fine if we remove the loc=
k in
> >>>>>> xfs, as most applications can handle this situation.
> >>>>>
> >>>>> Nope.
> >>>>>
> >>>>> This means that XFS loses high level serialisation of incoming IO
> >>>>> against operations like truncate, fallocate, pnfs operations, etc.
> >>>>>
> >>>>> We've been through this multiple times before; the solution lies in
> >>>>> doing the work to make buffered writes use shared locking, not
> >>>>> removing shared locking from buffered reads.
> >>>>
> >>>> You mean using shared locking for buffered reads and writes, right?
> >>>>
> >>>> I think it's a great idea. In theory, write operations can be perfor=
med
> >>>> simultaneously if they write to different ranges.
> >>>
> >>> Even if they overlap, the folio locks will prevent concurrent writes
> >>> to the same range.
> >>>
> >>> Now that we have atomic write support as native functionality (i.e.
> >>> RWF_ATOMIC), we really should not have to care that much about
> >>> normal buffered IO being atomic. i.e. if the application wants
> >>> atomic writes, it can now specify that it wants atomic writes and so
> >>> we can relax the constraints we have on existing IO...
> >>
> >> Yes, I'm not particularly concerned about whether buffered I/O is
> >> atomic. I'm more concerned about the multithreading performance of
> >> buffered I/O.
> >
> > Hi Chi,
> >
> > Sorry for joining late, I was on vacation.
> > I am very happy that you have taken on this task and your timing is goo=
d,
> > because  John Garry just posted his patches for large atomic writes [1]=
.
>
> I'm glad to have you on board. :)
>
> I'm not sure if my understanding is correct, but it seems that our
> discussion is about multithreading safety, while John's patch is about
> providing power-failure safety, even though both mention atomicity.
>

You are right about the *motivation* of John's work.
But as a by-product of his work, we get an API to opt-in for
atomic writes and we can piggy back this opt-in API to say
that whoever wants the legacy behavior can use the new API
to get both power failure safety and multithreading safety.

> >
> > I need to explain the relation to atomic buffered I/O, because it is no=
t
> > easy to follow it from the old discussions and also some of the discuss=
ions
> > about the solution were held in-person during LSFMM2024.
> >
> > Naturally, your interest is improving multithreading performance of
> > buffered I/O, so was mine when I first posted this question [2].
> >
> > The issue with atomicity of buffered I/O is the xfs has traditionally
> > provided atomicity of write vs. read (a.k.a no torn writes), which is
> > not required by POSIX standard (because POSIX was not written with
> > threads in mind) and is not respected by any other in-tree filesystem.
> >
> > It is obvious that the exclusive rw lock for buffered write hurts perfo=
rmance
> > in the case of mixed read/write on xfs, so the question was - if xfs pr=
ovides
> > atomic semantics that portable applications cannot rely on, why bother
> > providing these atomic semantics at all?
>
> Perhaps we can add an option that allows distributions or users to
> decide whether they need this semantics. I would not hesitate to
> turn off this semantics on my system when the time comes.
>

Yes, we can, but we do not want to do it unless we have to.
99% of the users do not want the legacy semantics, so it would
be better if they get the best performance without having to opt-in to get =
it.

> >
> > Dave's answer to this question was that there are some legacy applicati=
ons
> > (database applications IIRC) on production systems that do rely on the =
fact
> > that xfs provides this semantics and on the prerequisite that they run =
on xfs.
> >
> > However, it was noted that:
> > 1. Those application do not require atomicity for any size of IO, they
> >      typically work in I/O size that is larger than block size (e.g. 16=
K or 64K)
> >      and they only require no torn writes for this I/O size
> > 2. Large folios and iomap can usually provide this semantics via folio =
lock,
> >      but application has currently no way of knowing if the semantics a=
re
> >      provided or not
>
> To be honest, it would be best if the folio lock could provide such
> semantics, as it would not cause any potential problems for the
> application, and we have hope to achieve concurrent writes.
>
> However, I am not sure if this is easy to implement and will not cause
> other problems.
>
> > 3. The upcoming ability of application to opt-in for atomic writes larg=
er
> >      than fs block size [1] can be used to facilitate the applications =
that
> >      want to legacy xfs semantics and avoid the need to enforce the leg=
acy
> >      semantics all the time for no good reason
> >
> > Disclaimer: this is not a standard way to deal with potentially breakin=
g
> > legacy semantics, because old applications will not usually be rebuilt
> > to opt-in for the old semantics, but the use case in hand is probably
> > so specific, of a specific application that relies on xfs specific sema=
ntics
> > that there are currently no objections for trying this solution.
> >
> > [1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.gar=
ry@oracle.com/
> > [2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZ=
no3JSeZR71S1dXg+2w@mail.gmail.com/
> >
> >>
> >> Last week, it was mentioned that removing i_rwsem would have some
> >> impacts on truncate, fallocate, and PNFS operations.
> >>
> >> (I'm not familiar with pNFS, so please correct me if I'm wrong.)
> >
> > You are not wrong. pNFS uses a "layout lease", which requires
> > that the blockmap of the file will not be modified while the lease is h=
eld.
> > but I think that block that are not mapped (i.e. holes) can be mapped
> > while the lease is held.
> >
> >>
> >> My understanding is that the current i_rwsem is used to protect both
> >> the file's data and its size. Operations like truncate, fallocate,
> >> and PNFS use i_rwsem because they modify both the file's data and its
> >> size. So, I'm thinking whether it's possible to use i_rwsem to protect
> >> only the file's size, without protecting the file's data.
> >>
> >
> > It also protects the file's blockmap, for example, punch hole
> > does not change the size, but it unmaps blocks from the blockmap,
> > leading to races that could end up reading stale data from disk
> > if the lock wasn't taken.
> >
> >> So operations that modify the file's size need to be executed
> >> sequentially. For example, buffered writes to the EOF, fallocate
> >> operations without the "keep size" requirement, and truncate operation=
s,
> >> etc, all need to hold an exclusive lock.
> >>
> >> Other operations require a shared lock because they only need to acces=
s
> >> the file's size without modifying it.
> >>
> >
> > As far as I understand, exclusive lock is not needed for non-extending
> > writes, because it is ok to map new blocks.
> > I guess the need for exclusive lock for extending writes is related to
> > update of file size, but not 100% sure.
> > Anyway, exclusive lock on extending write is widely common in other fs,
> > while exclusive lock for non-extending write is unique to xfs.
> >
> >>>
> >>>> So we should track all the ranges we are reading or writing,
> >>>> and check whether the new read or write operations can be performed
> >>>> concurrently with the current operations.
> >>>
> >>> That is all discussed in detail in the discussions I linked.
> >>
> >> Sorry, I overlooked some details from old discussion last time.
> >> It seems that you are not satisfied with the effectiveness of
> >> range locks.
> >>
> >
> > Correct. This solution was taken off the table.
> >
> > I hope my explanation was correct and clear.
> > If anything else is not clear, please feel free to ask.
> >
>
> I think your explanation is very clear.

One more thing I should mention.
You do not need to wait for atomic large writes patches to land.
There is nothing stopping you from implementing the suggested
solution based on the xfs code already in master (v6.13-rc1),
which has support for the RWF_ATOMIC flag for writes.

It just means that the API will not be usable for applications that
want to do IO larger than block size, but concurrent read/write
performance of 4K IO could be improved already.

It's possible that all you need to do is:

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c488ae26b23d0..2542f15496488 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -777,9 +777,10 @@ xfs_file_buffered_write(
        ssize_t                 ret;
        bool                    cleared_space =3D false;
        unsigned int            iolock;
+       bool                    atomic_write =3D iocb->ki_flags & IOCB_ATOM=
IC;

 write_retry:
-       iolock =3D XFS_IOLOCK_EXCL;
+       iolock =3D atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;
        ret =3D xfs_ilock_iocb(iocb, iolock);
--

xfs_file_write_checks() afterwards already takes care of promoting
XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.

It is possible that XFS_IOLOCK_EXCL could be immediately demoted
back to XFS_IOLOCK_SHARED for atomic_writes as done in
xfs_file_dio_write_aligned().

TBH, I am not sure which blockdevs support 4K atomic writes that could
be used to test this.

John, can you share your test setup instructions for atomic writes?

Thanks,
Amir.
