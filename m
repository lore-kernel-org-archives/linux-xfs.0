Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9201A224D4;
	Sat, 25 Jan 2025 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737814504; cv=none; b=VQnUeo4CO1iIsBuiEVFltoUQAZr4MgYD0eTWcpt9OwUQfpjBHjsYNseqFp2PK3cs4fwt07VksqzoX8jb9Ub3re/TSN67fd6NlpUcDtRjvSCMajkX7pAZreUZWVZyeCnoWupMm8ymNIFTgP1fODYYaF/4AMRWxB7xBavaH+xssEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737814504; c=relaxed/simple;
	bh=4oI/OFes3Ja3lzrC2HHSiRozXgrmAeQ1jkYZuSGcUDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hm4xDt4tK3sc68L5yhJorU8OcacFVC0cTDNZcJdM/hdcOPttrkuMCZu5YzcriqQgmIPMEy3lfDY12wGE7dwNNH10e11Ksb4fRL+ZipPGh3AimtF15rDpiblSCTny3qscAl8wTPC67SV7h/9s26KQhVNoACgrnBrcpbT3Uk2wklM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hfDKLwO1; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hfDKLwO1"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso5746824a12.0;
        Sat, 25 Jan 2025 06:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737814501; x=1738419301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yy4F4zGsEWkyEtXzP0hJRqogsaP9xtTYG5I0B09BxTk=;
        b=hfDKLwO1aBO6QNRnJOTXIHdkOdCZfZYZMB/kc0s1htV+hdIPUB7+n0/PeWGK7t+QLJ
         uD9b2wWT5OqNAc3Bd2sDciB9WYKgSSf3Vzn05cb4mYIzQdP6A8C3sr0KyPaJBltmfu1k
         Zs3EIvddoiwWIkiQJw1Unra+kFVkiKYAo2nIk4aSHaivJZB157/n7e1CfFHacYL4tmRM
         Qz80SChOHk7uBVzGhOWmLc/6CIQobZUOGqE4ah6nHy0cZAHlMozWeI9FFEPs9svd/bYb
         bKbRj3ZXkSv1qlZQA++ZgGBpkE7ciQH9ToSW4MvxB5ktFKtgOlDD35ui9sG5gQb0MBot
         slSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737814501; x=1738419301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yy4F4zGsEWkyEtXzP0hJRqogsaP9xtTYG5I0B09BxTk=;
        b=hXKFii99hCKITdLlLs+NAvh8Hm+xqqgQo9V+vHtWu3nx7+H5Nldzi7bMr/YsziNnl2
         7RjmNjgtT+LHaYr9R0MO/Fx5pj3c3mLdq7BjljyFIcBRGZoMUTvwBmcnCebw4yS19J1l
         PZVxol9gAVGpOWixiZiNHtf8u64ZWtYmEUEaZfV4rBHGytCbtcAh7hFEttSDX7vEnJiW
         heJpagm1KuxUPa+49VWPTtdJLENiyMfwZyl9CCU1ENBbUi3ysBnwGJ5a0flfW45AKVUs
         w7VdoAAlaWkDPL6j1MADmGcEd6hBVxfjERqbbYXF/crKYQDMvV4KZDfgexux7+GvMrRh
         thuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwH12Phx9NCawarBnJfPSUmAjRmKeMX9mDfhVVArXNO9xc/SkWm0TFZz0+vvWuPsENXZupFkI9VkY3@vger.kernel.org, AJvYcCWPdiBemYGLxMxbP8qch781DbeHr5tHZiOk2qlJ1qMtwl8eFE/3+1awGH/CLUwKzaEQqDHCQZ/T/BYM50w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv+b6K+oyy7cPLTnuO5JWYR69N/TEwfgLsMBmdnFovpp+ha8ur
	NDoKXjH36vIMSBtbVfX2wqjCxBeJfzf55+xI9I0Mrty5erib6LORRVWKl1cxgLw5HDydyoN3OTb
	BYhMRA5jeCiB65iWcoT0v0cMr8C0=
