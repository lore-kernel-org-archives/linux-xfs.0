Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C26C61DA4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Feb 2023 16:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbjBCQWg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Feb 2023 11:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBCQWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2023 11:22:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A3FA6B81;
        Fri,  3 Feb 2023 08:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9tlU3E6gFTikzNFh8ic4A7v0yzAetE1KgNmS/ZDw9/M=; b=bkUZ4atbzUjdiHVSCwLnutyONe
        sNiRV3IwT/n86rZoj+ltc240yW0y9nwR3ypN16UIA+sX0uGDmBdA0N/uTz2xFCH0J2tDT8SOaTavO
        Jn41mc1+Iiq6JJqSWhCB+wo35TH6ghDlCN9x7lvnZR/mtr7hQMxoA2ZSpBCDgJH4rljX8m/iCzahq
        jqZN6sBR2AVf6kMeaH0/x7U7j3NDmppsdTvbstdRgdKPOqEP3ZnpbZKRiMo5+UKMFO27/jnboaLUZ
        lkC87ssYd6q3Q/yapdaJx8fP2S9V60y3jiCPNf8/xSVVEFIk7T0y15tgM4KDeJOGqDuZd16QruQ+g
        SGTwX4GQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNypK-00ES7K-IY; Fri, 03 Feb 2023 16:22:14 +0000
Date:   Fri, 3 Feb 2023 16:22:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 1/2] mm: vmscan: refactor updating reclaimed pages
 in reclaim_state
Message-ID: <Y900tl+kRWoZac/T@casper.infradead.org>
References: <20230202233229.3895713-1-yosryahmed@google.com>
 <20230202233229.3895713-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202233229.3895713-2-yosryahmed@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 02, 2023 at 11:32:28PM +0000, Yosry Ahmed wrote:
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 54c774af6e1c..060079f1e966 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -286,8 +286,7 @@ xfs_buf_free_pages(
>  		if (bp->b_pages[i])
>  			__free_page(bp->b_pages[i]);
>  	}
> -	if (current->reclaim_state)
> -		current->reclaim_state->reclaimed_slab += bp->b_page_count;
> +	report_freed_pages(bp->b_page_count);

XFS can be built as a module

> +++ b/mm/vmscan.c
> @@ -204,6 +204,19 @@ static void set_task_reclaim_state(struct task_struct *task,
>  	task->reclaim_state = rs;
>  }
>  
> +/*
> + * reclaim_report_freed_pages: report pages freed outside of LRU-based reclaim
> + * @pages: number of pages freed
> + *
> + * If the current process is undergoing a reclaim operation,
> + * increment the number of reclaimed pages by @pages.
> + */
> +void report_freed_pages(unsigned long pages)
> +{
> +	if (current->reclaim_state)
> +		current->reclaim_state->reclaimed += pages;
> +}
> +

report_free_pages is not EXPORT_SYMBOLed

