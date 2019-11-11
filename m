Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D97CC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B81206DF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cVMlfdeq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfKKBRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:17:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfKKBRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:17:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1Evhq100901
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 01:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=LCIfDj/eReFBxK1rPmQGBd3t1HbUWcpKSpPDcZGAJkY=;
 b=cVMlfdeqK1K4IUVYy+YBMmHhC7EyR7FOhaGaLrc3UqSivIOmGnNWRWOf3ju3AIeJxkTo
 UdfNENvEkFR16orAijApl8DLTGi/+Xv+FTm/rOpRecqq+F3eS5SSHA0vwEvdOvedHF0Z
 l4IJAoM584+Xe2MpUuHHnCQR7Nl5BdMwV/QdCM9lLwYVxu7yXEI7Ow8LJduZT8/NUxyq
 97UB0l68cE7RlaStmw0CjUw3p50Nc7q6OJD+9LCaZnUxV9ympGrZ0/phnhnEpAUlyL5c
 FdlCQYo5qHewV6De0a+Hb2AezQT3qERbxCDjh6HTsmZ9eKFaMSegRW9Lrb0jCjXSvS9C rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndpv4gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 01:17:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1Ct6K085062
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 01:17:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66ytmefn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 01:17:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAB1HU9B021486
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2019 01:17:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:17:30 -0800
Date:   Sun, 10 Nov 2019 17:17:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 23220fe260c4
Message-ID: <20191111011729.GR6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Still looking for a few logging cleanups from Dave,
and will be (re)sending the corrpution check cleanup series now with
more bikeshedding.

The new head of the for-next branch is commit:

23220fe260c4 xfs: always pass a valid hdr to xfs_dir3_leaf_check_int

New Commits:

Ben Dooks (Codethink) (1):
      [1aa6300638e7] xfs: add mising include of xfs_pnfs.h for missing declarations

Brian Foster (12):
      [f6b428a46d60] xfs: track active state of allocation btree cursors
      [f5e7dbea1e3e] xfs: introduce allocation cursor data structure
      [d6d3aff20377] xfs: track allocation busy state in allocation cursor
      [c62321a2a0ea] xfs: track best extent from cntbt lastblock scan in alloc cursor
      [396bbf3c657e] xfs: refactor cntbt lastblock scan best extent logic into helper
      [fec0afdaf498] xfs: reuse best extent tracking logic for bnobt scan
      [4a65b7c2c72c] xfs: refactor allocation tree fixup code
      [78d7aabdeea3] xfs: refactor and reuse best extent scanning logic
      [0e26d5ca4a40] xfs: refactor near mode alloc bnobt scan into separate function
      [d29688257fd4] xfs: factor out tree fixup logic into helper
      [dc8e69bd7218] xfs: optimize near mode bnobt scans with concurrent cntbt lookups
      [da781e64b28c] xfs: don't set bmapi total block req where minleft is

