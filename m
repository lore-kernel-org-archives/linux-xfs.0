Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2852DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 14:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FE46103B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 14:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhIQOL0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 10:11:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233735AbhIQOLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 10:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631887802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TY+5cjjtOXLMGk6Ah71l6SEWU61dMBIeT5xM8p+8KR0=;
        b=N3kOAVN2zt/mQZnPr+fDemKaQpzn5baos6RCdxryrPmeg+M3tUAzch7oIpJeaxYamEsEPN
        OENF8ALxGWzwE6odwVPUaVWjvsCpnpF+qBY1lwRA1SG/0fAENVy2GPT2JujoDXNWBgbv1G
        /YKTTVv88Py4H4KQlrlwvZn4JCoZeNQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-M_EXe9xTNrWzPeU5dnLzmA-1; Fri, 17 Sep 2021 10:10:01 -0400
X-MC-Unique: M_EXe9xTNrWzPeU5dnLzmA-1
Received: by mail-il1-f198.google.com with SMTP id x7-20020a920607000000b002302afca41bso21546323ilg.6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Sep 2021 07:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TY+5cjjtOXLMGk6Ah71l6SEWU61dMBIeT5xM8p+8KR0=;
        b=ymUDzAw/rwv7wqByDyFc0GRB7Xas+JFTNJ9ASRC07qTC+gytoclAwUbwXWR6RhtXjc
         fDb5lF1xENDWyQGg9IEbD4rUvAd0n40OcfJlcpQDYrjh0MgJZVone1kAXrs4DTKcn9N0
         0dM2LLh9RleGSwYTEqb5GeNGgtB8RsQaCNCt8Rp4AJeq+Z1CrqktmeyMBuRgevt+Bpps
         XvUSUPnEgAdcv5ywhShsh/RHTuHY4mdwXOp9CfIQTUkE0M/2JfYdsh83eRqOdzVxTMaQ
         UbBlH3vP9mpWmsTTfKh1yItgD6nGndjQqFrV7o91McaKvbZewfyi/C7HbtidC+aVxuHL
         f7tA==
X-Gm-Message-State: AOAM533i/A5LxhIT/VsjNjWFyCwWJKqAQFbcocMglsk7R7FL1MI1Mly7
        QCP35ZFiXadaRxIoY8thf9/h2Ng9ehBrsAHnE7MJFdosWofDFEpYQAUeLTAdGixoTrf8ruEQ5b0
        OetsDXQDFe1tOshpybZ/P
X-Received: by 2002:a05:6638:2104:: with SMTP id n4mr8923958jaj.111.1631887800015;
        Fri, 17 Sep 2021 07:10:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm9IC36vEywfx+sz4ATVHgsWJakFIiFwIeDkiTlzPLoL0Wy3A7Ida5gfJjDR8YXmMbBcgHFg==
X-Received: by 2002:a05:6638:2104:: with SMTP id n4mr8923909jaj.111.1631887799266;
        Fri, 17 Sep 2021 07:09:59 -0700 (PDT)
Received: from liberator.local (h114.53.19.98.static.ip.windstream.net. [98.19.53.114])
        by smtp.gmail.com with ESMTPSA id c13sm3459309iod.25.2021.09.17.07.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 07:09:58 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] ext2: remove dax EXPERIMENTAL warning
To:     Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
 <1631726561-16358-4-git-send-email-sandeen@redhat.com>
 <20210917094707.GD6547@quack2.suse.cz> <YUSRHjynaozAuO+P@infradead.org>
Message-ID: <88613c7a-5619-c038-16ac-f6383ad7943f@redhat.com>
Date:   Fri, 17 Sep 2021 09:09:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YUSRHjynaozAuO+P@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/17/21 7:59 AM, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 11:47:07AM +0200, Jan Kara wrote:
>> On Wed 15-09-21 12:22:41, Eric Sandeen wrote:
>>> As there seems to be no significant outstanding concern about
>>> dax on ext2 at this point, remove the scary EXPERIMENTAL
>>> warning when in use.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Agreed. Do you want my ack or should I just merge this patch?
> 
> Please do not merge it.  The whole DAX path is still a mess and should
> not be elevated to non-EXPERMINTAL state in this form.

Hi Christoph, "a mess" is tough to work with. What work remains before
we can lift the warning?

-Eric

