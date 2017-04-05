Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36803 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755329AbdDEOYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 10:24:40 -0400
Received: by mail-ua0-f179.google.com with SMTP id 100so8939102uaj.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2017 07:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83915e74-6198-4b0a-9aff-96cdedfad97a@sandeen.net>
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de> <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
 <CACj3i73u11rNPK701aVm07qOPpT2r-1r_m--iW-D6SwLfb-pbw@mail.gmail.com> <83915e74-6198-4b0a-9aff-96cdedfad97a@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 5 Apr 2017 16:24:18 +0200
Message-ID: <CACj3i71xWPTZRUE+mF5CNT4OsfJEKstvgJPEviEOC9d=U3noAA@mail.gmail.com>
Subject: Re: [xfsprogs] Do we need so many data types for user input?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Apr 5, 2017 at 4:08 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 4/5/17 3:26 AM, Jan Tulak wrote:
>> On Tue, Apr 4, 2017 at 10:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 4/4/17 2:48 PM, Luis R. Rodriguez wrote:
>>>>
>>>> And then agsize is capped artificially later via validate_ag_geometry():
>>>>
>>>>         if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>>>>               ...
>>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>>>               ...
>>>>       if (agsize > dblocks) {
>>>>               ...
>>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>>>               ...
>>>>
>>>> Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.
>>>
>>> .maxval = XFS_AG_MAX_BYTES,
>>>
>>> #define XFS_AG_MAX_BYTES        ((XFS_AG_BYTES(31)))    /* 1 TB */
>>> #define XFS_AG_BYTES(bblog)     ((long long)BBSIZE << (bblog))
>>>
>>> so the maximum is (long long)(512) << 31
>>>
>>> so, no - agsize won't fit in a 32 bit var, if that's the question...
>>>
>>
>> Yeah. I think that we can make it uint64 everywhere unless it is
>> causing an issue in a specific case with a bit shift or something, and
>> just limit the input value where appropriate explicitly.
>>
>>
>> And...
>>> And at the end of the day, we are converting all numbers into unsigned
>>
>> I take back this part, we are going through long long, not unsigned long long.
>> Everything else is still valid.
>
> Ok, for those who aren't immersed 24/7 in mkfs ;) can you help us understand
> where you're going with this?  What's the change you're proposing, and how
> does it help?
>

If you ask only about the last sentence - I was just taking back my
claim that we already convert all numbers into unsigned in getnum. We
convert them to long long right now. (It was too late evening for me,
apparently. :-) )

If you ask more about summarising what I want to do, then:

I'm already moving these standalone variables into an options table,
that holds all the information in one place. As I'm already touching
them, I can as well clean the differences and changes accumulated over
the years and change a lot of mkfs's internal variables from a mix of
signed and unsigned, 32bit and 64bit, to a single type, unsigned
64bits long.

That would simplify the code in some places and make it clear what
type numerical values are - less things like foo((long long) bar);


Cheers,
Jan

> Thanks,
> -Eric



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
