Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6DB1F9A8B;
	Wed,  8 Jan 2025 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336771; cv=none; b=qXWx9CY0hrWy6Z2hMZ0vGqq4TKT2zBEBWMsmuTGovwVJqpnnxvnIqW6NzvnUL2KfD4fjB3Wu5guPuTHLgUSiKQqvP4ttrCyc2/60eMHRmL6SaRTNlC0PCOk/4zYHy9RZteHqZ+SXHAWFDwbXvlqhBeGc5h+mMKuU1hBqp1Vy4Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336771; c=relaxed/simple;
	bh=Nq23CviHXma256fT5k+G93WzBcw74FRCYQNt4+eS70o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dHb8yp/bwf/r6Q2TK/IbwfH1C12z78RrsSwOt/HX3x1dmj/CigbuwBJOhty7AFem1tbQ5QFRpmZJO6lssj0QxYx/b4ZjpmTOJ2bb8s4dTDzHw9sWSj+0Ohv9fV9dgi/hKhkV2FWCY8diVZeap9+oM0yVJUaK5CwHk1Q2tp9o5W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F57bwOJa; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F57bwOJa"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaf60d85238so1231058166b.0;
        Wed, 08 Jan 2025 03:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736336768; x=1736941568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D17PnlShZ7rL2aKsp3wyjTJBFwAvVDImQ5GIOwEHxgo=;
        b=F57bwOJasEi4YmaeBGBdrz/yBfdcc2V+p9KqZzaGcJKQU+M6MrTG299pfAnAD2KLAD
         f5JYBDzsNf41ZuM6YbNo4E+nYQM5/2rQQqFGD+We4r8nkzUPCHt3QsbaHPEqTCXJCkS+
         gQmSclpB3WT0Limt8L7se8vmcMJDQgJrQjBqelQyO9D/ADGbzhpOz4CjRrG7VBK+Zp7Z
         ARPIaPN4ElzQjDLuREGFO1HZ3YT99qo04QlyNxwHwt+zEoo9RDkb28+xOTXN9LWboMjS
         AwH7QbP6Y5XSLMEPEWtvCKgvI71P0WwTGPPyZu+Bf7ACqIHlUbZSBX0fVSLhQsu5btk3
         DQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336768; x=1736941568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D17PnlShZ7rL2aKsp3wyjTJBFwAvVDImQ5GIOwEHxgo=;
        b=dkOUhrbQp13j0pa2OsP0a67fbjIRsiswrwMBd5YSNWMBXHUCVvKNJ7G5o9C7UHjoub
         iEeuGHKla+LeI503j0t/UI8vwGGnLA67hI/FfU3W1XDG3iZ05+00/LDIcFkeGZIAmSo5
         GtKF/Cy+HHeApOm+a8zRN96lGSG4UuB4zkozfCLyDDhALcOzKuTGYLuvzqAGfigr0+99
         jeUNfnjas0HnE9nuVoUEdoDzADM/rO6JMaVwUYNnvrawQmZlGFsLySYa2LvA3AVncXRK
         YOtP8Ls0dtP3GzPoVs+UtT0BiNvGWimQnUYsfN0Ty/M9J61pUGYIlZi3tFIYHM0J7tSr
         uwjA==
X-Forwarded-Encrypted: i=1; AJvYcCVJDvfP/p/Q4V+QOowmRDH/Jn3/SU0gB7Ojkj3+pvW5bAo3Ah6FPRyJvU2T8eCXn08Lf6xRUgpjF8rO@vger.kernel.org, AJvYcCWJYF3WsDje6qpEzREsrIsLRCGt3DV4hB9zw8E8w/wq3Yc06nbb5F3b6kAVgcu6vdziC8a20kbkrkoQ1bI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUdkh1Nb+HgzvF73+Aou027balAH+uYcwg4C7gSPX4otv/kyvG
	lWXe0PzGbdWwJBfMQzGLt89dgOqaJJnitM/vsnmd9G8p3My0lthZo+Bn0cxNPlrzz8kHbnUw4Bi
	QudtkmXAMU6JvnigfoP1/eR29nZ0=
