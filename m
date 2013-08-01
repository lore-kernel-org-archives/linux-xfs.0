Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24DBF7F3F
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 19:09:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 071088F8033
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 17:09:14 -0700 (PDT)
Date: Thu, 1 Aug 2013 10:08:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] how to use fstrim?
Message-ID: <20130801000845.GG7118@dastard>
References: <51F2BD31.5060301@profihost.ag> <20130727015029.GT13468@dastard>
	<CAGpXXZ+no_YcepmwMopFDYO_6PR6jOop9UpY_mAcaPbLA6CYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGpXXZ+no_YcepmwMopFDYO_6PR6jOop9UpY_mAcaPbLA6CYkg@mail.gmail.com>
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
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe <s.priebe@profihost.ag>

On Wed, Jul 31, 2013 at 09:26:35AM -0400, Greg Freemyer wrote:
> On Fri, Jul 26, 2013 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> > IOWs, the behaviour of fstrim on XFS is entirely dependent on the
> > speed of the block layer and hardware implementations of discards.
> 
> And on a lot of SSDs, trim seems to act like a cache flush so it can
> hit performance hard.

That's because TRIM on SATA3 is an unqueued command. It basically
causes the pipeline to be emptied before it can be issued, and no
further IO can be issued until it completes. SATA3.1 is supposed to
add a queued TRIM command, but it might be some time before we see
that appearing in hardware...

> It should be scheduled for off-peak times
> afaik.  It's not critical to run hourly or even daily.  If you can
> schedule it once a week when other i/o is light that should be enough
> for most workloads.

I run it once every couple of months on my SSDs, if ever. Most
modern SSDs have background defragmentation so if they are left idle
for a couple of hours they clean themselves up pretty well without
needing TRIM...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
