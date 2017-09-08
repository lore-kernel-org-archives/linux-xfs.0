Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36367 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755733AbdIHSYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 14:24:47 -0400
Received: by mail-pf0-f195.google.com with SMTP id f84so1772883pfj.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2017 11:24:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907024017.GX17782@dastard>
References: <20170907021900.41040-1-raj.khem@gmail.com> <20170907024017.GX17782@dastard>
From: Khem Raj <raj.khem@gmail.com>
Date: Fri, 8 Sep 2017 11:24:16 -0700
Message-ID: <CAMKF1srNNkZOYXAoN9MgiyvUoitvYJBEAeE-6XYdyoinrx32Jw@mail.gmail.com>
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave

On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
>> When uuid is enabled then we see linking failures with gold linker e.g.
>>
>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
>> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
>
> That's libxfs, not xfs_spaceman....
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
>

I am building with --disable-static, I wonder if thats not a supported
configuration
for xfsprogs

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