Christoph Hellwig (116):
      [2492a606b3d2] xfs: initialize iomap->flags in xfs_bmbt_to_iomap
      [05b30949f1aa] xfs: set IOMAP_F_NEW more carefully
      [4e087a3b313c] xfs: use a struct iomap in xfs_writepage_ctx
      [433dad94ec5d] xfs: refactor the ioend merging code
      [5653017bc44e] xfs: turn io_append_trans into an io_private void pointer
      [760fea8bfb7f] xfs: remove the fork fields in the writepage_ctx and ioend
      [009d8d849d3f] iomap: zero newly allocated mapped blocks
      [9e91c5728cab] iomap: lift common tracing code from xfs to iomap
      [598ecfbaa742] iomap: lift the xfs writeback code to iomap
      [3e19e6f3eeea] iomap: warn on inline maps in iomap_writepage_map
      [ab08b01ec0a2] iomap: move struct iomap_page out of iomap.h
      [b3d423ec898a] iomap: cleanup iomap_ioend_compare
      [48d64cd18b33] iomap: pass a struct page to iomap_finish_page_writeback
      [65a60e8687c1] iomap: better document the IOMAP_F_* flags
      [c12d6fa88d09] iomap: remove the unused iomap argument to __iomap_write_end
      [dcd6158d15c7] iomap: always use AOP_FLAG_NOFS in iomap_write_begin
      [3590c4d8979b] iomap: ignore non-shared or non-data blocks in xfs_file_dirty
      [d3b404396977] iomap: move the zeroing case out of iomap_read_page_sync
      [32a38a499104] iomap: use write_begin to read pages to unshare
      [eb81cf9d0e18] iomap: renumber IOMAP_HOLE to 0
      [bdb2ed2dbdc2] xfs: ignore extent size hints for always COW inodes
      [cd95cb962b7d] xfs: pass the correct flag to xlog_write_iclog
      [2c68a1dfbd8e] xfs: remove the unused ic_io_size field from xlog_in_core
      [390aab0a1640] xfs: move the locking from xlog_state_finish_copy to the callers
      [df732b29c807] xfs: call xlog_state_release_iclog with l_icloglock held
      [032cc34ed517] xfs: remove dead ifdef XFSERRORDEBUG code
      [fe9c0e77acc5] xfs: remove the unused XLOG_STATE_ALL and XLOG_STATE_UNUSED flags
      [1858bb0bec61] xfs: turn ic_state into an enum
      [4b29ab04ab0d] xfs: remove the XLOG_STATE_DO_CALLBACK state
      [0d45e3a20822] xfs: also call xfs_file_iomap_end_delalloc for zeroing operations
      [dd26b84640cc] xfs: remove xfs_reflink_dirty_extents
      [ffb375a8cf20] xfs: pass two imaps to xfs_reflink_allocate_cow
      [ae36b53c6c60] xfs: refactor xfs_file_iomap_begin_delay
      [36adcbace24e] xfs: fill out the srcmap in iomap_begin
      [43568226a4a3] xfs: factor out a helper to calculate the end_fsb
      [690c2a38878e] xfs: split out a new set of read-only iomap ops
      [a526c85c2236] xfs: move xfs_file_iomap_begin_delay around
      [f150b4234397] xfs: split the iomap ops for buffered vs direct writes
      [12dfb58af61d] xfs: rename the whichfork variable in xfs_buffered_write_iomap_begin
      [5c5b6f7585d2] xfs: cleanup xfs_direct_write_iomap_begin
      [1e190f8e8098] xfs: improve the IOMAP_NOWAIT check for COW inodes
      [25a409572b5f] xfs: mark xfs_buf_free static
      [30fa529e3b2e] xfs: add a xfs_inode_buftarg helper
      [f9acc19c8cbe] xfs: use xfs_inode_buftarg in xfs_file_dio_aio_write
      [c7d68318c9ae] xfs: use xfs_inode_buftarg in xfs_file_ioctl
      [9afe1d5c14e0] xfs: don't implement XFS_IOC_RESVSP / XFS_IOC_RESVSP64
      [837a6e7f5cdb] fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers
      [7a42c70ea0dd] xfs: disable xfs_ioc_space for always COW inodes
      [360c09c01c5a] xfs: consolidate preallocation in xfs_file_fallocate
      [2123ef851083] xfs: simplify setting bio flags
      [69e8575dee42] xfs: remove the dsunit and dswidth variables in
      [dd2d535e3fb2] xfs: cleanup calculating the stat optimal I/O size
      [b5ad616c3edf] xfs: don't use a different allocsice for -o wsync
      [3cd1d18b0d40] xfs: remove the m_readio_* fields in struct xfs_mount
      [5da8a07c79e8] xfs: rename the m_writeio_* fields in struct xfs_mount
      [2fcddee8cd8f] xfs: simplify parsing of allocsize mount option
      [3274d0080100] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to
      [7c6b94b1b526] xfs: reverse the polarity of XFS_MOUNT_COMPAT_IOSIZE
      [aa58d4455a11] xfs: clean up printing the allocsize option in
      [1775c506a31e] xfs: clean up printing inode32/64 in xfs_showargs
      [21f55993eb7a] xfs: merge xfs_showargs into xfs_fs_show_options
      [ae7e403fa5bb] xfs: simplify xfs_iomap_eof_align_last_fsb
      [49bbf8c76156] xfs: mark xfs_eof_alignment static
      [57c49444d7cc] xfs: remove the extsize argument to xfs_eof_alignment
      [88cdb7147b21] xfs: slightly tweak an assert in xfs_fs_map_blocks
      [307cdb54b80e] xfs: don't log the inode in xfs_fs_map_blocks if it
      [e696663a97e8] xfs: simplify the xfs_iomap_write_direct calling
      [be6cacbeea8c] xfs: refactor xfs_bmapi_allocate
      [fd638f1de1f3] xfs: move extent zeroing to xfs_bmapi_allocate
      [c34d570d1586] xfs: cleanup use of the XFS_ALLOC_ flags
      [a39f089a25e7] xfs: move incore structures out of xfs_da_format.h
      [b16be561876e] xfs: use unsigned int for all size values in struct xfs_da_geometry
      [649d9d98c60e] xfs: refactor btree node scrubbing
      [f475dc4dc7cc] xfs: devirtualize ->node_hdr_from_disk
      [e1c8af1e02c7] xfs: devirtualize ->node_hdr_to_disk
      [51908ca75feb] xfs: add a btree entries pointer to struct xfs_da3_icnode_hdr
      [3b34441309f3] xfs: move the node header size to struct xfs_da_geometry
      [518425560a8b] xfs: devirtualize ->leaf_hdr_from_disk
      [163fbbb3568b] xfs: devirtualize ->leaf_hdr_to_disk
      [787b0893ad1e] xfs: add an entries pointer to struct xfs_dir3_icleaf_hdr
      [545910bcc875] xfs: move the dir2 leaf header size to struct xfs_da_geometry
      [478c7835cb8e] xfs: move the max dir2 leaf entries count to struct xfs_da_geometry
      [5ba30919a6fc] xfs: devirtualize ->free_hdr_from_disk
      [200dada70008] xfs: devirtualize ->free_hdr_to_disk
      [195b0a44ab73] xfs: make the xfs_dir3_icfree_hdr available to xfs_dir2_node_addname_int
      [a84f3d5cb04f] xfs: add a bests pointer to struct xfs_dir3_icfree_hdr
      [ed1d612fbe6b] xfs: move the dir2 free header size to struct xfs_da_geometry
      [5893e4feb0ea] xfs: move the max dir2 free bests count to struct xfs_da_geometry
      [3d92c93b7065] xfs: devirtualize ->db_to_fdb and ->db_to_fdindex
      [84915e1bdddf] xfs: devirtualize ->sf_get_parent_ino and ->sf_put_parent_ino
      [50f6bb6b7aea] xfs: devirtualize ->sf_entsize and ->sf_nextentry
      [93b1e96a4200] xfs: devirtualize ->sf_get_ino and ->sf_put_ino
      [4501ed2a3a86] xfs: devirtualize ->sf_get_ftype and ->sf_put_ftype
      [c81484e2b97f] xfs: remove the unused ->data_first_entry_p method
      [1682310474b2] xfs: remove the data_dot_offset field in struct xfs_dir_ops
      [2eb68a5d3619] xfs: remove the data_dotdot_offset field in struct xfs_dir_ops
      [da3ca0df8bd1] xfs: remove the ->data_dot_entry_p and ->data_dotdot_entry_p methods
      [ee641d5af5e6] xfs: remove the ->data_unused_p method
      [263dde869bd0] xfs: cleanup xfs_dir2_block_getdents
      [2f4369a862b6] xfs: cleanup xfs_dir2_leaf_getdents
      [4c037dd5fd32] xfs: cleanup xchk_dir_rec
      [4a1a8b2f5f78] xfs: cleanup xchk_directory_data_bestfree
      [8073af5153ce] xfs: cleanup xfs_dir2_block_to_sf
      [62479f573459] xfs: cleanup xfs_dir2_data_freescan_int
      [48a71399e747] xfs: cleanup __xfs_dir3_data_check
      [9eedae10899a] xfs: remove the now unused ->data_entry_p method
      [5c072127d31d] xfs: replace xfs_dir3_data_endp with xfs_dir3_data_end_offset
      [fdbb8c5b805c] xfs: devirtualize ->data_entsize
      [7e8ae7bd1c5d] xfs: devirtualize ->data_entry_tag_p
      [d73e1cee8add] xfs: move the dir2 data block fixed offsets to struct xfs_da_geometry
      [711c7dbf5fda] xfs: cleanup xfs_dir2_data_entsize
      [1848b607a9ad] xfs: devirtualize ->data_bestfree_p
      [59b8b465058e] xfs: devirtualize ->data_get_ftype and ->data_put_ftype
      [957ee13e204a] xfs: remove the now unused dir ops infrastructure
      [ae42976de7f1] xfs: merge xfs_dir2_data_freescan and xfs_dir2_data_freescan_int
      [23220fe260c4] xfs: always pass a valid hdr to xfs_dir3_leaf_check_int