X-Gm-Gg: ASbGncu+iBjZjUQqa5v5FVLPs3ro1/BaHqo9bkHNj+ByFiA3Js9sgOpNNmdzWdx7GXC
	oGbCRZHzb3SQvp54qIBj4PF33+xQ5ZW2eHcZ9DODNhnOXnasYZK95EhIdHC1VIg==
X-Google-Smtp-Source: AGHT+IFOkibvgbOKUGRq7ZPGNF/+OmP7fbxWpm42VKOBUmzPan00IHS049WxlovmmcJA/GB0F2IJgDFCzyo9HLWf718=
X-Received: by 2002:a05:6402:2807:b0:5db:7316:6309 with SMTP id
 4fb4d7f45d1cf-5db7d2dc140mr30764115a12.7.1737814500239; Sat, 25 Jan 2025
 06:15:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <20250125084327.154410-1-alexjlzheng@tencent.com>
In-Reply-To: <20250125084327.154410-1-alexjlzheng@tencent.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 25 Jan 2025 15:14:48 +0100
X-Gm-Features: AWEUYZnkZz-wh9SpTbswpoNSaccRJqxeJ5vIAeFomESPPZfxV5tqCbLkmtOMo-Q
Message-ID: <CAOQ4uxh=S9b6k6hjS9iY3_E7qdh1Zgc0cmZTQVwEQrVA=tQeWA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: cem@kernel.org, chizhiling@163.com, chizhiling@kylinos.cn, 
	david@fromorbit.com, djwong@kernel.org, john.g.garry@oracle.com, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2025 at 9:43=E2=80=AFAM Jinliang Zheng <alexjlzheng@gmail.c=
om> wrote:
>
> On Tue, 7 Jan 2025 13:13:17 +0100, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> > On Mon, Dec 30, 2024 at 3:43=E2=80=AFAM Chi Zhiling <chizhiling@163.com=
> wrote:
> > >
> > >
> > >
> > > On 2024/12/29 06:17, Dave Chinner wrote:
> > > > On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> > > >>
> > > >>
> > > >> On 2024/12/27 05:50, Dave Chinner wrote:
> > > >>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > > >>>> From: Chi Zhiling <chizhiling@kylinos.cn>
> > > >>>>
> > > >>>> Using an rwsem to protect file data ensures that we can always o=
btain a
> > > >>>> completed modification. But due to the lock, we need to wait for=
 the
> > > >>>> write process to release the rwsem before we can read it, even i=
f we are
> > > >>>> reading a different region of the file. This could take a lot of=
 time
> > > >>>> when many processes need to write and read this file.
> > > >>>>
> > > >>>> On the other hand, The ext4 filesystem and others do not hold th=
e lock
> > > >>>> during buffered reading, which make the ext4 have better perform=
ance in
> > > >>>> that case. Therefore, I think it will be fine if we remove the l=
ock in
> > > >>>> xfs, as most applications can handle this situation.
> > > >>>
> > > >>> Nope.
> > > >>>
> > > >>> This means that XFS loses high level serialisation of incoming IO
> > > >>> against operations like truncate, fallocate, pnfs operations, etc=
.
> > > >>>
> > > >>> We've been through this multiple times before; the solution lies =
in
> > > >>> doing the work to make buffered writes use shared locking, not
> > > >>> removing shared locking from buffered reads.
> > > >>
> > > >> You mean using shared locking for buffered reads and writes, right=
?
> > > >>
> > > >> I think it's a great idea. In theory, write operations can be perf=
ormed
> > > >> simultaneously if they write to different ranges.
> > > >
> > > > Even if they overlap, the folio locks will prevent concurrent write=
s
> > > > to the same range.
> > > >
> > > > Now that we have atomic write support as native functionality (i.e.
> > > > RWF_ATOMIC), we really should not have to care that much about
> > > > normal buffered IO being atomic. i.e. if the application wants
> > > > atomic writes, it can now specify that it wants atomic writes and s=
o
> > > > we can relax the constraints we have on existing IO...
> > >
> > > Yes, I'm not particularly concerned about whether buffered I/O is
> > > atomic. I'm more concerned about the multithreading performance of
> > > buffered I/O.
> >
> > Hi Chi,
> >
> > Sorry for joining late, I was on vacation.
> > I am very happy that you have taken on this task and your timing is goo=
d,
> > because  John Garry just posted his patches for large atomic writes [1]=
.
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
> >     typically work in I/O size that is larger than block size (e.g. 16K=
 or 64K)
