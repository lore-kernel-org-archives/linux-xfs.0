Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B7vnlV117280 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 01:57:49 -0600
Received: from web30207.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5840A1918501
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 23:57:12 -0800 (PST)
Received: from web30207.mail.mud.yahoo.com (web30207.mail.mud.yahoo.com
	[209.191.69.54]) by cuda.sgi.com with SMTP id 89qtHGDKbuHhmD3y
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 23:57:12 -0800 (PST)
Message-ID: <356951.28198.qm@web30207.mail.mud.yahoo.com>
Date: Tue, 10 Feb 2009 23:57:12 -0800 (PST)
From: Rakesh <raksac@yahoo.com>
Subject: BUG: soft lockup detected on CPU#1!
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hello,

I am running the 2.6.28 based xfs kernel driver on a
custom kernel with following kernel config enabled.

CONFIG_PREEMPT
CONFIG_DETECT_SOFTLOCKUP

Running the following xfsqa causes a soft lockup. The
configuration is a x86 with Hyperthreading, 4GB RAM
and a AHCI connected JBOD. Its 100% reproducible.

Any suggestions/inputs on where to start debugging the
problem would be much appreciated.

#! /bin/sh
# FS QA Test No. 008
#
# randholes test
#

BUG: soft lockup detected on CPU#1!
 [<4013d525>] softlockup_tick+0x9c/0xaf
 [<40123246>] update_process_times+0x3d/0x60
 [<401100ab>] smp_apic_timer_interrupt+0x52/0x58
 [<40103633>] apic_timer_interrupt+0x1f/0x24
 [<402a1557>] _spin_lock_irqsave+0x48/0x61
 [<f8b8fe30>] xfs_iflush_cluster+0x16d/0x31c [xfs]
 [<f8b9018b>] xfs_iflush+0x1ac/0x271 [xfs]
 [<f8ba49a1>] xfs_inode_flush+0xd6/0xfa [xfs]
 [<f8bb13c8>] xfs_fs_write_inode+0x27/0x40 [xfs]
 [<401789d9>] __writeback_single_inode+0x1b0/0x2ff
 [<40101ad5>] __switch_to+0x23/0x1f9
 [<40178f87>] sync_sb_inodes+0x196/0x261
 [<4017920a>] writeback_inodes+0x67/0xb1
 [<401465df>] wb_kupdate+0x7b/0xe0
 [<40146bc3>] pdflush+0x0/0x1b5
 [<40146ce1>] pdflush+0x11e/0x1b5
 [<40146564>] wb_kupdate+0x0/0xe0
 [<4012be6d>] kthread+0xc1/0xec
 [<4012bdac>] kthread+0x0/0xec
 [<401038b3>] kernel_thread_helper+0x7/0x10
 =======================

Thanks,
Rakesh



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
