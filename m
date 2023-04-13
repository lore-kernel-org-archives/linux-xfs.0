Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF7AC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjDMLck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjDMLc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F133975A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681385503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIm5iNvrLIrBpXBxl0Ffwy4XMhjO0OH42kfpLYYOzdU=;
        b=Nq3rbDXZFLmF40Mm+Uy+8tUyzMgRXc0t0UuIa23TYS10epegkc90AuoPsajyyXITKn8SFv
        J2ZiEO/EVtoHqcTOaCk22U6CwkRPKYR7hKe2qcluTWmxqL1UndDJ1TWRBxqyClde8HM7nK
        tePQisBx4H+iUAtpus5nEnazhMp0F1k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-AeFMBNh0NyOrESMQkNVoQw-1; Thu, 13 Apr 2023 07:31:42 -0400
X-MC-Unique: AeFMBNh0NyOrESMQkNVoQw-1
Received: by mail-wr1-f70.google.com with SMTP id m9-20020adfa3c9000000b002f4a18aed73so1141649wrb.20
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681385501; x=1683977501;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIm5iNvrLIrBpXBxl0Ffwy4XMhjO0OH42kfpLYYOzdU=;
        b=Denk//r953BEn6OYX/j28UxNDD5toxGdzY7xwUhXsKrBGs5mLPayqOZSqvbLHTPsyn
         C0CVJhg32X02C2e+P8Di/9efRlPAJNgbdOGjcO/LgtAW+2arKS+J+mmk8xy9coM/AM01
         ylb69zjzQFlRVhrh/mNlj50bVtGCIOTMXodo2s2M0gl8lNRcI1B+IXgd8X2liYP955V1
         u3OfVc6A0XtGtmVrGD/o33RN++bJPt6srAvwZG51A8tq0nLy3RpW1961F5jZ5LdKPmNT
         Ztgxvvd9VvIP8E1VJ1+BHlghQiYUGlZRN7j8uQVex/fsarydEdE4A7ngBQq+hXman5f4
         gyEA==
X-Gm-Message-State: AAQBX9e4k8OsuEeREcabJufbYhTDbKQvZKLW9esMEjGT/Zev2k0WykAV
        0mk9jRpCQeBUqqKaZYwWisNw0GmmzrKGwtTp8zLIvwWUXx7sY95NZhqllasX8CcrvErHTMB6RG+
        OwJavTo9MfybWlm5MudwD
X-Received: by 2002:a05:600c:298:b0:3f0:7147:2ed7 with SMTP id 24-20020a05600c029800b003f071472ed7mr1687508wmk.16.1681385501423;
        Thu, 13 Apr 2023 04:31:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y4H8/rhGt4xGxQ9IGJbZT1v8VC/SsnmagiAuFB3KrJE6ARurMSfQvfmVWRsSDoFSctJZW2Ag==
X-Received: by 2002:a05:600c:298:b0:3f0:7147:2ed7 with SMTP id 24-20020a05600c029800b003f071472ed7mr1687487wmk.16.1681385501058;
        Thu, 13 Apr 2023 04:31:41 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c204d00b003ee0d191539sm1590363wmg.10.2023.04.13.04.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 04:31:40 -0700 (PDT)
Message-ID: <57be0df8-e7a8-acda-4422-d4502a8b08b7@redhat.com>
Date:   Thu, 13 Apr 2023 13:31:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating
 current->reclaim_state
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-4-yosryahmed@google.com>
 <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
 <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13.04.23 13:29, Yosry Ahmed wrote:
> On Thu, Apr 13, 2023 at 4:21 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 13.04.23 12:40, Yosry Ahmed wrote:
>>> During reclaim, we keep track of pages reclaimed from other means than
>>> LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
>>> which we stash a pointer to in current task_struct.
>>>
>>> However, we keep track of more than just reclaimed slab pages through
>>> this. We also use it for clean file pages dropped through pruned inodes,
>>> and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and add
>>
>> Would "reclaimed_non_lru" be more expressive? Then,
>>
>> mm_account_reclaimed_pages() -> mm_account_non_lru_reclaimed_pages()
>>
>>
>> Apart from that LGTM.
> 
> Thanks!
> 
> I suck at naming things. If you think "reclaimed_non_lru" is better,
> then we can do that. FWIW mm_account_reclaimed_pages() was taken from
> a suggestion from Dave Chinner. My initial version had a terrible
> name: report_freed_pages(), so I am happy with whatever you see fit.
> 
> Should I re-spin for this or can we change it in place?

Respin would be good, but maybe wait a bit more on other comments. I'm 
bad at naming things as well :)

-- 
Thanks,

David / dhildenb

