Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC4767F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 21:06:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E603AC002
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 19:05:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EGaWwc40zTsBvADb for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 19:05:54 -0800 (PST)
Date: Mon, 16 Dec 2013 14:05:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_REPAIR on LVM partition
Message-ID: <20131216030537.GX31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
	<20131216000141.GU31386@dastard>
	<CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG97radg3xd8-G2qChh2BOfH8R6N4kWH3qn3ivukxrkFVrt=rA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rafael Weingartner <rafaelweingartner@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Dec 15, 2013 at 10:34:43PM -0200, Rafael Weingartner wrote:
> So, sadly I went for the big hammer option, I thought that there were no
> other options ;).
> 
> I'm guessing it can't find or validate the primary superblock, so
> > it's looking for a secondary superblock. Please post the output of
> > the running repair so we can see exactly what it is doing.
> 
> That is exactly what it seems that it is happening.
> 
> *dmesg erros:*
> 
> >  81.927888] Pid: 878, comm: mount Not tainted 3.5.0-44-generic
> > #67~precise1-Ubuntu
> > [   81.927891] Call Trace:
> > [   81.927941]  [<ffffffffa01d460f>] xfs_error_report+0x3f/0x50 [xfs]
> > [   81.927972]  [<ffffffffa01ecd66>] ? xfs_free_extent+0xe6/0x130 [xfs]
> > [   81.927990]  [<ffffffffa01ea318>] xfs_free_ag_extent+0x528/0x730 [xfs]
> > [   81.928007]  [<ffffffffa01e8e07>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
> > [   81.928033]  [<ffffffffa01ecd66>] xfs_free_extent+0xe6/0x130 [xfs]
> > [   81.928055]  [<ffffffffa021bb10>] xlog_recover_process_efi+0x170/0x1b0
> > [xfs]
> > [   81.928075]  [<ffffffffa021cd56>]
> > xlog_recover_process_efis.isra.8+0x76/0xd0 [xfs]
> > [   81.928097]  [<ffffffffa0220a17>] xlog_recover_finish+0x27/0xd0 [xfs]
> > [   81.928119]  [<ffffffffa022812c>] xfs_log_mount_finish+0x2c/0x30 [xfs]
> > [   81.928140]  [<ffffffffa0223620>] xfs_mountfs+0x420/0x6b0 [xfs]
> > [   81.928156]  [<ffffffffa01e2ffd>] xfs_fs_fill_super+0x21d/0x2b0 [xfs]
> > [   81.928163]  [<ffffffff8118b716>] mount_bdev+0x1c6/0x210
> > [   81.928179]  [<ffffffffa01e2de0>] ? xfs_parseargs+0xb80/0xb80 [xfs]
> > [   81.928194]  [<ffffffffa01e10a5>] xfs_fs_mount+0x15/0x20 [xfs]
> > [   81.928198]  [<ffffffff8118c563>] mount_fs+0x43/0x1b0
> > [   81.928202]  [<ffffffff811a5ee3>] ? find_filesystem+0x63/0x80
> > [   81.928206]  [<ffffffff811a7246>] vfs_kern_mount+0x76/0x120
> > [   81.928209]  [<ffffffff811a7c34>] do_kern_mount+0x54/0x110
> > [   81.928212]  [<ffffffff811a9934>] do_mount+0x1a4/0x260
> > [   81.928215]  [<ffffffff811a9e10>] sys_mount+0x90/0xe0
> > [   81.928220]  [<ffffffff816a7729>] system_call_fastpath+0x16/0x1b
> > [   81.928229] XFS (dm-0): Failed to recover EFIs
> > [   81.928232] XFS (dm-0): log mount finish failed
> > [   81.972741] XFS (dm-1): Mounting Filesystem
> > [   82.195661] XFS (dm-1): Ending clean mount
> > [   82.203627] XFS (dm-2): Mounting Filesystem
> > [   82.479044] XFS (dm-2): Ending clean mount
> 
> Actually, the problem was a little bit more complicated. This LVM2
> partition, was using a physical device (PV) that is exported by a RAID NAS
> controller.

What's a "RAID NAS controller"? Details, please, or we can't help
you.

> This volume exported by the controller was created using a RAID
> 5, there was a hardware failure in one of the HDs of the array and the
> volume got unavailable, till we replaced the bad driver with a new one and
> the array rebuild finished.

So, hardware RAID5, lost a drive, rebuild on replace, filesystem in
a bad way after rebuild?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
