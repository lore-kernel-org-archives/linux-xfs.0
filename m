Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02DcI5A114596 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 07:38:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B57715034C7
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 05:39:06 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	D41UDEJmgIymPGGg for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 05:39:06 -0800 (PST)
Date: Sun, 3 Jan 2010 00:39:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Don't flush stale inodes
Message-ID: <20100102133902.GJ13802@discord.disaster>
References: <1262399980-19277-1-git-send-email-david@fromorbit.com>
	<20100102120053.GB18502@infradead.org>
	<20100102122405.GI13802@discord.disaster>
	<20100102131701.GA17320@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102131701.GA17320@infradead.org>
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

On Sat, Jan 02, 2010 at 08:17:01AM -0500, Christoph Hellwig wrote:
> This looks like a bigger problem to me.  We only mark inodes as stale
> from xfs_ifree_cluster, which via xfs_ifree and xfs_inactive gets
> called from xfs_fs_clear_inode.  Given that the inode has now been
> deleted we should not mark it as reclaimable in xfs_fs_destroy_inode
> but go on to reap it given that there is nothing to reclaim.

We can't reap it immediately as the inodes are usually dirty and
pinned in memory at this point by transactions that have not yet
been written to disk and completed. We need the inodes in core for
log IO completion processing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
