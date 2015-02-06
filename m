Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A61D0801E
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 18:24:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50506AC001
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 16:24:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tIdBUcURTMQmvDYR for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 16:24:14 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YJWiF-0006ET-OP
	for xfs@oss.sgi.com; Fri, 06 Feb 2015 11:23:59 +1100
Date: Fri, 6 Feb 2015 11:23:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 354240e
Message-ID: <20150206002359.GX4251@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4088239552921402383=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4088239552921402383==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The 354240e branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. Unless there are late breaking bug fixes,
this will be the last update to this branch before the 3.20 merge
window opens (expected early next week).

-Dave.

The new head of the 354240e branch is commit:

354240e Merge branch 'xfs-misc-fixes-for-3.20-4' into for-next

New Commits:

Christoph Hellwig (1):
      [f8079b8] xfs: growfs should use synchronous transactions

Dave Chinner (1):
      [354240e] Merge branch 'xfs-misc-fixes-for-3.20-4' into for-next

Eric Sandeen (2):
      [de8bd0e] xfs: fix panic_mask documentation
      [01f9882] xfs: report proper f_files in statfs if we overshoot imaxpct

kbuild test robot (1):
      [f92090e] xfs: xfs_ioctl_setattr_check_projid can be static


Code Diffstat:

 Documentation/filesystems/xfs.txt | 5 +++--
 fs/xfs/xfs_fsops.c                | 1 +
 fs/xfs/xfs_ioctl.c                | 4 ++--
 fs/xfs/xfs_super.c                | 5 +++++
 4 files changed, 11 insertions(+), 4 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU1AmfAAoJEK3oKUf0dfodmlEQAK4qQa0Aa+HltVFuYdtAGbgB
6OzAfcKSt9UROhssRyH5kQzqOUsfoZr8YWdTJCWn4nN/ODXhl/HLld/9wfg9TGGN
vjyoGBT1FJphgSIfFh+m4HKwFiPHLmZGm/kVYjB7RGGs3M569bXthlx9IA5wzTxb
bTLsn8UjQlTJOZAYC2JIMktusaPoeYxtMc2qg2fCsmv7Pk5SgDl4BqioLHk5TV+a
2DUrxkSUAELIQOfCdVkZe5zsX0bkmpyrsKAXItlcBprBuMrBYahebgtiLaKBk9Zx
sSuVQvsNlsP+36xUWZeDbpopB4gRYjQypJ0A05BdAtY0eytIKheCrq3FFf39DjPk
kakytD35pTjhCrl4mqUE9tAyOz7AnD/1ElH58uFy2QeBuAm+R9XkwYMGLcGIpv2L
g9otIWzYouk9f4Ta6YtlNHSj/XPADn177Yn5XXb17vkJs06Ocm4KKEi3I8BxOb97
QE28/+eWruKWoPjDe4sxZ48zGbJGQwl0uTOZKd+TYlP443lYsnku/edaSFDaxkeF
94oon2yLJnMb0TxGxUlRqU3KHCF+2sLVftjfjtvh1kyGzmMdRKoLGM+HM0KBR/GP
rctYKzTeiBMv+bB960fnciVzpzJLZ7CP+gUHjb5x3s7wRItt1yNCCtv1WYG7E47f
zNwmfWyI4oSWwhU0GozN
=l2Vk
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--


--===============4088239552921402383==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4088239552921402383==--
