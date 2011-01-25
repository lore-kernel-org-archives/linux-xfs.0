Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PDCrkg011390 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 07:12:54 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FD7C1057F9E
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 05:15:15 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 0KGX1EtI9qnHIpQz for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 05:15:15 -0800 (PST)
Date: Tue, 25 Jan 2011 08:15:15 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.37: XFS / BUG: soft lockup - CPU#0 stuck for 61s!
	[kworker/0:0:4783]
Message-ID: <alpine.DEB.2.00.1101250810500.19338@p34.internal.lan>
MIME-Version: 1.0
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
Cc: linux-kernel@vger.kernel.org

Hi,

I was rm -rf'ing some directories with many files and I tried to mkdir a 
directory elsewhere on the filesystem and this happened:

# ps auxww | grep ' D '
root       560  0.0  0.0      0     0 ?        D    Jan20   0:00 [fsnotify_mark]
root      1327  0.0  0.0      0     0 ?        D    Jan20   0:07 [xfssyncd/sda1]
root     19006  5.8  0.0   4472   768 pts/40   D    08:07   0:10 rm -rf dir1 dir2 dir3 dir4 dir5 dir6

The filesystem in question:
/dev/sda1 on /r1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144,delaylog,inode64)

The lockup:

[392833.039090] BUG: soft lockup - CPU#0 stuck for 61s! [kworker/0:0:4783]
[392833.039094] Modules linked in:
[392833.039095] CPU 0 
[392833.039096] Modules linked in:
[392833.039097] 
[392833.039099] Pid: 4783, comm: kworker/0:0 Not tainted 2.6.37 #2 DP55KG/ 
[392833.039101] RIP: 0010:[<ffffffff812286b2>]  [<ffffffff812286b2>] xfs_ail_insert+0x12/0x80
[392833.039105] RSP: 0018:ffff8800c24edd08  EFLAGS: 00000202
[392833.039107] RAX: ffff8802c2c11078 RBX: ffff88017426da98 RCX: 0000007a0012eb01
[392833.039108] RDX: ffff8802c1d19660 RSI: ffff88017426da98 RDI: 0000007a0012eb02
[392833.039109] RBP: ffffffff8149cbce R08: 000000000000007a R09: 000000000000007a
[392833.039111] R10: ffff88041a436c48 R11: ffff8802d4e93058 R12: 000000000000001b
[392833.039112] R13: ffff88041e85db00 R14: dead000000100100 R15: ffffffff810a0f07
[392833.039113] FS:  0000000000000000(0000) GS:ffff8800df000000(0000) knlGS:0000000000000000
[392833.039115] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[392833.039116] CR2: 00000000025cc098 CR3: 000000028bcec000 CR4: 00000000000006f0
[392833.039118] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[392833.039119] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[392833.039120] Process kworker/0:0 (pid: 4783, threadinfo ffff8800c24ec000, task ffff880057a56750)
[392833.039122] Stack:
[392833.039123]  ffffffff8122876c ffff88017426da98 ffff88041a436c40 000000000000007a
[392833.039126]  ffff88041e59a9c0 ffff88041e59aa48 ffffffff81227236 ffff880356dfccc0
[392833.039128]  0000007a0012eb01 ffff88023de8a340 ffff88006f6dba40 0000000000000000
[392833.039130] Call Trace:
[392833.039133]  [<ffffffff8122876c>] ? xfs_trans_ail_update+0x4c/0xd0
[392833.039136]  [<ffffffff81227236>] ? xfs_trans_item_committed+0xb6/0xe0
[392833.039139]  [<ffffffff8121cc90>] ? xlog_cil_committed+0x30/0xe0
[392833.039141]  [<ffffffff8121968c>] ? xlog_state_do_callback+0x15c/0x2c0
[392833.039144]  [<ffffffff81231b20>] ? xfs_buf_iodone_work+0x0/0x60
[392833.039147]  [<ffffffff8104829b>] ? process_one_work+0xfb/0x3b0
[392833.039149]  [<ffffffff8104892e>] ? worker_thread+0x14e/0x400
[392833.039151]  [<ffffffff810487e0>] ? worker_thread+0x0/0x400
[392833.039152]  [<ffffffff810487e0>] ? worker_thread+0x0/0x400
[392833.039155]  [<ffffffff8104c0e6>] ? kthread+0x96/0xa0
[392833.039158]  [<ffffffff81003014>] ? kernel_thread_helper+0x4/0x10
[392833.039160]  [<ffffffff8104c050>] ? kthread+0x0/0xa0
[392833.039162]  [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10
[392833.039163] Code: 48 8b 6c 24 10 4c 8b 64 24 18 4c 8b 6c 24 20 48 83 c4 28 e9 11 0b ff ff 90 4c 8d 57 08 4c 3b 57 08 74 58 48 8b 47 10 48 8b 50 08 <49> 39 c2 0f 18 0a 74 20 48 8b 4e 10 48 8b 78 10 49 89 c8 49 89 
[392833.039179] Call Trace:
[392833.039180]  [<ffffffff8122876c>] ? xfs_trans_ail_update+0x4c/0xd0
[392833.039182]  [<ffffffff81227236>] ? xfs_trans_item_committed+0xb6/0xe0
[392833.039184]  [<ffffffff8121cc90>] ? xlog_cil_committed+0x30/0xe0
[392833.039186]  [<ffffffff8121968c>] ? xlog_state_do_callback+0x15c/0x2c0
[392833.039188]  [<ffffffff81231b20>] ? xfs_buf_iodone_work+0x0/0x60
[392833.039190]  [<ffffffff8104829b>] ? process_one_work+0xfb/0x3b0
[392833.039192]  [<ffffffff8104892e>] ? worker_thread+0x14e/0x400
[392833.039194]  [<ffffffff810487e0>] ? worker_thread+0x0/0x400
[392833.039196]  [<ffffffff810487e0>] ? worker_thread+0x0/0x400
[392833.039198]  [<ffffffff8104c0e6>] ? kthread+0x96/0xa0
[392833.039200]  [<ffffffff81003014>] ? kernel_thread_helper+0x4/0x10
[392833.039202]  [<ffffffff8104c050>] ? kthread+0x0/0xa0
[392833.039204]  [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10

Is this normal?  Is it because I am using delaylog?  I notice when I use 
delaylog, there is an EXTREME amount of lag/hanging of the system 
sometimes when deleting thousands/millions of files until its done.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
