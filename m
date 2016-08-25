Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ABD7D7CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:02:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB9D330405F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 15:02:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sP5qzM6eciDpJfEi for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2016 15:02:25 -0700 (PDT)
Date: Fri, 26 Aug 2016 08:01:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160825220128.GE19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160825080402.GA28747@infradead.org>
	<20160824204746.GA25162@nyan>
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
To: Felix Janda <felix.janda@posteo.de>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 10:47:46PM +0200, Felix Janda wrote:
> Dave Chinner wrote:
> > So, the patches are fine, and everything works. Problem is, it
> > screws up xfstests because it changes all the error messages
> > that are output to stderr and captured by the test harness.
> > There are quite a few tests that this causes failures for,
> > and because it's stderr, it's not as simple as just adding a new
> > filter to do 'sed -e "s/^\(.*\)64\(: .*$\)/\1\2/"' on stderr.
> 
> Thanks for testing!
> 
> I can rework the patches to leave stderr unchanged. I guess that this
> is preferable as opposed to updating the output expected by xfstests
> since xfstests should be usable with both old and new xfsprogs.

Well, normally the thing that needs to change is xfstests. We have
to handle all sorts of issues like this (core-utils people seem to
change error messge format at least once a year). it just more
complex for xfs_io because we've got to filter both stdout and
stderr separately and not cross the streams.

> > Further, errors returned change, which further screws up xfstests.
> > e.g. old code gives EFBIG when we try to use offsets beyond the
> > supported range, this patchset returns EINVAL.  That further
> > complicates any sort of error filtering we'll need to do.
> 
> I am very surprised that something apart from the error messages has
> changed. I would be interested to know on what architecture and for
> which test(s) (where) this happened, if you still remember.

Turns out this was a false detection - the test captures EINVAL
error message and turns it into a EFBIG error message, probably
because at one stage it was EFBIG. So the errno didn't change, just
the error filter didn't match and convert....

On Thu, Aug 25, 2016 at 01:04:02AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 24, 2016 at 10:47:46PM +0200, Felix Janda wrote:
> > > screws up xfstests because it changes all the error messages
> > > that are output to stderr and captured by the test harness.
> > > There are quite a few tests that this causes failures for,
> > > and because it's stderr, it's not as simple as just adding a new
> > > filter to do 'sed -e "s/^\(.*\)64\(: .*$\)/\1\2/"' on stderr.
> > 
> > Thanks for testing!
> > 
> > I can rework the patches to leave stderr unchanged. I guess that this
> > is preferable as opposed to updating the output expected by xfstests
> > since xfstests should be usable with both old and new xfsprogs.
> 
> I would prefer to change the output if we can find a good way to
> filter it.  I suspect the issues are things like perror lines
> which would look odd if we leave the 64 back in.

right, it's pwrite64 -> pwrite that is the main issue. And yes, I
would prefer to filter it, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
