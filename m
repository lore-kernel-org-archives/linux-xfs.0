Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9T09FIu088399 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 19:09:15 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mLpLzR8xSk5VeMWC for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 17:10:59 -0700 (PDT)
Date: Mon, 29 Oct 2012 11:10:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs_io: [v3] add the lseek() SEEK_DATA/SEEK_HOLE
	support
Message-ID: <20121029001036.GF4353@dastard>
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com> <20121022232931.GD4291@dastard>
	<20121023200144.515107339@sgi.com>
	<20121025141450.995788000@sgi.com> <20121025222914.GE29378@dastard>
	<508A909F.10305@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <508A909F.10305@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 26, 2012 at 08:31:11AM -0500, Mark Tinguely wrote:
> On 10/25/12 17:29, Dave Chinner wrote:
> >On Thu, Oct 25, 2012 at 09:14:44AM -0500, Mark Tinguely wrote:
> >>Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
> >>The result from the lseek() call will be printed to the output.
> >>For example:
> >>
> >>xfs_io>  lseek -h 609k
> >>Type	Offset
> >>hole	630784
> >>
> >>v1 ->  v2 Add "-a" and "-r" options.
> >>	 Simplify the output.
> >>v2 ->  v3 Refactor for configure.in ->  configure.ac change.
> >>	 SEEK_DATA with -1 offset behaves badly on older Linux.
> >>	 Display error message as "ERR<errno>".
> >....
> >>+
> >>+#include<linux/fs.h>
> >
> >I missed this first time around - why is this include necessary?
> 
> Take it out and you will find that it contains the
> defines for SEEK_DATA/SEEK_HOLE.

It was added in glibc 2.14, IIRC. All this means is that your
userspace libraries are not current, while your kernel headers are.

So, you shouldn't be including linux/fs.h directly, I think,
especially as SEEK_DATA/SEEK_HOLE is functionality that is not linux
specific. I suspect that you should do something more like:

#ifndef SEEK_DATA
#define SEEK_DATA 3
#define SEEK_HOLE 4
#endif

Because the autoconf test passed, but the parameters are not defined
correctly by userspace. That way it will still work on other
platforms if they support this functionality....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
