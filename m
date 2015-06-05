Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 584267FBA
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 21:42:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06FC3304053
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 19:42:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3m8AHmGX0rePF805 for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 19:42:41 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Z0hah-0006Q7-DB
	for xfs@oss.sgi.com; Fri, 05 Jun 2015 12:42:39 +1000
Date: Fri, 5 Jun 2015 12:42:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch created
Message-ID: <20150605024239.GQ9143@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5868621840543460231=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5868621840543460231==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I just created the for-next branch in the xfsprogs-dev repository
on kernel.org. This branch is similar to the kernel for-next branch,
in that it is a rebasing branch that aggregates all the current
topic branches under developement. This branch is intended to
reflect the next release of the xfsprogs package, and I'll probably
run it in a similar manner to the kernel dev/merge cycle. You can
get the branch here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git for-next

I'm hoping to end up with a regular xfsprogs release cycle, somewhat
aligned to the kernel release cycle so that the userspace source
is kept up to date with the kernel code, and so that we release
support for new features in both the kernel and userspace code at
the same time.

Right now the branch is based on the 3.2.3-rc2 release, with the 4.1
update, some miscellaneous fixes and the sparse inode support from
Brian.  Once I release 3.2.3 (early next week at this point), I'll
rebase this branch on the release, and we'll work towards a 3.3
release from there.

You'll get an idea of the size of the update from the diffstat
below; I'm hoping that this sort of update is going to be a thing of
the past....

-Dave.

The new head of the for-next branch is commit:

841358d Merge branch 'sparse-inodes' into for-next

New Commits:

Brian Foster (28):
      [80967e0] xfs: create individual inode alloc. helper
      [c3eeec1] xfs: update free inode record logic to support sparse inode=
 records
      [69e54e7] xfs: support min/max agbno args in block allocator
      [e8a8872] xfs: add sparse inode chunk alignment superblock field
      [e1a8d5a] xfs: use sparse chunk alignment for min. inode allocation r=
equirement
      [4066502] xfs: sparse inode chunks feature helpers and mount requirem=
ents
      [cc3159c] xfs: add fs geometry bit for sparse inode chunks
      [03efd82] xfs: introduce inode record hole mask for sparse inode chun=
ks
      [9dd2877] xfs: pass inode count through ordered icreate log item
      [997709d] xfs: enable sparse inode chunks for v5 superblocks
      [1e9c0cd] mkfs: sparse inode chunk support
      [1fc9a33] db: support sparse inode chunk inobt record and sb fields
      [f2061da] db: show sparse inodes feature state in version command out=
put
      [ab1cd41] growfs: display sparse inode status from xfs_info
      [52c32f6] repair: handle sparse format inobt record freecount correct=
ly
      [c6e886e] repair: remove duplicate field from aghdr_cnts
      [b37a07e] repair: use ir_count for filesystems with sparse inode supp=
ort
      [fd6ec00] repair: scan and track sparse inode chunks correctly
      [e57d372] repair: scan sparse finobt records correctly
      [5832255] repair: validate ir_count field for sparse format records
      [74b153e] repair: process sparse inode records correctly
      [e572386] repair: factor out sparse inodes from finobt reconstruction
      [df6a640] repair: do not account sparse inodes in phase 5 cursor init.
      [5109d66] repair: reconstruct sparse inode records correctly on disk
      [ffdcb5b] repair: do not prefetch holes in sparse inode chunks
      [1b20fe5] repair: handle sparse inode alignment
      [d05f80e] metadump: reorder inode record sanity checks and inode buff=
er read
      [f81d357] metadump: support sparse inode records

Dave Chinner (13):
      [b2c3385] libxfs: do all xfs->libxfs defines inside libxfs/
      [b5f36ac] xfs: kill unsupported superblock versions
      [3a252cc] libxfs: update to 3.16 kernel code
      [eefa606] xfs: return is not a function
      [8066e7e] xfs: Nuke XFS_ERROR macro
      [b6daf45] libxfs: error negation rework
      [2fe8a24] libxfs: restructure to match kernel layout
      [7c8632e] libxfs: update to match 3.19-rc1 kernel code
      [d491a6d] libxfs: update to 4.1-rc2 code base
      [bd3b79c] libxfs: directly include libxfs headers
      [c7e9ce3] libxfs: disambiguate xfs.h
      [e104a5b] libxfs: split out xfs->libxfs mappings
      [841358d] Merge branch 'sparse-inodes' into for-next

