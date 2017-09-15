Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33653 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdIOEG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 00:06:28 -0400
Received: by mail-pf0-f193.google.com with SMTP id h4so651479pfk.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 21:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bccf58ec-197f-0294-ce94-6d21c98bac2f@sandeen.net>
References: <32b02ec1-de5d-f268-e726-376678c15e17@sandeen.net>
 <CAMKF1spg5jrxPnm8_wwsW=pj90pVjsFxsthfiV3FaJfK+z62FQ@mail.gmail.com>
 <aef2d3ee-8a55-771a-f80d-4b9b261614b2@sandeen.net> <CAMKF1srD3X3241mAgFypoRmw88ycsWRE94PeU7nUZUZ44PJy6w@mail.gmail.com>
 <bccf58ec-197f-0294-ce94-6d21c98bac2f@sandeen.net>
From: Khem Raj <raj.khem@gmail.com>
Date: Thu, 14 Sep 2017 21:05:57 -0700
Message-ID: <CAMKF1sovtJGbMCBGDbp6thKD7iNDKDTKv1JxfQzqDfX7Dm8JNA@mail.gmail.com>
Subject: Re: [ANNOUNCE] xfsdump: master updated to ce8b006
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Felix Janda <felix.janda@posteo.de>

On Thu, Sep 14, 2017 at 8:59 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 9/14/17 10:47 PM, Khem Raj wrote:
>> On Thu, Sep 14, 2017 at 8:40 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>
>>>
>>> On 9/14/17 10:31 PM, Khem Raj wrote:
>>>> On Thu, Sep 14, 2017 at 7:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>>> Hi folks,
>>>>>
>>>>> The xfsdump repository at:
>>>>>
>>>>>         git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
>>>>>
>>>>> has just been updated.
>>>>>
>>>>> This is comprised solely of fixes for building against musl
>>>>> libc; if all is well I'll tag this and push it out as 3.1.8.
>>>>> If those using musl could report success or failure I'd appreciate it.
>>>>>
>>>>
>>>> Just tried. we still need
>>>>
>>>> https://patchwork.kernel.org/patch/9946149/
>>>>
>>>> to get musl builds going.
>>>
>>> Isn't that more a bug in libattr?
>>>
>>
>> yes it is.
>>
>>> Yes, it seems it's been fixed by Felix:
>>>
>>> http://git.savannah.nongnu.org/cgit/attr.git/commit/include/attributes.h?id=37a27b6fd09ecb37097b85e5db74e4f77b80fe0a
>>>
>>
>> attr hasnt been released since this patch was applied so distros may
>> not have this patch yet but I guess distro can be patched.
>
> I'd prefer to have the fix in the right place, if you can handle it.
>

Me too.

> Things like coreutils depend on libattr... doesn't really make sense
> to fix all the consumers upstream to work around a broken library,
> rather than fixing the library itself, IMHO.  I can bug Andreas about
> a release.  ;)
>

that will be helpful in general, last release was over 4 years ago.

> Thanks,
> -Eric
