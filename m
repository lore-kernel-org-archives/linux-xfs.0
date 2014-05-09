Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA5D77F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 00:44:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F24EF8F804B
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 22:44:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8oNkwuIhcBAiTgEF for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 22:44:06 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WidbF-0004ru-Id
	for xfs@oss.sgi.com; Fri, 09 May 2014 15:44:01 +1000
Date: Fri, 9 May 2014 15:44:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v3.2.0-rc3 released
Message-ID: <20140509054401.GK26353@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5217050490464744550=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5217050490464744550==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

593dbdd xfsprogs: v3.2.0-rc3 release

This will hopefully be the last release candidate for 3.2.0. This
update fixes a coupel of build warnings, updates the Debian package
changelogs for the release, fixes an xfs_repair regression and a
xfs_repair scalability issue exposed by files with hundreds of
thousands of extents.

The repository has been tagged (v3.2.0-rc3) and a tarball has been
uploaded to ftp://oss.sgi.com/projects/xfs/cmd_tars/ so you can pull
down the source whicever way you want.

Please test!

-Dave.

Commits since v3.2.0-rc2:

Dave Chinner (3):
      [bbd3275] repair: don't unlock prefetch tree to read discontig buffers
      [bb9ca6c] repair: don't grind CPUs with large extent lists
      [593dbdd] xfsprogs: v3.2.0-rc3 release

Nathan Scott (3):
      [b47c8ca] Fix 32 bit build warning in libxfs, xfs_daddr_t printing
      [ce5da12] Fix msgfmt warning when building the German translation
      [75b480d] Update debian changelog in preparation for pending release


Code Diffstat:

 VERSION           |  2 +-
 debian/changelog  |  7 +++++++
 doc/CHANGES       |  7 +++++++
 libxfs/rdwr.c     |  5 +++--
 po/de.po          |  1 +
 repair/bmap.c     | 40 +++++++++++++++++++++++++++++++++-------
 repair/prefetch.c | 51 +++++++++++++++++++++++++--------------------------
 7 files changed, 77 insertions(+), 36 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbGsgAAoJEK3oKUf0dfodql0P/2XFmUtpOKDWAxmds3FR5Yva
KT+oBRx4Ot4ZcvKA9bzdEjxCs2dgn/6tvwwUJ9u/DqELR6bX1/Mll5XYc10L97Mp
ewGkleYfA5tzj5el7jnKTofXq5od00rXl9/gvXli/NeKKtjeRg49T6YGkg7lK9VH
6kaKByW5rwDoiHOxCeo9i/5+HgoNO3macS5zYym2keCVXXARX7ny/h8F4qg4hcQW
H1hX+TKCo9G0oGtde9jGs4UURT3V51OJNBzonTpxo8qOjTIM7UNkcQUo0bZmz01a
GFtmwX1ub8o5/uqwHoVIHNf6oyWVCSQaqdgtSh5WLeQphdLVO57mhT2LeYTHegSL
reAudgFGU/eVyUHw1YmFwHHehcGP3UfqBzhMnSsZPrsJTgKavBWbxN4nCEzWOA4/
EruZPWnVoOgziaYXSKLElYaKMFwlygUWH7t5+j8JccEPHQEka/JZNniX3+kXL9gi
HWj3CJxBxaIXdCZn42KTSR25MPEi7mRQ+RVbZ4uE1oHHt00NeKoL1zhRoj7TRZgE
F+lA63m91x3d7sqreVvRrMPAmcyYtyvyNZMJFpvXMlg3i9w+JOJy/0XicuFDgfKf
3pW0hQK43L4rX0Et7BrHdrMXXtTYHw+wmGQWvpJxm2IDo97+7I62goCB4b4kD8zZ
icw4aNxkBJij9C0UIwD1
=p6bi
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--


--===============5217050490464744550==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5217050490464744550==--
