Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BED0E7CA2
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 01:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FBA38F8040
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 23:36:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PYtTr9Z28mPG9Zyp for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 23:35:56 -0700 (PDT)
Date: Wed, 1 Jun 2016 16:35:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V4
Message-ID: <20160601063553.GI12670@dastard>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 09, 2016 at 10:47:03AM +0200, Christoph Hellwig wrote:
> This series add a new file system I/O path that uses the iomap structure
> introduced for the pNFS support and support multi-page buffered writes.
> 
> This was first started by Dave Chinner a long time ago, then I did beat
> it into shape for production runs in a very constrained ARM NAS
> enviroment for Tuxera almost as long ago, and now half a dozen rewrites
> later it's back.
> 
> The basic idea is to avoid the per-block get_blocks overhead
> and make use of extents in the buffered write path by iterating over
> them instead.
> 
> Note that patch 1 conflicts with Vishals dax error handling series.
> It would be great to have a stable branch with it so that both the
> XFS and nvdimm tree could pull it in before the other changes in this
> area.

I just pulled this forward to 4.7-rc1, and I get an immediate
failure in generic/346:

[   70.701300] ------------[ cut here ]------------
[   70.702029] kernel BUG at fs/xfs/xfs_aops.c:1253!
[   70.702778] invalid opcode: 0000 [#1] PREEMPT SMP
[   70.703484] Modules linked in:
[   70.703952] CPU: 2 PID: 5374 Comm: holetest Not tainted 4.7.0-rc1-dgc+ #812
[   70.704991] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
[   70.706285] task: ffff8801365e23c0 ti: ffff8800b0698000 task.ti: ffff8800b0698000
[   70.707395] RIP: 0010:[<ffffffff814f5ba7>]  [<ffffffff814f5ba7>] __xfs_get_blocks+0x597/0x6b0
[   70.708768] RSP: 0000:ffff8800b069b990  EFLAGS: 00010246
[   70.709518] RAX: ffff88013ac283c0 RBX: 000000000005c000 RCX: 000000000000000c
[   70.710527] RDX: 000000000005d000 RSI: 0000000000000008 RDI: ffff8800b3fc1b90
[   70.711579] RBP: ffff8800b069ba18 R08: 000000000000006b R09: ffff8800b069b914
[   70.712626] R10: 0000000000000000 R11: 000000000000006b R12: ffff8800b3fc1ce0
[   70.713656] R13: 0000000000001000 R14: ffff8800b069bb38 R15: ffff8800b9442000
[   70.714653] FS:  00007ff002a27700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[   70.715820] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.716669] CR2: 00007ff00436ec00 CR3: 00000000ae8c1000 CR4: 00000000000006e0
[   70.717656] Stack:
[   70.717940]  ffff8800b3fc1b40 ffff8800b3fc1b60 ffff880000000000 000000000000005c
[   70.719062]  ffff880100000000 ffff8800b3fc1b00 0000000000000000 00000001b069b9d8
[   70.720199]  0000000000000000 ffffffffffffffff 000000000000005d 0000000000000000
[   70.721294] Call Trace:
[   70.721644]  [<ffffffff814f5cd7>] xfs_get_blocks+0x17/0x20
[   70.722401]  [<ffffffff812368f4>] do_mpage_readpage+0x3d4/0x710
[   70.723250]  [<ffffffff811ab61e>] ? lru_cache_add+0xe/0x10
[   70.724013]  [<ffffffff81236d28>] mpage_readpages+0xf8/0x150
[   70.724828]  [<ffffffff814f5cc0>] ? __xfs_get_blocks+0x6b0/0x6b0
[   70.725654]  [<ffffffff814f5cc0>] ? __xfs_get_blocks+0x6b0/0x6b0
[   70.726504]  [<ffffffff811e544c>] ? alloc_pages_current+0x8c/0x110
[   70.727365]  [<ffffffff814f38d8>] xfs_vm_readpages+0x38/0xa0
[   70.728177]  [<ffffffff811a97f2>] __do_page_cache_readahead+0x192/0x230
[   70.729107]  [<ffffffff8119e030>] filemap_fault+0x440/0x4b0
[   70.729881]  [<ffffffff81e39080>] ? down_read+0x20/0x40
[   70.730616]  [<ffffffff815007cf>] xfs_filemap_fault+0x5f/0x110
[   70.731456]  [<ffffffff811c2907>] __do_fault+0x67/0xf0
[   70.732205]  [<ffffffff811c6aa9>] handle_mm_fault+0x239/0x1460
[   70.733015]  [<ffffffff810a2403>] __do_page_fault+0x1c3/0x4f0
[   70.733821]  [<ffffffff810a27f3>] trace_do_page_fault+0x43/0x140
[   70.734654]  [<ffffffff8109cc8a>] do_async_page_fault+0x1a/0xa0
[   70.735493]  [<ffffffff81e3d018>] async_page_fault+0x28/0x30
[   70.736500] Code: 41 ff d2 4d 8b 16 4d 85 d2 75 dd 4c 8b 65 98 4c 8b 75 80 65 ff 0d 82 69 b1 7e 74 11 e9 e6 fb ff ff e8 76 c4 b0 ff e9 e9 fd ff ff <0f> 0b e8 6a c4
[   70.740283] RIP  [<ffffffff814f5ba7>] __xfs_get_blocks+0x597/0x6b0
[   70.741157]  RSP <ffff8800b069b990>
[   70.742097] ---[ end trace aeed47f2452ca28a ]---

Maybe I screwed up the forward merge sorting out all the bits that
conflicted with what went into 4.7-rc1. Perhaps it would be best if
you rebased and reposted, Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
