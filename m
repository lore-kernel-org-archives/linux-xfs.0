Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F3DC4743C
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 02:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98BD613EA
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 02:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFECRV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 22:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhFECRV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jun 2021 22:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56963613E7;
        Sat,  5 Jun 2021 02:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622859334;
        bh=OrehuXo1s5BqS63VqbpzcT4Xc90PE03nlUkaNfpKhKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufug4RdJlWJHa7vo//OU4x3oscYBnxZkGAHSrgFsFvzl3I3resEfCbE9OBj9CycA2
         UA4/iEQGxutbw7oMdERiYA9w2iM/wq3u7lJyXf+ErzRqwcMa2WBCgyxyjjIiT3dcXz
         JC0cCIzO0n00wI1fJamUrFmOsSJJ1DUera9lnBUbiZkdDL3M9lt9iJORNTPRws2sh/
         EoXPjRhINnzX/W/jVl0Ac/rrm37ABL2vR1SMGG9mKBVQX3iKZ1V9QblYR58OjSUcDj
         jfpQ7/iiHgohPf3Pu4LwzFx1ScpWeZ/NYZA45FqDoVpbrrJhyASK0z4Ft/PCJaI5yj
         La5wPY1UVp2Hg==
Date:   Fri, 4 Jun 2021 19:15:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: CIL and log scalability improvements
Message-ID: <20210605021533.GH26380@locust>
References: <20210604032928.GU664593@dread.disaster.area>
 <20210605020354.GG26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605020354.GG26380@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 04, 2021 at 07:03:54PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 04, 2021 at 01:29:28PM +1000, Dave Chinner wrote:
