Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59FZtFX070931 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 10:35:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B0171BEE790
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:13:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	71yduoFRmEwPqVj3 for <xfs@oss.sgi.com>;
	Fri, 30 Jul 2010 16:13:48 -0700 (PDT)
Date: Sat, 31 Jul 2010 09:13:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100730231337.GD2126@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<1280511789.16484.18.camel@badari-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280511789.16484.18.camel@badari-desktop>
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
To: Badari Pulavarty <pbadari@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 10:43:09AM -0700, Badari Pulavarty wrote:
> On Fri, 2010-07-30 at 08:45 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If we get two unaligned direct IO's to the same filesystem block
> > that is marked as a new allocation (i.e. buffer_new), then both IOs will
> > zero the portion of the block they are not writing data to. As a
> > result, when the IOs complete there will be a portion of the block
> > that contains zeros from the last IO to complete rather than the
> > data that should be there.
> > 
> > This is easily manifested by qemu using aio+dio with an unaligned
> > guest filesystem - every IO is unaligned and fileystem corruption is
> > encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
> > is also a simple reproducer.
> > 
> > To avoid this problem, track unaligned IO that triggers sub-block zeroing and
> > check new incoming unaligned IO that require sub-block zeroing against that
> > list. If we get an overlap where the start and end of unaligned IOs hit the
> > same filesystem block, then we need to block the incoming IOs until the IO that
> > is zeroing the block completes. The blocked IO can then continue without
> > needing to do any zeroing and hence won't overwrite valid data with zeros.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I can confirm that, it  fixes corruption  of my VM images when using AIO
> +DIO. (cache=none,aio=native). I haven't reviewed the patch closely, but
> 
> 1) can we do this only for AIO+DIO combination ? For regular DIO, we
> should have all the IOs serialized by i_mutex anyway..

Not for filesystems that do their own locking. In most cases XFS
does not take the i_mutiex during DIO writes, and when it does it
drops it long before we call into the generic direct IO code that
does the sub-block zeroing. So the i_mutex does not guarantee any
form of serialisation in direct IO writes at all.

> 2) Having a single global list (for all devices) might cause scaling
> issues.

Unaligned direct IO is undesirable in the first place. While we
shouldd behave correctly in this corner case, I0 don't see any need
for it to be particularly efficient as the real fix for performance
problems with unaligned DIO is to not issue it in the first place.

> 3) Are you dropping i_mutex when you are waiting for the zero-out to
> finish ?

For XFS we're not holding the i_mutex - and we can't take the
i_mutex either as that will cause lock inversion issues. We don't
know what locks are held, we don't know whether it is safe to drop
and take locks, we don't even have the context to operate on
filesystem specific locks to avoid ordering problems. If we can't
sleep with the locks we already have held at this point, the DIO is
already broken for that filesystem.

Besides, if the i_mutex is already held for some filesystem when we
zero blocks, then we can't very well have concurrent block zeroing
in progress, and therefore can't hit this bug, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
