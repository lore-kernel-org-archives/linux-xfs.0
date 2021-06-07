Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0A8C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A465161182
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhFGWBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhFGWBw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 407A161130;
        Mon,  7 Jun 2021 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623103200;
        bh=AEKhjNqfnrVH768UWGz3TY+DMrxLtnY5FKPCSa+r7JE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZfYvuBRDNo2M/33NBSbFpRPkFv0w6CjFatzjPGQNU4jNhaWIcWK/wIshV11DZVmwG
         W0ECBYuTT5stxlt8CB3EkJRviLBOXsfXz7/7hJzf2+fWP8AennEWGmETgUQvfPyNI9
         99tbj4fr1QYdSTldNS339XwE+7tyo8Ucc5F588tvvDNJczuqv/sx3GoZ6xbCEScqJz
         ZwttAGrqrJfI8H2VZAzUuy3FPnhLfGF+Lr+5/bVhAGM8fPpj5CqhGS5zD9Q3oTPx9d
         JybuLyfyT2L5iUiJfPSPUKgwXRtCEq5HRyA8lhGjzfsn63ILYvoZmIsonKjm8iWZhn
         nALmBCgW9sCZA==
Date:   Mon, 7 Jun 2021 14:59:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: CIL and log scalability improvements
Message-ID: <20210607215959.GN2945738@locust>
References: <20210604032928.GU664593@dread.disaster.area>
 <20210605020354.GG26380@locust>
 <20210605021533.GH26380@locust>
 <20210606221119.GW664593@dread.disaster.area>
 <20210607000040.GX664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607000040.GX664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 10:00:40AM +1000, Dave Chinner wrote:
> On Mon, Jun 07, 2021 at 08:11:19AM +1000, Dave Chinner wrote:
> > On Fri, Jun 04, 2021 at 07:15:33PM -0700, Darrick J. Wong wrote:
> > > On Fri, Jun 04, 2021 at 07:03:54PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Jun 04, 2021 at 01:29:28PM +1000, Dave Chinner wrote:
> > > > > Hi Darrick,
> > > > > 
> > > > > Can you please pull the CIL and log improvements from the tag listed
> > > > > below?
> > > > 
> > > > I tried that and threw the series at fstests, which crashed all VMs with
> > > > the following null pointer dereference:
> > > > 
> > > > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > > #PF: supervisor read access in kernel mode
> > > > #PF: error_code(0x0000) - not-present page
> > > > PGD 0 P4D 0 
> > > > Oops: 0000 [#1] PREEMPT SMP
> > > > CPU: 2 PID: 731060 Comm: mount Not tainted 5.13.0-rc4-djwx #rc4
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > > > RIP: 0010:xlog_cil_init+0x2f7/0x370 [xfs]
> > > > Code: b4 7e a0 bf 1c 00 00 00 e8 c6 3b 8d e0 85 c0 78 0c c6 05 13 7f 12 00 01 e9 7b fd ff ff 4
> > > > 2 48 c7 c6 f8 bf 7f a0 <48> 8b 39 e8 f0 24 04 00 31 ff b9 fc 05 00 00 48 c7 c2 d9 b3 7e a0
> > > > RSP: 0018:ffffc9000776bcd0 EFLAGS: 00010286
> > > > RAX: 00000000fffffff0 RBX: 0000000000000000 RCX: 0000000000000000
> > > > RDX: 00000000fffffff0 RSI: ffffffffa07fbff8 RDI: 00000000ffffffff
> > > > RBP: ffff888004cf3c00 R08: ffffffffa078fb40 R09: 0000000000000000
> > > > R10: 000000000000000c R11: 0000000000000048 R12: ffff888052810000
> > > > R13: 0000607f81c0b0f8 R14: ffff888004a09c00 R15: ffff888004a09c00
> > > > FS:  00007fd2e4486840(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 0000000000000000 CR3: 00000000528e5004 CR4: 00000000001706a0
> > > > Call Trace:
> > > >  xlog_alloc_log+0x51f/0x5f0 [xfs]
> > > >  xfs_log_mount+0x55/0x340 [xfs]
> > > >  xfs_mountfs+0x4e4/0x9f0 [xfs]
> > > >  xfs_fs_fill_super+0x4dd/0x7a0 [xfs]
> > > >  ? suffix_kstrtoint.constprop.0+0xe0/0xe0 [xfs]
> > > >  get_tree_bdev+0x175/0x280
> > > >  vfs_get_tree+0x1a/0x80
> > > >  ? capable+0x2f/0x50
> > > >  path_mount+0x6fb/0xa90
> > > >  __x64_sys_mount+0x103/0x140
> > > >  do_syscall_64+0x3a/0x70
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > RIP: 0033:0x7fd2e46e8dde
> > > > Code: 48 8b 0d b5 80 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0
> > > > f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 82 80 0c 00 f7 d8 64 89 01 48
> > > > 
> > > > I'm pretty sure that's due to:
> > > > 
> > > > 	if (!xlog_cil_pcp_init) {
> > > > 		int	ret;
> > > > 
> > > > 		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
> > > > 						"xfs/cil_pcp:dead", NULL,
> > > > 						xlog_cil_pcp_dead);
> > > > 		if (ret < 0) {
> > > > 			xfs_warn(cil->xc_log->l_mp,
> > > > 	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
> > > > 				ret);
> > > > 
> > > > Because we haven't set cil->xc_log yet.
> > > 
> > > And having now fixed that, I get tons of:
> > > 
> > > XFS (sda): Failed to initialise CIL hotplug, error -16. XFS is non-functional.
> > > XFS: Assertion failed: 0, file: fs/xfs/xfs_log_cil.c, line: 1532
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 2 PID: 113983 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> > > Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_REDIR
> > > 
> > > EBUSY??
> > 
> > Ok, so EBUSY implies a setup race - multiple filesystems are trying
> > to run the init code at the same time. That seems somewhat unlikely,
> > but regardless what I'm going to do is move this setup/teardown to
> > the XFS module init functions rather than do it in the CIL.
> > 
> > i.e. turn this into a generic XFS filesystem hotplug infrastructure
> > in xfs_super.c and call out to xlog_cil_pcp_dead() from there.
> > 
> > This way we are guaranteed a single init call when the module is
> > inserted, and a single destroy call when the module is removed. That
> > should solve all these issues.
> > 
> > How do you want me to handle these changes? Just send out the
> > replacement patches for the code that is alread in the branch for
> > review, then resend a rebased pull-req after review? Or something
> > else? I don't really want to keep bombing the mailing list with 40
> > emails every time I need to get fixes for a single patch reviewed...
> 
> I've tested the two patches that will appear as replies to this mail
> as the replacement for the one hotplug infrastructure patch in the
> original series. I've tested it against modular XFS builds, and it
> doesn't cause any problems here.  Essentially the first patch splits
> out the XFS hotplug infrastructure, the second is the CIL
> functionality for handling dead CPU notifications.
> 
> If they work for you, I'll rebase the branch for you to reconstruct
> the for-next tree with the fixes in it...

All tests pass now, so the new patches look good.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
