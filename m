Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65AWNSq251398 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 05:32:23 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7873593D1FE
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 03:32:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dYBmrx2bOEnzFUFp for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 03:32:21 -0700 (PDT)
Date: Tue, 5 Jul 2011 20:32:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_bmap Cannot allocate memory
Message-ID: <20110705103217.GC561@dastard>
References: <4E129B00.4020709@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E129B00.4020709@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 07:02:56AM +0200, Michael Weissenbacher wrote:
> Hi List!
> I've got a file here on which i cannot use xfs_bmap to determine it's
> fragments. All that i know is that it must have a really great number of
> them. It was the result of running a smbd without strict allocate. The
> machine itself has 8GiB of RAM and 10GiB of swap available, so that
> shouldn't be the problem. I guess this is some bug in xfs_bmap. Or is it
> a known limitation?

Sounds like your memory is fragmented. IIRC, bmap tries to map all
the extents in a single buffer, and that might cause problems for
files with large numbers of extents. ENOMEM can occur if an
internal buffer cannot be allocated to hold all the extents to be
mapped in one call.

Try using the "-n <num_extents>" option to reduce the number of
extents gathered per ioctl call and see if that makes the
issue go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
