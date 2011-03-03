Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p232dsH1059485 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 20:39:54 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB3001AEB568
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 18:42:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pasTzLeRxISH7AC2 for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 18:42:41 -0800 (PST)
Date: Thu, 3 Mar 2011 13:42:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: kick inode writeback when low on memory
Message-ID: <20110303024228.GB15097@dastard>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
	<1298412969-14389-6-git-send-email-david@fromorbit.com>
	<20110302030602.GD4905@dastard>
	<20110302141220.GA4363@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110302141220.GA4363@infradead.org>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

On Wed, Mar 02, 2011 at 09:12:20AM -0500, Christoph Hellwig wrote:
> On Wed, Mar 02, 2011 at 02:06:02PM +1100, Dave Chinner wrote:
> > I'm open to ideas here - I could convert the bdi flusher
> > infrastructure to cmwqs rather than using worker threads, or move
> > all dirty inode tracking and writeback into XFS, or ???
> 
> Tejun posted patches to convert the writeback threads to workqueues.
> But I think sooner or later we should stop using VFS dirty state for
> metadata.  By allowing the dirty_inode operation to return a value
> and say it shouldn't be marked dirty that could be done relatively
> easily.

Yeah, it doesn't seem like there's an easy way around that. I guess
I'll start by tracking VFS dirty inodes via a tag in the per-ag radix
tree and kick writeback via a new xfssynd work operation. I'll see
if that is sufficient to avoid the OOM problem without needing to
log the inodes in the .dirty_inode callback or changing it's
prototype.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
