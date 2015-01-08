Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 534E17F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:45:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 238A08F8049
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 13:45:17 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qYx47r1ykojrys8w for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 13:45:11 -0800 (PST)
Date: Fri, 9 Jan 2015 08:45:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/6] xfs: truncate vs page fault IO exclusion
Message-ID: <20150108214509.GH25000@dastard>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
	<20150108122448.GA18034@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108122448.GA18034@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 04:24:48AM -0800, Christoph Hellwig wrote:
> > This patchset passes xfstests and various benchmarks and stress
> > workloads, so the real question is now:
> > 
> > 	What have I missed?
> > 
> > Comments, thoughts, flames?
> 
> Why is this done in XFS and not in generic code?

We might be able to do that. Indeed, if the concept is considered
sound, then this was the next question I was going to ask everyone.
I just don't know enough about other filesystem locking to be able
to say "this will always work", hence the wide distribution of the
RFC.  Different filesystems have different locking heirarchies, and
so there may be some are not able to use this technique
(cluster/network fs?)....

In the end, however, the main reason I decided on doing it in XFS
first was things like that swap extent operation that requires us to
lock multiple locks on two inodes in a specific order. We already
have all the infrastructure in XFS to enforce and *validate at
runtime* the specific lock ordering required, so it just made it a
no-brainer to do it this way first.

We also have several entry points in XFS that don't go through the
VFS that needed this page fault serialisation and they currently
only use XFS internal locks to serialise against IO.  Again, doing
it in XFS first is the easy-to-validate solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
