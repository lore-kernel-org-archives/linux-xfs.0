Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33F747CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 19:21:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C04E2AC008
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 17:21:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4gKxd3JDxkGxCd47 for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 17:21:24 -0700 (PDT)
Date: Fri, 14 Jun 2013 10:21:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: ensure btree root split sets blkno correctly
Message-ID: <20130614002122.GN29338@dastard>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-4-git-send-email-david@fromorbit.com>
	<20130613191617.GY20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613191617.GY20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 02:16:17PM -0500, Ben Myers wrote:
> On Wed, Jun 12, 2013 at 12:19:08PM +1000, Dave Chinner wrote:
> > Turns out that on a 1k filesystem, generic/234 accounts for one of
> > those two root splits, and that is somewhat of a smoking gun. In
> > fact, it's the same problem we saw in the directory/attr code where
> > headers are memcpy()d from one block to another without updating the
> > self describing metadata.
> 
> It is very interesting that this area of code is exercised so infrequently.

Well known problem - I remember that we did xfstests code coverage
analysis way back in 2005 at SGI, and this was something that popped
out. The stats simple confirmed what the code coverage profiling was
telling us...

That's the reason I run 512 byte/1k block size testing all the time
with xfstests - it covers all of these code paths that 4k block size
doesn't cover.

> I
> remember seeing a paper that described a tool that would list codepaths that
> are exercised during a test run.  Does that ring a bell?  It seems like this
> might be worth looking into more generally.

You mean code coverage profiling?

FWIW, RH QA has run some xfstests code coverage analysis recently,
too, and it has mostly confirmed the same results that we got at SGI
years ago - we get roughly 70% code coverage of the kernel code
froma default 4k filesystem xfstests run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
