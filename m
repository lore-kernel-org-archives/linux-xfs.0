Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478E3C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 02:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjEYCYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 22:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjEYCYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 22:24:13 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A6D319C
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 19:24:06 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id EA5E85CC303;
        Wed, 24 May 2023 21:24:05 -0500 (CDT)
Message-ID: <2b2cbfcf-c5e3-26b4-cc3a-028012f4cb15@sandeen.net>
Date:   Wed, 24 May 2023 21:24:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Content-Language: en-US
To:     Justin Forbes <jforbes@fedoraproject.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     Mike Pastore <mike@oobak.org>, linux-xfs@vger.kernel.org
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
 <20230502220258.GA3223426@dread.disaster.area>
 <CAP_NaWZEcv3B0nPEFguxVuQ8m93mO7te-bZDfwo-C8eN+f_KNA@mail.gmail.com>
 <20230502231318.GB3223426@dread.disaster.area>
 <ZG0w21hcYEl64joP@fedora64.linuxtx.org>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZG0w21hcYEl64joP@fedora64.linuxtx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/23/23 4:32 PM, Justin Forbes wrote:
> On Wed, May 03, 2023 at 09:13:18AM +1000, Dave Chinner wrote:
>> On Tue, May 02, 2023 at 05:13:09PM -0500, Mike Pastore wrote:
>>> On Tue, May 2, 2023, 5:03 PM Dave Chinner <david@fromorbit.com> wrote:
>>>
>>>>
>>>> If you can find a minimal reproducer, that would help a lot in
>>>> diagnosing the issue.
>>>>
>>>
>>> This is great, thank you. I'll get to work.
>>>
>>> One note: the problem occured with and without crc=0, so we can rule that
>>> out at least.
>>
>> Yes, I noticed that. My point was more that we have much more
>> confidence in crc=1 filesystems because they have much more robust
>> verification of the on-disk format and won't fail log recovery in
>> the way you noticed. The verification with crc=1 configured
>> filesystems is also known to catch issues caused by
>> memory corruption more frequently, often preventing such occurrences
>> from corrupting the on-disk filesystem.
>>
>> Hence if you are seeing corruption events, you really want to be
>> using "-m crc=1" (default config) filesystems...
> 
> Upon trying to roll out 6.3.3 to Fedora users, it seems that we have a
> few hitting this reliabily with 6.3 kernels. It is certainly not all
> users of XFS though, as I use it extensively and haven't run across it.
> The most responsive users who can reproduce all seem to be running on
> xfs filesystems that were created a few years ago, and some even can't
> reproduce it on their newer systems.  Either way, it is a widespread
> enough problem that I can't roll out 6.3 kernels to stable releases
> until it is fixed.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=2208553

The two cases in that bug look very similar, and are on similar 
hardware, and they also look (to me) like different problems than the 
one reported here.

Those reporters are reading garbage data from disk, this one seems to be 
in-memory corruption of an inode down a xfs_free_eofblocks() path...

I could be wrong, but I'm not seeing a connection between this report 
and the bugzilla report, at first glance.

Thanks,
-Eric


