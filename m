Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 09:49:55 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TGnm6p016654
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 09:49:50 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barriers.
Date: Thu, 29 Mar 2007 18:49:38 +0200
References: <17923.11463.459927.628762@notabene.brown> <200703291656.22084.Martin@lichtvoll.de> <20070329151858.GI32597093@melbourne.sgi.com>
In-Reply-To: <20070329151858.GI32597093@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5603208.FTvvu8bBA2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703291849.44297.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: David Chinner <dgc@sgi.com>

--nextPart5603208.FTvvu8bBA2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag 29 M=E4rz 2007 schrieb David Chinner:
> On Thu, Mar 29, 2007 at 04:56:21PM +0200, Martin Steigerwald wrote:
> > Am Montag 26 M=E4rz 2007 schrieb David Chinner:
> > > > Is there some mount flag to say "cope without barriers" or
> > > > "require barriers" ??
> > >
> > > XFs has "-o nobarrier" to say don't use barriers, and this is
> > > *not* the default. If barriers don't work, we drop back to "-o
> > > nobarrier" after leaving a loud warning inthe log....
> >
> > Hello David!
> >
> > Just a thought, maybe it shouldn't do that automatically, but require
> > the sysadmin to explicitely state "-o nobarrier" in that case.
>
> And prevent most existing XFS filesystems from mounting after
> a kernel upgrade? Think about the problems that might cause
> with XFs root filesystems on hardware/software that doesn't
> support barriers....

Hello David!

Granted. So it might turn out to be a decision between does not boot or is=
=20
not totally safe in power outages or crashes. I see no easy default=20
answer to that.

So while probably being a layering violation at least trying to disable=20
the write cache on devices without cache flush support unless "-o=20
nobarrier" (as in "I know what I am doing") is given, might help safety.=20
But this adds complexity and a possible source for bugs. And maybe trying=
=20
to disable write cache isn't safe on all setups?

Regards,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5603208.FTvvu8bBA2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGC+4omRvqrKWZhMcRAqBqAJ9aGM4oYzmMEyfYl3OpLCz/0jacIQCfUBeQ
L4Oc/JUnOhYE/bkd78nHygk=
=EVVf
-----END PGP SIGNATURE-----

--nextPart5603208.FTvvu8bBA2--
