Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77BD429DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 19:01:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 66F48304039
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 17:01:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	B9D0fCA4WUxFeY0O for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2015 17:01:41 -0800 (PST)
Date: Fri, 20 Nov 2015 11:58:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151120005843.GP14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
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
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Octavian Purdila <octavian.purdila@intel.com>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 12:54:02AM +0100, Richard Weinberger wrote:
> On Fri, Nov 20, 2015 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> >> Naive implementation for non-mmu architectures: allocate physically
> >> contiguous xfs buffers with alloc_pages. Terribly inefficient with
> >> memory and fragmentation on high I/O loads but it may be good enough
> >> for basic usage (which most non-mmu architectures will need).
> >
> > Can you please explain why you want to use XFS on low end, basic
> > non-MMU devices? XFS is a high performance, enterprise/HPC level
> > filesystem - it's not a filesystem designed for small IoT level
> > devices - so I'm struggling to see why we'd want to expend any
> > effort to make XFS work on such devices....
> 
> The use case is the Linux Kernel Library:
> https://lkml.org/lkml/2015/11/3/706
> 
> Using LKL and fuse you can mount any kernel filesystem using fuse
> as non-root.

IOWs, because we said no to unprivileged mounts, instead the
proposal is to linking all the kernel code into userspace so you can
do unprivielged mounts that way?

IOWs, you get to say "it secure because it's in userspace" and leave
us filesystem people with all the shit that comes with allowing
users to mount random untrusted filesystem images using code that
was never designed to allow that to happen?

Fmeh. Not a convincing argument by far.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
