Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB90w1pp155373 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 18:58:02 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6C891CA7B6A
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 16:59:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	ArF1txQl4CXmFiEk for <xfs@oss.sgi.com>;
	Wed, 08 Dec 2010 16:59:48 -0800 (PST)
Date: Thu, 9 Dec 2010 11:59:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101209005944.GD32766@dastard>
References: <30397503.post@talk.nabble.com> <20101207222558.GC29333@dastard>
	<30403823.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <30403823.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

On Wed, Dec 08, 2010 at 01:39:10AM -0800, blacknred wrote:
> 
> 
> >You've done a forced module load. No guarantee your kernel is in any
> >sane shape if you've done that....
> 
> Agree, but I'm reasonably convinced that module isn't the issue, because it
> works fine with my other servers......
> 
> >Strange failure. Hmmm - i386 arch and fedora - are you running with
> 4k stacks? If so, maybe it blew the stack...
> 
> i386 arch, rhel 5.0

Yup, 4k stacks. This is definitely smelling like a stack blowout.

XFS on 4k stacks is a ticking timebomb - it will explode and you've
got no idea of when it will go boom. Recompile your kernel with 8k
stacks or move to x86_64.

> ># dd if=<device> bs=512 count=1 | od -c
> This is what i get now, but now server's been rebooted and running OK, what
> should i be expecting or rather what are we looking for in this output at
> point of failure?

Well, what you see here:

> 0000000    X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0 025 324 304  \0
             ^^^^^^^^^^^^^
Is a valid XFS superblock magic number.

If you are getting this error:

> >> XFS: bad magic number
> >> XFS: SB validate failed 

Then I'd expect to see anything other than "XFSB" as the magic
number. Of course, if you smashed the stack during mount, then there
will most likely be nothing wrong with the value on disk...

> >why did I flash the controller
> I was on 5.22 fw version which has a known 'lockup' issue which is fixed in
> 7.x ver.
> This is a critical fix.

Is the version 7.x firmware certified with such an old kernel? It's
not uncommon for different firmware versions to only be supported on
specific releases/kernel versions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
