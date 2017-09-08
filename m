Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35722 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756895AbdIHXXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 19:23:25 -0400
Received: by mail-pg0-f68.google.com with SMTP id q68so1901410pgq.2
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2017 16:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170908223649.GF17782@dastard>
References: <20170907021900.41040-1-raj.khem@gmail.com> <20170907024017.GX17782@dastard>
 <CAMKF1srNNkZOYXAoN9MgiyvUoitvYJBEAeE-6XYdyoinrx32Jw@mail.gmail.com> <20170908223649.GF17782@dastard>
From: Khem Raj <raj.khem@gmail.com>
Date: Fri, 8 Sep 2017 16:22:54 -0700
Message-ID: <CAMKF1sqY3F=OG5imx=1bmBNigGnLywT4WqaQUTUMtf8XJe=PGw@mail.gmail.com>
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 8, 2017 at 3:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Sep 08, 2017 at 11:24:16AM -0700, Khem Raj wrote:
>> Hi Dave
>>
>> On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
>> >> When uuid is enabled then we see linking failures with gold linker e.g.
>> >>
>> >> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
>> >> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
>> >> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
>> >
>> > That's libxfs, not xfs_spaceman....
>> >
>> >>
>> >> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> >> ---
>> >>  spaceman/Makefile | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/spaceman/Makefile b/spaceman/Makefile
>> >> index 95ec3c0..060e0af 100644
>> >> --- a/spaceman/Makefile
>> >> +++ b/spaceman/Makefile
>> >> @@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
>> >>  HFILES = init.h space.h
>> >>  CFILES = init.c file.c prealloc.c trim.c
>> >>
>> >> -LLDLIBS = $(LIBXCMD)
>> >> +LLDLIBS = $(LIBXCMD) $(LIBUUID)
>> >
>> > And spaceman doesn't link against libxfs, nor does libxcmd or
>> > spaceman use uuids so I don't see why this fixes a problem with
>> > libxfs...
>> >
>>
>> I am building with --disable-static, I wonder if thats not a supported
>> configuration
>> for xfsprogs
>
> For what reason?
>

this is the distro policy under which I am trying to compile. No other reason.

> xfsprogs links it's internal libraries statically while it links to
> system libraries dynamically. We do not expose internal libraries
> like libxfs and libxcmd outside the build environment, and so
> dynamic linking of them doesn't make any sense because they won't be
> installed on any system you ship the binaries to....
>

Thats what I needed to know. I will remove --disable-static and both patches
I sent I no more needed.


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
