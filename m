Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D71C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8BB206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 12:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593088823;
	bh=my7htkK5FANAhWBSyYgp2LROjZSdqnMxJDtOxftgbz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2rZmNC8l5FiuIfLfppRILUfNJybQRPpmlGzpqCDrLJjEItFJeUqIfQ+DACpPfMMQD
	 3FERPdgCcLnaSNhufKKUHlGf7RVwH6H54z6o9JlOLka3o3vUk/gAxlQOvp8FVIHoXQ
	 k59FTpV4fupE22NuQRFt9k4aIlrIB9hf8ROyqbZQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404610AbgFYMkW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:40:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37520 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404575AbgFYMkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 08:40:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id a6so5686532wrm.4;
        Thu, 25 Jun 2020 05:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5nATsF4VCIDnrx784KWSs9fceGtDRoONcd5UkfYMdVE=;
        b=Ay1VfpHxDodDwBD5iq/yHw2ZzxeXpBADuuDi8KcEKSreTtWFvG4lxon3roe6wjRNNx
         c4MzRNvPs6P9nDCsEhs2vA2Kx7xRxP4Tq3RgfZaCTN2wbZnMbq/Na4cQuOuXmCrZPEyL
         vb8x67KcePB6tJ26x0CH9hnnwdSTezjurnvnzjzBAOPBcbydfwojiQjTnJPKZN9e2uN5
         +FNv1hYyN5X/02/EYjbLv4E/fyKZ3kwgUeSSL8hQR2BYk4NhZUWfUovEoqXdXNE2NK6O
         OL+tWH/jd6Y2qHTBDddzCx7JPKqhTiTkyPhuYFRqqWWhfvTGJwDD63yfLZVBLbaNNyfT
         2zpA==
X-Gm-Message-State: AOAM530uWZq/EauJjkPoQvZVexqgiK5dS8NDndvnyeW22x6PneXA9uyU
        d2KP2HqznjkhfrXkV9eIFY0=
X-Google-Smtp-Source: ABdhPJyv6+l15JpdrNqRIveKQ35DT9zRPh5saDxNlspP+hFweuHnhDzszpv8f1lx6qlSwC1j5o5A+w==
X-Received: by 2002:adf:e701:: with SMTP id c1mr33635637wrm.350.1593088820376;
        Thu, 25 Jun 2020 05:40:20 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id o29sm23839337wra.5.2020.06.25.05.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 05:40:19 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:40:17 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200625124017.GL1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 12:31:22, Matthew Wilcox wrote:
> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.

memalloc_nowait is a good idea! I suspect the primary usecase would be
vmalloc.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

[...]
> @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			unsigned nowait_flag = memalloc_nowait_save();
> +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			memalloc_nowait_restore(nowait_flag);

This looks confusing though. I am not familiar with alloc_buffer and
there is quite some tweaking around __GFP_NORETRY in alloc_buffer_data
which I do not follow but GFP_KERNEL just struck my eyes. So why cannot
we have 
		alloc_buffer(GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
-- 
Michal Hocko
SUSE Labs
