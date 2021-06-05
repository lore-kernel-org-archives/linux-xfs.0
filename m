Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6543EC47082
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 21:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33806613EF
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Jun 2021 21:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFEVpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Jun 2021 17:45:23 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32858 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhFEVpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Jun 2021 17:45:23 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E29351043E2E;
        Sun,  6 Jun 2021 07:43:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lpe4p-009OUo-P5; Sun, 06 Jun 2021 07:43:31 +1000
Date:   Sun, 6 Jun 2021 07:43:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: CIL and log scalability improvements
Message-ID: <20210605214331.GV664593@dread.disaster.area>
References: <20210604032928.GU664593@dread.disaster.area>
 <20210605020354.GG26380@locust>
 <20210605021533.GH26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605021533.GH26380@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=zORz_lIA94QGKEDY0bMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 04, 2021 at 07:15:33PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 04, 2021 at 07:03:54PM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 04, 2021 at 01:29:28PM +1000, Dave Chinner wrote:
> > > Hi Darrick,
> > > 
> > > Can you please pull the CIL and log improvements from the tag listed
> > > below?
> > 
> > I tried that and threw the series at fstests, which crashed all VMs with
> > the following null pointer dereference:
> > 
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 0 P4D 0 
> > Oops: 0000 [#1] PREEMPT SMP
> > CPU: 2 PID: 731060 Comm: mount Not tainted 5.13.0-rc4-djwx #rc4
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > RIP: 0010:xlog_cil_init+0x2f7/0x370 [xfs]
> > Code: b4 7e a0 bf 1c 00 00 00 e8 c6 3b 8d e0 85 c0 78 0c c6 05 13 7f 12 00 01 e9 7b fd ff ff 4
> > 2 48 c7 c6 f8 bf 7f a0 <48> 8b 39 e8 f0 24 04 00 31 ff b9 fc 05 00 00 48 c7 c2 d9 b3 7e a0
> > RSP: 0018:ffffc9000776bcd0 EFLAGS: 00010286
> > RAX: 00000000fffffff0 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 00000000fffffff0 RSI: ffffffffa07fbff8 RDI: 00000000ffffffff
> > RBP: ffff888004cf3c00 R08: ffffffffa078fb40 R09: 0000000000000000
> > R10: 000000000000000c R11: 0000000000000048 R12: ffff888052810000
> > R13: 0000607f81c0b0f8 R14: ffff888004a09c00 R15: ffff888004a09c00
> > FS:  00007fd2e4486840(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 00000000528e5004 CR4: 00000000001706a0
> > Call Trace:
> >  xlog_alloc_log+0x51f/0x5f0 [xfs]
> >  xfs_log_mount+0x55/0x340 [xfs]
> >  xfs_mountfs+0x4e4/0x9f0 [xfs]
> >  xfs_fs_fill_super+0x4dd/0x7a0 [xfs]
> >  ? suffix_kstrtoint.constprop.0+0xe0/0xe0 [xfs]
> >  get_tree_bdev+0x175/0x280
> >  vfs_get_tree+0x1a/0x80
> >  ? capable+0x2f/0x50
> >  path_mount+0x6fb/0xa90
> >  __x64_sys_mount+0x103/0x140
> >  do_syscall_64+0x3a/0x70
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7fd2e46e8dde
> > Code: 48 8b 0d b5 80 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0
> > f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 82 80 0c 00 f7 d8 64 89 01 48
> > 
> > I'm pretty sure that's due to:
> > 
> > 	if (!xlog_cil_pcp_init) {
> > 		int	ret;
> > 
> > 		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
> > 						"xfs/cil_pcp:dead", NULL,
> > 						xlog_cil_pcp_dead);
> > 		if (ret < 0) {
> > 			xfs_warn(cil->xc_log->l_mp,
> > 	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
> > 				ret);
> > 
> > Because we haven't set cil->xc_log yet.
> 
> And having now fixed that, I get tons of:
> 
> XFS (sda): Failed to initialise CIL hotplug, error -16. XFS is non-functional.
> XFS: Assertion failed: 0, file: fs/xfs/xfs_log_cil.c, line: 1532
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 113983 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_REDIR
> 
> EBUSY??

Can you attach your .config so I can try to reproduce this? I'm
guessing that it's an artifact of CONFIG_XFS=m or something else
being built as a module because I use monolothic kernels on my test
VMs and, obviously, haven't seen a single failure here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
