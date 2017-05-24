Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58626 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbdEXD3g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 23:29:36 -0400
Subject: Re: [PATCH] xfs_metadump: tag metadump image with attribute flags
References: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
 <20170523154603.GR4519@birch.djwong.org>
 <41c04794-5aef-5e2e-17ad-9ccf8aac488c@sandeen.net>
 <20170524032632.GA17542@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7d6c4f1e-6977-f205-478f-a41f813ecdf1@sandeen.net>
Date: Tue, 23 May 2017 22:29:33 -0500
MIME-Version: 1.0
In-Reply-To: <20170524032632.GA17542@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/23/17 10:26 PM, Dave Chinner wrote:
> On Tue, May 23, 2017 at 10:47:50AM -0500, Eric Sandeen wrote:
>> On 5/23/17 10:46 AM, Darrick J. Wong wrote:
>>> On Mon, May 22, 2017 at 07:33:35PM -0500, Eric Sandeen wrote:
>>>> After the long discussion about warning the user and/or consumer
>>>> of xfs_metadumps about dirty logs, it crossed my mind that we
>>>> could use the reserved slot in the metadump header to tag the
>>>> file with attributes, so the consumer of the metadump knows how
>>>> it was created.
>>>>
>>>> This patch adds 3 flags to describe the metadump: dirty log,
>>>> obfuscated, and full blocks (unused portions of metadata blocks
>>>> are not zeroed out).
>>>>
>>>> It then adds a new option to xfs_mdrestore, "-i" to show info,
>>>> which can be used with or without a target file:
>>
>>
>>>> +/* mb_flags */
>>>> +#define XFS_METADUMP_OBFUSCATED	(1 << 0)
>>>> +#define XFS_METADUMP_FULLBLOCKS	(1 << 1)
>>>> +#define XFS_METADUMP_DIRTYLOG	(1 << 2)
>>>
>>> If we always wrote zero for mb_reserved previously, how do we
>>> distinguish between a non-obfuscated partial-block clean-log metadump
>>> and an old metadump?  Do we care?
>>
>> Oh right.  ;)
>>
>>> I imagine metadumps are fairly transitory in nature, so it might not be
>>> a big deal, and probably not worth burning 1/8 of our flag-space over
>>> since AFAICT we don't use the(se) flags for any serious behavioral
>>> changes.
>>
>> OTOH, how many flags would we possibly have?  I'm ok with adding a
>> "we have flags" flag, too.
> 
> We can't extend the metadump header in a backwards compatible way
> unless mdrestore already rejects metadumps with non-zero mb_reserved
> fields....

There's no action taken based on the contents; it's information only,
and essentially optional.  It doesn't affect the primary functionality of
mdrestore in any way.

The reserved field has always been zeroed before; if newer mdrestore finds
all zeros, it can say "no info available."

If newer mdrestore finds a "we have flags" flag, it can report information
contained there.

What hole am I missing?

Thanks,
-Eric
