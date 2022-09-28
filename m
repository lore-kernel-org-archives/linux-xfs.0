Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70C3C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 23:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI1XM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiI1XM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 19:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655367DF55
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664406774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6uMT0J+3lHNij0H9w+7ThK1cPj6X4GXzu34a2DxQsM=;
        b=SCzPPTb4b11sITP9jJCwYWcwG1Ao3NciYcXU+QdU0dUPftAb/ZSfYRUZBjl3AYcJe7ub/m
        Vbk0I78Exovzwa9PiCs5om//If6GIFAQZYhiK2z5M5+P60kKVBcbcUQFwJXYNKLc+wTu/n
        vlWw16n62/Piu00BLbPZLUxxWVAIj0A=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-101-J3-optffOCyKeD-pGd9QPA-1; Wed, 28 Sep 2022 19:12:53 -0400
X-MC-Unique: J3-optffOCyKeD-pGd9QPA-1
Received: by mail-pj1-f71.google.com with SMTP id z9-20020a17090a468900b00202fdb32ba1so1627120pjf.1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=o6uMT0J+3lHNij0H9w+7ThK1cPj6X4GXzu34a2DxQsM=;
        b=VxkvKK7kIxIr6V/e8Bl/bGfFBmwQPUF/ShEVu/B6nhkqX5L7LQi7BSNYucHrin4gxB
         /Fp4e6XHDcfSt1Rl95TCo+ZHpHxPhMZodNHqEJbe/jYWM/+O88qsRZTfdUkM250hroeO
         68V//S0wfFf9teScbMCdOFPInE8FdvA/9Vj/XSxMYDM+5hCX2ilequuvVrSPGVCUd+l0
         LtOIr05jzharExBuR9Cqm+hqWbHJF19JHyksCsnI9fbXEl9SSOi7p1fp8OaP8ikZ+gYu
         paKxKL6+x1cKVsjbIzVRlDnYxwgwU7XhxmzZKupkRVDzhgIBwPoZsnG/1Bhfc4C4Jg1Q
         /Y7w==
X-Gm-Message-State: ACrzQf0JF3t14CjBifbWDUA42uKvW9zGXG+CJIlfqae4NgM+wS5qmwEh
        VKTlGsnLcu9QkSW7wuPBLkIDHO88l5L5bXlqV7BH2ZjRhmuEbEtxTTl21GE1ZnU+mXJskpgO3TQ
        RpEB6fVqHvoTFuWUQUGDF
X-Received: by 2002:a17:90b:4f4b:b0:200:876b:c1c8 with SMTP id pj11-20020a17090b4f4b00b00200876bc1c8mr13280391pjb.32.1664406772016;
        Wed, 28 Sep 2022 16:12:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM60iw8zufljrslYtNTbKpHzvB4Wv1OUThD8zrA8lqR0IQlp/BTskpgtRABgFAZwb4DoniFXww==
X-Received: by 2002:a17:90b:4f4b:b0:200:876b:c1c8 with SMTP id pj11-20020a17090b4f4b00b00200876bc1c8mr13280369pjb.32.1664406771781;
        Wed, 28 Sep 2022 16:12:51 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902ce0c00b00176e8f85147sm4294664plg.83.2022.09.28.16.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:12:51 -0700 (PDT)
Message-ID: <4a2690eb-af8a-2c32-3afe-1f24429bd2dd@redhat.com>
Date:   Thu, 29 Sep 2022 09:12:48 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 3/3] xfsrestore: untangle inventory unpacking logic
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-4-ddouwsma@redhat.com> <YzRnIKSjxuDEcG8V@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <YzRnIKSjxuDEcG8V@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/09/2022 01:24, Darrick J. Wong wrote:
> On Wed, Sep 28, 2022 at 03:53:07PM +1000, Donald Douwsma wrote:
>> stobj_unpack_sessinfo returns bool_t, fix logic in pi_addfile so errors
>> can be properly reported.
>>
>> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
>    ^ Needs correct capitalisation.
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Will fix for all three patches.

Thanks again,

Don

> 
>> ---
>>   restore/content.c | 13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/restore/content.c b/restore/content.c
>> index b3999f9..04b6f81 100644
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
>>   			 * desc.
>>   			 */
>>   			sessp = 0;
>> -			if (!buflen) {
>> -				ok = BOOL_FALSE;
>> -			} else {
>> -			    /* extract the session information from the buffer */
>> -			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
>> -				ok = BOOL_FALSE;
>> -			    } else {
>> +			ok = BOOL_FALSE;
>> +			/* extract the session information from the buffer */
>> +			if (buflen &&
>> +			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
>>   				stobj_convert_sessinfo(&sessp, &sessinfo);
>>   				ok = BOOL_TRUE;
>> -			    }
>>   			}
>> +
>>   			if (!ok || !sessp) {
>>   				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
>>   				      "on-media session "
>> -- 
>> 2.31.1
>>
> 

