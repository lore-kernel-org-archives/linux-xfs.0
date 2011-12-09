Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB9MK3wa236800 for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 16:20:03 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E9D156B3BA
	for <xfs@oss.sgi.com>; Fri,  9 Dec 2011 14:19:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FspeIfJmDFWk6w6D for <xfs@oss.sgi.com>;
	Fri, 09 Dec 2011 14:19:59 -0800 (PST)
Date: Sat, 10 Dec 2011 09:19:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS causing stack overflow
Message-ID: <20111209221956.GE14273@dastard>
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111209115513.GA19994@infradead.org>
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
Cc: linux-mm@kvack.org, xfs@oss.sgi.com, "Ryan C. England" <ryan.england@corvidtec.com>

On Fri, Dec 09, 2011 at 06:55:13AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 08, 2011 at 01:03:51PM -0500, Ryan C. England wrote:
> > I am looking for assistance on XFS which is why I have joined this mailing
> > list.  I'm receiving a stack overflow on our file server.  The server is
> > running Scientific Linux 6.1 with the following kernel,
> > 2.6.32-131.21.1.el6.x86_64.
> > 
> > This is causing random reboots which is more annoying than anything.  I
> > found a couple of links in the archives but wasn't quite sure how to apply
> > this patch.  I can provide whatever information necessary in order for
> > assistance in troubleshooting.
> 
> It's really mostly an issue with the VM page reclaim and writeback
> code.  The kernel still has the old balance dirty pages code which calls
> into writeback code from the stack of the write system call, which
> already comes from NFSD with massive amounts of stack used.  Then
> the writeback code calls into XFS to write data out, then you get the
> full XFS btree code, which then ends up in kmalloc and memory reclaim.

You forgot about interrupt stacking - that trace shows the system
took an interrupt at the point of highest stack usage in the
writeback call chain.... :/

> You probably have only a third of the stack actually used by XFS, the
> rest is from NFSD/writeback code and page reclaim.  I don't think any
> of this is easily fixable in a 2.6.32 codebase.  Current mainline 3.2-rc
> now has the I/O-less balance dirty pages which will basically split the
> stack footprint in half, but it's an invasive change to the writeback
> code that isn't easily backportable.

It also doesn't solve the problem, because we can get pretty much
the same stack from the COMMIT operation starting writeback....

The backport of the patches that separate the allocation onto a
separte workqueue are not straight forward because all the workqueue
code is different. I'll go back and update the TOT patch to make
this separation first before backporting...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
