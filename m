Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5O2FfsI236209 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 21:15:41 -0500
Date: Fri, 24 Jun 2011 12:15:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
Message-ID: <20110624021534.GA32466@dastard>
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
	<m2boxocvb5.fsf@firstfloor.org>
	<20110623175533.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110623175533.GK11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Alex Elder <aelder@sgi.com>

On Thu, Jun 23, 2011 at 06:55:33PM +0100, Al Viro wrote:
> On Thu, Jun 23, 2011 at 10:27:26AM -0700, Andi Kleen wrote:
> > Maarten Lankhorst <m.b.lankhorst@gmail.com> writes:
> > 
> > > gcc with -Warray-bounds generates a false positive on this
> > > since xfs defines the struct with u8 name[1]; to be able to
> > > add a tag at the end.
> > 
> > A better way would be to define it as name[0]. Then the compiler
> > would know it's a VLA. You may need to check noone relies on
> > the one byte though.
> 
> ... and even better is to write in real C and have u8 name[]; in the
> end of your structure.

Hard to do when the structure is effectively the definition of the
on-disk format. Hence it can't just be changed around and the kernel
recompiled to fix the problem.

> That's the standard C99 for this kind of thing
> (see 6.7.2.1p2, p16).  Zero-sized array is a gccism predating standard
> flexible array members and since the standard syntax is accepted by
> any gcc version that might be recent enough to build the kernel...

This code came from Irix, which means it predates both the gccism
and the C99 standard methods of using flexible array sizes. The code
works so it's never been modified because stuffing about with
structures that define disk formats is not done just for the hell of
it... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
