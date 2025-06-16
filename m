Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFB227F008;
	Mon, 16 Jun 2025 10:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750068575; cv=none; b=cwOxusMkdleV/OMiUSebfDhv9+AwDClaqklsQA6/+IJj5HcGxqxniKiqqEvPj3AqrU3aXxFp3Ba6A6qrqm0wzOp6mUDf8XelUydWM4uS51jMiMmGulVvdJ9eyUZDUd5c1iFDJmFv6HL/JIo1Yp4r1XEEuyCnLanDiyTTT7kMyHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750068575; c=relaxed/simple;
	bh=GUY8/63BQv85kRQHfmjIq1+ft2+ClaRKl8r4IWk1ocQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=k0vHMZKirWobe9XT75RmHEFil7gkzb/YI1XjcGL381BhxVIUF7YiPS+ZUy2LZfOavtxJQwRhsr2vCNTPRNzfhgOHz+P2NIClVpaL1UGlNIrkONRl5+jGR7fe4rAPrK43eVDpHuFkxF7MeOG+CJ93T7tSBrgyRAtjIT++aaDAFhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=RPoWjhAm; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="RPoWjhAm"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1750068571;
	bh=itB1oOGdFQkL5Y75629jq0JbuLdjXKutsArus/swJBA=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=RPoWjhAmO/c8bHNIyHNNg7x1zgLkEkwVrzUu1Av4PXh8ywypox9KUUjPRFs6cs9Wn
	 0JEMZWN8h3hzqyGuFDGO6p7X8oAVddz+9xGTS+1VdW3XmLyPZ6dTHulV4i8CGZpRZp
	 HgILLVS1+OG0rb4egCGhx/H5x/arourOL15ENYmQ=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
Date: Mon, 16 Jun 2025 12:09:21 +0200
Cc: stable@vger.kernel.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
To: Carlos Maiolino <cem@kernel.org>


> On 16. Jun 2025, at 11:47, Carlos Maiolino <cem@kernel.org> wrote:
>=20
> On Mon, Jun 16, 2025 at 10:59:34AM +0200, Christian Theune wrote:
>>=20
>>=20
>>> On 16. Jun 2025, at 10:50, Carlos Maiolino <cem@kernel.org> wrote:
>>>=20
>>> On Thu, Jun 12, 2025 at 03:37:10PM +0200, Christian Theune wrote:
>>>> Hi,
>>>>=20
>>>> in the last week, after updating to 6.6.92, we=E2=80=99ve =
encountered a number of VMs reporting temporarily hung tasks blocking =
the whole system for a few minutes. They unblock by themselves and have =
similar tracebacks.
>>>>=20
>>>> The IO PSIs show 100% pressure for that time, but the underlying =
devices are still processing read and write IO (well within their =
capacity). I=E2=80=99ve eliminated the underlying storage (Ceph) as the =
source of problems as I couldn=E2=80=99t find any latency outliers or =
significant queuing during that time.
>>>>=20
>>>> I=E2=80=99ve seen somewhat similar reports on 6.6.88 and 6.6.77, =
but those might have been different outliers.
>>>>=20
>>>> I=E2=80=99m attaching 3 logs - my intuition and the data so far =
leads me to consider this might be a kernel bug. I haven=E2=80=99t found =
a way to reproduce this, yet.
>>>=20
>>> =46rom a first glance, these machines are struggling because IO =
contention as you
>>> mentioned, more often than not they seem to be stalling waiting for =
log space to
>>> be freed, so any operation in the FS gets throttled while the =
journal isn't
>>> written back. If you have a small enough journal it will need to =
issue IO often
>>> enough to cause IO contention. So, I'd point it to a slow storage or =
small
>>> enough log area (or both).
>>=20
>> Yeah, my current analysis didn=E2=80=99t show any storage performance =
issues. I=E2=80=99ll revisit this once more to make sure I=E2=80=99m not =
missing anything. We=E2=80=99ve previously had issues in this area that =
turned out to be kernel bugs. We didn=E2=80=99t change anything =
regarding journal sizes and only a recent kernel upgrade seemed to be =
relevant.
>=20
> You mentioned you saw PSI showing a huge pressure ration, during the =
time, which
> might be generated by the journal writeback and giving it's a SYNC =
write, IOs
> will stall if your storage can't write it fast enough. IIRC, most of =
the threads
> from the logs you shared were waiting for log space to be able to =
continue,
> which causes the log to flush things to disk and of course increase IO =
usage.
> If your storage can't handle these IO bursts, then you'll get the =
stalls you're
> seeing.
> I am not discarding a possibility you are hitting a bug here, but it =
so far
> seems your storage is not being able to service IOs fast enough to =
avoid such IO
> stalls, or something else throttling IOs, XFS seems just the victim.

