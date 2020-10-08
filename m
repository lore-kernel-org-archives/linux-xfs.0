Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882B3C4363A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30E2021897
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M1I3BHDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgJHNzX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 09:55:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729829AbgJHNzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 09:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602165321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ReFMu/5UqeavK/j3nd2j059NXy1ENG5bwiWePTWBtcs=;
        b=M1I3BHDxqBDJPIUC67+UcQ+p2chfHmyh8/ydlpuxX43JU9xdLwS7phfKVCsVuYKfVI50gq
        WiYkAEJiCc/Rh3XkkHlSi5pQm/Kv0DFUhnGKQuvJ78az9NMeVorafk1rCPOdYJrqEpy4Ky
        fa1NrD2tdnZN5d8LSjBxsSa8lUpu4mE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-GIhlQ1YBPl6JRaWcaFhj9w-1; Thu, 08 Oct 2020 09:55:20 -0400
X-MC-Unique: GIhlQ1YBPl6JRaWcaFhj9w-1
Received: by mail-wr1-f69.google.com with SMTP id k14so3211643wrd.6
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 06:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ReFMu/5UqeavK/j3nd2j059NXy1ENG5bwiWePTWBtcs=;
        b=p0xtvrhQAxWFoOYAntWKzK02jhuwWtnA98dxQIlWeqwDRcQaDijqSAEk9Hc5X5LRyf
         nXDtMXzalX/IQDNvHcdXu8bUBq0XxLSm43+rHkJfEWL3HaN0k/UCX1fiYdImwpW/IvT+
         erCpxuATpTXCckjyLDJ5L3jvlYoDSRgdtuooWjwdKta5jZ5I3pOOS9o/wlMq0MjcghQ4
         zdXhQ2N2DWQuAgrTp11uhHL/qW6i88EOHpIOctQI5S3uDlvKC5mynaR9MnuYJk2B5BOJ
         ExUO+z3qNniNmIUdVzUOXdELZp+dYiUYbqFHQ/l/tqyvWFNq5aKAIcRhi5mbPZo4Qjpd
         +ZDA==
X-Gm-Message-State: AOAM531Pugy1InCsDjXDWL4jdrLsf85B8kdN061pfaU5n8wqpy55tLoA
        BuLf8HX3zA6o8eJ+RJnLjpPfzWcelzHCiMAwjW4jgUPMRPNPremLTqwiXEHeoUO+X9a2uZwWPHC
        rzeRANmSnhZyXtcL/Tgun
X-Received: by 2002:adf:a1d6:: with SMTP id v22mr9905520wrv.185.1602165318520;
        Thu, 08 Oct 2020 06:55:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhPf3hLShN3jZAy51xc6TwcXI1jjFGyPxBlYvnq1dUBiinqJK8zmrUfamUR/Uyw5rn9t4O/g==
X-Received: by 2002:adf:a1d6:: with SMTP id v22mr9905502wrv.185.1602165318314;
        Thu, 08 Oct 2020 06:55:18 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id e18sm7388124wrx.50.2020.10.08.06.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 06:55:17 -0700 (PDT)
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
 <20201007012159.GA49547@magnolia>
 <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
 <20201007152554.GL49559@magnolia>
 <4cd57497-4670-f96f-01a0-0c587e77548d@redhat.com>
 <20201007215545.GA6540@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <eebc3029-beb3-5b49-08d4-33ae63085411@redhat.com>
Date:   Thu, 8 Oct 2020 15:55:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201007215545.GA6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


>> Hi,
>>
>> thanks for the comments, however for some reason I cannot reproduce
>> the same memory corruption you are getting.
> 
> <shrug> Do you have full preempt enabled?

Hi, I'm not proud to admit that until now I tested w/o 'CONFIG_PREEMPT=y' :-/
However at least now I can see the bug you hit and test that the proposed change in version #10 fixes that.


> 
>> Do you think that moving the 'rwsem_release()' right before the
>> 'complete()' should fix the problem?
>>
>> Something like:
>>
>>
>> +       /*
>> +        * Update lockdep's lock ownership information to point to
>> +        * this thread as the thread that scheduled this worker is waiting
>> +        * for it's completion.
> 
> Nit: "it's" is always a contraction of "it is"; "its" is correct
> (posessive) form here.

Thanks for noticing. I know the difference...but still I did this mistake. I must focus more next time.

> 
> Otherwise, this looks fine to me.

Thanks, version #10 is on list now.

Bye.

