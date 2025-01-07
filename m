Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B532C50285;
	Tue,  7 Jan 2025 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736252013; cv=none; b=Twsn3zhMHxMWnpsDDO+zijZZmEk1MVdhQNzq6hjUxeEXQ2NN/U3snhYtDN5J6EHusAYC2YXJyT6OY5/JoylhXrHrXyfNiuuvnEL/rjwKIdW4S7RWaujtvBoSz5oPQY0RDF16OuS6PzoAD6fId3HFFhhfX1MuO/1DtNbFjCstVcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736252013; c=relaxed/simple;
	bh=MMTFiCQrG7Nfv/CD6exz2tfFBJjCfvqu57qS3HC7I7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4lUdxV6zPaLCxyio//AcHCfPHzfiBGfa2FA1uquhVkuwloMmtR983J0WNaxpFAYsDKuvvkRTWYDGQEvluFG2EG+nQoejd5XdI5cYC1aC4NGD5ZrlOwNI2rIycTrnWIJyqJ9RFITllhsi1VFu5jBLLCTERoEjnDE8cbaWWP//MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JE6fko/I; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JE6fko/I"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3e8f64d5dso27822132a12.3;
        Tue, 07 Jan 2025 04:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736252009; x=1736856809; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HxPcZzpo1eELg7z9Z6OAr2+j5d4BF5/N+pEUnGJeGU=;
        b=JE6fko/IYNIUVOYGFImKq3SkvSQGxA3FXH/iuh1wlhi2PLSFtjbTFxcPVBoUgnmu0F
         JSO6Ye4aWaI/GyYdi5vdBRDqdT+gi5Xx9i2etBNl8IAnuGpo/G+ANzKiTN9QJZrbcI/x
         LwJEXdH625j/iRJ5HVzugPwUCpbEvo0Dv3JzL8AfajoRy6NZfmwt8NDkeDVDaIL3eDTv
         b3uI7xOY8XM+68TMUQszreI4jpcET6tyeqKYLml/xMMXRS5FotG6LHKd1dwHQ+noYwYX
         hD62T0jaPXBUHWdrGQn+ad7pySlag2NmGgoUmSohdfb1Lvusw5drKzZ+IQUAByeojcy8
         acVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736252009; x=1736856809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4HxPcZzpo1eELg7z9Z6OAr2+j5d4BF5/N+pEUnGJeGU=;
        b=R9UsrbsPmzNqw60r7uBnw9lxgUhK3q31kVLgRnrF0lw7THQxhYP/CbCruuSiSPnXYb
         fFicmXumiJ65UCUg634aLa/nwfRkRlRumnE5pg9DixTwC+AXMBqQq+IgdzeKfOmwCnem
         zFy4x1mPTpCv83ikx3xT342UDiGTqXazY11lLPZZoxmGZRz5oqP6hrG9SWchjNP6p8ix
         mgc0K3flXq5brbjmIS4ub8fP/zoH1g6KlVEPnHiT2juO/hzAgDTSSzy9RJEf3jsdvcAs
         quqccGrMpuV1UXLdbKMdwsfRMOcfCyI3PqcQ+B+Xmb1MCS/HDTrlh7LXyZXpa9Y8coVC
         VTvA==
X-Forwarded-Encrypted: i=1; AJvYcCX6g37J/rUyEIoveadduBTjmxYf3/VBUKiLVHskXHNOtbQgiV3lQ1TAkFZStMNUHUEbZPxdncHIBw3UnZE=@vger.kernel.org, AJvYcCXAGdmu+GZfqWdGMNDio93vV4ITIPBlBsy7IhP2SjXUVcX5ISFrVbueuQKZDezLpaoInYZBBjUKCKQy@vger.kernel.org
X-Gm-Message-State: AOJu0YydRkwtODIMi/xgVjtj0K0qr2Sy6HUzveLOvWll0JCgh646Unw7
	WSjvBHMxw7zCW5HJLMlk4v8QW03+WbRutreDtdbBubhThQYrGCgWFvW+onPYS9AxlSeYspo7B9W
	NbyKez+p8iR9U+h+vjms88PAly/M=