> >     and they only require no torn writes for this I/O size
> > 2. Large folios and iomap can usually provide this semantics via folio =
lock,
> >     but application has currently no way of knowing if the semantics ar=
e
> >     provided or not
> > 3. The upcoming ability of application to opt-in for atomic writes larg=
er
> >     than fs block size [1] can be used to facilitate the applications t=
hat
> >     want to legacy xfs semantics and avoid the need to enforce the lega=
cy
> >     semantics all the time for no good reason
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
> > >
> > > Last week, it was mentioned that removing i_rwsem would have some
> > > impacts on truncate, fallocate, and PNFS operations.
> > >
> > > (I'm not familiar with pNFS, so please correct me if I'm wrong.)
> >
> > You are not wrong. pNFS uses a "layout lease", which requires
> > that the blockmap of the file will not be modified while the lease is h=
eld.
> > but I think that block that are not mapped (i.e. holes) can be mapped
> > while the lease is held.
> >
> > >
> > > My understanding is that the current i_rwsem is used to protect both
> > > the file's data and its size. Operations like truncate, fallocate,
> > > and PNFS use i_rwsem because they modify both the file's data and its
> > > size. So, I'm thinking whether it's possible to use i_rwsem to protec=
t
> > > only the file's size, without protecting the file's data.
> > >
> >
> > It also protects the file's blockmap, for example, punch hole
> > does not change the size, but it unmaps blocks from the blockmap,
> > leading to races that could end up reading stale data from disk
> > if the lock wasn't taken.
> >
> > > So operations that modify the file's size need to be executed
> > > sequentially. For example, buffered writes to the EOF, fallocate
> > > operations without the "keep size" requirement, and truncate operatio=
ns,
> > > etc, all need to hold an exclusive lock.
> > >
> > > Other operations require a shared lock because they only need to acce=
ss
> > > the file's size without modifying it.
> > >
> >
> > As far as I understand, exclusive lock is not needed for non-extending
> > writes, because it is ok to map new blocks.
> > I guess the need for exclusive lock for extending writes is related to
> > update of file size, but not 100% sure.
>
>
> > Anyway, exclusive lock on extending write is widely common in other fs,
> > while exclusive lock for non-extending write is unique to xfs.
>
> I am sorry but I can't understand, because I found ext4_buffered_write_it=
er()
> take exclusive lock unconditionally.
>
> Did I miss some context of the discussion?
>

No, I misspoke. Sorry.
The behavior that is unique to xfs is shared iolock on buffered read.
ext4 (and the rest) do not take iolock on buffered reads.

Internally, filemap_read() takes filemap_invalidate_lock_shared() as needed
to avoid races with truncate and punch hole.

Before the introduction of filemap_invalidate_lock(), xfs was the only fs t=
hat
was safe from races of punch hole vs. buffered read leading to reading
stale data.

One way to fix the mixed buffered rw performance issue is to follow suit wi=
th
other fs and not take shared iolock on buffered reads in xfs, but that has =
the
downside of regressing the legacy "untorn writes" xfs behavior and it will =
make
it hard to maintain the existing buffered/dio coherency in xfs.

So instead of going in the direction of "follow ext4 buffered io
locking scheme",
this discussion took the direction of "follow dio locking scheme" when foil=
ios
can be used to provide "untorn writes" and use another method to mutually
exclude dio writes and buffered writes.

I hope that my summary is correct and helps to clarify where we stand.

Thanks,
Amir.
