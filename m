Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP3kqIm204154 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 21:46:52 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2EF21A030E
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 19:48:29 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rCpwSgPvt9BRBUTa for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 19:48:29 -0800 (PST)
Date: Thu, 25 Nov 2010 14:48:24 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: XFS reclaim lock order bug
Message-ID: <20101125034824.GA3359@amd>
References: <20101123121802.GA4785@amd> <20101123211258.GY22876@dastard>
	<20101124200341.GA2493@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124200341.GA2493@infradead.org>
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
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>, xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 03:03:41PM -0500, Christoph Hellwig wrote:
> On Wed, Nov 24, 2010 at 08:12:58AM +1100, Dave Chinner wrote:
> > It is supposed to be handled by the re-initialisation of the
> > ip->i_iolock in ->evict_inode (xfs_fs_evict_inode). An inode found
> > in the reclaim state must have passed through this reinitialisation,
> > so from a lockdep perspective the iolock in the vfs path is a
> > different context to the iolock in the reclaim path. That fixed all
> > the non-reclaim state related lockdep false positives, so Perhaps
> > there is an issue with the lockdep reclaim state checking that does
> > not interact well with re-initialised lock contexts?
> 
> I've been looking through this again, and I think it's indeed not
> enough.  We don't just need to re-initialize it, but also set a
> different lockclass for it.

Doesn't init_rwsem give it a new class?

Guys, can you take a quick look at the code Dave is referring to
(xfs_fs_evict_inode), and check that it actually does what he
intends?

We're getting what seems to be false positives in reclaim inversion
of lockings. Backtraces here
http://oss.sgi.com/pipermail/xfs/2010-November/048092.html

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
