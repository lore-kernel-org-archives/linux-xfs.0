Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31821C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D26F2070A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEOVex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 17:34:53 -0400
Received: from sandeen.net ([63.231.237.45]:56526 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgEOVex (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 May 2020 17:34:53 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 08BD9544;
        Fri, 15 May 2020 16:34:31 -0500 (CDT)
Subject: Re: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200515204802.GO6714@magnolia>
 <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
 <20200515211011.GP6714@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <ffb18f85-4b60-d8e3-e488-b4dc3b3c071b@sandeen.net>
Date:   Fri, 15 May 2020 16:34:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515211011.GP6714@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/15/20 4:10 PM, Darrick J. Wong wrote:
> On Fri, May 15, 2020 at 03:54:34PM -0500, Eric Sandeen wrote:
>> On 5/15/20 3:48 PM, Darrick J. Wong wrote:
>>> On Fri, May 15, 2020 at 02:14:17PM -0500, Eric Sandeen wrote:
>>>> We validate commandline options for stripe unit and stripe width, and
>>>> if a device returns nonsensical values via libblkid, the superbock write
>>>> verifier will eventually catch it and fail (noisily and cryptically) but
>>>> it seems a bit cleaner to just do a basic sanity check on the numbers
>>>> as soon as we get them from blkid, and if they're bogus, ignore them from
>>>> the start.
>>>>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>
>>>> diff --git a/libfrog/topology.c b/libfrog/topology.c
>>>> index b1b470c9..38ed03b7 100644
>>>> --- a/libfrog/topology.c
>>>> +++ b/libfrog/topology.c
>>>> @@ -213,6 +213,19 @@ static void blkid_get_topology(
>>>>  	val = blkid_topology_get_optimal_io_size(tp);
>>>>  	*swidth = val;
>>>>  
>>>> +        /*
> 
> Tabs not spaces

yeah I have no idea how that happened :P

>>>> +	 * Occasionally, firmware is broken and returns optimal < minimum,
>>>> +	 * or optimal which is not a multiple of minimum.
>>>> +	 * In that case just give up and set both to zero, we can't trust
>>>> +	 * information from this device. Similar to xfs_validate_sb_common().
>>>> +	 */
>>>> +        if (*sunit) {
>>>> +                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {
> 
> Why not combine these?
> 
> if (*sunit != 0 && (*sunit > *swidth || *swidth % *sunit != 0)) {

was making it look a little like the kernel sb checks but *shrug*

> Aside from that the code looks fine I guess...
> 
>>> I feel like we're copypasting this sunit/swidth checking logic all over
>>> xfsprogs 
>>
>> That's because we are!
>>
>>> and yet we're still losing the stripe unit validation whackamole
>>> game.
>>
>> Need moar hammers!
>>
>>> In the end, we want to check more or less the same things for each pair
>>> of stripe unit and stripe width:
>>>
>>>  * integer overflows of either value
>>>  * sunit and swidth alignment wrt sector size
>>>  * if either sunit or swidth are zero, both should be zero
>>>  * swidth must be a multiple of sunit
>>>
>>> All four of these rules apply to the blkid_get_toplogy answers for the
>>> data device, the log device, and the realtime device; and any mkfs CLI
>>> overrides of those values.
>>>
>>> IOWs, is there some way to refactor those four rules into a single
>>> validation function and call that in the six(ish) places we need it?
>>> Especially since you're the one who played the last round of whackamole,
>>> back in May 2018. :)
>>
>> So .... I would like to do that refactoring.  I'd also like to fix this
>> with some expediency, TBH...
>>
>> Refactoring is going to be a little more complicated, I fear, because sanity
>> on "what came straight from blkid" is a little different from "what came from
>> cmdline" and has slightly different checks than "how does it fit into the
>> superblock we just read?"
> 
> Admittedly I wondered if "refactor all these checks" would fall apart
> because each tool has its own slightly different reporting and logging
> requirements.  You could make a checker function return an enum of what
> it's mad about and each caller could either have a message catalogue or
> just bail depending on the circumstances, but now I've probably
> overengineered the corner case catching code.
> 
>> This (swidth-vs-sunit-is-borken) is common enough that I wanted to just kill
>> it with fire, and um ... make it all better/cohesive at some later date.
>>
>> I don't like arguing for expediency over beauty but well... here I am.
> 
> :(

Well, I guess it's not actually that urgent; we don't handle it well
today but maybe I should resist the urge to do another spot-fix that
could(?) be handled better....

i'll put this on the backburner & give it a bit more thought I guess.

Thanks,
-Eric
