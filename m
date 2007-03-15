Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 06:01:20 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FD1E6p018217
	for <linux-xfs@oss.sgi.com>; Thu, 15 Mar 2007 06:01:15 -0700
Received: from localhost (dslb-084-056-119-204.pools.arcor-ip.net [84.56.119.204])
	by mail.lichtvoll.de (Postfix) with ESMTP id B19D95ADEC
	for <linux-xfs@oss.sgi.com>; Thu, 15 Mar 2007 13:39:37 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: cache+barriers vs cache+nobarriers vs disabled cache+barriers vs disabled cache+nobarriers
Date: Thu, 15 Mar 2007 13:39:30 +0100
References: <20070315092220.1B09B193FE@mail.edu.haifa.ac.il>
In-Reply-To: <20070315092220.1B09B193FE@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12764108.IlLcJFcpmg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703151339.36259.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

--nextPart12764108.IlLcJFcpmg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag 15 M=E4rz 2007 schrieb Leon Kolchinsky:
> Hello All,
>
>
> After reading http://oss.sgi.com/projects/xfs/faq.html#wcache
> and some posts on the list I've got the following question:
>
> If I have disabled write cache on the disk (hdparm -W0 /dev/hda) and by
> default FS is mounted with "barrier" enabled, Is there any taste in
> enabling "barrier"(by default) because write cache is disabled anyway
> or may be it's a good idea to mount with "nobarriers" in this case?

Hello Leon!

It is not needed to enable barriers when write cache is disabled. Enabling=
=20
barriers in this case shouldn't have any visible effect I think.

> I thought that "barrier" is on by default to somewhat minimize
> potential dangers of enabled write cache? But if write cache is
> disabled, would "barrier" option just slow down the FS performance
> (which is already slowed down by "hdparm -W0 /dev/had" anyway)?

I think it wouldn't slow down any more, except maybe a minimal slow down=20
due to a little bit more of code executed inside XFS.

But why do you want to disable write cache in the first case? As long as=20
you are using 2.6.17.7 or later you can safely enable barriers and and=20
write cache. At least that is my experience upto 2.6.20.1 with old IDE=20
drivers and now since some hours on my ThinkPad T42 2.6.20.3 with libata=20
drivers.

With write barriers XFS and enabled write cache, XFS will not be as fast=20
as without write barriers and with enabled write cache - which is the=20
unsafe combination -, but it will still be faster than with disabled=20
write cache.

Regards,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart12764108.IlLcJFcpmg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF+T6ImRvqrKWZhMcRAq3ZAJwKXM5jZFwQYMzp3nUN5vqmCRkehwCeL8VF
WgwkoRpR/gI3Dx2DNoH1RCU=
=QpPo
-----END PGP SIGNATURE-----

--nextPart12764108.IlLcJFcpmg--
