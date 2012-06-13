Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5DBwljb132641 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 06:58:48 -0500
Received: from v3-1046.systemlinux.org (systemlinux.org [79.140.41.46]) by
	cuda.sgi.com with ESMTP id xwQ1G8FCnNvq0BQT for
	<xfs@oss.sgi.com>; Wed, 13 Jun 2012 04:58:44 -0700 (PDT)
Date: Wed, 13 Jun 2012 13:59:34 +0200
From: Andre Noll <maan@systemlinux.org>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Message-ID: <20120613115934.GX32601@systemlinux.org>
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl>
MIME-Version: 1.0
In-Reply-To: <4FD8552C.4090208@xsnews.nl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6754972121679179921=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthew Whittaker-Williams <matthew@xsnews.nl>
Cc: xfs@oss.sgi.com


--===============6754972121679179921==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SvWan4890fseGSLw"
Content-Disposition: inline


--SvWan4890fseGSLw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 13, 10:54, Matthew Whittaker-Williams wrote:
> Current Cache Policy: WriteBack, ReadAheadNone, Direct, Write Cache OK if=
 Bad BBU
> Disk Cache Policy   : Disk's Default

Check if these two policy settings are what you really want. AFAICT
they can make a huge difference, depending on the workload.

Here's what gives best performance. Of course these are also the most
risky settings, so use with care:

	Current Cache Policy: WriteBack, ReadAdaptive, Cached, Write Cache OK if B=
ad BBU
	Disk Cache Policy: Enabled

To select these settings for all lds on adapter 0, use

	CLI=3DMegaCli; lsi_adapter_number=3D0
        $CLI -ldsetprop CachedBadBBU -LALL -a$lsi_adapter_number &&
        $CLI -ldsetprop -Cached -LAll -a$lsi_adapter_number &&
        $CLI -ldsetprop -EnDskCache -LAll -a$lsi_adapter_number &&
        $CLI -ldsetprop WB -LALL -a$lsi_adapter_number

Best
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--SvWan4890fseGSLw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/YgKYACgkQWto1QDEAkw/r2QCdHTi41efixdiLnL027KYkFjcp
6aIAoKO07aUXUm18TMEdiuun8Z53lhtB
=dw9C
-----END PGP SIGNATURE-----

--SvWan4890fseGSLw--


--===============6754972121679179921==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6754972121679179921==--
