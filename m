Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 695427F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 23:49:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5757B8F8039
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 21:49:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AvyEuvbr28Xi8i1B for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 21:49:40 -0700 (PDT)
Date: Thu, 21 Aug 2014 14:49:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: deduplicate xlog_do_recovery_pass()
Message-ID: <20140821044915.GX20518@dastard>
References: <53F5651C.8030206@redhat.com>
 <53F57758.9070007@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F57758.9070007@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 20, 2014 at 11:36:40PM -0500, Eric Sandeen wrote:
> On 8/20/14, 10:18 PM, Eric Sandeen wrote:
> > In xlog_do_recovery_pass(), there are 2 distinct cases:
> > non-wrapped and wrapped log recovery.
> > 
> > If we find a wrapped log, we recover around the end
> > of the log, and then handle the rest of recovery
> > exactly as in the non-wrapped case - using exactly the same
> > (duplicated) code.
> > 
> > Rather than having the same code in both cases, we can
> > get the wrapped portion out of the way first if needed,
> > and then recover the non-wrapped portion of the log.
> > 
> > There should be no functional change here, just code
> > reorganization & deduplication.
> > 
> > The patch looks a bit bigger than it really is; the last
> > hunk is whitespace changes (un-indenting).
> > 
> > Tested with xfstests "check -g log" on a stock configuration.
> 
> which didn't actually hit any log wraps.  Does xfstests
> really not cover wrapped log recovery?  anyway, something like this
> on a small log:

xfs/016

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
