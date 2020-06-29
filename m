Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA12C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAE6206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OTvKQIU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgF2TIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730826AbgF2THn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:07:43 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50862C00E3FB;
        Mon, 29 Jun 2020 05:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IEJE4pzTKwBckHnN8MJnYUJtj55RnUgeieprz/ielos=; b=OTvKQIU8NCpuynReFPzOX7sxPG
        BTVSLs55stmmHraBnRi26uem12+KaQj+V1eI4nr9kOJ5204WgoR9TEDgeWykyEJEGueWoT6zz5Lyn
        JyMjdjzxZuirLVi32k2alVYtkO02n8ePgQVbFBstHngo7UtOTcHEWnd01Xa0KUNi7R5ILAv29WWix
        tUNoRbV17Am92l88NVeSasyGJGdEcZ5maoj/2ZG1Jln2bvXxkxbcWyGOMifdiAetgP2Q5beo1uiI6
        qdSwFTgXdx9bahX+TOjD8VzRMT30ZHxxZY9z+GPv0FVIiW1r26VCh5KcPfDwcqQWEqgWK0thaROa6
        a2mxmwPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpsjo-00026M-RY; Mon, 29 Jun 2020 12:18:16 +0000
Date:   Mon, 29 Jun 2020 13:18:16 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200629121816.GC25523@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629050851.GC1492837@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 29, 2020 at 08:08:51AM +0300, Mike Rapoport wrote:
> > @@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> >  			return NULL;
> >  
> >  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> > +			unsigned noio_flag;
> > +
> >  			dm_bufio_unlock(c);
> > -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > +			noio_flag = memalloc_noio_save();
> 
> I've read the series twice and I'm still missing the definition of
> memalloc_noio_save().
> 
> And also it would be nice to have a paragraph about it in
> Documentation/core-api/memory-allocation.rst

Documentation/core-api/gfp_mask-from-fs-io.rst:``memalloc_nofs_save``, ``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
Documentation/core-api/gfp_mask-from-fs-io.rst:   :functions: memalloc_noio_save memalloc_noio_restore
Documentation/core-api/gfp_mask-from-fs-io.rst:allows nesting so it is safe to call ``memalloc_noio_save`` or

