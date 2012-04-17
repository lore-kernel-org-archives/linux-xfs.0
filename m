Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H4D3xS014388 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 23:13:03 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9NTvbJmbNn7EWVkc for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 21:13:01 -0700 (PDT)
Date: Tue, 17 Apr 2012 14:12:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/18] xfs: current patch queue
Message-ID: <20120417041258.GF6734@dastard>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<20120416212911.GE2924@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120416212911.GE2924@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 16, 2012 at 04:29:11PM -0500, Ben Myers wrote:
> Dave, 
> 
> On Fri, Apr 13, 2012 at 10:10:43PM +1000, Dave Chinner wrote:
> > Here's a repost of my current patch queue. They are all based on Christoph's
> > ilock and xfsbufd patch series and been tested on top of them. I've updated all
> > the reviewed-by tags, so if the patch is missing such a tag then it hasn't been
> > reviewed....
> 
> Looks like Christoph has some work to do on patch 4 of his xfsbufd series.  Do
> you want to rebase to something without that patch?

It's a bit of a PITA to do because of all the overlap with
Christoph's patch set. I'll spend the afternoon trying to work out
what is wrong with Christoph's code, because I think we really need
to get rid of the xfsbufd before I start making the buffer code more
complex again...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
