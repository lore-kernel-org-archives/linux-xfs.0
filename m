Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CF4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 06:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiDNGvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 02:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiDNGvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 02:51:06 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2B3854187
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 23:48:37 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C063D60E38;
        Thu, 14 Apr 2022 16:48:35 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id ZL_b8jv26X0w; Thu, 14 Apr 2022 16:48:35 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 59BAC60E26;
        Thu, 14 Apr 2022 16:48:35 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 425FD6802DC; Thu, 14 Apr 2022 16:48:35 +1000 (AEST)
Date:   Thu, 14 Apr 2022 16:48:35 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Limits to growth
Message-ID: <20220414064835.GA663863@onthe.net.au>
References: <20220414040024.GA550443@onthe.net.au>
 <20220414051801.GM1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220414051801.GM1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 14, 2022 at 03:18:01PM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 02:00:24PM +1000, Chris Dunlop wrote:
>> Hi,
>>
>> I have a nearly full 30T xfs filesystem that I need to grow significantly,
>> e.g. to, say, 256T, and potentially further in future, e.g. up to, say, 1PB.
>
> That'll be fun. :)

Yeah, good problem to have.

>> So even if the current fs were to grow to a 1P or more, e.g. 30x - 60x 
>> original, I'm still only going to be ~10% worse off in terms of agcount 
>> than creating a large fs from scratch and copying all the data over.
>
> Yup.
>
>> Is that really going to make a significant difference?
>
> No.
>
> But there will be significant differences. e.g. think of the data
> layout and free space distribution of a 1PB filesystem that it is
> 90% full and had it's data evenly distributed throughout it's
> capacity. Now consider the free space distribution of a 100TB
> filesystem that has been filled to 99% and then grown by 100TB nine
> times to a capacity of 90% @ 1PB. Where is all the free space?
>
> That's right - the free space is only in the region that was
> appended in the last 100TB grow operation. IOWs, 90% of the AGs are
> completley full, and the newly added 10% are compeltely empty.

Yep. But growing from 30T (@ 89% full), to 256T, then possibly to 512T and 
then 1P shouldn't suffer from this issue as much - perhaps assisted by 
growing when it reaches, say, 60-70% rather than waiting till 90%.

In this case I might be in a decent position: the data is generally 
large-ish backup files and the older ones get deleted as they age out, so 
that should free up a significant amount of space in the 
currently-near-full AGs over time. It sounds like this, in conjunction 
with the balancing of the allocation algorithms, should end up 
homogenising the usage over all the AGs.

Or, if there's a chance it'll get to 1P, would it be better to grow it out 
that far now (on thin storage - ceph rbd in this case)?

On the other hand, I may want newer XFS feature goodies before I need 1P 
in this thing.

> IOWs, growing by more than 10x really starts to push the limits of
> the algorithms regardless of the AG count it results in.  It's not a
> capacity thing - it's a reflection of the number of AGs with usable
> free space in them and the algorithms used to find free space in
> those AGs.

I'm not sure if 89% full has already put me behind, but outside of that, 
doing a grow at, say, 60-70% full rather than 90+%, in conjunction with a 
decent amount of data turnover, should reduce or remove this problem, no?

I.e. would you say, growing by more (possibly a lot more) than 10x would 
probably be ok *IF* you're starting with (near) maximally sized AGs, and 
growing the fs when it reaches, say, 60-70% full, and with data that has a 
reasonable turn over cycle?

Cheers,

Chris
