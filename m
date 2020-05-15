Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5CEC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336F3206D4
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 21:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5Mpksoy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgEOVG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 17:06:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726247AbgEOVG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 17:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589576818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=o+WKHuF7Cs93P2O1uIQL7nFIhoZM8rjeXYsyp69kGEA=;
        b=M5MpksoyxAb8hSDLc9Cg+xp2kQpYgfADmz5okg6Ut2AsTz3kaSkhIOnoWyjsyeI034eM7/
        ZMJEt1762sK/SgCK+nWqmq2LSY2SKjWY1mZbbwBswteOi0SC0CsP3t1K5WpIqGRmKqThi1
        /32g7ZUnMeIIQ2iKET+w+26fmDuzdPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-4mIeR5M1Of-3NrNbrHtzNg-1; Fri, 15 May 2020 17:06:56 -0400
X-MC-Unique: 4mIeR5M1Of-3NrNbrHtzNg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B2031800D4A;
        Fri, 15 May 2020 21:06:55 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2928C5D9D5;
        Fri, 15 May 2020 21:06:55 +0000 (UTC)
Subject: Re: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
From:   Eric Sandeen <sandeen@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200515204802.GO6714@magnolia>
 <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <5ea47ce1-e26c-4bd0-4ac9-4d08eabc9f0c@redhat.com>
Date:   Fri, 15 May 2020 16:06:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/15/20 3:54 PM, Eric Sandeen wrote:
> On 5/15/20 3:48 PM, Darrick J. Wong wrote:
>> On Fri, May 15, 2020 at 02:14:17PM -0500, Eric Sandeen wrote:
>>> We validate commandline options for stripe unit and stripe width, and
>>> if a device returns nonsensical values via libblkid, the superbock write
>>> verifier will eventually catch it and fail (noisily and cryptically) but
>>> it seems a bit cleaner to just do a basic sanity check on the numbers
>>> as soon as we get them from blkid, and if they're bogus, ignore them from
>>> the start.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> diff --git a/libfrog/topology.c b/libfrog/topology.c
>>> index b1b470c9..38ed03b7 100644
>>> --- a/libfrog/topology.c
>>> +++ b/libfrog/topology.c
>>> @@ -213,6 +213,19 @@ static void blkid_get_topology(
>>>  	val = blkid_topology_get_optimal_io_size(tp);
>>>  	*swidth = val;
>>>  
>>> +        /*
>>> +	 * Occasionally, firmware is broken and returns optimal < minimum,
>>> +	 * or optimal which is not a multiple of minimum.
>>> +	 * In that case just give up and set both to zero, we can't trust
>>> +	 * information from this device. Similar to xfs_validate_sb_common().
>>> +	 */
>>> +        if (*sunit) {
>>> +                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {
>>
>> I feel like we're copypasting this sunit/swidth checking logic all over
>> xfsprogs 
> 
> That's because we are!
> 
>> and yet we're still losing the stripe unit validation whackamole
>> game.
> 
> Need moar hammers!
> 
>> In the end, we want to check more or less the same things for each pair
>> of stripe unit and stripe width:
>>
>>  * integer overflows of either value
>>  * sunit and swidth alignment wrt sector size
>>  * if either sunit or swidth are zero, both should be zero
>>  * swidth must be a multiple of sunit
>>
>> All four of these rules apply to the blkid_get_toplogy answers for the
>> data device, the log device, and the realtime device; and any mkfs CLI
>> overrides of those values.
>>
>> IOWs, is there some way to refactor those four rules into a single
>> validation function and call that in the six(ish) places we need it?
>> Especially since you're the one who played the last round of whackamole,
>> back in May 2018. :)
> 
> So .... I would like to do that refactoring.  I'd also like to fix this
> with some expediency, TBH...
> 
> Refactoring is going to be a little more complicated, I fear, because sanity
> on "what came straight from blkid" is a little different from "what came from
> cmdline" and has slightly different checks than "how does it fit into the
> superblock we just read?"
> 
> This (swidth-vs-sunit-is-borken) is common enough that I wanted to just kill
> it with fire, and um ... make it all better/cohesive at some later date.
> 
> I don't like arguing for expediency over beauty but well... here I am.

A little more context, failures like this are caught today, but only
in the validators, and it's very noisy and nonobvious when it happens.
And we seem to keep finding devices that are broken like this, so would be
nice to just ignore them and move on.

-Eric

