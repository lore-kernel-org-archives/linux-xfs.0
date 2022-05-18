Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D4BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 17:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiERRGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 13:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240778AbiERRGC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 13:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290131706E
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 10:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6E62616DE
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 17:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6DAC385A9;
        Wed, 18 May 2022 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652893559;
        bh=By+9+L8ybCRFsFR/OLjL49ubNogtx/y1oyvXTK8lGa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCkHjauTgFww78Atof1ipxS1LnVmfhO+aD/gaWDRkFLQIVY2vvyZr0kMEOn1a/2Dg
         bl5Rh25AWVjat8GlWLiTvB1kQtWUsreMsOdyqRjLfljHVDqN+32N7/5mHhrOIwXpP6
         /+XWbTA6TcNk7Up68dHClJAvxja271VT+nkV4FjlqTpzzIki20hqDicgwNhwSmviEn
         uYWdIBVLkS0LSKcBub0+iYdHH02Sn2XzNr1nc01m6a1Vvh5vWCY7ceZr6YZoTgRkVx
         OGPGjCes4c02zMpiJCvhKHIuYqzW245q3eEtSFDFTXVcO6gZI4zQPHeePn3RmBl8Vl
         ihhBqJzINrIrA==
Date:   Wed, 18 May 2022 10:05:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCHSET 0/4] xfs: fix leaks and validation errors in logged
 xattr updates
Message-ID: <YoUndiuV8xWNJtHY@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
 <20220518091413.GQ1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518091413.GQ1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 07:14:13PM +1000, Dave Chinner wrote:
> On Sun, May 15, 2022 at 08:31:52PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > As I've detailed in my reply to Dave, this is a short series of fixes
> > for the 5.19 for-next branch that fixes some validation deficiencies in
> > xattr log item recovery and some memory leaks due to a confusing API.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       |   32 ++++++++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
> >  fs/xfs/xfs_attr_item.c         |   36 +++++++++++++++++++++++++++---------
> >  3 files changed, 57 insertions(+), 20 deletions(-)
> 
> Ok, somewhere in your two patchsets there is a new crash bug
> freeing da_state structures. It's tripped by Catherine's LARP test
> with my mods on top of that.
> 
> [17268.337737] BUG: kernel NULL pointer dereference, address: 00000000000000e0
> [17268.340269] #PF: supervisor read access in kernel mode
> [17268.342032] #PF: error_code(0x0000) - not-present page
> [17268.343802] PGD 0 P4D 0 
> [17268.344758] Oops: 0000 [#1] PREEMPT SMP
> [17268.346093] CPU: 15 PID: 3417611 Comm: mount Not tainted 5.18.0-rc7-dgc+ #1247
> [17268.348579] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [17268.351457] RIP: 0010:xfs_da_state_kill_altpath+0x5/0x40
> [17268.353290] Code: 00 00 48 c7 c2 88 c4 84 82 48 c7 c6 10 c0 84 82 31 ff e8 99 5f 7c 00 eb c3 e8 a7 b3 80 00 cc cc cc cc cc cc cc 0f 1f 44 00 00 <8b> 97 e0 00 00 00 85 d2 7e 26 48 8d 87 e8 00 00 00 83 ea 01 48 8d
> [17268.359442] RSP: 0018:ffffc90006227ba8 EFLAGS: 00010286
> [17268.360918] RAX: 00000000ffffffc3 RBX: ffff888802540300 RCX: ffff888802264050
> [17268.362913] RDX: 0000000000000000 RSI: ffffc90006227bac RDI: 0000000000000000
> [17268.364909] RBP: 0000000000000000 R08: ffff8888031b4380 R09: ffff88880537a708
> [17268.366893] R10: ffffc90006227ab8 R11: 0000000000000000 R12: 00000000ffffffc3
> [17268.368884] R13: 0000000000000000 R14: ffff888802540358 R15: ffff8888064ea000
> [17268.370871] FS:  00007f269a1f6800(0000) GS:ffff88883ed80000(0000) knlGS:0000000000000000
> [17268.373133] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [17268.374744] CR2: 00000000000000e0 CR3: 000000080510b004 CR4: 0000000000060ee0
> [17268.376743] Call Trace:
> [17268.377478]  <TASK>
> [17268.378131]  xfs_da_state_free+0xe/0x30
> [17268.379362]  xfs_attr_set_iter+0x5f2/0xa30
> [17268.380533]  xfs_xattri_finish_update+0x45/0x80
> [17268.381931]  xfs_attri_item_recover+0x308/0x4d0
> [17268.383208]  xlog_recover_process_intents+0xcc/0x330
> [17268.384632]  ? _raw_spin_lock_irqsave+0x17/0x20
> [17268.386005]  ? _raw_spin_unlock_irqrestore+0xe/0x30
> [17268.387375]  ? __mod_timer+0x205/0x3a0
> [17268.388456]  ? xfs_alloc_pagf_init+0x52/0x60
> [17268.389669]  xlog_recover_finish+0x13/0x100
> [17268.390858]  xfs_log_mount_finish+0x157/0x1e0
> [17268.392100]  xfs_mountfs+0x548/0x980
> [17268.393125]  ? xfs_filestream_get_parent+0x80/0x80
> [17268.394482]  xfs_fs_fill_super+0x487/0x8c0
> [17268.395651]  ? xfs_open_devices+0x1e0/0x1e0
> [17268.396847]  get_tree_bdev+0x16c/0x270
> [17268.397920]  vfs_get_tree+0x1f/0xb0
> [17268.398917]  path_mount+0x2b6/0xa80
> [17268.399923]  __x64_sys_mount+0x103/0x140
> [17268.401040]  do_syscall_64+0x35/0x80
> [17268.402064]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> I haven't yet dug into which patch introduces the problem, but it is
> a new regression with these 10 patches applied. I'll try to
> reproduce tomorrow, if it's reproducable I'll bisect.

Ah, that's a stupid coding error in the first patch -- if the
xfs_attr_node_hasname call returns error != -EEXIST, we never actually
set the state variable that is then passed to xfs_da_state_free.  I knew
I should've converted that last bit:

	if (error) {
		xfs_da_state_free(attr->xattri_da_state);
		attr->xattri_da_state = NULL;
	}

Frankly, I don't even think all those calls to tear down the
xfs_attr_item's da state are necessary, since it seems silly to keep
cycling them through the allocator when we could just zero them when we
no longer need them, and let the attr intent destructor free the state
once and for all.

--D

> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
