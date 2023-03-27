Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031C1C77B60
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Mar 2023 23:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjC0XCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 19:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjC0XCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 19:02:12 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513A01FF7
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 16:02:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ix20so9960134plb.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Mar 2023 16:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679958130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XwjJWkGsp6KWaPuhX4ZKe2jxF9ewadj6nf9Cn7FI1X8=;
        b=Zz8B3FNY4b+sfM3gfYNEEatxFjxwT5o1zpMNuvfBS517c1CYE6PZUHcz+vKQ8ZK3I6
         ClLBBKktOkc28IqhM36776xjqIMVzzd68Wv+FZKnHgaeOTuRX3pqh/9nZoUmvtZjbroh
         /HpBudD1UN/MdRKt/qGYgI0mBVhKZ//nk+V1TeeSn7WIXYnNhMbSB9aaQ/H+OOxQF4PK
         +8mCAP3e7DKdl6OydEeqWDXOsnJOVQm0B+/5a2VvkWwrxAlKTkRu6b97VNjgY7Rt8XYH
         AbIliowGwrJ1qKW7FRaV1H2An4bwesmo67qrWdznCygZkX6FmEo/qsCdrtNt+8JspfFP
         Cd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679958130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XwjJWkGsp6KWaPuhX4ZKe2jxF9ewadj6nf9Cn7FI1X8=;
        b=NSaUJD7qe4N+qucRO6lRg6XYFCrlVouQLND9iJBcxEpqWufkKbJ6QYL7CoSRP0IpSk
         /2yD6JRgQFU2kqS6Sdd5Dq/PbhPeAZAKqgO3ZWy5NzXUF2SqkXxlpFj7pkyz0IU0qm4M
         9foYe/3QuXQlD4ifUxEZfMl4pLwSY/ir/IYOCWojIujV3WlMh3MSoDFXNhZRTmEyqSYc
         y7i41q0cipw9q8rxKBudPha38cbLTzHDThWb5oWiSZNAS+CU5lJfSYwEdds6j4+VsKX7
         46QzwfSeNG6cRxCJd1d+NTlBLHH6aFpMHwGDloVpNQUFsjg5g4GGPJWm3hRJ7LToTl9X
         886A==
X-Gm-Message-State: AAQBX9cgVVgRhdgtYXhncmzD6aaJ6UPY+u2lzNJoElhrRPX5YRH6869d
        5iOJhktaYgO2bGboETsVhoxs5Q==
X-Google-Smtp-Source: AKy350bjib11R2NrhpiPjugKHYIyoMxeV3cFjuVht7Zm9p1Mx82x5ICBvHK5McnUuHknqG1vfNYkLg==
X-Received: by 2002:a17:90a:1d7:b0:23e:fc9c:930 with SMTP id 23-20020a17090a01d700b0023efc9c0930mr13985941pjd.36.1679958129769;
        Mon, 27 Mar 2023 16:02:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090a348d00b002311ae14a01sm4907325pjb.11.2023.03.27.16.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 16:02:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pgvqo-00DwxK-SK; Tue, 28 Mar 2023 10:02:06 +1100
Date:   Tue, 28 Mar 2023 10:02:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] mm: Hold the RCU read lock over calls to
 ->map_pages
Message-ID: <20230327230206.GB3223426@dread.disaster.area>
References: <20230327174515.1811532-1-willy@infradead.org>
 <20230327174515.1811532-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327174515.1811532-4-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2023 at 06:45:15PM +0100, Matthew Wilcox (Oracle) wrote:
> Prevent filesystems from doing things which sleep in their map_pages
> method.  This is in preparation for a pagefault path protected only
> by RCU.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  Documentation/filesystems/locking.rst |  4 ++--
>  mm/memory.c                           | 11 ++++++++---
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index 922886fefb7f..8a80390446ba 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -645,7 +645,7 @@ ops		mmap_lock	PageLocked(page)
>  open:		yes
>  close:		yes
>  fault:		yes		can return with page locked
> -map_pages:	yes
> +map_pages:	read
>  page_mkwrite:	yes		can return with page locked
>  pfn_mkwrite:	yes
>  access:		yes
> @@ -661,7 +661,7 @@ locked. The VM will unlock the page.
>  
>  ->map_pages() is called when VM asks to map easy accessible pages.
>  Filesystem should find and map pages associated with offsets from "start_pgoff"
> -till "end_pgoff". ->map_pages() is called with page table locked and must
> +till "end_pgoff". ->map_pages() is called with the RCU lock held and must
>  not block.  If it's not possible to reach a page without blocking,
>  filesystem should skip it. Filesystem should use set_pte_range() to setup
>  page table entry. Pointer to entry associated with the page is passed in
> diff --git a/mm/memory.c b/mm/memory.c
> index 8071bb17abf2..a7edf6d714db 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4461,6 +4461,7 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	/* The page offset of vmf->address within the VMA. */
>  	pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
>  	pgoff_t from_pte, to_pte;
> +	vm_fault_t ret;
>  
>  	/* The PTE offset of the start address, clamped to the VMA. */
>  	from_pte = max(ALIGN_DOWN(pte_off, nr_pages),
> @@ -4476,9 +4477,13 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  			return VM_FAULT_OOM;
>  	}
>  
> -	return vmf->vma->vm_ops->map_pages(vmf,
> -		vmf->pgoff + from_pte - pte_off,
> -		vmf->pgoff + to_pte - pte_off);
> +	rcu_read_lock();
> +	ret = vmf->vma->vm_ops->map_pages(vmf,
> +			vmf->pgoff + from_pte - pte_off,
> +			vmf->pgoff + to_pte - pte_off);
> +	rcu_read_unlock();
> +
> +	return ret;

Doesn't this mean that the rcu_read_lock/unlock can be removed from
filemap_map_pages()? i.e. all callers are now already under
rcu_read_lock(). Maybe WARN_ON_ONCE(!rcu_read_lock_held()) could
be put in filemap_map_pages() if you are worried about callers not
holding it...

Otherwise it looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
