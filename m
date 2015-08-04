Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 12E597F5A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 19:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F3FF08F804B
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 17:23:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FvyyxbiHz6drd82b for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 17:23:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZMQ0a-0002LQ-9b
	for xfs@oss.sgi.com; Tue, 04 Aug 2015 10:23:08 +1000
Date: Tue, 4 Aug 2015 10:23:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: Release v4.2.0-rc1
Message-ID: <20150804002308.GX3902@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1656824362585138274=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1656824362585138274==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev=
=2Egit
has just been updated.

Both the master branch and the for-next branch have been updated
with all the pending work for a new release, and as such I've tagged
it as an -rc1 release point.

As nobody has commented on requests for bikeshedding about release
numbering to reflect the changes I want to make to release cycles
and libxfs updates, I've made an executive decision to make the
release reflect the version of the libxfs/ code in the source tree.
This means that major/minor release numbers will now follow the
kernel release numbers. As such, this commits us to a release
cadence similar to the kernel code and this release introduces
tools to help us keep the userspace libxfs code up to date with the
kernel changes.

Because I expect some reaction to this, I haven't pushed this update
to the "official" repository at git://oss.sgi.com/xfs/cmds/xfsprogs
so that if people violently disagree with the release numbering I
don't have to rebase the master branch there. I'll update this tree
when the release numbering is set in concrete.

There is a lot of change in this pre-release, and there are some
potential pending changes that may also make the final release:

	- more OS X build changes
	- fixes for debian ppc64el build issues
	- bug fixes for whatever issues are found in wider testing

And so speaking of testing, there are still a couple of issues I'm
seeing that I haven't yet resolved:

	- xfs/003 appears to randomly fail on 1k block size
	- xfs/053 is still failing

Any testing that people can do would be appreciated, whether it be
build testing (as there's plenty of build infrastructure changes in
this update) or runtime testing.

Keep in mind that if you update an existing repo you will need to do
a 'make realclean' first before trying to build the current tree,
otherwise it will throw errors all over the place. Similarly,if you
are jumping between a 3.2.4 and a 4.2.0-rc1 tree via checkouts, you
should do a make realclean before the checkout that changes the
version to ensure that the next build is clean.

The new head of the master branch is commit:

7d8b708 xfsprogs: Release v4.2.0-rc1

New Commits:

Brian Foster (40):
      [01792d3] xfs: create individual inode alloc. helper
      [f6580bc] xfs: update free inode record logic to support sparse inode=
 records
      [ff3263d] xfs: support min/max agbno args in block allocator
      [6bd8b7e] xfs: add sparse inode chunk alignment superblock field
      [62dc6cd] xfs: use sparse chunk alignment for min. inode allocation r=
equirement
      [7f5cd45] xfs: sparse inode chunks feature helpers and mount requirem=
ents
      [5f90a19] xfs: add fs geometry bit for sparse inode chunks
      [11640e3] xfs: introduce inode record hole mask for sparse inode chun=
ks
      [fe8d48a] xfs: pass inode count through ordered icreate log item
      [2cf8771] xfs: helper to convert holemask to inode alloc. bitmap
      [6f4c54a] xfs: allocate sparse inode chunks on full chunk allocation =
failure
      [c9005f4] xfs: randomly do sparse inode allocations in DEBUG mode
      [fa58183] xfs: filter out sparse regions from individual inode alloca=
tion
      [7338c4b] xfs: only free allocated regions of inode chunks
      [5a3b2e0] xfs: skip unallocated regions of inode chunks in xfs_ifree_=
cluster()
      [f895847] xfs: enable sparse inode chunks for v5 superblocks
      [6003fd8] mkfs: sparse inode chunk support
      [061e316] db: support sparse inode chunk inobt record and sb fields
      [b8db017] db: show sparse inodes feature state in version command out=
put
      [48b7e37] growfs: display sparse inode status from xfs_info
      [aa6ce1f] repair: handle sparse format inobt record freecount correct=
ly
      [37246b9] repair: remove duplicate field from aghdr_cnts
      [85ed3bc] repair: use ir_count for filesystems with sparse inode supp=
