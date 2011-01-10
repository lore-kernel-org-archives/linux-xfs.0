Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A8dEnB226147 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 02:39:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A82B24E14D
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 00:41:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	EN2EVcyMX54M1hGJ for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 00:41:25 -0800 (PST)
Date: Mon, 10 Jan 2011 19:41:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110110084122.GF28803@dastard>
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
	<201101100857.53421@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201101100857.53421@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, Jan 10, 2011 at 08:57:52AM +0100, Michael Monnerie wrote:
> On Montag, 10. Januar 2011 Dave Chinner wrote:
> > This patch uses 32-way threading which results in no noticable
> > slowdown on single SATA drives with NCQ, but results in ~10x
> > reduction in runtime on a 12 disk RAID-0 array.
> 
> Is the fixed 32-way number reasonable, or shouldn't that be "number of 
> available cpu cores"-way? Why threading when you have a single core cpu?

Sure, 32-way is reasonable on a single disk and CPU. Pretty much
every sata disk supports NCQ these days, and default to a depth of
32, which means we can have 32 concurrent reads in progress at once.
Phase 2 is all synchronous IO, so the only way to hide the IO
latency is to queue work to multiple threads and switch between the
threadsto work on another queue when the current one blocks waiting
for IO.

Basically the threading being used to drive IO level concurrency,
not to drive CPU level concurrency - the total CPU usage of phase 2
is less than what even a slow CPU can provide, so to keep it busy we
need lots of concurrent IO streams in progress at once...

And if you want to change it, there's a command line option for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
