Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2149E7F5F
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 03:27:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C9A3AC008
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 01:27:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oFbUt2h0SO6Y85jr for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 01:27:38 -0700 (PDT)
Date: Tue, 20 May 2014 18:27:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
Message-ID: <20140520082724.GJ18954@dastard>
References: <20140516055650.GF26353@dastard>
	<y2a8uq11g5k.fsf@cartman.at.offog.org>
	<20140517002309.GA18954@dastard>
	<y2a4n0o1xt7.fsf@cartman.at.offog.org>
	<20140519025553.GB8554@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140519025553.GB8554@dastard>
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

On Mon, May 19, 2014 at 12:55:53PM +1000, Dave Chinner wrote:
> On Sat, May 17, 2014 at 11:53:08AM +0100, Adam Sampson wrote:
> > Dave Chinner <david@fromorbit.com> writes:
> > 
> > > [...] it's preferable to have things like xfs_repair abort when it
> > > comes across an inconsistency it can't handle than to continue blindly
> > > along and making a bigger mess of the filesystem it's supposed to be
> > > fixing...
> > 
> > Yes -- that's why I was building with DEBUG= on previous releases
> > (i.e. I want assertions enabled). doc/INSTALL says that DEBUG=-DNDEBUG
> > disables assertions, so packagers are quite likely to have DEBUG= in
> > their build process.
> 
> Hmmm - so, not being an everyday userspace programmer, it didn't
> even occur to me that "-DNDEBUG" actually changes libc header
> behaviour, not anything to do with the XFS code.
> 
> $ man assert
> .....
> BUGS
>        assert()  is  implemented as a macro; if the expression
>        tested has side-effects, program behavior will be different
>        depending on whether NDEBUG is defined.  This may create
>        Heisenbugs which go away when debugging is turned on.
> 
> Yup, it's oh so obvious now that "NDEBUG" is something owned by
> system library code, not the xfsprogs package...
> 
> <sigh>
> 
> > > Anyway, we'll look to fix it for 3.2.1.
> 
> Or maybe not. The intent of always turning off the asserts is that
> code like xfs_repair shouldn't assert fail when stuff it detected as
> out of bounds in a library function. IOWs, you're quite likely to
> unintentionally break repair by removing the NDEBUG define to
> re-instate the library asserts...

And it's not straight forward, either, because some of the ASSERT()s
have code in them that is only present when the libxfs code is built
with -DDEBUG, so compiling in the asserts without enabling -DDEBUG is
not going to work. And, well, compiling with -DDEBUG itself deosn't
work nor with -DNDEBUG -DDEBUG because -DDEBUG enables code that has
unhandled kernelisms in it.

So, right now, don't remove -NDEBUG from the libxfs/Makefile. It's
there for a good reason right now. i.e. removing it requires some
non-trivial work, and even if we do make it compile the resultant
code will probably not work (i.e. assert fail unnecessarily) given
the requirements that userspace has for tolerance of inconsistent
on-disk states.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
