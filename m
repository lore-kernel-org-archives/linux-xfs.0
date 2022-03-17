Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92784C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 13:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiCQNxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 09:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiCQNxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 09:53:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26DFB1CABEF
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 06:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647525109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKbILpPpnN7imRoozJjDZNfBKXeUG41cjQ9Ij+ryjFs=;
        b=cWtl9W4k0+bzyBHE3UX4HYxPZR7DcC5RZlY2ihRNQ/GK1yLlk/D2sVINStwIpGJD4ffLty
        DCQCJbbWchmdV4pmKsTkaDvIULG7NvmdTRM03+rrFFS77nQ1S58OlSV8Pjo02qsgIsfX8A
        cWTqSLVC1yeRH1+q3rY/znsXqBAwFDw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-8n0ztPkjP_-4Jol8UOrhQw-1; Thu, 17 Mar 2022 09:51:47 -0400
X-MC-Unique: 8n0ztPkjP_-4Jol8UOrhQw-1
Received: by mail-qv1-f69.google.com with SMTP id z2-20020a056214060200b00440d1bc7815so3837062qvw.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 06:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKbILpPpnN7imRoozJjDZNfBKXeUG41cjQ9Ij+ryjFs=;
        b=bjxlvdTBJvBCsuIh8hP7rHlEXrR4OCgWWytXLAXMtGWYw1u5c05XwysnfbixJNv+in
         X7MYZy7u1ZAXxLPO0hctDWiXiFHx0Km729WSfUjsaUebV+4qjlNRKkRDSp8u9XziAPgl
         FY9GHkTZmZk/rc+0ZA0DPO64oNZ9aztFSIyWEvskEABPfO4XK9GmEca9u/xJ/B0O6l36
         2AJn2yzjRYshg0zUwlGFnX9LS7j2uHea9+ujRP6GP+E6iUWm9BF3+ZfXylR81DxIM4JZ
         ycsfZPKCSxqj7Jo4GQf/qzym44sMyWynPjPLWv2Qi0BBDYpZADQPXuvTa9Lt5tq79Y9q
         mq2g==
X-Gm-Message-State: AOAM5310gqGfy85FQlP8fJ8eu6sVzOvlR/MpohxrJod4DWUSADqLtjiY
        hudrQkR5rRtuxU1uvMiS4m7V4EVcjCTTaDdq+RvCqKWaRWSiCeNRicLNQxwGEZwzMolU4PgJyXm
        VRJT1/0ezxgH/TOrHfV8J
X-Received: by 2002:ad4:5961:0:b0:435:a1d7:c243 with SMTP id eq1-20020ad45961000000b00435a1d7c243mr3626407qvb.46.1647525106850;
        Thu, 17 Mar 2022 06:51:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHAjc6UV88TAeKq6mZK5HSi6uYRrD+GMZuSbCOJEerxC44fv/M9qQ6MPpP+40UZpQszOE3AQ==
X-Received: by 2002:ad4:5961:0:b0:435:a1d7:c243 with SMTP id eq1-20020ad45961000000b00435a1d7c243mr3626378qvb.46.1647525106578;
        Thu, 17 Mar 2022 06:51:46 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id s19-20020a05622a179300b002e1ceeb21d0sm3585520qtk.97.2022.03.17.06.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 06:51:46 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:51:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: writeback completion soft lockup BUG in folio_wake_bit()
Message-ID: <YjM88OwoccZOKp86@bfoster>
References: <YjDj3lvlNJK/IPiU@bfoster>
 <YjJPu/3tYnuKK888@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjJPu/3tYnuKK888@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 08:59:39PM +0000, Matthew Wilcox wrote:
> On Tue, Mar 15, 2022 at 03:07:10PM -0400, Brian Foster wrote:
> > What seems to happen is that the majority of the fsync calls end up
> > waiting on writeback of a particular page, the wakeup of the writeback
> > bit on that page wakes a task that immediately resets PG_writeback on
> > the page such that N other folio_wait_writeback() waiters see the bit
> > still set and immediately place themselves back onto the tail of the
> > wait queue.  Meanwhile the waker task spins in the WQ_FLAG_BOOKMARK loop
> > in folio_wake_bit() (backing off the lock for a cycle or so in each
> > iteration) only to find the same bunch of tasks in the queue. This
> > process repeats for a long enough amount of time to trigger the soft
> > lockup warning. I've confirmed this spinning behavior with a tracepoint
> > in the bookmark loop that indicates we're stuck for many hundreds of
> > thousands of iterations (at least) of this loop when the soft lockup
> > warning triggers.
> 
> [...]
> 
> > I've run a few quick experiments to try and corroborate this analysis.
> > The problem goes away completely if I either back out the loop change in
> > folio_wait_writeback() or bump WAITQUEUE_WALK_BREAK_CNT to something
> > like 128 (i.e. greater than the total possible number of waiter tasks in
> > this test). I've also played a few games with bookmark behavior mostly
> > out of curiosity, but usually end up introducing other problems like
> > missed wakeups, etc.
> 
> As I recall, the bookmark hack was introduced in order to handle
> lock_page() problems.  It wasn't really supposed to handle writeback,
> but nobody thought it would cause any harm (and indeed, it didn't at the
> time).  So how about we only use bookmarks for lock_page(), since
> lock_page() usually doesn't have the multiple-waker semantics that
> writeback has?
> 

