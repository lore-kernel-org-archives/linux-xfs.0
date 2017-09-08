Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756303AbdIHTPm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 15:15:42 -0400
Subject: Re: [PATCH] spaceman: Add missing link to libuuid
References: <20170907021900.41040-1-raj.khem@gmail.com>
 <20170907024017.GX17782@dastard>
 <CAMKF1srNNkZOYXAoN9MgiyvUoitvYJBEAeE-6XYdyoinrx32Jw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3d43a83a-1b2b-f2de-e610-4a8bd3d3a188@sandeen.net>
Date: Fri, 8 Sep 2017 14:15:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAMKF1srNNkZOYXAoN9MgiyvUoitvYJBEAeE-6XYdyoinrx32Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khem Raj <raj.khem@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 9/8/17 1:24 PM, Khem Raj wrote:
> Hi Dave
> 
> On Wed, Sep 6, 2017 at 7:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Wed, Sep 06, 2017 at 07:19:00PM -0700, Khem Raj wrote:
>>> When uuid is enabled then we see linking failures with gold linker e.g.
>>>
>>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_compare'
>>> libxfs/.libs/libxfs.so: error: undefined reference to 'uuid_copy'
>>> clang-5.0: error: linker command failed with exit code 1 (use -v to see invocation)
>>
>> That's libxfs, not xfs_spaceman....
>>
>>>
>>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>>> ---
>>>  spaceman/Makefile | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/spaceman/Makefile b/spaceman/Makefile
>>> index 95ec3c0..060e0af 100644
>>> --- a/spaceman/Makefile
>>> +++ b/spaceman/Makefile
>>> @@ -9,7 +9,7 @@ LTCOMMAND = xfs_spaceman
>>>  HFILES = init.h space.h
>>>  CFILES = init.c file.c prealloc.c trim.c
>>>
>>> -LLDLIBS = $(LIBXCMD)
>>> +LLDLIBS = $(LIBXCMD) $(LIBUUID)
>>
>> And spaceman doesn't link against libxfs, nor does libxcmd or
>> spaceman use uuids so I don't see why this fixes a problem with
>> libxfs...
>>
> 
> I am building with --disable-static, I wonder if thats not a supported
> configuration
> for xfsprogs

Still doesn't make spaceman link against libxfs or use uuids ;)

I guess I'd suggest starting w/ x86 and a standard toolchain, make
--disable-static work for you there (I see that it does need some
fixups), then try things w/ the alternate toolchain and see
if more work is needed.

-Eric
