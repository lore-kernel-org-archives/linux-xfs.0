Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 627628027
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 09:18:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D23F6AC003
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 07:18:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KEiyPdblUbCYkYbk for
	<xfs@oss.sgi.com>; Wed, 19 Feb 2014 07:18:08 -0800 (PST)
Date: Wed, 19 Feb 2014 16:18:01 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <20140219145239.GA14849@gmail.com>
Message-ID: <alpine.LFD.2.00.1402191609550.9903@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140219145239.GA14849@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Wed, 19 Feb 2014, Dongsu Park wrote:

> Date: Wed, 19 Feb 2014 15:52:39 +0100
> From: Dongsu Park <dongsu.park@profitbricks.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
>     xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> Hi Lukas,
> 
> On 17.02.2014 16:08, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which you
> > can find here:
> > 
> > http://people.redhat.com/lczerner/zero_range/
> 
> Thank you for your great work!
> I've tested it both on xfs and on ext4.
> (Test environment: Fedora 20, Kernel 3.14-rc3 + your patches,
>  util-linux v2.24-232-g3c7ed4a + your patches)
> 
> It seems to work with xfs without problem.
> On ext4, however, immediately after doing "fallocate -z",
> kernel crashes with the following error:

That's weird I have not seen that before even after running tests
for several days and fallocate -z works as expected for me.

Are you able to reproduce it ? Can you tell me the steps to
reproduce this ? The problem is that the extent we're trying to mark
as uninitialized has zero length....


Ah...I can probably see what is going on. For some inexplicable
reason I am forgetting to take i_data_sem which means that we're
probably racing with truncate or something else.

Thanks a lot for letting me know and If you can please send me a
reproducer for your case because as I said I have not seen this
before.

Thanks!
-Lukas

> 
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/ext4_extents.h:193!
> invalid opcode: 0000 [#1] SMP 
> Modules linked in: 9pnet_virtio virtio_net 9pnet virtio_blk virtio_pci
> virtio_ring virtio
> CPU: 2 PID: 2959 Comm: fallocate Not tainted 3.14.0-rc3+ #34
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> task: ffff8800da97da10 ti: ffff880119068000 task.ti: ffff880119068000
> RIP: 0010:[<ffffffff813694c9>]  [<ffffffff813694c9>]
> ext4_ext_map_blocks+0x2899/0x2940
> RSP: 0018:ffff880119069c50  EFLAGS: 00010202
> RAX: 0000000000000003 RBX: ffff880036fa8470 RCX: 0000000000000002
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff82120e98
> RBP: ffff880119069d30 R08: ffff88011975d900 R09: 011ad15618080000
> R10: fec72ef09c4d8602 R11: 0000000000008000 R12: ffff880119069dd0
> R13: 0000000000000403 R14: 0000000000000001 R15: ffff880118c6700c
> FS:  00007fa54a0ba740(0000) GS:ffff88011fc40000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000003cdbf6f7e0 CR3: 0000000119077000 CR4: 00000000000006e0
> Stack:
>  0000000000000000 0000000000008000 ffff880036fa86c8 0000000000000000
>  ffff880100000000 0000800081384dee 0000000000000001 ffff880000000000
>  0000000000008800 0000000000000000 ffff880036f6f000 ffff88011975d900
> Call Trace:
>  [<ffffffff81385baa>] ? ext4_es_insert_extent+0x15a/0x240
>  [<ffffffff813669ae>] ? ext4_find_delalloc_range+0x1e/0xb0
>  [<ffffffff81322d3f>] ext4_map_blocks+0x25f/0x830
>  [<ffffffff81369764>] ? ext4_alloc_file_blocks+0xc4/0x1e0
>  [<ffffffff813697da>] ext4_alloc_file_blocks+0x13a/0x1e0
>  [<ffffffff81369e9f>] ext4_zero_range+0x61f/0x870
>  [<ffffffff8136a5d3>] ext4_fallocate+0x4e3/0x6c0
>  [<ffffffff81239675>] ? __sb_start_write+0x145/0x1a0
>  [<ffffffff8120ef00>] ? kmem_cache_free+0x2f0/0x3f0
>  [<ffffffff81246ca0>] ? final_putname+0x30/0x60
>  [<ffffffff812326a7>] do_fallocate+0x1e7/0x290
>  [<ffffffff812327c9>] SyS_fallocate+0x79/0xc0
>  [<ffffffff81ae7de9>] system_call_fastpath+0x16/0x1b
> Code: ba dc 05 00 00 48 c7 c6 b0 91 c7 81 48 89 df 89 04 24 31 c0 e8 99
> 83 fe ff e9 f5 f8 ff ff 48 83 05 34 b3 f5 00 01 e9 0a db ff ff <0f> 0b
> 0f 0b 0f 0b 0f 0b 45 89 d1 49 c7 c0 48 22 e5 81 31
> RIP  [<ffffffff813694c9>] ext4_ext_map_blocks+0x2899/0x2940
>  RSP <ffff880119069c50>
> ---[ end trace ba21204a3a98fbdc ]---
> 
> Regards,
> Dongsu
> 
> > I'll post the patches after we agree and merge the kernel functionality.
> > 
> > I tested this mostly with a subset of xfstests using fsx and fsstress and
> > even with new generic/290 which is just a copy of xfs/290 usinz fzero
> > command for xfs_io instead of zero (which uses ioctl). I was testing on
> > x86_64 and ppc64 with block sizes of 1024, 2048 and 4096.
> > 
> > ./check generic/076 generic/232 generic/013 generic/070 generic/269 generic/083 generic/117 generic/068 generic/231 generic/127 generic/091 generic/075 generic/112 generic/263 generic/091 generic/075 generic/256 generic/255 generic/316 generic/300 generic/290;
> > 
> > Note that there is a work in progress on FALLOC_FL_COLLAPSE_RANGE which
> > touches the same area as this pach set does, so we should figure out
> > which one should go first and modify the other on top of it.
> > 
> > Thanks!
> > -Lukas
> > 
> > -- 
> > [PATCH 1/6] ext4: Update inode i_size after the preallocation
> > [PATCH 2/6] ext4: refactor ext4_fallocate code
> > [PATCH 3/6] ext4: translate fallocate mode bits to strings
> > [PATCH 4/6] fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> > [PATCH 5/6] ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> > [PATCH 6/6] xfs: Add support for FALLOC_FL_ZERO_RANGE
> > 
> >  fs/ext4/ext4.h              |   3 +
> >  fs/ext4/extents.c           | 430 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
> >  fs/ext4/inode.c             |  17 ++-
> >  fs/open.c                   |   7 +-
> >  fs/xfs/xfs_file.c           |  10 +-
> >  include/trace/events/ext4.h |  67 ++++++-----
> >  include/uapi/linux/falloc.h |   1 +
> >  7 files changed, 393 insertions(+), 142 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
