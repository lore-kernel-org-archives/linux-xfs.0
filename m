Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF549C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 23:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355054AbiFUXOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 19:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354574AbiFUXOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 19:14:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61D282E6B5
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 16:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655853240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1EmJn2Z89xIQvz/S7EOoHLqWRRLZgCARA1IvNVEkIg=;
        b=Jm3sgTBVcLCqb4xNn6DP7HnaXfOLk2G9gy0r5B/dbzxivt3adwb6i0lSK+PtpNXJ7TDgUC
        wTPrYRLAKgOrKNSS6Q9UCjs2L+VvPSiCURSh4Mq6P5nzZvnT+skWdwMuxWByAh83K80iyd
        hJLtTX4N0xASCQretcfknQwhfmumit4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-RMFnCrSrNJ2VaYX8fSutHA-1; Tue, 21 Jun 2022 19:13:59 -0400
X-MC-Unique: RMFnCrSrNJ2VaYX8fSutHA-1
Received: by mail-il1-f197.google.com with SMTP id l4-20020a056e021c0400b002d92232d76dso2972332ilh.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 16:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H1EmJn2Z89xIQvz/S7EOoHLqWRRLZgCARA1IvNVEkIg=;
        b=ZKnigyNaeu+VW0FrEwRn/nJOlZsOWKGcz3TQWLsHUrNXEcZgzIxre2ngsrMqB9+swj
         5jxa/Y3UkvPYWN6GTiZ96OSl7lijWXhhd8YyvmBkVOAjS5uFzFjxqhSbkSuDzx9x6cvO
         3gcEK1ssMv1azzpv9/hLIyTzBJeddK16/chePz5nJvKVQhLFowwtW22qP43UhueKFZbz
         iih4fqGno+e3Mw2u8O4ng41WvAV+CzrRNDs3aJDVEB7beQdq8D2QA48yEAF181GOg2Ds
         CSpFQV/6KYENRFqoOqVFqSZ4bdZSgE4T60OHVnvseeyn8B1JlwIsamqy6byTR7FCajif
         5neg==
X-Gm-Message-State: AJIora9M/awAXE6oVeTQfaW38oUdnvvK0MUIrBYjOn15HEli6XD9doIg
        2wY5uRruKzUi92gBnRWhhDO4+1uIFmSrTS/f8Cikln3cpup3t/9Zmm1VxYF6lBjyhseEa75yHKd
        2BEglzGqBywXeFWsfVRn1
X-Received: by 2002:a05:6638:13d2:b0:331:c4f7:770c with SMTP id i18-20020a05663813d200b00331c4f7770cmr388083jaj.110.1655853238389;
        Tue, 21 Jun 2022 16:13:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tiHMBiGNXGT2MPWnjTi/GQdNlnwwSX+EkCo4oMju2d8lG94M7EEJ62M79dsPe27ImQhcJRcQ==
X-Received: by 2002:a05:6638:13d2:b0:331:c4f7:770c with SMTP id i18-20020a05663813d200b00331c4f7770cmr388064jaj.110.1655853238042;
        Tue, 21 Jun 2022 16:13:58 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id y3-20020a929503000000b002d169fe10acsm8023129ilh.24.2022.06.21.16.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 16:13:57 -0700 (PDT)
Message-ID: <a4648e37-b379-51a6-f64b-d67fb2eb0e53@redhat.com>
Date:   Tue, 21 Jun 2022 18:13:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] xfs_repair: Use xfs_extnum_t instead of basic data types
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
References: <20220621065010.666439-1-chandan.babu@oracle.com>
 <990cd4b5-28c4-770b-6869-7218faf4c685@sandeen.net>
 <20220621230414.GS227878@dread.disaster.area>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20220621230414.GS227878@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/21/22 6:04 PM, Dave Chinner wrote:
> On Tue, Jun 21, 2022 at 05:23:46PM -0500, Eric Sandeen wrote:
>> On 6/21/22 1:50 AM, Chandan Babu R wrote:
>>> xfs_extnum_t is the type to use to declare variables whose values have been
>>> obtained from per-inode extent counters. This commit replaces using basic
>>> types (e.g. uint64_t) with xfs_extnum_t when declaring such variables.
>>>
>>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>>> ---
>>
>> Thanks Chandan - I had rolled something like this into the merge of kernel
>> "xfs: Use xfs_extnum_t instead of basic data types"
>> because it seemed like it should maybe all be done at once.
>>
>> And the tree Dave has already had (some of) these type changes in db/ and
>> repair/dinode.c as part of that patch.
>>
>> On top of that, I added a lot more of these conversions, i.e. to
>> bmap(), bmap_one_extent(), and make_bbmap() in db/bmap.c, 
>> process_bmbt_reclist() in db/check.c, fa_cfileoffd() and
>> fa_dfiloffd() in db/faddr.c ... perhaps I should send you my net diff
>> on top of the tree dchinner assembled, and you can see what you think?
> 
> Just merge what we've already got, then do an audit to check for
> anything that is missing and then commit them.

I've already got the additional updates folded into what I have staged, though.
But I can also push what /I've/ got, and do an audit to fix stuff later, too,
I suppose.

>> But at the highest level, does it make more sense to convert everything
>> in the utilities at the same time as "xfs: Use xfs_extnum_t instead of
>> basic data types" is applied to xfsprogs libxfs/ or would separate patches
>> be better?
> 
> So long as it is converted before the release point it doesn't
> matter. We don't have extent counts of > 2*32 out in the wild yet,
> so as long as the conversions are all sorted by the time 5.19 is
> done then it just doesn't matter how many commits it takes because
> users won't be using the dev tree to repair filesystems with extent
> counts that could overflow a 32 bit counter....

Yeah, that's fair.

Thanks,
-Eric

> Cheers,
> 
> Dave.

