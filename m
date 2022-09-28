Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0E8C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 23:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiI1XMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI1XMR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 19:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4133A659E8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664406736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8m1iORqfF1S6WbV7xXzWskRMRmC9AhbX5SzvBzFfbpQ=;
        b=MZILYYMDxPaYOixlLOo9uzDtMjRWU8fhEW80y9aOca+pZffmLI/BwAjhF1j0Oq1C2WicTY
        pyPwKsl8ULT9YXTWhL/7RNMChf4czz5FRAGynTiBpzwKYFJEilLF35tP78utDe1ZkwTrz9
        WxBQAs35nzi2L9TNCGBPgddBkUJblK8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-x0W-aCfbOHuI1zDF8LXiqA-1; Wed, 28 Sep 2022 19:12:15 -0400
X-MC-Unique: x0W-aCfbOHuI1zDF8LXiqA-1
Received: by mail-pl1-f197.google.com with SMTP id w14-20020a170902e88e00b00177ab7a12f6so8942420plg.16
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8m1iORqfF1S6WbV7xXzWskRMRmC9AhbX5SzvBzFfbpQ=;
        b=aZx6+jcf0kJ8MXuMFJ3CImw+OTvP25JPKSFaF5t2krN9UhLLCujBiyFBD3qfSiYRzD
         36NJdwmUw2+bp/paSbmMmLhaRxjD62lv+Vy1UnMrbHOnov59VEIm3cANrshzHn0WDsja
         atLPRAk3GID5c3CwZlLJwQVt4CEMxNjz8eTCmjqPuOAD/fZAbPxo+Tyz63G0AymuYrK1
         pZmQguo8BzNAExFLLnEaU7MXfH3Rbrr3/zyQ3fGxSjVEf3EK8Nb+Y79ntwNXDgQU4fOz
         VvVmYDZh0IZ4RlqvJ4oPAik2j3sEIs4GR14DTMVJ/22kY6JSLHt+3OkgqUD9N1FRRQzU
         JLCw==
X-Gm-Message-State: ACrzQf0LyqgXkGoMxb5sLh4b3X6d3FlEu8Qg5+aLuWb6YD6PPFK0bN5y
        djUc29uJyv4HtDIqV44ZMDodgPxte31oK4IKw9QARts0ANTi84TRzwdGtHnq4odfIJ7SQh5lqeM
        Uwub0eBjrPH3ANc5iUSrE
X-Received: by 2002:a63:2c6:0:b0:43c:1f18:a475 with SMTP id 189-20020a6302c6000000b0043c1f18a475mr189290pgc.186.1664406733975;
        Wed, 28 Sep 2022 16:12:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM45Q9FoItLBhnFuc+TAOFS7Zsnbhp/8hKSkVDOKrhgAzUiTrt3+mHG+rmbE6wdRow8L/g8fuQ==
X-Received: by 2002:a63:2c6:0:b0:43c:1f18:a475 with SMTP id 189-20020a6302c6000000b0043c1f18a475mr189272pgc.186.1664406733741;
        Wed, 28 Sep 2022 16:12:13 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a0c0f00b001f2ef3c7956sm2108271pjs.25.2022.09.28.16.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:12:13 -0700 (PDT)
Message-ID: <244f6cfb-41f1-ceea-2cc5-c44dcaa14515@redhat.com>
Date:   Thu, 29 Sep 2022 09:12:09 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-3-ddouwsma@redhat.com> <YzRm86tcCc2m+YeX@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <YzRm86tcCc2m+YeX@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/09/2022 01:23, Darrick J. Wong wrote:
> On Wed, Sep 28, 2022 at 03:53:06PM +1000, Donald Douwsma wrote:
>> stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
>> this clearer with respect to the session header and streams processing.
>>
>> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>   inventory/inv_stobj.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index 5075ee4..521acff 100644
>> --- a/inventory/inv_stobj.c
>> +++ b/inventory/inv_stobj.c
>> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>>   		return BOOL_FALSE;
>>   	}
>>   
>> +	/* get the seshdr and then, the remainder of the session */
>>   	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>>   	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
>> -
>> -	/* get the seshdr and then, the remainder of the session */
>>   	s->seshdr = (invt_seshdr_t *)p;
>>   	s->seshdr->sh_sess_off = -1;
>>   	p += sizeof(invt_seshdr_t);
>>   
>> -
>>   	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
>>   	bcopy (tmpbuf, p, sizeof(invt_session_t));
>>   	s->ses = (invt_session_t *)p;
>>   	p += sizeof(invt_session_t);
>>   
>>   	/* the array of all the streams belonging to this session */
>> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
>> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>   	s->strms = (invt_stream_t *)p;
>> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
>> +	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>> +		xlate_invt_stream((invt_stream_t *)p,
> 
> Nit: trailing whitespace                        here ^

nod

> 
>> +				  (invt_stream_t *)tmpbuf, 1);
>> +		bcopy(tmpbuf, p, sizeof(invt_stream_t));
>> +		p += sizeof(invt_stream_t);
> 
> Ok, so we translate p into tmpbuf, then bcopy tmpbuf back to p.  That
> part makes sense, but I am puzzled by what stobj_pack_sessinfo does:
> 
> 	for (i = 0; i < ses->s_cur_nstreams; i++) {
> 		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
> 		sesbuf += sizeof(invt_stream_t);
> 	}
> 
> Why isn't that callsite xlate_invt_stream(&strms[i], ...); ?

Thanks! Yes, that's wrong, like the existing code it only worked/works
because there's only ever one stream. From the manpage "The third level
is media stream (currently only one  stream is supported)". Will fix.

> 
> --D
> 
>> +	}
>>   
>>   	/* all the media files */
>>   	s->mfiles = (invt_mediafile_t *)p;
>> -- 
>> 2.31.1
>>
> 

