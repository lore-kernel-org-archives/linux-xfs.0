Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44877C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 20:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A26E2065C
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 20:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RGstsrYa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOUyu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 16:54:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21976 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726179AbgEOUyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 16:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589576089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DyhwogexqggZHd1aKVZHpwzNil3/3938kSeGoiQ/IUg=;
        b=RGstsrYaeWFJUmcdGv5QDp2KcyowQ8QUdWdEaxG5MmZI16raLa35d/qed3XdTjquvPtCPD
        CNPnaK4uDETKYtikmGb0pfoj0hrkFMjaMNgRfILENX4w5r86DkqVpEWs7memW/VyqB7fAx
        tMg7kMB6ag3sLqjSmbQfjkJxw0N4bsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-lVCgmRgHPj-wEzKb5vSyPw-1; Fri, 15 May 2020 16:54:43 -0400
X-MC-Unique: lVCgmRgHPj-wEzKb5vSyPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACBC58B7D14;
        Fri, 15 May 2020 20:54:35 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4110182E76;
        Fri, 15 May 2020 20:54:35 +0000 (UTC)
Subject: Re: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200515204802.GO6714@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <49e3d73f-1df1-e4d3-2451-db76f7084731@redhat.com>
Date:   Fri, 15 May 2020 15:54:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515204802.GO6714@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/15/20 3:48 PM, Darrick J. Wong wrote:
> On Fri, May 15, 2020 at 02:14:17PM -0500, Eric Sandeen wrote:
>> We validate commandline options for stripe unit and stripe width, and
>> if a device returns nonsensical values via libblkid, the superbock write
>> verifier will eventually catch it and fail (noisily and cryptically) but
>> it seems a bit cleaner to just do a basic sanity check on the numbers
>> as soon as we get them from blkid, and if they're bogus, ignore them from
>> the start.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/libfrog/topology.c b/libfrog/topology.c
>> index b1b470c9..38ed03b7 100644
>> --- a/libfrog/topology.c
>> +++ b/libfrog/topology.c
>> @@ -213,6 +213,19 @@ static void blkid_get_topology(
>>  	val = blkid_topology_get_optimal_io_size(tp);
>>  	*swidth = val;
>>  
>> +        /*
>> +	 * Occasionally, firmware is broken and returns optimal < minimum,
>> +	 * or optimal which is not a multiple of minimum.
>> +	 * In that case just give up and set both to zero, we can't trust
>> +	 * information from this device. Similar to xfs_validate_sb_common().
>> +	 */
>> +        if (*sunit) {
>> +                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {
> 
> I feel like we're copypasting this sunit/swidth checking logic all over
> xfsprogs 

That's because we are!

> and yet we're still losing the stripe unit validation whackamole
> game.

Need moar hammers!

> In the end, we want to check more or less the same things for each pair
> of stripe unit and stripe width:
> 
>  * integer overflows of either value
>  * sunit and swidth alignment wrt sector size
>  * if either sunit or swidth are zero, both should be zero
>  * swidth must be a multiple of sunit
> 
> All four of these rules apply to the blkid_get_toplogy answers for the
> data device, the log device, and the realtime device; and any mkfs CLI
> overrides of those values.
> 
> IOWs, is there some way to refactor those four rules into a single
> validation function and call that in the six(ish) places we need it?
> Especially since you're the one who played the last round of whackamole,
> back in May 2018. :)

So .... I would like to do that refactoring.  I'd also like to fix this
with some expediency, TBH...

Refactoring is going to be a little more complicated, I fear, because sanity
on "what came straight from blkid" is a little different from "what came from
cmdline" and has slightly different checks than "how does it fit into the
superblock we just read?"

This (swidth-vs-sunit-is-borken) is common enough that I wanted to just kill
it with fire, and um ... make it all better/cohesive at some later date.

I don't like arguing for expediency over beauty but well... here I am.

-Eric

> --D
> 
>> +                        *sunit = 0;
>> +                        *swidth = 0;
>> +                }
>> +        }
>> +
>>  	/*
>>  	 * If the reported values are the same as the physical sector size
>>  	 * do not bother to report anything.  It will only cause warnings
>>
> 

