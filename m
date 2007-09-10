Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 07:24:49 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AEOg4p028860
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 07:24:44 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 3A4A51E0D5943
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 21:59:17 +0800 (PHT)
Subject: Attempt to Access Beyond End of Device
From: Federico Sevilla III <jijo@fs3.ph>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YTB1Gy6CzAmVb4PSWUII"
Date: Mon, 10 Sep 2007 21:59:07 +0800
Message-Id: <1189432747.4385.27.camel@auctoritas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Alec Joseph Rivera <agi@fs3.ph>

--=-YTB1Gy6CzAmVb4PSWUII
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

We've set up Debian GNU/Linux 4.0 "Etch" on an IBM x3400 machine with
two 73.4GB SAS hard drives in hardware RAID 1 with a battery-backed
cache. We are using the stock Debian 2.6.18-4-686 kernel.

The filesystems were created using the following optimization:

        -l size=3D32768b,version=3D2 -n 64k

The filesystems are mounted using the following optimization:

        logbufs=3D8,logbsize=3D256k

Today, we were unable to mount the "large" (not really at < 70GB) /var
(/dev/sda8), getting the following error:

        Attempt to access beyond end of device
        sda: rw=3D0, want=3D143139140, limit=3D143134720
        I/O error in filesystem ("sda8") meta-data dev sda8 block
        0x75cd27f
        ("xf:read_buf") errors buf count 512
        XFS: size check 2 failed
        Mount: /dev/sda8: can't read superblock

An attempted repair also fails:

        # xfs_repair /dev/sda8
        Phase 1 - find and verify superblock...
        Attempt to access beyond end of device
        Sda: rw=3D0, want=3D143139140, limit=3D143134720
        Xfs_repair: read failed.      Input/output error

The partition table looks okay:

        #Partition table of /dev/sda
        /dev/sda1 : start=3D          63,size        9637, Id=3D83, bootable
        /dev/sda2 : start=3D       96390,size   143042760, Id=3D5
        /dev/sda3 : start=3D           0,size           0, Id=3D0
        /dev/sda4 : start=3D           0,size           0, Id=3D0=20=20=20
        /dev/sda5 : start=3D       96453,size     3903732, Id=3D82
        /dev/sda6 : start=3D     4000248,size     7807527, Id=3D83
        /dev/sda7 : start=3D    11807838,size     7807527, Id=3D83
        /dev/sda8 : start=3D    19615428,size   123523722, Id=3D83

The machine doesn't have valuable data, yet, so a simple reinstall
should help get it back up. However I'm more concerned about what could
cause this. It's the first time for me to use a version 2 log, 64k
directories (?) and 256k in-memory log buffers. Are any of these to
blame?

We're also looking for generic filesystem tweaks for a PostgreSQL +
Apache server, which this will be (with more load direct to PostgreSQL
than to/through Apache). Are the above choices for mkfs.xfs and mount
well-made?

Please advise.

Thank you very much.

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-YTB1Gy6CzAmVb4PSWUII
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG5U2r5rCBSJO3Rr4RAr7hAJ4pMAPg6LWMxGAHLPRDZgdnwQLUQwCeN/rp
YNOBh0CR4nlUB8jn5PgNJ/o=
=jDsu
-----END PGP SIGNATURE-----

--=-YTB1Gy6CzAmVb4PSWUII--
