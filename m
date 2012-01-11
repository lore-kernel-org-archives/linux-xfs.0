Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BA3Kho153117
	for <linux-xfs@oss.sgi.com>; Wed, 11 Jan 2012 04:03:20 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dZ12GDtKWysVl5ce for <linux-xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 02:03:18 -0800 (PST)
Date: Wed, 11 Jan 2012 21:03:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why does xfsdump encounter "WARNING: could not get list of
	non-root attributes for nondir ino nnnn: Cannot allocate memory (12)"?
Message-ID: <20120111100316.GH24410@dastard>
References: <jdo01m$62j$1@dough.gmane.org> <20120102213706.GQ23662@dastard>
	<20120111095513.GA26958@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120111095513.GA26958@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, Michael Lueck <mlueck@lueckdatasystems.com>

On Wed, Jan 11, 2012 at 04:55:14AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 03, 2012 at 08:37:06AM +1100, Dave Chinner wrote:
> > xfs: handle kmalloc failure when reading attrs
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfsdump uses for a large buffer for extended attributes, which has a
> > kmalloc'd shadow buffer in the kernel. This can fail after the
> > system has been running for some time as it is a high order
> > allocation. Convert this to a vmalloc so that it doesn't require
> > contiguous memory and so won't randomly fail while xfsdump is
> > running.
> 
> I think this should use kmalloc for allocation smaller than a page to
> avoid the vmalloc overhead for the usual case of small attributes.
> 
> Also the fs/xattr.c code for the normal xattr system calls needs the
> same treatment.

Sounds like a generic kvmalloc()/kvfree() call pair is the answer
then. i.e. if kmalloc fails, then use vmalloc()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
