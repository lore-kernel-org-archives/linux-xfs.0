Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22E9ZUH023516 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 08:09:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A338157B7F6
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 06:12:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8o5Q2tiaIb1HkvCq for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2011 06:12:25 -0800 (PST)
Date: Wed, 2 Mar 2011 09:12:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: kick inode writeback when low on memory
Message-ID: <20110302141220.GA4363@infradead.org>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-6-git-send-email-david@fromorbit.com>
	<20110302030602.GD4905@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110302030602.GD4905@dastard>
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

On Wed, Mar 02, 2011 at 02:06:02PM +1100, Dave Chinner wrote:
> I'm open to ideas here - I could convert the bdi flusher
> infrastructure to cmwqs rather than using worker threads, or move
> all dirty inode tracking and writeback into XFS, or ???

Tejun posted patches to convert the writeback threads to workqueues.
But I think sooner or later we should stop using VFS dirty state for
metadata.  By allowing the dirty_inode operation to return a value
and say it shouldn't be marked dirty that could be done relatively
easily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