Eric Sandeen (6):
      [4407b13] libxfs: silence unused var warnings
      [8e72611] build: install PKGHFILES in install-dev
      [bb46491] libxlog: remove unused write-only var l_logsize
      [f0873ce] libxlog: add xlog_is_empty() helper
      [585043a] metadump: rename dont_obfuscate variable
      [ec693e1] metadump: zero out clean log


Code Diffstat:

 Makefile                               |   15 +-
 db/attr.c                              |    2 +-
 db/block.c                             |   16 +-
 db/bmap.c                              |   47 +-
 db/bmap.h                              |   12 +-
 db/bmroot.c                            |    4 +-
 db/btblock.c                           |   45 +-
 db/btblock.h                           |    3 +
 db/check.c                             |  247 +++---
 db/dir2.c                              |   68 +-
 db/dir2sf.c                            |    8 +-
 db/faddr.c                             |   72 +-
 db/field.c                             |   14 +-
 db/field.h                             |    2 +
 db/frag.c                              |   10 +-
 db/init.c                              |    4 +-
 db/inode.c                             |    1 -
 db/io.c                                |   12 +-
 db/metadump.c                          |  204 +++--
 db/sb.c                                |   55 +-
 db/type.c                              |   40 +
 db/type.h                              |    1 +
 fsr/xfs_fsr.c                          |    1 -
 growfs/xfs_growfs.c                    |   13 +-
 include/Makefile                       |   47 +-
 include/buildrules                     |    4 +-
 include/libxfs.h                       |  698 ++-------------
 include/libxlog.h                      |   13 +-
 include/xfs_ag.h                       |  279 ------
 include/xfs_arch.h                     |   18 -
 include/xfs_dinode.h                   |  243 ------
 include/xfs_dir2.h                     |  111 ---
 include/xfs_format.h                   |  454 ----------
 include/xfs_inode.h                    |  106 +++
 include/xfs_inum.h                     |   64 --
 include/xfs_mount.h                    |  149 ++++
 include/xfs_sb.h                       |  712 ---------------
 include/xfs_trace.h                    |   14 +-
 include/xfs_trans.h                    |  148 ++++
 libxfs/Makefile                        |   56 +-
 libxfs/cache.c                         |   15 +-
 libxfs/crc32.c                         |    5 +-
 libxfs/darwin.c                        |    4 +-
 libxfs/freebsd.c                       |    4 +-
 libxfs/init.c                          |   46 +-
 libxfs/irix.c                          |    4 +-
 libxfs/kmem.c                          |    2 +-
 libxfs/libxfs_api_defs.h               |  111 +++
 libxfs/libxfs_io.h                     |  236 +++++
 libxfs/{xfs.h =3D> libxfs_priv.h}        |  247 +++---
 libxfs/linux.c                         |    4 +-
 libxfs/logitem.c                       |   12 +-
 libxfs/radix-tree.c                    |    2 +-
 libxfs/rdwr.c                          |   35 +-
 libxfs/trans.c                         |   25 +-
 libxfs/util.c                          |  116 ++-
 libxfs/xfs_alloc.c                     |  219 +++--
 {include =3D> libxfs}/xfs_alloc.h        |    6 +
 libxfs/xfs_alloc_btree.c               |   97 +--
 {include =3D> libxfs}/xfs_alloc_btree.h  |    0
 libxfs/xfs_attr.c                      |  466 +++++-----
 libxfs/xfs_attr_leaf.c                 |  463 ++++++----
 {include =3D> libxfs}/xfs_attr_leaf.h    |   11 +-
 libxfs/xfs_attr_remote.c               |  108 ++-
 {include =3D> libxfs}/xfs_attr_remote.h  |    0
 {include =3D> libxfs}/xfs_attr_sf.h      |    0
 {include =3D> libxfs}/xfs_bit.h          |    7 +-
 libxfs/xfs_bmap.c                      | 1141 ++++++++++++++++++------
 {include =3D> libxfs}/xfs_bmap.h         |   69 +-
 libxfs/xfs_bmap_btree.c                |  223 +----
 {include =3D> libxfs}/xfs_bmap_btree.h   |    2 +-
 libxfs/xfs_btree.c                     |  221 +++--
 {include =3D> libxfs}/xfs_btree.h        |   67 +-
 {include =3D> libxfs}/xfs_cksum.h        |    0
 libxfs/xfs_da_btree.c                  |  509 +++++------
 {include =3D> libxfs}/xfs_da_btree.h     |   29 +-
 libxfs/xfs_da_format.c                 |  908 +++++++++++++++++++
 {include =3D> libxfs}/xfs_da_format.h    |  514 +----------
 libxfs/xfs_dir2.c                      |  502 ++++++-----
 libxfs/xfs_dir2.h                      |  323 +++++++
 libxfs/xfs_dir2_block.c                |  201 +++--
 libxfs/xfs_dir2_data.c                 |  271 +++---
 libxfs/xfs_dir2_leaf.c                 |  432 +++++----
 libxfs/xfs_dir2_node.c                 |  505 +++++------
 libxfs/xfs_dir2_priv.h                 |   30 +-
 libxfs/xfs_dir2_sf.c                   |  394 +++------
 libxfs/xfs_dquot_buf.c                 |   43 +-
 libxfs/xfs_format.h                    | 1497 ++++++++++++++++++++++++++++=
