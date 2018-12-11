Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbeLKM1F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Dec 2018 07:27:05 -0500
Date: Tue, 11 Dec 2018 07:27:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181211122701.GA2819@bfoster>
References: <20181210042842.GA16286@draconx.ca>
 <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster>
 <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
 <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Dec 11, 2018 at 02:04:48AM -0500, Nick Bowler wrote:
> Hi Dave,
> 
> On 2018-12-10, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Dec 10, 2018 at 03:54:47PM -0500, Nick Bowler wrote:
> >> I can have a go at fixing the FSGEOMETRY ioctl too (and submit it
> >> properly) if this approach seems reasonable.  Possibly other things
> >> may be broken too but I haven't hit any other issues yet in my XFS
> >> adventure.
> >
> > We really need to audit all the compat ioctls for this same
> > problem and fix all of them in one go, not just slap a bandaid on
> > the messenger and ignore the rest....
> 
> OK then.  This patch should cover all of them.  However, I wouldn't know
> where to start with verification of a change like this, since I don't
> know what these ioctls actually do, but xfs_growfs does seem to work for
> me now on a test filesystem with this applied.
> 

Given that the structure size essentially changes the command value, I'm
kind of curious why we have this ifdeffery in the first place. That
aside, the patch seems reasonable to me at a glance (though some brief
comments around the ifdefs would be nice).

Note that verification doesn't just mean checking whether your
particular configuration works, but also that nothing has broken on
other potentially affected configurations. For example, I'd suggest that
this kind of change at least warrants an additional regression test of
32-bit (x86) userspace on a 64-bit kernel that has CONFIG_X86_X32
enabled so we can make sure that we haven't disrupted anything in the
compat_ioctl() path for the non-x32 case.

As for test mechanism, look at the fstests suite:

  https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

It contains a suite of tests that all fs devs run against most changes
before they are posted/committed to the upstream kernel. Within that
tool, see the xfstests-dev/ltp/fsstress and xfstests-dev/ltp/fsx test
utilities. Each of those utils basically runs a stress test that
consists of all supported operations against a target directory. For
example, the set of operations noted by fsstress is:

                    the valid operation names are:
                        afsync allocsp aread attr_remove attr_set awrite 
                        bulkstat bulkstat1 chown clonerange copyrange 
                        creat deduperange dread dwrite fallocate 
                        fdatasync fiemap freesp fsync getattr getdents 
                        link mkdir mknod mread mwrite punch zero collapse 
                        insert read readlink readv rename resvsp rmdir 
                        setattr setxattr stat symlink sync truncate 
                        unlink unresvsp write writev 

... which covers several of these ioctls (block allocation, bulkstat,
etc.). The broader fstests suite has tests to cover things like growfs,
etc., and will also run the aforementioned tools, but you can run
them directly for quicker verification during development.

So if you'd like to propose this change for upstream inclusion, I'd
suggest to take advantage of those tools to test your change and then
run the xfstests suite (re: the auto test group) against the targeted
configuration along with one or more affected configurations.

Brian

> I didn't look at the set of ioctls marked 'No size or alignment issue on
> any arch' since those should presumably all be fine.
> 
> I manually inspected the structures used by everything else.  On all the
> cases under BROKEN_X86_ALIGNMENT, the structures differ due to 64-bit
> integer alignment reasons alone.  In this case, x32 will match amd64
> exactly, including the calculated ioctl number (which is different from
> the ia32 ioctl number since the structure sizes change), so we just need
> to emit BOTH sets of cases to handle this correctly.
> 
> The odd one out is XFS_IOC_SWAPEXT.  This is a rather big structure but it
> appears to consist only of integers of various sizes, with some time_t in
> there.  That should still all exactly match between x32 and amd64, and the
> structure size is different from ia32 so we can add a case that calls the
> native version.
> 
> All remaining ioctls use structures that consist exclusively of 32-bit
> integers and one or more pointers (or, recursively, structures containing
> only such members).  That means x32 should match ia32 exactly for these,
> including the calculated ioctl number, so the compat versions should be
> fine as-is for these and no change is required.
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index fba115f4103a..dd77f20f42ec 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
>  	case FS_IOC_GETFSMAP:
>  	case XFS_IOC_SCRUB_METADATA:
>  		return xfs_file_ioctl(filp, cmd, p);
> -#ifndef BROKEN_X86_ALIGNMENT
> +#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
>  	/* These are handled fine if no alignment issues */
>  	case XFS_IOC_ALLOCSP:
>  	case XFS_IOC_FREESP:
> @@ -561,8 +561,12 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_FSGROWFSDATA:
>  	case XFS_IOC_FSGROWFSRT:
>  	case XFS_IOC_ZERO_RANGE:
> +#ifdef CONFIG_X86_X32
> +	case XFS_IOC_SWAPEXT:
> +#endif
>  		return xfs_file_ioctl(filp, cmd, p);
> -#else
> +#endif
> +#if defined(BROKEN_X86_ALIGNMENT)
>  	case XFS_IOC_ALLOCSP_32:
>  	case XFS_IOC_FREESP_32:
>  	case XFS_IOC_ALLOCSP64_32:
