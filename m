Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824FFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E87D2075F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n9nOOTgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgESQOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:14:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgESQOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:14:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGD9ES142719
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=VGq5QU4pr9O/GfNXJvw1EN9vY+FV39iZDV4kipUYENI=;
 b=n9nOOTgT4Aupk7kJuEC+czK3z3ERu+awxNGx3VyQJUZe7ZmTMDwKtc+al7yphRrqR0wl
 JurLN6wqnv7sgJVyub2uT/un0ypuLmcywC016ZE/AjxrFZYskRvn/aXdazt6BZ4gGqeH
 uxJdLEi3H5jgdU/knAH3A40ElF61kenPfHHK6KTaqScl+yxJ+KHzxvipvBB7u3hMTn5p
 OC4Q81s6XuqToiKZPfGN7p12ehRvDAQqgAdD2HaD3miQC758Vn9/E8YLDF9BUqN3rCru
 l0ts7Vwr97C1YXCsayKlA/YwknRwRg5YSx+E88tJKtp5ZrJIsI+lGEfXZtbeUDP1IJYf CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kr6dh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:14:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGCaQM093604
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:14:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj1xbsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:14:07 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JGE7UO008334
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 16:14:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:14:07 -0700
Date:   Tue, 19 May 2020 09:14:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 188b1f949bde
Message-ID: <20200519161404.GJ17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=2 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=2 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190137
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
the next update.  Still clanking through Eric's quota series and the
delalloc/unwritten series...

The new head of the for-next branch is commit:

188b1f949bde xfs: cleanup xfs_idestroy_fork

New Commits:

Arnd Bergmann (1):
      [166405f6b53b] xfs: stop CONFIG_XFS_DEBUG from changing compiler flags

Brian Foster (19):
      [cb6ad0993eb8] xfs: refactor failed buffer resubmission into xfsaild
      [54b3b1f619ef] xfs: factor out buffer I/O failure code
      [f20192991d79] xfs: simplify inode flush error handling
      [15fab3b9be22] xfs: remove unnecessary shutdown check from xfs_iflush()
      [b6983e80b03b] xfs: reset buffer write failure state on successful completion
      [f9bccfcc3b59] xfs: refactor ratelimited buffer error messages into helper
      [61948b6fb276] xfs: ratelimit unmount time per-buffer I/O error alert
      [629dcb38dc35] xfs: fix duplicate verification from xfs_qm_dqflush()
      [b707fffda6a3] xfs: abort consistently on dquot flush failure
      [849274c103ae] xfs: acquire ->ail_lock from xfs_trans_ail_delete()
      [655879290c28] xfs: use delete helper for items expected to be in AIL
      [6af0479d8b6b] xfs: drop unused shutdown parameter from xfs_trans_ail_remove()
      [2b3cf09356d5] xfs: combine xfs_trans_ail_[remove|delete]()
      [88fc187984c9] xfs: remove unused iflush stale parameter
      [7376d7454734] xfs: random buffer write failure errortag
      [28d84620797e] xfs: remove unused shutdown types
      [c199507993ed] xfs: remove unused iget_flags param from xfs_imap_to_bp()
      [43dc0aa84ef7] xfs: fix unused variable warning in buffer completion on !DEBUG
      [c61b0b17a5c1] xfs: don't fail verifier on empty attr3 leaf block

Chen Zhou (1):
      [3d60548b216b] xfs: remove duplicate headers

