Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA1BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F4264E05
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhA1Vw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:52:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhA1Vww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:52:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611870685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SL+sVBLw54pAOHWFRrnIXb3MvEtbj8SwUzn03zgNnhM=;
        b=SQT8ba9dlRRtLjTCXhjFd8J4V2JFvOmd3cTAh112KAMHhK04zE63+iRZcEI7z5Kvs/C5h+
        bBHsVBjQvVdojQh7vElIvB5NBg6HqJCkhyojPZIXGXew+PYNuYooPJGargDLoh0m0PnOtk
        5VzmW0wEs2d9jJzmMj552jAnedzeWm0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-Dy1ZYoBMM5W_dXEQCrXAKA-1; Thu, 28 Jan 2021 16:51:24 -0500
X-MC-Unique: Dy1ZYoBMM5W_dXEQCrXAKA-1
Received: by mail-pg1-f199.google.com with SMTP id 26so4791022pgl.2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 13:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SL+sVBLw54pAOHWFRrnIXb3MvEtbj8SwUzn03zgNnhM=;
        b=C3JSxFrTYah93mok+tDiRqEkZf/1goOQ/UE06vEk4C7dt1E4w8s56eO9DpBhiHP8L5
         nsdK8mgfWUCtzTlpo96ta0qot658UtrF1PrpPKNk9Sk8qyrrg8utQBPlayVJ2UD42x4z
         Hrr2JbOz03mO7o6VAejhKKlvY1Dh/TlFb2zNKFaiqAYeHWCBr9uv+IJR8OxUMMomC3PD
         mR+6k5q4b/gFIJAkKSHus7JcNTfoJTmG5vGtFhCWxFHxdBPrh8vEifEfXWNRLj01gjPr
         6O2cMZnZkdhO2HPv+ewtcibnbam09hJXBrZa98sXHONdHTBznUFhAByU/FIIwgWkiscI
         acNg==
X-Gm-Message-State: AOAM531adcldSvxT3zv06085Hi/ocJAMwRP6QpQw7iPw365Yr2f+ZW5l
        nvCiElv/j0+9o21wQYcyVLcQIEEbYLRWjDyseysXeDj2jIlPiRfNssrya2hMjyK9K3yDl/lqilI
        RwEhegMaecaIWtUa0xVzJ9khC4+r+WVON0YsiEy0ZhEuHY7rS63rFARsXNtpEmg+6TBBQtLY2
X-Received: by 2002:a62:7b8a:0:b029:1bb:4a06:bb57 with SMTP id w132-20020a627b8a0000b02901bb4a06bb57mr1212525pfc.47.1611870682904;
        Thu, 28 Jan 2021 13:51:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/nmopdvU2iDcaMue/XhmVxX3HWluv7wmGqHglZ97A9Asa7b+q7NJtSl2VFAxFheY4jRPMMQ==
X-Received: by 2002:a62:7b8a:0:b029:1bb:4a06:bb57 with SMTP id w132-20020a627b8a0000b02901bb4a06bb57mr1212510pfc.47.1611870682545;
        Thu, 28 Jan 2021 13:51:22 -0800 (PST)
Received: from ?IPv6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id 68sm7178519pfg.90.2021.01.28.13.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 13:51:21 -0800 (PST)
Subject: Re: [PATCH 1/2] xfs_logprint: print misc buffers when using -o
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210128073708.25572-1-ddouwsma@redhat.com>
 <20210128073708.25572-2-ddouwsma@redhat.com> <20210128173513.GQ7698@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <0fd23532-5e5f-21db-678d-3dae11fd653b@redhat.com>
Date:   Fri, 29 Jan 2021 08:51:18 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128173513.GQ7698@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/01/2021 04:35, Darrick J. Wong wrote:
> On Thu, Jan 28, 2021 at 06:37:07PM +1100, Donald Douwsma wrote:
>> Logprint only dumps raw buffers for unhandled misc buffer types, but
>> this information is generally useful when debugging logprint issues so
>> allow it to print whenever -o is used.
>>
>> Switch to using the common xlog_print_data function to dump the buffer.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>  logprint/log_misc.c      | 19 +++----------------
>>  logprint/log_print_all.c |  2 +-
>>  2 files changed, 4 insertions(+), 17 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index c325f046..d44e9ff7 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -392,23 +392,10 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>  		}
>>  	} else {
>>  		printf(_("BUF DATA\n"));
>> -		if (print_data) {
>> -			uint *dp  = (uint *)*ptr;
>> -			int  nums = be32_to_cpu(head->oh_len) >> 2;
>> -			int  byte = 0;
>> -
>> -			while (byte < nums) {
>> -				if ((byte % 8) == 0)
>> -					printf("%2x ", byte);
>> -				printf("%8x ", *dp);
>> -				dp++;
>> -				byte++;
>> -				if ((byte % 8) == 0)
>> -					printf("\n");
>> -			}
>> -			printf("\n");
>> -		}
> 
> Nitpicking: One patch to collapse this into a xlog_recover_print_data
> call as a no-functional-changes cleanup, then a second patch to make the
> buffer dumps happen any time -D or -o are specified.
> 

ok

> TBH the sb/agheader decoders probably need some serious updating to
> handle newer fields.  It's also unfortunate that xfs_db doesn't know how
> to decode log buffers; adding such a thing would be a neat way to enable
> targetted fuzzing of log recovery.
> 

The free space accounting probably isn't the most useful thing to be dumping
because of the way they're re-calculated from the AG headers during recovery,
but I'd been looking into a sb free space issue and this was confusing me.

It could dump all the fields like xfs_db does, but that would be very verbose. 

By decode log buffers do you mean more of the raw log buffer?

> --D
> 
>>  	}
>> +
>> +	xlog_recover_print_data(*ptr, be32_to_cpu(head->oh_len));
>> +
>>  	*ptr += be32_to_cpu(head->oh_len);
>>      }
>>      if (head && head->oh_flags & XLOG_CONTINUE_TRANS)
>> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
>> index eafffe28..2b9e810d 100644
>> --- a/logprint/log_print_all.c
>> +++ b/logprint/log_print_all.c
>> @@ -176,8 +176,8 @@ xlog_recover_print_buffer(
>>  		} else {
>>  			printf(_("	BUF DATA\n"));
>>  			if (!print_buffer) continue;
>> -			xlog_recover_print_data(p, len);
>>  		}
>> +		xlog_recover_print_data(p, len);
>>  	}
>>  }
>>  
>> -- 
>> 2.27.0
>>
> 

