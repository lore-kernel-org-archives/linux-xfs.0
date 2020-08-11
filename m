Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748CEC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576F2207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 20:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHKUCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 16:02:10 -0400
Received: from sandeen.net ([63.231.237.45]:33190 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgHKUCJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 16:02:09 -0400
Received: from [10.0.0.11] (liberator [10.0.0.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2B51FF8B41;
        Tue, 11 Aug 2020 15:01:43 -0500 (CDT)
Subject: Re: [PATCH 2/2] mkfs: allow setting dax flag on root directory
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159716413625.2135493.4789129138005837744.stgit@magnolia>
 <159716415037.2135493.12958426655000840394.stgit@magnolia>
 <3331be1f-87de-074a-65ac-2491a97b3f80@sandeen.net>
 <20200811195445.GE6107@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <c2ef5419-a1ce-40cd-ce13-a2005c9d28e6@sandeen.net>
Date:   Tue, 11 Aug 2020 15:02:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811195445.GE6107@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/11/20 12:54 PM, Darrick J. Wong wrote:
> On Tue, Aug 11, 2020 at 02:39:01PM -0500, Eric Sandeen wrote:
>> On 8/11/20 9:42 AM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Teach mkfs to set the DAX flag on the root directory so that all new
>>> files can be created in dax mode.  This is a complement to removing the
>>> mount option.
>>
>> So, a new -d option, "-d dax"
>>
>> This is ~analogous to cowextsize, rtinherit, projinherit, and extszinherit
>> so there is certainly precedence for this.  (where only rtinherit is a boolean
>> like this, but they are all inheritable behaviors)
>>
>> (I wonder if "daxinherit" would be more consistent, but won't bikeshed
>> that (much))
> 
> /me is indifferent either way.  But I guess some day we might want to
> have a dax= flag to indicate something like "set the data device
> geometry to optimize for DAX?
> 
> Nah, I think if we were ever going to do that, we'd have something more
> like:
> 
> 	-d usage=dax
> 	-d usage=ssd
> 	-d usage=floopy
> 
> Meh.  I'll change it to daxinherit, since that /is/ what it does.

Ok.  I'm really pretty indifferent as well.

>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  man/man8/mkfs.xfs.8 |   11 +++++++++++
>>>  mkfs/xfs_mkfs.c     |   14 ++++++++++++++
>>>  2 files changed, 25 insertions(+)
>>>
>>>
>>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
>>> index 9d762a43011a..4b4fdd86b2f4 100644
>>> --- a/man/man8/mkfs.xfs.8
>>> +++ b/man/man8/mkfs.xfs.8
>>> @@ -394,6 +394,17 @@ All inodes created by
>>>  will have this extent size hint applied.
>>>  The value must be provided in units of filesystem blocks.
>>>  Directories will pass on this hint to newly created children.
>>> +.TP
>>> +.BI dax= value
>>> +All inodes created by
>>> +.B mkfs.xfs
>>> +will have the DAX flag set.
>>> +This means that directories will pass the flag on to newly created files
>>
>> let's call this "children" to match the other similar options?
>>
>> (because technically it is passed on not only to regular files, right?)
> 
> Directories and regular files, though not to other special files.
> Maybe we should fix that.

Ok so not all children.  But also not just files.  :P

"... pass the flag on to newly created files and directories, so that new
files will use the DAX IO paths when possible." ?

>>> +and files will use the DAX IO paths when possible.
>>> +This value is either 1 to enable the use or 0 to disable.

...

>>> @@ -369,6 +371,12 @@ static struct opt_params dopts = {
>>>  		  .maxval = UINT_MAX,
>>>  		  .defaultval = SUBOPT_NEEDS_VAL,
>>>  		},
>>> +		{ .index = D_DAX,
>>> +		  .conflicts = { { NULL, LAST_CONFLICT } },
>>
>> er....  should we conflict with reflink ....  ?

Thoughts? :)

>>> +		  .minval = 0,
>>> +		  .maxval = 1,
>>> +		  .defaultval = 1,
>>
>> Hm, interesting that this is a little different from rtinherit:
>>
>>                 { .index = D_RTINHERIT,
>>                   .conflicts = { { NULL, LAST_CONFLICT } },
>>                   .minval = 1,
>>                   .maxval = 1,
>>                   .defaultval = 1,
>>                 },
>>
>> I think this means that:
>>
>> -d rtinherit
>> -d rtinherit=1
>>
>> are valid, but
>>
>> -d rtinherit=0 is not, but
>>
>> -d dax
>> -d dax=1
>> -d dax=0
>>
>> are all valid?
> 
> TBH, I find it a little odd that you *can't* say "-d rtinherit=0" from a
> completeness perspective, but...

We could probably loosen it up and start allowing zero here too.
It wouldn't break any old scripts, right.

>> While the latter makes a bit more sense, I wonder if we should stay
>> consistent w/ the rtinherit semantics.  Or do you envision some sort
>> of automatic enabling of this based on device typethat we'd need to
>> override in the future?
> 
> ...the goal is to set this automatically once distros start shipping a
> libblkid that has blkid_topology_get_dax().  At that point we'll
> probably want a way to force it off.

*nod*

> Unless we want the ability to specify -ddax=0 the magic seekrit hook to
> discover if (future) mkfs actually supports dax autodetection?  Hmm,
> that alone sounds like sufficient justification.  Ok.

Not sure I followed that... :)

-Eric

