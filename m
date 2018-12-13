Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32959 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbeLMAWC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 19:22:02 -0500
Received: by mail-lf1-f67.google.com with SMTP id i26so210840lfc.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 16:22:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181212130922.GA23261@bfoster>
References: <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPExoZigFSgzrVOEsXNk=ZGRd92AWyM5Lz_z==_xEnJt5cQ@mail.gmail.com>
 <CADyTPEw6DfRO_=RbmaQC2f-2QGNtXKjcmtpcuX9VaNnRXQkH6Q@mail.gmail.com> <20181212130922.GA23261@bfoster>
From: Nick Bowler <nbowler@draconx.ca>
Date: Wed, 12 Dec 2018 19:21:58 -0500
Message-ID: <CADyTPEwXO3OvrvP3wPNT2RGhi4FgkbA75=Dhg6u1uh6vmra8Zg@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 2018-12-12, Brian Foster <bfoster@redhat.com> wrote:
> On Tue, Dec 11, 2018 at 03:20:23PM -0500, Nick Bowler wrote:
>> Right after I write this, I realize that it's almost certainly
>> the case that architectures which _don't_ define BROKEN_X86_ALIGNMENT
>> will have matching ioctl numbers between e.g., XFS_IOC_ALLOCSP and
>> XFS_IOC_ALLOCSP_32.
[...]
> So the two struct [compat_]xfs_flock64 variants are essentially the same
> with the exception of internal alignment padding that leaves a hole
> after the first 4 bytes in the 64-bit variant. So on x86_64, these are
> essentially two different (sized) structures and ioctl commands. On some
> non-broken alignment arch, the packing may be implied and thus these
> definitions evaluate down to the same ioctl command. If so, then having
> those separate but equivalent value commands in the same switch
> statement results in a compilation error. Am I following that correctly?
>
> If so, then it does seem we need an ifdef to exlude those definitions so
> long as we follow the one huge switch statement implementation. But is
> there anything that fundamentally prevents a multiple switch statement
> implementation to avoid such syntax errors?

I think nothing fundamentally prevents this approach and it is an option.

The only point I see is that, without the configuration ifdefs,
the impact of the change is expanded; there are (presumably benign)
functional changes on more architectures, most of which I don't have
the ability to test.  Making it dependent on the arch configuration
means nothing should change anywhere except on amd64 kernels that have
x32 binary support turned on.

> Note that in the end I don't care too much about whether we have an
> ifdef or not. I'm more interested in the most simple and elegant
> implementation and it just seemed that trying to dilute the existing
> ifdef may push us in the opposite direction (as opposed to something
> that for example called into the "native" ioctl and fell back to the _32
> variants on failure before returning an error). There may be technical
> complications to that or using some form of the ifdef may just end up
> being the more simple approach after all.

OK, since I have some test results I'll submit the current one for
RFC; afterwards I'll try to follow up with a less ifdeffy variant for
comparison purposes, then we can decide which version is better. :)

Cheers,
  Nick
