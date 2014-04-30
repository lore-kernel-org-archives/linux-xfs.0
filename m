Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B53429DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 22:22:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5887304062
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 20:22:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SiFvp6i3jt4872Ln for <xfs@oss.sgi.com>;
	Tue, 29 Apr 2014 20:22:12 -0700 (PDT)
Date: Wed, 30 Apr 2014 13:22:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
Message-ID: <20140430032209.GA22353@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
	<20140428234558.GD18672@dastard>
	<CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
	<20140429010121.GE18672@dastard>
	<CALjwKZBj0f_y7MPp-PLqhLDOnfmf2OWsvv_vbnX08ubevqM+Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALjwKZBj0f_y7MPp-PLqhLDOnfmf2OWsvv_vbnX08ubevqM+Bg@mail.gmail.com>
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
To: Bob Mastors <bob.mastors@solidfire.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 29, 2014 at 03:47:15PM -0600, Bob Mastors wrote:
> On Mon, Apr 28, 2014 at 7:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Apr 28, 2014 at 05:51:31PM -0600, Bob Mastors wrote:
> > > Log output attached.
> > > The xfs filesystem being mounted and unmounted is the only xfs filesystem
> > > on the system.
> > > Bob
> > >
> > >
> > > On Mon, Apr 28, 2014 at 5:45 PM, Dave Chinner <david@fromorbit.com>
> > wrote:
> > >
> > > > On Mon, Apr 28, 2014 at 04:29:02PM -0600, Bob Mastors wrote:
> > > > > Greetings,
> > > > >
> > > > > I have an xfs umount hang caused by forcing the block device to
> > return
> > > > > i/o errors while copying files to the filesystem.
> > > > > Detailed steps to reproduce the problem on virtualbox are below.
> > > > >
> > > > > The linux version is a recent pull and reports as 3.15.0-rc3.
> > > > >
> > > > > [ 2040.248096] INFO: task umount:10303 blocked for more than 120
> > seconds.
> > > > > [ 2040.323947]       Not tainted 3.15.0-rc3 #4
> > > > > [ 2040.343423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > > disables
> > > > > this message.
> > > > > [ 2040.352665] umount          D ffffffff8180fe40     0 10303   8691
> > > > > 0x00000000
> > > > > [ 2040.404918]  ffff88001e33dd58 0000000000000086 ffff88001e33dd48
> > > > > ffffffff81080f82
> > > > > [ 2040.489901]  ffff88001b311900 0000000000013180 ffff88001e33dfd8
> > > > > 0000000000013180
> > > > > [ 2040.534772]  ffff88003daa3200 ffff88001b311900 ffff88002421aec0
> > > > > ffff88002421ae80
> > > > > [ 2040.587450] Call Trace:
> > > > > [ 2040.592176]  [<ffffffff81080f82>] ? try_to_wake_up+0x232/0x2b0
> > > > > [ 2040.620212]  [<ffffffff816c54d9>] schedule+0x29/0x70
> > > > > [ 2040.627685]  [<ffffffffa04c4cd6>] xfs_ail_push_all_sync+0x96/0xd0
> > > > [xfs]
> > > > > [ 2040.632236]  [<ffffffff81092230>] ? __wake_up_sync+0x20/0x20
> > > > > [ 2040.659105]  [<ffffffffa04731a3>] xfs_unmountfs+0x63/0x160 [xfs]
> > > > > [ 2040.691774]  [<ffffffffa0478f65>] ? kmem_free+0x35/0x40 [xfs]
> > > > > [ 2040.698610]  [<ffffffffa0474cf5>] xfs_fs_put_super+0x25/0x60 [xfs]
> > > > > [ 2040.706838]  [<ffffffff8119561e>]
> > generic_shutdown_super+0x7e/0x100
> > > > > [ 2040.723958]  [<ffffffff811956d0>] kill_block_super+0x30/0x80
> > > > > [ 2040.734963]  [<ffffffff8119591d>]
> > deactivate_locked_super+0x4d/0x80
> > > > > [ 2040.745485]  [<ffffffff8119652e>] deactivate_super+0x4e/0x70
> > > > > [ 2040.751274]  [<ffffffff811b1d42>] mntput_no_expire+0xd2/0x160
> > > > > [ 2040.755894]  [<ffffffff811b2fff>] SyS_umount+0xaf/0x3b0
> > > > > [ 2040.761032]  [<ffffffff816d1592>] system_call_fastpath+0x16/0x1b
> > > > > [ .060058] XFS (sdb): xfs_log_force: error 5 returned.
> > > > > [ 268059] XFS (sdb): xfs_log_force: error 5 returned.
> > > > >
> > > > > I took a look at xfs_ail_push_all_sync and it is pretty easy to see
> > > > > the hang. But it is not obvious to me how to fix it.
> > > > > Any ideas would be appreciated.
> > > > >
> > > > > I am available to run additional tests or capture more logging
> > > > > or whatever if that would help.
> > > >
> > > > What's the entire log output from the first shutdown message?
> >
> > So what is the AIL stuck on? Can you trace the xfs_ail* trace points
> > when it is in shutdown like this and post the output of the report?
> >
> 
> 
> # tracer: function
> #
> # entries-in-buffer/entries-written: 32/32   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>           umount-2995  [003] ....  1125.524090: xfs_unmountfs <-xfs_fs_put_super
>           umount-2995  [003] ....  1125.524099: xfs_ail_push_all_sync <-xfs_unmountfs
>           umount-2995  [003] ....  1125.527498: xfs_ail_push_all_sync <-xfs_log_quiesce
>          kswapd0-43    [002] ....  1148.078330: xfs_ail_push_all <-xfs_reclaim_inodes_nr
>          kswapd0-43    [002] ....  1148.078332: xfs_ail_push <-xfs_ail_push_all
>      xfsaild/sdb-3005  [002] ....  1148.128311: xfs_ail_min_lsn <-xfsaild
>          kswapd0-43    [001] ....  1149.971684: xfs_ail_push_all <-xfs_reclaim_inodes_nr
>          kswapd0-43    [001] ....  1149.971695: xfs_ail_push <-xfs_ail_push_all
>      xfsaild/sdb-3005  [003] ....  1150.023104: xfs_ail_min_lsn <-xfsaild
>           umount-3013  [000] .N..  1153.035350: xfs_unmountfs <-xfs_fs_put_super
>           umount-3013  [000] ....  1153.093488: xfs_ail_push_all_sync <-xfs_unmountfs
>           umount-3013  [000] ....  1153.122459: xfs_ail_push_all_sync <-xfs_log_quiesce
>          kswapd0-43    [003] ....  1186.232408: xfs_ail_push_all <-xfs_reclaim_inodes_nr
>          kswapd0-43    [003] ....  1186.232411: xfs_ail_push <-xfs_ail_push_all
>      xfsaild/sdb-3035  [001] ....  1186.288258: xfs_ail_min_lsn <-xfsaild
>           umount-3043  [001] ....  1188.653981: xfs_unmountfs <-xfs_fs_put_super
>           umount-3043  [001] ....  1188.653991: xfs_ail_push_all_sync <-xfs_unmountfs
>      kworker/0:0-2865  [000] ....  1199.903174: xfs_ail_min_lsn <-xfs_log_need_covered
>      kworker/0:0-2865  [000] ....  1199.903179: xfs_ail_push_all <-xfs_log_worker
>      kworker/0:0-2865  [000] ....  1199.903180: xfs_ail_push <-xfs_ail_push_all
>      kworker/0:0-2865  [000] ....  1229.837372: xfs_ail_min_lsn <-xfs_log_need_covered
>      kworker/0:0-2865  [000] ....  1229.837377: xfs_ail_push_all <-xfs_log_worker
>      kworker/0:0-2865  [000] ....  1229.837378: xfs_ail_push <-xfs_ail_push_all
>      kworker/0:0-2865  [000] ....  1259.835355: xfs_ail_min_lsn <-xfs_log_need_covered
>      kworker/0:0-2865  [000] ....  1259.835360: xfs_ail_push_all <-xfs_log_worker
>      kworker/0:0-2865  [000] ....  1259.835360: xfs_ail_push <-xfs_ail_push_all
>      kworker/0:0-2865  [000] ....  1289.834315: xfs_ail_min_lsn <-xfs_log_need_covered
>      kworker/0:0-2865  [000] ....  1289.834320: xfs_ail_push_all <-xfs_log_worker
>      kworker/0:0-2865  [000] ....  1289.834321: xfs_ail_push <-xfs_ail_push_all
>      kworker/0:0-2865  [000] ....  1319.831564: xfs_ail_min_lsn <-xfs_log_need_covered
>      kworker/0:0-2865  [000] ....  1319.831569: xfs_ail_push_all <-xfs_log_worker
>      kworker/0:0-2865  [000] ....  1319.831570: xfs_ail_push <-xfs_ail_push_all
> 
> The first two xfs_unmountfs in the above log worked fine, no hang.
> The third one hung.

Well, I guess I should been more specific. ftrace is pretty much
useless here - we need the information taht is recorded by the
events, not the timing of the events.

# trace-cmd record -e xfs_ail*
....
^C
....
# trace-cmd report
version = 6
cpus=1
    kworker/0:1H-1269  [000] 104529.901271: xfs_ail_insert:       dev 253:16 lip 0x0xffff880017a4b740 old lsn 0/0 new lsn 1/20 type XFS_LI_BUF flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901273: xfs_ail_insert:       dev 253:16 lip 0x0xffff880017a4bbc8 old lsn 0/0 new lsn 1/20 type XFS_LI_BUF flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901273: xfs_ail_insert:       dev 253:16 lip 0x0xffff88001b6f8098 old lsn 0/0 new lsn 1/20 type XFS_LI_INODE flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901274: xfs_ail_insert:       dev 253:16 lip 0x0xffff880027600c80 old lsn 0/0 new lsn 1/20 type XFS_LI_EFI flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901274: xfs_ail_insert:       dev 253:16 lip 0x0xffff88001b6f81c8 old lsn 0/0 new lsn 1/20 type XFS_LI_INODE flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901274: xfs_ail_insert:       dev 253:16 lip 0x0xffff88001b6f8130 old lsn 0/0 new lsn 1/20 type XFS_LI_INODE flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901274: xfs_ail_insert:       dev 253:16 lip 0x0xffff880017a4b488 old lsn 0/0 new lsn 1/20 type XFS_LI_BUF flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901275: xfs_ail_insert:       dev 253:16 lip 0x0xffff880017a4bcb0 old lsn 0/0 new lsn 1/20 type XFS_LI_BUF flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901275: xfs_ail_insert:       dev 253:16 lip 0x0xffff880017a4b910 old lsn 0/0 new lsn 1/20 type XFS_LI_BUF flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901275: xfs_ail_insert:       dev 253:16 lip 0x0xffff88001b6f8000 old lsn 0/0 new lsn 1/20 type XFS_LI_INODE flags IN_AIL
    kworker/0:1H-1269  [000] 104529.901277: xfs_ail_delete:       dev 253:16 lip 0x0xffff880027600c80 old lsn 1/20 new lsn 1/20 type XFS_LI_EFI flags IN_AIL
     xfsaild/vdb-14828 [000] 104529.901338: xfs_ail_push:         dev 253:16 lip 0x0xffff88001b6f8000 lsn 1/20 type XFS_LI_INODE flags IN_AIL
     xfsaild/vdb-14828 [000] 104529.901339: xfs_ail_push:         dev 253:16 lip 0x0xffff880017a4b910 lsn 1/20 type XFS_LI_BUF flags IN_AIL
     xfsaild/vdb-14828 [000] 104529.901339: xfs_ail_push:         dev 253:16 lip 0x0xffff880017a4bcb0 lsn 1/20 type XFS_LI_BUF flags IN_AIL
     xfsaild/vdb-14828 [000] 104529.901340: xfs_ail_push:         dev 253:16 lip 0x0xffff880017a4b488 lsn 1/20 type XFS_LI_BUF flags IN_AIL
.....

> [  240.930278] xfsaild/sdb     D ffffffff8180fe40     0  5640      2 0x00000000
> [  240.931408]  ffff88003cd5dc58 0000000000000046 ffff88003cd5dc68 ffffffff81069029
> [  240.933116]  ffff88003cdc8000 0000000000013180 ffff88003cd5dfd8 0000000000013180
> [  240.934655]  ffff88003daa1900 ffff88003cdc8000 ffff88003cd5dc28 0000000000000011
> [  240.936328] Call Trace:
> [  240.936862]  [<ffffffff81069029>] ? flush_work+0x139/0x1e0
> [  240.937755]  [<ffffffff816c54d9>] schedule+0x29/0x70
> [  240.938532]  [<ffffffffa04be2b2>] xlog_cil_force_lsn+0x192/0x200 [xfs]
> [  240.939452]  [<ffffffff81081000>] ? try_to_wake_up+0x2b0/0x2b0
> [  240.940366]  [<ffffffffa04bc4ad>] _xfs_log_force+0x6d/0x2b0 [xfs]
> [  240.941302]  [<ffffffffa04bc729>] xfs_log_force+0x39/0xc0 [xfs]
> [  240.942174]  [<ffffffffa04c1567>] xfsaild+0x137/0x6e0 [xfs]
> [  240.943008]  [<ffffffffa04c1430>] ? xfs_trans_ail_cursor_first+0xa0/0xa0 [xfs]
> [  240.944240]  [<ffffffff81071ae9>] kthread+0xc9/0xe0
> [  240.945001]  [<ffffffff81071a20>] ? flush_kthread_worker+0xb0/0xb0
> [  240.945884]  [<ffffffff816d14ec>] ret_from_fork+0x7c/0xb0
> [  240.946696]  [<ffffffff81071a20>] ? flush_kthread_worker+0xb0/0xb0

Try the patch here:

http://oss.sgi.com/pipermail/xfs/2014-April/035870.html

Needs a minor fix to compile as noted here:

http://oss.sgi.com/pipermail/xfs/2014-April/035878.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
