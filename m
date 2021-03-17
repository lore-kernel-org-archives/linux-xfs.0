Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C084C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 16:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C12B864F41
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 16:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhCQQw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:52:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232660AbhCQQw1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 12:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615999947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NTAsRPoJwfYXUUkMUv7TuPCY0aybW2MD2iMe4Y7iD9w=;
        b=e4JHTLl7VEct5iZQrDhoDBvuFp8S2zmj/HW+Nqi4mkTJZs/L8ndez73JhoghR6Svmt1v0g
        cdn/dMJHvTzRoEoPu7mwpSJ6dribw3IGoCqk0zz18ZSkdzIycr2kWgE2PFKwAJvs4MQo3c
        iHPddvlDdyPa1MZbdGaFaYBm7HJC75Y=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-q1yycvggPP2g9Wj2-1_eVQ-1; Wed, 17 Mar 2021 12:52:24 -0400
X-MC-Unique: q1yycvggPP2g9Wj2-1_eVQ-1
Received: by mail-pf1-f200.google.com with SMTP id x197so22434901pfc.18
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 09:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NTAsRPoJwfYXUUkMUv7TuPCY0aybW2MD2iMe4Y7iD9w=;
        b=PocmBShalhF6Ql3Pmy1t/0VR/FTHRD12nPDQdBtSKe7uo5W+hc6tPkO8qplGtWCtX4
         cmoG04c4vz6zXGLFBugw3sAenxIKHtdAAs8lCA+5im8clMcJn9pgcibmyNHrfUhK4Dkt
         0F9Of7TszQid5y7mWF3yKMXQn21ZfeRvsUFsASlQ1zS9Q9dE2Vn+JauEL4DPBSA6f0n2
         rvdLEQtvQCdC4uzDa2EiNWRq8IiMF1SKSgmea9BrvwW0iS1Dvo3l4kQAKqUcJQYdZCG4
         HcmeEbMjQ8Io3TMm1zVq//U5YU494AfZGaLriEE73LIHPhml52jLugHDfB7EJyWAx0eE
         mONw==
X-Gm-Message-State: AOAM5304X6qAR66/5D6QtGZp5ivzmTJWeZz+n8wAAdwEBGj0BN3IECS2
        KvpXR5duhby8VTkPzANiahqQGp9005aR1GZMSUvmzKiMP9HNP4P+hcYU2Lybp7HRjf7Q52ujUaM
        0ZJb4XkLb2IwzP+Oh8Zxa
X-Received: by 2002:a62:8203:0:b029:1f1:5ceb:4be7 with SMTP id w3-20020a6282030000b02901f15ceb4be7mr78011pfd.48.1615999943071;
        Wed, 17 Mar 2021 09:52:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1qaI+RhRLuzK+aKkXVxID7qSjqJngv65EfcLO1WUWjShQkWaplII0jZ/PYsC8GFQ5Y/oJXw==
X-Received: by 2002:a62:8203:0:b029:1f1:5ceb:4be7 with SMTP id w3-20020a6282030000b02901f15ceb4be7mr77994pfd.48.1615999942836;
        Wed, 17 Mar 2021 09:52:22 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m5sm20222849pfd.96.2021.03.17.09.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:52:22 -0700 (PDT)
Date:   Thu, 18 Mar 2021 00:52:12 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: reduce buffer log item shadow allocations
Message-ID: <20210317165212.GB1207630@xiangao.remote.csb>
References: <20210317045706.651306-1-david@fromorbit.com>
 <20210317045706.651306-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210317045706.651306-3-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 17, 2021 at 03:57:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we modify btrees repeatedly, we regularly increase the size of
> the logged region by a single chunk at a time (per transaction
> commit). This results in the CIL formatting code having to
> reallocate the log vector buffer every time the buffer dirty region
> grows. Hence over a typical 4kB btree buffer, we might grow the log
> vector 4096/128 = 32x over a short period where we repeatedly add
> or remove records to/from the buffer over a series of running
> transaction. This means we are doing 32 memory allocations and frees
> over this time during a performance critical path in the journal.
> 
> The amount of space tracked in the CIL for the object is calculated
> during the ->iop_format() call for the buffer log item, but the
> buffer memory allocated for it is calculated by the ->iop_size()
> call. The size callout determines the size of the buffer, the format
> call determines the space used in the buffer.
> 
> Hence we can oversize the buffer space required in the size
> calculation without impacting the amount of space used and accounted
> to the CIL for the changes being logged. This allows us to reduce
> the number of allocations by rounding up the buffer size to allow
> for future growth. This can safe a substantial amount of CPU time in
> this path:
> 
> -   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
>    - 44.49% xfs_log_commit_cil
>       - 30.78% _raw_spin_lock
>          - 30.75% do_raw_spin_lock
>               30.27% __pv_queued_spin_lock_slowpath
> 
> (oh, ouch!)
> ....
>       - 1.05% kmem_alloc_large
>          - 1.02% kmem_alloc
>               0.94% __kmalloc
> 
> This overhead here us what this patch is aimed at. After:
> 
>       - 0.76% kmem_alloc_large
>          - 0.75% kmem_alloc
>               0.70% __kmalloc
> 
> The size of 512 bytes is based on the bitmap chunk size being 128
> bytes and that random directory entry updates almost never require
> more than 3-4 128 byte regions to be logged in the directory block.
> 
> The other observation is for per-ag btrees. When we are inserting
> into a new btree block, we'll pack it from the front. Hence the
> first few records land in the first 128 bytes so we log only 128
> bytes, the next 8-16 records land in the second region so now we log
> 256 bytes. And so on.  If we are doing random updates, it will only
> allocate every 4 random 128 byte regions that are dirtied instead of
> every single one.
> 
> Any larger than 512 bytes and I noticed an increase in memory
> footprint in my scalability workloads. Any less than this and I
> didn't really see any significant benefit to CPU usage.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

