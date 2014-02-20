Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB2507F88
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 05:16:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8D2C8F8037
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 03:16:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4aayfMvtUCk4nN5R for
	<xfs@oss.sgi.com>; Thu, 20 Feb 2014 03:16:33 -0800 (PST)
Date: Thu, 20 Feb 2014 12:16:26 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <CANWERqOyv3dP-4x2OVO9-1q+LaGh7aQDY-WtZRFkc9opWudHZA@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1402201207410.2245@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140219145239.GA14849@gmail.com>
	<alpine.LFD.2.00.1402191609550.9903@localhost.localdomain>
	<CANWERqOyv3dP-4x2OVO9-1q+LaGh7aQDY-WtZRFkc9opWudHZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-416043165-1392894989=:2245"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>, xfs <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-416043165-1392894989=:2245
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 19 Feb 2014, Dongsu Park wrote:

> Date: Wed, 19 Feb 2014 16:51:23 +0100
> From: Dongsu Park <dongsu.park@profitbricks.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>, tytso <tytso@mit.edu>,
>     linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Wed, Feb 19, 2014 at 4:18 PM, Lukáš Czerner <lczerner@redhat.com> wrote:
> > On Wed, 19 Feb 2014, Dongsu Park wrote:
> > Are you able to reproduce it ? Can you tell me the steps to
> > reproduce this ? The problem is that the extent we're trying to mark
> > as uninitialized has zero length....
> >
> > Ah...I can probably see what is going on. For some inexplicable
> > reason I am forgetting to take i_data_sem which means that we're
> > probably racing with truncate or something else.
> >
> > Thanks a lot for letting me know and If you can please send me a
> > reproducer for your case because as I said I have not seen this
> > before.
> 
> Yes, it's reliably reproducible.
> What I'm doing for testing is quite simple, just like that:
> (/dev/vdb is a test block device, 16GiB in size)
> 
> # mke2fs -t ext4 /dev/vdb
> # mkdir -p /mnt/test1
> # mount -t ext4 -o discard /dev/vdb /mnt/test1
> # dd if=/dev/urandom of=/mnt/test1/file1 bs=2G count=1
> # fallocate -z -l 2G /mnt/test1/file1
> 
> Then kernel crashes immediately.

Oh, now I know where the problem really is. It's not about the
locking at all. Initialized and Uninitialized extents have different
maximum size.

So we can not convert initialized extent of a maximum size to a
uninitialized extent right away. We have to split.

Thank you, your testing is very useful!

-Lukas

