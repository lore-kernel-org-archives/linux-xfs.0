Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23GGepC102796 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 10:16:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5437A30F7D5
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 08:19:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 96AhJID1AgmjtgCp for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 08:19:31 -0800 (PST)
Date: Thu, 3 Mar 2011 11:19:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: kick inode writeback when low on memory
Message-ID: <20110303161929.GA5795@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-6-git-send-email-david@fromorbit.com>
	<20110302030602.GD4905@dastard>
	<20110302141220.GA4363@infradead.org>
	<20110303024228.GB15097@dastard>
	<20110303154819.GA3945@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110303154819.GA3945@infradead.org>
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

On Thu, Mar 03, 2011 at 10:48:19AM -0500, Christoph Hellwig wrote:
> I don't think we'll be able to get around chaning the dirty_inode
> callback.  We need a way to prevent the VFS from marking the inode
> dirty, otherwise we have no chance of reclaiming it.
> 
> Except for that I think it's really simple:
> 
>  1) we need to reintroduce the i_update_size flag or an equivalent to
>     distinguish unlogged timestamp from unlogged size updates for fsync
>     vs fdatasync.  At that point we can stop looking at the VFS dirty
>     bits in fsync.
>  2) ->dirty_inode needs to tag the inode as dirty in the inode radix
>     tree
> 
> With those minimal changes we should be set - we already
> callxfs_sync_attr from the sync_fs path, and xfs_sync_inode_attr
> properly picks up inodes with unlogged changes.

Actually xfs_sync_attr does not get called from the sync path right now,
which is a bit odd.  But once we add it, possibly with an earlier
trylock pass and/or an inode cluster read-ahead the above plan still
stands.

What's also rather odd is how much we use xfs_sync_data - unlike the
inodes where our own code doing writeback based on disk order makes
a lot of sense data is actually handled very well by the core writeback
code.  The two remaining callers of xfs_sync_data are
xfs_flush_inodes_work and xfs_quiesce_data.  The former area really
belongs into this patchset - can you try what only calling
writeback_inodes* from the ENOSPC handler instead of doing our own stuff
does?  It should give you the avoidance of double writeout for free, and
get rid of one of xfs_sync_data callers.

After that we just need to look into xfs_quiesce_data.  The core
writeback code now does reliably writeback before calling into
->sync_fs, so the actual writeback should be superflous.  We will still
need a log force after it, and we might need an iteration through all
inodes to do an xfs_ioend_wait, but this are can be simplified a lot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
