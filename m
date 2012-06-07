Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q572Dw5H027064 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 21:13:59 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UpWzYCRW9ln682cA for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 19:13:57 -0700 (PDT)
Date: Thu, 7 Jun 2012 12:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: re-enable xfsaild idle mode and fix associated races
Message-ID: <20120607021353.GR22848@dastard>
References: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
	<4FCCEF94.7020501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FCCEF94.7020501@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Jun 04, 2012 at 12:25:40PM -0500, Mark Tinguely wrote:
> On 05/24/12 11:06, Brian Foster wrote:
> >xfsaild idle mode logic currently leads to a couple hangs:
> >
> >1.) If xfsaild is rescheduled in during an incremental scan
> >     (i.e., tout != 0) and the target has been updated since
> >     the previous run, we can hit the new target and go into
> >     idle mode with a still populated ail.
> >2.) A wake up is only issued when the target is pushed forward.
> >     The wake up can race with xfsaild if it is currently in the
> >     process of entering idle mode, causing future wake up
> >     events to be lost.
> >
> >Both hangs are reproducible by running xfstests 273 in a loop.
> >Modify xfsaild to enter idle mode only when the ail is empty
> >and the push target has not been moved forward since the last
> >push.
> >
> >Signed-off-by: Brian Foster<bfoster@redhat.com>
> >---
> 
> I wouldn't mind keeping an large (a few minutes) wake up value for the
> empty AIL case to be paranoid.

And then we'll never hear about hangs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
