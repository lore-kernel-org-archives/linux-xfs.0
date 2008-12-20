Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBK5G23A013756 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 23:16:03 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2BBE1607555
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 21:16:00 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	3UtMU8GuM1EwHsSG for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2008 21:16:00 -0800 (PST)
Date: Sat, 20 Dec 2008 16:10:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests tests not in the auto group; do we know why?
Message-ID: <20081220051015.GE17177@disturbed>
References: <49473616.1020307@sandeen.net>
	<20081219214411.GA18003@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081219214411.GA18003@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 19, 2008 at 04:44:12PM -0500, Christoph Hellwig wrote:
> > 104 hangs ...
> 
> Yeah, we should fix this eventually :) 

Changing the locking in growfs to loop doing trylocks
will prevent the deadlock. Might take a long time to get the
lock though....


> > # auto - tests to be run as part of nightly qa
> > 
> > I'm not sure what that means; is this group always supposed to pass?  If
> > so there are filestreams tests that don't, for example.  Maybe "tests
> > that don't hang?"
> > 
> > I wonder if it'd be worth documenting this a bit, and have a group which
> > should always run & pass on the core architectures.  (and for those that
> > don't pass, do a bit of documentation on why they don't?)
> 
> I think that would be auto.  I'm all for a slight reshuffling of the
> groups:
> 
> 	auto - stuff that should succeed everywhere
> 	large - stuff that needs a large enough machine / fs to succeed
> 		(for whatever defintion of large)
> 	xfail - expected to fail
> 	xhang - expected to hang
> 		(should be empty normally, only for new testcases)

I'd say we should add another:

	fast - tests that complete in only a few seconds

so that we can run a quicker set of sanity checks while developing
stuff. The current auto run takes a couple of hours under UML, which
means a qa cycle doesn't keep up with the rate at which I want to
test new changes......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
