Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23FjUuL099886 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 09:45:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 598E6132698B
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 07:48:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id arADmV93cMtQVUPp for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 07:48:21 -0800 (PST)
Date: Thu, 3 Mar 2011 10:48:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: kick inode writeback when low on memory
Message-ID: <20110303154819.GA3945@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-6-git-send-email-david@fromorbit.com>
	<20110302030602.GD4905@dastard>
	<20110302141220.GA4363@infradead.org>
	<20110303024228.GB15097@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303024228.GB15097@dastard>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

On Thu, Mar 03, 2011 at 01:42:28PM +1100, Dave Chinner wrote:
> Yeah, it doesn't seem like there's an easy way around that. I guess
> I'll start by tracking VFS dirty inodes via a tag in the per-ag radix
> tree and kick writeback via a new xfssynd work operation. I'll see
> if that is sufficient to avoid the OOM problem without needing to
> log the inodes in the .dirty_inode callback or changing it's
> prototype.

I don't think we'll be able to get around chaning the dirty_inode
callback.  We need a way to prevent the VFS from marking the inode
dirty, otherwise we have no chance of reclaiming it.

Except for that I think it's really simple:

 1) we need to reintroduce the i_update_size flag or an equivalent to
    distinguish unlogged timestamp from unlogged size updates for fsync
    vs fdatasync.  At that point we can stop looking at the VFS dirty
    bits in fsync.
 2) ->dirty_inode needs to tag the inode as dirty in the inode radix
    tree

With those minimal changes we should be set - we already
callxfs_sync_attr from the sync_fs path, and xfs_sync_inode_attr
properly picks up inodes with unlogged changes.

In fact that whole scheme might even be able to speed up sync - right
now we first log the inode and then flush all pending data in the log
back to disk, and with this scheme we avoid logging the inode in the
first place.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
