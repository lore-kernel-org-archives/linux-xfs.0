Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 91A827F53
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 16:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80E738F8033
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 14:40:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3suv6fZ8hjM309lr for <xfs@oss.sgi.com>;
	Mon, 31 Mar 2014 14:40:27 -0700 (PDT)
Date: Tue, 1 Apr 2014 08:40:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix bad hash ordering
Message-ID: <20140331214016.GD17603@dastard>
References: <20140328173430.622616177@sgi.com> <20140331001055.GD16336@dastard>
	<53399B06.5010400@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53399B06.5010400@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Mar 31, 2014 at 11:42:46AM -0500, Mark Tinguely wrote:
> On 03/30/14 19:10, Dave Chinner wrote:
> >On Fri, Mar 28, 2014 at 12:33:34PM -0500, Mark Tinguely wrote:
> >>Fix the fix directory "bad hash ordering" bug introduced in
> >>commit f5ea1100.
> >
> 
> ...
> 
> >
> >>---
> >>A C program that generates this problem can be found at:
> >>  http://oss.sgi.com/archives/xfs/2014-03/msg00373.html
> >>
> >>A xfstest for this bug is coming from Hannes Frederic Sowa.
> >
> >Can you convert this program to an xfstest yourself so that I can
> >commit the regression test at the same time I commit an updated
> >fix?
> 
> We narrowed the iterations down to make it a quick test.
> I have every confidence that Hannes can generate the test in a timely
> manner and I will help in any way possible.

Well, it's been over a week now and you're asking me to trust that
someone I don't know and who has never submitted an xfstests before
to do something in a timely manner so we can test a critical bug fix
during a merge window. I'm willing to be pleasently surprised, but
history tells me that people that report bugs rarely follow up with
xfstest cases and it's usually the developer that fixes the bug that
generates the xfstests patch.

So if the xfstests patch doesn't arrive in the next few hours, can
you please do that for us so I can get this sorted out for the merge
window?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
