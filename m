Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A687DC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 02:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B53E20718
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 02:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXRjf4Vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfKYCaM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Nov 2019 21:30:12 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:40051 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfKYCaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Nov 2019 21:30:12 -0500
Received: by mail-pj1-f47.google.com with SMTP id ep1so5873970pjb.7
        for <linux-xfs@vger.kernel.org>; Sun, 24 Nov 2019 18:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHsrrCP/dDoSic9xBGsHmnD9rTd6Vi0ZL/G6rRnZUdk=;
        b=mXRjf4VhT8lz5FFXYLzosMNOomkFcnBq3Ap7/FXf9dHvXJpjE0Sy693FP0SDeIRM97
         Qqz97cB8hV52z0WmNL7E+1yIQ9gn2d3pNVHg27r1l8kBfxGvFOjPAZRaNbvIFkW5lR9v
         FIxAyRBoC+Q1zMXPO6Ck9S3e2It7aB5oDP76NOWTsfzO/wZqsekodzzE9O8/ynZLkhG+
         9JTucKOwKh26V2UWah2UQq/kE47LaEtj0lLaecNo2lBFDxDMKgiHpix3NKw4ZjY4dpoe
         wylz9FwDO1Fpy4IDxo7b2MYtOgFqlW12ntAP2F0KMyNYmgoA2tCCc+Nicb04T6ks/+0c
         NfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IHsrrCP/dDoSic9xBGsHmnD9rTd6Vi0ZL/G6rRnZUdk=;
        b=mQTEnngL1SLIyfwi6pThQNefITntBdpMICyYTKIDeKmDUlPrTkwtvMVzvRWnlgyAGM
         6QtbmkXAsiUvvFcwqS+q8mRnOgVIcz6q9G2xvzax8RXUpSXwVupav8qTnz7xJ8oLmmVO
         iD4B51bqJfMc3uIHLGfpUfXiWRGYON0MIQFxY1d4pVH7vnoC+/OGjygDX+JDhbXRLT0f
         UpH8F2UOgGoYen0sFyMQLHfueUqeeck9JlPiifhigIqWOWjPYRMtsUShwb4M1uDHpd4d
         9HZeH05GhE1P7tVO9PBIZ0AenoB1hou9OsvY4l4ZDhsq0ZMSl+OHE2kuHP+QQ0En0Fti
         fg0A==
X-Gm-Message-State: APjAAAUISq9dC1OTFHpdB9qm4GVgEk3v1FTJBG1azwr/DTNyrsdgKdIP
        laLVmNg1pNC4wlK3zPCGKF6FCQe9
X-Google-Smtp-Source: APXvYqzKbis7kOrp0jzSr3WUU7MjN7Ifs9YAO07X5/yuPEFyL2plc9ajL1Xn6yuzTIrCB1nQt+jn+g==
X-Received: by 2002:a17:90a:1424:: with SMTP id j33mr36662959pja.2.1574649011073;
        Sun, 24 Nov 2019 18:30:11 -0800 (PST)
Received: from [192.168.1.74] (cm-58-10-155-5.revip7.asianet.co.th. [58.10.155.5])
        by smtp.gmail.com with ESMTPSA id o23sm6069290pgj.90.2019.11.24.18.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Nov 2019 18:30:10 -0800 (PST)
Subject: Re: Bug when mounting XFS with external SATA drives in USB enclosures
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
 <2543ac40-63ba-7a33-8ec5-2ef0797c6cc6@sandeen.net>
 <4728bdc7-3f6e-9abf-34a5-712156c40db3@gmail.com>
 <9ee09a97-b3a1-7bf9-43f2-ed2b47e35dc5@sandeen.net>
From:   Pedro Ribeiro <pedrib@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pedrib@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ba5d4b63-84f7-c818-460d-44a421039526@gmail.com>
Date:   Mon, 25 Nov 2019 09:30:05 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9ee09a97-b3a1-7bf9-43f2-ed2b47e35dc5@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 25/11/2019 02:16, Eric Sandeen wrote:

> Hm that doesn't make sense; f8f9ee479439 introduces kmem_alloc_io
> with 3 arguments.  2 arguments to kmem_alloc_io, missing the alignment
> mask, would be a problem.
> 
>> return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
>> return kmem_alloc_io(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);
>>
>> Do you think it's safe to keep these 4 patches on top of the 5.3.12
>> tree? So far it all looks fine, filesystems mount and work fine.
> 
> Yes, but ... they should probably be applied correctly.  A quick test here
> seems to show the three I suggested apply to 5.3.12 cleanly.
> 
> -Eric
> 

You're right, my bad, I applied them in order and now they work fine. I
guess there's no point in fixing this in stable since 5.3 is not a long
term kernel and the fix is already in 5.4?

Regards,
Pedro
