Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FCCC4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 04:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E571623A34
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 04:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6Ie/MBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgIVEon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 00:44:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727724AbgIVEon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 00:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600749882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nUDuNcWNlJoeIxJLLzpcNtkSyixBzhrXe0l2V7Xp7/U=;
        b=Q6Ie/MBgLbYoUMr/jUMOZhx6sQSUp/zpmmVpikXQrSyOKOAERQQGUrQ05LY1+4vyvarxNC
        kWZxNta9bE8Fjqv9FTfnCsP6FaSUsauQt1LMXZ3ckN7aw5yiLihI5Vw2rD/7Uwt+lNFJ6o
        VuNYm+B4F34ZXNjAqyi2m+iypswEqlI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-06VFmUMdOBmimyI0puW7sw-1; Tue, 22 Sep 2020 00:44:40 -0400
X-MC-Unique: 06VFmUMdOBmimyI0puW7sw-1
Received: by mail-pg1-f197.google.com with SMTP id c26so9722452pgl.9
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2020 21:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nUDuNcWNlJoeIxJLLzpcNtkSyixBzhrXe0l2V7Xp7/U=;
        b=ZrGouyZIuxL/VrbhEtS1N00QUwjCQ+K6XkFcDWLk8ZHv8vEV+RC4D25NHVsBYLua1A
         p1m5og62J3Arm/8aZzlMAMxphzNhcVfVmfLz8TVKURPiQrwSYbhhqn1xih1oEb0T1n1V
         gC6cQrt2rUc6u2iKMj7LGyqPDeb5Hf9439VF0nWwpv5rj+fnn88ir32B3UNzz/4x4LMZ
         1xQaF4l7Yqkbrs0+qM1xlmsl/f8FY3kxOiMudJGUNaO0Boh/pF7dfrSrPqHpOm83yap2
         EuwwXVGmSlkJ4IvG3ZvCBR+sVtWx/X3mVv9ZE3wQW+2AuUiwZQyZDfKqaJlcrAUCFJUj
         OOgQ==
X-Gm-Message-State: AOAM531c9U1OP8NlqzvaLnd4OmnCR1+oxrWZsbfQqb1p9dDj2uVDyVwq
        MXQk+6GvaQTLvUqYLiD6vfYTUvMpTnzxWEN5GeYkJdOjv7ZFN2eZeKcGlLydQFLgl04EnB4L0G7
        N2+viLcECjriUSUu6hjl4
X-Received: by 2002:a05:6a00:15c1:b029:13e:d13d:a04d with SMTP id o1-20020a056a0015c1b029013ed13da04dmr2533303pfu.19.1600749878772;
        Mon, 21 Sep 2020 21:44:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5mcfiDva5UsOuSwVQSIyBd4s6lBU8HTgSJMJk7VZlLsi6nct8zzdmTRXeza1YPgAmma0+ww==
X-Received: by 2002:a05:6a00:15c1:b029:13e:d13d:a04d with SMTP id o1-20020a056a0015c1b029013ed13da04dmr2533290pfu.19.1600749878504;
        Mon, 21 Sep 2020 21:44:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n127sm12932592pfn.155.2020.09.21.21.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 21:44:38 -0700 (PDT)
Date:   Tue, 22 Sep 2020 12:44:28 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200922044428.GA4284@xiangao.remote.csb>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922034249.20549-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> tree"), there is no m_peraglock anymore, so it's hard to understand
> the described situation since per-ag is no longer an array and no
> need to reallocate, call xfs_filestream_flush() in growfs.
> 
> In addition, the race condition for shrink feature is quite confusing
> to me currently as well. Get rid of it instead.
> 

(Add some words) I think I understand what the race condition could mean
after shrink fs is landed then, but the main point for now is inconsistent
between code and comment, and there is no infrastructure on shrinkfs so
when shrink fs is landed, the locking rule on filestream should be refined
or redesigned and xfs_filestream_flush() for shrinkfs which was once
deleted by 1c1c6ebcf52 might be restored to drain out in-flight
xfs_fstrm_item for these shrink AGs then.

From the current code logic, the comment has no use and has been outdated
for years. Keep up with the code would be better IMO to save time.

