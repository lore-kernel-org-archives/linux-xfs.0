Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CHeEAb015572 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 12:40:14 -0500
Received: from xsnews-ex.xsnews.local (exchange.xsnews.nl [78.152.36.69]) by
	cuda.sgi.com with ESMTP id PxJActBopFeVX0mg (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 10:40:12 -0700 (PDT)
Message-ID: <4FD77EF9.8050805@xsnews.nl>
Date: Tue, 12 Jun 2012 19:40:09 +0200
From: Matthew Whittaker-Williams <matthew@xsnews.nl>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl>
In-Reply-To: <4FD766A7.9030908@xsnews.nl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 6/12/12 5:56 PM, Matthew Whittaker-Williams wrote:

Few more traces:

[ 2162.950080] INFO: task kworker/0:1:11 blocked for more than 120 seconds.
[ 2162.950172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 2162.950265] kworker/0:1     D ffff880603cac668     0    11      2 
0x00000000
[ 2162.950414]  ffff880603df9bf0 0000000000000046 0000000000000000 
ffff880603c56840
[ 2162.950652]  0000000000000400 ffff880603df8010 0000000000013340 
0000000000013340
[ 2162.950890]  ffff880603df9fd8 0000000000013340 ffff880603df9fd8 
0000000000013340
[ 2162.951128] Call Trace:
[ 2162.951195]  [<ffffffff8137e2af>] schedule+0x5f/0x61
[ 2162.951264]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
[ 2162.951334]  [<ffffffff8137d912>] __down_common+0x96/0xe4
[ 2162.951423]  [<ffffffffa037e38c>] ? xfs_getsb+0x32/0x60 [xfs]
[ 2162.951493]  [<ffffffff8137d9bf>] __down+0x18/0x1a
[ 2162.951562]  [<ffffffff81060428>] down+0x28/0x38
[ 2162.951637]  [<ffffffffa032f786>] xfs_buf_lock+0x6f/0xc0 [xfs]
[ 2162.951720]  [<ffffffffa037e38c>] xfs_getsb+0x32/0x60 [xfs]
[ 2162.951800]  [<ffffffffa038b65c>] xfs_trans_getsb+0xb3/0x107 [xfs]
[ 2162.951885]  [<ffffffffa037eda5>] xfs_mod_sb+0x41/0x112 [xfs]
[ 2162.951967]  [<ffffffffa033ebac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
[ 2162.952048]  [<ffffffffa0334434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
[ 2162.952130]  [<ffffffffa0385656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
[ 2162.952214]  [<ffffffffa033ebea>] xfs_sync_worker+0x3e/0x64 [xfs]
[ 2162.957959]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
[ 2162.958030]  [<ffffffff8105531e>] worker_thread+0x13e/0x264
[ 2162.958099]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
[ 2162.958171]  [<ffffffff8105bb50>] kthread+0x84/0x8c
[ 2162.958242]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
[ 2162.958313]  [<ffffffff8105bacc>] ? 
kthread_freezable_should_stop+0x5d/0x5d
[ 2162.958387]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13
[ 4083.044756] INFO: task kworker/0:2:538 blocked for more than 120 seconds.
[ 4083.044850] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 4083.044944] kworker/0:2     D ffff8805ec091de8     0   538      2 
0x00000000
[ 4083.045092]  ffff8805ebb17bf0 0000000000000046 0000000000000000 
ffff880603c56840
[ 4083.045330]  0000000000000400 ffff8805ebb16010 0000000000013340 
0000000000013340
[ 4083.045567]  ffff8805ebb17fd8 0000000000013340 ffff8805ebb17fd8 
0000000000013340
[ 4083.045806] Call Trace:
[ 4083.045874]  [<ffffffff8137e2af>] schedule+0x5f/0x61
[ 4083.045943]  [<ffffffff8137cf95>] schedule_timeout+0x31/0xde
[ 4083.046013]  [<ffffffff8137d912>] __down_common+0x96/0xe4
[ 4083.046101]  [<ffffffffa037e38c>] ? xfs_getsb+0x32/0x60 [xfs]
[ 4083.046171]  [<ffffffff8137d9bf>] __down+0x18/0x1a
[ 4083.046240]  [<ffffffff81060428>] down+0x28/0x38
[ 4083.046315]  [<ffffffffa032f786>] xfs_buf_lock+0x6f/0xc0 [xfs]
[ 4083.046399]  [<ffffffffa037e38c>] xfs_getsb+0x32/0x60 [xfs]
[ 4083.046479]  [<ffffffffa038b65c>] xfs_trans_getsb+0xb3/0x107 [xfs]
[ 4083.046564]  [<ffffffffa037eda5>] xfs_mod_sb+0x41/0x112 [xfs]
[ 4083.046646]  [<ffffffffa033ebac>] ? xfs_flush_inodes+0x2e/0x2e [xfs]
[ 4083.046726]  [<ffffffffa0334434>] xfs_fs_log_dummy+0x61/0x76 [xfs]
[ 4083.046810]  [<ffffffffa0385656>] ? xfs_log_need_covered+0x5a/0xb4 [xfs]
[ 4083.046895]  [<ffffffffa033ebea>] xfs_sync_worker+0x3e/0x64 [xfs]
[ 4083.046968]  [<ffffffff810550d1>] process_one_work+0x1da/0x2e9
[ 4083.047038]  [<ffffffff8105531e>] worker_thread+0x13e/0x264
[ 4083.047107]  [<ffffffff810551e0>] ? process_one_work+0x2e9/0x2e9
[ 4083.047178]  [<ffffffff8105bb50>] kthread+0x84/0x8c
[ 4083.047248]  [<ffffffff81386ae4>] kernel_thread_helper+0x4/0x10
[ 4083.047319]  [<ffffffff8105bacc>] ? 
kthread_freezable_should_stop+0x5d/0x5d
[ 4083.047392]  [<ffffffff81386ae0>] ? gs_change+0x13/0x13


Thanks

Kind regards

Matthew

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
