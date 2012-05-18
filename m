Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IAScku126049 for <xfs@oss.sgi.com>; Fri, 18 May 2012 05:28:38 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Nr8pgt6Y0HCLbFDf for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 03:28:37 -0700 (PDT)
Date: Fri, 18 May 2012 20:28:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Are two transactions running in parallel OK?
Message-ID: <20120518102829.GY25351@dastard>
References: <20120517200831.GB23231@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120517200831.GB23231@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: sandeen@redhat.com, dchinner@redhat.com, xfs@oss.sgi.com

On Thu, May 17, 2012 at 10:08:31PM +0200, Jan Kara wrote:
>   Hello,
> 
>   I've been into a source of lockdep warning I got with XFS when testing my
> filesystem freezing patches. The culprit seems to be that when doing direct
> IO, XFS starts a transaction in xfs_setfilesize_trans_alloc() and attaches
> that transaction to endio structure. Then it goes on and starts another
> transaction in xfs_iomap_write_direct() which creates a possible deadlock
> with filesystem freezing (if the second transaction start happens after we
> start blocking new transactions, it gets blocked, but the first transaction
> isn't ever completed).

Both occur within the context of an active write IO - why would
new transactions be blocked while there are still active write
operations that require allocation transactions occurring?

> So first I wanted to ask whether my analysis is correct. If yes, I was also
> wondering whether this cannot cause a deadlock (at least in theory) if the
> second transaction would block waiting for log space but we couldn't
> possibly free enough of it due to the first transaction being held open?

Don't think so. The first transaction reservation is for the inode
size update, but it doesn't hold anything locked so it will not hold
up log tail pushing so the second transaction reservation will not
get blocked by it. The onyl way that could happen is if the
combination of the two transactions is greater than 25% of the log,
and given that the size update transaction reservation is only about
600 bytes, that can't occur....

> If freezing deadlock is the only problem with this code, then I guess we
> could avoid waiting for filesystem freezing when starting the second
> transaction (although it might end up being rather ugly). Or if anyone else
> has other idea how to solve this, I'm listening ;).

I'm confused about why the active sb_start_write() of the direct IO
wouldn't hold off the freeze until the IO has completed. That should
completely protect the write against freeze until the IO completes,
which AFAICT means the lockdep report is a false positive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
