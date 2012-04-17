Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H0QaTo259373 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 19:26:36 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gca2iPl8tVIZBOcb for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 17:26:34 -0700 (PDT)
Date: Tue, 17 Apr 2012 10:26:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120417002610.GC6734@dastard>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org> <20120413075634.GD6734@dastard>
	<20120413081725.GA3640@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120413081725.GA3640@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 09:17:25AM +0100, Brian Candler wrote:
> On Fri, Apr 13, 2012 at 05:56:34PM +1000, Dave Chinner wrote:
> > In some cases.
> > 
> > You can't just blindly assert that something is needed purely on
> > the size of the filesystem.
> 
> Thanks, but then perhaps the XFS FAQ needs updating. It warns that you might
> have compatibility problems with old clients (NFS) and inode64, but it
> doesn't say "for some workloads inode32 may perform better than inode64 on
> large filesystems".

The FAQ doesn't say anything about whether inode32 performs better
than inode64 or vice versa. All it talks about is inode allocation
locality and possible errors (like ENOSPC with lots of free space)
that can occur with inode32.

> Also, aren't these orthogonal features?
> 
> (1) "I want all my inode metadata stored at the front of the disk"
> 
> (2) "I want files in the same directory to be distributed between AGs, not
>     stored in the same AG"
> 
> If there are not explicit knobs for these behaviours, then it seems almost
> accidental that limiting yourself to 32-bit inode numbers causes them to
> happen (an implementation artefact).

The behaviour of inode32 was defined long before anyone who
currently works on XFS had any say in the matter. Most people really
consider it a nasty hack that was done to avoid needing to make NFS
clients 64 bit inode number clean back in 1998. At the time it was
unpopular, but considered the least worst solution to the problem.
The biggest issue was that it was made the default mount option...

It's now a historical artifact, and all we are doing is preserving
the behaviour of the allocation policies because there are plenty of
applications out there that rely on the way inode32 or inode64
behaves to acheive their performance..

> Finally, what happens if you have a filesystem smaller than 1TB? I imagine
> that XFS will scale the agsize down so that you have multiple AGs, but will
> still have 32-bit inode numbers - so you will get the same behaviour as
> inode64 on a large filesystem.  What happens then if your workload requires
> behaviour (1) and/or (2) above for optimal performance?

Then you get to choose the least worse option.

Making allocation policy more flexible is something that I've been
wanting to do for years - it was something I was working on when I
left SGI almost 4 years ago (along with metadata checksums). Here's
the patchset of what I'd written from that time:

http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

You're more than welcome to pick it up and start working on it again
so that we can have a much more flexible allocation subsystem if you
want....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
