Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C2287F57
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:14:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAACFAC002
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:14:43 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qLRkogZ03tHrBFxL for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 13:14:41 -0800 (PST)
Date: Thu, 13 Feb 2014 08:14:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212211437.GG13997@dastard>
References: <52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard>
	<20140212142538.GA11046@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212142538.GA11046@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Feb 12, 2014 at 09:25:38AM -0500, Dave Jones wrote:
> On Wed, Feb 12, 2014 at 05:10:38PM +1100, Dave Chinner wrote:
>  > On Wed, Feb 12, 2014 at 12:50:27AM -0500, Dave Jones wrote:
>  > > On Wed, Feb 12, 2014 at 04:40:43PM +1100, Dave Chinner wrote:
>  > > 
>  > >  > None of the XFS code disables interrupts in that path, not does is
>  > >  > call outside XFS except to dispatch IO. The stack is pretty deep at
>  > >  > this point and I know that the standard (non stacked) IO stack can
>  > >  > consume >3kb of stack space when it gets down to having to do memory
>  > >  > reclaim during GFP_NOIO allocation at the lowest level of SCSI
>  > >  > drivers. Stack overruns typically show up with symptoms like we are
>  > >  > seeing.
>  > >  > ..
>  > >  > 
>  > >  > Dave, before chasing ghosts, can you (like Eric originally asked)
>  > >  > turn on stack overrun detection?
>  > > 
>  > > CONFIG_DEBUG_STACKOVERFLOW ? Already turned on.
>  > 
>  > That only checks stack usage when an interrupt is taken. If no
>  > interrupts are taken when stack usage is within 128 bytes of
>  > overflow, then it doesn't catch it.
>  > 
>  > I tend to use CONFIG_DEBUG_STACK_USAGE=y as it records the maximum
>  > stack usage of a process via canary overwrites and it records it in
>  > do_exit().
> 
> I had that on too. The only message from it came from quite a while
> before the trace that happened overnight..

Right, it won't capture an overrun at the point in time an overrun
occurs, either, because it only checks when the process exits. But
it does tell you what stack usage is being seen, as this:

> [ 3415.655125] trinity-c0 (4383) used greatest stack depth: 992 bytes left
> [12900.804230] BUG: sleeping function called from invalid context at mm/mempool.c:203

is a pretty a good indication that trinity is at risk of stack
overuns...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
