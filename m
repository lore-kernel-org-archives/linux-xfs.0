Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8F037F4E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 381D5AC00A
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 04:09:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6HLBzMXBSdcSbsaB for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 04:09:37 -0700 (PDT)
Date: Thu, 18 Jul 2013 21:09:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [regression 3.11-rc1] unmount hanging purging quotas
Message-ID: <20130718110931.GA13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hi Chandra,

I'm seeing xfs/050 hanging on a current oss-xfs master tree during
unmount getting stuck purging dquots. it basically loops there
forever. Have you seen anything like this recently?

# echo w > /proc/sysrq-trigger 
[ 5179.063824] SysRq : Show Blocked State
[ 5179.064895]   task                        PC stack   pid father
[ 5179.066459] umount          D ffff88007fd13280  5592 27782  26800 0x00000000
[ 5179.067478]  ffff88007b747b98 0000000000000046 ffff8800524e4500 ffff88007b747fd8
[ 5179.067478]  ffff88007b747fd8 ffff88007b747fd8 ffff88007c83dc00 ffff8800524e4500
[ 5179.067478]  ffff88007b747b88 ffff88007b747bd0 ffff88007c858000 0000000100129cb6
[ 5179.067478] Call Trace:
[ 5179.067478]  [<ffffffff81c53319>] schedule+0x29/0x70
[ 5179.067478]  [<ffffffff81c4fa3b>] schedule_timeout+0x10b/0x1f0
[ 5179.067478]  [<ffffffff8109a1e0>] ? usleep_range+0x50/0x50
[ 5179.067478]  [<ffffffff814d8c20>] ? xfs_qm_need_dqattach+0x80/0x80
[ 5179.067478]  [<ffffffff81c4fb3e>] schedule_timeout_uninterruptible+0x1e/0x20
[ 5179.067478]  [<ffffffff814d911b>] xfs_qm_dquot_walk+0x19b/0x1b0
[ 5179.067478]  [<ffffffff81c54934>] ? _raw_spin_lock_irqsave+0x24/0x30
[ 5179.067478]  [<ffffffff8174c3ad>] ? do_raw_spin_unlock+0x5d/0xb0
[ 5179.067478]  [<ffffffff810a77e4>] ? flush_work+0x34/0x160
[ 5179.067478]  [<ffffffff8109b354>] ? del_timer+0x54/0x70
[ 5179.067478]  [<ffffffff810a9461>] ? try_to_grab_pending+0xd1/0x190
[ 5179.067478]  [<ffffffff814d9170>] xfs_qm_dqpurge_all+0x40/0x90
[ 5179.067478]  [<ffffffff814d9d65>] xfs_qm_unmount+0x25/0x40
[ 5179.067478]  [<ffffffff8147065c>] xfs_unmountfs+0x7c/0x120
[ 5179.067478]  [<ffffffff814735c5>] xfs_fs_put_super+0x25/0x60
[ 5179.067478]  [<ffffffff81191aa1>] generic_shutdown_super+0x61/0xf0
[ 5179.067478]  [<ffffffff81191b60>] kill_block_super+0x30/0x80
[ 5179.067478]  [<ffffffff81191fdd>] deactivate_locked_super+0x4d/0x80
[ 5179.067478]  [<ffffffff81192b8e>] deactivate_super+0x4e/0x70
[ 5179.067478]  [<ffffffff811adaf1>] mntput_no_expire+0x101/0x160
[ 5179.067478]  [<ffffffff811aec9c>] SyS_umount+0x9c/0x3a0
[ 5179.067478]  [<ffffffff81c5d419>] system_call_fastpath+0x16/0x1b

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