Christoph Hellwig (33):
      [e968350aadf3] xfs: refactor the buffer cancellation table helpers
      [5ce70b770d16] xfs: rename inode_list xlog_recover_reorder_trans
      [7d4894b4ce07] xfs: factor out a xlog_buf_readahead helper
      [f15ab3f60ef3] xfs: simplify xlog_recover_inode_ra_pass2
      [98b69b1285be] xfs: refactor xlog_recover_buffer_pass1
      [82ff450b2d93] xfs: remove the xfs_efi_log_item_t typedef
      [c84e819090f3] xfs: remove the xfs_efd_log_item_t typedef
      [fd9cbe512151] xfs: remove the xfs_inode_log_item_t typedef
      [e046e949486e] xfs: factor out a xfs_defer_create_intent helper
      [c1f09188e8de] xfs: merge the ->log_item defer op into ->create_intent
      [d367a868e46b] xfs: merge the ->diff_items defer op into ->create_intent
      [13a833333907] xfs: turn dfp_intent into a xfs_log_item
      [bb47d79750f1] xfs: refactor xfs_defer_finish_noroll
      [f09d167c2033] xfs: turn dfp_done into a xfs_log_item
      [3ec1b26c04d4] xfs: use a xfs_btree_cur for the ->finish_cleanup state
      [2f88f1efd02d] xfs: spell out the parameter name for ->cancel_item
      [ee0d0dbcfe19] xfs: xfs_bmapi_read doesn't take a fork id as the last argument
      [f5d7d422c81c] xfs: call xfs_iformat_fork from xfs_inode_from_disk
      [980f26097db7] xfs: split xfs_iformat_fork
      [deaae0f84fdc] xfs: handle unallocated inodes in xfs_inode_from_disk
      [a0070f456d70] xfs: call xfs_dinode_verify from xfs_inode_from_disk
      [0561e88beb54] xfs: don't reset i_delayed_blks in xfs_iread
      [e700fa3913bb] xfs: remove xfs_iread
      [63ec6a4b2d6a] xfs: remove xfs_ifork_ops
      [411d0c362c44] xfs: refactor xfs_inode_verify_forks
      [fdf080bf439c] xfs: improve local fork verification
      [1405c18793c0] xfs: remove the special COW fork handling in xfs_bmapi_read
      [1dd19ee9233d] xfs: remove the NULL fork handling in xfs_bmapi_read
      [f0423a69ff83] xfs: remove the XFS_DFORK_Q macro
      [a136c7a77ebd] xfs: remove xfs_ifree_local_data
      [0042f9de0246] xfs: move the per-fork nextents fields into struct xfs_ifork
      [d66bc96d2cb5] xfs: move the fork format fields into struct xfs_ifork
      [188b1f949bde] xfs: cleanup xfs_idestroy_fork

Darrick J. Wong (30):
      [0d2d35a33ea7] xfs: report unrecognized log item type codes during recovery
      [8bc3b5e4b70d] xfs: clean up the error handling in xfs_swap_extents
      [35f4521fd3a0] xfs: convert xfs_log_recover_item_t to struct xfs_log_recover_item
      [86ffa471d9ce] xfs: refactor log recovery item sorting into a generic dispatch structure
      [8ea5682d0711] xfs: refactor log recovery item dispatch for pass2 readhead functions
      [3304a4fabd09] xfs: refactor log recovery item dispatch for pass1 commit functions
      [1094d3f12363] xfs: refactor log recovery buffer item dispatch for pass2 commit functions
      [658fa68b6f34] xfs: refactor log recovery inode item dispatch for pass2 commit functions
      [fcbdf91e0c9f] xfs: refactor log recovery dquot item dispatch for pass2 commit functions
      [3ec6efa703cf] xfs: refactor log recovery icreate item dispatch for pass2 commit functions
      [9817aa80dcdc] xfs: refactor log recovery EFI item dispatch for pass2 commit functions
      [07590a9d38b8] xfs: refactor log recovery RUI item dispatch for pass2 commit functions
      [9b4467e98340] xfs: refactor log recovery CUI item dispatch for pass2 commit functions
      [3c6ba3cf90c7] xfs: refactor log recovery BUI item dispatch for pass2 commit functions
      [2565a11b224b] xfs: remove log recovery quotaoff item dispatch for pass2 commit functions
      [10d0c6e06fc8] xfs: refactor recovered EFI log item playback
      [cba0ccac28a7] xfs: refactor recovered RUI log item playback
      [c57ed2f5a2ff] xfs: refactor recovered CUI log item playback
      [9329ba89cbb1] xfs: refactor recovered BUI log item playback
      [bba7b1644a25] xfs: refactor xlog_item_is_intent now that we're done converting
      [154c733a33d9] xfs: refactor releasing finished intents during log recovery
      [86a371741386] xfs: refactor adding recovered intent items to the log
      [889eb55dd68f] xfs: refactor intent item RECOVERED flag into the log item
      [96b60f826713] xfs: refactor intent item iop_recover calls
      [cc560a5a9540] xfs: hoist setting of XFS_LI_RECOVERED to caller
      [17d29bf271ea] xfs: move log recovery buffer cancellation code to xfs_buf_item_recover.c
      [6ea670ade207] xfs: remove unnecessary includes from xfs_log_recover.c
      [4b1d64b072ac] xfs: use ordered buffers to initialize dquot buffers during quotacheck
      [444f17be1a16] xfs: don't allow SWAPEXT if we'd screw up quota accounting
      [1d5361955f18] xfs: clean up xchk_bmap_check_rmaps usage of XFS_IFORK_Q

