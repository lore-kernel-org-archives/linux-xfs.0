Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 13:28:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1ILSWfK026963
	for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:28:33 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 257FFE54F5D
	for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:28:55 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id G4pzJszjTXb8YyNG for <linux-xfs@oss.sgi.com>; Mon, 18 Feb 2008 13:28:55 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Data safety horror stories?
Date: Mon, 18 Feb 2008 22:28:45 +0100
References: <1202748389.28320.1236240801@webmail.messagingengine.com> <20080211171209.GA7567@teal.hq.k1024.org> <1202764989.11126.1236296081@webmail.messagingengine.com> (sfid-20080211_233600_747175_BC87DF53)
In-Reply-To: <1202764989.11126.1236296081@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1812791.tPhqDFMVZZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802182228.50631.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: "Felix E. Klee" <felix.klee@inka.de>, Iustin Pop <iusty@k1024.org>

--nextPart1812791.tPhqDFMVZZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 11 Februar 2008 schrieb Felix E. Klee:
> Hi Justin,

Hi Felix,

> > Improperly written applications and/or improperly configured systems
> > might have issues with recently written files losing data.
>
> Again, just to make sure that I understood you correctly: Could you
> name an example?

I recommend to read my article about write barriers and journalling=20
filesystems for some basic understanding.
=20
http://www.linux-magazin.de/heft_abo/sonderheft/2006/04/beschraenktes_schre=
iben?category=3D0

its in german tough. Actually I thought it should have been translated to=
=20
english for Linux Magazine under the title "Imposing Order", but I do not=
=20
find it on the net and it might have not been published.

Note: There is a mistake in it regarding history of write barriers. Write=
=20
barriers are not supported via device mapper. Thats why I do not use LVM=20
on my notebook for my productive data.

> > Just my opinion as an XFS user, your mileage might vary.
>
> Hopefully, it's not about opinions ...

I had not had any problems since quite some kernel releases. And there=20
were some power losses involved ;). At earlier times Akregator (an KDE=20
newsreader) said its opml was broken and a backup was restored after such=
=20
a power loss... but not since quite some kernel releases.

I had one nasty problem with corrupt data in files but that was with a=20
kernel that was patched with Con Koliva's patchset and didn't happen in=20
mainline.

So since 2.6.17.7 XFS has been pretty stable for me. On a ThinkPad T42, a=
=20
ThinkPad T23 and half a dozen of workstations at work ;-).

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1812791.tPhqDFMVZZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHufiSmRvqrKWZhMcRAn4kAJ4ttnnPLynH02mCqBVvOlwTMEBY0ACeLscV
T077gUUaUwGrO1pC9eArC4o=
=vvZ+
-----END PGP SIGNATURE-----

--nextPart1812791.tPhqDFMVZZ--
