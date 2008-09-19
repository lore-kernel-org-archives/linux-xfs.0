Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 17:41:33 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J0fUqQ003369
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 17:41:30 -0700
Message-ID: <48D2F795.3080104@sgi.com>
Date: Fri, 19 Sep 2008 10:51:33 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>    <48D2C97A.1070703@thebarn.com> <63352.131.252.241.230.1221776406.squirrel@sandeen.net>
In-Reply-To: <63352.131.252.241.230.1221776406.squirrel@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Russell Cattelan wrote:
>> Lachlan McIlroy wrote:
>>> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
>>> all the records from the next page into the current page then we need
>>> to update the er_extoff of the modified page as we move the remaining
>>> extents up.  Would you mind giving it a go?
>>>
>>> --- a/fs/xfs/xfs_inode.c    2008-09-18 18:48:46.000000000 +1000
>>> +++ b/fs/xfs/xfs_inode.c    2008-09-18 18:57:18.000000000 +1000
>>> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>>>                     (XFS_LINEAR_EXTS -
>>>                         erp_next->er_extcount) *
>>>                     sizeof(xfs_bmbt_rec_t));
>>> +                erp_next->er_extoff += ext_diff;
>>>             }
>>>         }
>>>
>> Cool I'll give it some run through when I done traveling.
>>
>> I still think compact_full should simply be eliminated since
>> it really doesn't help, and it's obviously confusing code.
>> Or we should make sure it works and get rid of compact_pages
>> since compact_full behaves just like compact_pages when not
>> doing partial moves.
> 
> I'd agree with that, at least as far as reevaluating this packing stuff -
> given the seriousness of the bug when you do hit it, and how rarely it's
> ever hit, apparently this chunk of code is almost never run ....
> 

I agree too.  If any code is difficult to reach it's also difficult to test.
We've had numerous reports of extent corruption that could be explained by
this bug but we have not been able to reproduce the symptoms let alone devise
a reliable test case.

What real benefit does compact_full have over compact_pages?
Are there corner cases where compact_pages is not good enough?