Colin Ian King (1):
      [0279c71fe0d1] xfs: remove redundant assignment to variable error

Dan Carpenter (1):
      [7f6bcf7c2941] xfs: remove a stray tab in xfs_remount_rw()

Darrick J. Wong (23):
      [9cd0ed63ca51] iomap: enhance writeback error message
      [c84760659dcf] xfs: check attribute leaf block structure
      [16c6e92c7e98] xfs: namecheck attribute names before listing them
      [04df34ac6494] xfs: namecheck directory entry names before listing them
      [c2414ad6e66a] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
      [fec40e220ffc] xfs: refactor xfs_bmap_count_blocks using newer btree helpers
      [e992ae8afded] xfs: refactor xfs_iread_extents to use xfs_btree_visit_blocks
      [e91ec882af21] xfs: relax shortform directory size checks
      [d243b89a611e] xfs: constify the buffer pointer arguments to error functions
      [a5155b870d68] xfs: always log corruption errors
      [ee4fb16cbec9] xfs: decrease indenting problems in xfs_dabuf_map
      [110f09cb705a] xfs: add missing assert in xfs_fsmap_owner_from_rmap
      [9842b56cd406] xfs: make the assertion message functions take a mount parameter
      [8ef34723eff0] xfs: add missing early termination checks to record scrubbing functions
      [5d1116d4c6af] xfs: periodically yield scrub threads to the scheduler
      [5f213ddbcbe8] xfs: fix missing header includes
      [f5be08446ee7] xfs: null out bma->prev if no previous extent
      [120254608f04] xfs: "optimize" buffer item log segment bitmap setting
      [d6abecb82573] xfs: range check ri_cnt when recovering log items
      [f755979355d4] xfs: annotate functions that trip static checker locking checks
      [5113f8ec3753] xfs: clean up weird while loop in xfs_alloc_ag_vextent_near
      [2fe4f92834c4] xfs: refactor "does this fork map blocks" predicate
      [895e196fb6f8] xfs: convert EIO to EFSCORRUPTED when log contents are invalid

