Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE4BC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 22:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 180726188B
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 22:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhC2WAM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 18:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhC2V7x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 17:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2586F6188B;
        Mon, 29 Mar 2021 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617055193;
        bh=vCNeAD7Qq6CZlh/FvyMUS51yuk6+Oc6+Hji3jYO/E28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZX2ntMh9ZuLi0u1TYCsWf4kRoBqJ+4Gl9QUJkeK6/CgMt8kXEjXPcsZSgmnMJKs0j
         m1j+vy1nTLkCfKdUzibvJxmQG/m9zr7KVOMsdZaeWpsSrcsS4ppYQELy8eTsBXum9H
         4peVsIjaOGCwvFXN+dq4mR3IJHGP0Vy4Zyvg3K/+RJxuuRsNbv1DmsmMPmsJpXAJ6z
         j6C2kYq4pYLXSWoJCcFw+FOT3ni/bhc1swH8BVPj+U2EhajO5He6zYsyg7Gwiu6gEB
         7EETUEXnKN8aEDP5eEP3OruUZ+yv/RQl4dhTv/TeoKI3YBrxbnWwbpg7pDpPe5uhiC
         j8SfcSS5Eo+JQ==
Date:   Mon, 29 Mar 2021 14:59:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 00/11] xfs: Delay Ready Attributes
Message-ID: <20210329215952.GJ4090233@magnolia>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326003308.32753-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:32:57PM -0700, Allison Henderson wrote:
> Hi all,
> 
> This set is a subset of a larger series for Dealyed Attributes. Which is a
> subset of a yet larger series for parent pointers. Delayed attributes allow
> attribute operations (set and remove) to be logged and committed in the same
> way that other delayed operations do. This allows more complex operations (like
> parent pointers) to be broken up into multiple smaller transactions. To do
> this, the existing attr operations must be modified to operate as a delayed
> operation.  This means that they cannot roll, commit, or finish transactions.
> Instead, they return -EAGAIN to allow the calling function to handle the
> transaction.  In this series, we focus on only the delayed attribute portion.
> We will introduce parent pointers in a later set.
> 
> In this version I have reduced the set back to the "Delay Ready Attrs" sub series to
> avoid reviewer burn out, but the extended series is available to view in the inlcuded
> git hub links, which extend all the way through parent pointers.  Feel free to review
> as much as feels reasonable.  The set as a whole is a bit much to digest at once, so
> working through it in progressive subsets seems like a reasonable way to manage its
> dev efforts.
> 
> Lastly, in the last revision folks asked for some stress testing on the set.  On my
> system, I found that in an fsstress test with all patches applied, we spend at most
> %0.17 of the time in the attr routines, compared to at most %0.12 with out the set applied.
> Both can fluctuate quite a bit depending on the other operations going on that seem to
> occupy most of the activity.  For the most part though, I do not find these results to be
> particularly concerning.  Though folks are certainly welcome to try it out on their own 
> system to see how the results might differ.
> 
> Updates since v15: Mostly just review feed back from the previous revision.  I've
> tracked changes below to help reviews recall the changes discussed

Hmm... so I ran fstests against this on an otherwise default V5
filesystem, and saw three new regressions:

xfs/125 spat out this from the final repair run:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
	- zero log...
	- scan filesystem freespace and inode maps...
	- found root inode chunk
Phase 3 - for each AG...
	- scan (but don't clear) agi unlinked lists...
	- process known inodes and perform inode discovery...
	- agno = 0
attribute entry #32 in attr block 2, inode 134 is INCOMPLETE
problem with attribute contents in inode 134
would clear attr fork
bad nblocks 8 for inode 134, would reset to 0
bad anextents 4 for inode 134, would reset to 0
	- agno = 1
	- agno = 2
	- agno = 3
	- process newly discovered inodes...
Phase 4 - check for duplicate blocks...
	- setting up duplicate extent list...
	- check for inodes claiming duplicate blocks...
	- agno = 0
	- agno = 1
	- agno = 2
	- agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
	- traversing filesystem ...
	- traversal finished ...
	- moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
xfs_repair should not fail

And xfs/434 and xfs/436 both complained about memory leaks stemming from
an xfs_da_state that xfs/125 didn't free correctly:

[ 1247.150683] =============================================================================
[ 1247.151799] BUG xfs_da_state (Tainted: G    B   W        ): Objects remaining in xfs_da_state on __kmem_cache_shutdown()
[ 1247.153246] -----------------------------------------------------------------------------
[ 1247.153246] 
[ 1247.154528] INFO: Slab 0xffffea00002e9280 objects=17 used=11 fp=0xffff88800ba4b4a0 flags=0xfff80000010200
[ 1247.155764] CPU: 2 PID: 50257 Comm: modprobe Tainted: G    B   W         5.12.0-rc4-djwx #rc4
[ 1247.156849] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1247.157996] Call Trace:
[ 1247.158330]  dump_stack+0x64/0x7c
[ 1247.158767]  slab_err+0xb7/0xdc
[ 1247.159196]  ? printk+0x58/0x6f
[ 1247.159615]  __kmem_cache_shutdown.cold+0x39/0x15e
[ 1247.160248]  kmem_cache_destroy+0x3f/0x110
[ 1247.160779]  xfs_destroy_zones+0xbe/0xe2 [xfs]
[ 1247.161462]  exit_xfs_fs+0x5f/0x9b4 [xfs]
[ 1247.162065]  __do_sys_delete_module.constprop.0+0x145/0x220
[ 1247.162740]  do_syscall_64+0x2d/0x40
[ 1247.163197]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1247.163810] RIP: 0033:0x7fd91cfe4bcb
[ 1247.164262] Code: 73 01 c3 48 8b 0d c5 82 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 82 0c 00 f7 d8 64 89 01 48
[ 1247.166352] RSP: 002b:00007fff89097038 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1247.167217] RAX: ffffffffffffffda RBX: 0000558b8e105cc0 RCX: 00007fd91cfe4bcb
[ 1247.167998] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000558b8e105d28
[ 1247.168781] RBP: 0000558b8e105cc0 R08: 0000000000000000 R09: 0000000000000000
[ 1247.169562] R10: 00007fd91d060ac0 R11: 0000000000000206 R12: 0000558b8e105d28
[ 1247.170351] R13: 0000000000000000 R14: 0000558b8e105d28 R15: 0000558b8e105cc0

