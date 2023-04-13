Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936CBC77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDMLVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDMLVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B924220
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681384864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jSfTt/FpZ51XsXOxa366XVa7DCOmNmyBB//s/oWzTsk=;
        b=GVJrQqOWszEWc9mojA3ur9z9be8RH7jcrb4cLixezNUyvFokNpM5ybo4OQbmaCI61jwvTA
        Z8eu7sPA3nObkLRK1V6j566X0HKaVevXyO4Ar+2tWAxztOMpv+XkaKjdRumSXBc1sfCSOo
        ZjHOQl6bLkDYQw9dLuFCXIW5wTmaHdE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-LmU4sXNkMjKHtNt5NTni4g-1; Thu, 13 Apr 2023 07:21:02 -0400
X-MC-Unique: LmU4sXNkMjKHtNt5NTni4g-1
Received: by mail-wm1-f72.google.com with SMTP id r20-20020a05600c35d400b003edd2023418so8648057wmq.4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681384861; x=1683976861;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jSfTt/FpZ51XsXOxa366XVa7DCOmNmyBB//s/oWzTsk=;
        b=VA4fCubPCTk6YXzpUa+fdZtp/eYLGCJK6Uz4517uw69Q9iMW43kMsUjG7aE/tm1xjO
         hbkpFr8eIOFFKLJrPDxl+Mt9CNHraP1hXlhIfcuyXG0icn2hzL5mXLBYaSDKmRxAeWxP
         JXwFmyOvhZIh31tboRaNxQKpMDVAw+ZSfC8VIEfIYkBOV580zoHxFb0YukNDNQPgyv+D
         rEbu+U3Iee7zak9Zuei0soGj2yBNnZnXyTueeK3MgVQs4QB1D2RztqOSyUREAMeUmNVZ
         c0LSvh/KrhEKlKMQOE0dDKutpntWNKSFWQk4Dy9PhRK77UL+x9Uv2F+mBZ/io7KKcc0j
         4c2w==
X-Gm-Message-State: AAQBX9dMHlwVaz/KF5w5nvvgqG7zBguGrdxIxyygPgeWuc6jmEbKAx4i
        EtNeFMLJt4+XkTq5e1DLrCnllZonnsAXwid0CL8F1xavJCJrin5Efw5TVWpT7mZp69n9m3Q7NhM
        McYuxbFdr6Kj17VfF9jnF
X-Received: by 2002:a5d:4748:0:b0:2f4:bc68:3493 with SMTP id o8-20020a5d4748000000b002f4bc683493mr1179309wrs.34.1681384861483;
        Thu, 13 Apr 2023 04:21:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350aqjI6Q+vFzM2qin74WRIRynSqW3dUlzZ+lzWRnT/FaK8OWoaXuG4EWNsNhSjPY7wORElSWBA==
X-Received: by 2002:a5d:4748:0:b0:2f4:bc68:3493 with SMTP id o8-20020a5d4748000000b002f4bc683493mr1179271wrs.34.1681384861121;
        Thu, 13 Apr 2023 04:21:01 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id f4-20020adff584000000b002f008477522sm1086917wro.24.2023.04.13.04.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 04:21:00 -0700 (PDT)
Message-ID: <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
Date:   Thu, 13 Apr 2023 13:20:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating
 current->reclaim_state
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
 <20230413104034.1086717-4-yosryahmed@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230413104034.1086717-4-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13.04.23 12:40, Yosry Ahmed wrote:
> During reclaim, we keep track of pages reclaimed from other means than
> LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
> which we stash a pointer to in current task_struct.
> 
> However, we keep track of more than just reclaimed slab pages through
> this. We also use it for clean file pages dropped through pruned inodes,
> and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and add

Would "reclaimed_non_lru" be more expressive? Then,

mm_account_reclaimed_pages() -> mm_account_non_lru_reclaimed_pages()


Apart from that LGTM.

-- 
Thanks,

David / dhildenb

