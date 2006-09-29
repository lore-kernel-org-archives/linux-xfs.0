Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Sep 2006 00:57:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8T7uoaG014070
	for <xfs@oss.sgi.com>; Fri, 29 Sep 2006 00:56:53 -0700
Message-ID: <451CD1EA.8020704@sgi.com>
Date: Fri, 29 Sep 2006 17:57:30 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: XFS update for 2.6.19
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org
Cc: akpm@osdl.org, xfs@oss.sgi.com

Hi Linus,

Please pull from:
	git://oss.sgi.com:8090/xfs/xfs-2.6

This will update the following files:

  fs/xfs/Makefile-linux-2.6      |    1
  fs/xfs/linux-2.6/kmem.c        |   29 +++
  fs/xfs/linux-2.6/kmem.h        |    6 -
  fs/xfs/linux-2.6/sema.h        |    2
  fs/xfs/linux-2.6/sv.h          |    2
  fs/xfs/linux-2.6/xfs_aops.c    |    9 -
  fs/xfs/linux-2.6/xfs_buf.c     |   51 +++---
  fs/xfs/linux-2.6/xfs_buf.h     |    7 -
  fs/xfs/linux-2.6/xfs_globals.c |    2
  fs/xfs/linux-2.6/xfs_ioctl.c   |   19 +-
  fs/xfs/linux-2.6/xfs_iops.c    |   25 ++-
  fs/xfs/linux-2.6/xfs_linux.h   |   14 +-
  fs/xfs/linux-2.6/xfs_lrw.c     |   10 +
  fs/xfs/linux-2.6/xfs_super.c   |    2
  fs/xfs/linux-2.6/xfs_vfs.h     |    2
  fs/xfs/linux-2.6/xfs_vnode.h   |    2
  fs/xfs/quota/xfs_dquot_item.c  |   26 ---
  fs/xfs/quota/xfs_qm.c          |   14 +-
  fs/xfs/quota/xfs_qm.h          |    6 -
  fs/xfs/quota/xfs_quota_priv.h  |    2
  fs/xfs/support/ktrace.c        |    2
  fs/xfs/xfs_ag.h                |    2
  fs/xfs/xfs_alloc.c             |   10 +
  fs/xfs/xfs_alloc_btree.c       |  132 ++++++++-------
  fs/xfs/xfs_attr.c              |  181 ++++++++++++++++-----
  fs/xfs/xfs_attr.h              |    8 +
  fs/xfs/xfs_attr_leaf.c         |  351 ++++++++++++++++++----------------------
  fs/xfs/xfs_attr_leaf.h         |   41 ++++-
  fs/xfs/xfs_behavior.c          |   20 --
  fs/xfs/xfs_behavior.h          |    2
  fs/xfs/xfs_bmap.c              |   90 +++++-----
  fs/xfs/xfs_bmap_btree.c        |  113 ++++++-------
  fs/xfs/xfs_bmap_btree.h        |   11 +
  fs/xfs/xfs_btree.c             |    8 -
  fs/xfs/xfs_btree.h             |    5 -
  fs/xfs/xfs_buf_item.c          |   22 ---
  fs/xfs/xfs_da_btree.c          |   33 ++--
  fs/xfs/xfs_error.h             |    9 -
  fs/xfs/xfs_extfree_item.c      |   69 --------
  fs/xfs/xfs_extfree_item.h      |   50 +++---
  fs/xfs/xfs_fs.h                |    8 -
  fs/xfs/xfs_ialloc.c            |   11 +
  fs/xfs/xfs_ialloc_btree.c      |   62 ++++---
  fs/xfs/xfs_ialloc_btree.h      |   19 +-
  fs/xfs/xfs_iget.c              |   44 +++--
  fs/xfs/xfs_inode.c             |   30 +++
  fs/xfs/xfs_inode.h             |   12 +
  fs/xfs/xfs_inode_item.c        |   16 --
  fs/xfs/xfs_inode_item.h        |   66 ++++----
  fs/xfs/xfs_iomap.c             |   89 ++++------
  fs/xfs/xfs_itable.c            |  184 +++++++++++++--------
  fs/xfs/xfs_itable.h            |   16 +-
  fs/xfs/xfs_log.c               |   19 ++
  fs/xfs/xfs_log.h               |    8 -
  fs/xfs/xfs_log_priv.h          |   10 +
  fs/xfs/xfs_mount.h             |    5 -
  fs/xfs/xfs_quota.h             |    2
  fs/xfs/xfs_rtalloc.c           |   38 ++--
  fs/xfs/xfs_sb.h                |   22 ---
  fs/xfs/xfs_trans.h             |    2
  fs/xfs/xfs_trans_ail.c         |    4
  fs/xfs/xfs_trans_priv.h        |   12 +
  fs/xfs/xfs_vfsops.c            |    2
  fs/xfs/xfs_vnodeops.c          |   26 ++-
  64 files changed, 1060 insertions(+), 1037 deletions(-)

