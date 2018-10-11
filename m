Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbeJLGGG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Oct 2018 02:06:06 -0400
Subject: Re: [PATCH] xfsprogs: don't include all xfs headers just for crc32
References: <e1259a8b-b5aa-cfa2-aeab-13d63757d7a5@redhat.com>
 <20181011195859.GA114854@rodete-desktop-imager.corp.google.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b6ee7861-3bf0-7192-d26e-5d57bcb10d19@sandeen.net>
Date: Thu, 11 Oct 2018 17:36:36 -0500
MIME-Version: 1.0
In-Reply-To: <20181011195859.GA114854@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Norris <briannorris@chromium.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 10/11/18 2:59 PM, Brian Norris wrote:
> On Wed, Oct 10, 2018 at 03:55:32PM -0500, Eric Sandeen wrote:
>> Brian Norris reported that "The $BUILD_CC toolchain might have an
>> older set of Linux headers than the $CC toolchain. It's generally
>> unsafe to try to build both with the same definitions, but in
>> particular, this one can cause compilation failures in the local
>> crc32selftest build: [failure to find fsmap.h]"
>>
>> It seems like the most straightforward thing to do here is include
>> a specific set of system headers, instead of pulling in the whole
>> xfs.h header chain which has multiple tests and definitions in
>> place for headers that may or may not be there during the build.
>>
>> Reported-by: Brian Norris <briannorris@chromium.org>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Brian, here's try #3, does this also work for you?
> 
> Tested-by: Brian Norris <briannorris@chromium.org>
> 
> This still leaves $BUILD_CFLAGS with bad entries, but as long as they
> don't get used anywhere that matters, it'll be OK.

Thanks.  At this point I think you have a better grasp of what all the
$FOO_FLAGS do than I do ;)  It may be  to keep things sorted
and separate, but it also seemed useful to get a giant tangle of
xfs header out of a non-xfs library file.

I'm also on the fence about whether cross-compiling the self-check
really even gains us much, given that it may be built or optimized
completely differently from the code on the target arch ...

-Eric
