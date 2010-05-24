Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4O1GsPQ148229 for <xfs@oss.sgi.com>; Sun, 23 May 2010 20:16:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 655B51DF7B8C
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 18:19:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	zqEP1s81IfTi8ITo for <xfs@oss.sgi.com>;
	Sun, 23 May 2010 18:19:14 -0700 (PDT)
Date: Mon, 24 May 2010 11:19:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100524011907.GC12087@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
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
To: Roman Kononov <roman@binarylife.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > You've got some workload that is mixing direct IO writes with some
> > form of buffered or mmap IO on the same file and they are racing.
> > Mixing different types of IO on the one inode is also known as A
> > Really Bad Idea because there is no guarantee of coherency between
> > them....
> > 
> > Can you find out what the application is triggering this?
> 
> This is severely modified Postgresql, which does mix direct IO with
> buffered one.

I hope you keep plenty of backups, then...

> You say "they are racing". Do you mean that this can cause file system
> corruption?

... because it's Not filesystem corruption you need to be worried
about, it's *silent data corruption* that these races can cause.

> Doest it simply warn that direct user data races with
> buffered user data and one of them wins?

Yes, that's right. No guarantee of who wins is given, though.

> This warning "taints" the kernel.

Yup, the application is doing something dangerous, and this warning
is there to let us know that the data corruption is the user's
fault, not the filesystem...

> Should it be safe to do different types of IOs on different
> non-overlapping 4-KiB-aligned regions of the same file (I am unsure
> if this is what the application really does)?

Yes, it should be safe, but the kernel code can't know whether this
is true or not - there are no specific interlocks with direct IO to
prevent concurrent buffered IO to the same region while a direct IO
is in progress. XFS does best effort attempts to maintain coherency
does not provide any guarantees, hence the warning when known race
conditions are tripped.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