ort
      [c749bd5] repair: scan and track sparse inode chunks correctly
      [3f05cea] repair: scan sparse finobt records correctly
      [4a7d321] repair: validate ir_count field for sparse format records
      [3e62b2c] repair: process sparse inode records correctly
      [c77c41e] repair: factor out sparse inodes from finobt reconstruction
      [824b581] repair: do not account sparse inodes in phase 5 cursor init.
      [c9dae79] repair: reconstruct sparse inode records correctly on disk
      [870b18f] repair: do not prefetch holes in sparse inode chunks
      [90c9ac9] repair: handle sparse inode alignment
      [9180183] metadump: reorder inode record sanity checks and inode buff=
er read
      [04b21e4] metadump: support sparse inode records
      [ac9a3f7] repair: access helpers for on-disk inobt record freecount
      [2245818] repair: helper for inode chunk alignment and start/end ino =
number verification
      [411c5e5] repair: helper to import on-disk inobt records to in-core t=
rees
      [618ba57] repair: helper to transition inode blocks to inode state
      [23fc058] xfs: always log the inode on unwritten extent conversion
      [0d995d0] xfs: check min blks for random debug mode sparse allocations

Christoph Hellwig (23):
      [d262295] libxfs: switch the remaining xfs_trans_dup user to xfs_tran=
s_roll
      [7bcb840] libxfs: simplify xfs_trans_free_items
      [3d7434f] libxfs: remove the flags argument to xfs_trans_cancel
      [de5a3f4] xfs: saner xfs_trans_commit interface
      [0c2a7d4] xfsprogs: remove register keywords
      [ee6cd73] xfsprogs: remove __psint_t and __psunsigned_t
      [ccd6890] xfsprogs: remove the unused inst_t typedef
      [ca50065] xfsprogs: remove the uint_t typedef
      [0221169] xfsprogs: remove the uchar_t typedef
      [5d9edea] xfsprogs: remove boolean_t typedef
      [34a1c91] xfsprogs: remove non-Linux defintions for loff_t
      [d60ba95] xfsprogs: remove xfs_caddr_t
      [92acb89] xfs: return a void pointer from xfs_buf_offset
      [61e2fa7] xfsprogs: don't install internal header files
      [a2942ca] xfsprogs: remove unused macros from xfs_arch.h
      [cd36c33] xfsprogs: remove swab.h
      [77d9870] xfsprogs: only install *format.h headers in install-qa
      [5711848] xfsprogs: remove install-qa target
      [f8d9433] xfsprogs: use <>-style includes in installed headers
      [6b803e5] xfsprogs: simplify internal includes
      [1e6bc37] xfsprogs: move __be*/__le* types and __arch_pack to xfs_arc=
h.h
      [24842c5] xfsprogs: move __u*/__s* typedefs to per-port headers
      [dcabd4e] xfsprogs: don't install platform_defs.h

Dave Chinner (39):
      [f616e2b] libxfs: do all xfs->libxfs defines inside libxfs/
      [5f6f366] xfs: kill unsupported superblock versions
      [ff105f7] libxfs: update to 3.16 kernel code
      [af43ca9] xfs: return is not a function
      [1e68581] xfs: Nuke XFS_ERROR macro
      [12b5319] libxfs: error negation rework
      [636b4d9] libxfs: restructure to match kernel layout
      [5a35bf2] libxfs: update to match 3.19-rc1 kernel code
      [19ebedc] libxfs: update to 4.1-rc2 code base
      [b626fb5] libxfs: directly include libxfs headers
      [9c79982] libxfs: disambiguate xfs.h
      [e515cca] libxfs: split out xfs->libxfs mappings
      [4071f72] libxfs: add xfs_bit.c
      [cebd391] xfsprogs: build fails to find platform_defs.h
      [337d9a2] build: populate include/xfs before building
      [5bb5f5d] libxfs-apply: CLI should specify source of commits
      [b08338d] progs: clean up libxfs.h includes
      [8fa16d6] libxfs-apply: allow commit range specification
      [e708d0f] progs: clean up libxlog.h includes
      [0ee451f] libxfs-apply: reduce output verbosity
      [897853d] progs: clean up all remaining xfs*h includes
      [a580497] libxfs-apply: auto-name patches for guilt
      [db60c38] libxfs-apply: ensure guilt import retains commit messages
      [7cc23f0] xfs: extent size hints can round up extents past MAXEXTLEN
      [a37f46d] xfs: xfs_attr_inactive leaves inconsistent attr fork state =