> > Hi Darrick,
> > 
> > Can you please pull the CIL and log improvements from the tag listed
> > below?
> 
> I tried that and threw the series at fstests, which crashed all VMs with
> the following null pointer dereference:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0 
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 2 PID: 731060 Comm: mount Not tainted 5.13.0-rc4-djwx #rc4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:xlog_cil_init+0x2f7/0x370 [xfs]
> Code: b4 7e a0 bf 1c 00 00 00 e8 c6 3b 8d e0 85 c0 78 0c c6 05 13 7f 12 00 01 e9 7b fd ff ff 4
> 2 48 c7 c6 f8 bf 7f a0 <48> 8b 39 e8 f0 24 04 00 31 ff b9 fc 05 00 00 48 c7 c2 d9 b3 7e a0
> RSP: 0018:ffffc9000776bcd0 EFLAGS: 00010286
> RAX: 00000000fffffff0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 00000000fffffff0 RSI: ffffffffa07fbff8 RDI: 00000000ffffffff
> RBP: ffff888004cf3c00 R08: ffffffffa078fb40 R09: 0000000000000000
> R10: 000000000000000c R11: 0000000000000048 R12: ffff888052810000
> R13: 0000607f81c0b0f8 R14: ffff888004a09c00 R15: ffff888004a09c00
> FS:  00007fd2e4486840(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000528e5004 CR4: 00000000001706a0
> Call Trace:
>  xlog_alloc_log+0x51f/0x5f0 [xfs]
>  xfs_log_mount+0x55/0x340 [xfs]
>  xfs_mountfs+0x4e4/0x9f0 [xfs]
>  xfs_fs_fill_super+0x4dd/0x7a0 [xfs]
>  ? suffix_kstrtoint.constprop.0+0xe0/0xe0 [xfs]
>  get_tree_bdev+0x175/0x280
>  vfs_get_tree+0x1a/0x80
>  ? capable+0x2f/0x50
>  path_mount+0x6fb/0xa90
>  __x64_sys_mount+0x103/0x140
>  do_syscall_64+0x3a/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd2e46e8dde
> Code: 48 8b 0d b5 80 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0
> f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 82 80 0c 00 f7 d8 64 89 01 48
> 
> I'm pretty sure that's due to:
> 
> 	if (!xlog_cil_pcp_init) {
> 		int	ret;
> 
> 		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
> 						"xfs/cil_pcp:dead", NULL,
> 						xlog_cil_pcp_dead);
> 		if (ret < 0) {
> 			xfs_warn(cil->xc_log->l_mp,
> 	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
> 				ret);
> 
> Because we haven't set cil->xc_log yet.

And having now fixed that, I get tons of:

XFS (sda): Failed to initialise CIL hotplug, error -16. XFS is non-functional.
XFS: Assertion failed: 0, file: fs/xfs/xfs_log_cil.c, line: 1532
------------[ cut here ]------------
WARNING: CPU: 2 PID: 113983 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_REDIR

EBUSY??

--D

> 
> > 
> > Cheers,
> > 
> > Dave.
> > 
> > The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:
> > 
> >   Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-cil-scale-tag
> > 
> > for you to fetch changes up to 856d6346ad5e76f230906792b1eb4ba70c860748:
> > 
> >   xfs: expanding delayed logging design with background material (2021-06-04 12:42:29 +1000)
> > 
> > ----------------------------------------------------------------
> > xfs: CIL and log scalability improvements
> > 
> > Performance improvements are largely documented in the change logs of the
> > individual patches. Headline numbers are an increase in transaction rate from
> > 700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
> > 2-3 orders of magnitude on metadata heavy workloads that don't use fsync.
> > 
> > Summary of series:
> > 
> > Patches         Modifications
> > -------         -------------
> > 1-7:            log write FUA/FLUSH optimisations
> > 8:              bug fix
> > 9-11:           Async CIL pushes
> > 12-25:          xlog_write() rework
> > 26-39:          CIL commit scalability
> > 
> > The log write FUA/FLUSH optimisations reduce the number of cache flushes
> > required to flush the CIL to the journal. It extends the old pre-delayed logging
> > ordering semantics required by writing individual transactions to the iclogs out
> > to cover then CIL checkpoint transactions rather than individual writes to the
> > iclogs. In doing so, we reduce the cache flush requirements to once per CIL
> > checkpoint rather than once per iclog write.
> > 
> > The async CIL pushes fix a pipeline limitation that only allowed a single CIL
> > push to be processed at a time. This was causing CIL checkpoint writing to
> > become CPU bound as only a single CIL checkpoint could be pushed at a time. The
> > checkpoint pipleine was designed to allow multiple pushes to be in flight at
> > once and use careful ordering of the commit records to ensure correct recovery
> > order, but the workqueue implementation didn't allow concurrent works to be run.
> > The concurrent works now extend out to 4 CIL checkpoints running at a time,
> > hence removing the CPU usage limiations without introducing new lock contention
> > issues.
> > 
> > The xlog_write() rework is long overdue. The code is complex, difficult to
> > understand, full of tricky, subtle corner cases and just generally really hard
> > to modify. This patchset reworks the xlog_write() API to reduce the processing
> > overhead of writing out long log vector chains, and factors the xlog_write()
> > code into a simple, compact fast path along with a clearer slow path to handle
> > the complex cases.
> > 
> > The CIL commit scalability patchset removes spinlocks from the transaction
> > commit fast path. These spinlocks are the performance limiting bottleneck in the
> > transaction commit path, so we apply a variety of different techniques to do
> > either atomic. lockless or per-cpu updates of the CIL tracking structures during
> > commits. This greatly increases the throughput of the the transaction commit
> > engine, moving the contention point to the log space tracking algorithms after
> > doubling throughput on 32-way workloads.
> > 
> > ----------------------------------------------------------------
> > Dave Chinner (39):
> >       xfs: log stripe roundoff is a property of the log
> >       xfs: separate CIL commit record IO
> >       xfs: remove xfs_blkdev_issue_flush
> >       xfs: async blkdev cache flush
> >       xfs: CIL checkpoint flushes caches unconditionally
> >       xfs: remove need_start_rec parameter from xlog_write()
> >       xfs: journal IO cache flush reductions
> >       xfs: Fix CIL throttle hang when CIL space used going backwards
> >       xfs: xfs_log_force_lsn isn't passed a LSN
> >       xfs: AIL needs asynchronous CIL forcing
> >       xfs: CIL work is serialised, not pipelined
> >       xfs: factor out the CIL transaction header building
> >       xfs: only CIL pushes require a start record
> >       xfs: embed the xlog_op_header in the unmount record
> >       xfs: embed the xlog_op_header in the commit record
> >       xfs: log tickets don't need log client id
> >       xfs: move log iovec alignment to preparation function
> >       xfs: reserve space and initialise xlog_op_header in item formatting
> >       xfs: log ticket region debug is largely useless
> >       xfs: pass lv chain length into xlog_write()
> >       xfs: introduce xlog_write_single()
> >       xfs:_introduce xlog_write_partial()
> >       xfs: xlog_write() no longer needs contwr state
> >       xfs: xlog_write() doesn't need optype anymore
> >       xfs: CIL context doesn't need to count iovecs
> >       xfs: use the CIL space used counter for emptiness checks
> >       xfs: lift init CIL reservation out of xc_cil_lock
> >       xfs: rework per-iclog header CIL reservation
> >       xfs: introduce per-cpu CIL tracking structure
> >       xfs: implement percpu cil space used calculation
> >       xfs: track CIL ticket reservation in percpu structure
> >       xfs: convert CIL busy extents to per-cpu
> >       xfs: Add order IDs to log items in CIL
> >       xfs: convert CIL to unordered per cpu lists
> >       xfs: convert log vector chain to use list heads
> >       xfs: move CIL ordering to the logvec chain
> >       xfs: avoid cil push lock if possible
> >       xfs: xlog_sync() manually adjusts grant head space
> >       xfs: expanding delayed logging design with background material
> > 
> >  Documentation/filesystems/xfs-delayed-logging-design.rst |  361 ++++++++++++++++++++++++++----
> >  fs/xfs/libxfs/xfs_log_format.h                           |    4 -
> >  fs/xfs/libxfs/xfs_types.h                                |    1 +
> >  fs/xfs/xfs_bio_io.c                                      |   35 +++
> >  fs/xfs/xfs_buf.c                                         |    2 +-
> >  fs/xfs/xfs_buf_item.c                                    |   39 ++--
> >  fs/xfs/xfs_dquot_item.c                                  |    2 +-
> >  fs/xfs/xfs_file.c                                        |   20 +-
> >  fs/xfs/xfs_inode.c                                       |   10 +-
> >  fs/xfs/xfs_inode_item.c                                  |   18 +-
> >  fs/xfs/xfs_inode_item.h                                  |    2 +-
> >  fs/xfs/xfs_linux.h                                       |    2 +
> >  fs/xfs/xfs_log.c                                         | 1015 +++++++++++++++++++++++++++++++++++++++---------------------------------------------
> >  fs/xfs/xfs_log.h                                         |   66 ++----
> >  fs/xfs/xfs_log_cil.c                                     |  822 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_log_priv.h                                    |  114 +++++-----
> >  fs/xfs/xfs_super.c                                       |   13 +-
> >  fs/xfs/xfs_super.h                                       |    1 -
> >  fs/xfs/xfs_sysfs.c                                       |    1 +
> >  fs/xfs/xfs_trace.c                                       |    1 +
> >  fs/xfs/xfs_trans.c                                       |   18 +-
> >  fs/xfs/xfs_trans.h                                       |    5 +-
> >  fs/xfs/xfs_trans_ail.c                                   |   11 +-
> >  fs/xfs/xfs_trans_priv.h                                  |    3 +-
> >  include/linux/cpuhotplug.h                               |    1 +
> >  25 files changed, 1603 insertions(+), 964 deletions(-)
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
