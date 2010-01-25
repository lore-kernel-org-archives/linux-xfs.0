Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PG2pOm063152 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 10:02:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A79C1894AB
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 08:03:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VtSxhTjiswn1sDeg for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 08:03:55 -0800 (PST)
Date: Mon, 25 Jan 2010 11:03:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: xfs_fs_write_inode() can fail to write inodes
	synchronously
Message-ID: <20100125160354.GA30227@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264400564-19704-8-git-send-email-david@fromorbit.com>
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

On Mon, Jan 25, 2010 at 05:22:44PM +1100, Dave Chinner wrote:
> When an inode has already be flushed delayed write,
> xfs_inode_clean() returns true and hence xfs_fs_write_inode() can
> return on a synchronous inode write without having written the
> inode. Currently these sycnhronous writes only come from the unmount
> path or the nfsd on a synchronous export so should be fairly rare.

They also come from sync_filesystem, which is uses by the sync system
call, in the unmount code and from cachefiles.

> Realistically, a synchronous inode write is not necessary here; we
> can treat this like fsync where we either force the log if there are
> no unlogged changes, or do a sync transaction if there are unlogged
> changes. The will result real synchronous semantics as the fsync
> will issue barriers, but may slow down the above two configurations
> as a result. However, if the inode is not pinned and has no unlogged
> changes, then the fsync code is a no-op and hence it may be faster
> than the existing code.

If we get a lot of cases where we need to write out the inode
synchronously the barrier might hit us really hard, though.  If
we have a lot of delalloc I/O outstanding I fear this might actually
happen in practice as the inode gets modified between the first
->write_inode with wait == 0 by I/O completion.

> +	error = EAGAIN;
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> +		goto out;
> +	if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
> +		goto out_unlock;

So if we make this non-blocking even for the wait case, don't we
still have a race window there bulkstat could miss the updates, even
after a sync?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
