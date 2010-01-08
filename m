Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08ADknQ028683 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 04:13:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11FB21C3B430
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 02:14:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5M0rCwXsxpQAsq8y for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 02:14:39 -0800 (PST)
Date: Fri, 8 Jan 2010 05:14:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Kill async inode writeback V2
Message-ID: <20100108101437.GA19491@infradead.org>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<20100106180800.GA9613@infradead.org>
	<20100106224944.GW13802@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100106224944.GW13802@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 07, 2010 at 09:49:44AM +1100, Dave Chinner wrote:
> On Wed, Jan 06, 2010 at 01:08:00PM -0500, Christoph Hellwig wrote:
> > Btw, after this series XFS_IFLUSH_DELWRI_ELSE_SYNC is also unused,
> > might be worth to throw something like the patch below in to clean
> > up xfs_iflush:
> 
> Yes, makes sense. I'll add the patch to my QA series after updating
> it for the slight changes to the unmount reclaim I ahd in the
> second posting of the patch. Can I get a signoff from you for this?


Signed-off-by: Christoph Hellwig <hch@lst.de>

> 
> > I'm also not sure we do enough of the noblock calls either with or
> > without your series.  There seem to be a lot more non-blocking sync
> > calls than iflush calls.
> 
> I don't quite follow - inode flushes from the bdi threads should be
> the majority of flushes (i.e. from xfs_fs_write_inode()) and they
> are non-blocking. the xfssyncd does delwri writeback (maybe that
> should be non-blocking and then we can get rid of that flag, too),
> so the only sync inode writeback path is from xfs_fs_write_inode()
> for sync flushing, as well as the unmount reclaim path....

Sorry, I mean non-blocking delwri calls above.  xfs_sync_worker should
certainly be non-blocking as the whole daemon is operating that way. And
possibly xfs_sync_attr as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
