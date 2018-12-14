Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34305 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728130AbeLNBoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 20:44:02 -0500
Date: Fri, 14 Dec 2018 12:43:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181214014358.GI6311@dastard>
References: <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
 <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
 <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard>
 <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
 <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com>
 <20181213213921.GG6311@dastard>
 <CADyTPExGkEzRvpcWevWGFDJkyvHe4KfZG4gOkDJcoWiNKDPJhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPExGkEzRvpcWevWGFDJkyvHe4KfZG4gOkDJcoWiNKDPJhA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Dec 13, 2018 at 04:53:56PM -0500, Nick Bowler wrote:
> On 2018-12-13, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Dec 12, 2018 at 11:49:36PM -0500, Nick Bowler wrote:
> >> To expand on this, for each structure which my RFC patchset feeds up to
> >> the native handler, I first checked them by manual inspection and then
> >> double checked using the following program; we can compile with both
> >> -mx32 and -m64 and check that the output is identical.
> >
> > So, turn that into an xfstest so that it is always run, diffs the
> > output between compat/native depending on which one is used complete
> > with guards that break the test when we add a new ioctl. We already
> > we have a test that is for explicitly checking that structures on disk
> > are the same for 32/64 bit architectures: tests/xfs/122
> [...]
> > Then we'll have tests that will fail if we ever change an ioctl or
> > add a new one and don't add it to the test. That guarantees we won't
> > ever forget about this....
> 
> OK, I will give it a shot to implement such a test.  A possible issue is
> that developers might not have a working x32 build or runtime environment
> so the test might not get run a lot.

We generally test for the <thing> being supported first and only run
the test if it is supported. for x86-64 systems, we should at least
already support -m32/-m64, so we'll at least get coverage on that,
and the reminder that...

> But hopefully people adding brand
> new ioctls don't introduce brand new compat problems; one can dream, right?

... introducing new ioctls need thought to ensure we don't introduce
new compat problems :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
