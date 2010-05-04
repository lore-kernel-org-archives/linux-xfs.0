Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o44BgKZl223520 for <xfs@oss.sgi.com>; Tue, 4 May 2010 06:42:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5217013404E4
	for <xfs@oss.sgi.com>; Tue,  4 May 2010 04:44:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	QU9aL5mjKap7ZsE8 for <xfs@oss.sgi.com>;
	Tue, 04 May 2010 04:44:27 -0700 (PDT)
Date: Tue, 4 May 2010 21:44:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT] Delayed Logging V3
Message-ID: <20100504114423.GC8120@dastard>
References: <20100504015042.GA8120@dastard>
	<20100504101733.GA18229@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100504101733.GA18229@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, May 04, 2010 at 06:17:33AM -0400, Christoph Hellwig wrote:
> On Tue, May 04, 2010 at 11:50:42AM +1000, Dave Chinner wrote:
> > The new cleanups added in this version mean it touche?? more files
> > that the previous versions, but overall it should still be simpler
> > to review because I've collapsed many of the intermediate patches
> > into one "Introduce delayed logging core code" commit.
> 
> Thanks.  Btw, a little procedural comment - you include the V2 markers
> and changelogs in the commit message.  Normal procedure is to have
> them below the -- or what it is marker with the diffstat so that they
> only get picked up in the mail and not the final commits, and no V2 in
> the subject line at all.

Yeah, That's typical. The problem is that guilt seems to kill
anything I add to the patch headers below a "---" separator.  Hence
if i don't put it the in commit message it doesn't stick as I rebase
my working branches, and hence doesn't get included in the
patchbombs I send direct from the repository.

For stuff that is in a series that I'm tracking in a separate branch I
can probably just keep versioning changes in the series header (the
patch 0/N message), but for individual patches it's a bit harder.
I'll see what I can do to track this more easily in my workflow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
