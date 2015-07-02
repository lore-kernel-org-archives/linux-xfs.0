Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC3F07FB6
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 07:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9AD14304053
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 05:34:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pBlkPa2DMQCd5HEh for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 05:34:10 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZAdgs-00069Y-Fb
	for xfs@oss.sgi.com; Thu, 02 Jul 2015 22:34:06 +1000
Date: Thu, 2 Jul 2015 22:34:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch rebased to 0c0845c
Message-ID: <20150702123406.GZ22807@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6487150036701744255=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6487150036701744255==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

I just rebased the for-next branch of the xfsprogs repository here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

It has been rebased on top of the 3.2.3 release branch. THe commit
list below is the entirity of the for-next branch. It contains:

	- libxfs update to 4.1 kernel code
	- sparse inode support
	- cleanups to transaction commit interface
	- cleanups to remove unnecessary typedefs
	- build system changes to make include/xfs contain symlinks
	  to the source header files. Includes a new method of
	  installing headers to inlcude/xfs before dependency
	  generation is run.
	- standardisation of all the header include statements
	- an updated version of Eric's "libxfs sync" script in a
	  new tools/ directory.
	- various bug fixes.

It's a pretty big update:

 261 files changed, 11761 insertions(+), 9060 deletions(-)

But it does not contain anything to do with rmap btrees, reflink
btrees, the table based mkfs option rework, or any of the recently
posted changes (e.g. libdisk removal).

because we've got a lot of work starting to build up, I'd like to
get this current tree sorted and released sooner rather than later.
i.e. to be the basis of a 3.3 (4.x?) release to co-incide
with the release of the 4.2 kernel. That means we'd be releasing a
userspace that understands sparse inodes at the same time the kernel
releases. Before that, I'd like to:

	- update the libxfs code to match what was just merged into
	  the kernel for 4.2-rc1
	- pull in outstanding reviewed patches
	- merge for-next back into the master branch
	- tag the tree with a x.y-rc1 tag.

New work will then be staged in the for-next branch ready for
merging back to the master branch after the release of x.y, similar
to the cadence of the kernel cycle.

Does anyone have anything pending that should go in now? I can stage
bug fixes at almost any time, but I'm sure there are things I've
missed over the past week or two. So if you are sitting on patches
waiting for something to be done then make sure you ping me about
them...

Feel free to bikeshed about what the next version number should be.
I'm partial to making each release a x.y.0 release, reserving the z
version for unexpected updates needed to address urgent bug fixes.
And seeing as I'm trying to get the userspace development and
release cycle aligned with the kernel libxfs changes, I'm also
tempted to jump straight to a 4.2.0 release so that the xfsprogs
version matches the kernel version that shares the identical libxfs
code. Paint away!

-Dave.

The new head of the master branch is commit:

0c0845c Merge branch 'libxfs-commit-script' into for-next

New Commits:

Brian Foster (38):
      [214acbb] xfs: create individual inode alloc. helper
      [fa56ad5] xfs: update free inode record logic to support sparse inode=
 records
      [f4bc361] xfs: support min/max agbno args in block allocator
      [8fb67ff] xfs: add sparse inode chunk alignment superblock field
      [ac685e6] xfs: use sparse chunk alignment for min. inode allocation r=
equirement
      [370b674] xfs: sparse inode chunks feature helpers and mount requirem=
ents
      [2e1cf97] xfs: add fs geometry bit for sparse inode chunks
      [c21954f] xfs: introduce inode record hole mask for sparse inode chun=
ks
      [b291dee] xfs: pass inode count through ordered icreate log item
      [8dff44e] xfs: helper to convert holemask to inode alloc. bitmap
      [2f577ca] xfs: allocate sparse inode chunks on full chunk allocation =
failure
      [d9df7a0] xfs: randomly do sparse inode allocations in DEBUG mode
      [0a2eaa3] xfs: filter out sparse regions from individual inode alloca=
