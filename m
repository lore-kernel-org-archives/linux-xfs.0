Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88781C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 17:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE992076C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 17:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgHYRcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 13:32:09 -0400
Received: from sandeen.net ([63.231.237.45]:34770 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHYRcJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Aug 2020 13:32:09 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 706D1EF4;
        Tue, 25 Aug 2020 12:31:58 -0500 (CDT)
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
 <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
 <20200825150915.GD3357@technoir>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2200404f-acdb-690c-a0ac-540f7d93902f@sandeen.net>
Date:   Tue, 25 Aug 2020 12:32:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200825150915.GD3357@technoir>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 10:09 AM, Anthony Iliopoulos wrote:
> On Tue, Aug 25, 2020 at 08:59:39AM -0500, Eric Sandeen wrote:
>> On 8/24/20 5:55 PM, Dave Chinner wrote:
>>> I agree that mkfs needs to be aware of DAX capability of the block
>>> device, but that capability existing should not cause mkfs to fail.
>>> If we want users to be able to direct mkfs to to create a DAX
>>> capable filesystem then adding a -d dax option would be a better
>>> idea. This would direct mkfs to align/size all the data options to
>>> use a DAX compatible topology if blkid supports reporting the DAX
>>> topology. It would also do things like turn off reflink (until that
>>> is supported w/ DAX), etc.
>>>
>>> i.e. if the user knows they are going to use DAX (and they will)
>>> then they can tell mkfs to make a DAX compatible filesystem.
>>
>> FWIW, Darrick /just/ added a -d daxinherit option, though all it does
>> now is set the inheritable dax flag on the root dir, it doesn't enforce
>> things like page vs block size, etc.
> 
> I am aware of that patch, but I considered the option to be somewhat
> orthogonal, given that FS_XFLAG_DAX can be set (and inherited)
> irrespective of dax support in the block device (and overridden via
> mount opts if need be), so I didn't want to overload daxinherit.

OK fair enough.

>> That change is currently staged in my local tree.
>>
>> I suppose we could condition that on other requirements, although we've
>> always had the ability to mkfs a filesystem that can't necessarily be
>> used on the current machine - i.e. you can make a 64k block size filesystem
>> on a 4k page machine, etc.  So I'm not sure we want to tie mkfs abilities
>> to the current mkfs environment....
> 
> Agreed, so I suppose any dax option should be an opt-in, e.g. similar to
> the -d dax=1 proposal. That won't prevent users from neglecting it and
> creating a fs which will be later incompatible with -o dax, but that's a
> different story I guess..

I guess my overarching desire here is to not try to predict too much, or to
make predictions that won't stand the test of time. Inferring what the admin
wants can be tricky.  :)  

I also want to be consistent; i.e. today we can mkfs a 64k block filesystem
on a 4k block machine, and no warning is emitted. If we mkfs a V5/CRC filesystem
or a reflink filesystem on an old kernel that doesn't support it, no warning is
emitted.

If we're going to warn every time when "this filesystem can't be used under the
currently running kernel" then there are quite a lot of cases to handle... I
don't want to warn about some things and not others, so we need to decide if
this is actually something we want to do in general, not just for dax.  I'm 
somewhat disinclined, TBH, and would rather rely on a mount failure to alert
the admin to the problem.  (It's not like there are a lot of resources invested
between mkfs & mount).

I'll reread this thread & Dave's responses and give this some more thought.

Thanks,
-Eric

> - Anthony
> 