Eric Sandeen (1):
      [ec43f6da31f1] xfs: define printk_once variants for xfs messages

Gustavo A. R. Silva (1):
      [ee4064e56cd8] xfs: Replace zero-length array with flexible-array

Ira Weiny (5):
      [d45344d6c49c] fs/xfs: Remove unnecessary initialization of i_rwsem
      [606723d98293] fs/xfs: Change XFS_MOUNT_DAX to XFS_MOUNT_DAX_ALWAYS
      [8d6c3446ec23] fs/xfs: Make DAX mount option a tri-state
      [32dbc5655f1c] fs/xfs: Create function xfs_inode_should_enable_dax()
      [840d493dff1a] fs/xfs: Combine xfs_diflags_to_linux() and xfs_diflags_to_iflags()

Kaixu Xia (8):
      [c140735bbb65] xfs: trace quota allocations for all quota types
      [d51bafe0d227] xfs: combine two if statements with same condition
      [fb353ff19d34] xfs: reserve quota inode transaction space only when needed
      [ea1c90403d5d] xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
      [7994aae8516a] xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
      [cd59455980f9] xfs: simplify the flags setting in xfs_qm_scall_quotaon
      [57fd2d8f61a2] xfs: remove unnecessary check of the variable resblks in xfs_symlink
      [5f2d90d7d040] xfs: fix the warning message in xfs_validate_sb_common()

Nishad Kamdar (1):
      [508578f2f560] xfs: Use the correct style for SPDX License Identifier

Zheng Bin (1):
      [237aac4624aa] xfs: ensure f_bfree returned by statfs() is non-negative


