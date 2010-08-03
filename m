Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73Nf56X261858 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 18:41:05 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DA6311C9536
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 16:49:25 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id Ey3ouUedMCjEBhLA for
	<xfs@oss.sgi.com>; Tue, 03 Aug 2010 16:49:25 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o73NadKS025152
	for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:36:39 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o73NfKWg109490 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:41:20 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id o73NfGMw012678
	for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:41:16 -0600
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
From: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <20100803225658.GB26402@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<20100730025324.GO25774@parisc-linux.org>
	<20100730045331.GA2126@dastard>
	<1280856865.2436.31.camel@mingming-laptop>
	<20100803225658.GB26402@dastard>
Date: Tue, 03 Aug 2010 16:41:14 -0700
Message-ID: <1280878874.2334.6.camel@mingming-laptop>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, sandeen@sandeen.net, Matthew Wilcox <matthew@wil.cx>

On Wed, 2010-08-04 at 08:56 +1000, Dave Chinner wrote:
> On Tue, Aug 03, 2010 at 10:34:25AM -0700, Mingming Cao wrote:
> > On Fri, 2010-07-30 at 14:53 +1000, Dave Chinner wrote:
> > > On Thu, Jul 29, 2010 at 08:53:24PM -0600, Matthew Wilcox wrote:
> > > > On Fri, Jul 30, 2010 at 08:45:16AM +1000, Dave Chinner wrote:
> > > > > If we get two unaligned direct IO's to the same filesystem block
> > > > > that is marked as a new allocation (i.e. buffer_new), then both IOs will
> > > > > zero the portion of the block they are not writing data to. As a
> > > > > result, when the IOs complete there will be a portion of the block
> > > > > that contains zeros from the last IO to complete rather than the
> > > > > data that should be there.
> ....
> > > I don't want any direct IO for XFS to go through the page cache -
> > > unaligned or not. using the page cache for the unaligned blocks
> > > would also be much worse for performance that this method because it
> > > turns unaligned direct IO into 3 IOs - the unaligned head block, the
> > > aligned body and the unaligned tail block. It would also be a
> > > performance hit you take on every single dio, whereas this way the
> > > hit is only taken when an overlap is detected.
> > 
> > Does this problem also possible for DIO and non AIO case? (Ext4 case
> > this only happy with AIO+DIO+unaligned).  If not, could we simply force
> > unaligned AIO+DIO to be synchronous? Still direct IO...
> 
> There is nothing specific to AIO about this bug. XFS (at least)
> allows concurrent DIO writes to the same inode regardless of whether
> they are dispatched via AIO or multiple separate threads and so the
> race condition exists outside just the AIO context...
> 

Okay..yeah ext4 prevent direct IO write to the same inode from multiple
threads, so this is not a issue for non-aio case.

How does XFS serialize direct IO (aligned) to the same file offset(or
overlap) from multiple threads?

Mingming

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
