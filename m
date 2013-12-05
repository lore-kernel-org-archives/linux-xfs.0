Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED21F7F84
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:40:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C71678F8049
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:40:35 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Cm9Xi9Tlo1MFEUBs for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:40:34 -0800 (PST)
Date: Fri, 6 Dec 2013 08:40:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: assert that we hold the ilock for extent map
	access
Message-ID: <20131205214029.GI29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.874279041@bombadil.infradead.org>
	<20131205211047.GG29897@dastard>
	<20131205212219.GA12602@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205212219.GA12602@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 05, 2013 at 01:22:19PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2013 at 08:10:47AM +1100, Dave Chinner wrote:
> > Looks good, but can we add an assert to xfs_bunmapi() at the same
> > time just to cover all the public bmapi interfaces with locking
> > requirements?
> 
> Sure, will do.
> 
> Btw, I got another idea to sort this mess out a bit better:
> 
>  - add a new XFS_ILOCK_BMAP flag, and fold the bmap locking magic
>    into xfs_ilock.
>  - because the flag is now passed down we can assert that it is
>    passed in xfs_bmapi_read and friends even if the extent list
>    is already read in and thus improve coverage.

Hmmm - I'm not sure I can see how that would work - the checks on
lock mode look at the lock directly, not at some other flag register
to indicate the locking context....

Are you thinking of expanding the code in xfs_isilocked() to handle
this as well? 

And what do we do with the unlock case, as we can't tell after the
fact from the inode state whether we locked shared or excl because
the extent list has now been read in....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
