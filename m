Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C1AD7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 22:24:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F16EA8F8033
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 20:24:05 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	L2HbeEDeEjBVdlAG for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 20:24:02 -0800 (PST)
Date: Tue, 5 Jan 2016 15:23:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [resend PATCH 3/3] writeback: fix false positive WARN in
	__mark_inode_dirty
Message-ID: <20160105042346.GL19802@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182016.24118.33718.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104182016.24118.33718.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org

On Mon, Jan 04, 2016 at 10:20:16AM -0800, Dan Williams wrote:
> This warning was added as a debugging aid way back in commit
> 500b067c5e6c "writeback: check for registered bdi in flusher add and
> inode dirty" when we were switching over to per-bdi writeback.
> 
> Once the block device has been torn down it's no longer useful to
> complain about unregistered bdi's.  Clear the writeback capability under
> the the wb->list_lock(), so that __mark_inode_dirty has no opportunity
> to race bdi_unregister() to this WARN() condition.
> 
> Alternatively we could just delete the warning...

The warning is correct - the filesytem is trying to mark an inode
dirty on a device that can't do writeback anymore. Seems to me like
it is functioning as it should.

> Found this while testing block device remove from underneath an active
> fs triggering traces like:
> 
>  WARNING: CPU: 6 PID: 2129 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
>  bdi-block not registered
>  [..]
>  Call Trace:
>   [<ffffffff81459f02>] dump_stack+0x44/0x62
>   [<ffffffff810a1f32>] warn_slowpath_common+0x82/0xc0
>   [<ffffffff810a1fcc>] warn_slowpath_fmt+0x5c/0x80
>   [<ffffffff812830b1>] __mark_inode_dirty+0x261/0x350
>   [<ffffffff8126d019>] generic_update_time+0x79/0xd0
>   [<ffffffff8126d19d>] file_update_time+0xbd/0x110
>   [<ffffffff812e4ab8>] ext4_dax_fault+0x68/0x110
>   [<ffffffff811f7f3e>] __do_fault+0x4e/0xf0

This seems like the problem to me - you haven't implemented a
shutdown hook for ext4, and so it continues to allow page faults to
make progress after the device has been removed. The DAX fault
should have been failed before the filesystem gets to the point of
marking the inode dirty....

> +	/* tell __mark_inode_dirty that writeback is no longer possible */
> +	spin_lock(&wb->list_lock);
> +	wb->bdi->capabilities |= BDI_CAP_NO_WRITEBACK;
> +	spin_unlock(&wb->list_lock);
> +
>  	spin_unlock_bh(&wb->work_lock);

Is that lock ordering safe? i.e. it's inside a section using bh-safe
locking, which tends to imply that it can run from interrupt
contexts. Can we get something like

	spin_lock(&wb->list_lock);
	.....
	<irq>
	.....
	wb_shutdown
	spin_lock_bh(&wb->work_lock);
	spin_lock(&wb->list_lock);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
