Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:25636 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbeLMVjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 16:39:25 -0500
Date: Fri, 14 Dec 2018 08:39:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181213213921.GG6311@dastard>
References: <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
 <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
 <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard>
 <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
 <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Dec 12, 2018 at 11:49:36PM -0500, Nick Bowler wrote:
> On 2018-12-12, Nick Bowler <nbowler@draconx.ca> wrote:
> > On 2018-12-12, Dave Chinner <david@fromorbit.com> wrote:
> >> On Tue, Dec 11, 2018 at 11:56:33PM -0500, Nick Bowler wrote:
> >>> OK, xfstests has revealed some trouble with the three "bulkstat" ioctls,
> >>> since while the xfs_bulkstat structure itself is fine, one of its
> >>> members
> >>> is used as a pointer to various structures which are not fine.  This
> >>> wasn't too hard to fix though.
> >>
> >> IIRC, there's bigger problems than you realise here - the bulkstat
> >> structure has embedded timestamps in them and on x32 struct timeval
> >> doesn't match either ia32 or x86-64. i.e. on ia32, struct timeval is
> >> 8 bytes, on x86-64 it is 16 bytes, and in x32 it is 12 bytes.
> >
> > This is not the case: struct timeval is 16 bytes on x32:
> >
> >   sizeof (struct timeval): 16
> >   tv_sec          size:   8 offset:   0
> >   tv_usec         size:   8 offset:   8

I was just quoting the kernel time subsystem maintainer who
said that these structures had problems with size and packing.

> >
> > This is the same as what I get on native 64-bit compilations; but
> > anyway the xfs_bstat structure has xfs_bstime members, with the
> > following characteristics on x32:
> >
> >   sizeof (struct xfs_bstime): 16
> >   tv_sec          size:   8 offset:   0
> >   tv_nsec         size:   4 offset:   8
> >
> > which is also the same as native 64-bit (time_t is the same on x32 and
> > native: 8 bytes with 8 byte alignment).
> >
> > I manually verified every member of the xfs_bstat structure with sizeof
> > and offsetof on -mx32 and -m64 compilations to ensure that this structure
> > matches precisely between the x32 and native 64-bit cases.
> 
> To expand on this, for each structure which my RFC patchset feeds up to
> the native handler, I first checked them by manual inspection and then
> double checked using the following program; we can compile with both
> -mx32 and -m64 and check that the output is identical.

So, turn that into an xfstest so that it is always run, diffs the
output between compat/native depending on which one is used complete
with guards that break the test when we add a new ioctl. We already
we have a test that is for explicitly checking that structures on disk
are the same for 32/64 bit architectures: tests/xfs/122

That test automates the generation of the test code and output,
and if it changes from the golden output, then the test fails.
I'd suggest that a similar thing is done here for /all/ the
structures we expose in ioctls.

FWIW, pahole can make this easy. e.g you can harvest every ioctl
structure from xfs_fs.h, write them into a file like so:

$ cat t.c
#include <xfs/xfs.h>

/* these should be the same for x32/x86-64, but not i386 */
int main(int argc, char *argv[])
{
	struct xfs_bstat bs = {0};
	struct xfs_fsop_geom_v1 geo1 = {0};
	struct xfs_fsop_geom geo = {0};
	struct xfs_growfs_data gd = {0};
	struct xfs_growfs_rt gr = {0};
	struct xfs_flock64 fl = {0};
	struct xfs_inogrp ig = {0};
	struct xfs_swapext se = {0};

	return 0;
}

And then compile and dump the structure layouts like so:
$ gcc -m64 -gdwarf-2 t.c -c; pahole t.o > t.x86-64
$ gcc -mx32 -gdwarf-2 t.c -c; pahole t.o > t.x32
$ gcc -m32 -gdwarf-2 t.c -c; pahole t.o > t.i386

Then we'll have tests that will fail if we ever change an ioctl or
add a new one and don't add it to the test. That guarantees we won't
ever forget about this....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
