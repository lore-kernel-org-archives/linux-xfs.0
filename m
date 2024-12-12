Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3E4F218
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018123; cv=none; b=CUZuIZ1Itb7H08gaLdbHtp8nDaesSjGQXEKeVmQjc5wbvhBelDkziMBFjaUl/RmGUdygJYDNLYrn7Wt4XOHx0EIUJ1LBfNvS97sn29SP9tXrN9BuzXWKfcw1/V6ZoJggefZJhk8gLoqblr4texS5E9rtgbNhFoIqVxZSUcbPmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018123; c=relaxed/simple;
	bh=aYQipamSKhwzdVh0jnSVjIfl9baWSzx+6IoPXrlsuhI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HilSuWEy/QfkaSE68cmypnY/xQI7Xdt5DXogYhxoctqVQNFlUdFu/wvhYDmipRYkoTaAybWudWSd1P0I1t7zV4UW5pKcLWWUMMX6t6kQGf7U17/2EpOUJbRMXAK87TUpoZnDd7n5xshWJX2exzHuKxmTp0zBANLciFTIUJpj/Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id C31E53AE6D6;
	Thu, 12 Dec 2024 10:33:47 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 1F15A3FAF2C;
	Thu, 12 Dec 2024 10:33:47 -0500 (EST)
Date: Thu, 12 Dec 2024 16:33:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241212163351.58dd1305@harpe.intellique.com>
In-Reply-To: <Z0o8vE4MlIg-jQeR@dread.disaster.area>
References: <20241128171458.37dc80ed@harpe.intellique.com>
	<Z0jbffI2A6Fn7LfO@dread.disaster.area>
	<20241129103332.4a6b452e@harpe.intellique.com>
	<Z0o8vE4MlIg-jQeR@dread.disaster.area>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qM_lO=2mNU3zuNdDXps5_v+";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_/qM_lO=2mNU3zuNdDXps5_v+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Sat, 30 Nov 2024 09:14:20 +1100
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> > xfs_quota -x -c "limit -p bhard=3D30000g 10" /mnt/raid =20
>=20
> That should set it up appropriately, hence the need to check if it
> has actually been set up correctly on disk.
>=20

Unfortunately in the meantime the users did some cleanup, therefore the
displayed information is coherent again (as there is more free space on
the filesystem as a whole as any remaining allocated quota).

xfs_quota -x -c "report -p"
Project quota on /mnt/raid (/dev/mapper/vg0-raid)
                         Blocks =20
Project ID       Used       Soft       Hard    Warn/Grace

----------- ------------------------------------------------------

<snip>
#40        10795758244          0 16106127360     00 [--------]


> > > Output of df and a project quota report showing usage and limits
> > > would be useful here.

looking at the corresponding folder :

/dev/mapper/vg0-raid    15T     11T  5,0T  68% /mnt/raid/pad


 du -s /mnt/raid/pad
10795758244	/mnt/raid/pad

# find /mnt/raid/pad -print | wc -l
39086

> > > Then, for each of the top level project directories you are
> > > querying with df, also run `xfs_io -rxc "stat" <dir>` and post
> > > the output. This will tell us if the project quota is set up
> > > correctly for df to report quota limits for them.
> > >=20

Starting with "pad" :

# xfs_io -rxc "stat" pad
fd.path =3D "."
fd.flags =3D non-sync,non-direct,read-only
stat.ino =3D 6442662464
stat.type =3D directory
stat.size =3D 4096
stat.blocks =3D 16
fsxattr.xflags =3D 0x200 \[--------P--------\]
fsxattr.projid =3D 40
fsxattr.extsize =3D 0
fsxattr.cowextsize =3D 0
fsxattr.nextents =3D 2
fsxattr.naextents =3D 0
dioattr.mem =3D 0x200
dioattr.miniosz =3D 512
dioattr.maxiosz =3D 2147483136

# xfs_io -rxc "stat" rush
fd.path =3D "."
fd.flags =3D non-sync,non-direct,read-only
stat.ino =3D 142
stat.type =3D directory
stat.size =3D 283
stat.blocks =3D 0
fsxattr.xflags =3D 0x200 \[--------P--------\]
fsxattr.projid =3D 10
fsxattr.extsize =3D 0
fsxattr.cowextsize =3D 0
fsxattr.nextents =3D 0
fsxattr.naextents =3D 0
dioattr.mem =3D 0x200
dioattr.miniosz =3D 512
dioattr.maxiosz =3D 2147483136

# xfs_io -rxc "stat" labo
fd.path =3D "."
fd.flags =3D non-sync,non-direct,read-only
stat.ino =3D 2147695168
stat.type =3D directory
stat.size =3D 310
stat.blocks =3D 0
fsxattr.xflags =3D 0x200 \[--------P--------\]
fsxattr.projid =3D 20
fsxattr.extsize =3D 0
fsxattr.cowextsize =3D 0
fsxattr.nextents =3D 0
fsxattr.naextents =3D 0
dioattr.mem =3D 0x200
dioattr.miniosz =3D 512
dioattr.maxiosz =3D 2147483136

# xfs_io -rxc "stat" prods
fd.path =3D "."
fd.flags =3D non-sync,non-direct,read-only
stat.ino =3D 4295178816
stat.type =3D directory
stat.size =3D 319
stat.blocks =3D 0
fsxattr.xflags =3D 0x200 \[--------P--------\]
fsxattr.projid =3D 30
fsxattr.extsize =3D 0
fsxattr.cowextsize =3D 0
fsxattr.nextents =3D 0
fsxattr.naextents =3D 0
dioattr.mem =3D 0x200
dioattr.miniosz =3D 512
dioattr.maxiosz =3D 2147483136

> > > It would also be useful to know if the actual quota usage is
> > > correct
> > > - having the output of `du -s /mnt/raid/project1` to count the
> > > blocks and `find /mnt/raid/project1 -print |wc -l` to count the
> > > files in quota controlled directories. That'll give us some idea
> > > if there's a quota accounting issue. =20
>=20
> iAnother thought occurred to me - can you also check that
> /etc/projid and /etc/projects is similar on all machines, and post
> the contents of them from the bad machine?
>=20

Hum, actually they didn't set up neither projid nor projects. Of course
I did create these during my tests, but could this be the culprit ?

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
   +33 6 16 30 15 95
------------------------------------------------------------------------
=20

--Sig_/qM_lO=2mNU3zuNdDXps5_v+
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ1sCXwAKCRBfeNBc1SJx
Vnl4AJ9gsS/Zc8qiUecFsybTApptGBUhjACfb6Df47VsKFUUygUaZTJitI/qCeU=
=L7bO
-----END PGP SIGNATURE-----

--Sig_/qM_lO=2mNU3zuNdDXps5_v+--