X-Gm-Gg: ASbGncsyc4hY8y5E+wiiDLv8dL1BMjuR/BjL6Mkt17fEiqP53+hb1qVxLaZ8DwJYXpq
	Mpcdgqe3PPe2bnjSfTjrjPnsCjij1Iqv2CFgKFw==
X-Google-Smtp-Source: AGHT+IH9PdXrco3vRB+YoHxhHGlVLEHsfBJKwFGavuQJYSm7ZWtqzzy6QSTnTLb8bUeKW0w63Cvu0p1XExZCOnutQkE=
X-Received: by 2002:a50:cc43:0:b0:5d9:a55:4307 with SMTP id
 4fb4d7f45d1cf-5d90a554368mr13916914a12.22.1736252008575; Tue, 07 Jan 2025
 04:13:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241226061602.2222985-1-chizhiling@163.com> <Z23Ptl5cAnIiKx6W@dread.disaster.area>
 <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com> <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
In-Reply-To: <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 7 Jan 2025 13:13:17 +0100
X-Gm-Features: AbW1kvbC0Yi_ZuKxC4j3s1Dtq_T106YM6UAIh3y5bWNY3VcKpAyFBb-lJ0dZD0k
Message-ID: <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Chi Zhiling <chizhiling@163.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, cem@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chi Zhiling <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2024 at 3:43=E2=80=AFAM Chi Zhiling <chizhiling@163.com> wr=
ote:
>
>
>
> On 2024/12/29 06:17, Dave Chinner wrote:
> > On Sat, Dec 28, 2024 at 03:37:41PM +0800, Chi Zhiling wrote:
> >>
> >>
> >> On 2024/12/27 05:50, Dave Chinner wrote:
> >>> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> >>>> From: Chi Zhiling <chizhiling@kylinos.cn>
> >>>>
> >>>> Using an rwsem to protect file data ensures that we can always obtai=
n a
> >>>> completed modification. But due to the lock, we need to wait for the
> >>>> write process to release the rwsem before we can read it, even if we=
 are
> >>>> reading a different region of the file. This could take a lot of tim=
e
> >>>> when many processes need to write and read this file.
> >>>>
> >>>> On the other hand, The ext4 filesystem and others do not hold the lo=
ck
> >>>> during buffered reading, which make the ext4 have better performance=
 in
> >>>> that case. Therefore, I think it will be fine if we remove the lock =
in
> >>>> xfs, as most applications can handle this situation.
> >>>
> >>> Nope.
> >>>
> >>> This means that XFS loses high level serialisation of incoming IO
> >>> against operations like truncate, fallocate, pnfs operations, etc.
> >>>
> >>> We've been through this multiple times before; the solution lies in
> >>> doing the work to make buffered writes use shared locking, not
> >>> removing shared locking from buffered reads.
> >>
> >> You mean using shared locking for buffered reads and writes, right?
> >>
> >> I think it's a great idea. In theory, write operations can be performe=
d
> >> simultaneously if they write to different ranges.
> >
> > Even if they overlap, the folio locks will prevent concurrent writes
> > to the same range.
> >
> > Now that we have atomic write support as native functionality (i.e.
> > RWF_ATOMIC), we really should not have to care that much about
> > normal buffered IO being atomic. i.e. if the application wants
> > atomic writes, it can now specify that it wants atomic writes and so
> > we can relax the constraints we have on existing IO...
>
> Yes, I'm not particularly concerned about whether buffered I/O is
> atomic. I'm more concerned about the multithreading performance of
> buffered I/O.

Hi Chi,

Sorry for joining late, I was on vacation.
I am very happy that you have taken on this task and your timing is good,
because  John Garry just posted his patches for large atomic writes [1].