X-Gm-Gg: ASbGncuvPmuzTtfOUZi7BbWdUSG1eTMZP8y7Y3EtDsMZF6iQSWcT5gf08n0S8/EdYVV
	3TuR5r4a9629MLa5Gq+A6EdZAzPq5o8b5OADxgw==
X-Google-Smtp-Source: AGHT+IE//NWYZFCQ0V5HxjUGjIFX731AOyksc1rONJnzhL0Mim/5DogRVvlwJ7bKDRpfC+W5hJPOr9L2zXA88QIdK9Q=
X-Received: by 2002:a17:907:6d04:b0:aa6:9ee2:f4c9 with SMTP id
 a640c23a62f3a-ab2ab6c6dffmr161652266b.23.1736336767181; Wed, 08 Jan 2025
 03:46:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com> <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com> <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjgGQmeid3-wa5VNy5EeOYNz+FmTAZVOtUsw+2F+x9fdQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jan 2025 12:45:55 +0100
X-Gm-Features: AbW1kvb88rInkoQlW5NH6T0bLQFWTwU2OZifwz1YWVi90pAzqyyH8HEuviCXSBs
Message-ID: <CAOQ4uxgurXXQ23wkk_oB4Vx6Ej3ga5vv_94OVi28arOhaTWOKA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Chi Zhiling <chizhiling@163.com>, John Garry <john.g.garry@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 12:33=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Jan 8, 2025 at 8:43=E2=80=AFAM Chi Zhiling <chizhiling@163.com> w=
rote:
> >
> > On 2025/1/7 20:13, Amir Goldstein wrote:
> > > On Mon, Dec 30, 2024 at 3:43=E2=80=AFAM Chi Zhiling <chizhiling@163.c=
om> wrote:
> > >> On 2024/12/29 06:17, Dave Chinner wrote:
> > >>> On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> > >>>> On 2024/12/27 05:50, Dave Chinner wrote:
> > >>>>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > >>>>>> From: Chi Zhiling <chizhiling@kylinos.cn>
> > >>>>>>
> > >>>>>> Using an rwsem to protect file data ensures that we can always o=
btain a
> > >>>>>> completed modification. But due to the lock, we need to wait for=
 the
> > >>>>>> write process to release the rwsem before we can read it, even i=
f we are
> > >>>>>> reading a different region of the file. This could take a lot of=
 time
