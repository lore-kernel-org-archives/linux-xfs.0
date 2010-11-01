Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1CRSPb208939 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 07:27:28 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3EAF1E8A56B
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 05:28:49 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id Ddj2twnKkwKFm8eQ
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 05:28:49 -0700 (PDT)
Message-ID: <4CCEB27E.1000605@profihost.ag>
Date: Mon, 01 Nov 2010 13:28:46 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag> <4CCE73C8.8070705@profihost.ag>
	<20101101122751.GL2715@dastard>
In-Reply-To: <20101101122751.GL2715@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

no, as Emmanuel told me i don't have todo that.

Stefan

Am 01.11.2010 13:27, schrieb Dave Chinner:
> On Mon, Nov 01, 2010 at 09:01:12AM +0100, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> i've done all you advises - updating 3ware, setting other scheduler,
>> block size, ...
>>
>> but today i got again hundrets of these messages:
>> [318343.901809] Filesystem "sdc3": XFS internal error
>> xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller
>> 0xffffffff8117bdea
>> [318343.901811]
>> [318343.901813] Pid: 20299, comm: rsync Not tainted 2.6.32.22intel #1
>> [318343.901815] Call Trace:
>> [318343.901819]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
>> [318343.901823]  [<ffffffff8117bcb7>] ? xfs_da_do_buf+0x557/0x620
>> [318343.901827]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
>> [318343.901831]  [<ffffffff810538a7>] ? bit_waitqueue+0x10/0xa0
>> [318343.901834]  [<ffffffff8117bdea>] ? xfs_da_read_buf+0x24/0x29
>> [318343.901839]  [<ffffffff8117f43c>] ? xfs_dir2_block_lookup_int+0x45/0x197
>> [318343.901843]  [<ffffffff8117f43c>] ? xfs_dir2_block_lookup_int+0x45/0x197
>> [318343.901846]  [<ffffffff813751d0>] ? tcp_write_xmit+0x466/0x96c
>> [318343.901850]  [<ffffffff8117f9c2>] ? xfs_dir2_block_lookup+0x18/0xb0
>> [318343.901854]  [<ffffffff8117e71c>] ? xfs_dir_lookup+0xd5/0x147
>> [318343.901857]  [<ffffffff811a11bd>] ? xfs_lookup+0x47/0xa3
>> [318343.901861]  [<ffffffff811a90d1>] ? xfs_vn_lookup+0x3c/0x7b
>> [318343.901865]  [<ffffffff810c1de7>] ? __lookup_hash+0xfa/0x11e
>> [318343.901869]  [<ffffffff810c51a8>] ? do_filp_open+0x208/0x934
>> [318343.901873]  [<ffffffff810c7242>] ? poll_select_copy_remaining+0xd0/0xf3
>> [318343.901877]  [<ffffffff810cd62a>] ? alloc_fd+0x67/0x10b
>> [318343.901880]  [<ffffffff810b8a60>] ? do_sys_open+0x55/0x103
>> [318343.901884]  [<ffffffff8100ae6b>] ? system_call_fastpath+0x16/0x1b
>
> Have you run repair to fix all the existing problems after doing all
> the firmware upgrades, etc?
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
