Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD7167F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 18:28:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BDA518F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 16:28:38 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id aDbyD8mcKCTr74cn for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 16:28:33 -0700 (PDT)
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 37055207B2
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 23:28:32 +0000 (UTC)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id F3B6F20647
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 23:28:30 +0000 (UTC)
Received: by obbkm3 with SMTP id km3so181214764obb.1
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2015 16:28:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150709224118.GB7943@dastard>
References: <1436338913.13729.11.camel@hasee> <20150708085341.GA23332@lst.de>
	<1436363862.15921.0.camel@hasee>
	<CAF1ivSYJEraUn_jEOEZg06D36yOYsZNrLz2Vzv=_Umpkao7Otw@mail.gmail.com>
	<1436424844.22691.2.camel@hasee> <20150709224118.GB7943@dastard>
Date: Thu, 9 Jul 2015 16:28:30 -0700
Message-ID: <CAF1ivSYq3AfHVi0jCq4bvUvzacz4RQmWkz_dy2GmDF8U_d6BeA@mail.gmail.com>
Subject: Re: xfs_io bmap confused
From: Ming Lin <mlin@kernel.org>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 9, 2015 at 3:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 08, 2015 at 11:54:04PM -0700, Ming Lin wrote:
>> On Wed, 2015-07-08 at 16:40 -0700, Ming Lin wrote:
>> > On Wed, 2015-07-08 at 06:57 -0700, Ming Lin wrote:
>> > > On Wed, 2015-07-08 at 10:53 +0200, Christoph Hellwig wrote:
>> > > > On Wed, Jul 08, 2015 at 12:01:53AM -0700, Ming Lin wrote:
>> > > > > Hi list,
>> > > > >
>> > > > > I am testing some direct-io patches.
>> > > > > xfs_tests/xfs/080 failed.
>> > > > >
>> > > > > It's strange.
>> > > > > There is no hole in "rwtest.file",
>> > > > > but when read it at some offset it returns zero because of hole.
>> > > > >
>> > > > > root@block:~# xfs_io -c bmap /mnt/test/rwtest.file
>> > > > > /mnt/test/rwtest.file:
>> > > > >              0: [0..125671]: 160..125831
>> > > >
>> > > > Sounds like you see an unwritten extent.  What does xfs_bmap -pv show on
>> > > > the file?
>> > >
>> > > root@block:~# xfs_bmap -pv /mnt/test/rwtest.file
>> > > /mnt/test/rwtest.file:
>> > >  EXT: FILE-OFFSET       BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>> > >    0: [0..743]:         160..903          0 (160..903)         744 00000
>> > >    1: [744..783]:       904..943          0 (904..943)          40 10000
>> > >    2: [784..951]:       944..1111         0 (944..1111)        168 00000
>> > >    3: [952..1023]:      1112..1183        0 (1112..1183)        72 10000
>> > >    4: [1024..1287]:     1184..1447        0 (1184..1447)       264 00000
>> > >    5: [1288..1383]:     1448..1543        0 (1448..1543)        96 10000
>> >
>> > file offset 659456 is in EXT 5.
>> > I guess FLAGS 1 means it's an unwritten extent, right?
>> >
>> > xfs_tests/xfs/080 basically does:
>> > 1. direct io write
>> > 2. then buffered read to check the previous dio write
>> >
>> > Here is an example of error logs.
>> >
>> > doio ( 3626) 16:13:23
>> > ---------------------
>> > *** DATA COMPARISON ERROR ***
>> > check_file(/mnt/test/rwtest.file, 239616, 81408, H:3626:block:doio*,
>> > 18, 0) failed
>> >
>> > Comparison fd is 5, with open flags 0
>> > Corrupt regions follow - unprintable chars are represented as '.'
>> > -----------------------------------------------------------------
>> > corrupt bytes starting at file offset 241664
>> >     1st 32 expected bytes:  oio*H:3626:block:doio*H:3626:blo
>> >     1st 32 actual bytes:    ................................
>> >
>> > Request number 981
>> >           fd 4 is file /mnt/test/rwtest.file - open flags are 040001
>> > O_WRONLY,O_DIRECT,
>> >           write done at file offset 239616 - pattern is H (0110)
>> >           number of requests is 1, strides per request is 1
>> >           i/o byte count = 81408
>> >           memory alignment is aligned
>> >           DIRECT I/O: offset % 512 = 0 length % 81408 = 0
>> >           mem alignment 0x200 xfer size: small: 512 large: 2147483136
>> >
>> > syscall:  writev(4, (iov on stack), 1)
>> >
>> >
>> > The "expected bytes" was actually written to the disk successfully,
>> > but for some bug the xfs extent flag was not set correctly.
>> > The flag should be "XFS_EXT_NORM", but now it's "XFS_EXT_UNWRITTEN".
>> >
>> > Could you share the code path the extent flag was updated?
>> > Is it also updated through direct io?
>>
>> For XFS direct IO, are below the only 2 paths to convert unwritten
>> extent to written extent?
>>
>> [   72.279043] Call Trace:
>> [   72.279719]  [<ffffffff8169c2f3>] dump_stack+0x4f/0x7b
>> [   72.280898]  [<ffffffff8127140f>] xfs_bmapi_convert_unwritten+0x73/0x176
>> [   72.282393]  [<ffffffff8127a233>] xfs_bmapi_write+0x2a0/0x7ee
>> [   72.283705]  [<ffffffff812b8ae8>] xfs_iomap_write_direct+0x23e/0x2f0
>> [   72.285132]  [<ffffffff8129ef88>] __xfs_get_blocks+0x14c/0xf6c
>> [   72.286456]  [<ffffffff8103d74b>] ? get_user_pages_fast+0xee/0x14c
>> [   72.287847]  [<ffffffff8129fdcf>] xfs_get_blocks_direct+0x14/0x16
>> [   72.289246]  [<ffffffff811879c6>] get_blocks+0x86/0x182
>> [   72.297467]  [<ffffffff8103d74b>] ? get_user_pages_fast+0xee/0x14c
>> [   72.298845]  [<ffffffff81187fe6>] __blockdev_direct_IO+0x372/0x666
>> [   72.300266]  [<ffffffff8129fdbb>] ? xfs_get_blocks+0x13/0x13
>> [   72.301555]  [<ffffffff8116f9ac>] ? __mnt_drop_write_file+0x12/0x14
>> [   72.302936]  [<ffffffff8116a017>] ? file_update_time+0xb5/0xcb
>> [   72.304279]  [<ffffffff8129d890>] xfs_vm_direct_IO+0x89/0x90
>> [   72.305555]  [<ffffffff8129d943>] ? xfs_setfilesize_trans_alloc+0xac/0xac
>> [   72.307064]  [<ffffffff8169ae5e>] xfs_file_dio_aio_write+0x2e0/0x449
>> [   72.308509]  [<ffffffff813e1028>] ? __clear_user+0x36/0x5b
>> [   72.309755]  [<ffffffff812af9c6>] xfs_file_write_iter+0x75/0x105
>> [   72.311107]  [<ffffffff81151524>] __vfs_write+0x97/0xc0
>> [   72.312347]  [<ffffffff81151b1f>] vfs_write+0xb5/0x16f
>> [   72.313526]  [<ffffffff811522c3>] SyS_write+0x4a/0x94
>> [   72.314683]  [<ffffffff816a4b17>] system_call_fastpath+0x12/0x6f
>
> There should not be unwritten extent conversion happening through
> the allocation path here. Indeed, xfs_iomap_write_direct() only uses
> the XFS_BMAPI_PREALLOC flag, which means
> xfs_bmapi_convert_unwritten() returns without doing anything to the
> newly allocated extent...
>
>> [   72.328096] Call Trace:
>> [   72.328786]  [<ffffffff8169c2f3>] dump_stack+0x4f/0x7b
>> [   72.330002]  [<ffffffff8127140f>] xfs_bmapi_convert_unwritten+0x73/0x176
>> [   72.331565]  [<ffffffff8126cd9d>] ? xfs_bmap_search_extents+0x60/0xd6
>> [   72.333059]  [<ffffffff812c96f1>] ? kmem_zone_alloc+0x6e/0xba
>> [   72.334412]  [<ffffffff8127a233>] xfs_bmapi_write+0x2a0/0x7ee
>> [   72.335777]  [<ffffffff812b9455>] xfs_iomap_write_unwritten+0x205/0x413
>> [   72.337300]  [<ffffffff8129d7e2>] xfs_end_io+0x50/0x75
>> [   72.338495]  [<ffffffff8129dab9>] xfs_end_io_direct_write+0x176/0x26c
>> [   72.339952]  [<ffffffff810d20a4>] ? delayacct_end+0x55/0x5e
>> [   72.341238]  [<ffffffff8118759d>] dio_complete+0x7c/0x134
>> [   72.342488]  [<ffffffff811882a7>] __blockdev_direct_IO+0x633/0x666
>> [   72.343908]  [<ffffffff8129fdbb>] ? xfs_get_blocks+0x13/0x13
>> [   72.345263]  [<ffffffff8129d890>] xfs_vm_direct_IO+0x89/0x90
>> [   72.346598]  [<ffffffff8129d943>] ? xfs_setfilesize_trans_alloc+0xac/0xac
>> [   72.348185]  [<ffffffff8169ae5e>] xfs_file_dio_aio_write+0x2e0/0x449
>> [   72.349652]  [<ffffffff813e1028>] ? __clear_user+0x36/0x5b
>> [   72.350950]  [<ffffffff812af9c6>] xfs_file_write_iter+0x75/0x105
>> [   72.352369]  [<ffffffff81151524>] __vfs_write+0x97/0xc0
>> [   72.353607]  [<ffffffff81151b1f>] vfs_write+0xb5/0x16f
>> [   72.354832]  [<ffffffff811522c3>] SyS_write+0x4a/0x94
>> [   72.356060]  [<ffffffff816a4b17>] system_call_fastpath+0x12/0x6f
>
> This is the only unwritten conversion path that should occur through
> direct IO - the IO completion path....

There is a bug in the direct io rewrite patches.
I have fixed it here:
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/commit/?h=block-dio-rewrite&id=ceeccaa16

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
