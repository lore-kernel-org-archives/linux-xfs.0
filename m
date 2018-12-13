Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26130 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbeLMDzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 22:55:04 -0500
Date: Thu, 13 Dec 2018 14:53:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181213035352.GF6311@dastard>
References: <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster>
 <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
 <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
 <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Dec 11, 2018 at 11:56:33PM -0500, Nick Bowler wrote:
> On 12/11/18, Brian Foster <bfoster@redhat.com> wrote:
> > On Tue, Dec 11, 2018 at 02:04:48AM -0500, Nick Bowler wrote:
> >> Hi Dave,
> >>
> >> On 2018-12-10, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Mon, Dec 10, 2018 at 03:54:47PM -0500, Nick Bowler wrote:
> >> >> I can have a go at fixing the FSGEOMETRY ioctl too (and submit it
> >> >> properly) if this approach seems reasonable.  Possibly other things
> >> >> may be broken too but I haven't hit any other issues yet in my XFS
> >> >> adventure.
> >> >
> >> > We really need to audit all the compat ioctls for this same
> >> > problem and fix all of them in one go, not just slap a bandaid on
> >> > the messenger and ignore the rest....
> >>
> >> OK then.  This patch should cover all of them.  However, I wouldn't know
> >> where to start with verification of a change like this, since I don't
> >> know what these ioctls actually do, but xfs_growfs does seem to work for
> >> me now on a test filesystem with this applied.
> >>
> >
> > Given that the structure size essentially changes the command value, I'm
> > kind of curious why we have this ifdeffery in the first place. That
> > aside, the patch seems reasonable to me at a glance (though some brief
> > comments around the ifdefs would be nice).
> 
> OK, xfstests has revealed some trouble with the three "bulkstat" ioctls,
> since while the xfs_bulkstat structure itself is fine, one of its members
> is used as a pointer to various structures which are not fine.  This
> wasn't too hard to fix though.

IIRC, there's bigger problems than you realise here - the bulkstat
structure has embedded timestamps in them and on x32 struct timeval
doesn't match either ia32 or x86-64. i.e. on ia32, struct timeval is
8 bytes, on x86-64 it is 16 bytes, and in x32 it is 12 bytes.

IOWs, using the x86-64 handlers for bulkstat is wrong, as is using
the compat handlers. That's one of the reasons why x32 is such a
Charlie Foxtrot when it comes to compat handlers - we basically have
to audit ioctl structures one by one with pahole to determine which
arch version they *may* be compatible with.

And then there is testing that we get identical output from all
three versions for each ioctl.

Right now, I'd much prefer we simply put this at the start of
xfs_fs_fill_super():

#ifdef CONFIG_X86_X32
	xfs_warn("XFS not supported on x32 architectures")
	return -ENOSYS;
#endif

Or, alternatively, tag it as EXPERIMENTAL and "use at your own
risk".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
