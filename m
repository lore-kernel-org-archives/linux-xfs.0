Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8U2LckJ084768 for <xfs@oss.sgi.com>; Sat, 29 Sep 2012 21:21:38 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vd2gCsEavaKzQ5S2 for <xfs@oss.sgi.com>;
	Sat, 29 Sep 2012 19:22:59 -0700 (PDT)
Date: Sun, 30 Sep 2012 12:22:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: only update the last_sync_lsn when a transaction
	completes
Message-ID: <20120930022235.GG23520@dastard>
References: <1348807035-20087-1-git-send-email-david@fromorbit.com>
	<20120928124038.GA25262@infradead.org>
	<20120928233752.GE23520@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120928233752.GE23520@dastard>
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

On Sat, Sep 29, 2012 at 09:37:52AM +1000, Dave Chinner wrote:
> On Fri, Sep 28, 2012 at 08:40:38AM -0400, Christoph Hellwig wrote:
> > 
> > Looks good.
> > 
> > Do you have any testcase for this?  It doesn't look like an issue found
> > by code inspection.
> 
> Yeah, test 182 with my xfssyncd-die-die-die patchset triggers it
> 100% reliably.

FWIW, I've occasionally seen unreproducable recovery issues that
could have been caused by this for many years now. This is
effectively correcting a zero-day bug in the log behaviour. Here's
the commit that introduced this behaviour:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=99b58644923246c710c6dc9f7b47bcae66ed3c63

Dated 4th May, 1994.

It's definitely a contender for the oldest bug we've ever found in
the XFS code base...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
