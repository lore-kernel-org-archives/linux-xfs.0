Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35940 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754219AbdDEI1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 04:27:16 -0400
Received: by mail-ua0-f169.google.com with SMTP id 100so3607071uaj.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2017 01:27:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de> <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 5 Apr 2017 10:26:54 +0200
Message-ID: <CACj3i73u11rNPK701aVm07qOPpT2r-1r_m--iW-D6SwLfb-pbw@mail.gmail.com>
Subject: Re: [xfsprogs] Do we need so many data types for user input?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 4, 2017 at 10:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/4/17 2:48 PM, Luis R. Rodriguez wrote:
>>
>> And then agsize is capped artificially later via validate_ag_geometry():
>>
>>         if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>>               ...
>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>               ...
>>       if (agsize > dblocks) {
>>               ...
>>       if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
>>               ...
>>
>> Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.
>
> .maxval = XFS_AG_MAX_BYTES,
>
> #define XFS_AG_MAX_BYTES        ((XFS_AG_BYTES(31)))    /* 1 TB */
> #define XFS_AG_BYTES(bblog)     ((long long)BBSIZE << (bblog))
>
> so the maximum is (long long)(512) << 31
>
> so, no - agsize won't fit in a 32 bit var, if that's the question...
>

Yeah. I think that we can make it uint64 everywhere unless it is
causing an issue in a specific case with a bit shift or something, and
just limit the input value where appropriate explicitly.


And...
> And at the end of the day, we are converting all numbers into unsigned

I take back this part, we are going through long long, not unsigned long long.
Everything else is still valid.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
