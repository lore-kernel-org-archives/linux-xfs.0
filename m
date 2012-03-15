Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2F811w2076702 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 03:01:01 -0500
Received: from v3-1046.systemlinux.org (systemlinux.org [79.140.41.46]) by
	cuda.sgi.com with ESMTP id PbctZO1wsCBhAgmQ for
	<xfs@oss.sgi.com>; Thu, 15 Mar 2012 01:00:58 -0700 (PDT)
Date: Thu, 15 Mar 2012 09:01:11 +0100
From: Andre Noll <maan@systemlinux.org>
Subject: Re: display project quota as user
Message-ID: <20120315080111.GB26508@systemlinux.org>
References: <20120314130902.GA26508@systemlinux.org>
	<20120314233127.GL5091@dastard>
MIME-Version: 1.0
In-Reply-To: <20120314233127.GL5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5971646119145623350=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: =?utf-8?B?QW5kcsOpIEMu?= Stiel <andre.stiel@tuebingen.mpg.de>, xfs@oss.sgi.com


--===============5971646119145623350==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 15, 10:31, Dave Chinner wrote:
> > Is there a better way to allow users to display project quotas?
>=20
> There is no user <=3D> projid mapping that exists, so either the
> information is available to everyone, or it is available only to
> root. In this case, system wide quota reports are limited to root,
> and I don't see that changing.
>=20
> If you really must allow users to see project quota limits, then
> write a simple wrapper program and allow only the users that need
> the infomration to execute it via sudo....

OK, will do that. Thanks for the clarification.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9hoccACgkQWto1QDEAkw/AGwCfdQUa3LMERJyIWMsan/BzuKdc
wKIAn1AAEbtBbrzbQD1kv5FTGQT6gt6z
=Yt7y
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--


--===============5971646119145623350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5971646119145623350==--
