Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0E4TAQs003441 for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 22:29:15 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A709817F0A6F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 20:29:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 98eNUHS3E2LYI91i for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2009 20:29:09 -0800 (PST)
Date: Tue, 13 Jan 2009 23:28:58 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090113214949.GN8071@disturbed>
Message-ID: <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> > This misbehavior is apparently caused by delayed allocation, delayed 
> > allocation does not exactly know how much space will be occupied by data, 
> > so it makes some upper bound guess.
> 
> No, we know *exactly* how much space is consumed by the data. What
> we don't know is how much space will be required for additional
> *metadata* to do the allocation so we reserve the worst case need so
> hat we should never get an ENOSPC during async writeback when we
> can't report the error to anyone.  Worst case is 4 metadata blocks
> per allocation (delalloc extent, really).
> 
> If we ENOSPC in the delalloc path, we have two choices:
> 
> 	1. potentially lock the system up due to OOM and being
> 	   unable to flush pages
> 	2. throw away user data without being able to report an
> 	   error to the application that wrote it originally.
> 
> Personally, I don't like either option, so premature ENOSPC at
> write() time is fine by me....
> 
> > Because free space count is only a 
> > guess, not the actual data being consumed, XFS should not return -ENOSPC 
> > on behalf of it. When the free space overflows, XFS should sync itself, 
> > retry allocation and only return -ENOSPC if it fails the second time, 
> > after the sync.
> 
> It does, by graduated response (see xfs_iomap_write_delay() and
> xfs_flush_space()):
> 
> 	1. trigger async flush of the inode and retry
> 	2. retry again
> 	3. start a filesystem wide flush, wait 500ms and try again

The result must not depend on magic timer values. If it does, you end up 
with undebbugable nondeterministic failures.

Why don't you change that 500ms wait to "wait until the flush finishes"? 
That would be correct.

> 	4. really ENOSPC now.
> 
> It could probably be improved but, quite frankly, XFS wasn't designed
> for small filesystems so I don't think this is worth investing any
> major effort in changing/fixing.
> 
> Cheers,
> 
> Dave.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
