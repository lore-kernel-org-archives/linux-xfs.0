Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9824FC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 16:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 630EF613AA
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 16:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhDSQLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 12:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232760AbhDSQLU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Apr 2021 12:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB2CF61369;
        Mon, 19 Apr 2021 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618848650;
        bh=n6JdNvuuZ8Uw5jdDTx9/WCNNeie0snivKr+SAQ2WyeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N52ECp3RDVrz0f9Lrfv81mHyhu3dVAN0qRyROmFptRGrIQ4Hq7/FMYVPbpyB33fRX
         asppK4f8Wj4mbpPLOCJk8a2FbXd/hcHVl2IXFaeOHPdvXbJuDvx7kunjMxFQ0IVkmP
         QoXau0PzY8ydH3NBki2G+imsGKTArV3YbQ/7HgOG/3hXHWMqHuQ+FEEmz+wBQyS5Ul
         RKnF81oIRojGtviHO3C9y5RqWLXsxXP25NSJstjyvVUvObGrdM5fyXLpmBcgEhvb0P
         J6wvVKxv4K53di4ubDgkVzJ6VnTlcd7cTQaAPEOux6ijf+ZCw+hN48WOl5/14p4d3w
         BYCdIyMJh+bdQ==
Date:   Mon, 19 Apr 2021 09:10:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Chen, Rong A" <rong.a.chen@intel.com>
Cc:     kernel test robot <lkp@intel.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [kbuild-all] Re: [PATCH v3 2/2] xfs: set aside allocation btree
 blocks from block reservation
Message-ID: <20210419161050.GC3122264@magnolia>
References: <20210412133059.1186634-3-bfoster@redhat.com>
 <202104130641.CXaGdXDk-lkp@intel.com>
 <20210414004151.GV3957620@magnolia>
 <f72234e6-09e1-2030-de0d-f0c295194935@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f72234e6-09e1-2030-de0d-f0c295194935@intel.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 08:59:11AM +0800, Chen, Rong A wrote:
