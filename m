Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34624 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeLLE4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 23:56:37 -0500
Received: by mail-lf1-f66.google.com with SMTP id p6so12535852lfc.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 20:56:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181211122701.GA2819@bfoster>
References: <20181210042842.GA16286@draconx.ca> <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
From: Nick Bowler <nbowler@draconx.ca>
Date: Tue, 11 Dec 2018 23:56:33 -0500
Message-ID: <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 12/11/18, Brian Foster <bfoster@redhat.com> wrote:
> On Tue, Dec 11, 2018 at 02:04:48AM -0500, Nick Bowler wrote:
>> Hi Dave,
>>
>> On 2018-12-10, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Dec 10, 2018 at 03:54:47PM -0500, Nick Bowler wrote:
>> >> I can have a go at fixing the FSGEOMETRY ioctl too (and submit it
>> >> properly) if this approach seems reasonable.  Possibly other things
>> >> may be broken too but I haven't hit any other issues yet in my XFS
>> >> adventure.
>> >
>> > We really need to audit all the compat ioctls for this same
>> > problem and fix all of them in one go, not just slap a bandaid on
>> > the messenger and ignore the rest....
>>
>> OK then.  This patch should cover all of them.  However, I wouldn't know
>> where to start with verification of a change like this, since I don't
>> know what these ioctls actually do, but xfs_growfs does seem to work for
>> me now on a test filesystem with this applied.
>>
>
> Given that the structure size essentially changes the command value, I'm
> kind of curious why we have this ifdeffery in the first place. That
> aside, the patch seems reasonable to me at a glance (though some brief
> comments around the ifdefs would be nice).

OK, xfstests has revealed some trouble with the three "bulkstat" ioctls,
since while the xfs_bulkstat structure itself is fine, one of its members
is used as a pointer to various structures which are not fine.  This
wasn't too hard to fix though.

I'll keep testing and hope to get to submitting these properly.

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 001b30605d45..eb6e80c7f2bd 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -241,6 +241,21 @@ xfs_compat_ioc_bulkstat(
 	int			done;
 	int			error;

+	/* These functions and size are used later to handle individual
+	 * entries; x32 is annoying and needs different functions. */
+	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
+	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
+	size_t bs_one_size = sizeof (compat_xfs_bstat_t);
+
+#ifdef CONFIG_X86_X32
+	if (in_x32_syscall()) {
+		/* x32 matches native amd64 bstat and inogrp layout */
+		inumbers_func = xfs_inumbers_fmt;
+		bs_one_func = xfs_bulkstat_one;
+		bs_one_size = sizeof (xfs_bstat_t);
+	}
+#endif
+
 	/* done = 1 if there are more stats to get and if bulkstat */
 	/* should be called again (unused here, but used in dmapi) */

@@ -272,15 +287,15 @@ xfs_compat_ioc_bulkstat(

 	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		error = xfs_inumbers(mp, &inlast, &count,
-				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
+				bulkreq.ubuffer, inumbers_func);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
 		int res;

-		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), NULL, &res);
+		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
+		                    bs_one_size, NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
+			bs_one_func, bs_one_size,
 			bulkreq.ubuffer, &done);
 	} else
 		error = -EINVAL;
