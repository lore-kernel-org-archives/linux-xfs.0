Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 19:57:22 -0800 (PST)
Received: from mailgate.mysql.com (mailgate-out2.mysql.com [213.136.52.68])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAM3vDBm008771
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 19:57:14 -0800
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
From: Stewart Smith <stewart@mysql.com>
In-Reply-To: <20071122011214.GR114266761@sgi.com>
References: 
	 <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com>
	 <p73oddnhzoq.fsf@bingen.suse.de>  <20071122011214.GR114266761@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WAjZXbGIUan1gQIlUjdm"
Date: Thu, 22 Nov 2007 14:28:43 +1100
Message-Id: <1195702123.8369.78.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

--=-WAjZXbGIUan1gQIlUjdm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-22 at 12:12 +1100, David Chinner wrote:
> In all the cases that I know of where ppl are using what could
> be considered real-time I/O (e.g. media environments where they
> do real-time ingest and playout from the same filesystem) the
> real-time ingest processes create the files and do pre-allocation
> before doing their I/O. This I/O can get held up behind another
> process that is not real time that has issued log I/O.=20
>=20
> Given there is no I/O priority inheritence and having log I/O stall
> will stall the entire filesystem, we cannot allow log I/O to
> stall in real-time environments. Hence it must have the highest
> possible priority to prevent this.

FWIW from a "real time" database POV this seems to make sense to me...
in fact, we probably rely on filesystem metadata way too much
(historically it's just "worked".... although we do seem to get issues
on ext3).

I have a (casually stupid) simulation program... although I've observed
little to no problems on all my XFS tests using it.

--=20
Stewart Smith, Senior Software Engineer (MySQL Cluster)
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

--=-WAjZXbGIUan1gQIlUjdm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUAR0T3a73yNwHyU3DLAQLp7Q/+PaPp6lTGjHwPBvP8RvoPzEvajjlj9JhM
5jWPDFv8xJcK2zIMCSvzV7gV4FLVTLT6mX4ZOW3dQ7aItbGEM0KzT9P/T82pjDyf
T9j2HRuN45bVEMGuqpkyuwCKuLK+XJv+nKio6+5pZgMpXulWM1xY1pPDaXW/OkP4
ZwgU3CkYkBC0u7bTmCb7fndFmmOtXGXox/4GSTU+J1Ez6SPblcTt66EThCD1ad7d
UfsF08LaEnUNoDfWDNSd2WxnD6A3p4EL3KoUla2lBk7a7FyOOV04zeK9LulinqpA
KceXVgy2J8BUyFeZdlCI02J8QhMJXpG2qgCjpRlmbjZT+dLLCvES2O6I6NqqCNW+
Z/H00c9TWAhpjuWqga5wz0F0xROGec/Nn5rs/3XKz13HmaKny32Dyv2xm9t/1qFr
4GSkHWQtJrovJwA+A6pBIzIJJ4EUbnVanu4pHZ0gL925dqQRCl/49/GsiGuMBQme
gk4Izdf+2sAdQF7lnPAquQXu5g9U19zhLog25jVLr5R4H8gY1hpqKWO3ftC4UOsW
fFjV2aGI+CMb9Fg2lhkgeHyvJFy4Rx+5Luh4OkWDdz9aqknJgR+tthGN5LlWUCZJ
V3HOOHNJrsKIG/0yZ6u/ek++3/+gIuNn1ZGTLQHgvqGGKmrt0GjR0nagNeB6JdtH
uD3ce+3Rq7o=
=KdGI
-----END PGP SIGNATURE-----

--=-WAjZXbGIUan1gQIlUjdm--
