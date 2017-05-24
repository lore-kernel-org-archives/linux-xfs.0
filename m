Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42654 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031593AbdEXWeT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 18:34:19 -0400
Subject: Re: [PATCH] xfs_metadump: tag metadump image with attribute flags
References: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
 <20170523154603.GR4519@birch.djwong.org>
 <41c04794-5aef-5e2e-17ad-9ccf8aac488c@sandeen.net>
 <20170524032632.GA17542@dastard>
 <7d6c4f1e-6977-f205-478f-a41f813ecdf1@sandeen.net>
 <20170524222526.GB17542@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <68faddc1-36c2-2424-d31f-949585db8f95@sandeen.net>
Date: Wed, 24 May 2017 17:34:17 -0500
MIME-Version: 1.0
In-Reply-To: <20170524222526.GB17542@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/24/17 5:25 PM, Dave Chinner wrote:
> On Tue, May 23, 2017 at 10:29:33PM -0500, Eric Sandeen wrote:
>> On 5/23/17 10:26 PM, Dave Chinner wrote:
>>> On Tue, May 23, 2017 at 10:47:50AM -0500, Eric Sandeen wrote:
>>>> On 5/23/17 10:46 AM, Darrick J. Wong wrote:
>>>>> On Mon, May 22, 2017 at 07:33:35PM -0500, Eric Sandeen wrote:
>>>>>> After the long discussion about warning the user and/or consumer
>>>>>> of xfs_metadumps about dirty logs, it crossed my mind that we
>>>>>> could use the reserved slot in the metadump header to tag the
>>>>>> file with attributes, so the consumer of the metadump knows how
>>>>>> it was created.
>>>>>>
>>>>>> This patch adds 3 flags to describe the metadump: dirty log,
>>>>>> obfuscated, and full blocks (unused portions of metadata blocks
>>>>>> are not zeroed out).
>>>>>>
>>>>>> It then adds a new option to xfs_mdrestore, "-i" to show info,
>>>>>> which can be used with or without a target file:
>>>>
>>>>
>>>>>> +/* mb_flags */
>>>>>> +#define XFS_METADUMP_OBFUSCATED	(1 << 0)
>>>>>> +#define XFS_METADUMP_FULLBLOCKS	(1 << 1)
>>>>>> +#define XFS_METADUMP_DIRTYLOG	(1 << 2)
>>>>>
>>>>> If we always wrote zero for mb_reserved previously, how do we
>>>>> distinguish between a non-obfuscated partial-block clean-log metadump
>>>>> and an old metadump?  Do we care?
>>>>
>>>> Oh right.  ;)
>>>>
>>>>> I imagine metadumps are fairly transitory in nature, so it might not be
>>>>> a big deal, and probably not worth burning 1/8 of our flag-space over
>>>>> since AFAICT we don't use the(se) flags for any serious behavioral
>>>>> changes.
>>>>
>>>> OTOH, how many flags would we possibly have?  I'm ok with adding a
>>>> "we have flags" flag, too.
>>>
>>> We can't extend the metadump header in a backwards compatible way
>>> unless mdrestore already rejects metadumps with non-zero mb_reserved
>>> fields....
>>
>> There's no action taken based on the contents; it's information only,
>> and essentially optional.  It doesn't affect the primary functionality of
>> mdrestore in any way.
>>
>> The reserved field has always been zeroed before; if newer mdrestore finds
>> all zeros, it can say "no info available."
>>
>> If newer mdrestore finds a "we have flags" flag, it can report information
>> contained there.
>>
>> What hole am I missing?
> 
> That I read "we have flags flag" as a "we have another flags field"
> flag. Which can't be done because the block index is packed hard
> against the struct xfs_metablock header.

Right, I'm not doing that.

I'm suggesting that mb_reserved has been zeroed out from day 1, so
the presence of /anything/ there indicates a newer format.

As Darrick pointed out, the absence of anything there isn't helpful,
unless we:

#define XFS_METADUMP_INFO_FLAGS (1 << 0)

and set that in newer metadump - then we'll know that the presence
or absence of any other feature flags will tell us something
about the dump.  If the INFO_FLAGS flag isn't set, it's an
old dump, and we can't learn anything.

<snip>

> As such, even if we don't change the size of the header, the flags
> can only be informational. They can't indicate a change in metadata
> format or behaviour such feature flags requires older mdrestorei
> binaries to reject flags they don't understand. In that case,
> calling the field "mb_info" might be more appropriate....

Right, that's why I made the option to read them "-i" (info),
and nothing else.

Certainly can't use them for format changes.

Sure, I can change the field name to make it more clear.

Thanks,
-Eric
 
> Cheers,
> 
> Dave.
>>
>> Thanks,
>> -Eric
>>
> 
