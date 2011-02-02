Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p122AHnl258715 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 20:10:17 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFEFD1A64611
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 18:12:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CXHGVIOL3ZNXE7Cz for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 18:12:44 -0800 (PST)
Date: Wed, 2 Feb 2011 13:12:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfstests: Speed up test 042
Message-ID: <20110202021242.GP11040@dastard>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
	<1295927937-20634-5-git-send-email-david@fromorbit.com>
	<1296610209.2350.161.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1296610209.2350.161.camel@doink>
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

On Tue, Feb 01, 2011 at 07:30:09PM -0600, Alex Elder wrote:
> On Tue, 2011-01-25 at 14:58 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > test 042 generates a worst-case fragmented filesystem and uses it to
> > test xfs_fsr. It uses small 4k files to generate the hole-space-hole
> > pattern that fragments free space badly. It is much faster to
> > generate the same pattern by creating a single large file and
> > punching holes in it.  Also, instead of writing large files to
> > create unfragmented space, just use preallocation so we don't have
> > to write the data to disk.
> > 
> > These changes reduce the runtime of the test on a single SATA drive
> > from 106s to 27s.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Perhaps your test system is configured different
> from mine, but I don't see the speedup you see.
> In fact, it might have slowed it down.  I really
> haven't experimented much though and will report
> back if I find anything more constructive to say.

That may be because the resvsp call at the moment is a sync
transaction. I've got a patch to make that async which should solve
the problem for you. Mind you, the above numbers come from a Vm that
wasn't running that patch, so it probably depends mostly on how
efficient your storage is a processing barriers to the difference
you see right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
