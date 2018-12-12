Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbeLLNJZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Dec 2018 08:09:25 -0500
Date: Wed, 12 Dec 2018 08:09:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181212130922.GA23261@bfoster>
References: <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster>
 <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
 <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
 <CADyTPExoZigFSgzrVOEsXNk=ZGRd92AWyM5Lz_z==_xEnJt5cQ@mail.gmail.com>
 <CADyTPEw6DfRO_=RbmaQC2f-2QGNtXKjcmtpcuX9VaNnRXQkH6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEw6DfRO_=RbmaQC2f-2QGNtXKjcmtpcuX9VaNnRXQkH6Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Dec 11, 2018 at 03:20:23PM -0500, Nick Bowler wrote:
> On 12/11/18, Nick Bowler <nbowler@draconx.ca> wrote:
> > On 12/11/18, Brian Foster <bfoster@redhat.com> wrote:
> >> Given that the structure size essentially changes the command value, I'm
> >> kind of curious why we have this ifdeffery in the first place. That
> >> aside, the patch seems reasonable to me at a glance (though some brief
> >> comments around the ifdefs would be nice).
> [...]
> > Current code has the ifdeffery.  Also since it's a syntax error to have
> > multiple case labels with the same value it'd be essential to validate
> > that all supported architectures architectures end up with different
> > values for each XFS_IOC_xyz and the corresponding XFS_IOC_xyz_32.
> 
> Right after I write this, I realize that it's almost certainly
> the case that architectures which _don't_ define BROKEN_X86_ALIGNMENT
> will have matching ioctl numbers between e.g., XFS_IOC_ALLOCSP and
> XFS_IOC_ALLOCSP_32.  Thus the ifdeffery is essential for the above
> syntactic reason.
> 

So the two struct [compat_]xfs_flock64 variants are essentially the same
with the exception of internal alignment padding that leaves a hole
after the first 4 bytes in the 64-bit variant. So on x86_64, these are
essentially two different (sized) structures and ioctl commands. On some
non-broken alignment arch, the packing may be implied and thus these
definitions evaluate down to the same ioctl command. If so, then having
those separate but equivalent value commands in the same switch
statement results in a compilation error. Am I following that correctly?

If so, then it does seem we need an ifdef to exlude those definitions so
long as we follow the one huge switch statement implementation. But is
there anything that fundamentally prevents a multiple switch statement
implementation to avoid such syntax errors?

Note that in the end I don't care too much about whether we have an
ifdef or not. I'm more interested in the most simple and elegant
implementation and it just seemed that trying to dilute the existing
ifdef may push us in the opposite direction (as opposed to something
that for example called into the "native" ioctl and fell back to the _32
variants on failure before returning an error). There may be technical
complications to that or using some form of the ifdef may just end up
being the more simple approach after all.

Brian

> Cheers,
>   Nick
