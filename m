Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA831E2828
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734104578; cv=none; b=RcsUPP5n49AUOOBDh51qMGgQs3Rk1Ngy2bv944U8whpg7uvLo3BARF5H48uerTbv9GyGxu+KlY/0jgPPEMePMkAJJiBtb2fmS5wj1FM4qcVRFsjJ/EpK2wqIvuJZaabXdKW8dsToc3uLHmLV4uz02RTZBwDgYrMvdhnHWYc9siA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734104578; c=relaxed/simple;
	bh=3Wn6PQNG66LeXtmL1RMIE6AkeQiqnj0Ba+RhRrHmb/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JBfSX9Ogq8qRmYntZGdKmR7mTQgw7zpSjfN50Lj7/a3xTcgJVDJEtoxM+ZTKk7L6xkA9Avn2wrWE7QRLTn5Kc/wAVNCWaXWKxGjXLjf+bibpQm5qBNjcz4cfpUsLzj/XdSulWpEz78zPgh912frDNVeEP8rQ+m9x4XLw9Y3Sq/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id 4AB6B3AE7CF;
	Fri, 13 Dec 2024 10:42:49 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 7F66B3FAEE2;
	Fri, 13 Dec 2024 10:42:48 -0500 (EST)
Date: Fri, 13 Dec 2024 16:42:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241213164251.361f8877@harpe.intellique.com>
In-Reply-To: <20241212202547.GK6678@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
	<Z0jbffI2A6Fn7LfO@dread.disaster.area>
	<20241129103332.4a6b452e@harpe.intellique.com>
	<Z0o8vE4MlIg-jQeR@dread.disaster.area>
	<20241212163351.58dd1305@harpe.intellique.com>
	<20241212202547.GK6678@frogsfrogsfrogs>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7uTjcsfHM8RUB.Uk84Zk9nt";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_/7uTjcsfHM8RUB.Uk84Zk9nt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 12 Dec 2024 12:25:47 -0800
"Darrick J. Wong" <djwong@kernel.org> =C3=A9crivait:


> Does this recreate the symptoms?
>=20
<snip>
> # df /mnt /mnt/dir
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda         20G  420M   20G   3% /mnt
> /dev/sda        2.0G     0  2.0G   0% /mnt
> # fallocate -l 19g /mnt/a
> # df /mnt /mnt/dir
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda         20G   20G  345M  99% /mnt
> /dev/sda        2.0G     0  2.0G   0% /mnt
>=20
> Clearly, df should be reporting 345M available for both cases, since
> we haven't actually used any of project 55's blocks.
>=20
> # xfs_io -f -c 'pwrite -S 0x59 0 1m' -c fsync -c 'stat -vvvv'
> /mnt/dir/fork wrote 1048576/1048576 bytes at offset 0
> 1 MiB, 256 ops; 0.0008 sec (1.121 GiB/sec and 293915.0402 ops/sec)
> fd.path =3D "/mnt/dir/fork"
> fd.flags =3D non-sync,non-direct,read-write
> stat.ino =3D 134
> stat.type =3D regular file
> stat.size =3D 1048576
> stat.blocks =3D 2048
> stat.atime =3D Thu Dec 12 12:11:06 2024
> stat.mtime =3D Thu Dec 12 12:11:06 2024
> stat.ctime =3D Thu Dec 12 12:11:06 2024
> fsxattr.xflags =3D 0x0 []
> fsxattr.projid =3D 55
> fsxattr.extsize =3D 0
> fsxattr.cowextsize =3D 0
> fsxattr.nextents =3D 1
> fsxattr.naextents =3D 0
> dioattr.mem =3D 0x200
> dioattr.miniosz =3D 512
> dioattr.maxiosz =3D 2147483136
> # df /mnt /mnt/dir
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda         20G   20G  344M  99% /mnt
> /dev/sda        2.0G  1.0M  2.0G   1% /mnt
>=20
> I think this behavior comes from xfs_fill_statvfs_from_dquot, which
> does this:
>=20
> 	limit =3D blkres->softlimit ?
> 		blkres->softlimit :
> 		blkres->hardlimit;
> 	if (limit && statp->f_blocks > limit) {
> 		statp->f_blocks =3D limit;
> 		statp->f_bfree =3D statp->f_bavail =3D
> 			(statp->f_blocks > blkres->reserved) ?
> 			 (statp->f_blocks - blkres->reserved) : 0;
> 	}
>=20
> I think the f_bfree/f_bavail assignment is wrong because it doesn't
> handle the case where f_bfree was less than (limit - reserved).
>=20
> 	if (limit) {
> 		uint64_t	remaining =3D 0;
>=20
> 		if (statp->f_blocks > limit)
> 			statp->f_blocks =3D limit;
> 		if (limit > blkres->reserved)
> 			remaining =3D limit - blkres->reserved;
> 		statp->f_bfree =3D min(statp->f_bfree, remaining);
> 		statp->f_bavail =3D min(statp->f_bavail, remaining);
> 	}
>=20
> This fixes the df output a bit:
> # df /mnt /mnt/dir
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda         20G   20G  344M  99% /mnt
> /dev/sda        2.0G  1.7G  344M  84% /mnt
>=20
> Though the "used" column is nonsense now.  But I guess that's why
> statfs only defines total blocks and free/available blocks.

Yep, that looks exactly like the problem we've met. Does the fact that
not all folders have project quota change something in that case ?

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
   +33 6 16 30 15 95
------------------------------------------------------------------------
=20

--Sig_/7uTjcsfHM8RUB.Uk84Zk9nt
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ1xV/AAKCRBfeNBc1SJx
Vio2AKCFMGPOt87HjFEkTNa6RXN82wU/bwCg40dlXDjexups2VY2CImZC/5uZcE=
=WisA
-----END PGP SIGNATURE-----

--Sig_/7uTjcsfHM8RUB.Uk84Zk9nt--