behind
      [72bda06] xfs: xfs_alloc_fix_freelist() can use incore perag structur=
es
      [5515b7c] xfs: factor out free space extent length check
      [4f86468] Merge branch 'progs-misc-fixes-1' into for-next
      [c98e644] xfs: sanitise error handling in xfs_alloc_fix_freelist
      [de04664] xfs: clean up XFS_MIN_FREELIST macros
      [36afcc3] Merge branch 'libxfs-4.2-rc1-update' into for-next
      [d530478] Merge branch 'progs-cleanup' into for-next
      [03b2805] Merge branch 'libxfs-commit-script' into for-next
      [7af0c6c] build: create include/xfs before installing headers
      [641842c] Merge branch 'progs-header-cleanup' into for-next
      [f31982a] repair: use sb_meta_uuid for checking of metadata headers
      [299c038] libxfs: fix uuid check durign inode allocation
      [92592be] Merge branch 'progs-misc-fixes-2' into for-next
      [7d8b708] xfsprogs: Release v4.2.0-rc1

Eric Sandeen (11):
      [aefc06c] libxfs: silence unused var warnings
      [b75ef5e] build: install PKGHFILES in install-dev
      [ae51960] libxlog: remove unused write-only var l_logsize
      [c63ce10] xfs_copy: fix copy of hard 4k devices
      [20cec86] mkfs.xfs: always use underlying fs sector size when mkfs'in=
g a file
      [c40f279] xfs_repair: refuse to unset lazycount on V5 filesystems
      [76de6bb] xfs_repair: automatically enable -f (file) mode when needed
      [1f2d2b9] tools: libxfs kernel sync script
      [9c4e12f] xfsprogs: Add new sb_meta_uuid field, update userspace tool=
s to manipulate it
      [a1b2cb5] xfs_copy: fix up initial sb buffer read on CRC fs
      [8d8a27c] xfs_repair: Fix malloc size of rt_ext_tree_ptr

George Wang (1):
      [cbf3bea] xfs: use percpu_counter_read_positive for mp->m_icount

Jan Tulak (4):
      [2a3a494] xfsprogs: blkid is now mandatory
      [1473570] xfsprogs: Search path for utilities unified
      [dd30c0a] xfsprogs: Don't Make .po files with gettext disabled
      [5d87ed9] xfsprogs: Use glibtoolize on osx

Mike Grant (1):
      [90dd831] xfs_repair: include any realloc'ed buffers in final putbuf

Theodore Ts'o (5):
      [c9a9018] xfsprogs: define NBBY if not defined by the system header f=
iles
      [b9bc59c] xfsprogs: pull in libgen.h to get prototype for basename()
      [e14913c] xfsprogs: define and use BUILD_CC in configure.ac for cross=
 compilation
      [58d0d84] xfsprogs: avoid use of si_tid in struct xlog_split_item
      [919dbc7] xfsprogs: use "unsigned short" instead of ushort