through these commits:

commit f37ea14969bf85633d3bd29ddf008171a5618855
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Sep 28 10:52:04 2006 +1000

     [XFS] pass inode to xfs_ioc_space(), simplify some code. There is trivial
     "inode => vnode => inode" conversion, but only flags and mode of final
     inode are looked at. Pass original inode instead.

     SGI-PV: 904196
     SGI-Modid: xfs-linux-melb:xfs-kern:26395a

     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit f07c225036358038bf8a64f75351f10cdca2fb22
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 10:52:15 2006 +1000

     [XFS] Improve xfsbufd delayed write submission patterns, after blktrace
     analysis.

     Under a sequential create+allocate workload, blktrace reported backward
     writes being issued by xfsbufd, and frequent inappropriate queue unplugs.
     We now insert at the tail when moving from the delwri lists to the temp
     lists, which maintains correct ordering, and we avoid unplugging queues
     deep in the submit paths when we'd shortly do it at a higher level anyway.
     blktrace now reports much healthier write patterns from xfsbufd for this
     workload (and likely many others).

     SGI-PV: 954310
     SGI-Modid: xfs-linux-melb:xfs-kern:26396a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 128dabc5e9aa13dfebcad84e6b4ab31078555131
Author: Tim Shimmin <tes@sgi.com>
Date:   Thu Sep 28 10:55:43 2006 +1000

     [XFS] cleanup the field types of some item format structures

     SGI-PV: 954365
     SGI-Modid: xfs-linux-melb:xfs-kern:26406a

     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 87395deb0b3d174ffcc7f66569764f0715ac5174
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Sep 28 10:56:01 2006 +1000

     [XFS] move XFS_IOC_GETVERSION to main multiplexer

     Avoids doing an unnecessary inode to vnode conversion and avoids a memory
     allocation.

     SGI-PV: 904196
     SGI-Modid: xfs-linux-melb:xfs-kern:26492a

     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 673cdf5c72ff9551df08a71f2ac1a8fe02888e8d
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 10:56:26 2006 +1000

     [XFS] Fix rounding bug in xfs_free_file_space found by sparse checking.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26551a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit ed9d88f7b7e6feba457b87ff30249e6c1e139005
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 10:56:43 2006 +1000

     [XFS] Fix sparse warning found when page tracing enabled, due to
     overloaded gfp_t param.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26552a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit e21010053a0f11122db728f82ae115f2808752d6
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:56:51 2006 +1000

     [XFS] endianess annotation for xfs_agfl_t. Trivial, xfs_agfl_t is always
     used for ondisk values.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26553a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 61a258486795ff710cf4518b5a1729c965c32aa0
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:57:04 2006 +1000

     [XFS] endianess annotations for xfs_inobt_rec_t / xfs_inobt_key_t

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26556a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit c38e5e84dbbeda9a92ea878ec9f6255b519a69e7
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:57:17 2006 +1000

     [XFS] remove left over INT_ comments in *alloc*.c We can verify endianess
     handling with sparse now, no need for comments.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26557a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit b113bcb83efb411f3cc6c7692fbf933ed01b67d8
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:57:42 2006 +1000

     [XFS] add xfs_btree_check_lptr_disk variant which handles endian
     conversion

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26558a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 397b5208d5609e2f01b171a34ab690f325253492
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:57:52 2006 +1000

     [XFS] endianess annotations for xfs_bmbt_ptr_t/xfs_bmdr_ptr_t

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26559a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 576039cf3c668d5f8d97dff8a0a5817e8b3a761b
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:58:06 2006 +1000

     [XFS] endianess annotate XFS_BMAP_BROOT_PTR_ADDR Make sure it returns a
     __be64 and let the callers use the proper macros.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26560a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 8801bb99e4425b9a778b355153ab3254bb431d92
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:58:17 2006 +1000

     [XFS] endianess annotations for xfs_bmbt_key Trivial as there are no
     incore users.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26561a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 1121b219bf3fe6d1bd1d1f7618cc5e0c409fabb4
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 10:58:40 2006 +1000

     [XFS] use NULL for pointer initialisation instead of zero-cast-to-ptr

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26562a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit fe48cae9ed979d2ac14080c837d793c4f6bfaa82
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Sep 28 10:58:52 2006 +1000

     [XFS] remove bhv_lookup, _range version works aswell and has more useful
     semantics.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26563a

     Signed-off-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 29b6d22b011d83dac8ca5b7d26f766ae598abbbd
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 10:59:06 2006 +1000

     [XFS] remove accidentally reintroduced vfs unmount flag, unneeded in
     current kernels

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26564a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 69e23b9a5e7430ced667d8b699330e370c202f28
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:01:22 2006 +1000

     [XFS] Update XFS for i_blksize removal from generic inode structure

     SGI-PV: 954366
     SGI-Modid: xfs-linux-melb:xfs-kern:26565a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 726801ba067410a1d38518823f2c253a087f6c6f
