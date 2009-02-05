Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n157ibpn202147 for <xfs@oss.sgi.com>; Thu, 5 Feb 2009 01:44:37 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7024EC4D0
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 23:43:57 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	QDT6duwLETYEphrB for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2009 23:43:57 -0800 (PST)
Date: Thu, 5 Feb 2009 18:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090205074353.GN24173@disturbed>
References: <20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
	<20090124071249.GF32390@disturbed>
	<Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
	<20090131235725.GA24173@disturbed>
	<Pine.LNX.4.64.0902021214310.15622@hs20-bc2-1.build.redhat.com>
	<20090203032740.GG24173@disturbed>
	<Pine.LNX.4.64.0902031459350.28433@hs20-bc2-1.build.redhat.com>
	<20090204120852.GK24173@disturbed>
	<Pine.LNX.4.64.0902042310240.27204@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902042310240.27204@hs20-bc2-1.build.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 11:31:25PM -0500, Mikulas Patocka wrote:
> > > ... and if you turn it into trylock, what are you going to do with the 
> > > inode that is just being written to? You should definitely flush it, but 
> > > trylock will skip it because it's already locked.
> > 
> > We've already flushed it directly. You disabled that code fearing
> > deadlocks. I've made it synchronous (i.e. not handed off to
> > xfssyncd) because the flush path requires us to hold the lock we are
> > already holding....
> 
> This is not "fearing deadlocks". This was getting a real deadlock:

<sigh>

Thank you for *finally* telling me exactly what the deadlock is that
you've been handwaving about for the last week. It's not a VFS
deadlock, nor is it an inode lock deadlock - its a page lock deadlock.

Perhaps next time you will post the stack trace instead of vaguely
describing a deadlock so you don't waste several hours of another
developer's time looking for deadlocks in all the wrong places?

> This one was obtained on a machine with 4k filesystem blocks, 8k pages and 
> dd bs=1 on a nearly full filesystem.

That's helpful, too. I can write a test case to exercise that.

So, now I understand why you were suggesting going all the way back up
to the top of the IO path and flushing from there - so we don't hold
a page lock.

Perhaps we should just cull the direct inode flush completely.
If that inode has any significant delayed allocation space on it,
then the only reason it gets to an ENOSPC is that is has converted
all the speculative preallocation that it already has reserved
and is trying to allocate new space. Hence flushing it will not
return any extra space.

Hmmmmm - given that we hold the iolock exclusively, the trylock I
added into xfs_sync_inodes_ag() will fail on the inode we currently
hold page locks on (tries to get iolock shared) so that should avoid
deadlock on the page we currently hold locked.  Can you remove the
direct inode flush and just run with the modified device flush to see
if that triggers the deadlock you've been seeing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
