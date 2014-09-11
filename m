Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E5F0C7FB1
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 17:03:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D47C88F8037
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:03:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rzL0hRORzdaGsOp0 for <xfs@oss.sgi.com>;
	Thu, 11 Sep 2014 15:03:24 -0700 (PDT)
Date: Fri, 12 Sep 2014 08:03:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: more pagecache invalidation issues?
Message-ID: <20140911220317.GB4322@dastard>
References: <20140911211443.GA2191@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911211443.GA2191@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Sep 11, 2014 at 02:14:43PM -0700, Christoph Hellwig wrote:
> I just hit this with Linus' tree from a day or two ago when running
> xfstests in my 64-bit x86 kvm VM:
> 
> [ 1810.820601] ------------[ cut here ]------------
> [ 1810.821730] kernel BUG at ../fs/xfs/xfs_aops.c:1373!
> [ 1810.822881] invalid opcode: 0000 [#1] SMP 
> [ 1810.823177] Modules linked in:
> [ 1810.823177] CPU: 0 PID: 5324 Comm: 4980.fsstress.b Not tainted 3.17.0-rc4+ #266
> [ 1810.823177] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [ 1810.823177] task: ffff88004fedc910 ti: ffff88000b340000 task.ti: ffff88000b340000
> [ 1810.823177] RIP: 0010:[<ffffffff8150139b>]  [<ffffffff8150139b>] __xfs_get_blocks+0x5cb/0x5d0
> [ 1810.823177] RSP: 0018:ffff88000b343998  EFLAGS: 00010202
> [ 1810.823177] RAX: ffff880079ddf580 RBX: 0000000000166000 RCX: ffff88004fedd0f8
> [ 1810.823177] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000246
> [ 1810.823177] RBP: ffff88000b343a38 R08: 0000000000000001 R09: 0000000000000000
> [ 1810.823177] R10: 0000000000000000 R11: 00000000000785b0 R12: ffff88004863d9a0
> [ 1810.823177] R13: ffff88004863d700 R14: ffff88000b343b50 R15: 0000000000000000
> [ 1810.823177] FS:  00007ff4401c6700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
> [ 1810.823177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1810.823177] CR2: 00007ff4400c2008 CR3: 000000004fed3000 CR4: 00000000000006f0
> [ 1810.823177] Stack:
> [ 1810.823177]  ffff88000b343a18 0000000000005000 ffff88000b3439c8 ffff880000000000
> [ 1810.823177]  ffff880000000008 0000000000000166 000188004ff2e940 0000000000005000
> [ 1810.823177]  ffff88000b343a18 0000000100000202 000000000000015e ffffffffffffffff
> [ 1810.823177] Call Trace:
> [ 1810.823177]  [<ffffffff815013af>] xfs_get_blocks_direct+0xf/0x20
> [ 1810.823177]  [<ffffffff811f3ffe>] __blockdev_direct_IO+0x9ee/0x3340
> [ 1810.823177]  [<ffffffff815013a0>] ? __xfs_get_blocks+0x5d0/0x5d0
> [ 1810.823177]  [<ffffffff814ff7d0>] xfs_vm_direct_IO+0x130/0x150
> [ 1810.823177]  [<ffffffff815013a0>] ? __xfs_get_blocks+0x5d0/0x5d0
> [ 1810.823177]  [<ffffffff8117116a>] generic_file_read_iter+0x54a/0x610
> [ 1810.823177]  [<ffffffff810f5a8a>] ? mark_held_locks+0x6a/0x90
> [ 1810.823177]  [<ffffffff8150c6e9>] xfs_file_read_iter+0xf9/0x2b0
> [ 1810.823177]  [<ffffffff81193e3e>] ? might_fault+0x3e/0x90
> [ 1810.823177]  [<ffffffff811b9b69>] new_sync_read+0x79/0xb0
> [ 1810.823177]  [<ffffffff811bac6b>] vfs_read+0x9b/0x190
> [ 1810.823177]  [<ffffffff811baf11>] SyS_read+0x51/0xc0
> [ 1810.823177]  [<ffffffff81d9f6e9>] system_call_fastpath+0x16/0x1b
> 
> The BUG_ON is this one:
> 
> 	if (imap.br_startblock == DELAYSTARTBLOCK) {
> 		BUG_ON(direct);
> 		if (create) {
> 			..

That's a symptom of the problem I've been chasing for the past *18
months*. Every time we fix another bunch of bufferhead coherency
bugs, I hope that it goes away. It hasn't, and Brian's latest set of
collapse_range fixes have made it substantially worse on my test
machines. However, Brian has a simply test case we are discussing on
#xfs right now that reproduces on of the issues, and again it looks
like stray delalloc blocks and/or dirty buffers beyond EOF being the
source of the problems.

We're slowly fixing the problems we find, but the frequency of
that bug being hit is increasing and decreasing as time goes on. But
in reality we still haven't found the root cause because it's been
so hard to reliably reproduce....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