Author: Tim Shimmin <tes@sgi.com>
Date:   Thu Sep 28 11:01:37 2006 +1000

     [XFS] Add EA list callbacks for xfs kernel use. Cleanup some namespace
     code.

     SGI-PV: 954372
     SGI-Modid: xfs-linux-melb:xfs-kern:26583a

     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 8b56f083c2a6bd0a88271225f0bcf1d81db20d3c
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:01:46 2006 +1000

     [XFS] Rework DMAPI bulkstat calls in such a way that we can directly
     extract inline attributes out of the bulkstat buffer (for that case),
     rather than using an (extremely expensive for large icount filesystems)
     iget for fetching attrs.

     SGI-PV: 944409
     SGI-Modid: xfs-linux-melb:xfs-kern:26602a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 51bdd70681e247184b81c2de61dbc26154511155
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:01:57 2006 +1000

     [XFS] When issuing metadata readahead, submit bio with READA not READ.

     SGI-PV: 944409
     SGI-Modid: xfs-linux-melb:xfs-kern:26603a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 2627509330323efc88b5818065cba737e000de5c
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:02:03 2006 +1000

     [XFS] Drop unneeded endian conversion in bulkstat and start readahead for
     batches of inode cluster buffers at once, before any blocking reads are
     issued.

     SGI-PV: 944409
     SGI-Modid: xfs-linux-melb:xfs-kern:26606a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit bb3c7d2936b6db6f5ded9abf4d215abe97af8372
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:02:09 2006 +1000

     [XFS] Increase the size of the buffer holding the local inode cluster
     list, to increase our potential readahead window and in turn improve
     bulkstat performance.

     SGI-PV: 944409
     SGI-Modid: xfs-linux-melb:xfs-kern:26607a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit a3c6685eaa1b6c5cf05b084b3bc91895e253ad2c
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:02:14 2006 +1000

     [XFS] Ensure xlog_state_do_callback does not report spurious warnings on
     ramdisks.

     SGI-PV: 954802
     SGI-Modid: xfs-linux-melb:xfs-kern:26627a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 745b1f47fc0c68dbb1ff440eec8889f61e57194b
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:02:23 2006 +1000

     [XFS] Remove last bulkstat false-positives with debug kernels.

     SGI-PV: 953819
     SGI-Modid: xfs-linux-melb:xfs-kern:26628a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 17370097dace78c93d6fa32110983e74b981d192
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:02:30 2006 +1000

     [XFS] pass file mode on DMAPI remove events

     SGI-PV: 953687
     SGI-Modid: xfs-linux-melb:xfs-kern:26639a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 43129c16e85119355d352e10ff4b30a08053228c
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:02:37 2006 +1000

     [XFS] Remove a couple of unused BUF macros

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26746a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 065d312e15902976d256ddaf396a7950ec0350a8
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:02:44 2006 +1000

     [XFS] Remove unused iop_abort log item operation

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26747a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 3f89243c5b987dd55f8eec6fd54be05887d69bc6
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:02:57 2006 +1000

     [XFS] Remove several macros that are no longer used anywhere

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26749a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit efb8ad7e9431a430a75d44288614cf6047ff4baa
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:05 2006 +1000

     [XFS] Add a debug flag for allocations which are known to be larger than
     one page.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26800a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 948ecdb4c118293d2f3e267eec642c30c5d3a056
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:13 2006 +1000

     [XFS] Be more defensive with page flags (error/private) for metadata
     buffers.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26801a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 572d95f49f3652fffe8242c4498b85f4083e52ab
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:20 2006 +1000

     [XFS] Improve error handling for the zero-fsblock extent detection code.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26802a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 77e4635ae191774526ed695482a151ac986f3806
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:27 2006 +1000

     [XFS] Add a greedy allocation interface, allocating within a min/max size
     range.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26803a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit b627259c602f3f1b995d09aad2b57bed889430b9
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:33 2006 +1000

     [XFS] Remove a no-longer-correct debug assert from dio completion
     handling.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26804a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit d432c80e68e3c283fc9a85021f5b65e0aabf254e
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:44 2006 +1000

     [XFS] Minor code rearranging and cleanup to prevent some coverity false
     positives.

     SGI-PV: 955502
     SGI-Modid: xfs-linux-melb:xfs-kern:26805a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 68c3271515f11f6665dc8732e53aaab3d3fdd7d3
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:03:53 2006 +1000

     [XFS] Fix a porting botch on the realtime subvol growfs code path.

     SGI-PV: 955515
     SGI-Modid: xfs-linux-melb:xfs-kern:26806a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 22d91f65d57a7f1a1c5fc81f47b47b0cc54ad6f7
