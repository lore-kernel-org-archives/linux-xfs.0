Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02CNKCo106285 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:23:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48B001DAB8F8
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:24:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ONBYLIySBVlEtlRO for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 04:24:08 -0800 (PST)
Date: Sat, 2 Jan 2010 23:24:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Don't flush stale inodes
Message-ID: <20100102122405.GI13802@discord.disaster>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
	<20100102120053.GB18502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102120053.GB18502@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 07:00:53AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 01:39:40PM +1100, Dave Chinner wrote:
> > Because inodes remain in cache much longer than inode buffers do
> > under memory pressure, we can get the situation where we have stale,
> > dirty inodes being reclaimed but the backing storage has been freed.
> > Hence we should never, ever flush XFS_ISTALE inodes to disk as
> > there is no guarantee that the backing buffer is in cache and
> > still marked stale when the flush occurs.
> 
> We should not flush stale inodes.  But how do we even end up calling
> xfs_iflush with a stale inode?

Actually, here's most of the failure trace (unlimited scrollback buffers are
great):

[ 5703.683858] Device sdb2 - bad inode magic/vsn daddr 16129976 #0 (magic=0)
[ 5703.690689] ------------[ cut here ]------------
[ 5703.691665] kernel BUG at fs/xfs/support/debug.c:62!
[ 5703.691665] invalid opcode: 0000 [#1] SMP
[ 5703.691665] last sysfs file: /sys/devices/virtual/net/lo/operstate
[ 5703.691665] CPU 1
[ 5703.691665] Modules linked in:
[ 5703.691665] Pid: 4017, comm: xfssyncd Not tainted 2.6.32-dgc #73 IBM eServer 326m -[796955M]-
[ 5703.691665] RIP: 0010:[<ffffffff813925a1>]  [<ffffffff813925a1>] cmn_err+0x101/0x110
[ 5703.691665] RSP: 0018:ffff8800a8cfdaa0  EFLAGS: 00010246
[ 5703.691665] RAX: 0000000002deff6d RBX: ffffffff819102d0 RCX: 0000000000000006
[ 5703.691665] RDX: ffffffff81fb5130 RSI: ffff8800ae2d9ba0 RDI: ffff8800ae2d9440
[ 5703.691665] RBP: ffff8800a8cfdb90 R08: 0000000000000000 R09: 0000000000000001
[ 5703.691665] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[ 5703.691665] R13: 0000000000000282 R14: 0000000000000000 R15: ffff8800ae34ca88
[ 5703.691665] FS:  00007f64efe476f0(0000) GS:ffff880007600000(0000) knlGS:0000000000000000
[ 5703.691665] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 5703.691665] CR2: 00007f64efe4b000 CR3: 00000000ad04f000 CR4: 00000000000006e0
[ 5703.691665] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5703.691665] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5703.691665] Process xfssyncd (pid: 4017, threadinfo ffff8800a8cfc000, task ffff8800ae2d9440)
[ 5703.691665] Stack:
[ 5703.691665]  0000003000000030 ffff8800a8cfdba0 ffff8800a8cfdac0 ffff8800ad585b24
[ 5703.691665] <0> 0000000000000002 ffffffff8135e77d ffff8800a8cfdbe0 0000000000f61fb8
[ 5703.691665] <0> 0000000000000000 0000000000000000 ffff8800a8cfdb10 ffffffff81388330
[ 5703.691665] Call Trace:
[ 5703.691665]  [<ffffffff8135e77d>] ? xfs_itobp+0x6d/0x100
[ 5703.691665]  [<ffffffff81388330>] ? _xfs_buf_read+0x90/0xa0
[ 5703.691665]  [<ffffffff81388a8c>] ? xfs_buf_read+0xdc/0x110
[ 5703.691665]  [<ffffffff8137a9cf>] ? xfs_trans_read_buf+0x43f/0x680
[ 5703.691665]  [<ffffffff8117b723>] ? disk_name+0x63/0xc0
[ 5703.691665]  [<ffffffff8135e62a>] xfs_imap_to_bp+0x15a/0x240
[ 5703.691665]  [<ffffffff8135e77d>] ? xfs_itobp+0x6d/0x100
[ 5703.691665]  [<ffffffff8135e77d>] xfs_itobp+0x6d/0x100
[ 5703.691665]  [<ffffffff81360397>] xfs_iflush+0x207/0x380
[ 5703.691665]  [<ffffffff81390d7f>] xfs_reclaim_inode+0x15f/0x1b0
[ 5703.691665]  [<ffffffff81390e38>] xfs_reclaim_inode_now+0x68/0x90
[ 5703.691665]  [<ffffffff81390dd0>] ? xfs_reclaim_inode_now+0x0/0x90
[ 5703.691665]  [<ffffffff81391744>] xfs_inode_ag_walk+0x64/0xc0
[ 5703.691665]  [<ffffffff81373552>] ? xfs_perag_get+0xe2/0x110
[ 5703.691665]  [<ffffffff81391817>] xfs_inode_ag_iterator+0x77/0xc0
[ 5703.691665]  [<ffffffff81390dd0>] ? xfs_reclaim_inode_now+0x0/0x90

I was hitting this regularly with workloads creating then removing
hundreds of thousands of small files, and the patch I sent stopped
them from occurring...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
