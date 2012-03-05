Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25129lk068675 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 19:02:09 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GgUFYmX4P1HIIPCl for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 17:02:06 -0800 (PST)
Date: Mon, 5 Mar 2012 12:02:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
Message-ID: <20120305010203.GK5091@dastard>
References: <4F50BF89.7020909@xwis.net> <20120302131240.GA14186@infradead.org>
	<4F53A2FF.3000305@xwis.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F53A2FF.3000305@xwis.net>
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
To: Olaf van der Spek <olaf@xwis.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Mar 04, 2012 at 06:14:39PM +0100, Olaf van der Spek wrote:
> On 2-3-2012 14:12, Christoph Hellwig wrote:
> >>I'd like to ask:
> >>- Is there a tool to log all unsafe operations?
> >
> >What is an unsafe operation?  Anything that's dumb and might lose data?
> 
> For example
> 
> >The possibilities are sheer endless.
> 
> And?
> 
> >>- What is the *right* way to update a file?
> >
> >  fd = open(tmpfile, ...);
> >  write(fd, ...);  // or any other update
> >  fdatasync(fd);
> >  rename(tmpfile, realfile);
> 
> Argh, come on.
> That's not real and it's not complete. tmpfile is undefined, errors
> aren't handled and you have lots of unlisted assumptions or
> regressions.

The above is perfectly reasonable psuedo code for quickly describing
how to safely overwriting a file. If you want to know about error
handling and assumptions, read the man pages for operation.

To make it easy for you, I'll just point out this has already been
dealt with early in in the LWN thread for that article, here's the
link to the comment and the relevant LWN article providing you with
all the information you want:

http://lwn.net/Articles/476606/
https://lwn.net/Articles/457667/

And that my stance on this atomic rename subject is simply this: If
we want to change reanme behaviour, then the filesystem is not the
right place to do it - atomic rename semantics need to be defined
and enforced at the VFS.  See here:

http://lwn.net/Articles/479152/

This has all been hashed out before - we don't need to revisit this
discussion here. If you want to solve the problem once and for all,
submit patches to LKML to implement the new rename semantics in a
new syscall....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
