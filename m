Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 15:22:48 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JMLpDW003991
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 15:21:51 -0700
Date: Wed, 19 Jul 2006 23:14:02 +0200
From: Torsten Landschoff <torsten@debian.org>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060719211402.GA1133@stargate.galaxy>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20060719085731.C1935136@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nathan,=20

On Wed, Jul 19, 2006 at 08:57:31AM +1000, Nathan Scott wrote:
=20
> I suspect you had some residual directory corruption from using the
> 2.6.17 XFS (which is known to have a lurking dir2 corruption issue,
> fixed in the latest -stable point release).

That probably the cause of my problem. Thanks for the info!

BTW: I think there was nothing important on the broken filesystems, but
I'd like to keep what's still there anyway just in case... How would you
suggest should I copy that data? I fear, just mounting and using cp=20
might break and shutdown the FS again, would xfsdump be more
appropriate?

Thanks for XFS, I am using it for years in production servers!

Greetings

	Torsten

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEvqCadQgHtVUb5EcRAoJLAJ4jJaYRxbnNVCEZBJuki2kTz2VtQwCfd2Mq
9BasGncq2cRLpRTp5wU9EMM=
=NS5n
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
