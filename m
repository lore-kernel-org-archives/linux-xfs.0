Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82D187F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:50:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2520BAC004
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 15:50:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6yyS3yiM6r2ONhsB for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 15:50:50 -0700 (PDT)
Date: Fri, 22 Aug 2014 08:50:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: use abort() not ASSERT(0) for impossible
	switch case
Message-ID: <20140821225048.GQ26465@dastard>
References: <53F62D12.8010505@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F62D12.8010505@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 12:32:02PM -0500, Eric Sandeen wrote:
> The original reason for the expletive below has been lost
> in the mists of time

Oh, no it hasn't.

That's a switch statement using enums for the cases and so if you
don't define every enum value in the switch statement gcc throws
warnings. IOWs, the switch statement has to either define them all or
contain a "default" case, either of which *does not need to exist* because
other code guarantees that the value of cur->bc_btnum is within
the valid range.

So, we have to put an invalid value into the switch statement to
make gcc shut the fuck up, and the ASSERT(0) is there to indicate
that "this should never, ever happen".

> libxfs, and this leads static analysis checkers to believe that
> XFS_BTNUM_MAX is possible, and that we might overflow an array
> later when using it as an index.
> 
> We can shut this up and mark it as truly impossible with abort().

Random differences between kernel and user code to keep static
analysis checkers happy is not a good road to follow, because it
will just cause patch failures and people wondering "why is this
randomly different to the kernel code?". So, no, I don't really like
this approach.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
