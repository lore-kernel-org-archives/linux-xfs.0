Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AEDF7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 16:31:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D100DAC009
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 14:31:09 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0moiEjeIyD3WKQM2 for <xfs@oss.sgi.com>;
	Fri, 28 Feb 2014 14:31:07 -0800 (PST)
Date: Sat, 1 Mar 2014 09:31:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfstests: Move fallocate include into global.h
Message-ID: <20140228223105.GE13647@dastard>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-4-git-send-email-lczerner@redhat.com>
	<5310C4B5.9010901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5310C4B5.9010901@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 28, 2014 at 11:17:41AM -0600, Eric Sandeen wrote:
> On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> > Move the inclusion of falloc.h with all it's possible defines for the
> > fallocate mode into global.h header file so we do not have to include
> > and define it manually in every tool using fallocate.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> I like the direction, but I think this changes behavior a little bit.
> 
> #ifdef FALLOCATE came from an autoconf macro:
> 
> AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
>   [ AC_MSG_CHECKING([for fallocate])
>     AC_TRY_LINK([
> #define _GNU_SOURCE
> #define _FILE_OFFSET_BITS 64
> #include <fcntl.h>
> #include <linux/falloc.h> ],
>       [ fallocate(0, 0, 0, 0); ],
>       [ have_fallocate=true; AC_MSG_RESULT(yes) ],
>       [ have_fallocate=false; AC_MSG_RESULT(no) ])
>     AC_SUBST(have_fallocate)
>   ])
> 
> (at least I think so?)

Not quite. autoconf defines "have_fallocate" to match the variable
name in the AC_SUBST() macro above. The makefiles do this:

include/builddefs.in:HAVE_FALLOCATE = @have_fallocate@               
include/builddefs.in:HAVE_FALLOCATE = @have_fallocate@               

to define HAVE_FALLOCATE at the makefile level, and then they do
this to pass it into the C source:

ltp/Makefile:ifeq ($(HAVE_FALLOCATE), true)
ltp/Makefile:LCFLAGS += -DFALLOCATE

src/Makefile:ifeq ($(HAVE_FALLOCATE), true)
src/Makefile:LCFLAGS += -DHAVE_FALLOCATE

> and so #ifdef FALLOCATE meant that
> an fallocate syscall actually exists.  With your changes,
> the test is now whether the fallocate *header* exists.

It actually tests both, because if header doesn't exist, the compile
of the test stub will fail in the macro will fail. So, no change
there, really.

> falloc.h is part of kernel-headers, not glibc.  So it's
> possible that there's a divergence between the two.

Right, which is why we need to test both ;)

> I think it's probably ok.  Build-time checks should
> determine whether we are able to _build_ and yours do that.
> Each caller of fallocate (or each test using it) then probably
> needs to ensure that the functionality it wants is actually
> available at runtime and handle it if not.
> 
> So I'll give this a 
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> but maybe the above rambling will ring alarm bells for
> someone else... ;)

I need to look at it all in more detail. I thought I'd just explain
exactly what was happening with autoconf here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
