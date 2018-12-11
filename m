Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f47.google.com ([209.85.167.47]:35761 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeLKUU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 15:20:26 -0500
Received: by mail-lf1-f47.google.com with SMTP id e26so11770378lfc.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 12:20:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADyTPExoZigFSgzrVOEsXNk=ZGRd92AWyM5Lz_z==_xEnJt5cQ@mail.gmail.com>
References: <20181210042842.GA16286@draconx.ca> <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPExoZigFSgzrVOEsXNk=ZGRd92AWyM5Lz_z==_xEnJt5cQ@mail.gmail.com>
From: Nick Bowler <nbowler@draconx.ca>
Date: Tue, 11 Dec 2018 15:20:23 -0500
Message-ID: <CADyTPEw6DfRO_=RbmaQC2f-2QGNtXKjcmtpcuX9VaNnRXQkH6Q@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 12/11/18, Nick Bowler <nbowler@draconx.ca> wrote:
> On 12/11/18, Brian Foster <bfoster@redhat.com> wrote:
>> Given that the structure size essentially changes the command value, I'm
>> kind of curious why we have this ifdeffery in the first place. That
>> aside, the patch seems reasonable to me at a glance (though some brief
>> comments around the ifdefs would be nice).
[...]
> Current code has the ifdeffery.  Also since it's a syntax error to have
> multiple case labels with the same value it'd be essential to validate
> that all supported architectures architectures end up with different
> values for each XFS_IOC_xyz and the corresponding XFS_IOC_xyz_32.

Right after I write this, I realize that it's almost certainly
the case that architectures which _don't_ define BROKEN_X86_ALIGNMENT
will have matching ioctl numbers between e.g., XFS_IOC_ALLOCSP and
XFS_IOC_ALLOCSP_32.  Thus the ifdeffery is essential for the above
syntactic reason.

Cheers,
  Nick
