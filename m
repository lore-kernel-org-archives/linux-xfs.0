Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1F6mi4c046813 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 00:48:45 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97161193F4E9
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 22:48:09 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	RYvZjZIurTaMcvyV for <xfs@oss.sgi.com>;
	Sat, 14 Feb 2009 22:48:09 -0800 (PST)
Date: Sun, 15 Feb 2009 17:42:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/17] xfs: merge xfs_inode_flush into xfs_fs_write_inode
Message-ID: <20090215064225.GA8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.588218000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073202.588218000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 26, 2009 at 02:31:47AM -0500, Christoph Hellwig wrote:
> Spliting the task for a VFS-induced inode flush into two functions doesn't
> make any sense, so merge the two functions dealing with it.

I just realised that we should really be calling xfs_inode_flush() from
xfs_sync_inodes_ag() - it open codes xfs_inode_flush() and doesn't
have any of the non-blocking flush code for async flushes...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
