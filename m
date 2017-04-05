Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755494AbdDEOJR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 10:09:17 -0400
Subject: Re: [xfsprogs] Do we need so many data types for user input?
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de>
 <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
 <CACj3i73u11rNPK701aVm07qOPpT2r-1r_m--iW-D6SwLfb-pbw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <83915e74-6198-4b0a-9aff-96cdedfad97a@sandeen.net>
Date: Wed, 5 Apr 2017 09:08:27 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i73u11rNPK701aVm07qOPpT2r-1r_m--iW-D6SwLfb-pbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org


On 4/5/17 3:26 AM, Jan Tulak wrote:
> On Tue, Apr 4, 2017 at 10:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 4/4/17 2:48 PM, Luis R. Rodriguez wrote:
>>>
>>> And then agsize is capped artificially later via validate_ag_geometry():
>>>
>>>         if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>>>               ...
>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>>               ...
>>>       if (agsize > dblocks) {
>>>               ...
>>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>>               ...
>>>
>>> Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.
>>
>> .maxval = XFS_AG_MAX_BYTES,
>>
>> #define XFS_AG_MAX_BYTES        ((XFS_AG_BYTES(31)))    /* 1 TB */
>> #define XFS_AG_BYTES(bblog)     ((long long)BBSIZE << (bblog))
>>
>> so the maximum is (long long)(512) << 31
>>
>> so, no - agsize won't fit in a 32 bit var, if that's the question...
>>
> 
> Yeah. I think that we can make it uint64 everywhere unless it is
> causing an issue in a specific case with a bit shift or something, and
> just limit the input value where appropriate explicitly.
> 
> 
> And...
>> And at the end of the day, we are converting all numbers into unsigned
> 
> I take back this part, we are going through long long, not unsigned long long.
> Everything else is still valid.

Ok, for those who aren't immersed 24/7 in mkfs ;) can you help us understand
where you're going with this?  What's the change you're proposing, and how
does it help?

Thanks,
-Eric

> Jan
> 
