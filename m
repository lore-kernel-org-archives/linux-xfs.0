Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35786 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbeLKUN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 15:13:26 -0500
Received: by mail-lf1-f66.google.com with SMTP id e26so11755232lfc.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 12:13:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181211122701.GA2819@bfoster>
References: <20181210042842.GA16286@draconx.ca> <20181210143345.GB8356@bfoster>
 <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster>
From: Nick Bowler <nbowler@draconx.ca>
Date: Tue, 11 Dec 2018 15:13:23 -0500
Message-ID: <CADyTPExoZigFSgzrVOEsXNk=ZGRd92AWyM5Lz_z==_xEnJt5cQ@mail.gmail.com>
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
>
> Given that the structure size essentially changes the command value, I'm
> kind of curious why we have this ifdeffery in the first place. That
> aside, the patch seems reasonable to me at a glance (though some brief
> comments around the ifdefs would be nice).

OK.  The ifdeffery will mean the "native" ioctls number only get accepted
in the compat case on select architectures.  In principle it could be
removed and both "native" and "compat" ioctl numbers would be accepted
all the time in the compat case (so the possible impact would mainly
be on non-x86 and hopefully would be limited to code size and/or "some
ioctl numbers gave errors before and now don't")

I think it's a separate discussion for whether that's prudent or not.
Current code has the ifdeffery.  Also since it's a syntax error to have
multiple case labels with the same value it'd be essential to validate
that all supported architectures architectures end up with different
values for each XFS_IOC_xyz and the corresponding XFS_IOC_xyz_32.

> Note that verification doesn't just mean checking whether your
> particular configuration works, but also that nothing has broken on
> other potentially affected configurations. For example, I'd suggest that
> this kind of change at least warrants an additional regression test of
> 32-bit (x86) userspace on a 64-bit kernel that has CONFIG_X86_X32
> enabled so we can make sure that we haven't disrupted anything in the
> compat_ioctl() path for the non-x32 case.

Indeed.  I will run xfstests in a vm (thanks for the instructions) and
report before/after results for x32-on-x86_64 and i686-on-x86_64.

Cheers,
  Nick
