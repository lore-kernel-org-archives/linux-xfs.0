Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F0DdIh155617 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:13:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6839DDE7F6
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:26:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ixjxWPJH9c3CDNKE for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 17:26:14 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:14:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100915001423.GJ15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-8-git-send-email-david@fromorbit.com>
	<20100914145447.GE3400@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100914145447.GE3400@infradead.org>
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

On Tue, Sep 14, 2010 at 10:54:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 14, 2010 at 08:56:06PM +1000, Dave Chinner wrote:
> > Hence we can stop marking VFS inodes dirty during transaction commit or when
> > changing timestamps during transactions. This will keep the inodes in the
> > superblock dirty list to those containing data or unlogged metadata changes.
> 
> But we also use xfs_ichgtime for non-transacion size updates, e.g.
> for truncate of zero length files.  With this patch we lose track of
> the timestamp updates for this case.

Oh, I missed that one in the twisty passages of the setattr code.
I'll do another (more careful) pass across all the callers, and for
those that are outside a transaction I'll add a separate call to
xfs_mark_inode_dirty_sync() for them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