tion
      [a6b3ddb] xfs: only free allocated regions of inode chunks
      [9ad2424] xfs: skip unallocated regions of inode chunks in xfs_ifree_=
cluster()
      [d755348] xfs: enable sparse inode chunks for v5 superblocks
      [46141c7] mkfs: sparse inode chunk support
      [71bdfea] db: support sparse inode chunk inobt record and sb fields
      [0058e77] db: show sparse inodes feature state in version command out=
put
      [e471aa7] growfs: display sparse inode status from xfs_info
      [b63f41b] repair: handle sparse format inobt record freecount correct=
ly
      [f7d4028] repair: remove duplicate field from aghdr_cnts
      [d9a559b] repair: use ir_count for filesystems with sparse inode supp=
ort
      [87f617c] repair: scan and track sparse inode chunks correctly
      [170383b] repair: scan sparse finobt records correctly
      [9fa86a8] repair: validate ir_count field for sparse format records
      [f324686] repair: process sparse inode records correctly
      [37c2fcf] repair: factor out sparse inodes from finobt reconstruction
      [62531d7] repair: do not account sparse inodes in phase 5 cursor init.
      [a6bb9c8] repair: reconstruct sparse inode records correctly on disk
      [1da6831] repair: do not prefetch holes in sparse inode chunks
      [9f984cd] repair: handle sparse inode alignment
      [3fe33d9] metadump: reorder inode record sanity checks and inode buff=
er read
      [1e2689a] metadump: support sparse inode records
      [244e5b4] repair: access helpers for on-disk inobt record freecount
      [dbbc824] repair: helper for inode chunk alignment and start/end ino =
number verification
      [bb9a8c3] repair: helper to import on-disk inobt records to in-core t=
rees
      [25753aa] repair: helper to transition inode blocks to inode state

Christoph Hellwig (12):
      [010f294] libxfs: switch the remaining xfs_trans_dup user to xfs_tran=
s_roll
      [330efa1] libxfs: simplify xfs_trans_free_items
      [ea8a317] libxfs: remove the flags argument to xfs_trans_cancel
      [47918c2] xfs: saner xfs_trans_commit interface
      [5d99e84] xfsprogs: remove register keywords
      [27c2138] xfsprogs: remove __psint_t and __psunsigned_t
      [8401468] xfsprogs: remove the unused inst_t typedef
      [fd267f4] xfsprogs: remove the uint_t typedef
      [22abf77] xfsprogs: remove the uchar_t typedef
      [2f96337] xfsprogs: remove boolean_t typedef
      [de1ce66] xfsprogs: remove non-Linux defintions for loff_t
      [7b0f48b] xfsprogs: remove xfs_caddr_t

Dave Chinner (28):
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
      [c3dcf63] libxfs: add xfs_bit.c
      [c954da1] xfsprogs: build fails to find platform_defs.h
      [83d7c7d] build: populate include/xfs before building
      [18ffd96] libxfs-apply: CLI should specify source of commits
      [27b0276] libxfs-apply: allow commit range specification
      [50f69d1] libxfs-apply: reduce output verbosity
      [9e65dfe] libxfs-apply: auto-name patches for guilt
      [522c306] libxfs-apply: ensure guilt import retains commit messages
      [b8aa7ab] progs: clean up libxfs.h includes
      [18155c3] progs: clean up libxlog.h includes
      [71d5d40] progs: clean up all remaining xfs*h includes
      [11e314a] Merge branch 'libxfs-4.1-update' into for-next
      [3fd7344] Merge branch 'sparse-inodes' into for-next
      [d1726d3] Merge branch 'progs-misc-fixes-1' into for-next
      [fd27f6c] Merge branch 'progs-cleanup' into for-next
      [0c0845c] Merge branch 'libxfs-commit-script' into for-next

