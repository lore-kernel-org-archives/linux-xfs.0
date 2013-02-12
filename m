Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47DA47F56
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 04:20:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3993C8F8040
	for <linux-xfs@oss.sgi.com>; Tue, 12 Feb 2013 02:20:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WyS0ACD34Y2NYKCq for <linux-xfs@oss.sgi.com>;
	Tue, 12 Feb 2013 02:20:16 -0800 (PST)
Date: Tue, 12 Feb 2013 21:20:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130212102014.GA26694@dastard>
References: <loom.20130212T071115-446@post.gmane.org>
	<20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
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
To: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Tue, Feb 12, 2013 at 07:01:59AM +0000, Cheung, Norman wrote:
> Sorry Dave.  Let me copy and paste the trace below, hope it works.
> Thanks,
> Norman
> 
> Below is the sysrq for the 2 offending threads.
> 
> 1. the disk writing thread hung in fclose
> 
> 
> Tigris_IMC.exe  D 0000000000000000     0  4197   4100 0x00000000
> ffff881f3db921c0 0000000000000086 0000000000000000 ffff881f42eb8b80
> ffff880861419fd8 ffff880861419fd8 ffff880861419fd8 ffff881f3db921c0
> 0000000000080000 0000000000000000 00000000000401e0 00000000061805c1 Call Trace:
> [<ffffffff810d89ed>] ? zone_statistics+0x9d/0xa0 [<ffffffffa0402682>] ? xfs_iomap_write_delay+0x172/0x2b0 [xfs] [<ffffffff813c7e35>] ? rwsem_down_failed_common+0xc5/0x150
> [<ffffffff811f32a3>] ? call_rwsem_down_write_failed+0x13/0x20
> [<ffffffff813c74ec>] ? down_write+0x1c/0x1d [<ffffffffa03fba8e>] ? xfs_ilock+0x7e/0xa0 [xfs] [<ffffffffa041b64b>] ? __xfs_get_blocks+0x1db/0x3d0 [xfs] [<ffffffff81103340>] ? kmem_cache_alloc+0x100/0x130 [<ffffffff8113fa2e>] ? alloc_page_buffers+0x6e/0xe0 [<ffffffff81141cdf>] ? __block_write_begin+0x1cf/0x4d0 [<ffffffffa041b850>] ? xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffffa041b850>] ? xfs_get_blocks_direct+0x10/0x10 [xfs] [<ffffffff8114226b>] ? block_write_begin+0x4b/0xa0 [<ffffffffa041b8fb>] ? xfs_vm_write_begin+0x3b/0x70 [xfs] [<ffffffff810c0258>] ? generic_file_buffered_write+0xf8/0x250
> [<ffffffffa04207b5>] ? xfs_file_buffered_aio_write+0xc5/0x130 [xfs] [<ffffffffa042099c>] ? xfs_file_aio_write+0x17c/0x2a0 [xfs] [<ffffffff81115b28>] ? do_sync_write+0xb8/0xf0 [<ffffffff8119daa4>] ? security_file_permission+0x24/0xc0
> [<ffffffff8111630a>] ? vfs_write+0xaa/0x190 [<ffffffff81116657>] ? sys_write+0x47/0x90 [<ffffffff813ce412>] ? system_call_fastpath+0x16/0x1b

It's just as mangled. Write them to a file, make sure it is
formatted correctly, and attach it to the email.

> kernel version 3.0.13-0.27

What distribution is that from?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