++++
 {include =3D> libxfs}/xfs_fs.h           |    9 +-
 libxfs/xfs_ialloc.c                    |  656 ++++++++------
 {include =3D> libxfs}/xfs_ialloc.h       |   27 +-
 libxfs/xfs_ialloc_btree.c              |  109 +--
 {include =3D> libxfs}/xfs_ialloc_btree.h |    0
 libxfs/xfs_inode_buf.c                 |   68 +-
 {include =3D> libxfs}/xfs_inode_buf.h    |    2 +
 libxfs/xfs_inode_fork.c                |   78 +-
 {include =3D> libxfs}/xfs_inode_fork.h   |    3 +-
 {include =3D> libxfs}/xfs_log_format.h   |    6 +-
 libxfs/xfs_log_rlimit.c                |   16 +-
 {include =3D> libxfs}/xfs_quota_defs.h   |    4 +-
 libxfs/xfs_rtbitmap.c                  |   69 +-
 libxfs/xfs_sb.c                        |  461 +++++-----
 libxfs/xfs_sb.h                        |   38 +
 {include =3D> libxfs}/xfs_shared.h       |   33 +-
 libxfs/xfs_symlink_remote.c            |   23 +-
 libxfs/xfs_trans_resv.c                |  164 ++--
 {include =3D> libxfs}/xfs_trans_resv.h   |    4 +-
 {include =3D> libxfs}/xfs_trans_space.h  |    7 +-
 {include =3D> libxfs}/xfs_types.h        |   29 +-
 libxlog/util.c                         |   57 ++
 libxlog/xfs_log_recover.c              |    2 +-
 logprint/log_copy.c                    |    2 +
 logprint/log_dump.c                    |    2 +
 logprint/log_misc.c                    |    6 +-
 logprint/log_print_all.c               |    2 +
 logprint/log_print_trans.c             |    2 +
 logprint/logprint.c                    |    8 +-
 logprint/logprint.h                    |    2 -
 man/man8/mkfs.xfs.8                    |   17 +
 mdrestore/xfs_mdrestore.c              |    2 +-
 mkfs/maxtrres.c                        |    3 +-
 mkfs/proto.c                           |   68 +-
 mkfs/xfs_mkfs.c                        |   77 +-
 po/de.po                               |    8 +-
 po/pl.po                               |    8 +-
 repair/agheader.c                      |   41 +-
 repair/agheader.h                      |    8 +-
 repair/attr_repair.c                   |   66 +-
 repair/attr_repair.h                   |   33 -
 repair/bmap.c                          |   36 +-
 repair/bmap.h                          |   20 +-
 repair/dino_chunks.c                   |  208 +++--
 repair/dinode.c                        |  181 ++--
 repair/dinode.h                        |   12 +-
 repair/dir2.c                          |  151 ++--
 repair/globals.h                       |   14 -
 repair/incore.c                        |    6 +-
 repair/incore.h                        |   42 +-
 repair/incore_bmc.c                    |   10 +-
 repair/incore_ext.c                    |    8 +-
 repair/incore_ino.c                    |    1 +
 repair/phase2.c                        |   61 +-
 repair/phase4.c                        |    6 +-
 repair/phase5.c                        |   66 +-
 repair/phase6.c                        |  302 +++----
 repair/phase7.c                        |   14 +-
 repair/prefetch.c                      |   53 +-
 repair/rt.c                            |   14 +-
 repair/sb.c                            |  129 +--
 repair/scan.c                          |  212 +++--
 repair/scan.h                          |   12 +-
 repair/versions.c                      |   65 +-
 repair/versions.h                      |    1 -
 repair/xfs_repair.c                    |    8 +-
 154 files changed, 9887 insertions(+), 8103 deletions(-)
 delete mode 100644 include/xfs_ag.h
 delete mode 100644 include/xfs_dinode.h
 delete mode 100644 include/xfs_dir2.h
 delete mode 100644 include/xfs_format.h
 create mode 100644 include/xfs_inode.h
 delete mode 100644 include/xfs_inum.h
 create mode 100644 include/xfs_mount.h
 delete mode 100644 include/xfs_sb.h
 create mode 100644 include/xfs_trans.h
 create mode 100644 libxfs/libxfs_api_defs.h
 create mode 100644 libxfs/libxfs_io.h
 rename libxfs/{xfs.h =3D> libxfs_priv.h} (68%)
 rename {include =3D> libxfs}/xfs_alloc.h (96%)
 rename {include =3D> libxfs}/xfs_alloc_btree.h (100%)
 rename {include =3D> libxfs}/xfs_attr_leaf.h (91%)
 rename {include =3D> libxfs}/xfs_attr_remote.h (100%)
 rename {include =3D> libxfs}/xfs_attr_sf.h (100%)
 rename {include =3D> libxfs}/xfs_bit.h (97%)
 rename {include =3D> libxfs}/xfs_bmap.h (72%)
 rename {include =3D> libxfs}/xfs_bmap_btree.h (98%)
 rename {include =3D> libxfs}/xfs_btree.h (91%)
 rename {include =3D> libxfs}/xfs_cksum.h (100%)
 rename {include =3D> libxfs}/xfs_da_btree.h (87%)
 create mode 100644 libxfs/xfs_da_format.c
 rename {include =3D> libxfs}/xfs_da_format.h (69%)
 create mode 100644 libxfs/xfs_dir2.h
 create mode 100644 libxfs/xfs_format.h
 rename {include =3D> libxfs}/xfs_fs.h (98%)
 rename {include =3D> libxfs}/xfs_ialloc.h (91%)
 rename {include =3D> libxfs}/xfs_ialloc_btree.h (100%)
 rename {include =3D> libxfs}/xfs_inode_buf.h (95%)
 rename {include =3D> libxfs}/xfs_inode_fork.h (99%)
 rename {include =3D> libxfs}/xfs_log_format.h (99%)
 rename {include =3D> libxfs}/xfs_quota_defs.h (97%)
 create mode 100644 libxfs/xfs_sb.h
 rename {include =3D> libxfs}/xfs_shared.h (93%)
 rename {include =3D> libxfs}/xfs_trans_resv.h (97%)
 rename {include =3D> libxfs}/xfs_trans_space.h (95%)
 rename {include =3D> libxfs}/xfs_types.h (82%)