Code Diffstat:

 Makefile                               |   48 +-
 VERSION                                |    4 +-
 configure.ac                           |   19 +-
 copy/xfs_copy.c                        |   65 +-
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
 db/metadump.c                          |  213 +++--
 db/output.c                            |    2 +-
 db/print.c                             |    2 +-
 db/quit.c                              |    2 +-
 db/sb.c                                |   87 +-
 db/sig.c                               |    2 +-
 db/strvec.c                            |    2 +-
 db/symlink.c                           |    2 +-
 db/text.c                              |    2 +-
 db/type.c                              |   42 +-
 db/type.h                              |    1 +
 db/write.c                             |    2 +-
 debian/rules                           |    6 +-
 doc/CHANGES                            |   14 +
 estimate/xfs_estimate.c                |    2 +-
 fsr/xfs_fsr.c                          |   13 +-
 growfs/xfs_growfs.c                    |   17 +-
 include/Makefile                       |   74 +-
 include/bitops.h                       |    6 +
 include/builddefs.in                   |    5 +-
 include/buildrules                     |   19 +-
 include/darwin.h                       |   15 +-
 include/dvh.h                          |  177 ----
 include/freebsd.h                      |   17 +-
 include/fstyp.h                        |   43 -
 include/gnukfreebsd.h                  |   18 +-
 include/input.h                        |    2 +-
 include/irix.h                         |   21 +-
 include/libxfs.h                       |  776 +++--------------
 include/libxlog.h                      |   17 +-
 include/linux.h                        |   13 +-
 include/path.h                         |    2 +-
 include/platform_defs.h.in             |  105 +--
 include/project.h                      |    3 +-
 include/swab.h                         |  194 -----
 include/volume.h                       |   52 --
 include/xfs.h                          |   28 +-
 include/xfs_ag.h                       |  279 ------
 include/xfs_arch.h                     |  280 ++++--
 include/xfs_dinode.h                   |  243 ------
 include/xfs_dir2.h                     |  111 ---
 include/xfs_format.h                   |  454 ----------
 include/xfs_inode.h                    |  106 +++
 include/xfs_inum.h                     |   64 --
 include/xfs_log_recover.h              |    2 +-
 include/xfs_mount.h                    |  149 ++++
 include/xfs_sb.h                       |  712 ---------------
 include/xfs_trace.h                    |   16 +-
 include/xfs_trans.h                    |  147 ++++
 io/attr.c                              |    5 +-
 io/bmap.c                              |    4 +-
 io/fadvise.c                           |    5 +-
 io/fiemap.c                            |    4 +-
 io/file.c                              |    5 +-
 io/freeze.c                            |    5 +-
 io/fsync.c                             |    4 +-
 io/getrusage.c                         |    5 +-
 io/imap.c                              |    5 +-
 io/init.c                              |    6 +-
 io/inject.c                            |    5 +-
 io/io.h                                |    2 +
 io/link.c                              |    5 +-
 io/madvise.c                           |    5 +-
 io/mincore.c                           |    5 +-
 io/mmap.c                              |    5 +-
 io/open.c                              |    5 +-
 io/parent.c                            |   13 +-
 io/pread.c                             |    5 +-
 io/prealloc.c                          |    5 +-
 io/pwrite.c                            |    5 +-
 io/readdir.c                           |    5 +-
 io/resblks.c                           |    5 +-
 io/seek.c                              |    5 +-
 io/sendfile.c                          |    5 +-
 io/shutdown.c                          |    5 +-
 io/sync.c                              |    4 +-
 io/sync_file_range.c                   |    5 +-
 io/truncate.c                          |    5 +-
 libdisk/Makefile                       |   37 -
 libdisk/dm.c                           |  112 ---
 libdisk/drivers.c                      |   82 --
 libdisk/drivers.h                      |   45 -
 libdisk/evms.c                         |   68 --
 libdisk/evms.h                         |   32 -
 libdisk/fstype.c                       |  442 ----------
 libdisk/fstype.h                       |  334 -------
 libdisk/lvm.c                          |  117 ---
 libdisk/md.c                           |  119 ---
 libdisk/md.h                           |   67 --
 libdisk/pttype.c                       |  118 ---
 libdisk/pttype.h                       |   50 --
 libdisk/xvm.c                          |   93 --
 libdisk/xvm.h                          |   53 --
 libhandle/Makefile                     |    2 -
 libhandle/handle.c                     |    7 +-
 libhandle/jdm.c                        |   17 +-
 libxcmd/Makefile                       |    2 +-
 libxcmd/command.c                      |    6 +-
 libxcmd/help.c                         |    4 +-
 libxcmd/input.c                        |    4 +-
 libxcmd/paths.c                        |    6 +-
 libxcmd/projects.c                     |    2 +-
 libxcmd/quit.c                         |    4 +-
 libxfs/Makefile                        |   71 +-
 libxfs/cache.c                         |   15 +-
 libxfs/crc32.c                         |    4 +-
 libxfs/darwin.c                        |    6 +-
 libxfs/freebsd.c                       |    6 +-
 libxfs/init.c                          |   46 +-
 libxfs/irix.c                          |    6 +-
 libxfs/kmem.c                          |    2 +-
 libxfs/libxfs_api_defs.h               |  110 +++
 libxfs/libxfs_io.h                     |  236 +++++
 libxfs/{xfs.h =3D> libxfs_priv.h}        |  305 ++++---
 libxfs/linux.c                         |    4 +-
 libxfs/logitem.c                       |   14 +-
 libxfs/radix-tree.c                    |    3 +-
 libxfs/rdwr.c                          |   41 +-
 libxfs/trans.c                         |   65 +-
 libxfs/util.c                          |  140 ++-
 libxfs/xfs_alloc.c                     |  462 ++++++----
 {include =3D> libxfs}/xfs_alloc.h        |   14 +-
 libxfs/xfs_alloc_btree.c               |  101 +--
 {include =3D> libxfs}/xfs_alloc_btree.h  |    0
 libxfs/xfs_attr.c                      |  479 +++++-----
 libxfs/xfs_attr_leaf.c                 |  475 ++++++----
 {include =3D> libxfs}/xfs_attr_leaf.h    |   13 +-
 libxfs/xfs_attr_remote.c               |  112 ++-
 {include =3D> libxfs}/xfs_attr_remote.h  |    0
 {include =3D> libxfs}/xfs_attr_sf.h      |    0
 libxfs/xfs_bit.c                       |  118 +++
 {include =3D> libxfs}/xfs_bit.h          |    7 +-
 libxfs/xfs_bmap.c                      | 1179 +++++++++++++++++++------
 {include =3D> libxfs}/xfs_bmap.h         |   69 +-
 libxfs/xfs_bmap_btree.c                |  228 +----
 {include =3D> libxfs}/xfs_bmap_btree.h   |    2 +-
 libxfs/xfs_btree.c                     |  231 +++--
 {include =3D> libxfs}/xfs_btree.h        |   67 +-
 {include =3D> libxfs}/xfs_cksum.h        |    0
 libxfs/xfs_da_btree.c                  |  513 +++++------
 {include =3D> libxfs}/xfs_da_btree.h     |   29 +-
 libxfs/xfs_da_format.c                 |  908 +++++++++++++++++++
 {include =3D> libxfs}/xfs_da_format.h    |  514 +----------
 libxfs/xfs_dir2.c                      |  502 ++++++-----
 libxfs/xfs_dir2.h                      |  323 +++++++
 libxfs/xfs_dir2_block.c                |  205 ++---
 libxfs/xfs_dir2_data.c                 |  275 +++---
 libxfs/xfs_dir2_leaf.c                 |  436 +++++-----
 libxfs/xfs_dir2_node.c                 |  509 +++++------
 libxfs/xfs_dir2_priv.h                 |   30 +-
 libxfs/xfs_dir2_sf.c                   |  394 +++------
 libxfs/xfs_dquot_buf.c                 |   47 +-
 libxfs/xfs_format.h                    | 1501 ++++++++++++++++++++++++++++=
