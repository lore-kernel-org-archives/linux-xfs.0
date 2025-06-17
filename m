Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51156288A2;
	Tue, 17 Jun 2025 05:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750139112; cv=none; b=P6pLzcfaEjLblsJ3KNmF83WHzQd/PIuyuZAUexVKyJMaKHgAPmf2Wf0hkgRF7a0IR7XG9ue7y5L0EwyOudrsSWfFkzz5bSj5zuAX/ozQMV+qteiVNK1fU0h6BoZgtck/dWhy12J7WwYc5tw+nyQtwPKdk7ZE89b16ih1xyG11Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750139112; c=relaxed/simple;
	bh=1WHzlCNxEImWUDje4Ej56WMZmcdG8ijinP9bszSGkac=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EPZw4CdMqZzNbM0WuCSrDP/VBP1oHF0gDxGULvrX9h6tDAcU6YYND7pYL9Rvt6HZFq3tNvPfaFj8g0OZjF9AmoTqtxzeEFWG5MVqPg0kbVYkvq5PwF7zhVYTtYNry2HbjIrnD2d95gFugFZ7CvG4Dkzv8QnUAYzVCIyECXNRXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=qXxQv4po; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="qXxQv4po"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1750139104;
	bh=lrkO0Eu7jwec7H3gk2TW5b+gWEMO/yUB0J1TGVptgM0=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=qXxQv4poTYiMenSeyZ9gadw0198Z7sdZgm91imfcP7ZkMGX83uHg0+pEEkAKcoBXU
	 FcG/BdiuVN2+wbDMtDrgM6Mk1iDBFO5RbQMldBh6qfBTloPLAUO7hsVMu0v/+zQMSF
	 xZF+kl8JZsO6jzRG46pYow8unWtT6MNBkewWGwDI=
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <hoszywa5az7z4yxubonbhs2p2ysnut3s7jjnkd7ckz4sgdyqw2@ifuor5qnl7yu>
Date: Tue, 17 Jun 2025 07:44:54 +0200
Cc: stable@vger.kernel.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <B380AC75-6B14-4EC9-A398-61A2D33033A7@flyingcircus.io>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <M0QJfqa7-6M2vnPhyeyy36xCOmCEL83O7lj-ky1DXTqQXa677-oE8C_nAsBCBglBp_6k7vLeN4a2nJ6R3JuQxw==@protonmail.internalid>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
 <hoszywa5az7z4yxubonbhs2p2ysnut3s7jjnkd7ckz4sgdyqw2@ifuor5qnl7yu>
To: Carlos Maiolino <cem@kernel.org>



> On 16. Jun 2025, at 14:15, Carlos Maiolino <cem@kernel.org> wrote:
>=20
> On Mon, Jun 16, 2025 at 12:09:21PM +0200, Christian Theune wrote:
>=20
>>=20
>> # xfs_info /tmp/
>> meta-data=3D/dev/vdb1              isize=3D512    agcount=3D8, =
agsize=3D229376 blks
>>         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D1        finobt=3D1, =
sparse=3D1, rmapbt=3D0
>>         =3D                       reflink=3D0    bigtime=3D0 =
inobtcount=3D0 nrext64=3D0
>>         =3D                       exchange=3D0
>> data     =3D                       bsize=3D4096   blocks=3D1833979, =
imaxpct=3D25
>>         =3D                       sunit=3D1024   swidth=3D1024 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, =
ftype=3D1, parent=3D0
>> log      =3Dinternal log           bsize=3D4096   blocks=3D2560, =
version=3D2
>>         =3D                       sectsz=3D512   sunit=3D8 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>=20
> This is worrisome. Your journal size is 10MiB, this can easily keep =
stalling IO
> waiting for log space to be freed, depending on the nature of the =
machine this
> can be easily triggered. I'm curious though how you made this FS, =
because 2560
> is below the minimal log size that xfsprogs allows since (/me goes =
look
> into git log) 2022, xfsprogs 5.15.
>=20
> FWIW, one of the reasons the minimum journal log size has been =
increased is the
> latency/stalls that happens when waiting for free log space, which is =
exactly
> the symptom you've been seeing.
>=20
> I'd suggest you to check the xfsprogs commit below if you want more =
details,
> but if this is one of the filesystems where you see the stalls, this =
might very
> well be the cause:

Interesting catch! I=E2=80=99ll double check this against our fleet and =
the affected machines and will dive into the traffic patterns of the =
specific underlying devices.

This filesystem is used for /tmp and is getting created fresh after a =
=E2=80=9Ccold boot=E2=80=9D from our hypervisor. It could be that a =
number of VMs have only seen warm reboots for a couple of years but get =
kernel upgrades with warm reboots quite regularly. We=E2=80=99re in the =
process of changing the /tmp filesystem creation to happen fresh during =
initrd so that the VM internal xfsprogs will more closely match the =
guest kernel.

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

