Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE5FC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 21:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDMVBC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMVBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 17:01:01 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F9A8A53
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:00:55 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-517bfdf55c3so264197a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 14:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681419655; x=1684011655;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Po7kMV6PWfvJ0JdTbzWxvRcPOaOmD0dTKySmuNSlDE8=;
        b=5SO+s+WzALNpDN1F2r4RktSFMbeXUOZ5ZZ4imLVAQoXA9/lC9hm3pg4FQZHjcgDFRr
         1W6P7WWYojNsiIJnPi5nuXNn2irghWpItwRXONlnThqo2JXE5P7eGdXskbXOeHw4pfWs
         e4/5GvOocPYZ3hDXjojyciRevZvF858Azln1xhdoJbybRGFGIr/n4fs/v2L8hdzg9s+o
         8ZlfxWTij0X1M7Oqj0eJgBUQGLAU22t8D3AGl9hVEvZT5GMRqEz+FbjOT15elBmGEZRc
         Ug46SqyE6nfY3hF8oRes80r0DASMIbliHC9taLr+InAecO1VhkSBXbyNobEJYqH1kvC8
         qBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681419655; x=1684011655;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Po7kMV6PWfvJ0JdTbzWxvRcPOaOmD0dTKySmuNSlDE8=;
        b=gwq+94exytoMq2o3Kn6q8axJ0Vb+MxtreEXyFWL8UGkgbfbAYmgL2cHdxvQe09yaOE
         Wq/IfwALVNDfZtmlAZOcoKOOciKgcRP4BuLwRrekbMK937fsWDZJhmTaCi8qNB69lB5O
         na3fHPECXjgUkZVsqbHHtDTSNm+s8DQOlXN5xaK8/86WO8x8d7O5C8oAQ6injYafZmRB
         riQWY2eV4qteQkDVbmUYHvunI6DvzSz/V8SeionL6PKTPht6iM1g7CJFmIF3rf8DP+1q
         mFYgU0ZkK64GqqfXPNHS70s8/2qGPLkM5WVCN9rZbiOWfWjWshDvOmwTg6nVBG/DhhTo
         ZVmA==
X-Gm-Message-State: AAQBX9cwphpSiSAweHdfzxcBAGc3AesAY6VjKDMRrErh0Cfj3A9weMv3
        HF+Or7hkJvhhzF2KzsiyOgRGZQ==
X-Google-Smtp-Source: AKy350ZeUgwDYY5eMW7ZOlxK2igrJRw/XaGk5mqSdFs2oVNX3KK71uxfEiOe9qiJLyAHAqLgA8MlqA==
X-Received: by 2002:a05:6a00:2e9c:b0:636:d5be:982f with SMTP id fd28-20020a056a002e9c00b00636d5be982fmr6073105pfb.6.1681419655345;
        Thu, 13 Apr 2023 14:00:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id w5-20020aa78585000000b0063824fef27asm1871769pfn.13.2023.04.13.14.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 14:00:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pn43n-00322H-2A; Fri, 14 Apr 2023 07:00:51 +1000
Date:   Fri, 14 Apr 2023 07:00:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating
 current->reclaim_state
Message-ID: <20230413210051.GO3223426@dread.disaster.area>
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-4-yosryahmed@google.com>
 <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
 <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 04:29:43AM -0700, Yosry Ahmed wrote:
> On Thu, Apr 13, 2023 at 4:21 AM David Hildenbrand <david@redhat.com> wrote:
> >
> > On 13.04.23 12:40, Yosry Ahmed wrote:
> > > During reclaim, we keep track of pages reclaimed from other means than
> > > LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
> > > which we stash a pointer to in current task_struct.
> > >
> > > However, we keep track of more than just reclaimed slab pages through
> > > this. We also use it for clean file pages dropped through pruned inodes,
> > > and xfs buffer pages freed. Rename reclaimed_slab to reclaimed, and add
> >
> > Would "reclaimed_non_lru" be more expressive? Then,
> >
> > mm_account_reclaimed_pages() -> mm_account_non_lru_reclaimed_pages()
> >
> >
> > Apart from that LGTM.
> 
> Thanks!
> 
> I suck at naming things. If you think "reclaimed_non_lru" is better,
> then we can do that. FWIW mm_account_reclaimed_pages() was taken from
> a suggestion from Dave Chinner. My initial version had a terrible
> name: report_freed_pages(), so I am happy with whatever you see fit.
> 
> Should I re-spin for this or can we change it in place?

I don't care for the noise all the bikeshed painting has generated
for a simple change like this.  If it's a fix for a bug, and the
naming is good enough, just merge it already, ok?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
