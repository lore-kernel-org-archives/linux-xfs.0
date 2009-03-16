Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GARj2m084340 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:28:08 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BED2B1C45F53
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:27:23 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	qU8EqzSaQ5hrn4Qb for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:27:23 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:27:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] [XFS] Block callers of xfs_flush_inodes() correctly.
Message-ID: <20090316102719.GE26138@disturbed>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-4-git-send-email-david@fromorbit.com>
	<20090316091331.GC2636@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316091331.GC2636@infradead.org>
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
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 05:13:31AM -0400, Christoph Hellwig wrote:
> On Sun, Mar 15, 2009 at 10:31:45PM +1100, Dave Chinner wrote:
> > xfs_flush_inodes() currently uses a magic timeout to wait for
> > some inodes to be flushed before returning. This isn't
> > really reliable but used to be the best that could be done
> > due to deadlock potential of waiting for the entire flush.
> > 
> > Now the inode flush is safe to execute while we hold page
> > and inode locks, we can wait for all the inodes to flush
> > synchronously. Convert the wait mechanism to a completion
> > to do this efficiently. This should remove all remaining
> > spurious ENOSPC errors from the delayed allocation reservation
> > path.
> 
> Why do we queue it up to a different thread if we synchronously wait
> for it anyway?

To avoid competing with flushes that may already be in progress.
This way all the concurrent ENOSPC flushes are serialised by the
xfssyncd so it can do optimal flushing without being interfered
with....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
