Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04DD17CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 17:26:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9A2C304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:26:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vccVNTK9MasbH81V for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 15:26:19 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:26:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [current tot] XFS: Assertion failed: bp->b_flags & XBF_ASYNC,
	file: fs/xfs/xfs_buf.c, line: 118
Message-ID: <20160803222616.GU16044@dastard>
References: <20160803061430.GS16044@dastard>
	<20160803144454.GA17518@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803144454.GA17518@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 10:44:55AM -0400, Brian Foster wrote:
> On Wed, Aug 03, 2016 at 04:14:30PM +1000, Dave Chinner wrote:
> > Hi Brian,
> > 
> > It seems I can hit this fairly often on a single CPU, 1GB ram VM
> > in generic/306:
> > 
> 
> I ended up reproducing on a similarly configured vm via xfs/305
> (generic/306 appears unrelated to quota..?).

Ugh, don't know how I screwed that up. Yes, it was xfs/305 that
triggered it here. Maybe it was generic/306 that triggered the inode
reclaim variant of the problem....

Anyway, not important now...

> Agreed. I'll fire off a patch. Thanks for catching this.

I'll pull it in and add to the list of things for the next -rc
update.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