--=20
Dave Chinner
david@fromorbit.com

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVcQyeAAoJEK3oKUf0dfodcPcP/2Izr3woa3MV0fa9ZgBLQ3wE
A2jCr8TRI+iMIbMIfWgVqFMfHIiDx9SHGycUwI1izEaYrjQyjX66j+Z24ZKLkDW6
n8zgKA32qVF3MMga+hBozQ+USIhzmoqXXCGVcqRPiQOwvA1o9UAGKOWM0uCdZHuM
iJOLycwhj7TqLhXZ4dyviwF/QIOwN2/iRMgW2KKFvmOVPMjOaNJG7ukooPh7Gs+d
gKhpjrmzB6Br1vk24F5HGiC+k+rAYaNLa1pokkvaTNtDc4Q5soeqnUcZ7Hx/foXI
sll37Y9SP2lgaQINbyDR03wEEEfZuWayDobwjfUJ+hai14KkeQJgiwrV7D//1L/A
ZYok1k7xSQGu+tXRiRtHcEba+5mG3y9wnfIZ01ohDAfLwP4cW6Rz0A7YGyB1DwMx
JqFwVO47LObocHSdFsbb7jHfZ94b7R+wxS5/6g39/sLpiDn3H6h7DgSfwlGsMvkJ
E0q14qWvUJRxktDm0n3yc0fJwzyWMZjUp/eKi/lAk8JvyIkwWqOl+I+CNrLRtAT6
cWvdIDDm4iZ+cwyj6OGrfRpTX0VHDQ62k0AiRYY1cNNLpzkOneXHu5YocYh4Ijwp
ywKWwvpte+unf1/F97RYGvA/9lBZDNTezbER9l6WxuSLT+L1EjSvAdOElQoFTfIt
a6WEvgqMiaz9E/pe/p7D
=c5d3
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--


--===============5868621840543460231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5868621840543460231==--