Yeah, it=E2=80=99s annoying, I know. To paraphrase "any sufficiently =
advanced bug is indistinguishable from slow storage=E2=80=9D. ;)=09

As promised, I=E2=80=99ll dive deeper into the storage performance =
analysis, all telemetry so far was completely innocuous, but it=E2=80=99s =
a complex layering of SSDs =E2=86=92 Ceph =E2=86=92 Qemu =E2=80=A6 =
Usually if we have performance issues then the metrics reflect this =
quite obviously and will affect many machines at the same time. As this =
has always just affected one single VM at a time but spread over time my =
gut feeling is a bit more on the side of =E2=80=9Cit might be maybe a =
bug=E2=80=9D. As those things tend to be hard/nasty to diagnose I wanted =
to raise the flag early on to see whether other=E2=80=99s might be =
having an =E2=80=9Caha=E2=80=9D moment if they=E2=80=99re experiencing =
something similar.

I=E2=80=99ll get back to you in 2-3 days with results from the storage =
analysis.

> Can you share the xfs_info of one of these filesystems? I'm curious =
about the FS
> geometry.

Sure:

# xfs_info /
meta-data=3D/dev/disk/by-label/root isize=3D512    agcount=3D21, =
agsize=3D655040 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1 =
inobtcount=3D1 nrext64=3D0
         =3D                       exchange=3D0
data     =3D                       bsize=3D4096   blocks=3D13106171, =
imaxpct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1,=
 parent=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D16384, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

# xfs_info /tmp/
meta-data=3D/dev/vdb1              isize=3D512    agcount=3D8, =
agsize=3D229376 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D0    bigtime=3D0 =
inobtcount=3D0 nrext64=3D0
         =3D                       exchange=3D0
data     =3D                       bsize=3D4096   blocks=3D1833979, =
imaxpct=3D25
         =3D                       sunit=3D1024   swidth=3D1024 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1,=
 parent=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D8 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0


>=20
>>=20
>>> There has been a few improvements though during Linux 6.9 on the log =
performance,
>>> but I can't tell if you have any of those improvements around.
>>> I'd suggest you trying to run a newer upstream kernel, otherwise =
you'll get very
>>> limited support from the upstream community. If you can't, I'd =
suggest you
>>> reporting this issue to your vendor, so they can track what you =
are/are not
>>> using in your current kernel.
>>=20
>> Yeah, we=E2=80=99ve started upgrading selected/affected projects to =
6.12, to see whether this improves things.
>=20
> Good enough.
>=20
>>=20
>>> FWIW, I'm not sure if NixOS uses linux-stable kernels or not. If =
that's the
>>> case, running a newer kernel suggestion is still valid.
>>=20
>> We=E2=80=99re running the NixOS mainline versions which are very =
vanilla. There are very very 4 small patches that only fix up things =
around building and binary paths for helpers to call to adapt them to =
the nix environment.
>=20
> I see. There were some improvements in the newer versions, so if you =
can rule
> out any possibly fixed bug is worth it.
>=20
>=20
>>=20
>> Christian
>>=20
>>=20
>> --
>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick


--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

