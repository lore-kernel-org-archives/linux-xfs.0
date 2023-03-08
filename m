Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F6AC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 16:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjCHQDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 11:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjCHQCu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 11:02:50 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C4DC9A6A
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 08:01:04 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id r5so18561094qtp.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 08:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1678291257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h3hZwpKMg+vlHtotr98nmh9kQ0sI9K4sYDzfoR8/Nkw=;
        b=VKR9kxxOdfwLKRX+OUxi0CqO3qdzQviWy2G5KfY1OlbX5P2Zjs7o+pnTrBmcgdPn/3
         3mcJ510vjumwGzDhiWCOfmNnwbgE1xGHD/3UPa5tx6sWp0j1xRGvNagDAeIJvEyJqMmY
         E2nu6YPt8YzGd84SVtsL7clnfqTYJf9TROwXIfd1yPVrGs7P4BS3ZZRyCNAU28hjP7I0
         iglsK76350p0U/4VE1Mvd237L0HvzuoKM+uyEaqw58KBNXFQ+xVXxJHJV4vSiuA0zCYF
         ooBfwRMknXntUcS7NSqpef0p62PactO8oozTc50D7gqWgBk6/NceCWvU3Q7eLccrbNBa
         VWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678291257;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3hZwpKMg+vlHtotr98nmh9kQ0sI9K4sYDzfoR8/Nkw=;
        b=dWWHFl8TkP+TAED1KJ+MirvvIWmaFLgdSib/1L8GKlrKRDGzF86DQBvITk0tr2UEPF
         mnmSC1kKsPtxTwaK6VfbwzrG0o7fac5MC1GTkkWdt+gpJdFtQjJ2sS9UYJVIqc4dWOYs
         fTn/MCmqrkJz1JMpsrVkyE5B3NI8R/BkUFReDh7DzCnmluvTISWDEOuRxTigwggiIvBQ
         lGQijhxuzY9Qgsk/JfDNP5tBI/OS1V4kU3rDTimGiK1edPnt4xauNUB53OtKuLvMtnES
         gshW+UDx+qNGJFAyRHmeMoIrLNBMvMO2GfX6FV88JNQmdvJ+nWaL1ZmNADfmNZwoGy9/
         EfHg==
X-Gm-Message-State: AO0yUKWrozGfV9llGj63IjBVjbsewN8MSNiqP9xQCWZBq74t6Tjo31OW
        b7wuN5h+qnc222hrKLZnTjX3Kg==
X-Google-Smtp-Source: AK7set8VHTOzJ1mGxBCJIKeE5Y/M6Q5A34bQK9WHzEHfDvqAd4z/Xd8BRHp+AwjZqV34Y2Q19xl+tQ==
X-Received: by 2002:a05:622a:303:b0:3bf:a08d:b265 with SMTP id q3-20020a05622a030300b003bfa08db265mr37829235qtw.24.1678291257174;
        Wed, 08 Mar 2023 08:00:57 -0800 (PST)
Received: from localhost (2603-7000-0c01-2716-8f57-5681-ccd3-4a2e.res6.spectrum.com. [2603:7000:c01:2716:8f57:5681:ccd3:4a2e])
        by smtp.gmail.com with ESMTPSA id a191-20020ae9e8c8000000b00742743dba2asm11578051qkg.39.2023.03.08.08.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:00:56 -0800 (PST)
Date:   Wed, 8 Mar 2023 11:00:56 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
Message-ID: <20230308160056.GA414058@cmpxchg.org>
References: <20230228085002.2592473-1-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228085002.2592473-1-yosryahmed@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello Yosry,

On Tue, Feb 28, 2023 at 08:50:00AM +0000, Yosry Ahmed wrote:
> Reclaimed pages through other means than LRU-based reclaim are tracked
> through reclaim_state in struct scan_control, which is stashed in
> current task_struct. These pages are added to the number of reclaimed
> pages through LRUs. For memcg reclaim, these pages generally cannot be
> linked to the memcg under reclaim and can cause an overestimated count
> of reclaimed pages. This short series tries to address that.

Could you please add more details on how this manifests as a problem
with real workloads?

> Patch 1 is just refactoring updating reclaim_state into a helper
> function, and renames reclaimed_slab to just reclaimed, with a comment
> describing its true purpose.

Looking through the code again, I don't think these helpers add value.

report_freed_pages() is fairly vague. Report to who? It abstracts only
two lines of code, and those two lines are more descriptive of what's
happening than the helper is. Just leave them open-coded.

add_non_vmanscan_reclaimed() may or may not add anything. But let's
take a step back. It only has two callsites because lrugen duplicates
the entire reclaim implementation, including the call to shrink_slab()
and the transfer of reclaim_state to sc->nr_reclaimed.

IMO the resulting code would overall be simpler, less duplicative and
easier to follow if you added a common shrink_slab_reclaim() that
takes sc, handles the transfer, and documents the memcg exception.
