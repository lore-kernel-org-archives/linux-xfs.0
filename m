Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09McVwV207880 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 16:38:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D2741C3EA99
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2010 14:39:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	71HkZ37tMwTn2LEX for <xfs@oss.sgi.com>;
	Sat, 09 Jan 2010 14:39:24 -0800 (PST)
Date: Sun, 10 Jan 2010 09:39:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Re: [PATCH v2] xfs: Don't flush stale inodes
Message-ID: <20100109223920.GA4019@discord.disaster>
References: <20100109000927.GE8654@discord.disaster>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A693B@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693B@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 09, 2010 at 10:22:14AM -0600, Alex Elder wrote:
> Yes, I see that now.  I had marked your older one "Reviewed" and
> didn't look further.  I will re-do the port and will re-submit.
> BTW I also plan to port the perag radix tree patch(es) over this
> for you after I get this one published.

Don't make extra work for yourself that slows down the rate at which
you can merge stuff. When the tree is updated with these patches,
I'll fix any conflicts in my patches and retest them, then send them
to the list again.

As a maintainer, manually munging a bunch patches around to fit,
then asking if they are correct, then finally merging them doesn't
scale - push that work back out to the patch authors where it does
scale and who have probably already done the work.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
