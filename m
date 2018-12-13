Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40860 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbeLMVyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 16:54:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18-v6so3137018lji.7
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 13:53:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181213213921.GG6311@dastard>
References: <20181210165020.GT24487@magnolia> <20181210174627.GD8356@bfoster>
 <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard> <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
 <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com> <20181213213921.GG6311@dastard>
From: Nick Bowler <nbowler@draconx.ca>
Date: Thu, 13 Dec 2018 16:53:56 -0500
Message-ID: <CADyTPExGkEzRvpcWevWGFDJkyvHe4KfZG4gOkDJcoWiNKDPJhA@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 2018-12-13, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Dec 12, 2018 at 11:49:36PM -0500, Nick Bowler wrote:
>> To expand on this, for each structure which my RFC patchset feeds up to
>> the native handler, I first checked them by manual inspection and then
>> double checked using the following program; we can compile with both
>> -mx32 and -m64 and check that the output is identical.
>
> So, turn that into an xfstest so that it is always run, diffs the
> output between compat/native depending on which one is used complete
> with guards that break the test when we add a new ioctl. We already
> we have a test that is for explicitly checking that structures on disk
> are the same for 32/64 bit architectures: tests/xfs/122
[...]
> Then we'll have tests that will fail if we ever change an ioctl or
> add a new one and don't add it to the test. That guarantees we won't
> ever forget about this....

OK, I will give it a shot to implement such a test.  A possible issue is
that developers might not have a working x32 build or runtime environment
so the test might not get run a lot.  But hopefully people adding brand
new ioctls don't introduce brand new compat problems; one can dream, right?

Thanks,
  Nick
