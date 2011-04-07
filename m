Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p370LxQX063447 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:21:59 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FA643AF3A6
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:25:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Tz7pVW62pA0Wm1Rw for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:25:15 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:25:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: convert log tail checking to a warning
Message-ID: <20110407002512.GS31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-10-git-send-email-david@fromorbit.com>
	<20110406140257.GB24618@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406140257.GB24618@infradead.org>
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

On Wed, Apr 06, 2011 at 10:02:57AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 06, 2011 at 04:19:18PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > On the Power platform, the log tail debug checks fire excessively
> > causing the system to panic early in testing. The debug checks are
> > known to be racy, though on x86_64 there is no evidence that they
> > trigger at all.
> > 
> > We want to keep the checks active on debug systems to alert us to
> > problems with log space accounting, but we need to reduce the impact
> > of a racy check on testing on the Power platform.
> > 
> > As a result, convert the ASSERT conditions to warnings, and
> > allow them to fire only once per filesystem mount. This will prevent
> > false positives from interfering with testing, whilst still
> > providing us with the indication that they may be a problem with log
> > space accounting should that occur.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Keeping a potentially racy debug check around still seems somewhat
> fishy to me.  But you've done all the recent log work, so if it's
> going to help you spot problems I'm fine with keeping it in this way,

It was invaluable when testing the modifications to make the log
grant accounting lockless, so I really don't want to get rid of it
altogether.  This seemed like the least-worst compromise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