Author: Josh Triplett <josh@freedesktop.org>
Date:   Thu Sep 28 11:04:07 2006 +1000

     [XFS] Add lock annotations to xfs_trans_update_ail and
     xfs_trans_delete_ail

     xfs_trans_update_ail and xfs_trans_delete_ail get called with the AIL lock
     held, and release it. Add lock annotations to these two functions so that
     sparse can check callers for lock pairing, and so that sparse will not
     complain about these functions since they intentionally use locks in this
     manner.

     SGI-PV: 954580
     SGI-Modid: xfs-linux-melb:xfs-kern:26807a

     Signed-off-by: Josh Triplett <josh@freedesktop.org>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 955e47ad28b5b255ddcd7eb9cb814a269dc6e991
Author: Tim Shimmin <tes@sgi.com>
Date:   Thu Sep 28 11:04:16 2006 +1000

     [XFS] Fixes the leak in reservation space because we weren't ungranting
     space for the unmount record - which becomes a problem in the freeze/thaw
     scenario.

     SGI-PV: 942533
     SGI-Modid: xfs-linux-melb:xfs-kern:26815a

     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 22de606a0b9623bf15752808f123848a65a6cc28
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:04:24 2006 +1000

     [XFS] pv 955157, rv bnaujok - break the loop on formatter() error

     SGI-PV: 955157
     SGI-Modid: xfs-linux-melb:xfs-kern:26866a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit e132f54ce8660bbf34723cc12cb11e6f61d6fbac
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:04:31 2006 +1000

     [XFS] pv 955157, rv bnaujok - break the loop on EFAULT formatter() error

     SGI-PV: 955157
     SGI-Modid: xfs-linux-melb:xfs-kern:26869a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 215101c36012399cf2eaee849de54eeefc9f618c
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:04:43 2006 +1000

     [XFS] Fix kmem_zalloc_greedy warnings on 64 bit platforms.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26907a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit edcd4bce5e58987c8c039bdf7705a22cd229fe96
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 28 11:05:33 2006 +1000

     [XFS] Minor cleanup from dio locking fix, remove an extra conditional.

     SGI-PV: 955696
     SGI-Modid: xfs-linux-melb:xfs-kern:26908a

     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 91d87232044c1ceb8371625c27479e982984a848
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:05:40 2006 +1000

     [XFS] Reduce endian flipping in alloc_btree, same as was done for
     ialloc_btree.

     SGI-PV: 955302
     SGI-Modid: xfs-linux-melb:xfs-kern:26910a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 7ae67d78e7518fba89e5f3a74bdcb68e48ae8858
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:05:46 2006 +1000

     [XFS] standardize on one sema init macro

     One sema to rule them all, one sema to find them...

     SGI-PV: 907752
     SGI-Modid: xfs-linux-melb:xfs-kern:26911a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 01106eae97b70399ce5a273a3cceb5246e8d9cc8
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 28 11:05:52 2006 +1000

     [XFS] Collapse sv_init and init_sv into just the one interface.

     SGI-PV: 907752
     SGI-Modid: xfs-linux-melb:xfs-kern:26925a

     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
     Signed-off-by: Nathan Scott <nathans@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit f273ab848b7cbc0088b0ac7457b3769e6566074e
