Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61ECC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974D6207D8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593092066;
	bh=4uUKv9yZQ+d0WH6ig3pTANqZS7eTFL8+eTpP5kzMW18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FyphyK1oT31L9C7n7CJw2L0DtvK/zc5/NjK7wFLPSl5h7mY6lKVpdZbEnjvbIb59D
	 RdJAN2f6VZN2ufNJTPL0y/WArMWRlqMBm+1ShOrry9NE2a9BRJ5v7wT9SOAuD3cHYT
	 l6yTy/Ch4BBsaTLsXrSgUDtrq9gSY1SSi6Wzuzco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404890AbgFYNe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 09:34:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46240 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404887AbgFYNeZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 09:34:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id r12so5822223wrj.13;
        Thu, 25 Jun 2020 06:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gso1n2O6qGt4XCAgbt0r3fAr2sgINjgku+sh5gi1NWY=;
        b=YrSiL+bhSkP3DGVZbeMU6uDdO5rGNyfx+cE4jWQP2bnqbyTHwZsjEjAOWp6LVDcRki
         kn9PbTpyqJKNgFAqjSRfxw4+tr5zyBg/pDZFdP4CG1/pOwPizrW2ltJj1fmGorYFOnSh
         JH5fQleFTic665Pzk0pRY3DKsA8vBlIxMTlUefltq9vQLJZpEQplJK1Qf7wO8u3uMGle
         ep18mv10PD9kBv+YaJu3MIlpy1CFBkM7J4vpTfoCXrWcKJs4Mm5mPxOR1xbpzjFkCorX
         XDJX2Vic/yLoWUESTChqKX3lCah3dTCgK2lKqjvItGZXcFpjmrY5kQjJ+ux0E9cs0nnX
         UE0Q==
X-Gm-Message-State: AOAM532cB+cgZWbl8gR96PY0MeDjtL5seZZyiQfjpN98yuBKt2cd9uun
        UJSMHadei4nAS0V0l/GWLXY=
X-Google-Smtp-Source: ABdhPJzpVrNaN5j5rVGXAiejljpXNjMiCVf/+8PXhmVJ4820v+TwTrdbGmEOyJwMQNORqxQ5JfER4g==
X-Received: by 2002:adf:9c8c:: with SMTP id d12mr6351189wre.369.1593092063507;
        Thu, 25 Jun 2020 06:34:23 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id v66sm12924082wme.13.2020.06.25.06.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 06:34:22 -0700 (PDT)
Date:   Thu, 25 Jun 2020 15:34:20 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200625133420.GN1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200625124017.GL1320@dhcp22.suse.cz>
 <20200625131055.GC7703@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625131055.GC7703@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 25-06-20 14:10:55, Matthew Wilcox wrote:
> On Thu, Jun 25, 2020 at 02:40:17PM +0200, Michal Hocko wrote:
> > On Thu 25-06-20 12:31:22, Matthew Wilcox wrote:
> > > Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> > > guarantees we will not sleep to reclaim memory.  Use it to simplify
> > > dm-bufio's allocations.
> > 
> > memalloc_nowait is a good idea! I suspect the primary usecase would be
> > vmalloc.
> 
> That's funny.  My use case is allocating page tables in an RCU protected
> page fault handler.  Jens' use case is allocating page cache.  This one
> is a vmalloc consumer (which is also indirectly page table allocation).
> 
> > > @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> > >  	 */
> > >  	while (1) {
> > >  		if (dm_bufio_cache_size_latch != 1) {
> > > -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			unsigned nowait_flag = memalloc_nowait_save();
> > > +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			memalloc_nowait_restore(nowait_flag);
> > 
> > This looks confusing though. I am not familiar with alloc_buffer and
> > there is quite some tweaking around __GFP_NORETRY in alloc_buffer_data
> > which I do not follow but GFP_KERNEL just struck my eyes. So why cannot
> > we have 
> > 		alloc_buffer(GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> 
> Actually, I wanted to ask about the proliferation of __GFP_NOMEMALLOC
> in the block layer.  Am I right in thinking it really has no effect
> unless GFP_ATOMIC is set?

It does have an effect as an __GFP_MEMALLOC resp PF_MEMALLOC inhibitor.

> It seems like a magic flag that some driver
> developers are sprinkling around randomly, so we probably need to clarify
> the documentation on it.

Would the following make more sense?
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 67a0774e080b..014aa7a6d36a 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -116,8 +116,9 @@ struct vm_area_struct;
  * Usage of a pre-allocated pool (e.g. mempool) should be always considered
  * before using this flag.
  *
- * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
- * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
+ * %__GFP_NOMEMALLOC is used to inhibit __GFP_MEMALLOC resp. process scope
+ * variant of it PF_MEMALLOC. So use this flag if the caller of the allocation
+ * context might contain one or the other.
  */
 #define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)

> What I was trying to do was just use the memalloc_nofoo API to control
> what was going on and then the driver can just use GFP_KERNEL.  I should
> probably have completed that thought before sending the patches out.

Yes the effect will be the same but it just really hit my eyes as this
was in the same diff. IMHO GFP_NOWAIT would be easier to grasp but
nothing I would dare to insist on.
-- 
Michal Hocko
SUSE Labs
