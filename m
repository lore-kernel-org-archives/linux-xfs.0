Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB458C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 11:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDMLT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDMLTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 07:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F037F527E
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681384746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XuDaODPg28/lbKls3iVZv9/j3tAy7pEuJB1+NArX0sI=;
        b=BMHy6mnjcXbL3NGCq/5qM3p4v9RH90UHNCpIE/pI1zOvDSf+C2rwcqvOK/MLJPq3HE/8oE
        qMlRDIrYEJf4S7qecyGiVNC9QgIFV3JwgN67YVmx/Z9pR/QfP7AabZDSfhGMQltsQ2ThX6
        GbJ9n2euOfqeyxXqXEy+0LN/taM96P4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-pnGTR4hCP8ynHOCnwpfkGQ-1; Thu, 13 Apr 2023 07:19:05 -0400
X-MC-Unique: pnGTR4hCP8ynHOCnwpfkGQ-1
Received: by mail-wr1-f72.google.com with SMTP id j15-20020adfb30f000000b002d34203df59so2459711wrd.9
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 04:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681384744; x=1683976744;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XuDaODPg28/lbKls3iVZv9/j3tAy7pEuJB1+NArX0sI=;
        b=SNWRBDbiEUA9zl7mhkEBD0qh6N4RQZ/1RraeP7lcSr9la7bMMsKCIpmgRl3aFTmIja
         hT+GM+K39MDXoO1ErBXoHpX3T1livwT73W5UEKrceywzclnaIJfTx5pVSiaokJxhkolN
         oWu9Ro13uFe2wLcy1mqQYrn0Ung+mESuPfSBQZO3EQ8SsYk+IipBPffxwQrvwD8oH9Bj
         CawhR2ZkpxvhG94qSFEU621GZJGMuBxGwUuNBdJ8kpmih2kK7Wwv1166rWLtitFBQQkE
         lGaJ98EYR5Hli4pkjInK4dkicPWmKwNPV7S+OzDv4KdQD4CNvtpewMAkYYWUbcmQAw7G
         oKJA==
X-Gm-Message-State: AAQBX9dYWKPcAjuhIwGEdALSHGbsIwKvvIlmtbsdVCGRRw3InFwJB+Sm
        L0KYwwhyltxa43FEI9xLe4AdXGAo0O1LnMOXUBbSlTKC6oCqscNQQh492Zy5sGiL1C81kXnex0F
        P3dRxur6SNCC0TNtRxbAj
X-Received: by 2002:a7b:ca4c:0:b0:3f0:7147:2ecd with SMTP id m12-20020a7bca4c000000b003f071472ecdmr1571282wml.7.1681384744360;
        Thu, 13 Apr 2023 04:19:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350bLB2veUASI4/m+qmmFnnoaJ0DjGho2eJAioBtjyEBuvdQ48H1Q2Wt23LlVt3082GLF+6fzbQ==
X-Received: by 2002:a7b:ca4c:0:b0:3f0:7147:2ecd with SMTP id m12-20020a7bca4c000000b003f071472ecdmr1571251wml.7.1681384743997;
        Thu, 13 Apr 2023 04:19:03 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id bg20-20020a05600c3c9400b003ee9c8cc631sm5196264wmb.23.2023.04.13.04.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 04:19:03 -0700 (PDT)
Message-ID: <bb42720b-dec9-a62b-50a2-422ddd6a1920@redhat.com>
Date:   Thu, 13 Apr 2023 13:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 2/3] mm: vmscan: move set_task_reclaim_state() near
 flush_reclaim_state()
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
 <20230413104034.1086717-3-yosryahmed@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230413104034.1086717-3-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13.04.23 12:40, Yosry Ahmed wrote:
> Move set_task_reclaim_state() near flush_reclaim_state() so that all
> helpers manipulating reclaim_state are in close proximity.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

Hm, it's rather a simple helper to set the reclaim_state for a task, not 
to modify it.

No strong opinion, but I'd just leave it as it.

-- 
Thanks,

David / dhildenb

