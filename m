Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40884 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757173AbdIIAdh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 20:33:37 -0400
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
References: <20170907021900.41040-1-raj.khem@gmail.com>
 <20170907024017.GX17782@dastard>
 <CAMKF1srNNkZOYXAoN9MgiyvUoitvYJBEAeE-6XYdyoinrx32Jw@mail.gmail.com>
 <20170908223649.GF17782@dastard>
 <CAMKF1sqY3F=OG5imx=1bmBNigGnLywT4WqaQUTUMtf8XJe=PGw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ea036e80-330e-dbe7-2245-63fa7b620bcb@sandeen.net>
Date: Fri, 8 Sep 2017 19:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAMKF1sqY3F=OG5imx=1bmBNigGnLywT4WqaQUTUMtf8XJe=PGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 9/8/17 6:22 PM, Khem Raj wrote:
> On Fri, Sep 8, 2017 at 3:36 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Fri, Sep 08, 2017 at 11:24:16AM -0700, Khem Raj wrote:
>>> Hi Dave
>>>
>>> On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>> On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
>>>>> When uuid is enabled then we see linking failures with gold linker e.g.
>>>>>
>>>>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
>>>>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
>>>>> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
>>>>
>>>> That's libxfs, not xfs_spaceman....
>>>>
>>>>>
>>>>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>>>>> ---
>>>>>  spaceman/Makefile | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/spaceman/Makefile b/spaceman/Makefile
>>>>> index 95ec3c0..060e0af 100644
>>>>> --- a/spaceman/Makefile
>>>>> +++ b/spaceman/Makefile
>>>>> @@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
>>>>>  HFILES = init.h space.h
>>>>>  CFILES = init.c file.c prealloc.c trim.c
>>>>>
>>>>> -LLDLIBS = $(LIBXCMD)
>>>>> +LLDLIBS = $(LIBXCMD) $(LIBUUID)
>>>>
>>>> And spaceman doesn't link against libxfs, nor does libxcmd or
>>>> spaceman use uuids so I don't see why this fixes a problem with
>>>> libxfs...
>>>>
>>>
>>> I am building with --disable-static, I wonder if thats not a supported
>>> configuration
>>> for xfsprogs
>>
>> For what reason?
>>
> 
> this is the distro policy under which I am trying to compile. No other reason.

which distro has this policy?

There are certainly policies against static linking with /external/
libraries, because if libfoo has an exploit, you'd have to find
every static linker and fix it, rather than just libfoo.

But I can't imagine a policy that says a project cannot statically
link with its own /internal/ libraries which are never distributed
separately.

-Eric

