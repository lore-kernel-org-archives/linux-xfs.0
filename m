Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5950E7F5E
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:54:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF97AAC007
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:54:24 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id S7wEixCbHhiNGQo2 for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 07:54:22 -0800 (PST)
Date: Wed, 4 Mar 2015 10:54:21 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150304155421.GE1627@fieldses.org>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304020826.GD19439@fieldses.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Mar 03, 2015 at 09:08:26PM -0500, J. Bruce Fields wrote:
> On Wed, Mar 04, 2015 at 09:44:56AM +1100, Dave Chinner wrote:
> > On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> > > I'm getting mysterious crashes on a server exporting an xfs filesystem.
> > > 
> > > Strangely, I've reproduced this on
> > > 
> > > 	93aaa830fc17 "Merge tag 'xfs-pnfs-for-linus-3.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
> > > 
> > > but haven't yet managed to reproduce on either of its parents
> > > (24a52e412ef2 or 781355c6e5ae).  That might just be chance, I'll try
> > > again.
> > 
> > I think you'll find that the bug is only triggered after that XFS
> > merge because it's what enabled block layout support in the server,
> > i.e.  nfsd4_setup_layout_type() is now setting the export type to
> > LAYOUT_BLOCK_VOLUME because XFS has added the necessary functions to
> > it's export ops.
> 
> Doh--after all the discussion I didn't actually pay attention to what
> happened in the end.  OK, I see, you're right, it's all more-or-less
> dead code till that merge.
> 
> Christoph's code was passing all my tests before that, so maybe we
> broke something in the merge process.
> 
> Alternatively, it could be because I've added more tests--I'll rerun my
> current tests on his original branch....

The below is on Christoph's pnfsd-for-3.20-4 (at cd4b02e).  Doesn't look
very informative.  I'm running xfstests over NFSv4.1 with client and
server running the same kernel, the filesystem in question is xfs, but
isn't otherwise available to the client (so the client shouldn't be
doing pnfs).

--b.

BUG: unable to handle kernel paging request at 00000000757d4900
IP: [<ffffffff810b59af>] cpuacct_charge+0x5f/0xa0
PGD 0 
Thread overran stack, or stack corrupted
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: rpcsec_gss_krb5 nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
CPU: 1 PID: 18130 Comm: kworker/1:0 Not tainted 3.19.0-rc4-00205-gcd4b02e #79
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
Workqueue: rpciod rpc_async_schedule [sunrpc]
task: ffff880030639710 ti: ffff88001e698000 task.ti: ffff88001e698000
RIP: 0010:[<ffffffff810b59af>]  [<ffffffff810b59af>] cpuacct_charge+0x5f/0xa0
RSP: 0018:ffff88007f903e08  EFLAGS: 00010092
RAX: 000000000000d4e8 RBX: 000000001e698038 RCX: 000000001e698038
RDX: ffffffff822377c0 RSI: 0000000000000003 RDI: ffff880030639f78
RBP: ffff88007f903e38 R08: 0000000000000000 R09: 0000000000000001
R10: 000000000000001b R11: ffffffff82238fc0 R12: 00000000003b4c1b
R13: ffff880030639710 R14: ffff880030639710 R15: 0000001536dbb554
FS:  0000000000000000(0000) GS:ffff88007f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000757d4900 CR3: 000000006d8e2000 CR4: 00000000000406e0
Stack:
 ffffffff810b5955 0000000000000000 ffff88007f903e98 ffff880030639778
 ffff88007f913698 00000000003b4c1b ffff88007f903e78 ffffffff810a47d0
 ffff88007f903e78 ffff880030639778 ffff88007f913698 ffff88007f913600
Call Trace:
 <IRQ> 
 [<ffffffff810b5955>] ? cpuacct_charge+0x5/0xa0
 [<ffffffff810a47d0>] update_curr+0xd0/0x190
 [<ffffffff810a767f>] task_tick_fair+0x1df/0x4f0
 [<ffffffff8109e147>] scheduler_tick+0x57/0xd0
 [<ffffffff810d7e11>] update_process_times+0x51/0x60
 [<ffffffff810e43df>] tick_periodic+0x2f/0xc0
 [<ffffffff8165b517>] ? debug_smp_processor_id+0x17/0x20
 [<ffffffff810e4599>] tick_handle_periodic+0x29/0x70
 [<ffffffff81033e6a>] local_apic_timer_interrupt+0x3a/0x70
 [<ffffffff81a8fb81>] smp_apic_timer_interrupt+0x41/0x60
 [<ffffffff81a8df1f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
Code: 31 c9 45 31 c0 31 f6 48 c7 c7 c0 8f 23 82 e8 a9 71 00 00 49 8b 85 c0 0f 00 00 48 63 cb 48 8b 50 58 0f 1f 00 48 8b 82 d0 00 00 00 <48> 03 04 cd 40 47 31 82 4c 01 20 48 8b 52 48 48 85 d2 75 e5 48 
RIP  [<ffffffff810b59af>] cpuacct_charge+0x5f/0xa0
 RSP <ffff88007f903e08>
CR2: 00000000757d4900
---[ end trace fa7901843d14b3ab ]---
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
---[ end Kernel panic - not syncing: Fatal exception in interrupt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
