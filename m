Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p959aM33104785 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 04:36:22 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02BF91C69965
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 02:36:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	B4E5mRG1CN5muR2C for <xfs@oss.sgi.com>;
	Wed, 05 Oct 2011 02:36:21 -0700 (PDT)
Date: Wed, 5 Oct 2011 20:36:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111005093615.GQ3159@dastard>
References: <4E887D7F.2010306@oracle.com>
	<20111004130208.GA19263@infradead.org>
	<20111005043659.GO3159@dastard> <201110050934.28021@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110050934.28021@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Wed, Oct 05, 2011 at 09:34:26AM +0200, Michael Monnerie wrote:
> On Mittwoch, 5. Oktober 2011 Dave Chinner wrote:
> > That will only work if you can prevent concurrent unwritten extent
> > conversion from happening while we do the separate tag lookups on
> > the range because it requires two radix tree tag lookups rather than
> > just one index lookup. i.e. miss the dirty page because it went
> > dirty->writeback during the dirty tag search, and miss the same page
> > when doing the writeback lookup because it went writeback->clean
> > very quickly due to IO completion.
> > 
> > So to stop that from happening, it requires that filesystems can
> > exclude unwritten extent conversion from happening while a
> > SEEK_HOLE/SEEK_DATA operation is in progress, and that the
> > filesystem can safely do mapping tree lookups while providing that
> > extent tree exclusion.  I know that XFS has no problems here, but
> > filesystems that use i_mutex for everything might be in trouble.
> > 
> > Besides, if we just look for pages in the cache over unwritten
> > extents (i.e. someone has treated it as data already), then it can
> > be done locklessly without having to worry about page state changes
> > occurring concurrently...
> 
> I'd like to understand why it's important to care about locking here. As 
> I understand it, SEEK_* is used for example to copy a file efficiently. 
> If that is performed on a file that is currently being written to, the 
> resulting copy will probably be bogus anyway, even without SEEK_* usage.

The problem is that copying a file with dirty data hot in the cache
concurrently when writeback to that file is occurring. The
application is not modifying the file, and the state changes that
could lead SEEK_DATA missing data are driven entirely by background
kernel threads. The application leaves a file in this state:

                     dirty page
              +------D--------+
               unwritten extent

SEEK_DATA must stop at that dirty page over the unwritten extent.
If we do a dirty page lookup, but the flusher thread has started IO
on it, it will have transitioned to this state:

                     writeback page
              +------W--------+
               unwritten extent

And the dirty page lookup will not find it. If we allow unwritten
extent conversion to also run while we are doing the writeback page
cache lookup, then IO completion and conversion can occur before we
find the writeback page in the cache. i.e we see this state:

                     clean page
              +------C--------+
               unwritten extent

And we don't find the data page over the unwritten extent at all
because we haven't looked up clean pages in the cache.

At that point, our SEEK_DATA call has skipped over a valid data
page, the copy utility fails to copy the data over the unwritten
extent, thereby silently creating a corrupt copy....

> There might be a case where it is important, but I can't see that atm. 

It's a data corruption problem, pure and simple....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
