Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K6dPOq038679 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 00:39:25 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CABE22793C9
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:41:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ppw6Mz2b4k24Fdmc for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 22:41:43 -0800 (PST)
Date: Thu, 20 Jan 2011 17:41:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS - issues with writes using sync
Message-ID: <20110120064137.GS16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
	<AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 11:37:44AM +0530, Amit Sahrawat wrote:
> Hi,
> 
> I will try to find out the cause for this.
> Meanwhile, just a small request/suggestion - in the past this type of
> testcases have helped us in finding many problems in XFS.
> Can something like this be added to xfstests? This might help.

Definitely.  We're always looking for more people to add tests that
expose problems to xfstests. :) We try to keep individual test
runtime to as little as possible - under 5 minutes for the auto
group, under 15s for the quick group, but by the looks of it the
test you are running doesn't take that long to run.

FWIW, there are already tests that cause worst case filesystem
fragmentation as part of their test setup (e.g. test 042) but the
coverage of such issues could definitely be improved. Also, the way
we generate fragmented filesystems - by writing files and then
removing a subset - could be greatly sped up by preallocation and
hole punching. There's no need to write data when we could just use
unwritten extents to do the same thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
