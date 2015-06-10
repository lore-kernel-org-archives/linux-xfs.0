Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AA727F91
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 03:45:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6314AC003
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 01:45:23 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ep9Gy5EbInwS8HUy for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 01:45:21 -0700 (PDT)
Date: Wed, 10 Jun 2015 18:44:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610084445.GD24666@dastard>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
	<20150610083441.GW9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610083441.GW9143@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 10, 2015 at 06:34:41PM +1000, Dave Chinner wrote:
> On Wed, Jun 10, 2015 at 01:24:15AM -0700, Christoph Hellwig wrote:
> > On Wed, Jun 10, 2015 at 06:19:14PM +1000, Dave Chinner wrote:
> > > Does the problem go away after a 'make distclean'?
> > 
> > No. Neither a distclean nor a fresh clone fixes the issue.
> > 
> > Also disabling the crc32ctest target I get similar error in other
> > code.
> > 
> > Note that the master branch is doing fine.
> 
> Yeah, it's to do with the libxfs restructure in the for-next branch
> to ring it up to the same as the 4.1 kernel. Can you dump the output
> of 'ls -l include/xfs' and attach your include/platform_defs.h file?

Looking at my tree, I suspect it is a missing link from
include/xfs/platform_defs.h -> include/platform_defs.h.

I don't have that link in my tree, and so it's pulling
/usr/include/xfs/platform_defs.h into the build and hence not
failing on my build machine. Not sure where it's getting that
include rule from yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
