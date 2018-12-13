Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f41.google.com ([209.85.167.41]:46118 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeLMEOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 23:14:32 -0500
Received: by mail-lf1-f41.google.com with SMTP id f23so460581lfc.13
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 20:14:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181213035352.GF6311@dastard>
References: <20181210143345.GB8356@bfoster> <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard>
From: Nick Bowler <nbowler@draconx.ca>
Date: Wed, 12 Dec 2018 23:14:28 -0500
Message-ID: <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 2018-12-12, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Dec 11, 2018 at 11:56:33PM -0500, Nick Bowler wrote:
>> OK, xfstests has revealed some trouble with the three "bulkstat" ioctls,
>> since while the xfs_bulkstat structure itself is fine, one of its members
>> is used as a pointer to various structures which are not fine.  This
>> wasn't too hard to fix though.
>
> IIRC, there's bigger problems than you realise here - the bulkstat
> structure has embedded timestamps in them and on x32 struct timeval
> doesn't match either ia32 or x86-64. i.e. on ia32, struct timeval is
> 8 bytes, on x86-64 it is 16 bytes, and in x32 it is 12 bytes.

This is not the case: struct timeval is 16 bytes on x32:

  sizeof (struct timeval): 16
  tv_sec          size:   8 offset:   0
  tv_usec         size:   8 offset:   8

This is the same as what I get on native 64-bit compilations; but
anyway the xfs_bstat structure has xfs_bstime members, with the
following characteristics on x32:

  sizeof (struct xfs_bstime): 16
  tv_sec          size:   8 offset:   0
  tv_nsec         size:   4 offset:   8

which is also the same as native 64-bit (time_t is the same on x32 and
native: 8 bytes with 8 byte alignment).

I manually verified every member of the xfs_bstat structure with sizeof
and offsetof on -mx32 and -m64 compilations to ensure that this structure
matches precisely between the x32 and native 64-bit cases.
