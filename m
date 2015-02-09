Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA3767FAB
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 15:17:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8BEF304032
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 13:17:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8RImZhHksGcJJtpN for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 13:17:47 -0800 (PST)
Date: Tue, 10 Feb 2015 08:17:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
Message-ID: <20150209211744.GT12722@dastard>
References: <54D53E8C.8070207@redhat.com> <20150208213502.GA4251@dastard>
	<20150209130926.GA18336@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150209130926.GA18336@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 09, 2015 at 08:09:26AM -0500, Brian Foster wrote:
> On Mon, Feb 09, 2015 at 08:35:02AM +1100, Dave Chinner wrote:
> > On Fri, Feb 06, 2015 at 04:22:04PM -0600, Eric Sandeen wrote:
> > > These 2 patches provide information about which filesystem
> > > hit the error...
> > 
> > If we are going to touch every one of these macros, then can we
> > rename them to something a little shorter like XFS_CORRUPT_GOTO()
> > and XFS_CORRUPT_RETURN() at the same time? That will make the code a
> > little less eye-bleedy where there are lots of these statements,
> > and make formatting of complex checks a bit easier, too...
> > 
> 
> XFS_CORRUPT_DOSOMETHING() jumps out to me as indicate corruption if the
> logic statement evaluates as true rather than false. The latter (e.g.,
> assert-like logic) is how they work today, so that could be a bit
> confusing to somebody who isn't already familiar with how these macros
> work.

Someone not familiar with XFS conventions is already going to get
caught by "should be true" logic of these statements anyway as the
logic is the opposite of BUG_ON() and WARN_ON(). i.e.  BUG_ON(1)
will kill the kernel, while ASSERT(1) indicates everything is fine.

I suggested shortening the macro because it makes the code that uses
it extensively shouty and hard to read because it splits logic
statements across lines regularly (e.g __xfs_dir3_data_check).  I
want to use this more extensively in verifiers to give better
corruption detection reporting, but the current macro will make the
verifier code rather ugly. Hence my suggestion to make it shorter,
neater and a little less shouty...

> Unfortunately, nothing shorter than the current naming immediately comes
> to mind... :/ We could kill the XFS_ prefix I suppose or even invert the
> logic of the calls, but that's certainly a more significant change.
> Thoughts?

No logic changes, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
