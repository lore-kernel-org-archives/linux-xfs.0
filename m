Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769B5C11D00
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 23:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5175E207FD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 23:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgBTXlA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:41:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60301 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729335AbgBTXlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 18:41:00 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CC0363A45E4;
        Fri, 21 Feb 2020 10:40:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4vR9-0004V3-9U; Fri, 21 Feb 2020 10:40:55 +1100
Date:   Fri, 21 Feb 2020 10:40:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] libxfs: enable tools to check that metadata updates
 have been committed
Message-ID: <20200220234055.GQ10776@dread.disaster.area>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216292664.601264.186457838279269618.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216292664.601264.186457838279269618.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=b3GJ-uZIL4zsjtRpJ9MA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:42:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new function that will ensure that everything we changed has
> landed on stable media, and report the results.  Subsequent commits will
> teach the individual programs to report when things go wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfs_mount.h |    3 +++
>  libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_io.h  |    2 ++
>  libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
>  4 files changed, 73 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 29b3cc1b..c80aaf69 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
>  extern void	libxfs_umount (xfs_mount_t *);
>  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
>  
> +void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
> +		int *rtdev);
> +
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a0d4b7f4..d1d3f4df 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
>  	}
>  	btp->bt_mount = mp;
>  	btp->dev = dev;
> +	btp->lost_writes = false;
> +
>  	return btp;
>  }
>  
> @@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
>  	mp->m_rsumip = mp->m_rbmip = NULL;
>  }
>  
> +static inline int
> +libxfs_flush_buftarg(
> +	struct xfs_buftarg	*btp)
> +{
> +	if (btp->lost_writes)
> +		return -ENOTRECOVERABLE;
> +
> +	return libxfs_blkdev_issue_flush(btp);
> +}
> +
> +/*
> + * Purge the buffer cache to write all dirty buffers to disk and free all
> + * incore buffers.  Buffers that cannot be written will cause the lost_writes
> + * flag to be set in the buftarg.  If there were no lost writes, flush the
> + * device to make sure the writes made it to stable storage.
> + *
> + * For each device, the return code will be set to -ENOTRECOVERABLE if we
> + * couldn't write something to disk; or the results of the block device flush
> + * operation.
> + */
> +void
> +libxfs_flush_devices(
> +	struct xfs_mount	*mp,
> +	int			*datadev,
> +	int			*logdev,
> +	int			*rtdev)
> +{
> +	*datadev = *logdev = *rtdev = 0;
> +
> +	libxfs_bcache_purge();
> +
> +	if (mp->m_ddev_targp)
> +		*datadev = libxfs_flush_buftarg(mp->m_ddev_targp);
> +
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> +		*logdev = libxfs_flush_buftarg(mp->m_logdev_targp);
> +
> +	if (mp->m_rtdev_targp)
> +		*rtdev = libxfs_flush_buftarg(mp->m_rtdev_targp);
> +}

So one of the things I'm trying to do is make this use similar code
to the kernel. basically this close process is equivalent of
xfs_wait_buftarg() which waits for all references to buffers to
got away, and if any buffer it tagged with WRITE_FAIL then it issues
and alert before it frees the buffer.

IOWs, any sort of delayed/async write failure that hasn't been
otherwise caught by the async/delwri code is caught by the device
close code....

Doing things like this (storing a "lost writes" flag on the buftarg)
I think is just going to make it harder to switch to kernel
equivalent code because it just introduces even more of an impedance
mismatch between userspace and kernel code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
