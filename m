Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9952EC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 22:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F3C66135C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 22:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbhDLWXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:23:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:43482 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241651AbhDLWXQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Apr 2021 18:23:16 -0400
IronPort-SDR: /EVVnMHy/o1k7CeA/aqM3h1VeAeK074T7icaCcmuiQRfjUkxMAl5LH2maQhPJi1vJS8mekfmzT
 OPXgJfB5A//w==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="174388814"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="gz'50?scan'50,208,50";a="174388814"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 15:22:55 -0700
IronPort-SDR: EMnR5i4dzOaQFCe4bgWYSOojqINW2p7/WrICWVd2bJ/zds/m8CfAlXI0q4bHnS/Aqo169ryrQ+
 ILXuchHLnAZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="gz'50?scan'50,208,50";a="460344846"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2021 15:22:51 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lW4xG-0000fh-He; Mon, 12 Apr 2021 22:22:50 +0000
Date:   Tue, 13 Apr 2021 06:21:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH v3 2/2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <202104130641.CXaGdXDk-lkp@intel.com>
References: <20210412133059.1186634-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20210412133059.1186634-3-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Brian,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on v5.12-rc7 next-20210412]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Brian-Foster/xfs-set-aside-allocation-btree-blocks-from-block-reservation/20210412-213222
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: um-randconfig-r022-20210412 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/5ffa1f5fa63a4a9c557f90beb5826866fa4aefd0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Brian-Foster/xfs-set-aside-allocation-btree-blocks-from-block-reservation/20210412-213222
        git checkout 5ffa1f5fa63a4a9c557f90beb5826866fa4aefd0
        # save the attached .config to linux build tree
        make W=1 ARCH=um 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   syscall.c:(.text+0xa023): undefined reference to `atomic64_inc_386'
   /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_link_put':
   syscall.c:(.text+0xa036): undefined reference to `atomic64_dec_return_386'
   /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_tracing_prog_attach':
   syscall.c:(.text+0xa423): undefined reference to `atomic64_set_386'
   /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_link_get_from_fd':
   syscall.c:(.text+0xa8a7): undefined reference to `atomic64_inc_386'
   /usr/bin/ld: kernel/bpf/bpf_iter.o: in function `prepare_seq_file':
   bpf_iter.c:(.text+0x1b2): undefined reference to `atomic64_inc_return_386'
   /usr/bin/ld: fs/proc/task_mmu.o: in function `task_mem':
   task_mmu.c:(.text+0x2bfd): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/ext4/balloc.o: in function `ext4_has_free_clusters':
   balloc.c:(.text+0x94): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/ext4/dir.o: in function `ext4_dir_llseek':
   dir.c:(.text+0x2d3): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/ext4/dir.o: in function `ext4_readdir':
   dir.c:(.text+0x84b): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xc71): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xc9f): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: dir.c:(.text+0xe1b): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xe44): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xe72): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/ialloc.o: in function `get_orlov_stats':
   ialloc.c:(.text+0x205): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/ext4/inline.o: in function `ext4_add_dirent_to_inline.isra.0':
   inline.c:(.text+0x14a9): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inline.c:(.text+0x14df): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/inline.o: in function `ext4_read_inline_dir':
   inline.c:(.text+0x3dd8): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inline.c:(.text+0x3ea7): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inline.c:(.text+0x3ed5): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/inode.o: in function `ext4_do_update_inode':
   inode.c:(.text+0x3f13): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inode.c:(.text+0x44bb): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/ext4/inode.o: in function `__ext4_iget':
   inode.c:(.text+0x7c4d): undefined reference to `atomic64_set_386'
   /usr/bin/ld: inode.c:(.text+0x8385): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/ext4/inode.o: in function `ext4_mark_iloc_dirty':
   inode.c:(.text+0x8a69): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inode.c:(.text+0x8aa0): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/inode.o: in function `ext4_setattr':
   inode.c:(.text+0xf4ed): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inode.c:(.text+0xf523): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/ioctl.o: in function `swap_inode_boot_loader':
   ioctl.c:(.text+0x1794): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/ext4/namei.o: in function `ext4_setent':
   namei.c:(.text+0x2a0a): undefined reference to `atomic64_read_386'
   /usr/bin/ld: namei.c:(.text+0x2a41): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/namei.o: in function `add_dirent_to_buf':
   namei.c:(.text+0x498c): undefined reference to `atomic64_read_386'
   /usr/bin/ld: namei.c:(.text+0x49c3): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/namei.o: in function `ext4_generic_delete_entry':
   namei.c:(.text+0x7452): undefined reference to `atomic64_read_386'
   /usr/bin/ld: namei.c:(.text+0x7488): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/namei.o: in function `ext4_rmdir':
   namei.c:(.text+0x9f2d): undefined reference to `atomic64_read_386'
   /usr/bin/ld: namei.c:(.text+0x9f63): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ext4/resize.o: in function `ext4_update_super.isra.0':
   resize.c:(.text+0x2566): undefined reference to `atomic64_add_386'
   /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_iget':
   xattr.c:(.text+0x6b6): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_update_ref':
   xattr.c:(.text+0x776): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xattr.c:(.text+0x79f): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_lookup_create':
   xattr.c:(.text+0x2baf): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/fat/dir.o: in function `fat_remove_entries':
   dir.c:(.text+0x2cf0): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0x2d27): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/fat/misc.o: in function `fat_update_time':
   misc.c:(.text+0x721): undefined reference to `atomic64_read_386'
   /usr/bin/ld: misc.c:(.text+0x75e): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ufs/dir.o: in function `ufs_commit_chunk':
   dir.c:(.text+0x24): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0x5b): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ufs/dir.o: in function `ufs_readdir':
   dir.c:(.text+0x62e): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xa43): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0xa71): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/ufs/inode.o: in function `ufs_iget':
   inode.c:(.text+0x4331): undefined reference to `atomic64_read_386'
   /usr/bin/ld: inode.c:(.text+0x4365): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/affs/dir.o: in function `affs_readdir':
   dir.c:(.text+0xf5): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0x480): undefined reference to `atomic64_read_386'
   /usr/bin/ld: dir.c:(.text+0x4ae): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/affs/amigaffs.o: in function `affs_remove_hash':
   amigaffs.c:(.text+0x180): undefined reference to `atomic64_read_386'
   /usr/bin/ld: amigaffs.c:(.text+0x1b6): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/affs/amigaffs.o: in function `affs_insert_hash':
   amigaffs.c:(.text+0x4ec): undefined reference to `atomic64_read_386'
   /usr/bin/ld: amigaffs.c:(.text+0x522): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_trace.o: in function `trace_event_raw_event_xfs_log_assign_tail_lsn':
   xfs_trace.c:(.text+0xe948): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_trace.c:(.text+0xe959): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_trace.o: in function `trace_event_raw_event_xfs_loggrant_class':
   xfs_trace.c:(.text+0x1126c): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_trace.c:(.text+0x11286): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_trace.c:(.text+0x112b2): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_alloc.o: in function `xfs_alloc_read_agf':
>> xfs_alloc.c:(.text+0x63db): undefined reference to `atomic64_add_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_alloc_btree.o: in function `xfs_allocbt_free_block':
>> xfs_alloc_btree.c:(.text+0x844): undefined reference to `atomic64_dec_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_alloc_btree.o: in function `xfs_allocbt_alloc_block':
>> xfs_alloc_btree.c:(.text+0x8d5): undefined reference to `atomic64_inc_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_inode_buf.o: in function `xfs_inode_to_disk':
   xfs_inode_buf.c:(.text+0x5e7): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_inode_buf.o: in function `xfs_inode_from_disk':
   xfs_inode_buf.c:(.text+0x1409): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/libxfs/xfs_trans_inode.o: in function `xfs_trans_log_inode':
   xfs_trans_inode.c:(.text+0x490): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_trans_inode.c:(.text+0x4d8): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_icache.o: in function `xfs_iget_cache_hit':
   xfs_icache.c:(.text+0x1d0c): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_icache.c:(.text+0x1d78): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_iops.o: in function `xfs_vn_update_time':
   xfs_iops.c:(.text+0xab2): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_iops.c:(.text+0xaf8): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_inode.o: in function `xfs_init_new_inode':
   xfs_inode.c:(.text+0x27d): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_mount.o: in function `xfs_mod_fdblocks':
>> xfs_mount.c:(.text+0x24a2): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `write_grant_head_show':
   xfs_sysfs.c:(.text+0x160): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `reserve_grant_head_show':
   xfs_sysfs.c:(.text+0x1a6): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `log_tail_lsn_show':
   xfs_sysfs.c:(.text+0x1ec): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_space_left':
   xfs_log.c:(.text+0x2cf): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_log.o:xfs_log.c:(.text+0x2e1): more undefined references to `atomic64_read_386' follow
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_grant_head_init':
   xfs_log.c:(.text+0x4e5): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_alloc_log':
   xfs_log.c:(.text+0xceb): undefined reference to `atomic64_set_386'
   /usr/bin/ld: xfs_log.c:(.text+0xcf6): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_assign_tail_lsn_locked':
   xfs_log.c:(.text+0x1951): undefined reference to `atomic64_set_386'
   /usr/bin/ld: xfs_log.c:(.text+0x196d): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_grant_push_threshold':
   xfs_log.c:(.text+0x1cc5): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x1ceb): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_regrant':
   xfs_log.c:(.text+0x258d): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x25b2): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_state_do_callback':
   xfs_log.c:(.text+0x27ab): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x2820): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_sync':
   xfs_log.c:(.text+0x310e): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x3134): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: xfs_log.c:(.text+0x3243): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x3269): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_ticket_regrant':
   xfs_log.c:(.text+0x5483): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x54be): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: xfs_log.c:(.text+0x54e7): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x5522): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: xfs_log.c:(.text+0x557f): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x559c): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_ticket_ungrant':
   xfs_log.c:(.text+0x5798): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x57d6): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: xfs_log.c:(.text+0x57f9): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x5834): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_reserve':
   xfs_log.c:(.text+0x5d14): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x5d39): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: xfs_log.c:(.text+0x5da8): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log.c:(.text+0x5dcd): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/xfs/xfs_inode_item.o: in function `xfs_inode_item_format':
   xfs_inode_item.c:(.text+0x1da9): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_set_state':
   xfs_log_recover.c:(.text+0x1e3): undefined reference to `atomic64_set_386'
   /usr/bin/ld: xfs_log_recover.c:(.text+0x1fd): undefined reference to `atomic64_set_386'
   /usr/bin/ld: xfs_log_recover.c:(.text+0x21c): undefined reference to `atomic64_set_386'
   /usr/bin/ld: xfs_log_recover.c:(.text+0x23b): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_check_unmount_rec':
   xfs_log_recover.c:(.text+0x460e): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/xfs/xfs_log_recover.o:xfs_log_recover.c:(.text+0x461f): more undefined references to `atomic64_set_386' follow
   /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_find_tail':
   xfs_log_recover.c:(.text+0x57be): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xfs_log_recover.c:(.text+0x597a): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_inode_add_blocks':
   inode.c:(.text+0x5c4): undefined reference to `atomic64_add_386'
   /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_inode_sub_blocks':
   inode.c:(.text+0x60f): undefined reference to `atomic64_sub_386'
   /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_new_inode':
   inode.c:(.text+0x738): undefined reference to `atomic64_inc_386'
   /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_evict_inode':
   inode.c:(.text+0x1d8e): undefined reference to `atomic64_dec_386'
   /usr/bin/ld: fs/nilfs2/the_nilfs.o: in function `nilfs_find_or_create_root':
   the_nilfs.c:(.text+0x17f0): undefined reference to `atomic64_set_386'
   /usr/bin/ld: the_nilfs.c:(.text+0x17fb): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/nilfs2/segment.o: in function `nilfs_segctor_do_construct':
   segment.c:(.text+0x4e4d): undefined reference to `atomic64_read_386'
   /usr/bin/ld: segment.c:(.text+0x4e61): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/nilfs2/ifile.o: in function `nilfs_ifile_count_free_inodes':
   ifile.c:(.text+0x380): undefined reference to `atomic64_read_386'
   /usr/bin/ld: fs/btrfs/ctree.o: in function `__tree_mod_log_insert':
   ctree.c:(.text+0x2f8): undefined reference to `atomic64_inc_return_386'
   /usr/bin/ld: fs/btrfs/ctree.o: in function `btrfs_get_tree_mod_seq':
   ctree.c:(.text+0x3f69): undefined reference to `atomic64_inc_return_386'
   /usr/bin/ld: fs/btrfs/transaction.o: in function `join_transaction':
   transaction.c:(.text+0x1109): undefined reference to `atomic64_set_386'
   /usr/bin/ld: fs/btrfs/xattr.o: in function `btrfs_xattr_handler_set_prop':
   xattr.c:(.text+0xec): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xattr.c:(.text+0x122): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/btrfs/xattr.o: in function `btrfs_setxattr_trans':
   xattr.c:(.text+0xc24): undefined reference to `atomic64_read_386'
   /usr/bin/ld: xattr.c:(.text+0xc5a): undefined reference to `cmpxchg8b_emu'
   /usr/bin/ld: fs/btrfs/volumes.o: in function `create_chunk':
   volumes.c:(.text+0x242c): undefined reference to `atomic64_sub_386'
   /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_remove_chunk':
   volumes.c:(.text+0x51e7): undefined reference to `atomic64_add_386'
   /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_shrink_device':
   volumes.c:(.text+0x7977): undefined reference to `atomic64_sub_386'
   /usr/bin/ld: volumes.c:(.text+0x7bcc): undefined reference to `atomic64_add_386'
   /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_init_new_device':
   volumes.c:(.text+0xdc15): undefined reference to `atomic64_add_386'
   /usr/bin/ld: volumes.c:(.text+0xeb10): undefined reference to `atomic64_sub_386'
   /usr/bin/ld: fs/btrfs/volumes.o: in function `read_one_dev':

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--IS0zKkzwUGydFO0o
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICI62dGAAAy5jb25maWcAnFxZc+M4kn6fX8GojtiYidjq1uFzN/wAgaCEEUHSBKjDLwy1
rapytMtySPJM1b/fTIAHQIKuiX1plzJxJBKJzC8TYP/2t98C8n4+fN+dnx93Ly8/g6/71/1x
d94/BV+eX/b/G4RpkKQqYCFXv0Pj+Pn1/ccf79+Dy9/Hk99Hn4+PF8Fyf3zdvwT08Prl+es7
dH4+vP7tt7/RNIn4vKS0XLFc8jQpFduou09fHx8/3wZ/D/d/Pu9eg9vfpzDMZPIP869PVjcu
yzmldz9r0rwd6u52NB2NmrYxSeYNqyHHIQ4xi8J2CCDVzSbTy9GkoVuMkSUCJUkZ82TZjmAR
S6mI4tThLYgsiRTlPFWpl8ET6MpaFs/vy3Wa4wygs9+Cudb/S3Dan9/fWi3O8nTJkhKUKEVm
9U64KlmyKkkOi+CCq7vx5KZZVUpJXC/r0ycfuSSFLeis4KAJSWJltQ9ZRIpY6ck85EUqVUIE
u/v099fD6/4fn2AVVRO5JlnwfApeD2dcUN1TbuWKZ5biKgL+pSpu6Wui6KK8L1hhaYzmqZSl
YCLNtyVRitAFMJs5C8liPvPMuiArBnqCAUkB1oxzkTiu9Q77EJze/zz9PJ3331u9z1nCck71
NslFuras0eLw5J+MKtSys69hKghP/F1CNivmkdSS71+fgsOXjgjdThS2bclWLFGyllk9f98f
Tz6xwSyXYCwMRFbt/ElaLh5KmgqhJW1UBsQM5khDTj16M714GDO7j6bardvR+HxR5kyCEAKM
zG1TLbUneT1ZljMmMgXD60Oil0mz4g+1O/0VnKFXsIMRTufd+RTsHh8P76/n59evnYVDh5JQ
mhaJ4snclnomQ5gipQwsCFoo7wIyyb1C/wdyaHlzWgTStyfJtgSeLQ/8LNkGlK98x8Q0trt3
SEQupR6jMhIPq0cqQuajq5xQ1ohXrdhdSSs2X5p/eITmywUjIey75XRTdCwRnB8egX+6bvea
Jwq8KIlYt83UaFI+fts/vb/sj8GX/e78ftyfNLmSzsNtfMQ8T4vMkiEjc1Zqi2B5SwUnQued
n+US/lgeMV5Wo1keSP8u1zlXbEbosseRdMGsqBMRnpcup1EljSBEkSRc81AtPPrM1WBPQ894
KD39Km4eCtITL4JD9qD10B0sZCtO2fBwcATw2PRGnGWRdzTwcT7DTumyaUOUJSDGEZmBJUrH
pStZJtJ7VjFqJL71QxjIgWNZAA+d36BOusxSMEF0VirNrRCjda1DY73zbUjbStixkIGjokSx
0LdlLCZb14JArzp85pZV6N9EwGgyLXLKrNCah+X8gTvzAmkGpIlvvrCMH+xtBsLmwfkZP6Sd
weKHC69CgfUglW9ZszRVpfm3g2zSDBw9f2BllOYYR+CPIAl1okW3mYR/+IGBE/91yC54OL6y
1Oma2qD37HQTAFU4GoWDOlD5DQ6oT+sCjmNsWUOWSr6poplF1d7Lhk6WWlgcgapsk5oRCUsv
nIkKAMSdn2CmneUbMhXZhi7sGbLUHkvyeUJiG+pqeW2Cxg42QS4cT0e4BQR5Wha5CZ41O1xx
WEKlLksRMMiM5Dm3VbvEJlsh+5TS0XVD1erBg6P4ijmbbW1QG8aBDAcwTknoNWLcZw1OI58h
L6lwjhbIz8LQPco6zlSJTbY/fjkcv+9eH/cB+9f+FUI+gQhEMegDirFD0n/Yo5ZkJcyu1JHJ
0peMi5lxoM45SkVGFGQDS++6ZUx8yBfHcnwYNINtyyEkViB+cDQdK2IuwUnCqUiFd3S72YLk
IYARx8yKKIqZCcGwkZB9gLd1jqFiQgcCzMF4xKGBg6UBsUU8dqxRwxXtvR0I7WZPemcKEX8+
ve0fn788PwaHN0xOTy0oA65lycKCRQBweeocEAORAKVHMZmD4yiyLM2tWIgAHQJDnwF5Il2a
3j1eA+8JZC05RBTYEid8LB7uxm2qm+QYg+Xd2CxucTidg7fj4XF/Oh2OwfnnmwGmDlyqV3dx
cyU33p1Glp9x+QFDSTrIE2JgpquhATM4B7wQnP+C/TFffMj1hzyxHBBpeT1Av/HTaV7I1BfX
BIvAqpmbdYk1T+gCAMzA7BV76ndxAqwk8XPmLA3ZfDP+gFvGA9tDtznfDCp5xQmdlpNh5oDC
MBQO9AJf4N+zzc1VfTg8GkUuR5eZ4GooAcBW5Q6XdpN4PMzD7rEOFTTNrAOHPKCWGbgdgxJl
IVw2WL5LoCJduRQB8E4UQueiERE83t5dNcGVTCdlxMCRO2gHm4J/MIL1yUSEfeJiO7c9ZU2m
YO+kyPsM8EKJFAxc7XTS5z4sSLrhie1Rf+lhLE+KC7ct/Opixn3QDPVjTz8tYwiDcZnNFZnF
zIqCulyDpTNJK4jTZeYM9wprUOWqQgrAYKTvYRdrxucL1y0roLv1PSx/0ZxnqlfdwzkiG/fA
X5m6VRFB5lyXsfJ7H/AAc4Vl6nBQphAnc/DjbV9BMsCynn6VXoyW5N203R1vcKvDXkC/7Y67
R0AcQbj/1/Pj3op7APFZnpeeJUgZe89jAtgVjoPrdBqEDGkq8qyYrbYdimop7SGHEyyGRk3S
2jydceBPCdlrasifvjz9z+i/4T/jT3YDw/sBa//e0GFlFf3t/POTbbeQgCU2YvH8LLHo6EJ6
NAgsJab2efHrvV3xiucKwbXwaxmlyZXP42lrl4WEUBZiSiL5zE5SKk6PYCX79c4IgGyMORAY
aJjtarq/JibKNVkyhDi+bDsTndGGUn9g0dg6but7WMsaUnUdITli4QqS3nUK4rvj47fn8/4R
vc7np/0b6BuAdR/RSabKqOslphPwRGUaRaV1/k1BWIpSpGFVDu/2WxMQCGsMGcnBzdS19M4Q
emcYRXD+AasEDOtUn3pdYpXWhc/aJ6RhAQ5RxyPMKXMnMMTQtsQC1BpAtyV6ik6MzysLmPYY
pFOrrrIKoyTMGztaAChc1WXtXUZbsNMXxy7M1tF09fnP3Wn/FPxlEiMIJF+eX0zFthkIm1W+
0Vt3/WgYR9t4QZTFxZwn3qTgFxZkVdwE5tx2HNLpqRSYho4sj212xwf4qn1ToDZQVLq0y4cz
1JxbH8rvTWbU0T6yJJUc9v2+YFK5nLrEt8ZI1a83zeTcS4Q8w1ecUmyec+WpWz2kTjpXk9Ui
T5WKuwX2HheWv/a6FL0EEeJ1mDlevtCHjdYz/8J5GkO+lNDtAJemUnVlg7FKcT8oj3Zb4D4G
G0gGkSAjfueNDcz9Xgli5dsMj1nvVGS74/kZTS5QAKacFA3UoLjS13LhCmtovvIFgMk5aZta
zkKGqfQxWMQdcnMyuqLYatQu3VyNpW2p3XK04h50bCqlISOhe61pMZfbme31avIsunc2J7ov
643TDbyuwBWl0YhMxu0ERVLtgcx4Ar/c09aGQ7029mP/+H7e/fmy1/fdgS7bnJ1NmfEkEgrd
r88+DdNARssODVlwO1FA9BAWVe2pWtDQ/FoAsf9+OP4MxO5193X/3RvtIjgCTpECCaVOioAM
eNTyO9WVKZd4bhwDkVkMnj9T2qXr+sJFp+ZEu6bcWOwc63YIAJ36DNhoTrpRBnLwufFz9s4v
pa+qVN8uIyrGZApORJjfXYxumywqYWBFAJh19rJ0AAiNGZweTPx8Vxm6VN62FaSPVvrcyHvJ
AlxMNuRdc6n1kKWpU6t8mBW+U/wwjSAaOw11fEn9NRW8fjXKxjrSEnTth2mQzGIuBwHBJ+8c
M0BWecXKAoeNzML+TPXcmIG2QXh8/pdxCy1ag1zEkIO0V28zgGHB4sx2Cg4Z1qkWeBvSzA8R
RYnMuwWw1CQksUFNrR5yM2DEcwHgiJmHDb01RM/H7//eHffBy2H3tD9ax2pdYnHZFrEh6W0I
8bbS8rAb2JZmNkf2tp++kjJL9CykbYcHLmdSOnNra7b3rSt74wzBhtY6Blv+ptEjhrcw5yt7
ZRWVrXL32s3Q0V6qLnDQRbpiQwnCPUSfZYEvUrCPL//VzGqsjNWmWBtnXQkFAzb3kJYGcjZ3
fJn5XfIJ7dPye2ttcELlAvZEb1jkXnoiM4JIbQ4V84NPv0Fr85m9n4KnbmYtFhymchRZkXxu
pprFHskCxon0gksV1uGrDeBvu+Opvoxo24F3utahf2AcG4Apu7YBLNCZvvL7gBXynFGFQcVg
2s9jd3ZnCAjFVfW/G9wHe4BrDdMk3np11l+7KXzAPwNxQIhgbl3Ucfd6etGv0oJ499PFMDAl
gB0wt84KOxg9sut0Se8XYHB7vznS/LerUVh2eLUfk1Fov4gS7pwoU5pmHSmz+t7a0WED9cDo
BZHKdTfmiQoRf+Sp+CN62Z2+BZAWvQVPjSO3zSPi7oz/ZCGjWZ7OmEuHw1t6yNAfoay+/E0T
2ZUU2Uk68EqsbjAD771VTD8m8w0QW/wPhpmzVDCVb7tDoMuYkQRSA3yBUQ5UzfsNB+rZ/YYD
lw79hgO3Ch4ZrwbW2Wmna6w9ffHxB1ri/i4XH3W56XZJlb+I1PTAAjeEzA8GJSKUKvTJAgGf
fNCxULxzbMDWu+Pk3otM7S9nEnCDHWc/OCr6KCWAP9xDg5ROqdDIsdas2nfnu3//AZ5r9/Ky
f9GjBF/MFIfX8/Hw8mKhKvF8evTMgf+RvMnTGKUg9Nfn131wen97OxzPnj7MflFrU+H8lAsi
RCehH2gCDspXpOy2nlVvM+tsxyNhzdN61OuIM4D6wX+Zv5MgoyL4bkCq10fpZu6a7sEDp40/
aqb49cD2IMWs4/uAUK5jLG3gu0oA73Y2UjeYsVn1EHcy6vIicMZuRlYx5nHB9GyO2vVwGIe8
hymNvOSqANPz+MlKsEA2ZtGq3aY3xtaHNSS8nFxuyjCzH5RaRBeKAewU2wqJtWGRytvpRF6M
/D4WgFicygLAOuBkDf+8zUgWytub0YTEPkzDZTy5HY2smqehTEZ23TWRaS5LBZzLy5Fz+VGx
Zovx9fXIF6arBlqK29HG7rwQ9Gp66XuhFcrx1Y193zapHgGYc8sydEgna3NqlWhOSdTEH0Qq
fszmhG4/aiHI5urm+tIjWtXgdko31mupigpRpLy5XWRMbno8xsaj0YVzut11mCfK+x+7U8Bf
T+fj+3f9EOb0DZKWp+CMqAzbBS/oDp7A6J7f8J+2cf4/erdpEOAegtEis+IBowvntsaxdfPk
lEpeUfpeVNdiRWpVQ3PCQ3yEnjvYRg/iw6y+0Rtn4CmyCjcEmjeJIVOMeoNniJeZjNjeMNQi
jnqUcZ/Sb3RxeeXQ9CM6nZ3bVF2osYuwba7qUAYvhSp2dfxl8+zJZRO5TSgmeVyqbm2p1lco
dKavuJfn5n6D4uhBIp76mhuHDOcpIXNIYvFHpxZjDcIxBnFpCwrkDC+RAJXjVZfz+BV4RQJr
45ldbweqLiU7FJmQzH3bD0S14BqErzheUjnlOByk2pQOBQK5ky6bV829HQQGm/kcLjJydxE0
du6wgCJ4nttPvoCE5uUQ8ErX7dQ3Npta3scdAVuW9D9oc9osvCUKpwlPSc8GYuJ3tMgshobU
X844+6zLUw4pismSbR0SvoZT244Ihmheym0ByaZqQeQCr/WG5Kp6RMyH2NCY1ly539AAER/k
a1MY2HT7wsjup2+LvJIoks+Z0sDYd9m/co4n/CwzOLk9HNPerfcgirKdUJHwze0NPkOwv0TQ
gXKQaO4x7yaXV9YtZ8gl1W538LWpfhkBk3tWVX1VkRbOxW/1FNB5dwKYh5PY3NG51SOLQ1Wu
Z0L04BWlel1AzbMOj0CLdfWQ09IUPjmoae2iYNXzjKfe0vzKXDnY9Vn8asJf8oC0x5T8vBGx
v59taEWZQFlwrPTj86Yia26lJrQfoB0QCj+gH8lDzAZcsrnx7tD009WVSxTFpp5QvL+cAWTs
f4CsODnFVNAnAXbSuusNVcaKXkxHziOpmpVRcnt54YfGbpsfPtxbtRDxhmbVvUKNcT6S2+5f
Vd+rLwKdyWVMBuq+yDWRsXuwPU1IPE+9VmBvptVx6r8MkZngPtuW9tt5QGr25pvnsoC+POm1
Jr88I8BsNxIHQJNoh8wy51zCzz6EMFXZTNbj9Q0Eu9FYv3RZ6jf63TErpnY8/lJ726h7Qpvp
q894D0dbAsNVGQh3ePyry2Cv+hoyW2zx+0l845cwhZ+mlkDSDxMATIsM4c75ALPtg/O3fbB7
etJF2N2LGfX0uw3g+5NZy+AJ+jPfNRWsynmlUBF0Aq0js8mwL8eT1iehfbmHDn+V1BzptqZe
E8uVrw6m2ZAtXU9HG9vTaEXvf7yBWjpVdt2DhNnl5c3NxwOOenJo+mQz1E0f9+mm162iY379
Ydfr/owZjW4urwdnVBmnk5vxyPYfnuUbfxiFPrXUXqfP1ezV8/H8DsaieW09p6PO+RxwPn4m
4D0ARncAvYvM6028czTnTz83gzSDOY9DLLL+HowMRFjTDp/xx96Av2C5IA4yrUjmPalUnPoQ
Vd2I6c8yEsQjOBG+WNOYsxSy/TC9boz4TD8MxZzBQjQ1v75Dn6crmJ1l5ZpL5hPNbqg/VtRX
Zn4U5+miLzb1Z3sfrMwduy9sV0gPe4af+eN/fGsYFqTXlAHEJ90HDU0r/dF5mPrhNJgl9k19
N7iU0W7Zl4WcaHrvuw/deAGnf1K7mflx9/bt+fHkFILqW8guzwqGzutUvPmmMeG++nYhZ2W6
oBy8p1IxvlEC6dxPEphAA/UXHBO2Bqzs/diUUPyims94bBICU0l52+/+en/DgHs6QGA5ve33
j9+cD3j9LRoAqPBxthUGkACLs2/GkbSgKpVbP7G6Sb77dDw/tv9zCWyAnx2BNtxeFXG4V6c0
gaSkQsOmqI9vd/Ejry87JzfBhpAyReajQ1vnDQe/S/fotuF3AplNLwvOtFX7bRblzle9W/km
uKHQHldc9yOz2eUDk9MPByczlj7cDshvGmxu3HppzQnleDq6/qArNri+cLVe0a+uJ306Vjtv
R6M+I5eXdOrrwWU8noxuhhgTT5cN0C99y9EhdjL9YD26xehqOth7evXL7lfTvkiaceNhiIux
uvHow9DLdah8oszupxO/K6hbyOnl9Hbku46rW0RiCpvr2QkwhrGffnkz9refeNXNxHQ0+ch6
8hU08Gwt0qeejc1XNzcjjxJlCFZ603i3jHfOjX0uIePBWzCpv+Zt2iOm/g/OWyink6n/etna
6cn416u+pROfyvLN1Xg86rmC7GV3xveHw+sy0k0uRp7DiPON6tUeXj/TrOgMZHItHgZy/4rf
Enm4oSCzIvI86sfSb8Q7X6qsNd2rqKIayVe7QkaJD5nKJFU86lSwNHe4NKzZksURelMr5lSc
BSPZALX60NWG1p3lWpdcxQbSv2yo2Fjw1EtfRUMMntcPr3zxuyobCZZYH8Cu9EdVFa0dSVPN
/4PHAAjP9VN1j/h4PJwOX87B4ufb/vh5FXx935/OPnjzq6YW9P+/yp6luY0c5/v8CldOu1WZ
GVuWbOcwh1arJXXcrZb7Ycm+qBRb46gSWy5Z3tnsr/8IkOwGSFDJd4kjAM0nSIIgHmVyN2wC
hoATpvOOCxC/aNs1JDi5LVpLtjjRELDgevhX77R/dYRMHTiU8tSrEgyBpfF36dIqOjJNhuiq
Nxi43UTgqoo8+LX+q+WobunowdICqjdz0cvjfrd9JI+/NlRAO2OWhMxMtRrPJxEo6iTZc5Yq
9leieau/m6zfvm0ORIvbCbsc01UxTpNspA3pboU60AeEeRfFaNrlOWBYQhCW5+wyomMjmULo
5BgozPSn/tUgNIeWrEoH531Jv+DQDM6kugHV7wdaEI/i5PJUsgCiRFXv9PR0Fc/F4ucLpr2d
LsBS3jU00CcT6m6q3fv+YcOOLKu9lfDkPhGl2bCQXY1T1Z7G3ot8A7XN8+6wAb9TqVoBq796
fX57Ej9gCH0gK2n7XxVGNjopXlAr+u+T1pfSMWuOnr/vnhS42sVS8RJaW4jud+vHh91z6EMR
r+01lvM/x/vN5u1hrW5GN7t9ehMq5GekSLv9I1+GCvBwVB+YbQ8bjR2+b78/bvbdIAlF/fpH
+NXN+/q76n5wfER8u+Ojv5TdT5bgEPbfUEEStr2G/hInEBUQvAPejstE0r4lyzrGB1/jXnJQ
l1vfVr6zz0Dy0EuLwapN5/yc7vkGPq9ngzNuwGIwZX316fJcEswNQZUPBqc9r0RQEXAlaodQ
g63+Pe+x+rRPibzAxS7pvaf70V6ICcgLewJA0Ghe8J33Nxu474E/xbCIegxHFTkVPkbO6rLI
MsFEdj69Y1HcuoPO2KkDgWiXzD5kaseYGn+Nau41W0a+B6V/Es9GZUFfzg0API7Ad0CHVezk
SIYVHSicAqzl/YcvW9Dafvz6j/nPf14e9f8+hIpHR1krGotD00oNdggiYldk9Sj0p8sdGlgS
hct0AcZAD9uXJ8mAqqpzsSHCV7YKEGLI8Gozojl0zir3OnlEka6GZTqaBPSNiRjkKi2YGgR+
o3tAYBOosjTXT8J2YUHcC/X/WcIisbXB7brrBd92jMsLKNqQN9lGdBtl6QjCz4yrsDemwqlj
m5thqw2itxI5S2HOV1zZZUAmpFYUS68/lqZK4oZ7pCpMn/l2IwB8oyGmGDTEqav/C3X1nbr4
96G7AiI7ZxfSps/DUY//cpWGqr7ct5EqkxSiVlXyWH5GBKX//JOufRaH8PO48rdXJD32OrH0
ageIkd1Wt5J1OBDcNEUduV+JbWYUYjg3QBTGrzMueTwrggOBPpVYF2gWUTlzvwtN8GRc9Riv
DevSGwULOzoRLRHGkhE9rS1F2aiTOZqBtY7DVZrENYxDYFQpvqnFZpXJ2BgKSRY3adb2sdvS
eh4Htjgw7QnxJzSObuZ0TOh6BYbhK1hDjF0d83ABfY+1sGMyB3j8odcRpZAb1flhs7Z1YLBJ
qBjOt7pqgUFu6SiM+aGOVlM3rkud1jjJ8pLG4SOWSDCO/K8Nyq40K2xAbEINRKZnehENdljp
BtyVb89oWzVIMmfGEljoIrAZGVd8c9Ywl79wt5Y4qFADCA+dtIgOBo5h6GwGPme0QIkkyhbR
naq5yEKxB8hXILrIN1RCBBGTIEqUf0FeP3yl7zzjytvYDch3yvUopmoDLiZlJBtSWaowD2p8
MYRg1CuIxkekA0DBcmGz0UGPuUB3RIEGWmWAHgs9LqPfwWlmdDtCiaMTOCyzV8Wni4tTNtuf
iyzlj/L3ikxklmY0XvHg2YEKtVa5qP4cR/WfyRL+ndVykxSONUeHU+Dse6uJpNGP2sg1ShQb
JeAk/Ff//JLKE8GPZ7W3UBAUmmpEGp9DK+sd66O+0Lxt3h93GGbA6zu8PToNQNB1wFoTkW60
VgSij3peqDOMGvwiKp6m2ahMyE4MQV/okDvSPvp80zYh4OhhqymWYJFPZjLJx6NVXCZKvuVa
NfgjHHj2JuePWFskKHRxUaBSn7WyKKPZxD8pu1vTKHSKRmPLB5Zn8JiSQapbVeXovKfO9+r3
PGs8sSV4jA/d+gWxUwsN8rvEMA13O8Zgx9IF56aJqinjAwPRB7y3o3K03vSPlKuWEcZfqtRQ
ZXJBhgJNv2WTQ4nShFs4VrXDiS383lXIW4QTl9lHF+Jny/tjX91rX0oX3EfHCAxrk94nAoGN
jCvNTBlNcoz9pA83KOC8fTpaOnwE0RCXDicVeYgLp3Pn85vZsu+DLmSQa6Jh6nEhEDcLogLc
tb7e3VXMIchr2fDbK6iQQ7gjmRI1HafyuRN1XP9uT5HrvJqgZ3P119lpr3/qk0H4IyFahCFQ
rHIM2afIbtdv0dO4JZAN4TTlVb/3S3TAgiIhJws22O0uCRPnN77wyI41jY6FRC+3sG3Ah8fN
39/Xh80Hr+DYN8N3SeZqksN13TNHGgMcZh4PoY+TjmNAosgTHPISrtGLvoDOoyXEWgBPpdai
FnKysGXTOMtI/9ZOInQWmiOCC1g0uieKhR0RQVsS3E6PlLvSUfNdaKzOwNpEbrFpclpZioYU
VT+6ed2+7a6uBp9+PyMzCwRWvFsp8U62lKNEl79EdCk/KTKiq8HprxDJliMO0S9VJ9mXcJKL
Uz52BHMWxPSCGGYR5eBkD1iHSPJwdUgujtQh2a8xkk/nF4HGfxqEhuITD8PAcf2fVnl12Xc/
V7ciYMxAwAj29VlvILkxuzRnbhVRFQeCQNMGyN4qlEJSH1C8N+MWIUlBFD8IfSi9jFP8ZejD
0Ey0nT3nE9zC+wH4gMOvi/RqVQqwhsPyKAaRgYa8teA4yVhI4g4+q5OG+k+2mLKI6lQs665M
syyN3eEA3CRKFCYwHkhQJsm19GUaQ1xyKeBZSzFr0lr6FPucypGADUndlNdpNeWdaeoxi0DS
zFJgbaGYtFgtbuilmT2GaKuAzcP7fnv44ZugXSd37NiC3zYu5yoUa474+ip6SKhBL1daCQkh
Ev2yV6PpqlCfo526JDABDeoDTboEen0yav/VSF0R8amzLtOYDbolkS87BikL52A8Y7M8tOHT
pcQOHhFtgF/CWBUBsrTcJB2rG4hzNbnBKGpWeO6GICLrJavyvz6Aycrj7p+Xjz/Wz+uPED3t
dfvy8W3990aVs338CObbT8ADH7+8/v2BZQL5ut4/bl7g1bBjj99IpMbty/awXX/f/s/JgYhp
+nTYbx7fFxGohIbgr7bxPE+ApYHIlYRE1FgE2uGkJxG60dpCuPxvW7osSn1/oRpeNMvkLg8a
Bpm0aEx9DV1S7tCg+Y0LAcfwC8WzMY2ojwuldeOL9z9eD7uTh91+c7Lbn3zdfH+lwfs08WrM
fGIMMMomEU2xw8A9H55EIxHok1bXcTqfUjdfB+F/Ao7bItAnLZllYwsTCcnVyGl4sCVRqPHX
87lPrYB+CXAv8klNoIQQnElGHLUapZV2boKXMMncjZPrEIzOs5mhmYzPeld5k3mIGUvIRIB+
T/CPwAxNPVUbuWXN+fuX79uH379tfpw8IJc+gefOD485yyoSuj6S1AcGxwI3tbCRz0BJXI6Y
Iahhw1zoU1PeJr3B4OyTbX/0fvi6eYFksJACNnnBTkDkvH+2h68n0dvb7mGLqNH6sPZ6Fce5
P/YCLJ6q8zLqnc6L7O7s/HQgLLFJWp1Rq33bi+Qm9fYFCOsSqW3y1vZiiGaJz7tH+jRj6x7G
wsjHYylxkkXWPgPHApsl8dCDZeXCgxVjn26u28WBS6ESde4vyshfgLNpeDTBTLtu/HkAp612
0KYQfCwwZnnkN24qAZfy8N4qWu/tbLR92rwd/MrK+Lznl4xgv76luIkOIZhGbyi0RGOO7Ceq
nvrsdJSOfU4WqyKj7u1kI+kW0yL9icpTxchJBn+F4sp8dHYhqwDs6phGotFxi+3RgD4deHAm
nGfT6NwH5gIMgtwPi4nQ4sVcley/mW5fvzLXknbRC+c15pEV5rdYjFNx4jVCyHJr5zfKE3Xv
kWwjWwqQ6MPfV7WkZiBof4xHQtfGTlgfZ28Utr5yzoLGtHPSF5pZLwoYh3BDDUHXURk9wJQ+
et52z6/7zdsbT+9tO4jqWX/7uy882FXf57bsXuoEqqHDXTDPGtr0e/3yuHs+mb0/f9nsTcoH
I4S7pUYzCO0wL0WbEdufcjhx/GEoRtz7NEbvEd7JDrhY1F0SCq/Iz2ldJ2UCRqpUnCai4orG
tzCC8fftl/1aXQP2u/fD9kXYzyGWgrTaAG42SD+lsE8j4jT/Hv1ck8ioViIhJXhswQjDQwp0
0soDuN22lSQGavGzYyTH+nJk+++62kk6xxvb7tBuUdOF8KG6L+UQ0lbdi0EZUN/N+T3MIufN
MDM0VTPkZMvB6adVnJRGj2AzcXQE8+u4ugKDolvAQhkSxaV5jCbfdy8diMcw4upz+XafTmYY
zF+/6NIskP7psdkfwDBfSaFvkC7h5G379IK5yE4evm4evrF04Ca3JMYQ0noWntTUx1cseLvB
67sFGSbpsVXdWGejqLwTanPLU+snvsZ0mYZGtqf5hZ7a2ofpDKpGw6+x3Q6y4D6gL9n08m0h
q6G6zajtraQ50TCo4ArNGlhObWua1zaihrj7JY3fYK3lxynkokpLiOWUMrPlckSXlupBnqgr
WD5k6VC1Hixil7VY3TfU/shAZxecwhfl4lVaNyv+FRcs1c/WjJ2vRcSotZQM72TdOyORXywM
SVQuZD7SeD5GZXzRZz/5r0s6VUNffo7JPcoVmHWULd5jg6JPuxyqjSA4HCwa4DDiYsC93oMd
qPw0DVCpZOetmkDFdtCHZgcs0S/vAez+NqkMOQx9OOY+bRrR6THAqMwlWD1VrO0hwDHSL3cY
f/ZgfIq6DtmE4T6C5wYnCJojnNETka2EJCtVkRVMRqRQUGPTVcdwqliWuzsmnIduDLdRhkmy
6MFVFXGKeaDVeJU0Fe6sWLF09pgBBpI4QNxz0BCzqJPRKpqnrjUIA68qtjnbktodUNrlJ1mb
wcbucFnBLprwW3SDsesxu1/VEeGBtIQkeFQRlc9TFvgEfGxM4FMyHKhQHiUsIrNWMqNgqBNM
dlGoK7WnsOjT8CoAkbzpVmcjZbsnB9eC21MWoa/77cvhGwY3eHzevD35Tyc6VbqT28wAIWEn
0w9qmwmIP6mTglpl5mWQ4qYBs9HWrsFKIl4JJKeRzjGhW3AkpufdLFJX8XA0AIr3vIOUADYs
QPBKylLRSXu9CSnbTNShOSwqFqw8OKztXWz7ffP7YftspIE3JH3Q8D2ZhK47WBvcFyT71VI1
UXtIgLUR5ZE5Jkk06dyJv0o0Qv1sFMjfhAsswcRRYC6ZRzVd/S4GqwYvDsLguk2Y5dtJ3KLT
tBVlrJqcRNc2DZQsRv3qUP1GExgZXh9tvrw/PcFTCYlC3XG2zRcnNK4ymXjUv8HhAaOXtNJ0
OcYeDZcDD0cBo8vKzQTt5K452hfeIp2GkZ4LADV5zOhTV1sYWeaw6pSonMx4kkxdBmC93F8O
Sp0lyFJHjLCgjmIxYxcQvHcUEGiZBz1uCwdHGBeuzeSFmTOIY1s4Jxzr8ytQDMZ4FIPoMjII
tBgupIwbCCIimyFyUpMCzLgD/rRePuI0H3GVNUNLLEdKQ4pQrjF8JzZMlSd5ppap3z+LCW8g
eJ41sKGTvQMTCGoUpLhFxyp3fm9zH4J6aCcOtkWVQ795EIR4omTXSXj+bFI9FuE5jjFp9XWk
VqagPdBYmHE4f2cFunxB/BDIcWcNMvmLbrfcnPGZ6iQLWqEORCfF7vXt40m2e/j2/qp3uun6
5Ykex6q6GF6UeUIhBgZ/0IaoRTQSeLlo6i4SYYZBGFc6Ij193a2Kce0j2fmrRN4op4RYh2SU
HiQ2rTyl8waVrabNDAJOV7IxweImEOSv9Zs9No7aTsRmoWQbYbcyTFrMkEEj4gWHIPsKL5TO
5x1m4jpJ5nrD07d9ePPq9vh/vb1uXzAi68eT5/fD5r8b9Z/N4eGPP/74d8cL6HWHRWI8mC5M
IfUDuRWd7FoKLAM6E1wkUkpdw78m8oh34sjki4XGqK2nWDix4XVNi0p7YzAottAR2wE2Srzk
eEfAMEBwdxCiP2EFisfB4c+5onVNFlQKVTxmn4nc8P+ZWN5qtTfg7uXcDzD+OGkhSF5qdCD7
gLpRJSMhHLjZrvWpcXy3Z+Is2ZdM7ubH9WF9AuIH5mH2ZCnutmaOcAno3N0Qpu2h5ONWn2OY
cgFE9bKZu9lwjzbTrSou1UjN6tRJQ6PfIuJGko9k/oCjvVK3oGTlMgdgQsxBSMDJ90gBbmZD
gktuqDO4DZXDGu8svxsjdJcobvsToL14lQwIjiWy0b3J2VwXUrK2WTHXLXaj5Zdoo+4wro6j
H/P9A++0ba5HA9TZQIHeCRGmZCTVWJ0BwauZFGWEcJODjtTPyrPKTqkLfHu1NxynR3DUwdZO
iu7swMqbCjPYY+HhY0UgsIt0AcmBA+PrpxRxEG2uXX8QktVQbRlqBNVhMU69nOAUl3gXme6c
QXQ0U6sYckSa77jHakultiuLF4fCVBocizbxedFyFbm5z+qp5hm5cN1nzVTpzN0SORleX4/q
lCibCdp3W1mUoXbKREFkDCQoby0CAll3WX+95eBRdD4XhAYfb8DdUw27PCK0D7TEnxK3cUeQ
7UdJVkeij2CUzx3nZQ0KhErkNObcEr4+GuxZm82udL4Lb5d/f5ZlvyQqM/MScy2e5+xDqlir
N28HOOFB1ox3/9ns108bYoDcsDuGSaarc1O7YD7dGpYsdZfdidZYWFAhSzt7rIImqygNx6fc
OmKey2TiwGob1rYc6W2zVIsX71DcDlRfndSFSYENc/KIR0AvrTF1G8Z9VXVRBz7kYS2z61Et
qbGQ8/GlrmIbN8IhLTmE9nTAnHJoBS5cpO7hPwTltwukGnSOYjpzBxfVRZ7GF31R0KS2tcF1
ia2fJktIGh0aC6M01gbYldvzuqyY3a9+9VXgulg60PapklevldTh5jVNKnkXIG7pvBcgEKI4
jNXZ7dVUgpYc4+eHyuMvZQhSexXZY+FNUzWY7dq8EpsSPDicjg+9Kg2jXLarnehbq6IB2UtO
sU2fmFWJxxNx66dnYadgL70OzqaKlr5TzXbJ9Wyhct0bFTAPV5LIESbDp+XUW3BJnjrDokcZ
VgMo+uTDSX0WvFwd3Xo9u3n98PF/oLaHaTahAAA=

--IS0zKkzwUGydFO0o--
