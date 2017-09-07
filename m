Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33542 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdIGELm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 00:11:42 -0400
Received: by mail-pg0-f68.google.com with SMTP id m9so4438294pgd.0
        for <linux-xfs@vger.kernel.org>; Wed, 06 Sep 2017 21:11:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907024017.GX17782@dastard>
References: <20170907021900.41040-1-raj.khem@gmail.com> <20170907024017.GX17782@dastard>
From: Khem Raj <raj.khem@gmail.com>
Date: Wed, 6 Sep 2017 21:11:11 -0700
Message-ID: <CAMKF1souYmZRaQuBoOv-xR6+S8kj9oHpzZ_rN6V4ecnOr=RuFQ@mail.gmail.com>
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
>> When uuid is enabled then we see linking failures with gold linker e.g.
>>
>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
>> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
>
> That's libxfs, not xfs_spaceman....

yes its libxfs but its linking spaceman, I chopped the error logs too
much I guess.

>
>>
>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> ---
>>  spaceman/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/spaceman/Makefile b/spaceman/Makefile
>> index 95ec3c0..060e0af 100644
>> --- a/spaceman/Makefile
>> +++ b/spaceman/Makefile
>> @@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
>>  HFILES = init.h space.h
>>  CFILES = init.c file.c prealloc.c trim.c
>>
>> -LLDLIBS = $(LIBXCMD)
>> +LLDLIBS = $(LIBXCMD) $(LIBUUID)
>
> And spaceman doesn't link against libxfs, nor does libxcmd or
> spaceman use uuids so I don't see why this fixes a problem with
> libxfs...

I was just following what other binaries were doing, otherwise I agree
libuuid should appear in DT_NEEDED flags in libxfs.so so linkers can
pull it in automatically.

try using

LDFLAGS = "-fuse-ld=gold" if you want to reproduce the problem on your end.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
