Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33499 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdC0UqO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 16:46:14 -0400
Date: Mon, 27 Mar 2017 13:46:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Suspend fails when xfs is involved?
Message-ID: <20170327204607.GA4874@birch.djwong.org>
References: <20170203010401.GR9134@birch.djwong.org>
 <20170203223127.GC32761@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203223127.GC32761@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-pm@vger.kernel.org

[cc linux-pm since this intersects with suspend...]

On Sat, Feb 04, 2017 at 09:31:27AM +1100, Dave Chinner wrote:
> On Thu, Feb 02, 2017 at 05:04:01PM -0800, Darrick J. Wong wrote:
> > Hi list,
> > 
> > So I've noticed that my laptop consistently fails to suspend with:
> > 
> > [1183625.726800] atkbd serio0: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
> > [1183625.726804] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
> > [1183625.727492] atkbd serio0: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
> > [1183625.727497] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
> > [1183626.203928] e1000e: enp0s25 NIC Link is Down
> > [1183626.422720] PM: Syncing filesystems ... done.
> > [1183626.450348] Freezing user space processes ... (elapsed 0.002 seconds) done.
> > [1183626.452995] Freezing remaining freezable tasks ... 
> > [1183632.657243] atkbd serio0: Unknown key pressed (translated set 2, code 0xd9 on isa0060/serio0).
> > [1183632.657247] atkbd serio0: Use 'setkeycodes e059 <keycode>' to make it known.
> > [1183632.657814] atkbd serio0: Unknown key released (translated set 2, code 0xd9 on isa0060/serio0).
> > [1183632.657817] atkbd serio0: Use 'setkeycodes e059 <keycode>' to make it known.
> > [1183646.459310] Freezing of tasks failed after 20.006 seconds (1 tasks refusing to freeze, wq_busy=0):
> > [1183646.459348] xfsaild/dm-1    D    0  1767      2 0x00000000
> 
> Yes, this can happen because suspend thinks that "sync" is
> sufficient to quiesce a filesystem into an idle state. 
> 
> > [1183646.459366] Call Trace:
> > [1183646.459386]  [<ffffffffb5a43b8d>] schedule+0x3d/0x90
> > [1183646.459390]  [<ffffffffb5a47339>] schedule_timeout+0x239/0x420
> > [1183646.459401]  [<ffffffffb5a450e6>] wait_for_completion+0xa6/0x120
> > [1183646.459460]  [<ffffffffb539ba0f>] xfs_buf_submit_wait+0x7f/0x280
> > [1183646.459466]  [<ffffffffb539bc33>] _xfs_buf_read+0x23/0x30
> > [1183646.459470]  [<ffffffffb539bd64>] xfs_buf_read_map+0x124/0x1b0
> > [1183646.459473]  [<ffffffffb53eb270>] xfs_trans_read_buf_map+0x110/0x370
> > [1183646.459478]  [<ffffffffb538417e>] xfs_imap_to_bp+0x6e/0xe0
> > [1183646.459481]  [<ffffffffb53b3883>] xfs_iflush+0xd3/0x230
> > [1183646.459486]  [<ffffffffb53e0ab4>] xfs_inode_item_push+0xf4/0x150
> > [1183646.459489]  [<ffffffffb53e9cdf>] xfsaild+0x2df/0x740
> > [1183646.459500]  [<ffffffffb51101f9>] kthread+0xd9/0xf0
> 
> That's inode writeback when the underlying inode buffer has been
> reclaimed before the dirty cached inode has been written. So the
> xfsaild is doing read/modify/write cycles to write back dirty
> inodes. i.e. you're running in active memory reclaim conditions
> prior to suspend...

So I wrote up a patch that removes WQ_FREEZABLE from the xfs_buf thread,
and since then I haven't had any problems suspending my laptop.  Last
week at LSF I inquired about whether it was proper to be freezing IO
helper threads as part of suspend, and was told in response "Are you
convinced that use of WQ_FREEZABLE is even correct?"  TBH I can't see
why you'd want to freeze IO helper workqueues at all.

So, I'm going to email that patch out as an RFC and if anyone wants to
follow up the discussion, let's do it there.  I get it, suspend really
should just fsfreeze, but the question I really want to know is, why
does XFS freeze its own threads?  They seem to go to sleep just fine
after we're done doing all the IO we want.

> > ISTR Dave or someone grumbling about this being some artifact of the log
> > trying to read in some buffer or other as part of flushing the log prior
> > to suspend, but the io completion ends up tied to a workqueue that's
> > already been put to sleep, so xfs gets stuck forever.
> 
> Yup, suspend is just completely fucked, has been for more than 10
> years. It needs to freeze filesystems so they are quiesced sanely,
> not left to run while random parts of the kernel infrastructure they
> rely on are shut down behind the filesystem's back.
> 
> > Look familiar to anyone before I try to debug this tomorrow?
> 
> See this as a recent starting point.
> 
> https://lwn.net/Articles/705269/

I wonder if they've done any work on freezing filesystems...

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