++++
 {include =3D> libxfs}/xfs_fs.h           |    9 +-
 libxfs/xfs_ialloc.c                    | 1117 ++++++++++++++++++------
 {include =3D> libxfs}/xfs_ialloc.h       |   40 +-
 libxfs/xfs_ialloc_btree.c              |  193 ++--
 {include =3D> libxfs}/xfs_ialloc_btree.h |   10 +
 libxfs/xfs_inode_buf.c                 |   78 +-
 {include =3D> libxfs}/xfs_inode_buf.h    |    6 +-
 libxfs/xfs_inode_fork.c                |   78 +-
 {include =3D> libxfs}/xfs_inode_fork.h   |    3 +-
 {include =3D> libxfs}/xfs_log_format.h   |   10 +-
 libxfs/xfs_log_rlimit.c                |   16 +-
 {include =3D> libxfs}/xfs_quota_defs.h   |    4 +-
 libxfs/xfs_rtbitmap.c                  |   69 +-
 libxfs/xfs_sb.c                        |  474 +++++-----
 libxfs/xfs_sb.h                        |   38 +
 {include =3D> libxfs}/xfs_shared.h       |   39 +-
 libxfs/xfs_symlink_remote.c            |   27 +-
 libxfs/xfs_trans_resv.c                |  164 ++--
 {include =3D> libxfs}/xfs_trans_resv.h   |    8 +-
 {include =3D> libxfs}/xfs_trans_space.h  |    9 +-
 {include =3D> libxfs}/xfs_types.h        |   29 +-
 libxlog/Makefile                       |    2 +-
 libxlog/util.c                         |    9 +-
 libxlog/xfs_log_recover.c              |   44 +-
 logprint/log_copy.c                    |    2 +
 logprint/log_dump.c                    |    2 +
 logprint/log_misc.c                    |   50 +-
 logprint/log_print_all.c               |    6 +-
 logprint/log_print_trans.c             |    2 +
 logprint/logprint.c                    |    8 +-
 logprint/logprint.h                    |    2 -
 m4/package_blkid.m4                    |   20 +-
 m4/package_types.m4                    |   41 -
 m4/package_utilies.m4                  |   19 +-
 man/man8/mkfs.xfs.8                    |   17 +
 man/man8/xfs_admin.8                   |   11 +-
 man/man8/xfs_db.8                      |    9 +-
 mdrestore/xfs_mdrestore.c              |    4 +-
 mkfs/Makefile                          |   22 +-
 mkfs/fstyp.c                           |   59 --
 mkfs/maxtrres.c                        |    5 +-
 mkfs/proto.c                           |   88 +-
 mkfs/xfs_mkfs.c                        |  220 ++---
 po/de.po                               |   59 +-
 po/pl.po                               |   57 +-
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
 repair/agheader.c                      |   64 +-
 repair/agheader.h                      |    9 +-
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
 repair/dinode.c                        |  190 ++--
 repair/dinode.h                        |   12 +-
 repair/dir2.c                          |  169 ++--
 repair/globals.c                       |    2 +-
 repair/globals.h                       |   14 -
 repair/incore.c                        |    8 +-
 repair/incore.h                        |   70 +-
 repair/incore_bmc.c                    |   12 +-
 repair/incore_ext.c                    |   32 +-
 repair/incore_ino.c                    |   11 +-
 repair/init.c                          |    2 +-
 repair/phase1.c                        |   10 +-
 repair/phase2.c                        |    4 +-
 repair/phase3.c                        |    2 +-
 repair/phase4.c                        |    8 +-
 repair/phase5.c                        |   81 +-
 repair/phase6.c                        |  394 +++++----
 repair/phase7.c                        |   19 +-
 repair/prefetch.c                      |   55 +-
 repair/progress.c                      |    2 +-
 repair/rt.c                            |   16 +-
 repair/sb.c                            |  133 +--
 repair/scan.c                          |  459 ++++++----
 repair/scan.h                          |   12 +-
 repair/threads.c                       |    2 +-
 repair/versions.c                      |   67 +-
 repair/versions.h                      |    1 -
 repair/xfs_repair.c                    |   29 +-
 rtcp/xfs_rtcp.c                        |    4 +-
 tools/libxfs-apply                     |  284 ++++++
 290 files changed, 12324 insertions(+), 11896 deletions(-)
 delete mode 100644 include/dvh.h
 delete mode 100644 include/fstyp.h
 delete mode 100644 include/swab.h
 delete mode 100644 include/volume.h
 delete mode 100644 include/xfs_ag.h
 delete mode 100644 include/xfs_dinode.h
 delete mode 100644 include/xfs_dir2.h
 delete mode 100644 include/xfs_format.h
 create mode 100644 include/xfs_inode.h
 delete mode 100644 include/xfs_inum.h
 create mode 100644 include/xfs_mount.h
 delete mode 100644 include/xfs_sb.h
 create mode 100644 include/xfs_trans.h
 delete mode 100644 libdisk/Makefile
 delete mode 100644 libdisk/dm.c
 delete mode 100644 libdisk/drivers.c
 delete mode 100644 libdisk/drivers.h
 delete mode 100644 libdisk/evms.c
 delete mode 100644 libdisk/evms.h
 delete mode 100644 libdisk/fstype.c
 delete mode 100644 libdisk/fstype.h
 delete mode 100644 libdisk/lvm.c
 delete mode 100644 libdisk/md.c
 delete mode 100644 libdisk/md.h
 delete mode 100644 libdisk/pttype.c
 delete mode 100644 libdisk/pttype.h
 delete mode 100644 libdisk/xvm.c
 delete mode 100644 libdisk/xvm.h
 create mode 100644 libxfs/libxfs_api_defs.h
 create mode 100644 libxfs/libxfs_io.h
 rename libxfs/{xfs.h =3D> libxfs_priv.h} (63%)
 rename {include =3D> libxfs}/xfs_alloc.h (94%)
 rename {include =3D> libxfs}/xfs_alloc_btree.h (100%)
 rename {include =3D> libxfs}/xfs_attr_leaf.h (90%)
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
 rename {include =3D> libxfs}/xfs_ialloc.h (86%)
 rename {include =3D> libxfs}/xfs_ialloc_btree.h (86%)
 rename {include =3D> libxfs}/xfs_inode_buf.h (88%)
 rename {include =3D> libxfs}/xfs_inode_fork.h (99%)
 rename {include =3D> libxfs}/xfs_log_format.h (99%)
 rename {include =3D> libxfs}/xfs_quota_defs.h (97%)
 create mode 100644 libxfs/xfs_sb.h
 rename {include =3D> libxfs}/xfs_shared.h (91%)
 rename {include =3D> libxfs}/xfs_trans_resv.h (94%)
 rename {include =3D> libxfs}/xfs_trans_space.h (94%)
 rename {include =3D> libxfs}/xfs_types.h (82%)
 delete mode 100644 mkfs/fstyp.c
 create mode 100755 tools/libxfs-apply
