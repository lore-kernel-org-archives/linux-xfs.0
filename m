Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8B8C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F18620672
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 19:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593459508;
	bh=4ECl/pIPEUH2v5bmJI4o9fIfWPNuwnv1Iy+dGSbkmYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=V/W+s3Kl412g8lUXRl3qTC7nIl8i9/6gXmHIQititPBfUJ/Pmb2ukTK9nwFw1UIiD
	 Rz7L+9QhoxHafKJ2WsG5+5oBnGIos/LT5WKwxL+hENTg5knBT8fBQ6hwzdlW0+btT9
	 TuB6gWFl8y/jdmX6gDCROPGR7pF9uUaplaHJQXiI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgF2Ti1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387449AbgF2Tho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:37:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA6BC02A549;
        Mon, 29 Jun 2020 05:52:34 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so12727584edr.9;
        Mon, 29 Jun 2020 05:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mISjJ6W1t59EyOgM95PXut3o9oWxsupqoczgWBu6EVM=;
        b=U+aAv48PQQCnh+KsZHoyXJp2fb+2JKRI7qPY/jFla8ukJUA0pqSumSJaqLP1d1c/Tg
         QfUulpfaMxcxtpRdA0xd2YvPRJYF0X1F3NE3vdK3UR/tDmi+QfDx9cT7UXKBbtjjsPpF
         3v4QE6RY8FZ0bO8xAJT/vUL8eTbWWxXWI+uwWu5Y/HETw6WBlLZHUxfxQG9ZsmdduygF
         IeV+sFppe6kmQwReUz8SndYScV/KQSW3/ARWhd2MV7oZPNecQ2kLXmxVp2QkAvjFKRFH
         Xaj0Qb8zk7m4nJUPj85jBwjxDU6FgXx6o++a7QOXmvJWBIMIKwmSdEQ1n0HiqP9ql7he
         d52Q==
X-Gm-Message-State: AOAM532rcdftR3zqGww/nsy4sirU2uOjxsKLIudipP8lgdUdqSGTAyxn
        JQY4PQmIgkpBxm3WL52Qw/E=
X-Google-Smtp-Source: ABdhPJwKuDYNd8lQ0rDIYcM14Sny/O73oVLrmaxeBF52BJhJLTspOZ/6aPol9DAWu4TfLKyk6WFptw==
X-Received: by 2002:a05:6402:1c96:: with SMTP id cy22mr17042750edb.79.1593435153360;
        Mon, 29 Jun 2020 05:52:33 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id r17sm4808969edw.68.2020.06.29.05.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:52:32 -0700 (PDT)
Date:   Mon, 29 Jun 2020 14:52:31 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200629125231.GJ32461@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629121816.GC25523@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon 29-06-20 13:18:16, Matthew Wilcox wrote:
> On Mon, Jun 29, 2020 at 08:08:51AM +0300, Mike Rapoport wrote:
> > > @@ -886,8 +868,12 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> > >  			return NULL;
> > >  
> > >  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> > > +			unsigned noio_flag;
> > > +
> > >  			dm_bufio_unlock(c);
> > > -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > > +			noio_flag = memalloc_noio_save();
> > 
> > I've read the series twice and I'm still missing the definition of
> > memalloc_noio_save().
> > 
> > And also it would be nice to have a paragraph about it in
> > Documentation/core-api/memory-allocation.rst
> 
> Documentation/core-api/gfp_mask-from-fs-io.rst:``memalloc_nofs_save``, ``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
> Documentation/core-api/gfp_mask-from-fs-io.rst:   :functions: memalloc_noio_save memalloc_noio_restore
> Documentation/core-api/gfp_mask-from-fs-io.rst:allows nesting so it is safe to call ``memalloc_noio_save`` or
 
The patch is adding memalloc_nowait* and I suspect Mike had that in
mind, which would be a fair request. Btw. we are missing memalloc_nocma*
documentation either - I was just reminded of its existence today...

-- 
Michal Hocko
SUSE Labs
