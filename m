Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 22:12:20 -0700 (PDT)
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k865C7DW022292
	for <linux-xfs@oss.sgi.com>; Tue, 5 Sep 2006 22:12:08 -0700
Received: from localhost (albatross.madduck.net [127.0.0.1])
	by albatross.madduck.net (postfix) with ESMTP id 72800895D7C
	for <linux-xfs@oss.sgi.com>; Wed,  6 Sep 2006 06:12:39 +0200 (CEST)
Received: from albatross.madduck.net ([127.0.0.1])
	by localhost (albatross.madduck.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 16384-01 for <linux-xfs@oss.sgi.com>;
	Wed, 6 Sep 2006 06:12:39 +0200 (CEST)
Received: from wall.oerlikon.madduck.net (84-72-21-226.dclient.hispeed.ch [84.72.21.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "wall.oerlikon.madduck.net", Issuer "CAcert Class 3 Root" (verified OK))
	by albatross.madduck.net (postfix) with ESMTP id 2EF29895D79
	for <linux-xfs@oss.sgi.com>; Wed,  6 Sep 2006 06:12:39 +0200 (CEST)
Received: from piper.oerlikon.madduck.net (piper.oerlikon.madduck.net [192.168.14.3])
	by wall.oerlikon.madduck.net (Postfix) with ESMTP id 911761804BBE
	for <linux-xfs@oss.sgi.com>; Wed,  6 Sep 2006 06:12:45 +0200 (CEST)
Date: Wed, 6 Sep 2006 06:12:45 +0200
From: martin f krafft <madduck@madduck.net>
Subject: Re: XFS Journal on md device
Message-ID: <20060906041245.GA10066@piper.madduck.net>
References: <2260b150609051640y288629cbtcbc133d05b2b40dd@mail.gmail.com> <44FE28A8.5000803@oss.sgi.com> <2260b150609051853w1286eda7ve59a5df2c7e0ae1c@mail.gmail.com> <20060906034027.GA7393@piper.madduck.net> <2260b150609052053h31731a0eycababfab603749c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <2260b150609052053h31731a0eycababfab603749c9@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Chris Seufert <seufert@gmail.com> [2006.09.06.0553 +0200]:
> My root (/) volume is ext3 running on /dev/md0 (RAID 1), the
> problem is with my /data volume thats xfs, running on /dev/sda,
> with log on /dev/md4.

Can you tell when /data gets umounted during the shutdown sequence?
Correct me if I'm wrong, but once that happened, /dev/md4 should
become free as far as XFS is concerned.

However, since mdadm or the kernel fails to stop the device during
shutdown, I am guessing that the partition is simply not being
umounted.

Does it have an entry in /etc/fstab?

Try changing the=20

  #! /bin/sh

in line 1 of /etc/rc6.d/S40umountfs to

  #! /bin/sh -x
  exec 2> /root/umountfs.out.2

then reboot and paste that file somewhere (http://rafb.net/paste).

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"you don't sew with a fork, so I see no reason
 to eat with knitting needles."
                               -- miss piggy, on eating chinese food

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE/kq9IgvIgzMMSnURAiPcAJ99QMFVoCCU3qG+cTDtAP7wtvm3dQCffFeW
1nM/lomxGvDkQSmGbdgBKRI=
=fBYK
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