--=20
Dave Chinner
david@fromorbit.com

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVwAXrAAoJEK3oKUf0dfod+TwP/A1VOVzkaxQxFZW/ohz5T0kM
Nrpa5lpJYnT/ifTB+MGqzhgKxXKoUdxbsc6kf+i8Vt2lsJPR4bg51HSJJyZ5WcSH
r8bmbS/Pu1KKkK8/2HXwkmzBpQLmOlsAmUPWnL3PE3tG8FmxGUnAMLcjbdW1sR6d
siOWpLUoOkRBqPabuSonDW+uSUDXYZfpVPE7p1ldt8533KQ2SK5wmTcwy+KgiGFO
+KRZlz6Z7wwabpYxwiOs2E9+Wr+xLd6wiDqWJDlxQBO1UqiFZbDQSXNGko4leW+S
gwi3CyJ/2y+QO9rAQjDN1HWMDeDTGXMT8DpoVfOlMZ/Ic6vZtF3A9L/WPoZyG6sn
Tqs++ZL9b6kxaU1LV1obeckF1q1WalxZNuR0PeBW13PEV3DHUR0KXaraa/lSWC5Q
QEbzRlK+Yn08fHlJDxPBoTGiZSs8uxMrrNgwQV0azrB6Ry/Pdqw+C1GpktIqebFY
RrA+bztIC8zrivOH/PaQrdVEk+XkMTPcDITo+K+q0w8VQaQoxtCcMTC863vPSuJf
ZQEUNKO5NBABqcBhWDXxeVJf+xPxNcOikWQiRKqv6psKp36UimPNVxr3W6D3pSWf
/h/HSQf51sXdoJY794LnutWn+eWKwkgx/8u8E2l825uz1tLgGoUFKI10b9Mq3rmn
MA38izdGeizdJWbIlp/S
=RRBU
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--


--===============1656824362585138274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1656824362585138274==--
