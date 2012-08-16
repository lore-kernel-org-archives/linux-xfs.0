Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GGgNfi166912 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 11:42:23 -0500
Date: Thu, 16 Aug 2012 11:42:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix uninitialised variable in xfs_rtbuf_get()
Message-ID: <20120816164218.GY29979@sgi.com>
References: <1343710551-24998-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343710551-24998-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Tue, Jul 31, 2012 at 02:55:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Results in this assert failure in generic/090:
> 
> XFS: Assertion failed: *nmap >= 1, file: fs/xfs/xfs_bmap.c, line: 4363
> .....
> Call Trace:
>  [<ffffffff814680db>] xfs_bmapi_read+0x6b/0x370
>  [<ffffffff814b64b2>] xfs_rtbuf_get+0x42/0x130
>  [<ffffffff814b6f09>] xfs_rtget_summary+0x89/0x120
>  [<ffffffff814b7bfe>] xfs_rtallocate_extent_size+0xce/0x340
>  [<ffffffff814b89f0>] xfs_rtallocate_extent+0x240/0x290
>  [<ffffffff81462c1a>] xfs_bmap_rtalloc+0x1ba/0x340
>  [<ffffffff81463a65>] xfs_bmap_alloc+0x35/0x40
>  [<ffffffff8146f111>] xfs_bmapi_allocate+0xf1/0x350
>  [<ffffffff8146f9de>] xfs_bmapi_write+0x66e/0xa60
>  [<ffffffff8144538a>] xfs_iomap_write_direct+0x22a/0x3f0
>  [<ffffffff8143707b>] __xfs_get_blocks+0x38b/0x5d0
>  [<ffffffff814372d4>] xfs_get_blocks_direct+0x14/0x20
>  [<ffffffff811b0081>] do_blockdev_direct_IO+0xf71/0x1eb0
>  [<ffffffff811b1015>] __blockdev_direct_IO+0x55/0x60
>  [<ffffffff814355ca>] xfs_vm_direct_IO+0x11a/0x1e0
>  [<ffffffff8112d617>] generic_file_direct_write+0xd7/0x1b0
>  [<ffffffff8143e16c>] xfs_file_dio_aio_write+0x13c/0x320
>  [<ffffffff8143e6f2>] xfs_file_aio_write+0x1c2/0x1d0
>  [<ffffffff81174a07>] do_sync_write+0xa7/0xe0
>  [<ffffffff81175288>] vfs_write+0xa8/0x160
>  [<ffffffff81175702>] sys_pwrite64+0x92/0xb0
>  [<ffffffff81b68f69>] system_call_fastpath+0x16/0x1b
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
