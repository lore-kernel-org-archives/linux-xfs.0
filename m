Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38790 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754133AbdIRRf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:35:57 -0400
Subject: Re: [PATCH] xfs_repair: handle missing extent states
References: <20170918163944.GC6540@magnolia>
 <f19ea1b1-c86c-d745-b725-ac3befa5e0a3@sandeen.net>
 <ffab0b07-0bdb-8514-dd20-2c1136ff5580@sandeen.net>
 <20170918173006.GF6540@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b6e5b45-afd1-9fa3-9091-4e8088390462@sandeen.net>
Date: Mon, 18 Sep 2017 12:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170918173006.GF6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, amir73il@gmail.com

On 9/18/17 12:30 PM, Darrick J. Wong wrote:
> On Mon, Sep 18, 2017 at 12:18:50PM -0500, Eric Sandeen wrote:
>>
>>
>> On 9/18/17 12:16 PM, Eric Sandeen wrote:
>>>> @@ -812,6 +813,12 @@ _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
>>>>  					forkname, ftype, ino, b);
>>>>  				goto done;
>>>>  
>>>> +			case XR_E_COW:
>>>> +				do_warn(
>>>> +_("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
>>>> +					forkname, ftype, ino, b);
>>>> +				goto done;
>>>> +
>>> why do cow blocks get a special case and custom warning vs the above cases
>>> that just say "metadata?"
>>>
>>> Obviously it's just nitpicking over the do_warn message string, just
>>> double checking on the consistency front. 
>>
>> And this was also found via the rmap, but that fact isn't printed like
>> it is for every other type.  For that reason I'd probably rather just add
>> XR_RE_COW above the /* fallthrough */ too, for consistency.  Thoughts?
> 
> Strictly speaking, CoW blocks aren't metadata; they're, uh, alternate
> data. 

Oh, fair point.  ok.

> I'd rather have xfs_repair deliver a more specific message about
> the other alleged owner of a block so I'd know where to start looking --
> "claims CoW blocks" implies that I ought to start looking at the rmapbt
> for cow-owned blocks and the refcountbt, vs. just "shares with metadata,
> urk".

*nod*

> That said, we probably ought to have the rmapbt scan set XR_E_COW1 and
> have the refcountbt scan set XR_E_COW (similar to what we do for things
> like INUSE/INUSE1).  Will try to work on that for 4.14, but for now
> let's at least not abort xfs_repair here.

yep not asking for the world here, just trying to understand and maybe plant
the seeds for future cleanups.  ;)

-Eric
