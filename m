Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABA4C4338F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 16:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 185DF60F94
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 16:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhHCQPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:15:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232696AbhHCQP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Aug 2021 12:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628007316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUcmhz7YDMrRJ4P8lEZX1x6bjV0DSPQPPp1jqB0XURc=;
        b=ZDIFZVCfn5iuVQNbEQ4gFZzy80Uw7RieATnh3tP7o1/7+kqf1M0zt40D3P7W1WN0rAULuU
        UpMMYWDWlsUcc6O+ScDy1/riF2F2+he20vL1pZrfQRpxLPtELhdxKs+hfIE7/MaEjSUtyN
        bssyBWbfawsv6gJn+AwklIhIJCMkNuk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-jAWNmk-VO5eHNfBZD3MLyQ-1; Tue, 03 Aug 2021 12:15:15 -0400
X-MC-Unique: jAWNmk-VO5eHNfBZD3MLyQ-1
Received: by mail-wm1-f69.google.com with SMTP id a197-20020a1c98ce0000b029025831695a2eso3198960wme.4
        for <linux-xfs@vger.kernel.org>; Tue, 03 Aug 2021 09:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gUcmhz7YDMrRJ4P8lEZX1x6bjV0DSPQPPp1jqB0XURc=;
        b=tTbzY5Zwyx+Pd8FYN539qS1M+4E3axNygSrk48Zdp9kcoEk42/JHuchJJOmja5iZvF
         9HD7nAiTwldteutqL8kRhOPjiOgCu70w7Yr71EIGgMJO+WRhT0E+bZ2dYb+7u7HHioUf
         4eo1H2aUH1hUpLTfJN5ruo1D8D/DhVCLSWKK/u5QdEc24QPLWQMWXX93L6cfdp2TXpUi
         Qo6Stoih0qaeR66I73EtqrKmtMl+dBt7jJiRiLr4SA97rCo9D+tyfAB7UWpYJZ2Q2YvQ
         yegltEALVBMv6qlK8kTH0le1SDy/sfywfft1h75l++UYB8DMF+ZgoAXWQyWlamCi8Ygo
         li2Q==
X-Gm-Message-State: AOAM531jz/b5K6vanJZqivBBsA1pO1oNuj/gwkw20YDwABPJo1s5qrVP
        ZG2WyPYvEHKttYTxt4WaWvaemKAXtzuCBRBRGNBS4FRDh8Hr/odSlLZXmwWBDI1mHbHvZtamV4y
        KxoovWQ9NNqGpuVzjLpCVEjDfHEBrCWr2KrwTqeXWHVsCaGdIQAZziLFkEGW76mkIhopWZ6M=
X-Received: by 2002:a05:600c:4649:: with SMTP id n9mr5204390wmo.168.1628007314388;
        Tue, 03 Aug 2021 09:15:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7YYOM8Ojf/61iPFLM+b5G7blTu/t4leMI3oDsGVdQ4ozmRYt7/FIZDPfG8l/af8gntVMYlg==
X-Received: by 2002:a05:600c:4649:: with SMTP id n9mr5204363wmo.168.1628007314098;
        Tue, 03 Aug 2021 09:15:14 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id s13sm3020154wmc.47.2021.08.03.09.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 09:15:13 -0700 (PDT)
Subject: Re: [PATCH 2/8] xfsprogs: Rename platform.h -> common.h
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210802215024.949616-1-preichl@redhat.com>
 <20210802215024.949616-3-preichl@redhat.com>
 <20210802223358.GK3601466@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <ce90e2cc-5098-9e9a-c083-16bb73eddd0b@redhat.com>
Date:   Tue, 3 Aug 2021 18:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802223358.GK3601466@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/3/21 12:33 AM, Darrick J. Wong wrote:
> On Mon, Aug 02, 2021 at 11:50:18PM +0200, Pavel Reichl wrote:
>> No other platform then linux is supported so rename to something more
>> common.
>> ---
>>   copy/xfs_copy.c                  | 2 +-
>>   libfrog/{platform.h => common.h} | 0
> This is confusing, we already have a scrub/common.h.  Renaming files
> breaks git blame; why change them?
>
I wanted to rename the file because it contains functions that were 
supposed to be multi-platform (at least that's my understanding) but it 
never became the case. So since we are trying to get rid of the obsolete 
'platform_' prefix I thought that more proper name for the file should 
be chosen. However, I respect the git blame consideration and I'm fine 
with keeping the name.

