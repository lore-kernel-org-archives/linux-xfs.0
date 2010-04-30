Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U8rAAA143962 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 03:53:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83342300DBC
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 01:55:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	OGKobJiMGH3cESrY for <xfs@oss.sgi.com>;
	Fri, 30 Apr 2010 01:55:14 -0700 (PDT)
Date: Fri, 30 Apr 2010 18:55:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Message-ID: <20100430085511.GE32515@dastard>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
	<20100429064943.GB3774@dastard>
	<20100429104611.GA17317@infradead.org>
	<20100430012630.GC32515@dastard> <1272594520.3221.154.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272594520.3221.154.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Apr 29, 2010 at 09:28:40PM -0500, Alex Elder wrote:
> On Fri, 2010-04-30 at 11:26 +1000, Dave Chinner wrote:
> > On Thu, Apr 29, 2010 at 06:46:11AM -0400, Christoph Hellwig wrote:
> > > Spoken too soon.  While this second patch at least compiles on my Debian
> > > testing  system it doesn't link:
> > > 
> > > /tmp/ccWcHXtY.o: In function `CleanupDbmLookup': /root/xfstests-dev/src/dbtest.c:304: undefined reference to `dbm_close'
> > > /tmp/ccWcHXtY.o: In function `DoDbmLookup':
> > > /root/xfstests-dev/src/dbtest.c:220: undefined reference to `dbm_fetch'
> > > /root/xfstests-dev/src/dbtest.c:264: undefined reference to `dbm_fetch' /tmp/ccWcHXtY.o: In function `InitDbmLookup':
> > > /root/xfstests-dev/src/dbtest.c:144: undefined reference to `dbm_open'
> > > /root/xfstests-dev/src/dbtest.c:178: undefined reference to `dbm_store'
> > > /root/xfstests-dev/src/dbtest.c:191: undefined reference to `dbm_close'
> > > /root/xfstests-dev/src/dbtest.c:196: undefined reference to `dbm_open'
> > > collect2: ld returned 1 exit status
> > > make[2]: *** [dbtest] Error 1
> > > make[1]: *** [src] Error 2
> > > make: *** [default] Error 2
> > 
> > Where is libgdbm-compat on your system?
> 
> I think we need to do a better job of defining what's required
> for this stuff--building and running.

autoconf is supposed to handle that. If you don't have a critical
package, autoconf will fail and ask you to install it. For
non-critical packages or libraries, it just compiles it out.  The
above error indicates that my autoconf changes are not detecting the
libgdbm_compat library correctly (no surprise, I just hacked a hack
to make it work on my system) so once that is sorted dbtest won't
even be built unless the libraries are installed and detected.

FWIW, Christoph, does the problem go away with a 'make distclean;
make'?

> I know I had trouble the first time I set things up, and now that
> it works I have no recollection of the stuff that I did.  It would
> be good to make it easier for people to get testing going, we
> might get more people actually running them in a wider variety of
> environments.

A real source package for xfstests is the right way to do this, I
think. That way installing the package can pull in the correct
dependencies before you try to build it. There's only so much we
can do if all you do is a git clone to install it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
