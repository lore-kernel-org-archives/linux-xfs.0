Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19629C636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 21:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBIVyD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 16:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBIVyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 16:54:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62A063129
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 13:54:01 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso7216213pju.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 13:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oX/lGmYsdyx5VnhUGqtR+KDAdmrsp9Y/YPHFCTjwNA=;
        b=Dka+5DdMdyuJvweTAJtER7ujyyrCUwCe7DZogFEspsK7zh/SU9WcyEFz8K9FPImVEx
         fVJTz1DCFLQFbRcXrYhMAlDtL42Wzyqv1YdFqNdD4i5wX2o6LFQiHw/Ut3SZ8mSYDaFt
         ajAqsQ/eWwraRs5nLh46MxwPRfQQkHe9xu3WRyeB2E0nIA9pqT//ImS/ilF3reKnS318
         s52iLbBbRBMvr91PhWvVABusRn4qwzys1mmvDkN1XyMveU2OpjzikGbARFQy6DbNufEX
         vmI8ThZrgVJ4hsy8KfZl3B/uOduwMhMaCn3oewsfyEeMuFYZwKkdG+z9Hsi2iiU7xIWN
         P88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oX/lGmYsdyx5VnhUGqtR+KDAdmrsp9Y/YPHFCTjwNA=;
        b=ggI0JrywhXAqjoimgcB43B5ly8hqFnZmU5vTyRsTmMgMFiGSW6BDZQHpSyAJGk8KB5
         UdDkTeUIIXUyMhYLC6taJIj2wyxYdhRliaGTwlGQilj1lUMtaJpXlFuKwbVq85/Kop/C
         DXVkITeEK/35lJK0bQiUJ+g/rob6HAcVSyMQnCx/gEP8hVqIk5FBI/C8ZSvVrQ7xw6+N
         cHFyWJptITfbip97A3KPy2I1Jx5PKscqROQLlm9G2EagzGbF2PWXZ2PWkAXMMMpMVDdk
         xz2sZP8o/DP3XQCI3bMtnB1T6cyP9bfb1565eYNcUokzZrnP7sW8OhHraUYAE1Ts81b8
         hw3Q==
X-Gm-Message-State: AO0yUKXM7q20Ebv9JmyOVI/pZCMeufy/w1tNcMghqKn7XKKlcVz4uixx
        0eypIFx8te8njDXRcrLcoSwB+9TCeIY53Gjf
X-Google-Smtp-Source: AK7set+AzVGstAfdK4z0lHZ07rf0XD9ogpNvaI86WtR3MzF0pWUdM+mcOrZ5j7LF7wQNCocTD+G2iQ==
X-Received: by 2002:a05:6a20:7f8e:b0:c0:b55b:8259 with SMTP id d14-20020a056a207f8e00b000c0b55b8259mr14663046pzj.0.1675979641353;
        Thu, 09 Feb 2023 13:54:01 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id j16-20020a62e910000000b0058d9a5bac88sm1885080pfh.203.2023.02.09.13.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:54:00 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQEre-00DO2z-CV; Fri, 10 Feb 2023 08:53:58 +1100
Date:   Fri, 10 Feb 2023 08:53:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Remove xfs_filemap_map_pages() wrapper
Message-ID: <20230209215358.GG360264@dread.disaster.area>
References: <20230208145335.307287-1-willy@infradead.org>
 <20230208145335.307287-2-willy@infradead.org>
 <Y+PQN8cLdOXST20D@magnolia>
 <Y+PX5tPyOP2KQqoD@casper.infradead.org>
 <20230208215311.GC360264@dread.disaster.area>
 <Y+ReBH8DFxf+Iab4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+ReBH8DFxf+Iab4@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2023 at 02:44:20AM +0000, Matthew Wilcox wrote:
> On Thu, Feb 09, 2023 at 08:53:11AM +1100, Dave Chinner wrote:
> > > If XFS really needs it,
> > > it can trylock the semaphore and return 0 if it fails, falling back to
> > > the ->fault path.  But I don't think XFS actually needs it.
> > >
> > > The ->map_pages path trylocks the folio, checks the folio->mapping,
> > > checks uptodate, then checks beyond EOF (not relevant to hole punch).
> > > Then it takes the page table lock and puts the page(s) into the page
> > > tables, unlocks the folio and moves on to the next folio.
> > > 
> > > The hole-punch path, like the truncate path, takes the folio lock,
> > > unmaps the folio (which will take the page table lock) and removes
> > > it from the page cache.
> > > 
> > > So what's the race?
> > 
> > Hole punch is a multi-folio operation, so while we are operating on
> > invalidating one folio, another folio in the range we've already
> > invalidated could be instantiated and mapped, leaving mapped
> > up-to-date pages over a range we *require* the page cache to empty.
> 
> Nope.  ->map_pages is defined to _not_ instantiate new pages.
> If there are uptodate pages in the page cache, they can be mapped, but
> missing pages will be skipped, and left to ->fault to bring in.

Sure, but *at the time this change was made* other operations could
instantiate pages whilst an invalidate was running, and then
->map_pages could also find them and map them whilst that
invalidation was still running. i.e. the race conditions that
existed before the mapping->invalidate_lock was introduced (ie. we
couldn't intercept read page faults instantiating pages in the page
cache at all) didn't require ->map_pages to instantiate the page for
it to be able to expose incorrect data to userspace when page faults
raced with an ongoing invalidation operation.

While this may not be able to happen now if everything is using the
mapping->invalidate_lock correctly (because read faults are now
intercepted before they can instatiate new page cache pages), it
doesn't mean it wasn't possible in the past.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