> > >>>>>> when many processes need to write and read this file.
> > >>>>>>
> > >>>>>> On the other hand, The ext4 filesystem and others do not hold th=
e lock
> > >>>>>> during buffered reading, which make the ext4 have better perform=
ance in
> > >>>>>> that case. Therefore, I think it will be fine if we remove the l=
ock in
> > >>>>>> xfs, as most applications can handle this situation.
> > >>>>>
> > >>>>> Nope.
> > >>>>>
> > >>>>> This means that XFS loses high level serialisation of incoming IO
> > >>>>> against operations like truncate, fallocate, pnfs operations, etc=
.
> > >>>>>
> > >>>>> We've been through this multiple times before; the solution lies =
in
> > >>>>> doing the work to make buffered writes use shared locking, not
> > >>>>> removing shared locking from buffered reads.
> > >>>>
> > >>>> You mean using shared locking for buffered reads and writes, right=
?
> > >>>>
> > >>>> I think it's a great idea. In theory, write operations can be perf=
ormed
> > >>>> simultaneously if they write to different ranges.
> > >>>
> > >>> Even if they overlap, the folio locks will prevent concurrent write=
s
> > >>> to the same range.
> > >>>
> > >>> Now that we have atomic write support as native functionality (i.e.
> > >>> RWF_ATOMIC), we really should not have to care that much about
> > >>> normal buffered IO being atomic. i.e. if the application wants
> > >>> atomic writes, it can now specify that it wants atomic writes and s=
o
> > >>> we can relax the constraints we have on existing IO...
> > >>
> > >> Yes, I'm not particularly concerned about whether buffered I/O is
> > >> atomic. I'm more concerned about the multithreading performance of
> > >> buffered I/O.
> > >
> > > Hi Chi,
> > >
> > > Sorry for joining late, I was on vacation.
> > > I am very happy that you have taken on this task and your timing is g=
ood,
> > > because  John Garry just posted his patches for large atomic writes [=
1].
> >
> > I'm glad to have you on board. :)
> >
> > I'm not sure if my understanding is correct, but it seems that our
> > discussion is about multithreading safety, while John's patch is about
> > providing power-failure safety, even though both mention atomicity.
> >
>
> You are right about the *motivation* of John's work.
> But as a by-product of his work, we get an API to opt-in for
> atomic writes and we can piggy back this opt-in API to say
> that whoever wants the legacy behavior can use the new API
> to get both power failure safety and multithreading safety.
>
> > >
> > > I need to explain the relation to atomic buffered I/O, because it is =
not
> > > easy to follow it from the old discussions and also some of the discu=
ssions
> > > about the solution were held in-person during LSFMM2024.
> > >
> > > Naturally, your interest is improving multithreading performance of
> > > buffered I/O, so was mine when I first posted this question [2].
> > >
> > > The issue with atomicity of buffered I/O is the xfs has traditionally
> > > provided atomicity of write vs. read (a.k.a no torn writes), which is
> > > not required by POSIX standard (because POSIX was not written with
> > > threads in mind) and is not respected by any other in-tree filesystem=
.
> > >
> > > It is obvious that the exclusive rw lock for buffered write hurts per=
formance
> > > in the case of mixed read/write on xfs, so the question was - if xfs =
provides
> > > atomic semantics that portable applications cannot rely on, why bothe=
r
> > > providing these atomic semantics at all?
> >
> > Perhaps we can add an option that allows distributions or users to
> > decide whether they need this semantics. I would not hesitate to
> > turn off this semantics on my system when the time comes.
> >
>
> Yes, we can, but we do not want to do it unless we have to.
> 99% of the users do not want the legacy semantics, so it would
> be better if they get the best performance without having to opt-in to ge=
t it.
>
> > >
> > > Dave's answer to this question was that there are some legacy applica=
tions
> > > (database applications IIRC) on production systems that do rely on th=
e fact
> > > that xfs provides this semantics and on the prerequisite that they ru=
n on xfs.
> > >
> > > However, it was noted that:
> > > 1. Those application do not require atomicity for any size of IO, the=
y
> > >      typically work in I/O size that is larger than block size (e.g. =
16K or 64K)
> > >      and they only require no torn writes for this I/O size
> > > 2. Large folios and iomap can usually provide this semantics via foli=
o lock,
> > >      but application has currently no way of knowing if the semantics=
 are