Code Diffstat:

 .../filesystems/xfs-self-describing-metadata.txt   |   10 +-
 fs/xfs/Makefile                                    |    5 +-
 fs/xfs/kmem.h                                      |    2 +-
 fs/xfs/libxfs/xfs_ag_resv.h                        |    2 +-
 fs/xfs/libxfs/xfs_alloc.h                          |    2 +-
 fs/xfs/libxfs/xfs_alloc_btree.h                    |    2 +-
 fs/xfs/libxfs/xfs_attr.c                           |   16 +-
 fs/xfs/libxfs/xfs_attr.h                           |    2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   50 +-
 fs/xfs/libxfs/xfs_attr_leaf.h                      |    2 +-
 fs/xfs/libxfs/xfs_attr_remote.h                    |    2 +-
 fs/xfs/libxfs/xfs_attr_sf.h                        |    2 +-
 fs/xfs/libxfs/xfs_bit.h                            |    2 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  281 +--
 fs/xfs/libxfs/xfs_bmap.h                           |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                     |    5 +-
 fs/xfs/libxfs/xfs_bmap_btree.h                     |    2 +-
 fs/xfs/libxfs/xfs_btree.h                          |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h                       |    2 +-
 fs/xfs/libxfs/xfs_da_format.h                      |    2 +-
 fs/xfs/libxfs/xfs_defer.c                          |  162 +-
 fs/xfs/libxfs/xfs_defer.h                          |   26 +-
 fs/xfs/libxfs/xfs_dir2.c                           |    8 +-
 fs/xfs/libxfs/xfs_dir2.h                           |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c                     |    2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h                      |    2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                        |   13 +-
 fs/xfs/libxfs/xfs_errortag.h                       |    6 +-
 fs/xfs/libxfs/xfs_format.h                         |    9 +-
 fs/xfs/libxfs/xfs_fs.h                             |    2 +-
 fs/xfs/libxfs/xfs_health.h                         |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |  186 +-
 fs/xfs/libxfs/xfs_inode_buf.h                      |   10 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |  320 ++-
 fs/xfs/libxfs/xfs_inode_fork.h                     |   68 +-
 fs/xfs/libxfs/xfs_log_recover.h                    |   83 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |    2 +-
 fs/xfs/libxfs/xfs_sb.c                             |    2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   14 +-
 fs/xfs/libxfs/xfs_trans_inode.c                    |    2 +-
 fs/xfs/scrub/bmap.c                                |   40 +-
 fs/xfs/scrub/dabtree.c                             |    2 +-
 fs/xfs/scrub/dir.c                                 |    7 +-
 fs/xfs/scrub/ialloc.c                              |    3 +-
 fs/xfs/scrub/parent.c                              |    2 +-
 fs/xfs/xfs_aops.c                                  |    2 +-
 fs/xfs/xfs_attr_inactive.c                         |    9 +-
 fs/xfs/xfs_attr_list.c                             |    4 +-
 fs/xfs/xfs_bmap_item.c                             |  237 +-
 fs/xfs/xfs_bmap_item.h                             |   11 -
 fs/xfs/xfs_bmap_util.c                             |   79 +-
 fs/xfs/xfs_buf.c                                   |   70 +-
 fs/xfs/xfs_buf.h                                   |    2 +
 fs/xfs/xfs_buf_item.c                              |  106 +-
 fs/xfs/xfs_buf_item.h                              |    2 -
 fs/xfs/xfs_buf_item_recover.c                      |  984 ++++++++
 fs/xfs/xfs_dir2_readdir.c                          |    2 +-
 fs/xfs/xfs_dquot.c                                 |  103 +-
 fs/xfs/xfs_dquot_item.c                            |   17 +-
 fs/xfs/xfs_dquot_item_recover.c                    |  201 ++
 fs/xfs/xfs_error.c                                 |    3 +
 fs/xfs/xfs_extfree_item.c                          |  216 +-
 fs/xfs/xfs_extfree_item.h                          |   25 +-
 fs/xfs/xfs_file.c                                  |    2 +-
 fs/xfs/xfs_fsops.c                                 |    5 +-
 fs/xfs/xfs_icache.c                                |   58 +-
 fs/xfs/xfs_icreate_item.c                          |  152 ++
 fs/xfs/xfs_inode.c                                 |  263 +-
 fs/xfs/xfs_inode.h                                 |    6 +-
 fs/xfs/xfs_inode_item.c                            |   54 +-
 fs/xfs/xfs_inode_item.h                            |    6 +-
 fs/xfs/xfs_inode_item_recover.c                    |  394 +++
 fs/xfs/xfs_ioctl.c                                 |   65 +-
 fs/xfs/xfs_iomap.c                                 |    6 +-
 fs/xfs/xfs_iops.c                                  |   77 +-
 fs/xfs/xfs_itable.c                                |    6 +-
 fs/xfs/xfs_log_recover.c                           | 2561 ++------------------
 fs/xfs/xfs_message.c                               |   22 +
 fs/xfs/xfs_message.h                               |   24 +-
 fs/xfs/xfs_mount.c                                 |    7 +-
 fs/xfs/xfs_mount.h                                 |    6 +-
 fs/xfs/xfs_pnfs.c                                  |    5 +-
 fs/xfs/xfs_qm.c                                    |    7 +-
 fs/xfs/xfs_qm_syscalls.c                           |    8 +-
 fs/xfs/xfs_quotaops.c                              |    2 +-
 fs/xfs/xfs_refcount_item.c                         |  252 +-
 fs/xfs/xfs_refcount_item.h                         |   11 -
 fs/xfs/xfs_rmap_item.c                             |  229 +-
 fs/xfs/xfs_rmap_item.h                             |   13 -
 fs/xfs/xfs_super.c                                 |   51 +-
 fs/xfs/xfs_symlink.c                               |   10 +-
 fs/xfs/xfs_trace.h                                 |    4 +-
 fs/xfs/xfs_trans.h                                 |    6 +-
 fs/xfs/xfs_trans_ail.c                             |   79 +-
 fs/xfs/xfs_trans_priv.h                            |   21 +-
 fs/xfs/xfs_xattr.c                                 |    1 -
 96 files changed, 3717 insertions(+), 4139 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_item_recover.c
 create mode 100644 fs/xfs/xfs_dquot_item_recover.c
 create mode 100644 fs/xfs/xfs_inode_item_recover.c
