Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B3297CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:57:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5ED0AC006
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 15:57:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JzSON2wy6m4lu1xA for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2015 15:57:35 -0700 (PDT)
Date: Sun, 16 Aug 2015 08:57:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: Introduce writeback context for writepages
Message-ID: <20150815225734.GZ3902@dastard>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
	<1439333388-16452-2-git-send-email-david@fromorbit.com>
	<20150812072635.GA32399@infradead.org>
	<20150813013244.GP3902@dastard>
	<20150813065258.GA677@infradead.org>
	<20150814015309.GU3902@dastard>
	<20150815132336.GA7385@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150815132336.GA7385@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Aug 15, 2015 at 06:23:36AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 14, 2015 at 11:53:09AM +1000, Dave Chinner wrote:
> > Ok, I've gone back and had a look at this now and reminded myself of
> > the discussion we had and the problems found. The end results are
> > remarkably similar - maybe that's why I found it easy to write this
> > patch set. i.e. your patchset was buried somewhere in my brain, even
> > though I'd forgotten about it at the surface...
> > 
> > How would you like to see this patchset broken up into more
> > sensible/reviewable chunks? It's just folding and splitting patches,
> > so it's not a big deal to rework it...
> 
> I think it should be less.  Patch 3 should go first, and then 1,2,4 & 5
> as a single one.

No worries, I'll reorder and fold them, retest and repost. Thanks
Christoph!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
