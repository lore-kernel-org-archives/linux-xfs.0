Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B3CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 02:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiCACpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiCACpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 21:45:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4107C3BF8D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646102694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXtrRIzQbye/CXgfPdiL0RG6c42xYE0c4sxiODxwnH0=;
        b=Lt/YnsK4xQqi6jxhzqQjS4aZE4YzHy/OHceaUIFNxXuXHfQcYNq9ZN3OObXymKwmTOFjV4
        bysmRsX/GzzMtvVRaX1QSSdChQQZdIkGYh956R8+fl4/BS7L5/FHQ3tKowN68YJX2NdQ1f
        uMsHgxN3HFOpI5dmMQyF9uwRgLyrhq8=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-uDCS5FqHOTSHIKMMUzKoGQ-1; Mon, 28 Feb 2022 21:44:53 -0500
X-MC-Unique: uDCS5FqHOTSHIKMMUzKoGQ-1
Received: by mail-io1-f71.google.com with SMTP id i19-20020a5d9353000000b006419c96a6b4so9739280ioo.23
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=qXtrRIzQbye/CXgfPdiL0RG6c42xYE0c4sxiODxwnH0=;
        b=vJ/KhG28S0DHwbQCPvLYSls69yCd7SH7GmH4Nm5U3APrs58US/GoodasYnOmekoKbC
         F0cApblTxOiKrwiT8ZGsx4I7BuEKGnOvzqYM2J2oAUrvo+DHomWxJ8ERONhUnFQrkzrV
         URHp8fI/lWY7k8xLy2KrsKDsfYTTQqHKBh1J77AyMoq03H4ERIBqjFRsMW//7BJmQX7z
         WBmXqiqkG85QM+WWSoWHiOi5WVo/mYMscSkV+F4+U0efQ8UwP2cuiKM+bkuKy90npAT1
         yDU6ofKElyhi7THwPcUFjMSMvGyTvFSjzGHWppAbRoIcPxrAFaXo/Kp36KK7AYuquN79
         svzQ==
X-Gm-Message-State: AOAM532RvOjlGbEzYtQgttx3c3eo6O8vhF1jCX3FqA8/4dqg2Ub8awX1
        LMOEDmhCh+SXM9HlB+0ZPA9OXyukueRIO0JoIqp0ppjb+iJAbn3yzuvyGMnyP662O6BqakxsXjl
        +rqhN1fPDHO1iPbJ5QNeI
X-Received: by 2002:a05:6638:584:b0:311:9d1c:64b with SMTP id a4-20020a056638058400b003119d1c064bmr20162260jar.158.1646102692111;
        Mon, 28 Feb 2022 18:44:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxTbTRJoncHx3es57K0JDXbPpZw9p7ijEFTAGXngFCdZ7aIzN4DTwNYZpqe7ghRIedjaoYtw==
X-Received: by 2002:a05:6638:584:b0:311:9d1c:64b with SMTP id a4-20020a056638058400b003119d1c064bmr20162241jar.158.1646102691791;
        Mon, 28 Feb 2022 18:44:51 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id y18-20020a056e02129200b002c26a6c9478sm7257168ilq.68.2022.02.28.18.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 18:44:51 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <f7ef2ef7-710e-6f96-04e9-68fcd165e1ec@redhat.com>
Date:   Mon, 28 Feb 2022 20:44:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <20220226025450.GY8313@magnolia>
 <2476cebf-b383-9788-4222-be918aa7a077@sandeen.net>
 <20220301022115.GB117732@magnolia>
In-Reply-To: <20220301022115.GB117732@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/22 8:21 PM, Darrick J. Wong wrote:
> On Mon, Feb 28, 2022 at 03:44:29PM -0600, Eric Sandeen wrote:
>> On 2/25/22 8:54 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> ...
>>
>>> Hence we increase the ratio by 16x because there doesn't seem to be much
>>> improvement beyond that, and we don't want the log to grow /too/ large.
>>> This change does not affect filesystems larger than 4TB, nor does it
>>> affect formatting to older formats.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> ---
>>>  mkfs/xfs_mkfs.c |   12 +++++++++++-
>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 96682f9a..7178d798 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -3308,7 +3308,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>>>  
>>>  	/* internal log - if no size specified, calculate automatically */
>>>  	if (!cfg->logblocks) {
>>> -		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
>>> +		if (cfg->sb_feat.bigtime) {
>>
>> I'm not very keen on conditioning this on bigtime; it seems very ad-hoc and
>> unexpected. Future maintainers will look at this and wonder why bigtime is
>> in any way related to log size...
>>
>> If we make this change, why not just make it regardless of other features?
>> Is there some other risk to doing so?
> 
> I wrote it this way to leave the formatting behavior unchanged on older
> filesystems, figuring that you'd be wary of anything that could generate
> bug reports about old fs formats, e.g. "Why does my cloud deployment
> image generator report that the minified filesystem size went up when I
> went from X to X+1?"

We might run into that, but I'm perhaps naively willing to tell people that
if they were hard-coding reverse-engineered filesystem heuristics to the
nearest kilobyte, too bad so sad, they were doing it wrong.

> So now that I've guessed incorrectly, I guess I'll go change this to do
> it unconditionally.  Or drop the whole thing entirely.  I don't know.
> I'm too burned out to be able to think reasonably anymore.

I (maybe also naively) think it's reasonable to increase the log size for
small filesystems, given that they often as not become large filesystems
these days, and the ultimate % increase in size will be negligible.

(It's somewhere on my todo list to figure out how various products and
provisioning mechanisms actually create, transport, and expand these
minimized images, to see what the requirements really are ...)

> Frankly, I don't have the time to prove beyond a reasonable doubt that
> this the problem is exactly as stated, that the code change is exactly
> the correct fix, that no other fix is more appropriate, and that there
> are no other possible explanations for the slowness being complained
> aobut.  I really just wanted to do this one little thing that we've all
> basically agreed is the right thing.

I do agree. I just think that if the concern is a distro noticing the
difference, then the distro can carry the patch to get rid of that difference.
That's something I have had to do as well a times. With my upstream hat on, I
would rather keep distro version concerns out of the upstream patch, is all.

> Instead I'll just leave things as they are, and consider whether there
> even is a future for me working on XFS.

I'd miss you a lot if that happened. :(

-Eric

> --D
> 
>> Thanks,
>> -Eric

