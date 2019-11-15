Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D26C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 17:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4206F20732
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 17:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfKORwZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 12:52:25 -0500
Received: from sandeen.net ([63.231.237.45]:52994 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfKORwZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Nov 2019 12:52:25 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2B55AF8AD1
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 11:51:02 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.3.0 released
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <61517628-9afd-6976-8997-deb47fa9e092@sandeen.net>
Date:   Fri, 15 Nov 2019 11:52:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="udlKoWDhY5AEkvWS8YDZmNroPCNCO8P8R"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--udlKoWDhY5AEkvWS8YDZmNroPCNCO8P8R
Content-Type: multipart/mixed; boundary="Gb3620lkhrP2oDdPcBcgQYLYrSKamdrOg"

--Gb3620lkhrP2oDdPcBcgQYLYrSKamdrOg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.3.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.3.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.3.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.3.0.tar=
=2Esign

Thanks,
-Eric

The new head of the master branch is commit:

1609c11a (HEAD -> master, tag: v5.3.0, origin/master, origin/for-next, ko=
rg/master, korg/for-next) xfsprogs: Release v5.3.0

Condensed changelog:

xfsprogs-5.3.0 (15 Nov 2019)
        - No further changes

xfsprogs-5.3.0-rc2 (07 Nov 2019)
        - mkfs.xfs: use libxfs to write out AGs vs. open-coding (Darrick =
Wong)
        - mkfs.xfs: fix incorrect error message during AG init (Darrick W=
ong)
        - xfs_repair: better info when metadata updates fail (Darrick Won=
g)
        - xfs_growfs: allow mounted device node as argument (Eric Sandeen=
)
        - xfs_spaceman: always report sick metadata (Darrick Wong)
        - xfs_io: add a bulkstat command (Darrick Wong)
        - xfs_io: encrypt command enhancements (Eric Biggers)
        - xfs_io: expose FS_XFLAG_HASATTR flag (Amir Goldstein)
        - xfs_io: copy_file_range fixes (Jianhong Yin)
        - man: document several new ioctls (Darrick Wong)
        - xfs_scrub: copious rewriting (Darrick Wong)
        - libfrog: header moves, refactoring, updates (Darrick Wong)
        - libxfs: fix buffer refcounting (Darrick Wong)

xfsprogs-5.3.0-rc1 (28 Aug 2019)
        - rebase 5.3 branch on top of 5.2.1

xfsprogs-5.3.0-rc0 (16 Aug 2019)
        - libxfs changes merged from kernel 5.3

xfsprogs-5.2.1 (21 Aug 2019)
        - fix geometry calls for kernels older than 5.2 (Eric Sandeen)

New Commits since v5.2.0:

Amir Goldstein (1):
      [89f0bc44] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag

Brian Foster (4):
      [c971cb6a] xfs: clean up small allocation helper
      [ba02381c] xfs: move small allocation helper
      [9e1862f0] xfs: skip small alloc cntbt logic on NULL cursor
      [2d7ea81f] xfs: always update params on small allocation

Christoph Hellwig (2):
      [7861ef77] xfs: add struct xfs_mount pointer to struct xfs_buf
      [a36b2201] xfs: remove XFS_TRANS_NOFS

Darrick J. Wong (158):
      [e7fd2b6f] xfs: separate inode geometry
      [3a05ab22] xfs: refactor inode geometry setup routines
      [f8780726] xfs: fix inode_cluster_size rounding mayhem
      [4b0fd0f4] xfs: finish converting to inodes_per_cluster
      [27846843] xfs: move xfs_ino_geometry to xfs_shared.h
      [9c34b021] xfs: refactor free space btree record initialization
      [db817aed] xfs: account for log space when formatting new AGs
      [4a509d6d] xfs: create iterator error codes
      [2af937c0] xfs: create simplified inode walk function
      [b46789e2] xfs: remove various bulk request typedef usage
      [79671ab5] xfs: introduce new v5 bulkstat structure
      [9d9b8f75] xfs: introduce v5 inode group structure
      [9826f6b8] xfs: wire up new v5 bulkstat ioctls
      [cb3dc141] xfs: wire up the v5 inumbers ioctl
      [cbab59a7] xfs: specify AG in bulk req
      [bfcd754e] xfs: allow single bulkstat of special inodes
      [7a0f3e61] xfs: attribute scrub should use seen_enough to pass erro=
r values
      [ffab1122] xfs: remove more ondisk directory corruption asserts
      [3f7f9ac2] xfs: don't crash on null attr fork xfs_bmapi_read
      [c7498b69] xfsprogs: update spdx tags in LICENSES/
      [9612817d] libfrog: refactor online geometry queries
      [3f9efb2e] libfrog: introduce xfs_fd to wrap an fd to a file on an =
xfs filesystem
      [5b5c7336] libfrog: store more inode and block geometry in struct x=
fs_fd
      [a749451c] libfrog: create online fs geometry converters
      [f31b5e12] libfrog: refactor open-coded bulkstat calls
      [248af7cb] libfrog: create xfd_open function
      [621f3374] libfrog: refactor open-coded INUMBERS calls
      [7478c2e3] libxfs: move topology declarations into separate header
      [b4a09f89] libfrog: move avl64.h to libfrog/
      [a58400ed] libfrog: move bitmap.h to libfrog/
      [25e98e81] libfrog: move convert.h to libfrog/
      [fee68490] libfrog: move fsgeom.h to libfrog/
      [14051909] libfrog: move ptvar.h to libfrog/
      [8bf7924e] libfrog: move radix-tree.h to libfrog/
      [56598728] libfrog: move workqueue.h to libfrog/
      [63153a95] libfrog: move crc32c.h to libfrog/
      [42b4c8e8] libfrog: move path.h to libfrog/
      [59f1f2a6] libfrog: move workqueue.h to libfrog/
      [660b5d96] libfrog: move libfrog.h to libfrog/util.h
      [10cfd61e] xfs_spaceman: remove typedef usage
      [8990666e] xfs_spaceman: remove unnecessary test in openfile()
      [a509ad57] xfs_spaceman: embed struct xfs_fd in struct fileio
      [b3803ff1] xfs_spaceman: convert open-coded unit conversions to hel=
pers
      [30abbc26] man: document the new v5 fs geometry ioctl structures
      [88537f07] man: document new fs summary counter scrub command
      [e2fd97fc] man: document the new allocation group geometry ioctl
      [666b4f18] man: document the new health reporting fields in various=
 ioctls
      [3491bee4] xfs_db: remove db/convert.h
      [cb1e69c5] xfs_db: add a function to compute btree geometry
      [f28e184b] xfs_db: use precomputed inode geometry values
      [41baceb7] xfs_repair: use precomputed inode geometry values
      [904a5020] xfs_repair: reduce the amount of "clearing reflink flag"=
 messages
      [ac8b6c38] xfs_repair: add AG btree rmaps into the filesystem after=
 syncing sb
      [bb85ae74] xfs_spaceman: report health problems
      [991e5a84] xfs_scrub: remove unnecessary fd parameter from file scr=
ubbers
      [5ef3b66a] libfrog: share scrub headers
      [8dd3922c] libfrog: add online scrub/repair for superblock counters=

      [469f76cb] xfs_scrub: separate internal metadata scrub functions
      [cbaf1c9d] xfs_scrub: check summary counters
      [83630b7f] xfs_scrub: refactor queueing of subdir scan work item
      [4953e709] xfs_scrub: fix nr_dirs accounting problems
      [44012ab0] xfs_scrub: remove unnecessary wakeup wait in scan_fs_tre=
e
      [cad15696] libxfs: fix uncached buffer refcounting
      [3d943e22] libxfs: fix buffer refcounting in delwri_queue
      [7db2e3c1] libxfs: make xfs_buf_delwri_submit actually do something=

      [7b754805] mkfs: use libxfs to write out new AGs
      [04fa6912] man: add documentation for v5 bulkstat ioctl
      [085b39cc] man: add documentation for v5 inumbers ioctl
      [4cca629d] misc: convert xfrog_bulkstat functions to have v5 semant=
ics
      [b94a69ac] misc: convert from XFS_IOC_FSINUMBERS to XFS_IOC_INUMBER=
S
      [3c8276c4] xfs_io: add a bulkstat command
      [1ff6be86] xfs_spaceman: remove open-coded per-ag bulkstat
      [23ea9841] xfs_scrub: convert to per-ag inode bulkstat operations
      [6040b5d5] xfs_scrub: batch inumbers calls during fscounters calcul=
ation
      [9d57cbfc] libfrog: fix workqueue error communication problems
      [bfd9b38b] libfrog: fix missing error checking in workqueue code
      [71296cf8] libfrog: split workqueue destroy functions
      [7668d01d] xfs_scrub: redistribute read verify pool flush and destr=
oy responsibilities
      [cb321a39] libfrog: fix per-thread variable error communication pro=
blems
      [336c4824] libfrog: add missing per-thread variable error handling
      [233fabee] libfrog: fix bitmap error communication problems
      [d504cf0b] libfrog: fix missing error checking in bitmap code
      [da3dd6c0] xfs_scrub: fix per-thread counter error communication pr=
oblems
      [0a9ac205] xfs_scrub: report all progressbar creation failures
      [8808a003] xfs_scrub: check progress bar timedwait failures
      [f0bbbd72] xfs_scrub: move all the queue_subdir error reporting to =
callers
      [499c104f] xfs_scrub: fix error handling problems in vfs.c
      [5c657f1e] xfs_scrub: fix handling of read-verify pool runtime erro=
rs
      [4cd869e5] xfs_scrub: abort all read verification work immediately =
on error
      [8cab77d3] xfs_scrub: fix read-verify pool error communication prob=
lems
      [601ebcd8] xfs_scrub: fix queue-and-stash of non-contiguous verify =
requests
      [22d658ec] xfs_scrub: only call read_verify_force_io once per pool
      [15589f0a] xfs_scrub: refactor inode prefix rendering code
      [20e10ad4] xfs_scrub: record disk LBA size
      [29c4f385] xfs_scrub: enforce read verify pool minimum io size
      [323ef14c] xfs_scrub: return bytes verified from a SCSI VERIFY comm=
and
      [27464242] xfs_scrub: fix read verify disk error handling strategy
      [cac2b8b0] xfs_scrub: simulate errors in the read-verify phase
      [d9b8ae44] xfs_spaceman: always report sick metadata, checked or no=
t
      [4546e66d] xfs_db: btheight should check geometry more carefully
      [ca427fe8] xfs_scrub: report repair activities on stdout, not stder=
r
      [b8302b7f] xfs_scrub: don't allow zero or negative error injection =
interval
      [a57cc320] libfrog: fix workqueue_add error out
      [af06261f] xfs_repair: print better information when metadata updat=
es fail
      [eb20c4ca] libxfs: fix typo in message about write verifier
      [5770b2f0] mkfs: fix incorrect error message
      [aeff0641] libfrog/xfs_scrub: improve iteration function documentat=
ion
      [663e02a0] xfs_scrub: separate media error reporting for attribute =
forks
      [ed953d26] xfs_scrub: improve reporting of file data media errors
      [f1f5fd3a] xfs_scrub: better reporting of metadata media errors
      [02d0069e] xfs_scrub: improve reporting of file metadata media erro=
rs
      [909c6a54] xfs_scrub: don't report media errors on unwritten extent=
s
      [c9b349bd] xfs_scrub: reduce fsmap activity for media errors
      [0f402dd8] xfs_scrub: request fewer bmaps when we can
      [eacea707] xfs_scrub: fix media verification thread pool size calcu=
lations
      [d530e589] libfrog: clean up platform_nproc
      [4b45ff6f] libxfs: remove libxfs_nproc
      [4e5fe123] libxfs: remove libxfs_physmem
      [b658de93] libfrog: take over platform headers
      [ae14fe63] xfs_scrub: clean out the nproc global variable
      [e3724c8b] xfs_scrub: refactor xfs_iterate_inodes_range_check
      [e98616ba] xfs_scrub: fix misclassified error reporting
      [5155653f] xfs_scrub: simplify post-run reporting logic
      [420fad2d] xfs_scrub: clean up error level table
      [abc2e70d] xfs_scrub: explicitly track corruptions, not just errors=

      [e458f3f1] xfs_scrub: promote some of the str_info to str_error cal=
ls
      [05921544] xfs_scrub: refactor xfs_scrub_excessive_errors
      [49e05cb0] xfs_scrub: create a new category for unfixable errors
      [51c94053] xfs_scrub: bump work_threads to include the controller t=
hread
      [b3f76f94] xfs_scrub: implement deferred description string renderi=
ng
      [a3158a75] xfs_scrub: adapt phase5 to deferred descriptions
      [16dbab1a] xfs_scrub: implement background mode for phase 6
      [73ce9669] xfs_scrub: remove moveon from filemap iteration
      [934d8d3a] xfs_scrub: remove moveon from the fscounters functions
      [59f79e0a] xfs_scrub: remove moveon from inode iteration
      [f544ec31] xfs_scrub: remove moveon from vfs directory tree iterati=
on
      [7a2eef2b] xfs_scrub: remove moveon from spacemap
      [ac1c1f8e] xfs_scrub: remove moveon from unicode name collision hel=
pers
      [d86e83b8] xfs_scrub: remove moveon from progress report helpers
      [d22f2471] xfs_scrub: remove moveon from scrub ioctl wrappers
      [83d2c80b] xfs_scrub: remove moveon from repair action list helpers=

      [0d96df9d] xfs_scrub: remove moveon from phase 7 functions
      [af9eb208] xfs_scrub: remove moveon from phase 6 functions
      [8142c597] xfs_scrub: remove moveon from phase 5 functions
      [596a30ba] xfs_scrub: remove moveon from phase 4 functions
      [df024103] xfs_scrub: remove moveon from phase 3 functions
      [f29dc2f5] xfs_scrub: remove moveon from phase 2 functions
      [35b65bcf] xfs_scrub: remove moveon from phase 1 functions
      [b8e62724] xfs_scrub: remove XFS_ITERATE_INODES_ABORT from inode it=
erator
      [64dabc9f] xfs_scrub: remove moveon from main program
      [9fc3ef62] libfrog: print library errors
      [93d69bc7] libfrog: convert bitmap.c to negative error codes
      [03d96c64] libfrog: convert fsgeom.c functions to negative error co=
des
      [e6542132] libfrog: convert bulkstat.c functions to negative error =
codes
      [2f4422f4] libfrog: convert ptvar.c functions to negative error cod=
es
      [de5d20ec] libfrog: convert scrub.c functions to negative error cod=
es
      [baed134d] libfrog: convert workqueue.c functions to negative error=
 codes
      [c3387fb8] xfs_scrub: fix complaint about uninitialized ret

Eric Biggers (9):
      [f007179d] xfs_io/encrypt: remove unimplemented encryption modes
      [336e7c19] xfs_io/encrypt: update to UAPI definitions from Linux v5=
=2E4
      [eb6c66e6] xfs_io/encrypt: generate encryption modes for 'help set_=
encpolicy'
      [7cde2c28] xfs_io/encrypt: add new encryption modes
      [c304c84f] xfs_io/encrypt: extend 'get_encpolicy' to support v2 pol=
icies
      [a7a5e44c] xfs_io/encrypt: extend 'set_encpolicy' to support v2 pol=
icies
      [ba71de04] xfs_io/encrypt: add 'add_enckey' command
      [c808a097] xfs_io/encrypt: add 'rm_enckey' command
      [dafb55f9] xfs_io/encrypt: add 'enckey_status' command

Eric Sandeen (10):
      [b2604bc1] xfsprogs: fix geometry calls on older kernels for 5.2.1
      [53c77ac7] xfsprogs: Release v5.2.1
      [67c4a324] xfs: remove unused flags arg from getsb interfaces
      [4aa01a59] xfs: remove unused flag arguments
      [4aeb2b0c] xfs: remove unused header files
      [e74aec5b] xfsprogs: Release v5.3.0-rc1
      [7e8275f8] xfs_growfs: allow mounted device node as argument
      [4aaa3af1] xfs_io: fix memory leak in add_enckey
      [0f6bd6e1] xfsprogs: Release v5.3.0-rc2
      [1609c11a] xfsprogs: Release v5.3.0

Jianhong Yin (1):
      [64e366d9] xfs_io: copy_range don't truncate dst_file, and add smar=
t length


Code Diffstat:

 LICENSES/GPL-2.0                        |   6 +
 Makefile                                |   1 +
 VERSION                                 |   2 +-
 configure.ac                            |   2 +-
 db/Makefile                             |   4 +-
 db/btheight.c                           | 384 +++++++++++++++
 db/check.c                              |  50 +-
 db/command.c                            |   2 +-
 db/command.h                            |   2 +
 db/convert.c                            |   1 -
 db/convert.h                            |   7 -
 db/frag.c                               |   9 +-
 db/info.c                               |   2 +-
 db/inode.c                              |  15 +-
 db/metadump.c                           |  25 +-
 debian/changelog                        |  30 ++
 doc/CHANGES                             |  27 ++
 fsr/xfs_fsr.c                           | 209 ++++----
 growfs/xfs_growfs.c                     |  35 +-
 include/Makefile                        |   3 -
 include/builddefs.in                    |   3 +-
 include/fsgeom.h                        |  11 -
 include/input.h                         |   4 +-
 include/jdm.h                           |   8 +-
 include/libxcmd.h                       |  31 --
 include/libxfs.h                        |   9 +-
 include/platform_defs.h.in              |   2 +
 include/ptvar.h                         |  18 -
 include/xfs_mount.h                     |  22 +-
 include/xfs_trans.h                     |   2 +-
 io/Makefile                             |   9 +-
 io/attr.c                               |   4 +-
 io/bmap.c                               |   7 +-
 io/bulkstat.c                           | 513 ++++++++++++++++++++
 io/copy_file_range.c                    |  42 +-
 io/cowextsize.c                         |   2 +-
 io/crc32cselftest.c                     |   4 +-
 io/encrypt.c                            | 822 ++++++++++++++++++++++++++=
+-----
 io/fsmap.c                              |   9 +-
 io/imap.c                               |  50 +-
 io/init.c                               |   1 +
 io/io.h                                 |   3 +-
 io/label.c                              |   2 +-
 io/open.c                               | 142 +++---
 io/parent.c                             |  20 +-
 io/scrub.c                              |  91 ++--
 io/stat.c                               |   8 +-
 io/swapext.c                            |  29 +-
 libfrog/Makefile                        |  20 +-
 {include =3D> libfrog}/avl64.h            |   6 +-
 libfrog/bitmap.c                        |  80 +++-
 {include =3D> libfrog}/bitmap.h           |  10 +-
 libfrog/bulkstat.c                      | 588 +++++++++++++++++++++++
 libfrog/bulkstat.h                      |  35 ++
 {include =3D> libfrog}/convert.h          |   6 +-
 {include =3D> libfrog}/crc32c.h           |   6 +-
 {include =3D> libfrog}/crc32cselftest.h   |   6 +-
 libfrog/fsgeom.c                        | 108 +++++
 libfrog/fsgeom.h                        | 197 ++++++++
 libfrog/linux.c                         |   9 +-
 libfrog/logging.c                       |  18 +
 libfrog/logging.h                       |  11 +
 libfrog/paths.c                         |   4 +-
 include/path.h =3D> libfrog/paths.h       |   6 +-
 libfrog/platform.h                      |  26 +
 libfrog/projects.c                      |   2 +-
 include/project.h =3D> libfrog/projects.h |   6 +-
 libfrog/ptvar.c                         |  47 +-
 libfrog/ptvar.h                         |  22 +
 {include =3D> libfrog}/radix-tree.h       |   6 +-
 libfrog/scrub.c                         | 153 ++++++
 libfrog/scrub.h                         |  36 ++
 libfrog/topology.c                      |   2 +
 libfrog/topology.h                      |  39 ++
 libfrog/util.c                          |   2 +-
 include/libfrog.h =3D> libfrog/util.h     |   6 +-
 libfrog/workqueue.c                     |  82 +++-
 {include =3D> libfrog}/workqueue.h        |   8 +-
 libhandle/jdm.c                         |  16 +-
 libxfs/init.c                           |  75 +--
 libxfs/init.h                           |  14 -
 libxfs/libxfs_api_defs.h                |   5 +
 libxfs/libxfs_io.h                      |  32 +-
 libxfs/libxfs_priv.h                    |  10 +-
 libxfs/rdwr.c                           |  41 +-
 libxfs/trans.c                          |  10 +-
 libxfs/util.c                           |   1 +
 libxfs/xfs_ag.c                         | 101 +++-
 libxfs/xfs_ag_resv.c                    |  11 -
 libxfs/xfs_alloc.c                      | 228 +++++----
 libxfs/xfs_alloc_btree.c                |   5 +-
 libxfs/xfs_attr.c                       |   2 -
 libxfs/xfs_attr.h                       |   8 +-
 libxfs/xfs_attr_leaf.c                  |  15 +-
 libxfs/xfs_attr_remote.c                |  11 +-
 libxfs/xfs_bit.c                        |   1 -
 libxfs/xfs_bmap.c                       |  46 +-
 libxfs/xfs_bmap_btree.c                 |   4 +-
 libxfs/xfs_btree.c                      |  50 +-
 libxfs/xfs_btree.h                      |  14 +-
 libxfs/xfs_da_btree.c                   |  29 +-
 libxfs/xfs_da_format.c                  |   3 -
 libxfs/xfs_defer.c                      |   6 -
 libxfs/xfs_dir2.c                       |   6 +-
 libxfs/xfs_dir2_block.c                 |  10 +-
 libxfs/xfs_dir2_data.c                  |  14 +-
 libxfs/xfs_dir2_leaf.c                  |  10 +-
 libxfs/xfs_dir2_node.c                  |  13 +-
 libxfs/xfs_dir2_sf.c                    |   3 +-
 libxfs/xfs_dquot_buf.c                  |  13 +-
 libxfs/xfs_format.h                     |   2 +-
 libxfs/xfs_fs.h                         | 125 ++++-
 libxfs/xfs_health.h                     |   2 +-
 libxfs/xfs_ialloc.c                     | 245 ++++++----
 libxfs/xfs_ialloc.h                     |  18 +-
 libxfs/xfs_ialloc_btree.c               |  56 ++-
 libxfs/xfs_ialloc_btree.h               |   3 +
 libxfs/xfs_iext_tree.c                  |   4 -
 libxfs/xfs_inode_buf.c                  |  10 +-
 libxfs/xfs_inode_fork.c                 |   3 +-
 libxfs/xfs_log_rlimit.c                 |   2 -
 libxfs/xfs_refcount.c                   |   3 -
 libxfs/xfs_refcount_btree.c             |   5 +-
 libxfs/xfs_rmap.c                       |   7 -
 libxfs/xfs_rmap_btree.c                 |   6 +-
 libxfs/xfs_rtbitmap.c                   |   4 -
 libxfs/xfs_sb.c                         |  39 +-
 libxfs/xfs_shared.h                     |  49 +-
 libxfs/xfs_symlink_remote.c             |   9 +-
 libxfs/xfs_trans_inode.c                |   3 -
 libxfs/xfs_trans_resv.c                 |  18 +-
 libxfs/xfs_trans_space.h                |   7 +-
 libxfs/xfs_types.c                      |  13 +-
 man/man2/ioctl_xfs_ag_geometry.2        | 130 +++++
 man/man2/ioctl_xfs_bulkstat.2           | 346 ++++++++++++++
 man/man2/ioctl_xfs_fsbulkstat.2         |  58 ++-
 man/man2/ioctl_xfs_fsop_geometry.2      |  62 +++
 man/man2/ioctl_xfs_inumbers.2           | 128 +++++
 man/man2/ioctl_xfs_scrub_metadata.2     |   5 +
 man/man3/xfsctl.3                       |   6 +
 man/man8/xfs_growfs.8                   |  10 +-
 man/man8/xfs_io.8                       | 167 ++++++-
 man/man8/xfs_scrub.8                    |   4 +
 man/man8/xfs_spaceman.8                 |  28 ++
 mkfs/proto.c                            |   2 +-
 mkfs/xfs_mkfs.c                         | 388 ++-------------
 po/pl.po                                |   2 +-
 quota/free.c                            |  10 +-
 quota/init.c                            |   2 +-
 quota/quot.c                            |  56 +--
 quota/quota.h                           |   4 +-
 repair/dino_chunks.c                    |  66 +--
 repair/dinode.c                         |  14 +-
 repair/globals.c                        |   1 -
 repair/globals.h                        |   1 -
 repair/incore_ext.c                     |   2 +-
 repair/phase2.c                         |   2 +-
 repair/phase4.c                         |   6 +-
 repair/phase5.c                         |  52 +-
 repair/phase6.c                         |   8 +-
 repair/prefetch.c                       |  32 +-
 repair/rmap.c                           |  38 +-
 repair/sb.c                             |   3 +-
 repair/scan.c                           |  19 +-
 repair/slab.c                           |   2 +-
 repair/threads.c                        |  10 +-
 repair/threads.h                        |   2 +-
 repair/xfs_repair.c                     |  27 +-
 rtcp/Makefile                           |   3 +
 rtcp/xfs_rtcp.c                         |   9 +-
 scrub/Makefile                          |   2 +
 scrub/common.c                          |  91 +++-
 scrub/common.h                          |  14 +-
 scrub/counter.c                         |  46 +-
 scrub/counter.h                         |   6 +-
 scrub/descr.c                           | 106 ++++
 scrub/descr.h                           |  29 ++
 scrub/disk.c                            |  88 +++-
 scrub/disk.h                            |   3 +-
 scrub/filemap.c                         |  77 ++-
 scrub/filemap.h                         |  16 +-
 scrub/fscounters.c                      | 178 +++----
 scrub/fscounters.h                      |   4 +-
 scrub/inodes.c                          | 263 +++++-----
 scrub/inodes.h                          |  17 +-
 scrub/phase1.c                          | 119 ++---
 scrub/phase2.c                          | 128 ++---
 scrub/phase3.c                          | 162 ++++---
 scrub/phase4.c                          | 108 +++--
 scrub/phase5.c                          | 271 +++++++----
 scrub/phase6.c                          | 556 +++++++++++++--------
 scrub/phase7.c                          | 101 ++--
 scrub/progress.c                        |  35 +-
 scrub/progress.h                        |   2 +-
 scrub/read_verify.c                     | 265 +++++++---
 scrub/read_verify.h                     |  17 +-
 scrub/repair.c                          |  92 ++--
 scrub/repair.h                          |  32 +-
 scrub/scrub.c                           | 625 ++++++++++++------------
 scrub/scrub.h                           |  47 +-
 scrub/spacemap.c                        | 177 +++----
 scrub/spacemap.h                        |  12 +-
 scrub/unicrash.c                        | 103 ++--
 scrub/unicrash.h                        |  28 +-
 scrub/vfs.c                             | 206 +++++---
 scrub/vfs.h                             |  16 +-
 scrub/xfs_scrub.c                       | 169 ++++---
 scrub/xfs_scrub.h                       |  54 +--
 spaceman/Makefile                       |   2 +-
 spaceman/file.c                         |  61 ++-
 spaceman/freesp.c                       |  49 +-
 spaceman/health.c                       | 461 ++++++++++++++++++
 spaceman/info.c                         |  32 +-
 spaceman/init.c                         |  14 +-
 spaceman/prealloc.c                     |  17 +-
 spaceman/space.h                        |  18 +-
 spaceman/trim.c                         |  43 +-
 217 files changed, 8608 insertions(+), 3730 deletions(-)
 create mode 100644 db/btheight.c
 delete mode 100644 db/convert.h
 delete mode 100644 include/fsgeom.h
 delete mode 100644 include/ptvar.h
 create mode 100644 io/bulkstat.c
 rename {include =3D> libfrog}/avl64.h (96%)
 rename {include =3D> libfrog}/bitmap.h (68%)
 create mode 100644 libfrog/bulkstat.c
 create mode 100644 libfrog/bulkstat.h
 rename {include =3D> libfrog}/convert.h (87%)
 rename {include =3D> libfrog}/crc32c.h (68%)
 rename {include =3D> libfrog}/crc32cselftest.h (99%)
 create mode 100644 libfrog/fsgeom.h
 create mode 100644 libfrog/logging.c
 create mode 100644 libfrog/logging.h
 rename include/path.h =3D> libfrog/paths.h (95%)
 create mode 100644 libfrog/platform.h
 rename include/project.h =3D> libfrog/projects.h (90%)
 create mode 100644 libfrog/ptvar.h
 rename {include =3D> libfrog}/radix-tree.h (94%)
 create mode 100644 libfrog/scrub.c
 create mode 100644 libfrog/scrub.h
 create mode 100644 libfrog/topology.h
 rename include/libfrog.h =3D> libfrog/util.h (65%)
 rename {include =3D> libfrog}/workqueue.h (84%)
 create mode 100644 man/man2/ioctl_xfs_ag_geometry.2
 create mode 100644 man/man2/ioctl_xfs_bulkstat.2
 create mode 100644 man/man2/ioctl_xfs_inumbers.2
 create mode 100644 scrub/descr.c
 create mode 100644 scrub/descr.h
 create mode 100644 spaceman/health.c


--Gb3620lkhrP2oDdPcBcgQYLYrSKamdrOg--

--udlKoWDhY5AEkvWS8YDZmNroPCNCO8P8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl3O5dUACgkQIK4WkuE9
3uAoPhAApBs53JJYQkZPEK8IJrWvxhTdQRfhP0/a4F3dCrOsxUu2QQ2h3b8ZrYig
Xkm6a/Tzl1WUvW9V9hhZiI2XqSQvl19zr6dire7Uv6mV10BCHvZ6d/jN0AD7uBk4
nNSzDjHHPXsJ8ovhmKGCLmWMquuTsfsDhDm1Z/HixkkJKrVfZNe2hbGM+xVvUqfd
D3wAgC/PTKwbGVYilGPjOqCgIVD7TF9VMkfOlC7NgaIcj+SplQoOhfn17wDJGAfI
leM7ghxjJqAXSi2DPJk9Z8MjVs3BpOlfu0M3dE/3ruvjBBjLw3x3xECV0AhxrWO/
cwQ6kVmb8+xo1DQkrje85GqbPZuR8iiDsv/beKbxRpuDUGMx6MHOd5BAqHb21TzO
lOlL/odFODMr+9EB3BkYQ3dZ2DqJEhpJfKj3rpwoUE7mCZNoiLp7PumMKB2S8xg4
TW24EeqNobmJVtsbYEsUkI4i6yPHNkjwHMc9NlDzi405zEKM0TmDb5S3vNyCH0Vr
69i2EXUk4pmxxwlJZeeEpYZlboyqBiObz/0ZPWHxFh9HxvR94z3RspqoHyUCNHB+
pFLL98+hNmWfVxm8EJgjJmwL35O/74LYltRWyBUo7oR4vWaiwM45K59IEBrdFhcY
SGevugoCqNmLLExXb591yb7BDNysH8qbmYETeh7YUhzpVlqtipQ=
=x9vM
-----END PGP SIGNATURE-----

--udlKoWDhY5AEkvWS8YDZmNroPCNCO8P8R--
