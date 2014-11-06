Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 756A87F4E
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 07:02:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54A428F8035
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 05:02:22 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0MHqHcf9KgNvoYn6 for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 05:02:19 -0800 (PST)
Date: Fri, 7 Nov 2014 00:02:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 v2] xfs: fix the bulkstat mess
Message-ID: <20141106130216.GE23575@dastard>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
	<20141105060728.GE28565@dastard> <20141105063226.GF28565@dastard>
	<20141105131706.GB26724@bfoster.bfoster>
	<20141105212100.GG28565@dastard> <20141106065359.GD23575@dastard>
	<20141106124907.GA31429@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141106124907.GA31429@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Thu, Nov 06, 2014 at 07:49:08AM -0500, Brian Foster wrote:
> There's a simple test for that condition, as noted in my previous mail
> as well in case you missed it. Again, that probably calls out that we
> could be doing better unit testing of bulkstat in xfstests. At the very
> least we probably need some bulkstat inode count validation against a
> known data set.

That's exactly what I've been running to find this latest problem.
But a 500TB filesystem with 10 million inodes in it is a bit beyond
xfstests. ANd that only showed up the problem in 4 AGs out of 500,
so with smaller filesystems there's a good chance that this would
have also been missed....

> xfsdump testing is obviously important, but if bulkstat
> is broken then we clearly can't expect xfsdump to work (and debugging
> the former via the latter appears to be quite painful).

We have a bulkstat command in xfstests. And it can be used to
comapre the output against a stat of the file. But it can't detect
missing inodes and I don't think we can start at arbitrary inodes,
either. So it needs work to be able to be used in unit tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