> > >      provided or not
> >
> > To be honest, it would be best if the folio lock could provide such
> > semantics, as it would not cause any potential problems for the
> > application, and we have hope to achieve concurrent writes.
> >
> > However, I am not sure if this is easy to implement and will not cause
> > other problems.
> >
> > > 3. The upcoming ability of application to opt-in for atomic writes la=
rger
> > >      than fs block size [1] can be used to facilitate the application=
s that
> > >      want to legacy xfs semantics and avoid the need to enforce the l=
egacy
> > >      semantics all the time for no good reason
> > >
> > > Disclaimer: this is not a standard way to deal with potentially break=
ing
> > > legacy semantics, because old applications will not usually be rebuil=
t
> > > to opt-in for the old semantics, but the use case in hand is probably
> > > so specific, of a specific application that relies on xfs specific se=
mantics
> > > that there are currently no objections for trying this solution.
> > >
> > > [1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.g=
arry@oracle.com/
> > > [2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ER=
JZno3JSeZR71S1dXg+2w@mail.gmail.com/
> > >
> > >>
> > >> Last week, it was mentioned that removing i_rwsem would have some
> > >> impacts on truncate, fallocate, and PNFS operations.
> > >>
> > >> (I'm not familiar with pNFS, so please correct me if I'm wrong.)
> > >
> > > You are not wrong. pNFS uses a "layout lease", which requires
> > > that the blockmap of the file will not be modified while the lease is=
 held.
> > > but I think that block that are not mapped (i.e. holes) can be mapped
> > > while the lease is held.
> > >
> > >>
> > >> My understanding is that the current i_rwsem is used to protect both
> > >> the file's data and its size. Operations like truncate, fallocate,
> > >> and PNFS use i_rwsem because they modify both the file's data and it=
s
> > >> size. So, I'm thinking whether it's possible to use i_rwsem to prote=
ct
> > >> only the file's size, without protecting the file's data.
> > >>
> > >
> > > It also protects the file's blockmap, for example, punch hole
> > > does not change the size, but it unmaps blocks from the blockmap,
> > > leading to races that could end up reading stale data from disk
> > > if the lock wasn't taken.
> > >
> > >> So operations that modify the file's size need to be executed
> > >> sequentially. For example, buffered writes to the EOF, fallocate
> > >> operations without the "keep size" requirement, and truncate operati=
ons,
> > >> etc, all need to hold an exclusive lock.
> > >>
> > >> Other operations require a shared lock because they only need to acc=
ess
> > >> the file's size without modifying it.
> > >>
> > >
> > > As far as I understand, exclusive lock is not needed for non-extendin=
g
> > > writes, because it is ok to map new blocks.
> > > I guess the need for exclusive lock for extending writes is related t=
o
> > > update of file size, but not 100% sure.
> > > Anyway, exclusive lock on extending write is widely common in other f=
s,
> > > while exclusive lock for non-extending write is unique to xfs.
> > >
> > >>>
> > >>>> So we should track all the ranges we are reading or writing,
> > >>>> and check whether the new read or write operations can be performe=
d
> > >>>> concurrently with the current operations.
> > >>>
> > >>> That is all discussed in detail in the discussions I linked.
> > >>
> > >> Sorry, I overlooked some details from old discussion last time.
> > >> It seems that you are not satisfied with the effectiveness of
> > >> range locks.
> > >>
> > >
> > > Correct. This solution was taken off the table.
> > >
> > > I hope my explanation was correct and clear.
> > > If anything else is not clear, please feel free to ask.
> > >
> >
> > I think your explanation is very clear.
>
> One more thing I should mention.
> You do not need to wait for atomic large writes patches to land.
> There is nothing stopping you from implementing the suggested
> solution based on the xfs code already in master (v6.13-rc1),
> which has support for the RWF_ATOMIC flag for writes.
>
> It just means that the API will not be usable for applications that
> want to do IO larger than block size, but concurrent read/write
> performance of 4K IO could be improved already.
>
> It's possible that all you need to do is:
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c488ae26b23d0..2542f15496488 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -777,9 +777,10 @@ xfs_file_buffered_write(
>         ssize_t                 ret;
>         bool                    cleared_space =3D false;
>         unsigned int            iolock;
> +       bool                    atomic_write =3D iocb->ki_flags & IOCB_AT=
OMIC;
>
>  write_retry:
> -       iolock =3D XFS_IOLOCK_EXCL;
> +       iolock =3D atomic_write ? XFS_IOLOCK_SHARED : XFS_IOLOCK_EXCL;

It's the other way around of course :)
and did not state the obvious - this mock patch is NOT TESTED!

Thanks,
Amir.

>         ret =3D xfs_ilock_iocb(iocb, iolock);
> --
>
> xfs_file_write_checks() afterwards already takes care of promoting
> XFS_IOLOCK_SHARED to XFS_IOLOCK_EXCL for extending writes.
>
> It is possible that XFS_IOLOCK_EXCL could be immediately demoted
> back to XFS_IOLOCK_SHARED for atomic_writes as done in
> xfs_file_dio_write_aligned().
>
> TBH, I am not sure which blockdevs support 4K atomic writes that could
> be used to test this.
>
> John, can you share your test setup instructions for atomic writes?
>
> Thanks,
> Amir.
