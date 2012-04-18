Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3INmSPt249424 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 18:48:29 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	C5Fth1Jx9SDBn7Fd for <xfs@oss.sgi.com>;
	Wed, 18 Apr 2012 16:48:26 -0700 (PDT)
Date: Thu, 19 Apr 2012 09:48:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120418234821.GR6734@dastard>
References: <20120418151139.GC4652@poseidon.cudanet.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120418151139.GC4652@poseidon.cudanet.local>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Wed, Apr 18, 2012 at 11:11:40AM -0400, Josef 'Jeff' Sipek wrote:
> Greetings!  I have a file server that get a pretty nasty load (about 15
> million files created every day).  After some time, I noticed that the load
> average spiked up from the usual 30 to about 180.  dmesg revealed:
> 
> [434042.318401] INFO: task php:2185 blocked for more than 120 seconds.
> [434042.318403] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [434042.318405] php             D 000000010675d6cd     0  2185  27306 0x00000000
> [434042.318408]  ffff88008d735a48 0000000000000086 ffff88008d735938 ffffffff00000000
> [434042.318412]  ffff88008d734010 ffff88000e28e340 0000000000012000 ffff88008d735fd8
> [434042.318416]  ffff88008d735fd8 0000000000012000 ffff8807ef9966c0 ffff88000e28e340
> [434042.318419] Call Trace:
> [434042.318442]  [<ffffffffa0087a9b>] ? xfs_trans_brelse+0xee/0xf7 [xfs]
> [434042.318464]  [<ffffffffa00689de>] ? xfs_da_brelse+0x71/0x96 [xfs]
> [434042.318485]  [<ffffffffa006df10>] ? xfs_dir2_leaf_lookup_int+0x211/0x225 [xfs]
> [434042.318489]  [<ffffffff8141481e>] schedule+0x55/0x57
> [434042.318512]  [<ffffffffa0083de2>] xlog_reserveq_wait+0x115/0x1c0 [xfs]
> [434042.318515]  [<ffffffff810381f1>] ? try_to_wake_up+0x23d/0x23d
> [434042.318539]  [<ffffffffa0083f45>] xlog_grant_log_space+0xb8/0x1be [xfs]
> [434042.318562]  [<ffffffffa0084164>] xfs_log_reserve+0x119/0x133 [xfs]
> [434042.318585]  [<ffffffffa0080cf1>] xfs_trans_reserve+0xca/0x199 [xfs]
> [434042.318605]  [<ffffffffa00500dc>] xfs_create+0x18d/0x467 [xfs]
> [434042.318623]  [<ffffffffa00485be>] xfs_vn_mknod+0xa0/0xf9 [xfs]
> [434042.318640]  [<ffffffffa0048632>] xfs_vn_create+0xb/0xd [xfs]
> [434042.318644]  [<ffffffff810f0c5d>] vfs_create+0x6e/0x9e
> [434042.318647]  [<ffffffff810f1c5e>] do_last+0x302/0x642
> [434042.318651]  [<ffffffff810f2068>] path_openat+0xca/0x344
> [434042.318654]  [<ffffffff810f23d1>] do_filp_open+0x38/0x87
> [434042.318658]  [<ffffffff810fb22e>] ? alloc_fd+0x76/0x11e
> [434042.318661]  [<ffffffff810e40b1>] do_sys_open+0x10b/0x1a4
> [434042.318664]  [<ffffffff810e4173>] sys_open+0x1b/0x1d
> 
> It makes sense that'd the load average would spike up if some major lock got
> held longer than it should have been.

That's possibly just IO load. It's waiting for log space to become
available, and that will only occur when metadata is written back to
disk.

What's the storage subsystem, what IO scheduler, the actually
workload that is running at the time the spike occurs (e.g did
someone run a directory traversal that changed every indoe?), and so
on.

Also, getting the output of 'echo w > /proc/sysrq-trigger' whould be
helpful here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
