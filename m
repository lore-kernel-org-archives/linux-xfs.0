Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I4c4II204426 for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 23:38:24 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 246581C4E93C
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 21:37:20 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	PCP0l36zhY2hP43E for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2009 21:37:20 -0700 (PDT)
Date: Wed, 18 Mar 2009 15:17:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] [XFS] Use xfs_sync_inodes() for device flushing
Message-ID: <20090318041752.GN26138@disturbed>
References: <1237114679-18808-1-git-send-email-david@fromorbit.com>
	<1237114679-18808-2-git-send-email-david@fromorbit.com>
	<Pine.LNX.4.64.0903170857050.26754@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903170857050.26754@hs20-bc2-1.build.redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 17, 2009 at 09:08:36AM -0400, Mikulas Patocka wrote:
> On Sun, 15 Mar 2009, Dave Chinner wrote:
> 
> > From: Dave Chinner <dgc@evostor.com>
> > 
> > Currently xfs_device_flush calls sync_blockdev() which is
> > a no-op for XFS as all it's metadata is held in a different
> > address to the one sync_blockdev() works on.
> > 
> > Call xfs_sync_inodes() instead to flush all the delayed
> > allocation blocks out. To do this as efficiently as possible,
> > do it via two passes - one to do an async flush of all the
> > dirty blocks and a second to wait for all the IO to complete.
> > This requires some modification to the xfs-sync_inodes_ag()
> > flush code to do efficiently.

.....

> I tested the code and it works fine.
> 
> But I'm not somehow convinced that that TRYLOCK is right ... that it will 
> avoid that pagelock-deadlock that I found before.

Care to expand on why?

> What is the ordering of pagelock, ILOCK and IOLOCK?

iolock, pagelock, and ilock is always the innermost of the three.

> If you keep the 
> ordering right, you don't need trylock.

In this case, we are doing:

	iolock exclusive
	pagelock
	<flush>

Clearly we can't take the iolock during <flush> (nor any other
several other places in XFS that might try to take the iolock), so
trylock-and-fail is the usual method used in XFS for avoiding a
deadlock in this scenario.

> And if the ordering is wrong, 
> trylock will only lower the probability of a deadlock, not avoid it 
> completely.

Details of why you think this? XFS uses trylocks extensively to
avoid deadlocks in these sorts of situations, so I'm curious to
know why you think this technique provide an absolute guarantee in
this case....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
