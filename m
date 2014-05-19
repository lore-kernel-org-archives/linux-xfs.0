Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD7CF7F3F
	for <xfs@oss.sgi.com>; Sun, 18 May 2014 21:56:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88448F8039
	for <xfs@oss.sgi.com>; Sun, 18 May 2014 19:56:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1WOv6DPBcNAC69yR for <xfs@oss.sgi.com>;
	Sun, 18 May 2014 19:55:59 -0700 (PDT)
Date: Mon, 19 May 2014 12:55:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
Message-ID: <20140519025553.GB8554@dastard>
References: <20140516055650.GF26353@dastard>
	<y2a8uq11g5k.fsf@cartman.at.offog.org>
	<20140517002309.GA18954@dastard>
	<y2a4n0o1xt7.fsf@cartman.at.offog.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <y2a4n0o1xt7.fsf@cartman.at.offog.org>
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
To: Adam Sampson <ats@offog.org>
Cc: xfs@oss.sgi.com

On Sat, May 17, 2014 at 11:53:08AM +0100, Adam Sampson wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > [...] it's preferable to have things like xfs_repair abort when it
> > comes across an inconsistency it can't handle than to continue blindly
> > along and making a bigger mess of the filesystem it's supposed to be
> > fixing...
> 
> Yes -- that's why I was building with DEBUG= on previous releases
> (i.e. I want assertions enabled). doc/INSTALL says that DEBUG=-DNDEBUG
> disables assertions, so packagers are quite likely to have DEBUG= in
> their build process.

Hmmm - so, not being an everyday userspace programmer, it didn't
even occur to me that "-DNDEBUG" actually changes libc header
behaviour, not anything to do with the XFS code.

$ man assert
.....
BUGS
       assert()  is  implemented as a macro; if the expression
       tested has side-effects, program behavior will be different
       depending on whether NDEBUG is defined.  This may create
       Heisenbugs which go away when debugging is turned on.

Yup, it's oh so obvious now that "NDEBUG" is something owned by
system library code, not the xfsprogs package...

<sigh>

> > Anyway, we'll look to fix it for 3.2.1.

Or maybe not. The intent of always turning off the asserts is that
code like xfs_repair shouldn't assert fail when stuff it detected as
out of bounds in a library function. IOWs, you're quite likely to
unintentionally break repair by removing the NDEBUG define to
re-instate the library asserts...

The control of the assert statements in the xfs_repair code itself
is handled by the -DDEBUG macro, which is configurable. i.e. you can
chose whether or not to have asserts in the repair code itself for
it to fail when an inconsistency it can't handle is detected, but
repair defines "inconsistent and cannot continue" very differently
to the libxfs library code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
