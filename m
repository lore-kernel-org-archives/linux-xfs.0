Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E144A7F75
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 23:49:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67A0CAC00B
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 21:49:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QOCk0TBdlU4d8xyG for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 21:49:19 -0700 (PDT)
Date: Fri, 11 Apr 2014 14:48:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: fix random pread/pwrite to honor offset
Message-ID: <20140411044844.GH15995@dastard>
References: <53459C4E.9030902@sandeen.net> <5345B209.5040906@sgi.com>
	<5345B3AD.5020805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5345B3AD.5020805@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 09, 2014 at 03:55:09PM -0500, Eric Sandeen wrote:
> On 4/9/14, 3:48 PM, Mark Tinguely wrote:
> > On 04/09/14 14:15, Eric Sandeen wrote:
> >> xfs_io's pread & pwrite claim to support a random IO mode
> >> where it will do random IOs between offset & offset+len.
> >>
> >> However, offset was ignored, and we did the IOs between 0
> >> and len instead.
> >>
> >> Clang caught this by pointing out that the calculated/normalized
> >> "offset" variable was never read.
> >>
> >> (NB: If the range is larger than RAND_MAX, these functions don't
> >> work, but that's always been true, so I'll leave it for another
> >> day...)
> >>
> >> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> >> ---
....
> > 
> > Looks like this was introduced in:
> > commit 8fb2237e65555ff540e8b6108ffccfffefe239ac
> > Author: Nathan Scott <nathans@sgi.com>
> > Date:   Fri Nov 11 14:25:18 2005 +0000
> > 
> > Provide further debugging options and tweaks for analysing the read/write paths.
> > Merge of master-melb:xfs-cmds:24372a by kenmcd.
> > 
> >  ---
> > 
> > If it was broken for 8.5 years, I think it could be removed.
> 
> Eh, could, or we could fix it.  :)  I suppose this means it needs a test... :/

And document it ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
