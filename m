Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFB637F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 02:06:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CBE2304039
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 00:06:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QUyIUcqWYLvkkCgX for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 00:06:44 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WZayX-0007zu-PH
	for xfs@oss.sgi.com; Mon, 14 Apr 2014 17:06:41 +1000
Date: Mon, 14 Apr 2014 17:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v3.2.0-rc1 tagged
Message-ID: <20140414070641.GK27694@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5671746292813638957=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5671746292813638957==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

fa98503 xfsprogs: v3.2.0-rc1 release

This update indicates that we are getting close to a 3.2.0 release.
We are just about feature complete for CRC enabled filesystems, so
it's time to push towards a full release. I haven't created tarballs
for this release, just tagged the repository and updated the version
and changelogs. I'll release a source tarball for an -rc2 release if
we need it...

At this point, I'm really aiming to have the release complete by the
time that the 3.15 kernel is released, and hence make the 3.15
kernel the first kernel we fully support metadata CRCs on. This
gives us about 6 weeks to finalise the xfsprogs 3.2.0 release, so
testing and bug reprorts and fixes are very welcome at this point.

And while this looks like lots of change leading up to a -rc1
release, the majority of them are Coverity fixes and so remove a lot
of noise from the checker reports and hence will help us identify
new issues a lot faster.

Cheers,

Dave.

----

New Commits:

Dave Chinner (1):
      [fa98503] xfsprogs: v3.2.0-rc1 release

Eric Sandeen (17):
      [11e0696] xfsprogs: fix various fd leaks
      [d0e82db] xfs_fsr: refactor fsrall_cleanup
      [355ac01] xfsprogs: trivial buffer frees on error paths
      [0284875] libxlog: fix memory leak in xlog_recover_add_to_trans
      [edbdb4f] libxfs: fix memory leak in xfs_dir2_node_removename
      [f6a8b88] xfs_quota: fix memory leak in quota_group_type() error path
      [04536ba] xfs_logprint: fix leak in error path of xlog_print_record()
      [682fa9e] libxfs: free resources in libxfs_alloc_file_space error pat=
hs
      [90ec25e] libxfs: annotate a case fallthrough in libxfs_ialloc
      [04c2e8d] xfs_db: fix too-large memset value in attr code
      [9d473f4] xfs_quota: remove impossible tests in printpath
      [f8579c0] xfs_repair: address never-true tests in repair/bmap.c on 64=
 bit
      [3ddc4ae] mkfs: catch unknown format in protofile parsing
      [d15f7cf] xfs_db: don't use invalid index in ring_f
      [d0bbcbc] xfsprogs: remove write-only assignments
      [0337778] xfs_io: fix random pread/pwrite to honor offset
      [e887198] libxfs: remove never-read "offset" assignment in readbufr_m=
ap & writebufr

Mark Tinguely (1):
      [9404cb4] logprint: handle split EFI entry


Code Diffstat:

 VERSION                   |  2 +-
 copy/xfs_copy.c           |  3 +--
 db/addr.c                 | 15 +++++++--------
 db/attrset.c              |  2 +-
 db/bmap.c                 |  1 -
 db/check.c                |  5 +++--
 db/convert.c              |  1 -
 db/io.c                   |  4 +++-
 db/write.c                |  2 ++
 doc/CHANGES               | 18 ++++++++++++++++++
 fsr/xfs_fsr.c             | 34 +++++++++++++++++++++-------------
 growfs/xfs_growfs.c       |  1 -
 include/bitops.h          |  1 -
 io/parent.c               |  2 ++
 io/pread.c                |  2 +-
 io/pwrite.c               |  2 +-
 io/readdir.c              |  1 +
 libhandle/handle.c        |  1 +
 libxfs/rdwr.c             |  4 +---
 libxfs/util.c             | 21 ++++++++++++++++++---
 libxfs/xfs_dir2_node.c    | 26 +++++++++++++-------------
 libxlog/xfs_log_recover.c |  1 +
 logprint/log_misc.c       | 43 ++++++++++++++++++++++++++++++++-----------
 logprint/log_print_all.c  |  3 +--
 logprint/logprint.h       |  2 +-
 mkfs/proto.c              | 18 ++++++++++++++----
 mkfs/xfs_mkfs.c           |  2 --
 quota/path.c              |  8 ++++----
 quota/quot.c              |  1 +
 quota/quota.c             | 20 ++++++++++++--------
 repair/attr_repair.c      |  2 --
 repair/bmap.c             |  8 ++++----
 repair/dir2.c             |  3 +--
 repair/phase5.c           |  3 ---
 repair/phase6.c           |  1 -
 repair/prefetch.c         |  1 -
 repair/sb.c               |  2 --
 rtcp/xfs_rtcp.c           |  2 ++
 38 files changed, 168 insertions(+), 100 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTS4kBAAoJEK3oKUf0dfodMwgQAJbY6xEoD42JazhEprp7Qi+L
UqcICLfQLy8R50ZqaYS8h5uEHLJpGedRJjwdqeeDAPVrgA7y67/pE0Uy14frq5Q/
J10hVEl3UobmjnHk1L3WyabdZfPLMIWjbf2ZOzlNPgKmHXR0mvFAQ5Lkvq+tftVW
3AgwnmM7JurfMKJvOUSc+5e+a6gJml90SekxwGrVFRkqxR7CCrglYYOZn/dSJuHH
Iyr0Srq2ly8TzdrsTFMMCM2AHXkgHv7i5KEM0cQIIz0Sj6BVKnalIJvO9mPIPRWu
CB+TcmjTFsxzKADq6/Y2aPDT26C9sxXYZWebboYC5diMZeeS6MUVbePwOXmn4tT3
C8Kfk59wU/sIINl9lGEzTTsmfPdpeydAEJKMdZIArzDwkBaZR7/BxDs9kz7P5hQv
NakxtlpPxt5U65K6tSU/lYT7LZOI6U0h0wcfBCoTJWKkGZHtG+WDRrFkr0QMCmPa
MHDTa8Tl4sMuJmQgRjMQwAPkO+zyxeE/n4fnGI+iCwAT72QgT9cEveE6M9elfOTu
CLQI9rpYnSRLtnfFEhW2pFjlEmMDOU0Xph7CUVn23Jd3wDLpWRWcN7piAT4Dxyzw
ELFdUIO3c6qfZnEX1FQ2n8iidoOEMQCHvSOOSinvFtuYwyBbn46RhCCoKMJKmxJH
W3K4sqbS/ZFtlNVePARM
=IkLs
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--


--===============5671746292813638957==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5671746292813638957==--
