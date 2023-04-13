Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB67C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjDMLRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjDMLR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8958A57
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681384587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QNSaV+uzNwUaTHzuGiSzLbWwlIcvuOBgoNlGeWAI1UU=;
        b=d7M1oBTE/7SGCLVpg1IYcdzfGKqdVvi19Ntqvf6vrI+FFWgnHeQ1+jsyUq9YDZ8tfNJzJr
        umkclcdgjEifo2Jso5bSzetgEQTZZ5sbPCWBvmCYL/pJy4ZP6uy64kV39Ih04P/UfN/ZhV
        JxWLPhonmQDYxAN81t1/6VEVdcumV3k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-T7rdC71KMDuEeqNPOtJ41A-1; Thu, 13 Apr 2023 07:16:26 -0400
X-MC-Unique: T7rdC71KMDuEeqNPOtJ41A-1
Received: by mail-wm1-f71.google.com with SMTP id n9-20020a05600c4f8900b003ee21220fccso5510202wmq.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681384585; x=1683976585;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QNSaV+uzNwUaTHzuGiSzLbWwlIcvuOBgoNlGeWAI1UU=;
        b=Tt55dUpmxj3TXV5D3VOcYppmqEnVUoKKe7uORXOyOEVzLxIw09DVbgcrLm0hny3iwW
         l27y4ijGOZlm+4ypm6CBRFhJmZtHzHXvO/v6lzP38psOSF1PGKpuA09HqsRkvowmRxLS
         YIZwYR2mlNdxeCerKK12ZxydwwAYzJYJQCz9vdBqmxDwyf5Y0eejD+J7Eo7RBJ0GHHl0
         T0VD3OueBEH86PYb0sJV0sIJWAM7a8/cE3LoowKJukisqQqwk3K0jYsO1Cx+7p9NwS+p
         JvgcI9U5svxhfNXd9q0pL71AXFphL5IF98T+w60EExucKJKUwMq1dBn0bEoC5kZ98wSU
         rKLQ==
X-Gm-Message-State: AAQBX9c+1uKw7mPR172FbDeWOotTPH4y4G0CQ51zGM5lF/8uEqp28luo
        6qR451LNIY2NQVQn3c/8ctIb1eesauX4p9RK+V4DUAdMOfEclPA6ajhNLxK24LsYuwIH0FDVA0w
        kG9A0JHhQ/V1NhIxB6jbO
X-Received: by 2002:a05:600c:253:b0:3ee:2b04:e028 with SMTP id 19-20020a05600c025300b003ee2b04e028mr1540244wmj.14.1681384585004;
        Thu, 13 Apr 2023 04:16:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y56+uVeHEpQ7DYhvS2HpddDR7vO9wV6HUHDfsZtsRnbxqsJQPF2RWE55xND5m+Q/fCnqGAWg==
X-Received: by 2002:a05:600c:253:b0:3ee:2b04:e028 with SMTP id 19-20020a05600c025300b003ee2b04e028mr1540223wmj.14.1681384584652;
        Thu, 13 Apr 2023 04:16:24 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id k7-20020a5d6287000000b002e463bd49e3sm1064660wru.66.2023.04.13.04.16.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 04:16:24 -0700 (PDT)
Message-ID: <0340c57b-dcec-42ba-eb6e-dd5599722ea4@redhat.com>
Date:   Thu, 13 Apr 2023 13:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 1/3] mm: vmscan: ignore non-LRU-based reclaim in memcg
 reclaim
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Tim Chen <tim.c.chen@linux.intel.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-2-yosryahmed@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230413104034.1086717-2-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13.04.23 12:40, Yosry Ahmed wrote:
> We keep track of different types of reclaimed pages through
> reclaim_state->reclaimed_slab, and we add them to the reported number
> of reclaimed pages.  For non-memcg reclaim, this makes sense. For memcg
> reclaim, we have no clue if those pages are charged to the memcg under
> reclaim.
> 
> Slab pages are shared by different memcgs, so a freed slab page may have
> only been partially charged to the memcg under reclaim.  The same goes for
> clean file pages from pruned inodes (on highmem systems) or xfs buffer
> pages, there is no simple way to currently link them to the memcg under
> reclaim.
> 
> Stop reporting those freed pages as reclaimed pages during memcg reclaim.
> This should make the return value of writing to memory.reclaim, and may
> help reduce unnecessary reclaim retries during memcg charging.  Writing to
> memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
> for this case we want to include any freed pages, so use the
> global_reclaim() check instead of !cgroup_reclaim().
> 
> Generally, this should make the return value of
> try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.g.
> freed a slab page that was mostly charged to the memcg under reclaim),
> the return value of try_to_free_mem_cgroup_pages() can be underestimated,
> but this should be fine. The freed pages will be uncharged anyway, and we
> can charge the memcg the next time around as we usually do memcg reclaim
> in a retry loop.
> 
> Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
> instead of pages")
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

LGTM, hopefully the underestimation won't result in a real issue.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

