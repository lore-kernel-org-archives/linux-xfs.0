Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EC8C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 02:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGNCLf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 22:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGNCLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 22:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16752BEE
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 19:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D57A61DA0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 02:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D8BC3411E;
        Thu, 14 Jul 2022 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657764692;
        bh=TwHNRh24CnU9TDejWoMV02iPWI0k9YW+qhwa0g00+Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwVbYh09ZZNgzjMBOB8ZaliIoJbKbeHcJWLa5+aHFeGkobMRdvX0U/9NV3Zr9PRug
         VfrFsfU/kCBBrNohSnlVymsnMGeAiwq7bM1V7EguIwnAqgwCG9PzBiig4EKAh6YsCv
         NAOzx1ClJqUePFhL5wzBXcA3iJDMBbHHk2I5fm8Y2NXjvuNTCdVkUXhs49pPK1Nv3C
         XWwOBY3+LDaE+MvIUcxFkwAmazE+I664GrLaUkWl3snzZtWvBPr6bb3PFj4W5Iq8/x
         ZBnH/S21IcgCsIns+PKHwfk+8ekrOLo+5KIGO1OptGxh57QrDSVj6AvjqaToAbD32F
         qhSuXHboUn4Bg==
Date:   Wed, 13 Jul 2022 19:11:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6 v3] xfs: lockless buffer lookups
Message-ID: <Ys97VOzdb/FXxHHU@magnolia>
References: <20220707235259.1097443-1-david@fromorbit.com>
 <Ys76W8V72KJmXN+B@magnolia>
 <20220714013201.GP3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714013201.GP3861211@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 14, 2022 at 11:32:01AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2022 at 10:01:15AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 08, 2022 at 09:52:53AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > Current work to merge the XFS inode life cycle with the VFS indoe
> > > life cycle is finding some interesting issues. If we have a path
> > > that hits buffer trylocks fairly hard (e.g. a non-blocking
> > > background inode freeing function), we end up hitting massive
> > > contention on the buffer cache hash locks:
> > 
> > Hmm.  I applied this to a test branch and this fell out of xfs/436 when
> > it runs rmmod xfs.  I'll see if I can reproduce it more regularly, but
> > thought I'd put this out there early...
> > 
> > XFS (sda3): Unmounting Filesystem
> > =============================================================================
> > BUG xfs_buf (Not tainted): Objects remaining in xfs_buf on __kmem_cache_shutdown()
> > -----------------------------------------------------------------------------
> > 
> > Slab 0xffffea000443b780 objects=18 used=4 fp=0xffff888110edf340 flags=0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
> > CPU: 3 PID: 30378 Comm: modprobe Not tainted 5.19.0-rc5-djwx #rc5 bebda13a030d0898279476b6652ddea67c2060cc
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x34/0x44
> >  slab_err+0x95/0xc9
> >  __kmem_cache_shutdown.cold+0x39/0x1e9
> >  kmem_cache_destroy+0x49/0x130
> >  exit_xfs_fs+0x50/0xc57 [xfs 370e1c994a59de083c05cd4df389f629878b8122]
> >  __do_sys_delete_module.constprop.0+0x145/0x220
> >  ? exit_to_user_mode_prepare+0x6c/0x100
> >  do_syscall_64+0x35/0x80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > RIP: 0033:0x7fe7d7877c9b
> > Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00 f7 d8 64 89 01 48
> > RSP: 002b:00007fffb911cab8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> > RAX: ffffffffffffffda RBX: 0000555a217adcc0 RCX: 00007fe7d7877c9b
> > RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000555a217add28
> > RBP: 0000555a217adcc0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 00007fe7d790fac0 R11: 0000000000000206 R12: 0000555a217add28
> > R13: 0000000000000000 R14: 0000555a217add28 R15: 00007fffb911ede8
> >  </TASK>
> > Disabling lock debugging due to kernel taint
> > Object 0xffff888110ede000 @offset=0
> > Object 0xffff888110ede1c0 @offset=448
> > Object 0xffff888110edefc0 @offset=4032
> > Object 0xffff888110edf6c0 @offset=5824
> 
> Curious, I haven't seen anything from KASAN that would indicate a
> leak is occurring, and unmount can't occur while there are still
> referenced buffers in the system. So what might be leaking is a bit
> of a mystery to me right now...
> 
> Is this a result of xfs/436 running by itself, or left over from
> some other prior test? i.e. if you add a '_reload_fs_module "xfs"'
> call before the test does anything, does it complain?

Still digging into that.  I ran ./check -I 100 xfs/434 xfs/436 and
couldn't reproduce it, so I'll have to dig further.  You might as well
push the patchset along since that's the only time this has happened
despite several days and dozens of VMs testing this.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