Oh, interesting. I wasn't aware of the tenuous status of the bookmark
code. This is indeed much nicer than anything I was playing with. I
suspect it will address the problem, but I'll throw it at my test env
for a while and follow up.. thanks!

Brian

> (this is more in the spirit of "minimal patch" -- I think initialising
> the bookmark should be moved to folio_unlock()).
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b2728eb52407..9ee3c5f1f489 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1146,26 +1146,28 @@ static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync,
>  	return (flags & WQ_FLAG_EXCLUSIVE) != 0;
>  }
>  
> -static void folio_wake_bit(struct folio *folio, int bit_nr)
> +static void folio_wake_bit(struct folio *folio, int bit_nr,
> +		wait_queue_entry_t *bookmark)
>  {
>  	wait_queue_head_t *q = folio_waitqueue(folio);
>  	struct wait_page_key key;
>  	unsigned long flags;
> -	wait_queue_entry_t bookmark;
>  
>  	key.folio = folio;
>  	key.bit_nr = bit_nr;
>  	key.page_match = 0;
>  
> -	bookmark.flags = 0;
> -	bookmark.private = NULL;
> -	bookmark.func = NULL;
> -	INIT_LIST_HEAD(&bookmark.entry);
> +	if (bookmark) {
> +		bookmark->flags = 0;
> +		bookmark->private = NULL;
> +		bookmark->func = NULL;
> +		INIT_LIST_HEAD(&bookmark->entry);
> +	}
>  
>  	spin_lock_irqsave(&q->lock, flags);
> -	__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
> +	__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, bookmark);
>  
> -	while (bookmark.flags & WQ_FLAG_BOOKMARK) {
> +	while (bookmark && (bookmark->flags & WQ_FLAG_BOOKMARK)) {
>  		/*
>  		 * Take a breather from holding the lock,
>  		 * allow pages that finish wake up asynchronously
> @@ -1175,7 +1177,7 @@ static void folio_wake_bit(struct folio *folio, int bit_nr)
>  		spin_unlock_irqrestore(&q->lock, flags);
>  		cpu_relax();
>  		spin_lock_irqsave(&q->lock, flags);
> -		__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
> +		__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, bookmark);
>  	}
>  
>  	/*
> @@ -1204,7 +1206,7 @@ static void folio_wake(struct folio *folio, int bit)
>  {
>  	if (!folio_test_waiters(folio))
>  		return;
> -	folio_wake_bit(folio, bit);
> +	folio_wake_bit(folio, bit, NULL);
>  }
>  
>  /*
> @@ -1554,12 +1556,15 @@ static inline bool clear_bit_unlock_is_negative_byte(long nr, volatile void *mem
>   */
>  void folio_unlock(struct folio *folio)
>  {
> +	wait_queue_entry_t bookmark;
> +
>  	/* Bit 7 allows x86 to check the byte's sign bit */
>  	BUILD_BUG_ON(PG_waiters != 7);
>  	BUILD_BUG_ON(PG_locked > 7);
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (clear_bit_unlock_is_negative_byte(PG_locked, folio_flags(folio, 0)))
> -		folio_wake_bit(folio, PG_locked);
> +		folio_wake_bit(folio, PG_locked, &bookmark);
>  }
>  EXPORT_SYMBOL(folio_unlock);
>  
> @@ -1578,7 +1583,7 @@ void folio_end_private_2(struct folio *folio)
>  {
>  	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
>  	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
> -	folio_wake_bit(folio, PG_private_2);
> +	folio_wake_bit(folio, PG_private_2, NULL);
>  	folio_put(folio);
>  }
>  EXPORT_SYMBOL(folio_end_private_2);
> 

