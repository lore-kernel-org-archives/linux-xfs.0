Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:34389 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdCPRcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 13:32:02 -0400
Received: by mail-ot0-f181.google.com with SMTP id o24so63638872otb.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2017 10:32:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79cc8aa4-9ff0-07cb-9f88-755239d4311f@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <79cc8aa4-9ff0-07cb-9f88-755239d4311f@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 16 Mar 2017 18:23:19 +0100
Message-ID: <CACj3i70AfuMFTmNxVEnjqyY=ipiGHT9mb6z8htJe9Vo-G=brJw@mail.gmail.com>
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, "Luis R . Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>

On Thu, Mar 16, 2017 at 6:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/15/17 8:59 AM, Jan Tulak wrote:
>> Hi guys,
>>
>> my RFC didn't got much of attention, so I'm sending it as a merge request.
>> Hopefully, this will get more eyes on it. ;-) I fixed the few small issues Bill
>> noticed (Thanks, Bill!) and xfstests runs ok. There is one case where test
>> xfs/191-input-validation was accepting a behaviour forbidden in man page, so
>> I'm sending also a xfstests patch:
>>
>> Specifically, a standalone "-l size=4096b" should fail, because:
>>               To  specify any options on the command line in units of filesys‐
>>               tem blocks, this option must be  specified  first  so  that  the
>>               filesystem block size is applied consistently to all options.
>>
>> So without the xfstest patch, expect this one test to fail.
>>
>> The following text is copy&paste from RFC. I only removed/edited one question
>> I had at the time and was solved in the RFC thread. After that is an addendum
>> with regards to Luis' config file support.
>
> Hi Jan -
>
> I'm finally trying to take some time and give this serious review.
>
> At a top level, though, please fix up coding style issues which are
> introduced throughout the series.
>
> As Dave has said before, checkpatch.pl in the kernel tree isn't perfect,
> and we need to apply understanding and reason to its results, but it's
> a place to start looking - for a sampling,
>
> [snip]
>
> So use your good judgement, but please fix as many of these as you can;
> it's important to have a consistent coding style throughout the xfsprogs
> codebase.
>

OK, thanks. I will run it and see what I can do. And thanks for
looking on this. :-)

Cheers,
Jan


-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
