Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AADEA7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:45:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 988688F8033
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 15:45:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JVBA7WEmGKDxF7PL for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 15:45:37 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aGEoh-000349-DL
	for xfs@oss.sgi.com; Tue, 05 Jan 2016 10:45:35 +1100
Date: Tue, 5 Jan 2016 10:45:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs-documentation: master branch updated to a04146a
Message-ID: <20160104234535.GF19802@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0190230017487200577=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0190230017487200577==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi folks,

The xfs documentation repository at

git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated. This is a major update to the XFS Filesystem
Structure document which brings it up to date with the current on
disk format. A big thank you must go to Darrick for doing this work,
and to Christoph for reviewing it.

-Dave.

The new head of the guilt/working branch is commit:

a04146a move directory chapter before xattr chapter

New Commits:

Darrick J. Wong (20):
      [38d3e30] fix asciidoc confusion w.r.t. include file newline at EOF
      [bda4165] update book subtitles and headings
      [728d229] restore the old rendering of structure field definitions
      [042c084] convert html entities to regular characters
      [f14c343] convert images to text
      [c93a293] delete images of hex dumps
      [0b39c06] update types
      [d77fa4e] make example section titles consistent
      [983e8a1] fix various errors and missing bits in the text
      [38dcd43] add missing structure field definitions
      [410e764] add missing xfs_db examples
      [36ce418] fix quoted text markings
      [8b4a922] introduce XFS at a high level
      [02be33c] document the xfs log format
      [13be785] document the operation of the realtime device and inodes
      [372d53f] add documentation of v5 fields
      [e95c161] add a chapter discussing v5 disk format
      [70cbe0d] document magic numbers and theoretical limits
      [83abac0] document the sparse inodes feature
      [a04146a] move directory chapter before xattr chapter


Code Diffstat:

 .../allocation_groups.asciidoc                     | 808 ++++++++++++++++-=
---
 .../XFS_Filesystem_Structure/common_types.asciidoc |  41 +-
 .../XFS_Filesystem_Structure/data_extents.asciidoc | 210 ++++--
 .../XFS_Filesystem_Structure/directories.asciidoc  | 818 +++++++++++++++++=
---
 design/XFS_Filesystem_Structure/docinfo.xml        |  43 +-
 .../extended_attributes.asciidoc                   | 466 ++++++++++--
 .../XFS_Filesystem_Structure/images/code/33a.png   | Bin 106484 -> 0 bytes
 .../XFS_Filesystem_Structure/images/code/33b.png   | Bin 40229 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/40.png | Bin 94094 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/46.png | Bin 78484 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/57.png | Bin 17987 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/60.png | Bin 32907 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/61.png | Bin 54687 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/65.png | Bin 107515 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/66.png | Bin 69316 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/67.png | Bin 109738 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/71.png | Bin 62675 -> 0 bytes
 .../XFS_Filesystem_Structure/images/code/73-74.png | Bin 153732 -> 0 bytes
 design/XFS_Filesystem_Structure/images/code/74.png | Bin 62210 -> 0 bytes
 .../images/code/SVG/33a.svg                        | 185 -----
 .../images/code/SVG/33b.svg                        | 158 ----
 .../images/code/SVG/40.svg                         | 177 -----
 .../images/code/SVG/46.svg                         | 197 -----
 .../images/code/SVG/57.svg                         | 129 ----
 .../images/code/SVG/60.svg                         | 182 -----
 .../images/code/SVG/61.svg                         | 157 ----
 .../images/code/SVG/65.svg                         | 233 ------
 .../images/code/SVG/66.svg                         | 260 -------
 .../images/code/SVG/67.svg                         | 232 ------
 .../images/code/SVG/71.svg                         | 150 ----
 .../images/code/SVG/73-74.svg                      | 364 ---------
 .../images/code/SVG/74.svg                         | 201 -----
 .../internal_inodes.asciidoc                       | 123 +--
 .../journaling_log.asciidoc                        | 836 +++++++++++++++++=
+++-
 design/XFS_Filesystem_Structure/magic.asciidoc     |  86 +++
 .../metadata_integrity.asciidoc                    |  36 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc | 209 ++++--
 design/XFS_Filesystem_Structure/overview.asciidoc  |  38 +
 .../symbolic_links.asciidoc                        |  76 +-
 .../xfs_filesystem_structure.asciidoc              |  51 +-
 40 files changed, 3281 insertions(+), 3185 deletions(-)
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/33a.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/33b.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/40.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/46.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/57.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/60.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/61.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/65.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/66.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/67.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/71.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/73-74.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/74.png
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/33a.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/33b.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/40.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/46.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/57.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/60.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/61.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/65.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/66.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/67.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/71.svg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/73-74.s=
vg
 delete mode 100644 design/XFS_Filesystem_Structure/images/code/SVG/74.svg
 create mode 100644 design/XFS_Filesystem_Structure/magic.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/metadata_integrity.asci=
idoc
 create mode 100644 design/XFS_Filesystem_Structure/overview.asciidoc
--=20
Dave Chinner
david@fromorbit.com

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWiwQeAAoJEK3oKUf0dfodB/QQANIAE0fJ1FoSuRGXOInJDtqw
kv/MYlzd5qKe2RJdaHgMGmOWY0AHKtEhdRbhLyf0jYpaWqWxxXL7pVRAB5nrsSk3
8jFET0iyrTr+u4CWiYYzv98ybMl/DACggeC7RqirOwLXM25vR4trywST+lSov+PL
9cSE15nzPt+hD/HB70BSDlFdT6++DQ7Mnbi7LOwXivM3mKrhjBUqj6LV3L15eZbU
IhNr6iU6Cggrr8eZ6p0XnEMNV0zhMtOsd8qjY8AgEq0a6KEYMCClCwscZfrFXi+8
1ddfgIVyjzL2CUk7FHYBju4A1BelRPi6itztRm6HiSOdQ/FDL5c8Q89AoH6rLqTx
sNWQqHdzIhECjZOZy9z6VjRppL2GbT2eDu0Xj2DsADbYRP6qV/I6cdB79hn9yAxj
L4LAHjWh4NrKbMyfquJ+t+b2R7SDkBn8Bkjx/5cu1rOyHSaI6wuUVs7RwrusngLX
kZ0wr8ewD4Gdlat1KSjC9UJTMD/U1TO3s8K8xItzxCVAWA9x44u/ZDNVRf0pxivo
ax0iX62A5ulnyQAssB2v/V/eOCQYaSY+1qRob/oAyKLj+EdAxw+MGr6uKhEOfDlG
tW5BOZJCeMvMkuWQjVXMjcKMHdG05eCKpUvWz2+qGAb3HNPYICJyEMx6WStSPVS0
AkRtjJDjd1sQgElsEsAP
=JQrY
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--


--===============0190230017487200577==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0190230017487200577==--
