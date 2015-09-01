Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F43A7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 20:08:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB64CAC003
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 18:08:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SBzoZGMuXdRHoo0m for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 18:08:39 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZWZpG-0000gc-Tu
	for xfs@oss.sgi.com; Tue, 01 Sep 2015 10:53:26 +1000
Date: Tue, 1 Sep 2015 10:53:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 5d54b8c
Message-ID: <20150901005326.GP3902@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1018183943393907500=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1018183943393907500==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is the final update that will occur for
the 4.3 merge window. Once this has sat in linux-next for a couple
of days (assuming no problems arise) I'll tag it and send a pull
request to Linus....

The new head of the for-next branch is commit:

5d54b8c Merge branch 'xfs-misc-fixes-for-4.3-4' into for-next

New Commits:

Darrick J. Wong (1):
      [dfdd4ac] libxfs: bad magic number should set da block buffer error

Dave Chinner (1):
      [5d54b8c] Merge branch 'xfs-misc-fixes-for-4.3-4' into for-next

David Jeffery (1):
      [c9eb256] xfs: return errors from partial I/O failures to files

Eric Sandeen (1):
      [1a7ccad] xfs: fix error gotos in xfs_setattr_nonsize

Lucas Stach (1):
      [8774cf8] xfs: add mssing inode cache attempts counter increment


Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c | 1 +
 fs/xfs/xfs_aops.c            | 3 ++-
 fs/xfs/xfs_icache.c          | 2 ++
 fs/xfs/xfs_iops.c            | 8 ++++----
 4 files changed, 9 insertions(+), 5 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV5PcGAAoJEK3oKUf0dfodVVwP/Rjg5o0IWZefUEAjPauQUqk9
F9L7YZc9bvDxDxkG/KBosn1lv3/2+uZdjISa/NjxRn1IVlmdgalhHbz7L7oklWl2
TrM6g266e6NuB5YtB1CxphmWnIhpwl/EN6MhF/DiKBVY3AKmq/MRHGvthCOVamCh
5qnwTrl3O95GZrPsZ+OlcMD2tULXie5Tb1KOU7sq5UE1o2Yb4wEMfJNmW7N/m3Ee
d+UMXreFhyzNWgMNAbFr3TyZHegP5+shXITT8h/D9mvXqqePwRbsadrUwjsmhOXQ
sufFVEardSvSpHOKY9Y+jRAby5nOcCVxhO0duHxlfMnRazVgSQfdfAdDnsJnXRPV
hlsJEaEi7byRlmiKvS2npTk44cH+EOACvH2Wy9FlftMzs5q+cboS9VCXhXqBGHDM
TNneHFkdhzPh1JDnMdQFEaDEmKfd+wB2vznH3gO5tgfGf4Zy+KCVd97t6mgIoykW
nZtNQe8YyDf5NpLsZZ0u0Ffyw576GPY81EPSpJX52ItcE/aBhMMfsudmt8cTZllG
x2V/44ciGeBlUvJgj11ccxQTBdtNZ/XszdWq3dvVLOnLfiEE+2GMFoYKh5IucKCl
CbkgzK5t+03I2dIU9peFlHgSAnQQBI8JUYedN+5AzDZtmvdJ1KNM0vgG+JO+Faaf
P4BdMFsBG83qHIYM9fgE
=jNNi
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--


--===============1018183943393907500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1018183943393907500==--
