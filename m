Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA7D27CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 17:35:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACEB38F8033
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 15:35:15 -0700 (PDT)
Date: Wed, 31 Jul 2013 08:34:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] how to use fstrim?
Message-ID: <20130730223450.GL13468@dastard>
References: <51F2BD31.5060301@profihost.ag> <20130727015029.GT13468@dastard>
	<51F815EB.9040000@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F815EB.9040000@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 30, 2013 at 09:37:15PM +0200, Stefan Priebe wrote:
> Am 27.07.2013 03:50, schrieb Dave Chinner:
> >On Fri, Jul 26, 2013 at 08:17:21PM +0200, Stefan Priebe wrote:
> >>Hi,
> >>
> >>what is the right way to use fstrim on top of XFS? just doing fstrim
> >>-v -m 4194304 /
> >>
> >>results sometimes (might depend on disk i/o) to hanging tasks and
> >>stack traces - fstrim needs > 5 min in these cases.
> >
> >It does indeed depend on disk IO. XFS walks all the free space and
> >issues discards on it, so runtime is always O(freespace). And while
> >it is walking an AG discarding the free space, it will hold the AG
> >locked so that free space doesn't change. This can hang other
> >operations for the length of time it takes to discard all the free
> >space in the AG.
> > IOWs, the behaviour of fstrim on XFS is entirely dependent on the
> > speed of the block layer and hardware implementations of discards.
> 
> Yes OK i understand that but is there any way to prevent getting the
> whole server crash when I/O is too much?

Sorry, what crash are you talking about? IO being slow because you
ran fstrim isn't a crash....

> For example splitting whole disk or even AGs into subparts? Or set a
> timeout for the fstrim command?

You can split fstrim up into smaller sections yourself by using the
range parameters.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
