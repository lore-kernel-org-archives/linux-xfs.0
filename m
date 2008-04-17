Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 12:37:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3HJaeYO024131
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 12:36:43 -0700
Received: from perch.m2000.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F70B158526E
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 12:37:20 -0700 (PDT)
Received: from perch.m2000.com (adsl-71-159-205-6.dsl.pltn13.sbcglobal.net [71.159.205.6]) by cuda.sgi.com with ESMTP id 5FBkjEbOXs2OexY4 for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 12:37:20 -0700 (PDT)
Message-ID: <4807A6E8.6010102@m2000.com>
Date: Thu, 17 Apr 2008 12:37:12 -0700
From: Adam Schrotenboer <adam@m2000.com>
MIME-Version: 1.0
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
References: <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com>	<18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com>	<47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org>	<32953.192.168.1.70.1206477121.squirrel@neil.brown.name>	<20080325212425.GA20257@josefsipek.net>	<34178.192.168.1.70.1206481102.squirrel@neil.brown.name>	<20080325221321.GC20257@josefsipek.net>	<20080326033738.GX103491721@sgi.com> <20080326050208.GH108924158@sgi.com>
In-Reply-To: <20080326050208.GH108924158@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1BF6A4C9FFDE6A417CF8AEFD"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1BF6A4C9FFDE6A417CF8AEFD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

David Chinner wrote:
> On Wed, Mar 26, 2008 at 02:37:38PM +1100, David Chinner wrote:
>=20=20=20
>> Given this state of affairs (i.e. HSM using ikeep), I guess we can do
>> anything we want for the noikeep case. I'll cook up a patch that does
>> something similar to ext3 generation numbers for the initial seeding....
>>=20=20=20=20=20
>
> Patch below for comments. It passes xfsqa, but there's no userspace
> support for it yet. 2.6.26 is the likely target for this change.
>=20=20=20
2.6.26 merge window begins now. Has this been pushed yet? Is it in=20
linux-next tree ?


--------------enig1BF6A4C9FFDE6A417CF8AEFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIB6bsyWYDdvnGArwRAgWsAJ9t0nH7ajRgEVsj/2t/tIa6MO+TRwCgnChk
IpX4Rz5Lfw83P0S23KKixBc=
=pnkR
-----END PGP SIGNATURE-----

--------------enig1BF6A4C9FFDE6A417CF8AEFD--
