Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6860D7F50
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 17:47:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C35BFAC001
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 15:46:59 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	z33UeBCCECsyQRQ8 for <xfs@oss.sgi.com>;
	Wed, 30 Jan 2013 15:46:58 -0800 (PST)
Date: Thu, 31 Jan 2013 10:46:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130130234650.GE32297@disturbed.disaster>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 29, 2013 at 10:16:20PM -0500, Tom wrote:
> With md raid1:
> Unmounting pipe file systems:
> Unmounting file systems:

So the filesystems are unmounted....

> Please stand by while rebooting the system...
> md: stopping all md devices.
> md: md2 switched to read-only mode.
> md: md1 switched to read-only mode.
> (hang)
> 
> Traceback:
> INFO: task reboot:2063 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> reboot        D ffff810037df37e0     0  2063      1                  19
> (NOTLB)
>  ffff81005890ba08 0000000000000082 ffff81005890ba58 ffff81005beb1ea0
>  0000000000000001 0000000000000007 ffff810058d67040 ffff810037df37e0
>  000000596dd8a1e6 0000000000003df4 ffff810058d67228 000000008008d76f
> Call Trace:
>  [<ffffffff8002e4bc>] __wake_up+0x38/0x4f
>  [<ffffffff80223bce>] md_write_start+0xf2/0x108
>  [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8000ab62>] get_page_from_freelist+0x380/0x442
>  [<ffffffff880b102c>] :raid1:make_request+0x38/0x5d8
>  [<ffffffff8001c839>] generic_make_request+0x211/0x228
>  [<ffffffff8002389f>] mempool_alloc+0x31/0xe7
>  [<ffffffff8001a98f>] vsnprintf+0x5d7/0xb54
>  [<ffffffff80033695>] submit_bio+0xe6/0xed
>  [<ffffffff8807f801>] :xfs:_xfs_buf_ioapply+0x1f2/0x254
>  [<ffffffff8807f89c>] :xfs:xfs_buf_iorequest+0x39/0x64
>  [<ffffffff8808386c>] :xfs:xfs_bdstrat_cb+0x36/0x3a
>  [<ffffffff8807c0a8>] :xfs:xfs_bwrite+0x5e/0xba
>  [<ffffffff88077669>] :xfs:xfs_syncsub+0x119/0x226
>  [<ffffffff88084ce2>] :xfs:xfs_fs_sync_super+0x33/0xdd
>  [<ffffffff8010aa44>] quota_sync_sb+0x2e/0xf0
>  [<ffffffff800e55bd>] __fsync_super+0x1b/0x9e
>  [<ffffffff800e578a>] fsync_super+0x9/0x16
>  [<ffffffff800e57c1>] fsync_bdev+0x2a/0x3b
>  [<ffffffff8014ea59>] invalidate_partition+0x28/0x40
>  [<ffffffff802225a8>] do_md_stop+0xa0/0x2ec

And this says the filesystem is still mounted. Why?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