Eric Sandeen (13):
      [4407b13] libxfs: silence unused var warnings
      [8e72611] build: install PKGHFILES in install-dev
      [bb46491] libxlog: remove unused write-only var l_logsize
      [f0873ce] libxlog: add xlog_is_empty() helper
      [585043a] metadump: rename dont_obfuscate variable
      [ec693e1] metadump: zero out clean log
      [7080611] xfs_metadump: don't zero log if not obfuscating
      [aaf90a2] xfs_copy: fix copy of hard 4k devices
      [b0cda2f] mkfs.xfs: always use underlying fs sector size when mkfs'in=
g a file
      [66de82b] xfs_repair: refuse to unset lazycount on V5 filesystems
      [a5d34ab] xfs_repair: automatically enable -f (file) mode when needed
      [d21bcda] xfs_metadump: obfuscate remote symlinks on CRC filesystems
      [a902a3c] tools: libxfs kernel sync script

Mike Grant (1):
      [5c4532b] xfs_repair: include any realloc'ed buffers in final putbuf


Code Diffstat:

 Makefile                               |   21 +-
 configure.ac                           |    2 -
 copy/xfs_copy.c                        |   13 +-
 db/addr.c                              |    2 +-
 db/agf.c                               |    2 +-
 db/agfl.c                              |    2 +-
 db/agi.c                               |    2 +-
 db/attr.c                              |    4 +-
 db/attrset.c                           |    2 +-
 db/attrshort.c                         |    2 +-
 db/bit.c                               |   10 +-
 db/block.c                             |   18 +-
 db/bmap.c                              |   49 +-
 db/bmap.h                              |   12 +-
 db/bmroot.c                            |    6 +-
 db/btblock.c                           |   46 +-
 db/btblock.h                           |    3 +
 db/check.c                             |  253 +++---
 db/command.c                           |    2 +-
 db/convert.c                           |    2 +-
 db/debug.c                             |    2 +-
 db/dir2.c                              |   70 +-
 db/dir2sf.c                            |   10 +-
 db/dquot.c                             |    2 +-
 db/echo.c                              |    2 +-
 db/faddr.c                             |   74 +-
 db/field.c                             |   24 +-
 db/field.h                             |    8 +-
 db/flist.c                             |    2 +-
 db/fprint.c                            |    2 +-
 db/frag.c                              |   12 +-
 db/freesp.c                            |    2 +-
 db/hash.c                              |    4 +-
 db/help.c                              |    2 +-
 db/init.c                              |    6 +-
 db/inode.c                             |    3 +-
 db/input.c                             |    2 +-
 db/io.c                                |   14 +-
 db/malloc.c                            |    2 +-
 db/metadump.c                          |  259 ++++--
 db/output.c                            |    2 +-
 db/print.c                             |    2 +-
 db/quit.c                              |    2 +-
 db/sb.c                                |   59 +-
 db/sig.c                               |    2 +-
 db/strvec.c                            |    2 +-
 db/symlink.c                           |    2 +-
 db/text.c                              |    2 +-
 db/type.c                              |   42 +-
 db/type.h                              |    1 +
 db/write.c                             |    2 +-
 debian/rules                           |    3 +
 estimate/xfs_estimate.c                |    2 +-
 fsr/xfs_fsr.c                          |   13 +-
 growfs/xfs_growfs.c                    |   17 +-
 include/Makefile                       |   70 +-
 include/bitops.h                       |    6 +
 include/buildrules                     |   11 +-
 include/darwin.h                       |    6 -
 include/freebsd.h                      |    8 -
 include/gnukfreebsd.h                  |   10 +-
 include/input.h                        |    2 +-
 include/irix.h                         |   12 +-
 include/libxfs.h                       |  776 +++--------------
 include/libxlog.h                      |   19 +-
 include/linux.h                        |   11 -
 include/path.h                         |    2 +-
 include/platform_defs.h.in             |   46 +-
 include/project.h                      |    2 +-
 include/xfs.h                          |    6 +-
 include/xfs_ag.h                       |  279 ------
 include/xfs_arch.h                     |   18 -
 include/xfs_dinode.h                   |  243 ------
 include/xfs_dir2.h                     |  111 ---
 include/xfs_format.h                   |  454 ----------
 include/xfs_inode.h                    |  106 +++
 include/xfs_inum.h                     |   64 --
 include/xfs_mount.h                    |  149 ++++
 include/xfs_sb.h                       |  712 ---------------
 include/xfs_trace.h                    |   16 +-
 include/xfs_trans.h                    |  147 ++++
 include/xqm.h                          |    2 +-
 io/attr.c                              |    6 +-
 io/bmap.c                              |    4 +-
 io/fadvise.c                           |    6 +-
 io/fiemap.c                            |    4 +-
 io/file.c                              |    6 +-
 io/freeze.c                            |    6 +-
 io/fsync.c                             |    4 +-
 io/getrusage.c                         |    6 +-
 io/imap.c                              |    6 +-
 io/init.c                              |    6 +-
 io/inject.c                            |    6 +-
 io/link.c                              |    6 +-
 io/madvise.c                           |    6 +-
 io/mincore.c                           |    6 +-
 io/mmap.c                              |    6 +-
 io/open.c                              |    6 +-
 io/parent.c                            |   14 +-
 io/pread.c                             |    6 +-
 io/prealloc.c                          |    6 +-
 io/pwrite.c                            |    6 +-
 io/readdir.c                           |    6 +-
 io/resblks.c                           |    6 +-
 io/seek.c                              |    6 +-
 io/sendfile.c                          |    6 +-
 io/shutdown.c                          |    6 +-
 io/sync.c                              |    4 +-
 io/sync_file_range.c                   |    6 +-
 io/truncate.c                          |    6 +-
 libdisk/drivers.h                      |    2 +-
 libhandle/handle.c                     |    6 +-
 libhandle/jdm.c                        |   16 +-
 libxcmd/command.c                      |    6 +-
 libxcmd/help.c                         |    4 +-
 libxcmd/input.c                        |    4 +-
 libxcmd/paths.c                        |    6 +-
 libxcmd/projects.c                     |    2 +-
 libxcmd/quit.c                         |    4 +-
 libxfs/Makefile                        |   72 +-
 libxfs/cache.c                         |   15 +-
 libxfs/crc32.c                         |    4 +-
 libxfs/darwin.c                        |    6 +-
 libxfs/freebsd.c                       |    6 +-
 libxfs/init.c                          |   46 +-
 libxfs/irix.c                          |    6 +-
 libxfs/kmem.c                          |    2 +-
 libxfs/libxfs_api_defs.h               |  110 +++
 libxfs/libxfs_io.h                     |  236 +++++
 libxfs/{xfs.h =3D> libxfs_priv.h}        |  304 ++++---
 libxfs/linux.c                         |    4 +-
 libxfs/logitem.c                       |   12 +-
 libxfs/radix-tree.c                    |    2 +-
 libxfs/rdwr.c                          |   41 +-
 libxfs/trans.c                         |   65 +-
 libxfs/util.c                          |  136 ++-
 libxfs/xfs_alloc.c                     |  219 +++--
 {include =3D> libxfs}/xfs_alloc.h        |    6 +
 libxfs/xfs_alloc_btree.c               |   97 +--
 {include =3D> libxfs}/xfs_alloc_btree.h  |    0
 libxfs/xfs_attr.c                      |  479 +++++-----
 libxfs/xfs_attr_leaf.c                 |  463 ++++++----
 {include =3D> libxfs}/xfs_attr_leaf.h    |   11 +-
 libxfs/xfs_attr_remote.c               |  108 ++-
 {include =3D> libxfs}/xfs_attr_remote.h  |    0
 {include =3D> libxfs}/xfs_attr_sf.h      |    0
 libxfs/xfs_bit.c                       |  118 +++
 {include =3D> libxfs}/xfs_bit.h          |    7 +-
 libxfs/xfs_bmap.c                      | 1137 ++++++++++++++++++------
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
 libxfs/xfs_ialloc.c                    | 1104 +++++++++++++++++------
 {include =3D> libxfs}/xfs_ialloc.h       |   37 +-
 libxfs/xfs_ialloc_btree.c              |  191 ++--
 {include =3D> libxfs}/xfs_ialloc_btree.h |   10 +
 libxfs/xfs_inode_buf.c                 |   68 +-
 {include =3D> libxfs}/xfs_inode_buf.h    |    2 +
 libxfs/xfs_inode_fork.c                |   78 +-
 {include =3D> libxfs}/xfs_inode_fork.h   |    3 +-
 {include =3D> libxfs}/xfs_log_format.h   |    6 +-
 libxfs/xfs_log_rlimit.c                |   16 +-
 {include =3D> libxfs}/xfs_quota_defs.h   |    4 +-
 libxfs/xfs_rtbitmap.c                  |   69 +-
 libxfs/xfs_sb.c                        |  464 +++++-----
 libxfs/xfs_sb.h                        |   38 +
 {include =3D> libxfs}/xfs_shared.h       |   39 +-
 libxfs/xfs_symlink_remote.c            |   23 +-
 libxfs/xfs_trans_resv.c                |  164 ++--
 {include =3D> libxfs}/xfs_trans_resv.h   |    4 +-
 {include =3D> libxfs}/xfs_trans_space.h  |    7 +-
 {include =3D> libxfs}/xfs_types.h        |   29 +-
 libxlog/util.c                         |   59 +-
 libxlog/xfs_log_recover.c              |   44 +-
 logprint/log_copy.c                    |    2 +
 logprint/log_dump.c                    |    2 +
 logprint/log_misc.c                    |   42 +-
 logprint/log_print_all.c               |    6 +-
 logprint/log_print_trans.c             |    2 +
 logprint/logprint.c                    |    8 +-
 logprint/logprint.h                    |    2 -
 m4/package_types.m4                    |   28 -
 man/man8/mkfs.xfs.8                    |   17 +
 man/man8/xfs_admin.8                   |    4 +
 mdrestore/xfs_mdrestore.c              |    4 +-
 mkfs/fstyp.c                           |    2 +-
 mkfs/maxtrres.c                        |    5 +-
 mkfs/proto.c                           |   88 +-
 mkfs/xfs_mkfs.c                        |  158 ++--
 po/de.po                               |    8 +-
 po/pl.po                               |    8 +-
 quota/edit.c                           |    4 +-
 quota/free.c                           |    2 +-
 quota/init.c                           |    6 +-
 quota/path.c                           |    4 +-
 quota/project.c                        |    4 +-
 quota/quot.c                           |    2 +-
 quota/quota.c                          |    2 +-
 quota/quota.h                          |    6 +-
 quota/report.c                         |    2 +-
 quota/state.c                          |    2 +-
 repair/agheader.c                      |   45 +-
 repair/agheader.h                      |    8 +-
 repair/attr_repair.c                   |   76 +-
 repair/attr_repair.h                   |   33 -
 repair/avl.c                           |  144 +--
 repair/avl.h                           |   22 +-
 repair/avl64.c                         |  138 +--
 repair/avl64.h                         |    6 +-
 repair/bmap.c                          |   38 +-
 repair/bmap.h                          |   20 +-
 repair/btree.c                         |    2 +-
 repair/dino_chunks.c                   |  207 +++--
 repair/dinode.c                        |  183 ++--
 repair/dinode.h                        |   12 +-
 repair/dir2.c                          |  169 ++--
 repair/globals.c                       |    2 +-
 repair/globals.h                       |   14 -
 repair/incore.c                        |    8 +-
 repair/incore.h                        |   70 +-
 repair/incore_bmc.c                    |   12 +-
 repair/incore_ext.c                    |   30 +-
 repair/incore_ino.c                    |   11 +-
 repair/init.c                          |    2 +-
 repair/phase1.c                        |   10 +-
 repair/phase2.c                        |   63 +-
 repair/phase3.c                        |    2 +-
 repair/phase4.c                        |    8 +-
 repair/phase5.c                        |   72 +-
 repair/phase6.c                        |  386 ++++----
 repair/phase7.c                        |   19 +-
 repair/prefetch.c                      |   55 +-
 repair/progress.c                      |    2 +-
 repair/rt.c                            |   16 +-
 repair/sb.c                            |  133 +--
 repair/scan.c                          |  457 ++++++----
 repair/scan.h                          |   12 +-
 repair/threads.c                       |    2 +-
 repair/versions.c                      |   67 +-
 repair/versions.h                      |    1 -
 repair/xfs_repair.c                    |   22 +-
 rtcp/xfs_rtcp.c                        |    4 +-
 tools/libxfs-apply                     |  284 ++++++
 261 files changed, 11761 insertions(+), 9060 deletions(-)
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
 rename libxfs/{xfs.h =3D> libxfs_priv.h} (63%)
 rename {include =3D> libxfs}/xfs_alloc.h (96%)
 rename {include =3D> libxfs}/xfs_alloc_btree.h (100%)
 rename {include =3D> libxfs}/xfs_attr_leaf.h (91%)
 rename {include =3D> libxfs}/xfs_attr_remote.h (100%)
 rename {include =3D> libxfs}/xfs_attr_sf.h (100%)
 create mode 100644 libxfs/xfs_bit.c
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
 rename {include =3D> libxfs}/xfs_ialloc.h (87%)
 rename {include =3D> libxfs}/xfs_ialloc_btree.h (86%)
 rename {include =3D> libxfs}/xfs_inode_buf.h (95%)
 rename {include =3D> libxfs}/xfs_inode_fork.h (99%)
 rename {include =3D> libxfs}/xfs_log_format.h (99%)
 rename {include =3D> libxfs}/xfs_quota_defs.h (97%)
 create mode 100644 libxfs/xfs_sb.h
 rename {include =3D> libxfs}/xfs_shared.h (91%)
 rename {include =3D> libxfs}/xfs_trans_resv.h (97%)
 rename {include =3D> libxfs}/xfs_trans_space.h (95%)
 rename {include =3D> libxfs}/xfs_types.h (82%)
 create mode 100755 tools/libxfs-apply
