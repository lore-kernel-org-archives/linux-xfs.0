Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HMu1NZ005842 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 16:56:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7A141CDB618
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:57:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	0o78sDY7tDYgrUoq for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 14:57:19 -0800 (PST)
Date: Thu, 18 Feb 2010 09:57:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: cleanup xfs_iunpin_wait/xfs_iunpin_nowait
Message-ID: <20100217225716.GV28392@discord.disaster>
References: <20100217194356.GA28758@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217194356.GA28758@infradead.org>
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

On Wed, Feb 17, 2010 at 02:43:56PM -0500, Christoph Hellwig wrote:
> Remove the inode item pointer and ili_last_lsn checks in __xfs_iunpin_wait
> as any pinned inode is guaranteed to have them valid.  After this the
> xfs_iunpin_nowait case is nothing more than a xfs_log_force_lsn, as we
> know that the caller has already checked the pincount.
> 
> Make xfs_iunpin_nowait the new low-level routine just doing the log force
> and rewrite xfs_iunpin_wait around it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