Dave Chinner (4):
      [7684e2c4384d] iomap: iomap that extends beyond EOF should be marked dirty
      [3f8a4f1d876d] xfs: fix inode fork extent count overflow
      [1c743574de8b] xfs: cap longest free extent to maximum allocatable
      [249bd9087a52] xfs: properly serialise fallocate against AIO+DIO

Goldwyn Rodrigues (1):
      [c039b9979272] iomap: use a srcmap for a read-modify-write I/O

Ian Kent (18):
      [8da57c5c000c] xfs: remove the biosize mount option
      [f676c7508667] xfs: remove unused struct xfs_mount field m_fsname_len
      [e1d3d2188546] xfs: use super s_id instead of struct xfs_mount m_fsname
      [3d9d60d9addf] xfs: dont use XFS_IS_QUOTA_RUNNING() for option check
      [7b77b46a6137] xfs: use kmem functions for struct xfs_mount
      [a943f372c22b] xfs: merge freeing of mp names and mp
      [82332b6da226] xfs: add xfs_remount_rw() helper
      [2c6eba31775b] xfs: add xfs_remount_ro() helper
      [c0a6791667f8] xfs: refactor suffix_kstrtoint()
      [846410ccd104] xfs: avoid redundant checks when options is empty
      [48a06e1b5773] xfs: refactor xfs_parseags()
      [9a861816a026] xfs: move xfs_parseargs() validation to a helper
      [7c89fcb2783d] xfs: dont set sb in xfs_mount_alloc()
      [73e5fff98b64] xfs: switch to use the new mount-api
      [63cd1e9b026e] xfs: move xfs_fc_reconfigure() above xfs_fc_free()
      [2f8d66b3cd79] xfs: move xfs_fc_get_tree() above xfs_fc_reconfigure()
      [8757c38f2cf6] xfs: move xfs_fc_parse_param() above xfs_fc_get_tree()
      [50f8300904b1] xfs: fold xfs_mount-alloc() into xfs_init_fs_context()

