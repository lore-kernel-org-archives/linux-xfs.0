Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6K0LwgM200714 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 19:21:58 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9BC180F4A
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 17:21:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UceNyJStxAkDwgyy for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2011 17:21:56 -0700 (PDT)
Date: Wed, 20 Jul 2011 10:21:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110720002154.GE9359@dastard>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-2-git-send-email-david@fromorbit.com>
	<1311116624.1964.38.camel@doink> <20110719233644.GB9359@dastard>
	<20110720001530.GA13475@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110720001530.GA13475@infradead.org>
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
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Tue, Jul 19, 2011 at 08:15:31PM -0400, Christoph Hellwig wrote:
> On Wed, Jul 20, 2011 at 09:36:44AM +1000, Dave Chinner wrote:
> > Looks cleaner, but I'll need to test it. Right now all my test
> > resources are busy with non-mainline stuff, so it's going to be next
> > week sometime before I can do this.
> 
> Given that the merge window is about to open how about putting in the
> current version for now and doing a cleanup patch on top later on?

I'm happy with that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
