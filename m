Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FFD37F3F
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 17:04:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29C3E304062
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 15:04:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bMm1x53HoaXxg4Yl for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 15:04:22 -0700 (PDT)
Date: Sat, 26 Apr 2014 08:04:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.15-rc4 PATCH] xfs: fully support v5 format filesystems
Message-ID: <20140425220418.GW18672@dastard>
References: <1398324998-2592-1-git-send-email-david@fromorbit.com>
	<20140425063000.GA27527@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140425063000.GA27527@infradead.org>
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

On Thu, Apr 24, 2014 at 11:30:00PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 24, 2014 at 05:36:38PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We have had this code in the kernel for over a year now and have
> > shaken all the known issues out of the code over the past few
> > releases. It's now time to remove the experimental warnings during
> > mount and fully support the new filesystem format in production
> > systems.
> 
> Shouldn't we wait until the xfsprogs 3.2.0 release before this?

I'm expecting that 3.2.0 will release at the same time as 3.15,
hence this needs to go upstream before the release to co-ordinate
that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