Author: David Chinner <dgc@sgi.com>
Date:   Thu Sep 28 11:06:03 2006 +1000

     [XFS] Really fix use after free in xfs_iunpin.

     The previous attempts to fix the linux inode use-after-free in xfs_iunpin
     simply made the problem harder to hit. We actually need complete exclusion
     between xfs_reclaim and xfs_iunpin, as well as ensuring that the i_flags
     are consistent during both of these functions. Introduce a new spinlock
     for exclusion and the i_flags, and fix up xfs_iunpin to use igrab before
     marking the inode dirty.

     SGI-PV: 952967
     SGI-Modid: xfs-linux-melb:xfs-kern:26964a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 6216ff18839bf302805f67c93e8bc344387c513b
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:06:10 2006 +1000

     [XFS] pv 956240, author: nathans, rv: vapo - Minor fixes in
     kmem_zalloc_greedy()

     SGI-PV: 956240
     SGI-Modid: xfs-linux-melb:xfs-kern:26983a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 6f1f21684078884b62cfff2ea80a1a6c07f79824
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:06:15 2006 +1000

     [XFS] pv 956241, author: nathans, rv: vapo - make ino validation checks
     consistent in bulkstat

     SGI-PV: 956241
     SGI-Modid: xfs-linux-melb:xfs-kern:26984a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 6e73b418887675da18602550ca296211caeb3897
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Thu Sep 28 11:06:21 2006 +1000

     [XFS] 955947: Infinite loop in xfs_bulkstat() on formatter() error

     SGI-PV: 955947
     SGI-Modid: xfs-linux-melb:xfs-kern:26986a

     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 65e8697a12e356cd7a6ecafa1149f5c5c6a71593
Author: Tim Shimmin <tes@chook.melbourne.sgi.com>
Date:   Fri Sep 29 15:23:02 2006 +1000

     [XFS] Remove v1 dir trace macro - missed in a past commit.

     Signed-off-by: Tim Shimmin <tes@sgi.com>
