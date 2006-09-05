Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 00:55:13 -0700 (PDT)
Received: from smtp3.adl2.internode.on.net (smtp3.adl2.internode.on.net [203.16.214.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k857snDW006978
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 00:54:50 -0700
Subject: Re: review: propogate return codes from flush routines
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <44FC0D0F.60403@sgi.com>
References: <44FC0D0F.60403@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4A1jMXZoNsX4cSbdR8hr"
Date: Tue, 05 Sep 2006 17:54:08 +1000
Message-Id: <1157442848.5844.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

--=-4A1jMXZoNsX4cSbdR8hr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-09-04 at 12:25 +0100, Lachlan McIlroy wrote:
> Here's a patch to handle error return values in fs_flush_pages and
> fs_flushinval_pages.  It changes the prototype of fs_flushinval_pages
> so we can propogate the errors and handle them at higher layers.  I also=
=20
> modified xfs_itruncate_start so that it could propogate the error further.

IMHO this is always a good idea. Although I guess the only concern can
be getting the right error back (and a useful one).=20

> The motivation behind this change was the recent BUG reported due to a
> direct I/O read trying to write to delayed alloc extents.  While the exact
> cause of this problem is not known it is possible that fs_flushinval_pages
> ignored an error while flushing, truncated the pages on the file anyway,
> and failed to convert all delayed alloc extents.

from a quick look the patch seems to do as advertised.

i probably just haven't looked hard enough - but I'm assuming the layers
higher up deal with the error and: report to user, write log message or
something if there's a really catastrophic error?

--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-4A1jMXZoNsX4cSbdR8hr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBE/S0gKglWCUL+FDoRAmYOAKDWkSrawcugWkypcl3U+uhCnm9YtACeIlKY
VxE8pVDXIERtN4mRxSKH/1o=
=AvC+
-----END PGP SIGNATURE-----

--=-4A1jMXZoNsX4cSbdR8hr--