From a quick bisect, all of thse problem originates in the last patch.

--D

> xfs: Reverse apply 72b97ea40d
>   NEW
> 
> xfs: Add helper xfs_attr_node_remove_step
>   DROPPED
> 
> xfs: Add xfs_attr_node_remove_cleanup
>   No change
> 
> xfs: Hoist transaction handling in xfs_attr_node_remove_step
>   DROPPED
> 
> xfs: Hoist xfs_attr_set_shortform
>   No change
> 
> xfs: Add helper xfs_attr_set_fmt
>   Fixed helper to return error when defer_finish fails
> 
> xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
>   Renamed xfs_attr_node_addname_work to xfs_attr_node_addname_clear_incomplete
> 
> xfs: Add helper xfs_attr_node_addname_find_attr
>   Renamed goto out, to goto error
> 
> xfs: Hoist xfs_attr_node_addname
>   Removed unused retval variable
>   Removed extra state free in xfs_attr_node_addname
> 
> xfs: Hoist xfs_attr_leaf_addname
>   Fixed spelling typos
> 
> xfs: Hoist node transaction handling
>   Added consistent braces to if/else statement
> 
> xfs: Add delay ready attr remove routines
>   Typo fixes
>   Merged xfs_attr_remove_iter with xfs_attr_node_removename_iter
>   Added state XFS_DAS_RMTBLK
>   Flow chart updated
> 
> xfs: Add delay ready attr set routines
>   Rebase adjustments
>   Typo fixes
> 
> 
> Extended Series Changes
> ------------------------
> xfs: Add state machine tracepoints
>   Rebase adjustments
>   xfs_attr_node_remove_rmt_return removed to match earlier refactoring changes
>   trace_xfs_attr_node_removename_iter_return becomes
>   trace_xfs_attr_remove_iter_return to match earlier refactoring changes
> 
> xfs: Rename __xfs_attr_rmtval_remove
>   No change
> 
> xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
>   Added kmem_alloc_large fall back
>  
> xfs: Set up infrastructure for deferred attribute operations
>   Typo fixes
>   Rename xfs_trans_attr to xfs_trans_attr_finish_update
>   Added helper function xfs_attri_validate
>   Split patch into infrastructure and implementation patches
>   Added XFS_ERROR_REPORT in xlog_recover_attri_commit_pass2:
> 
> xfs: Implement for deferred attribute operations
>   NEW
> 
> xfs: Skip flip flags for delayed attrs
>   Did a performance analysis
> 
> xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
>   Typo fixes
> 
> xfs: Remove unused xfs_attr_*_args
>   Rebase adjustments
> 
> xfs: Add delayed attributes error tag
>   Added errortag include
> 
> xfs: Merge xfs_delattr_context into xfs_attr_item
>   Typo fixes
> 
> 
> This series can be viewed on github here:
> https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16
> 
> As well as the extended delayed attribute and parent pointer series:
> https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16_extended
> 
> And the test cases:
> https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2
> 
> In order to run the test cases, you will need have the corresponding xfsprogs
> changes as well.  Which can be found here:
> https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16
> https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16_extended
> 
> To run the xfs attributes tests run:
> check -g attr
> 
> To run as delayed attributes run:
> export MOUNT_OPTIONS="-o delattr"
> check -g attr
> 
> To run parent pointer tests:
> check -g parent
> 
> I've also made the corresponding updates to the user space side as well, and ported anything
> they need to seat correctly.
> 
> Questions, comment and feedback appreciated! 
> 
> Thanks all!
> Allison 
> 
> Allison Henderson (11):
>   xfs: Reverse apply 72b97ea40d
>   xfs: Add xfs_attr_node_remove_cleanup
>   xfs: Hoist xfs_attr_set_shortform
>   xfs: Add helper xfs_attr_set_fmt
>   xfs: Separate xfs_attr_node_addname and
>     xfs_attr_node_addname_clear_incomplete
>   xfs: Add helper xfs_attr_node_addname_find_attr
>   xfs: Hoist xfs_attr_node_addname
>   xfs: Hoist xfs_attr_leaf_addname
>   xfs: Hoist node transaction handling
>   xfs: Add delay ready attr remove routines
>   xfs: Add delay ready attr set routines
> 
>  fs/xfs/libxfs/xfs_attr.c        | 903 ++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_attr.h        | 364 ++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
>  fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  fs/xfs/xfs_trace.h              |   1 -
>  7 files changed, 998 insertions(+), 407 deletions(-)
> 
> -- 
> 2.7.4
> 
