Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p234sejw066931 for <xfs@oss.sgi.com>; Wed, 2 Mar 2011 22:54:41 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CDA6A77207
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2011 20:57:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yKpRCcBDsUd89Hw2 for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 20:57:29 -0800 (PST)
Date: Thu, 3 Mar 2011 15:57:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3, 14/16] xfsprogs: metadump: fix duplicate handling
	once and for all
Message-ID: <20110303045714.GE15097@dastard>
References: <201102182121.p1ILL2Wl029181@stout.americas.sgi.com>
	<20110224083945.GB3166@dastard> <1298657632.1990.6988.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1298657632.1990.6988.camel@doink>
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

On Fri, Feb 25, 2011 at 12:13:52PM -0600, Alex Elder wrote:
> On Thu, 2011-02-24 at 19:39 +1100, Dave Chinner wrote:
> > On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> > > This is a case where I think I've solved a problem to death.
> > 
> > :)
> 
> After getting through the patch, you see what I mean?
> 
> I have some long discussion below.  It is mostly
> explanation for why I ended up with this, so it may
> not convince you it's worth keeping (but I hope so).

It certainly helps understand how you came to this solution, and it
definitely helps explain the _why_ of the code. Hence I think that
if you include the main points from this discussion in in the code,
then it will be OK. Stuff like documenting the change in the number
of alternatives as the length increases, why the bitflip table was
sized and when (if ever) we'd need to consider expanding it, that
handling duplicates of less than 5 characters is not important as we
don't obfuscate names of that length so the low number of alternates
is not an issue, etc.

I know that will make the comments longer than the code, but it
really does need to explain why it has been done this way. That will
save time when someone has to understand it in the future, and I'm
fine with that.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