I need to explain the relation to atomic buffered I/O, because it is not
easy to follow it from the old discussions and also some of the discussions
about the solution were held in-person during LSFMM2024.

Naturally, your interest is improving multithreading performance of
buffered I/O, so was mine when I first posted this question [2].

The issue with atomicity of buffered I/O is the xfs has traditionally
provided atomicity of write vs. read (a.k.a no torn writes), which is
not required by POSIX standard (because POSIX was not written with
threads in mind) and is not respected by any other in-tree filesystem.

It is obvious that the exclusive rw lock for buffered write hurts performan=
ce
in the case of mixed read/write on xfs, so the question was - if xfs provid=
es
atomic semantics that portable applications cannot rely on, why bother
providing these atomic semantics at all?

Dave's answer to this question was that there are some legacy applications
(database applications IIRC) on production systems that do rely on the fact
that xfs provides this semantics and on the prerequisite that they run on x=
fs.

However, it was noted that:
1. Those application do not require atomicity for any size of IO, they
    typically work in I/O size that is larger than block size (e.g. 16K or =
64K)
    and they only require no torn writes for this I/O size
2. Large folios and iomap can usually provide this semantics via folio lock=
,
    but application has currently no way of knowing if the semantics are
    provided or not
3. The upcoming ability of application to opt-in for atomic writes larger
    than fs block size [1] can be used to facilitate the applications that
    want to legacy xfs semantics and avoid the need to enforce the legacy
    semantics all the time for no good reason

Disclaimer: this is not a standard way to deal with potentially breaking
legacy semantics, because old applications will not usually be rebuilt
to opt-in for the old semantics, but the use case in hand is probably
so specific, of a specific application that relies on xfs specific semantic=
s
that there are currently no objections for trying this solution.

[1] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.garry@o=
racle.com/
[2] https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3J=
SeZR71S1dXg+2w@mail.gmail.com/

>
> Last week, it was mentioned that removing i_rwsem would have some
> impacts on truncate, fallocate, and PNFS operations.
>
> (I'm not familiar with pNFS, so please correct me if I'm wrong.)

You are not wrong. pNFS uses a "layout lease", which requires
that the blockmap of the file will not be modified while the lease is held.
but I think that block that are not mapped (i.e. holes) can be mapped
while the lease is held.

>
> My understanding is that the current i_rwsem is used to protect both
> the file's data and its size. Operations like truncate, fallocate,
> and PNFS use i_rwsem because they modify both the file's data and its
> size. So, I'm thinking whether it's possible to use i_rwsem to protect
> only the file's size, without protecting the file's data.
>

It also protects the file's blockmap, for example, punch hole
does not change the size, but it unmaps blocks from the blockmap,
leading to races that could end up reading stale data from disk
if the lock wasn't taken.

> So operations that modify the file's size need to be executed
> sequentially. For example, buffered writes to the EOF, fallocate
> operations without the "keep size" requirement, and truncate operations,
> etc, all need to hold an exclusive lock.
>
> Other operations require a shared lock because they only need to access
> the file's size without modifying it.
>

As far as I understand, exclusive lock is not needed for non-extending
writes, because it is ok to map new blocks.
I guess the need for exclusive lock for extending writes is related to
update of file size, but not 100% sure.
Anyway, exclusive lock on extending write is widely common in other fs,
while exclusive lock for non-extending write is unique to xfs.

> >
> >> So we should track all the ranges we are reading or writing,
> >> and check whether the new read or write operations can be performed
> >> concurrently with the current operations.
> >
> > That is all discussed in detail in the discussions I linked.
>
> Sorry, I overlooked some details from old discussion last time.
> It seems that you are not satisfied with the effectiveness of
> range locks.
>

Correct. This solution was taken off the table.

I hope my explanation was correct and clear.
If anything else is not clear, please feel free to ask.

Thanks,
Amir.
