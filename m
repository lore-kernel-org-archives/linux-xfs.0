Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57AWwM6017622 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 05:32:59 -0500
Date: Tue, 7 Jun 2011 06:32:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bug in xfs: can't recovery metadata log
Message-ID: <20110607103252.GA15140@infradead.org>
References: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinX_BO94CdQsdmj=atFc-typqr0xg@mail.gmail.com>
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
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Jun 07, 2011 at 01:20:23PM +0800, Drunkard Zhang wrote:
> The log recovery failure happened after a hard reboot, I did "mount
> /dev/lg/log /mnt/temp/" twice, but the similar dmesg error.
> 
> The xfs lives on LVM, with 4x2TB SATA II disk.
> 
> The first time:
> [ 1479.130446] XFS mounting filesystem dm-0
> [ 1479.226525] Starting XFS recovery on filesystem: dm-0 (logdev: internal)
> [ 1506.217842] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8

[...]

> [ 1506.220989] RIP: 0010:[<ffffffff81235f9c>]  [<ffffffff81235f9c>]
> xfs_cmn_err+0x6b/0x92


[...]

> [ 1506.226301]  [<ffffffff8122922b>] ? kmem_zone_zalloc+0x1f/0x30
> [ 1506.226549]  [<ffffffff812098b5>] xfs_error_report+0x39/0x40
> [ 1506.226805]  [<ffffffff811e8340>] ? xfs_free_extent+0x8e/0xae
> [ 1506.227056]  [<ffffffff811e75cf>] xfs_free_ag_extent+0x3e7/0x70b
> [ 1506.227306]  [<ffffffff811e8340>] xfs_free_extent+0x8e/0xae

It looks like you hit one of the XFS_WANT_CORRUPTED_GOTO checks in
xfs_error_report, and we hit something in there that isn't initialized
that early during the mount process.  My guess it's actually the
mp->m_fsname dereference in xfs_fs_vcmn_err.  It's fixed by the message
rework in 2.6.39+, but that will only prevent the crash, you'll still
get an error and the log recovery will be aborted.  If you can get a
more recent kernel on the box I'd be curious what the output form it is.

Did you run older kernels on this machine before?  Before 2.6.33 device
mapper support for barriers (aka cache flushes) was incomplete and
frequently led to free space corruption if people left the volatile
write caches on.  For MD underneath it event took a bit longer.

If you just want to continue using the filesystem you can nuke the
log using xfs_repair -L.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
