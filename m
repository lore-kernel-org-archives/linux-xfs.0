Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43904 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390726AbeIVBCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Sep 2018 21:02:46 -0400
Subject: Re: [PATCH xfsprogs] build: don't assume $BUILD_CC has fsmap.h just
 because $CC does
References: <20180906183529.117251-1-briannorris@chromium.org>
 <30774ff1-57c1-c9f4-4ec3-31c177b11489@sandeen.net>
 <20180906225534.GA114388@ban.mtv.corp.google.com>
 <20180921183700.GA203751@ban.mtv.corp.google.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1daeaef0-af23-0d2d-cc30-e6f3ef12205c@sandeen.net>
Date: Fri, 21 Sep 2018 14:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <20180921183700.GA203751@ban.mtv.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Norris <briannorris@chromium.org>
Cc: linux-xfs@vger.kernel.org

On 9/21/18 1:37 PM, Brian Norris wrote:
> On Thu, Sep 06, 2018 at 03:55:34PM -0700, Brian Norris wrote:
>> On Thu, Sep 06, 2018 at 05:33:56PM -0500, Eric Sandeen wrote:
>>> I was trying to just get the selftest to build with a custom set of
>>> userspace headers, like the patch below, so we don't have to pull in all
>>> the various and sundry xfs headers & dependencies.  Not sure what the better
>>> approach is here ...
>>
>> I think an ideal goal is still to remove all usage of HAVE_* from
>> anything that gets built with $BUILD_CC. I guess that's just
>> crc32selftest? So even if you do that, it would still be good to do
>> something like my patch. (Maybe even more than that -- remove the BLKID,
>> FSETXATTR, etc., flags from $BUILD_CFLAGS.)
>>
>> But your patch does work for me. (Well, I had to port it back a little,
>> since my cross-compilation environment isn't building off the
>> development tip.)
> 
> Ping? Should I send a new version that combines our patches?
> 
> Regards,
> Brian
> 

Hi Brian - I'm not ignoring your patch, I've just been working on getting
libxfs synced for 4.19 before merging anything else - this is usually how
I work when patches come in near the beginning of a release cycle.
I'll revisit your patch & reach out to you if I have other questions or
suggestions when I get there, ok?  Sorry for the delay.

Thanks,
-Eric
