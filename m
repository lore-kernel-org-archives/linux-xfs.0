Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45802 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbeLKHEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 02:04:52 -0500
Received: by mail-lf1-f67.google.com with SMTP id b20so9909531lfa.12
        for <linux-xfs@vger.kernel.org>; Mon, 10 Dec 2018 23:04:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181210214115.GC6311@dastard>
References: <20181210042842.GA16286@draconx.ca> <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard>
From: Nick Bowler <nbowler@draconx.ca>
Date: Tue, 11 Dec 2018 02:04:48 -0500
Message-ID: <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hi Dave,

On 2018-12-10, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 10, 2018 at 03:54:47PM -0500, Nick Bowler wrote:
>> I can have a go at fixing the FSGEOMETRY ioctl too (and submit it
>> properly) if this approach seems reasonable.  Possibly other things
>> may be broken too but I haven't hit any other issues yet in my XFS
>> adventure.
>
> We really need to audit all the compat ioctls for this same
> problem and fix all of them in one go, not just slap a bandaid on
> the messenger and ignore the rest....

OK then.  This patch should cover all of them.  However, I wouldn't know
where to start with verification of a change like this, since I don't
know what these ioctls actually do, but xfs_growfs does seem to work for
me now on a test filesystem with this applied.

I didn't look at the set of ioctls marked 'No size or alignment issue on
any arch' since those should presumably all be fine.

I manually inspected the structures used by everything else.  On all the
cases under BROKEN_X86_ALIGNMENT, the structures differ due to 64-bit
integer alignment reasons alone.  In this case, x32 will match amd64
exactly, including the calculated ioctl number (which is different from
the ia32 ioctl number since the structure sizes change), so we just need
to emit BOTH sets of cases to handle this correctly.

The odd one out is XFS_IOC_SWAPEXT.  This is a rather big structure but it
appears to consist only of integers of various sizes, with some time_t in
there.  That should still all exactly match between x32 and amd64, and the
structure size is different from ia32 so we can add a case that calls the
native version.

All remaining ioctls use structures that consist exclusively of 32-bit
integers and one or more pointers (or, recursively, structures containing
only such members).  That means x32 should match ia32 exactly for these,
including the calculated ioctl number, so the compat versions should be
fine as-is for these and no change is required.

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index fba115f4103a..dd77f20f42ec 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
 	case FS_IOC_GETFSMAP:
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_file_ioctl(filp, cmd, p);
-#ifndef BROKEN_X86_ALIGNMENT
+#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
@@ -561,8 +561,12 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSRT:
 	case XFS_IOC_ZERO_RANGE:
+#ifdef CONFIG_X86_X32
+	case XFS_IOC_SWAPEXT:
+#endif
 		return xfs_file_ioctl(filp, cmd, p);
-#else
+#endif
+#if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
