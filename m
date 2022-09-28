Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F40C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 23:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiI1X2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiI1X2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 19:28:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06590E1189
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664407712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3iHzwbV//k2POEmIrZUBVLh879pfSwpqpVwDYb+FWcg=;
        b=ezxArtuSmXPSqMKDMnp+vRXjNXkJk1fOAYjCQsa+w3h6Divv/ne0ems979tmJP4oohVj38
        E8ofE/aivgS52SHd+/S9ajEqS+hh6oIcK9/Z05G7yJoPXb0prT6YfdveW0qwYL3vTWg6C+
        gk0ienDDx7N1t0NMIZ7Je8T4WJA99a8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-gJJb-9JyMbqIlsi7X7MMjg-1; Wed, 28 Sep 2022 19:28:30 -0400
X-MC-Unique: gJJb-9JyMbqIlsi7X7MMjg-1
Received: by mail-pg1-f199.google.com with SMTP id x23-20020a634857000000b0043c700f6441so8061099pgk.21
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3iHzwbV//k2POEmIrZUBVLh879pfSwpqpVwDYb+FWcg=;
        b=e73rwJwLF9B1eewA+leaCmVCoei1jPOlDPKVlcJVDz244CipgUVwB1+KEtXxES3I64
         ln+W7/VvasEdVcUgaZpav+MoHZZ2D+SVk2llRS6xiLUYECSrbcnR/5z67ubDkg+wAvMN
         22QPJoyMYSjd0Sv3XZ953aGQtEVesIcwXGATiwDYLLwHU1q+u0wUMqClPnrdHn9251bA
         0uw29FJIGDBmycKiYwbiq0XZJahb0xT1sB4WymBg9Eb6Pfrw/xSG0nmQMMNqems0rTTs
         +5yJlLW4zpFat6Ub5T7htlwdf7VYTQhk9nglsTvTc7t0RohHqmZ1Wpn13r3sUz9YiKdy
         tp2A==
X-Gm-Message-State: ACrzQf1TixwINxRpU2ZswJayu8QjV71tUGPG0sCFoJ0elUE8nPfosZY4
        RofFIveVmdE4sGa4OLGGQyG3eTAB00sVbCsj1vu+eoLvUQ1cGd2nJ9ao3k61z77lFToA+L8axqK
        CO8XcxUryxLVUwlQrThym
X-Received: by 2002:a17:90b:4b04:b0:203:9c4e:7cc1 with SMTP id lx4-20020a17090b4b0400b002039c4e7cc1mr12728531pjb.16.1664407709300;
        Wed, 28 Sep 2022 16:28:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5f1P2mO6tQWjoZbkxX3i+OsvEaJj2E/frdfp+EcjARvdrPsMSIBMwwZ4q8sbjolH0gpxkOCg==
X-Received: by 2002:a17:90b:4b04:b0:203:9c4e:7cc1 with SMTP id lx4-20020a17090b4b0400b002039c4e7cc1mr12728511pjb.16.1664407708980;
        Wed, 28 Sep 2022 16:28:28 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id r18-20020aa79892000000b00536816c0d4asm4685419pfl.147.2022.09.28.16.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:28:28 -0700 (PDT)
Message-ID: <b3197f6d-a762-26d5-ca67-3a220fe21b9a@redhat.com>
Date:   Thu, 29 Sep 2022 09:28:24 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Content-Language: en-AU
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-3-ddouwsma@redhat.com> <YzRm86tcCc2m+YeX@magnolia>
 <244f6cfb-41f1-ceea-2cc5-c44dcaa14515@redhat.com>
In-Reply-To: <244f6cfb-41f1-ceea-2cc5-c44dcaa14515@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/09/2022 09:12, Donald Douwsma wrote:
> 
> 
> On 29/09/2022 01:23, Darrick J. Wong wrote:
>> On Wed, Sep 28, 2022 at 03:53:06PM +1000, Donald Douwsma wrote:
>>> stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
>>> this clearer with respect to the session header and streams processing.
>>>
>>> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>> ---
>>>   inventory/inv_stobj.c | 13 +++++++------
>>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>>> index 5075ee4..521acff 100644
>>> --- a/inventory/inv_stobj.c
>>> +++ b/inventory/inv_stobj.c
>>> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>>>           return BOOL_FALSE;
>>>       }
>>> +    /* get the seshdr and then, the remainder of the session */
>>>       xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>>>       bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
>>> -
>>> -    /* get the seshdr and then, the remainder of the session */
>>>       s->seshdr = (invt_seshdr_t *)p;
>>>       s->seshdr->sh_sess_off = -1;
>>>       p += sizeof(invt_seshdr_t);
>>> -
>>>       xlate_invt_session((invt_session_t *)p, (invt_session_t 
>>> *)tmpbuf, 1);
>>>       bcopy (tmpbuf, p, sizeof(invt_session_t));
>>>       s->ses = (invt_session_t *)p;
>>>       p += sizeof(invt_session_t);
>>>       /* the array of all the streams belonging to this session */
>>> -    xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
>>> -    bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>>       s->strms = (invt_stream_t *)p;
>>> -    p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
>>> +    for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>>> +        xlate_invt_stream((invt_stream_t *)p,
>>
>> Nit: trailing whitespace                        here ^
> 
> nod
> 
>>
>>> +                  (invt_stream_t *)tmpbuf, 1);
>>> +        bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>> +        p += sizeof(invt_stream_t);
>>
>> Ok, so we translate p into tmpbuf, then bcopy tmpbuf back to p.  That
>> part makes sense, but I am puzzled by what stobj_pack_sessinfo does:
>>
>>     for (i = 0; i < ses->s_cur_nstreams; i++) {
>>         xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
>>         sesbuf += sizeof(invt_stream_t);
>>     }
>>
>> Why isn't that callsite xlate_invt_stream(&strms[i], ...); ?
> 
> Thanks! Yes, that's wrong, like the existing code it only worked/works
> because there's only ever one stream. From the manpage "The third level
> is media stream (currently only one  stream is supported)". Will fix.

Or should I just drop this clean-up? I think what I'm saying is right,
but its a clean-up for a feature that cant be used. I doubt anyone is
going to add multiple stream support now, whatever that was intended
for.


> 
>>
>> --D
>>
>>> +    }
>>>       /* all the media files */
>>>       s->mfiles = (invt_mediafile_t *)p;
>>> -- 
>>> 2.31.1
>>>
>>