> 
> 
> On 4/14/2021 8:41 AM, Darrick J. Wong wrote:
> > On Tue, Apr 13, 2021 at 06:21:56AM +0800, kernel test robot wrote:
> > > Hi Brian,
> > > 
> > > Thank you for the patch! Yet something to improve:
> > > 
> > > [auto build test ERROR on xfs-linux/for-next]
> > > [also build test ERROR on v5.12-rc7 next-20210412]
> > > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > > And when submitting patch, we suggest to use '--base' as documented in
> > > https://git-scm.com/docs/git-format-patch]
> > > 
> > > url:    https://github.com/0day-ci/linux/commits/Brian-Foster/xfs-set-aside-allocation-btree-blocks-from-block-reservation/20210412-213222
> > > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > > config: um-randconfig-r022-20210412 (attached as .config)
> > > compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> > > reproduce (this is a W=1 build):
> > >          # https://github.com/0day-ci/linux/commit/5ffa1f5fa63a4a9c557f90beb5826866fa4aefd0
> > >          git remote add linux-review https://github.com/0day-ci/linux
> > >          git fetch --no-tags linux-review Brian-Foster/xfs-set-aside-allocation-btree-blocks-from-block-reservation/20210412-213222
> > >          git checkout 5ffa1f5fa63a4a9c557f90beb5826866fa4aefd0
> > >          # save the attached .config to linux build tree
> > >          make W=1 ARCH=um
> > > 
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > 
> > > All errors (new ones prefixed by >>):
> > > 
> > >     syscall.c:(.text+0xa023): undefined reference to `atomic64_inc_386'
> > 
> > What is all this build robot noise I'm suddenly getting about UML and
> > weird versions of atomic functions?  Seems to build fine on vanilla x64
> > and arm64, so....is there a real problem here???
> 
> Hi Darrick,
> 
> It seem no one has an interest in it, we have disabled randconfig test
> for arch um to avoid sending report to irrelevant people.

Ah, ok, thank you!

--D

> Best Regards,
> Rong Chen
> 
> > 
> > --D
> > 
> > >     /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_link_put':
> > >     syscall.c:(.text+0xa036): undefined reference to `atomic64_dec_return_386'
> > >     /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_tracing_prog_attach':
> > >     syscall.c:(.text+0xa423): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: kernel/bpf/syscall.o: in function `bpf_link_get_from_fd':
> > >     syscall.c:(.text+0xa8a7): undefined reference to `atomic64_inc_386'
> > >     /usr/bin/ld: kernel/bpf/bpf_iter.o: in function `prepare_seq_file':
> > >     bpf_iter.c:(.text+0x1b2): undefined reference to `atomic64_inc_return_386'
> > >     /usr/bin/ld: fs/proc/task_mmu.o: in function `task_mem':
> > >     task_mmu.c:(.text+0x2bfd): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/ext4/balloc.o: in function `ext4_has_free_clusters':
> > >     balloc.c:(.text+0x94): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/ext4/dir.o: in function `ext4_dir_llseek':
> > >     dir.c:(.text+0x2d3): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/ext4/dir.o: in function `ext4_readdir':
> > >     dir.c:(.text+0x84b): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xc71): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xc9f): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: dir.c:(.text+0xe1b): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xe44): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xe72): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/ialloc.o: in function `get_orlov_stats':
> > >     ialloc.c:(.text+0x205): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/ext4/inline.o: in function `ext4_add_dirent_to_inline.isra.0':
> > >     inline.c:(.text+0x14a9): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inline.c:(.text+0x14df): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/inline.o: in function `ext4_read_inline_dir':
> > >     inline.c:(.text+0x3dd8): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inline.c:(.text+0x3ea7): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inline.c:(.text+0x3ed5): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/inode.o: in function `ext4_do_update_inode':
> > >     inode.c:(.text+0x3f13): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inode.c:(.text+0x44bb): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/ext4/inode.o: in function `__ext4_iget':
> > >     inode.c:(.text+0x7c4d): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: inode.c:(.text+0x8385): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/ext4/inode.o: in function `ext4_mark_iloc_dirty':
> > >     inode.c:(.text+0x8a69): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inode.c:(.text+0x8aa0): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/inode.o: in function `ext4_setattr':
> > >     inode.c:(.text+0xf4ed): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inode.c:(.text+0xf523): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/ioctl.o: in function `swap_inode_boot_loader':
> > >     ioctl.c:(.text+0x1794): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/ext4/namei.o: in function `ext4_setent':
> > >     namei.c:(.text+0x2a0a): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: namei.c:(.text+0x2a41): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/namei.o: in function `add_dirent_to_buf':
> > >     namei.c:(.text+0x498c): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: namei.c:(.text+0x49c3): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/namei.o: in function `ext4_generic_delete_entry':
> > >     namei.c:(.text+0x7452): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: namei.c:(.text+0x7488): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/namei.o: in function `ext4_rmdir':
> > >     namei.c:(.text+0x9f2d): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: namei.c:(.text+0x9f63): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ext4/resize.o: in function `ext4_update_super.isra.0':
> > >     resize.c:(.text+0x2566): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_iget':
> > >     xattr.c:(.text+0x6b6): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_update_ref':
> > >     xattr.c:(.text+0x776): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xattr.c:(.text+0x79f): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/ext4/xattr.o: in function `ext4_xattr_inode_lookup_create':
> > >     xattr.c:(.text+0x2baf): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/fat/dir.o: in function `fat_remove_entries':
> > >     dir.c:(.text+0x2cf0): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0x2d27): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/fat/misc.o: in function `fat_update_time':
> > >     misc.c:(.text+0x721): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: misc.c:(.text+0x75e): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ufs/dir.o: in function `ufs_commit_chunk':
> > >     dir.c:(.text+0x24): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0x5b): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ufs/dir.o: in function `ufs_readdir':
> > >     dir.c:(.text+0x62e): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xa43): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0xa71): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/ufs/inode.o: in function `ufs_iget':
> > >     inode.c:(.text+0x4331): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: inode.c:(.text+0x4365): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/affs/dir.o: in function `affs_readdir':
> > >     dir.c:(.text+0xf5): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0x480): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: dir.c:(.text+0x4ae): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/affs/amigaffs.o: in function `affs_remove_hash':
> > >     amigaffs.c:(.text+0x180): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: amigaffs.c:(.text+0x1b6): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/affs/amigaffs.o: in function `affs_insert_hash':
> > >     amigaffs.c:(.text+0x4ec): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: amigaffs.c:(.text+0x522): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_trace.o: in function `trace_event_raw_event_xfs_log_assign_tail_lsn':
> > >     xfs_trace.c:(.text+0xe948): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_trace.c:(.text+0xe959): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_trace.o: in function `trace_event_raw_event_xfs_loggrant_class':
> > >     xfs_trace.c:(.text+0x1126c): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_trace.c:(.text+0x11286): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_trace.c:(.text+0x112b2): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_alloc.o: in function `xfs_alloc_read_agf':
> > > > > xfs_alloc.c:(.text+0x63db): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_alloc_btree.o: in function `xfs_allocbt_free_block':
> > > > > xfs_alloc_btree.c:(.text+0x844): undefined reference to `atomic64_dec_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_alloc_btree.o: in function `xfs_allocbt_alloc_block':
> > > > > xfs_alloc_btree.c:(.text+0x8d5): undefined reference to `atomic64_inc_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_inode_buf.o: in function `xfs_inode_to_disk':
> > >     xfs_inode_buf.c:(.text+0x5e7): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_inode_buf.o: in function `xfs_inode_from_disk':
> > >     xfs_inode_buf.c:(.text+0x1409): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/libxfs/xfs_trans_inode.o: in function `xfs_trans_log_inode':
> > >     xfs_trans_inode.c:(.text+0x490): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_trans_inode.c:(.text+0x4d8): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_icache.o: in function `xfs_iget_cache_hit':
> > >     xfs_icache.c:(.text+0x1d0c): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_icache.c:(.text+0x1d78): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_iops.o: in function `xfs_vn_update_time':
> > >     xfs_iops.c:(.text+0xab2): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_iops.c:(.text+0xaf8): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_inode.o: in function `xfs_init_new_inode':
> > >     xfs_inode.c:(.text+0x27d): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_mount.o: in function `xfs_mod_fdblocks':
> > > > > xfs_mount.c:(.text+0x24a2): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `write_grant_head_show':
> > >     xfs_sysfs.c:(.text+0x160): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `reserve_grant_head_show':
> > >     xfs_sysfs.c:(.text+0x1a6): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_sysfs.o: in function `log_tail_lsn_show':
> > >     xfs_sysfs.c:(.text+0x1ec): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_space_left':
> > >     xfs_log.c:(.text+0x2cf): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o:xfs_log.c:(.text+0x2e1): more undefined references to `atomic64_read_386' follow
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_grant_head_init':
> > >     xfs_log.c:(.text+0x4e5): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_alloc_log':
> > >     xfs_log.c:(.text+0xceb): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0xcf6): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_assign_tail_lsn_locked':
> > >     xfs_log.c:(.text+0x1951): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x196d): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_grant_push_threshold':
> > >     xfs_log.c:(.text+0x1cc5): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x1ceb): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_regrant':
> > >     xfs_log.c:(.text+0x258d): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x25b2): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_state_do_callback':
> > >     xfs_log.c:(.text+0x27ab): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x2820): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xlog_sync':
> > >     xfs_log.c:(.text+0x310e): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x3134): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x3243): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x3269): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_ticket_regrant':
> > >     xfs_log.c:(.text+0x5483): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x54be): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x54e7): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x5522): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x557f): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x559c): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_ticket_ungrant':
> > >     xfs_log.c:(.text+0x5798): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x57d6): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x57f9): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x5834): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_log.o: in function `xfs_log_reserve':
> > >     xfs_log.c:(.text+0x5d14): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x5d39): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x5da8): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log.c:(.text+0x5dcd): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/xfs/xfs_inode_item.o: in function `xfs_inode_item_format':
> > >     xfs_inode_item.c:(.text+0x1da9): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_set_state':
> > >     xfs_log_recover.c:(.text+0x1e3): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: xfs_log_recover.c:(.text+0x1fd): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: xfs_log_recover.c:(.text+0x21c): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: xfs_log_recover.c:(.text+0x23b): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_check_unmount_rec':
> > >     xfs_log_recover.c:(.text+0x460e): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/xfs/xfs_log_recover.o:xfs_log_recover.c:(.text+0x461f): more undefined references to `atomic64_set_386' follow
> > >     /usr/bin/ld: fs/xfs/xfs_log_recover.o: in function `xlog_find_tail':
> > >     xfs_log_recover.c:(.text+0x57be): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xfs_log_recover.c:(.text+0x597a): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_inode_add_blocks':
> > >     inode.c:(.text+0x5c4): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_inode_sub_blocks':
> > >     inode.c:(.text+0x60f): undefined reference to `atomic64_sub_386'
> > >     /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_new_inode':
> > >     inode.c:(.text+0x738): undefined reference to `atomic64_inc_386'
> > >     /usr/bin/ld: fs/nilfs2/inode.o: in function `nilfs_evict_inode':
> > >     inode.c:(.text+0x1d8e): undefined reference to `atomic64_dec_386'
> > >     /usr/bin/ld: fs/nilfs2/the_nilfs.o: in function `nilfs_find_or_create_root':
> > >     the_nilfs.c:(.text+0x17f0): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: the_nilfs.c:(.text+0x17fb): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/nilfs2/segment.o: in function `nilfs_segctor_do_construct':
> > >     segment.c:(.text+0x4e4d): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: segment.c:(.text+0x4e61): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/nilfs2/ifile.o: in function `nilfs_ifile_count_free_inodes':
> > >     ifile.c:(.text+0x380): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: fs/btrfs/ctree.o: in function `__tree_mod_log_insert':
> > >     ctree.c:(.text+0x2f8): undefined reference to `atomic64_inc_return_386'
> > >     /usr/bin/ld: fs/btrfs/ctree.o: in function `btrfs_get_tree_mod_seq':
> > >     ctree.c:(.text+0x3f69): undefined reference to `atomic64_inc_return_386'
> > >     /usr/bin/ld: fs/btrfs/transaction.o: in function `join_transaction':
> > >     transaction.c:(.text+0x1109): undefined reference to `atomic64_set_386'
> > >     /usr/bin/ld: fs/btrfs/xattr.o: in function `btrfs_xattr_handler_set_prop':
> > >     xattr.c:(.text+0xec): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xattr.c:(.text+0x122): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/btrfs/xattr.o: in function `btrfs_setxattr_trans':
> > >     xattr.c:(.text+0xc24): undefined reference to `atomic64_read_386'
> > >     /usr/bin/ld: xattr.c:(.text+0xc5a): undefined reference to `cmpxchg8b_emu'
> > >     /usr/bin/ld: fs/btrfs/volumes.o: in function `create_chunk':
> > >     volumes.c:(.text+0x242c): undefined reference to `atomic64_sub_386'
> > >     /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_remove_chunk':
> > >     volumes.c:(.text+0x51e7): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_shrink_device':
> > >     volumes.c:(.text+0x7977): undefined reference to `atomic64_sub_386'
> > >     /usr/bin/ld: volumes.c:(.text+0x7bcc): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: fs/btrfs/volumes.o: in function `btrfs_init_new_device':
> > >     volumes.c:(.text+0xdc15): undefined reference to `atomic64_add_386'
> > >     /usr/bin/ld: volumes.c:(.text+0xeb10): undefined reference to `atomic64_sub_386'
> > >     /usr/bin/ld: fs/btrfs/volumes.o: in function `read_one_dev':
> > > 
> > > ---
> > > 0-DAY CI Kernel Test Service, Intel Corporation
> > > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> > 
> > _______________________________________________
> > kbuild-all mailing list -- kbuild-all@lists.01.org
> > To unsubscribe send an email to kbuild-all-leave@lists.01.org
> > 