> 
> Cheers,
> Dongsu
> 
> > Thanks!
> > -Lukas
> >
> > >
> > > ------------[ cut here ]------------
> > > kernel BUG at fs/ext4/ext4_extents.h:193!
> > > invalid opcode: 0000 [#1] SMP
> > > Modules linked in: 9pnet_virtio virtio_net 9pnet virtio_blk virtio_pci
> > > virtio_ring virtio
> > > CPU: 2 PID: 2959 Comm: fallocate Not tainted 3.14.0-rc3+ #34
> > > Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > task: ffff8800da97da10 ti: ffff880119068000 task.ti: ffff880119068000
> > > RIP: 0010:[<ffffffff813694c9>]  [<ffffffff813694c9>]
> > > ext4_ext_map_blocks+0x2899/0x2940
> > > RSP: 0018:ffff880119069c50  EFLAGS: 00010202
> > > RAX: 0000000000000003 RBX: ffff880036fa8470 RCX: 0000000000000002
> > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff82120e98
> > > RBP: ffff880119069d30 R08: ffff88011975d900 R09: 011ad15618080000
> > > R10: fec72ef09c4d8602 R11: 0000000000008000 R12: ffff880119069dd0
> > > R13: 0000000000000403 R14: 0000000000000001 R15: ffff880118c6700c
> > > FS:  00007fa54a0ba740(0000) GS:ffff88011fc40000(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000003cdbf6f7e0 CR3: 0000000119077000 CR4: 00000000000006e0
> > > Stack:
> > >  0000000000000000 0000000000008000 ffff880036fa86c8 0000000000000000
> > >  ffff880100000000 0000800081384dee 0000000000000001 ffff880000000000
> > >  0000000000008800 0000000000000000 ffff880036f6f000 ffff88011975d900
> > > Call Trace:
> > >  [<ffffffff81385baa>] ? ext4_es_insert_extent+0x15a/0x240
> > >  [<ffffffff813669ae>] ? ext4_find_delalloc_range+0x1e/0xb0
> > >  [<ffffffff81322d3f>] ext4_map_blocks+0x25f/0x830
> > >  [<ffffffff81369764>] ? ext4_alloc_file_blocks+0xc4/0x1e0
> > >  [<ffffffff813697da>] ext4_alloc_file_blocks+0x13a/0x1e0
> > >  [<ffffffff81369e9f>] ext4_zero_range+0x61f/0x870
> > >  [<ffffffff8136a5d3>] ext4_fallocate+0x4e3/0x6c0
> > >  [<ffffffff81239675>] ? __sb_start_write+0x145/0x1a0
> > >  [<ffffffff8120ef00>] ? kmem_cache_free+0x2f0/0x3f0
> > >  [<ffffffff81246ca0>] ? final_putname+0x30/0x60
> > >  [<ffffffff812326a7>] do_fallocate+0x1e7/0x290
> > >  [<ffffffff812327c9>] SyS_fallocate+0x79/0xc0
> > >  [<ffffffff81ae7de9>] system_call_fastpath+0x16/0x1b
> > > Code: ba dc 05 00 00 48 c7 c6 b0 91 c7 81 48 89 df 89 04 24 31 c0 e8 99
> > > 83 fe ff e9 f5 f8 ff ff 48 83 05 34 b3 f5 00 01 e9 0a db ff ff <0f> 0b
> > > 0f 0b 0f 0b 0f 0b 45 89 d1 49 c7 c0 48 22 e5 81 31
> > > RIP  [<ffffffff813694c9>] ext4_ext_map_blocks+0x2899/0x2940
> > >  RSP <ffff880119069c50>
> > > ---[ end trace ba21204a3a98fbdc ]---
> > >
> > > Regards,
> > > Dongsu
> > >
> > > > I'll post the patches after we agree and merge the kernel functionality.
> > > >
> > > > I tested this mostly with a subset of xfstests using fsx and fsstress and
> > > > even with new generic/290 which is just a copy of xfs/290 usinz fzero
> > > > command for xfs_io instead of zero (which uses ioctl). I was testing on
> > > > x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> > > >
> > > > ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083 generic/117 generic/068 generic/231 generic/127 generic/091 generic/075 generic/112 generic/263 generic/091 generic/075 generic/256 generic/255 generic/316 generic/300 generic/290;
> > > >
> > > > Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
> > > > touches the same area as this pach set does, so we should figure out
> > > > which one should go first and modify the other on top of it.
> > > >
> > > > Thanks!
> > > > -Lukas
> > > >
> > > > --
> > > > [PATCH 1/6] ext4: Update inode i_size after the preallocation
> > > > [PATCH 2/6] ext4: refactor ext4_fallocate code
> > > > [PATCH 3/6] ext4: translate fallocate mode bits to strings
> > > > [PATCH 4/6] fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> > > > [PATCH 5/6] ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> > > > [PATCH 6/6] xfs: Add support for FALLOC_FL_ZERO_RANGE
> > > >
> > > >  fs/ext4/ext4.h              |   3 +
> > > >  fs/ext4/extents.c           | 430 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
> > > >  fs/ext4/inode.c             |  17 ++-
> > > >  fs/open.c                   |   7 +-
> > > >  fs/xfs/xfs_file.c           |  10 +-
> > > >  include/trace/events/ext4.h |  67 ++++++-----
> > > >  include/uapi/linux/falloc.h |   1 +
> > > >  7 files changed, 393 insertions(+), 142 deletions(-)
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> 
--8323328-416043165-1392894989=:2245
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-416043165-1392894989=:2245--
