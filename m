Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:32911 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbeLNDfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 22:35:13 -0500
Received: by mail-lj1-f170.google.com with SMTP id v1-v6so3707119ljd.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 19:35:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181213213921.GG6311@dastard>
References: <20181210165020.GT24487@magnolia> <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard> <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
 <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com> <20181213213921.GG6311@dastard>
From: Nick Bowler <nbowler@draconx.ca>
Date: Thu, 13 Dec 2018 22:35:09 -0500
Message-ID: <CADyTPEzrtDwSE9F1Ef+0xJDn4Fh15gDZOwz5J-ySorgM2WTjiw@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 12/13/18, Dave Chinner <david@fromorbit.com> wrote:
> That test automates the generation of the test code and output,
> and if it changes from the golden output, then the test fails.
> I'd suggest that a similar thing is done here for /all/ the
> structures we expose in ioctls.
>
> FWIW, pahole can make this easy. e.g you can harvest every ioctl
> structure from xfs_fs.h,

OK, I did just that, by snarfing up the preprocessor output from
#including "xfs/xfs_fs.h" and searching for 'struct'.

The pahole tool was previously unknown to me.  I like it.

One thing I'll note is that it does not appear to be possible to use
pahole to get information about structs that don't have a tag.  The
xfs_fsid_t typedef is such a type.  Fortunately that one does not
look like a problem!

Cheers,
  Nick
