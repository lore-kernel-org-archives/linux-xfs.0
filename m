Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932237AbeBTAgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Feb 2018 19:36:36 -0500
Date: Mon, 19 Feb 2018 16:36:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfsprogs v4.15.0-rc1 released
Message-ID: <20180220003635.GA8479@infradead.org>
References: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

Btw, what do you think about enabling reflink support by default
in xfsprogs 4.15?  It's been stable in the kernel for a while,
and the only real on-disk format change is a couple additional
used/reserved blocks.

On Tue, Feb 13, 2018 at 02:29:00PM -0600, Eric Sandeen wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This is the first release candidate for v4.15.0, and it has
> the new experimental scrub utility as previously mentioned.
> 
> You can get the auto-generated tarball from:
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/snapshot/xfsprogs-dev-4.15.0-rc1.tar.gz
> 
> Other highlights; if you think something's missing here let me know:
> 
> xfsprogs-4.15.0-rc1 (13 Feb 2018)
>         - xfs_scrub: experimental new tool added (Darrick Wong)
>         - xfs_metadump: fix issues with -i flag (Marco Benatto)
>         - mkfs.xfs: don't allow creation of realtime+reflink (Darrick Wong)
>         - mkfs.xfs: don't crash on dswidth overflow (Darrick Wong)
>         - mkfs.xfs: much refactoring (Dave Chinner)
>         - xfs_copy: fix copy of v5 filesystems (Eric Sandeen)
>         - xfs_io: add a new 'log_writes' command (Ross Zwisler)
>         - xfs_io: add MAP_SYNC support to mmap() (Ross Zwisler)
>         - libxfs: memory zone handling cleanups (Eric Sandeen)
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next -rc or the next release cycle.
> 
> The new head of the master branch is commit:
> 
> a753d26 xfsprogs: Release v4.15.0-rc1
> 
> New Commits since v4.14.0, including all the libxfs sync bits:
> 
> Brian Foster (1):
>       [5963006] xfs: refactor buffer logging into buffer dirtying helper
> 
> Christoph Hellwig (67):
>       [0fcf377] xfs: fix incorrect extent state in xfs_bmap_add_extent_unwritten
>       [99a663c] xfs: use xfs_iext_get_extent instead of open coding it
>       [e9fa15a] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
>       [675b5a2] xfs: rename bno to end in __xfs_bunmapi
>       [ad68fd1] xfs: use xfs_bmap_del_extent_delay for the data fork as well
>       [bd92a38] xfs: move some more code into xfs_bmap_del_extent_real
>       [d0a03e5] xfs: use correct state defines in xfs_bmap_del_extent_{cow,delay
>       [b039ac7] xfs: use the state defines in xfs_bmap_del_extent_real
>       [70bf753] xfs: refactor xfs_del_extent_real
>       [450b398] xfs: refactor xfs_bmap_add_extent_hole_delay
>       [3281eb9] xfs: refactor xfs_bmap_add_extent_hole_real
>       [1988471] xfs: refactor xfs_bmap_add_extent_delay_real
>       [5bfca47] xfs: refactor delalloc accounting in xfs_bmap_add_extent_delay_r
>       [fd19685] xfs: refactor xfs_bmap_add_extent_unwritten_real
>       [d0e5f1f] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
>       [70a9311] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
>       [4f76f49] xfs: replace xfs_bmbt_lookup_ge with xfs_bmbt_lookup_first
>       [adddf4b] xfs: remove all xfs_bmbt_set_* helpers except for xfs_bmbt_set_a
>       [bb318cd] xfs: remove xfs_bmbt_get_state
>       [7bd4333] xfs: add a xfs_bmap_fork_to_state helper
>       [1a32da8] xfs: make better use of the 'state' variable in xfs_bmap_del_ext
>       [cfe299d] xfs: remove post-bmap tracing in xfs_bmap_local_to_extents
>       [df926c0] xfs: move pre/post-bmap tracing into xfs_iext_update_extent
>       [322fd80] xfs: remove XFS_BMAP_TRACE_EXLIST
>       [95817f5] xfs: remove the never fully implemented UUID fork format
>       [551174e] xfs: remove if_rdev
>       [6835c36] xfs: remove XFS_BMAP_MAX_SHIFT_EXTENTS
>       [a9f5d25] xfs: split xfs_bmap_shift_extents
>       [364937e] xfs: remove xfs_bmse_shift_one
>       [f36ccac] xfs: update got in xfs_bmap_shift_update_extent
>       [bac2049] xfs: don't rely on extent indices in xfs_bmap_collapse_extents
>       [bd80a80] xfs: don't rely on extent indices in xfs_bmap_insert_extents
>       [2d3a650] xfs: rewrite xfs_bmap_first_unused to make better use of xfs_iex
>       [6d79c95] xfs: merge xfs_bmap_read_extents into xfs_iread_extents
>       [d6fbe8f] xfs: add a new xfs_iext_lookup_extent_before helper
>       [4ed3a0f] xfs: remove the inode log format from the inode log item
>       [d29ce39] xfs: don't create overlapping extents in xfs_bmap_add_extent_del
>       [bc5dec5] xfs: remove a duplicate assignment in xfs_bmap_add_extent_delay_
>       [12ebbfe] xfs: treat idx as a cursor in xfs_bmap_add_extent_delay_real
>       [ee2bb3f] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_delay
>       [501dd27] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_real
>       [8121dd7] xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritten_real
>       [2844122] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
>       [c162e31] xfs: treat idx as a cursor in xfs_bmap_collapse_extents
>       [36d7c0a] xfs: pass an on-disk extent to xfs_bmbt_validate_extent
>       [f11e750] xfs: iterate over extents in xfs_iextents_copy
>       [62ed733] xfs: iterate over extents in xfs_bmap_extents_to_btree
>       [9788e05] xfs: introduce the xfs_iext_cursor abstraction
>       [8e87c88] xfs: simplify xfs_reflink_convert_cow
>       [07fe466] xfs: remove support for inlining data/extents into the inode for
>       [c2e6c70] xfs: allow unaligned extent records in xfs_bmbt_disk_set_all
>       [b37d753] xfs: use a b+tree for the in-core extent list
>       [26a75f6] xfs: remove the nr_extents argument to xfs_iext_insert
>       [cf455a6] xfs: remove the nr_extents argument to xfs_iext_remove
>       [080f0c7] xfs: pass struct xfs_bmbt_irec to xfs_bmbt_validate_extent
>       [5837f99] xfs: move xfs_bmbt_irec and xfs_exntst_t to xfs_types.h
>       [246486c] xfs: mark xfs_btree_check_lblock and xfs_btree_check_ptr static
>       [fd4c3ba] xfs: fix number of records handling in xfs_iext_split_leaf
>       [ba0bf2c] xfs: add some comments to xfs_iext_insert/xfs_iext_insert_node
>       [f3c6504] xfs: remove a superflous assignment in xfs_iext_remove_node
>       [c45b87c] xfs: trivial indentation fixup for xfs_iext_remove_node
>       [373c077] xfs: add comments documenting the rebalance algorithm
>       [546f383] xfs: handle zero entries case in xfs_iext_rebalance_leaf
>       [dc9b1f5] xfs: abstract out dev_t conversions
>       [c1a29e9] xfs: remove "no-allocation" reservations for file creations
>       [38d096b] xfs: remove wrappers around b_fspriv
>       [cfc06b6] xfs: add a proper transaction pointer to struct xfs_buf
> 
> Colin Ian King (1):
>       [d92c880] xfs: remove redundant assignment to variable bit
> 
> Darrick J. Wong (103):
>       [9bef625] xfs: create block pointer check functions
>       [d5c546d] xfs: refactor btree pointer checks
>       [b47beff] xfs: refactor btree block header checking functions
>       [be3bf25] xfs: create inode pointer verifiers
>       [afbe3b6] xfs: create an ioctl to scrub AG metadata
>       [d17a627] xfs: probe the scrub ioctl
>       [15c4e6e] xfs: scrub the shape of a metadata btree
>       [f253a97] xfs: scrub the secondary superblocks
>       [d6e1f78] xfs: scrub AGF and AGFL
>       [1770bca] xfs: scrub the AGI
>       [1b07bd7] xfs: scrub free space btrees
>       [3898cda] xfs: scrub inode btrees
>       [d21c412] xfs: scrub rmap btrees
>       [286f7cc] xfs: scrub refcount btrees
>       [1155b77] xfs: scrub inodes
>       [c123295] xfs: scrub inode block mappings
>       [16c101b] xfs: scrub directory metadata
>       [97ebbf2] xfs: scrub extended attributes
>       [3db552c] xfs: scrub symbolic links
>       [9d9d4f0] xfs: scrub directory parent pointers
>       [1da1b67] xfs: scrub realtime bitmap/summary
>       [821a975] xfs: scrub quota information
>       [9473ee3] xfs: abort dir/attr btree operation if btree is obviously weird
>       [0ad12e7] xfs: compare btree block keys to parent block's keys during scru
>       [e784bcd] xfs: remove inode log format typedef
>       [56d3fc2] xfs: move error injection tags into their own file
>       [52da310] xfs: remove u_int* type usage
>       [0484232] xfs: fix type usage
>       [904d971] xfs_io: pull xfs errortag definitions from libxfs
>       [813c67c] xfs_io: provide an interface to the scrub ioctls
>       [5591018] man: describe the metadata scrubbing ioctl
>       [5caa042] libfrog: move all the userspace support stuff into a new library
>       [24f4f99] libfrog: move libxfs_log2_roundup to libfrog
>       [1ca68d6] libfrog: add bit manipulation functions
>       [b28b84c] libfrog: move list_sort out of libxfs
>       [67f3faf] libfrog: promote avl64 code from xfs_repair
>       [f434fd9] libfrog: create a threaded workqueue
>       [695fc50] libfrog: move topology code out of libxcmd
>       [b95410d] libfrog: move conversion factors out of libxcmd
>       [bd987fe] libfrog: move paths.c out of libxcmd
>       [ce1abf9] libfrog: add missing function fs_table_destroy
>       [852fe01] libhandle: add missing destructor
>       [62843f3] xfs_repair: remove old workqueue stuff in favor of libfrog code
>       [31df6ad] xfs_db: print structure padding fields consistently
>       [70c1cce] xfs_db: add missing padding fields
>       [30a757b] libxfs: libxfs_nproc should never return negative numbers
>       [6f67c32] xfs: add the ability to join a held buffer to a defer_ops
>       [3fbc4d7] xfs: hold xfs_buf locked between shortform->leaf conversion and 
>       [db2cf1d] xfs: account for null transactions in bunmapi
>       [6428e6c] xfs: move xfs_iext_insert tracepoint to report useful informatio
>       [a44b23a] xfs: queue deferred rmap ops for cow staging extent alloc/free i
>       [3ee858a] xfs: always honor OWN_UNKNOWN rmap removal requests
>       [19f9a63] xfs: only skip rmap owner checks for unknown-owner rmap removal
>       [1ad4d3b] libhandle: zap fdhash in fshandle_destroy
>       [b638281] xfs_db: check should deal with cow staging extents correctly
>       [945e47e] xfs_db: fix crash when field list selector string has trailing s
>       [532d03d] xfs_repair: fix libxfs namespace problems
>       [128491c] find-api-violations: fix a broken grep pattern
>       [50663dc] xfsprogs: update dead urls
>       [ba795fb] xfs_db: interpret inode timestamps as signed integers
>       [25f9772] misc: ubsan fixes
>       [91c7d13] mkfs: don't crash on dswidth overflow
>       [0b1cf8b] mkfs: don't call values 'illegal', they're invalid
>       [7d25f65] mkfs: always explain why numeric inputs are invalid
>       [95b1e50] xfs_scrub: create online filesystem scrub program
>       [f0585fc] xfs_scrub: common error handling
>       [828105d] xfs_scrub: set up command line argument parsing
>       [173a028] xfs_scrub: dispatch the various phases of the scrub program
>       [e031d90] xfs_scrub: figure out how many threads we're going to need
>       [a555a1f] xfs_scrub: create an abstraction for a block device
>       [50a573a] xfs_scrub: find XFS filesystem geometry
>       [372d4ba] xfs_scrub: add inode iteration functions
>       [bc94c5d] xfs_scrub: add space map iteration functions
>       [c6eb0ff] xfs_scrub: add file space map iteration functions
>       [604dd33] xfs_scrub: filesystem counter collection functions
>       [fd7d73c] xfs_scrub: wrap the scrub ioctl
>       [e758ad0] xfs_scrub: scan filesystem and AG metadata
>       [d11cc69] xfs_scrub: thread-safe stats counter
>       [fa16b37] xfs_scrub: scan inodes
>       [c4892e7] xfs_scrub: check directory connectivity
>       [396cd02] xfs_scrub: warn about suspicious characters in directory/xattr n
>       [4bbed4e] xfs_scrub: warn about normalized Unicode name collisions
>       [0cf6f68] xfs_scrub: create a bitmap data structure
>       [2000470] xfs_scrub: create infrastructure to read verify data blocks
>       [b364a9c] xfs_scrub: scrub file data blocks
>       [03c0cd8] xfs_scrub: optionally use SCSI READ VERIFY commands to scrub dat
>       [698c6c7] xfs_scrub: check summary counters
>       [7e36bc0] xfs_scrub: fstrim the free areas if there are no errors on the f
>       [ed60d21] xfs_scrub: progress indicator
>       [f1dca11] xfs_scrub: create a script to scrub all xfs filesystems
>       [824b580] xfs_scrub: integrate services with systemd
>       [5c7826c] debian/control: remove nonexistent libreadline5-dev build depend
>       [1985247] xfs_scrub: wire up repair ioctl
>       [bfa66ec] mkfs: don't create realtime filesystems with reflink enabled
>       [e91c285] xfs_scrub: close dir_fd if we don't get a DIR pointer
>       [33a5034] xfs_scrub: kill dead code
>       [8041435] xfs_io: fix copy_file_range symbol name collision
>       [1658224] xfs_scrub: remove preen mode
>       [1df93c8] xfs_scrub: classify lack of ioctl support as a runtime error
>       [82377bd] xfs_scrub: reclassify runtime errors
>       [bb5dbd0] xfs_scrub: reclassify some of the warning messages
>       [2e4959c] xfs_scrub: always init phase information
>       [5454c2b] xfs_scrub: refactor outcome display into a separate helper
> 
> Dave Chinner (51):
>       [893d9af] xfs: convert remaining xfs_sb_version_... checks to bool
>       [41198ef] xfs_io: fix gcc-7 related printf warnings
>       [594932f] mkfs: disallow specifying the sector size of internal log
>       [05abf43] mkfs: make subopt table const
>       [cf627f3] mkfs: introduce a structure to hold CLI options
>       [a350bbc] mkfs: add generic subopt parsing table
>       [85d6f03] mkfs: factor block subopts parser
>       [a1273b7] mkfs: factor data subopts parser
>       [a3ac5af] mkfs: factor inode subopts parser
>       [f3bc91a] mkfs: factor log subopts parser
>       [997136c] mkfs: factor meta subopts parser
>       [98d4092] mkfs: factor naming subopts parser
>       [d145f69] mkfs: factor rt subopts parser
>       [f948f00] mkfs: factor sector subopts parser
>       [4ab08e3] mkfs: Introduce mkfs configuration structure
>       [d113804] mkfs: factor printing of mkfs config
>       [afda75a] mkfs: factor in memory superblock setup
>       [e99bf83] mkfs: factor out device preparation
>       [0ff1b0e] mkfs: factor writing AG headers
>       [e2847e5] mkfs: factor secondary superblock updates
>       [68344ba] mkfs: introduce default configuration structure
>       [ebed4ac] mkfs: rename top level CLI parameters
>       [585f41b] mkfs: factor sectorsize validation
>       [b1b8e54] mkfs: factor blocksize validation
>       [22319b5] mkfs: factor log sector size validation
>       [a43e656] mkfs: factor superblock feature validation
>       [fdea8fb] mkfs: factor directory blocksize validation
>       [8fe2902] mkfs: factor inode size validation
>       [e24dfa2] mkfs: factor out device size calculations
>       [7175103] mkfs: fix hidden parameter in DTOBT()
>       [80b154f] mkfs: factor rtdev extent size validation
>       [2f44b1b] mkfs: rework stripe calculations
>       [379f01d] mkfs: factor device opening
>       [dd5ac31] mkfs: factor data device validation
>       [90b7e13] mkfs: factor log device validation
>       [7a9af89] mkfs: factor rt device validation
>       [1de0144] mkfs: factor AG geometry calculations
>       [051b4e3] mkfs: factor AG alignment
>       [d7240c9] mkfs: rework imaxpct calculation
>       [befcd76] mkfs: factor initial mount setup
>       [e3bc839] mkfs: factor log size calculations
>       [b449c79] mkfs: cleanup redundant temporary code
>       [dafb318] mkfs: move error functions
>       [4eee66c] mkfs: tidy up definitions
>       [a9857ca] mkfs: use opts parameter during option parsing
>       [a6fb6ab] mkfs: simplify minimum log size calculation
>       [f1301cc] mkfs: protofile only needs to be set up once
>       [cedf1c4] mkfs: support arbitrary conflict specification
>       [64e924d] mkfs: convert subopt name, val pairs to enums and declared array
>       [6c75555] mkfs: resolve sector size CLI conflicts
>       [2cf637c] mkfs: remove logarithm based CLI options
> 
> Eric Sandeen (20):
>       [6e72e94] Merge branch 'libxfs-4.15-sync' into for-next
>       [fc60b66] xfs_io: add buf_lru_ref tag to inject table
>       [5c40ca1] xfs: fix leaks on corruption errors in xfs_bmap.c
>       [df90234] Merge branch 'libxfs-4.15-sync' into for-next
>       [b729d14] mkfs: Don't emit default config message yet
>       [ec64d06] mkfs: remove unused m_uuid in sb_feat_args
>       [639d0b0] mkfs: invert project id width boolean name
>       [852b325] mkfs: document sb_feat_args members
>       [129d98a] mkfs: remove use-once default macros
>       [c66bd30] mkfs: un-document removed logarithm based CLI options
>       [e5e612a] mkfs: pass switch case value directly into getnum/getstr
>       [9502da2] mkfs: do not allow both "dev" and "name" subopts for log or real
>       [2e2caf7] libxfs: remove unused buf_fsprivate3
>       [67d7227] libxfs: use a memory zone for transactions
>       [a1c5615] libxfs: use a memory zone for log items
>       [12f365e] xfs_logprint: fix v3 inode formatting
>       [d0ca5d8] xfs_copy: accept CRC version of ABTB_MAGIC in ASSERT
>       [16adcb8] mkfs: more sunit/swidth sanity checking
>       [ffdd272] xfs_scrub: handle scrub-only kernels more helpfully
>       [a753d26] xfsprogs: Release v4.15.0-rc1
> 
> Marco Benatto (2):
>       [720eec0] xfs_mdrestore: Add -i option to built-in help
>       [d789af7] xfs_mdrestore: Don't rewind source file stream
> 
> Nikolay Borisov (1):
>       [7c18973] xfs_io: implement ranged fiemap query
> 
> Ross Zwisler (2):
>       [dad7968] xfs_io: add MAP_SYNC support to mmap()
>       [851c5d1] xfs_io: add a new 'log_writes' command
> 
> Shu Wang (1):
>       [c822b63] xfs: fix memory leak in xfs_iext_free_last_leaf
> 
> 
> Code Diffstat:
> 
>  .gitignore                          |    5 +
>  Makefile                            |    9 +-
>  README                              |    2 +-
>  VERSION                             |    4 +-
>  configure.ac                        |   15 +-
>  copy/Makefile                       |    4 +-
>  copy/xfs_copy.c                     |    3 +-
>  db/Makefile                         |    4 +-
>  db/agi.c                            |    3 +-
>  db/attr.c                           |    2 +-
>  db/bit.c                            |    4 +-
>  db/check.c                          |   19 +-
>  db/dir2.c                           |    5 +-
>  db/dquot.c                          |    2 +-
>  db/flist.c                          |    1 +
>  db/fprint.c                         |    3 +-
>  db/inode.c                          |    2 +
>  debian/control                      |   10 +-
>  debian/copyright                    |    2 +-
>  debian/postinst                     |    3 +
>  debian/rules                        |    2 +-
>  debian/watch                        |    2 +-
>  doc/CHANGES                         |   11 +
>  growfs/Makefile                     |    4 +-
>  {repair => include}/avl64.h         |    0
>  include/bitops.h                    |   58 +
>  include/builddefs.in                |   16 +
>  include/convert.h                   |   37 +
>  include/handle.h                    |    2 +
>  include/input.h                     |   15 +-
>  include/libfrog.h                   |   23 +
>  include/libxfs.h                    |   21 +-
>  include/linux.h                     |    8 +
>  include/ptvar.h                     |   32 +
>  include/workqueue.h                 |   55 +
>  include/xfs.h                       |    4 +
>  include/xfs_inode.h                 |    1 +
>  include/xfs_multidisk.h             |    9 -
>  include/xfs_trace.h                 |    7 +-
>  include/xfs_trans.h                 |    2 +-
>  io/Makefile                         |   17 +-
>  io/copy_file_range.c                |   11 +-
>  io/fiemap.c                         |   81 +-
>  io/fsmap.c                          |    4 +-
>  io/init.c                           |    2 +
>  io/inject.c                         |   37 +-
>  io/io.h                             |    9 +
>  io/log_writes.c                     |  106 +
>  io/mmap.c                           |   29 +-
>  io/scrub.c                          |  252 ++
>  libfrog/Makefile                    |   39 +
>  {repair => libfrog}/avl64.c         |    4 +-
>  libfrog/convert.c                   |  384 +++
>  {libxfs => libfrog}/list_sort.c     |    7 +-
>  {libxcmd => libfrog}/paths.c        |   20 +
>  {libxcmd => libfrog}/projects.c     |    0
>  libfrog/ptvar.c                     |  133 +
>  {libxfs => libfrog}/radix-tree.c    |   26 +-
>  {libxcmd => libfrog}/topology.c     |    0
>  libfrog/util.c                      |   36 +
>  libfrog/workqueue.c                 |  174 ++
>  libhandle/handle.c                  |   14 +
>  libxcmd/Makefile                    |   10 +-
>  libxcmd/input.c                     |  375 ---
>  libxfs/Makefile                     |    4 +-
>  libxfs/init.c                       |   11 +-
>  libxfs/libxfs_api_defs.h            |    3 +-
>  libxfs/libxfs_io.h                  |   10 +-
>  libxfs/libxfs_priv.h                |   23 +
>  libxfs/logitem.c                    |   13 +-
>  libxfs/trans.c                      |  162 +-
>  libxfs/util.c                       |   45 +-
>  libxfs/xfs_ag_resv.c                |    1 +
>  libxfs/xfs_alloc.c                  |   54 +-
>  libxfs/xfs_alloc.h                  |    4 +
>  libxfs/xfs_attr.c                   |   20 +-
>  libxfs/xfs_attr_leaf.c              |   15 +-
>  libxfs/xfs_attr_leaf.h              |    3 +-
>  libxfs/xfs_bmap.c                   | 2065 ++++++--------
>  libxfs/xfs_bmap.h                   |   66 +-
>  libxfs/xfs_bmap_btree.c             |  250 +-
>  libxfs/xfs_bmap_btree.h             |   22 +-
>  libxfs/xfs_btree.c                  |  259 +-
>  libxfs/xfs_btree.h                  |   32 +-
>  libxfs/xfs_da_btree.c               |   22 +-
>  libxfs/xfs_defer.c                  |   39 +-
>  libxfs/xfs_defer.h                  |    5 +-
>  libxfs/xfs_dir2.c                   |   24 +-
>  libxfs/xfs_dir2.h                   |   17 +
>  libxfs/xfs_errortag.h               |  106 +
>  libxfs/xfs_format.h                 |   35 +-
>  libxfs/xfs_fs.h                     |   77 +
>  libxfs/xfs_ialloc.c                 |  101 +-
>  libxfs/xfs_ialloc.h                 |    8 +-
>  libxfs/xfs_iext_tree.c              | 1043 +++++++
>  libxfs/xfs_inode_buf.c              |    1 +
>  libxfs/xfs_inode_fork.c             | 1331 +--------
>  libxfs/xfs_inode_fork.h             |  138 +-
>  libxfs/xfs_log_format.h             |   24 +-
>  libxfs/xfs_refcount.c               |   53 +-
>  libxfs/xfs_rmap.c                   |  100 +-
>  libxfs/xfs_rmap.h                   |   16 +-
>  libxfs/xfs_rtbitmap.c               |   13 +-
>  libxfs/xfs_types.h                  |   22 +
>  libxlog/xfs_log_recover.c           |    4 +-
>  logprint/Makefile                   |    4 +-
>  logprint/log_misc.c                 |   17 +-
>  logprint/log_print_all.c            |    6 +-
>  logprint/logprint.h                 |    4 +-
>  m4/Makefile                         |    4 +
>  m4/package_attr.m4                  |   23 +
>  m4/package_devmapper.m4             |   11 +
>  m4/package_libcdev.m4               |   92 +
>  m4/package_services.m4              |   77 +
>  m4/package_unistring.m4             |   19 +
>  man/Makefile                        |    2 +-
>  man/man2/Makefile                   |   22 +
>  man/man2/ioctl_xfs_scrub_metadata.2 |  318 +++
>  man/man8/mkfs.xfs.8                 |   58 +-
>  man/man8/xfs_io.8                   |   51 +-
>  man/man8/xfs_scrub.8                |  142 +
>  man/man8/xfs_scrub_all.8            |   32 +
>  mdrestore/Makefile                  |    4 +-
>  mdrestore/xfs_mdrestore.c           |   70 +-
>  mkfs/Makefile                       |    7 +-
>  mkfs/maxtrres.c                     |  102 -
>  mkfs/xfs_mkfs.c                     | 5213 +++++++++++++++++++----------------
>  quota/Makefile                      |    4 +-
>  repair/Makefile                     |   10 +-
>  repair/dino_chunks.c                |    2 +-
>  repair/phase3.c                     |   16 +-
>  repair/phase4.c                     |   26 +-
>  repair/phase6.c                     |   16 +-
>  repair/phase7.c                     |    9 +-
>  repair/prefetch.c                   |   20 +-
>  repair/prefetch.h                   |    4 +-
>  repair/sb.c                         |    8 +-
>  repair/scan.c                       |   16 +-
>  repair/slab.c                       |    4 +-
>  repair/threads.c                    |  125 +-
>  repair/threads.h                    |   38 +-
>  scrub/Makefile                      |  142 +
>  scrub/bitmap.c                      |  410 +++
>  scrub/bitmap.h                      |   38 +
>  scrub/common.c                      |  391 +++
>  scrub/common.h                      |   92 +
>  scrub/counter.c                     |  104 +
>  scrub/counter.h                     |   29 +
>  scrub/disk.c                        |  315 +++
>  scrub/disk.h                        |   40 +
>  scrub/filemap.c                     |  157 ++
>  scrub/filemap.h                     |   39 +
>  scrub/fscounters.c                  |  212 ++
>  scrub/fscounters.h                  |   29 +
>  scrub/inodes.c                      |  297 ++
>  scrub/inodes.h                      |   32 +
>  scrub/phase1.c                      |  241 ++
>  scrub/phase2.c                      |  148 +
>  scrub/phase3.c                      |  169 ++
>  scrub/phase4.c                      |   77 +
>  scrub/phase5.c                      |  314 +++
>  scrub/phase6.c                      |  544 ++++
>  scrub/phase7.c                      |  266 ++
>  scrub/progress.c                    |  223 ++
>  scrub/progress.h                    |   33 +
>  scrub/read_verify.c                 |  270 ++
>  scrub/read_verify.h                 |   50 +
>  scrub/scrub.c                       |  782 ++++++
>  scrub/scrub.h                       |   82 +
>  scrub/spacemap.c                    |  256 ++
>  scrub/spacemap.h                    |   31 +
>  scrub/unicrash.c                    |  392 +++
>  scrub/unicrash.h                    |   47 +
>  scrub/vfs.c                         |  250 ++
>  scrub/vfs.h                         |   33 +
>  scrub/xfs_scrub.c                   |  756 +++++
>  scrub/xfs_scrub.h                   |  125 +
>  scrub/xfs_scrub@.service.in         |   20 +
>  scrub/xfs_scrub_all.cron.in         |    1 +
>  scrub/xfs_scrub_all.in              |  203 ++
>  scrub/xfs_scrub_all.service.in      |   10 +
>  scrub/xfs_scrub_all.timer           |   11 +
>  scrub/xfs_scrub_fail                |   26 +
>  scrub/xfs_scrub_fail@.service.in    |   10 +
>  spaceman/Makefile                   |    4 +-
>  tools/find-api-violations.sh        |    4 +-
>  186 files changed, 16170 insertions(+), 6533 deletions(-)
>  rename {repair => include}/avl64.h (100%)
>  create mode 100644 include/convert.h
>  create mode 100644 include/libfrog.h
>  create mode 100644 include/ptvar.h
>  create mode 100644 include/workqueue.h
>  create mode 100644 io/log_writes.c
>  create mode 100644 io/scrub.c
>  create mode 100644 libfrog/Makefile
>  rename {repair => libfrog}/avl64.c (99%)
>  create mode 100644 libfrog/convert.c
>  rename {libxfs => libfrog}/list_sort.c (98%)
>  rename {libxcmd => libfrog}/paths.c (97%)
>  rename {libxcmd => libfrog}/projects.c (100%)
>  create mode 100644 libfrog/ptvar.c
>  rename {libxfs => libfrog}/radix-tree.c (97%)
>  rename {libxcmd => libfrog}/topology.c (100%)
>  create mode 100644 libfrog/util.c
>  create mode 100644 libfrog/workqueue.c
>  create mode 100644 libxfs/xfs_errortag.h
>  create mode 100644 libxfs/xfs_iext_tree.c
>  create mode 100644 m4/package_attr.m4
>  create mode 100644 m4/package_devmapper.m4
>  create mode 100644 m4/package_services.m4
>  create mode 100644 m4/package_unistring.m4
>  create mode 100644 man/man2/Makefile
>  create mode 100644 man/man2/ioctl_xfs_scrub_metadata.2
>  create mode 100644 man/man8/xfs_scrub.8
>  create mode 100644 man/man8/xfs_scrub_all.8
>  delete mode 100644 mkfs/maxtrres.c
>  create mode 100644 scrub/Makefile
>  create mode 100644 scrub/bitmap.c
>  create mode 100644 scrub/bitmap.h
>  create mode 100644 scrub/common.c
>  create mode 100644 scrub/common.h
>  create mode 100644 scrub/counter.c
>  create mode 100644 scrub/counter.h
>  create mode 100644 scrub/disk.c
>  create mode 100644 scrub/disk.h
>  create mode 100644 scrub/filemap.c
>  create mode 100644 scrub/filemap.h
>  create mode 100644 scrub/fscounters.c
>  create mode 100644 scrub/fscounters.h
>  create mode 100644 scrub/inodes.c
>  create mode 100644 scrub/inodes.h
>  create mode 100644 scrub/phase1.c
>  create mode 100644 scrub/phase2.c
>  create mode 100644 scrub/phase3.c
>  create mode 100644 scrub/phase4.c
>  create mode 100644 scrub/phase5.c
>  create mode 100644 scrub/phase6.c
>  create mode 100644 scrub/phase7.c
>  create mode 100644 scrub/progress.c
>  create mode 100644 scrub/progress.h
>  create mode 100644 scrub/read_verify.c
>  create mode 100644 scrub/read_verify.h
>  create mode 100644 scrub/scrub.c
>  create mode 100644 scrub/scrub.h
>  create mode 100644 scrub/spacemap.c
>  create mode 100644 scrub/spacemap.h
>  create mode 100644 scrub/unicrash.c
>  create mode 100644 scrub/unicrash.h
>  create mode 100644 scrub/vfs.c
>  create mode 100644 scrub/vfs.h
>  create mode 100644 scrub/xfs_scrub.c
>  create mode 100644 scrub/xfs_scrub.h
>  create mode 100644 scrub/xfs_scrub@.service.in
>  create mode 100644 scrub/xfs_scrub_all.cron.in
>  create mode 100644 scrub/xfs_scrub_all.in
>  create mode 100644 scrub/xfs_scrub_all.service.in
>  create mode 100644 scrub/xfs_scrub_all.timer
>  create mode 100755 scrub/xfs_scrub_fail
>  create mode 100644 scrub/xfs_scrub_fail@.service.in
> 



---end quoted text---