--=20
Dave Chinner
david@fromorbit.com

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVlS++AAoJEK3oKUf0dfodHzcP/R/nwfcaeN226PIdNjueYAHZ
veNe1IbEIfSv8gxJQk0g/P9rpHUbjUblKaDRsfu6Ukm6IcGw0D/EwPkN/qoW5hzM
QJkfpOqwWv8qOmAncO5PoTMvcAwc9dqve/ptHqB1SNHQWW7AbSJVfCdya3VzeLRn
mpA/Gy9AHJpNHbwU38+ub76Y/E/JOgizOnoucTdpotovC+/OTNFeRuVjtF4I9Znw
XeZghgB1s/3kUru/TjcIoloH9BSJQCtrB9UO7Ex60w5toeBF5HO6TJ6tgfSoBXri
ihjYR8+dw/uJ7F2anRvC7ysD+um+e6BjevG1SRoojsEBR+NjXM4W9GcV47TAeqmd
gAOS2H7z2PRapKDiC6BO+nDeSgXTtAumu+lOhPSNJVECMcAy1qXm22rNXV0frgNV
8uL8cd64pDnpMzohDLyWJ6Qz1QIE+Im7Oj2pMLFxDGmKpevL6tQvp7z7z5mrljJf
uMzYbmo0t4dXYq58j8jzxLWaylIIfFilT2Hpd1uveCSzCK0nTcRxq+6wVXHtEOzw
pRKIVIMOcOAB9TmTrbTOCCugxkOY5BosgJsYSNwbuaDTNO8C5fvk7EO+Mfq+mTVS
+B1Du0YKaZv0C56lP6t3BiEtBLOziELPajRNPc3SN1SroAIELAPI81XeTdUvrgrF
Ne9OJgpJ99cqy1r62K2Z
=HTbT
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--


--===============6487150036701744255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6487150036701744255==--