Jan Kara (1):
      [3dd4d40b4208] xfs: Sanity check flags of Q_XQUOTARM call

Joe Perches (1):
      [cf085a1b5d22] xfs: Correct comment tyops -> typos

kaixuxia (1):
      [3fb21fc8cc04] xfs: remove the duplicated inode log fieldmask set

yu kuai (1):
      [e5e634041bc1] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS


Code Diffstat:

 fs/compat_ioctl.c               |   31 +-
 fs/dax.c                        |   13 +-
 fs/ext2/inode.c                 |    2 +-
 fs/ext4/inode.c                 |    2 +-
 fs/gfs2/bmap.c                  |    3 +-
 fs/ioctl.c                      |   12 +-
 fs/iomap/apply.c                |   25 +-
 fs/iomap/buffered-io.c          |  160 +++--
 fs/iomap/direct-io.c            |    2 +-
 fs/iomap/fiemap.c               |    4 +-
 fs/iomap/seek.c                 |    4 +-
 fs/iomap/swapfile.c             |    3 +-
 fs/xfs/Makefile                 |    1 -
 fs/xfs/kmem.c                   |    2 +-
 fs/xfs/libxfs/xfs_ag_resv.c     |    2 +
 fs/xfs/libxfs/xfs_alloc.c       | 1001 +++++++++++++++++-------------
 fs/xfs/libxfs/xfs_alloc.h       |   16 +-
 fs/xfs/libxfs/xfs_alloc_btree.c |    1 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |  109 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   27 +-
 fs/xfs/libxfs/xfs_attr_remote.c |    1 +
 fs/xfs/libxfs/xfs_bit.c         |    1 +
 fs/xfs/libxfs/xfs_bmap.c        |  349 +++++------
 fs/xfs/libxfs/xfs_btree.c       |   15 +-
 fs/xfs/libxfs/xfs_btree.h       |   12 +-
 fs/xfs/libxfs/xfs_da_btree.c    |  273 ++++----
 fs/xfs/libxfs/xfs_da_btree.h    |   41 +-
 fs/xfs/libxfs/xfs_da_format.c   |  888 ---------------------------
 fs/xfs/libxfs/xfs_da_format.h   |   59 +-
 fs/xfs/libxfs/xfs_dir2.c        |   35 +-
 fs/xfs/libxfs/xfs_dir2.h        |   88 +--
 fs/xfs/libxfs/xfs_dir2_block.c  |  124 ++--
 fs/xfs/libxfs/xfs_dir2_data.c   |  267 ++++----
 fs/xfs/libxfs/xfs_dir2_leaf.c   |  284 +++++----
 fs/xfs/libxfs/xfs_dir2_node.c   |  404 ++++++------
 fs/xfs/libxfs/xfs_dir2_priv.h   |   74 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  393 +++++++-----
 fs/xfs/libxfs/xfs_fs.h          |    2 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   14 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |   18 +-
 fs/xfs/libxfs/xfs_log_format.h  |    4 +-
 fs/xfs/libxfs/xfs_refcount.c    |    4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |    6 +-
 fs/xfs/libxfs/xfs_sb.c          |    1 +
 fs/xfs/scrub/attr.c             |   11 +-
 fs/xfs/scrub/bitmap.c           |    3 +-
 fs/xfs/scrub/common.h           |    9 +-
 fs/xfs/scrub/dabtree.c          |   58 +-
 fs/xfs/scrub/dabtree.h          |    3 +-
 fs/xfs/scrub/dir.c              |  121 ++--
 fs/xfs/scrub/fscounters.c       |    8 +-
 fs/xfs/scrub/health.c           |    1 +
 fs/xfs/scrub/quota.c            |    7 +
 fs/xfs/scrub/scrub.c            |    1 +
 fs/xfs/xfs_acl.c                |   18 +-
 fs/xfs/xfs_aops.c               |   43 +-
 fs/xfs/xfs_aops.h               |    3 -
 fs/xfs/xfs_attr_inactive.c      |   44 +-
 fs/xfs/xfs_attr_list.c          |   69 ++-
 fs/xfs/xfs_bmap_item.c          |    7 +-
 fs/xfs/xfs_bmap_util.c          |  247 +-------
 fs/xfs/xfs_bmap_util.h          |    4 -
 fs/xfs/xfs_buf.c                |   19 +-
 fs/xfs/xfs_buf.h                |    1 -
 fs/xfs/xfs_buf_item.c           |    2 +-
 fs/xfs/xfs_dir2_readdir.c       |  133 ++--
 fs/xfs/xfs_discard.c            |    1 +
 fs/xfs/xfs_dquot.c              |    6 +-
 fs/xfs/xfs_error.c              |   29 +-
 fs/xfs/xfs_error.h              |    7 +-
 fs/xfs/xfs_extent_busy.c        |    2 +-
 fs/xfs/xfs_extfree_item.c       |    5 +-
 fs/xfs/xfs_file.c               |  102 ++-
 fs/xfs/xfs_filestream.c         |    2 +-
 fs/xfs/xfs_fsmap.c              |    1 +
 fs/xfs/xfs_inode.c              |   22 +-
 fs/xfs/xfs_inode.h              |   10 +-
 fs/xfs/xfs_inode_item.c         |    5 +-
 fs/xfs/xfs_ioctl.c              |  101 +--
 fs/xfs/xfs_ioctl.h              |    1 -
 fs/xfs/xfs_ioctl32.c            |    9 +-
 fs/xfs/xfs_iomap.c              |  861 +++++++++++++-------------
 fs/xfs/xfs_iomap.h              |   11 +-
 fs/xfs/xfs_iops.c               |   67 +-
 fs/xfs/xfs_linux.h              |    6 +-
 fs/xfs/xfs_log.c                |  432 ++++++-------
 fs/xfs/xfs_log_cil.c            |    6 +-
 fs/xfs/xfs_log_priv.h           |   31 +-
 fs/xfs/xfs_log_recover.c        |   66 +-
 fs/xfs/xfs_message.c            |   22 +-
 fs/xfs/xfs_message.h            |    6 +-
 fs/xfs/xfs_mount.c              |   51 +-
 fs/xfs/xfs_mount.h              |   53 +-
 fs/xfs/xfs_pnfs.c               |   56 +-
 fs/xfs/xfs_qm.c                 |   13 +-
 fs/xfs/xfs_quotaops.c           |    3 +
 fs/xfs/xfs_refcount_item.c      |    5 +-
 fs/xfs/xfs_reflink.c            |  138 +----
 fs/xfs/xfs_reflink.h            |    4 +-
 fs/xfs/xfs_rmap_item.c          |    9 +-
 fs/xfs/xfs_rtalloc.c            |    3 +-
 fs/xfs/xfs_super.c              | 1297 +++++++++++++++++++--------------------
 fs/xfs/xfs_super.h              |   10 +
 fs/xfs/xfs_symlink.c            |    1 +
 fs/xfs/xfs_symlink.h            |    2 +-
 fs/xfs/xfs_trace.h              |   35 +-
 fs/xfs/xfs_trans_ail.c          |   10 +-
 fs/xfs/xfs_xattr.c              |    1 +
 include/linux/falloc.h          |    3 +
 include/linux/fs.h              |    2 +-
 include/linux/iomap.h           |   48 +-
 112 files changed, 4192 insertions(+), 4954 deletions(-)
 delete mode 100644 fs/xfs/libxfs/xfs_da_format.c
