Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB4FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 02:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhLIC46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 21:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhLIC45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 21:56:57 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5630C061746
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 18:53:24 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id t34so4115922qtc.7
        for <linux-xfs@vger.kernel.org>; Wed, 08 Dec 2021 18:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9lZzV6uRxUvt0RqeIyM4DCy//4WwHZcCj15yKoRWKv0=;
        b=MuH7fGvI/9AD+8Jf3135+Y84ksGN91yCSTt0zoUDEqseX7B2K0YN6lCaPdgDeOMRpm
         GOe7MfuQdBr+Z4wyPuK/X3Oq+E11gqhW44bDipD/o7JNOnqwTqyXLLafarAjz6Qto1ro
         aG+jBeBbWAiByCuS0S6B9hU+pATvx85RKkpkIAQIfLRbW2qUaPcS9Uu6YIpp8W008vUj
         AvLKcneW2BuqADAMC9NC6N/Val8HXTIHMS7sQv01juWNQbBHSKaBSpUv61IEYCjx2r7c
         hWVEXyKPTi4aa/SWCsc4zb+EUhNMyK5Z6Ko/CgGa+RO3zAgIsW2+q5scXiLYdGdjXPHA
         IZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9lZzV6uRxUvt0RqeIyM4DCy//4WwHZcCj15yKoRWKv0=;
        b=y56uIjU+v5P94//p1GHMr5Ygaw9WvyXQN/G6HzZ5WxMGtdbdBdlnKfBP4NtYOXCRfk
         ezzHw0E+GNA9yQBK5ZN4Wn36dN6TUDzeF6ko1UpQJfVKnB8geJ1nsTBbPgz0X6tGcDB/
         n4rIA75uBenIcoU95J0hIGybjDMddG7wtLAo/ZQeQ5nPwBLmV8mUPi7yPJrWaR7JjZF5
         a0w4Iucfp1S5OvMKXK98FuNKf8N3x9z2F4931NrsurgKsm/jjiRTI18IguFMBsF/0TCP
         yeGn+fVfCzEPa8W2THN01qB7yhgTO8p/Bp4GfyCxovDSsSE4xz4971+GW8RTg/NwKsqc
         tvWQ==
X-Gm-Message-State: AOAM5304BUXE8dmXFSPcgDqPMWom+rIHuWdnPVDxBeRxXg4w5mpUFZdd
        ZJ8IV/lGsFF25yhcG8WpXsCpoI4Xw+j6mg==
X-Google-Smtp-Source: ABdhPJzd7PgIaK+OliA8j4qPmgBHphO7odQ23RlPROnXGhIchmoXCBqWvKGTqHwv0CnaCCZT+fN4FA==
X-Received: by 2002:a05:622a:8d:: with SMTP id o13mr13208686qtw.574.1639018404025;
        Wed, 08 Dec 2021 18:53:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id m1sm2800768qtk.34.2021.12.08.18.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 18:53:23 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mv9Yg-000zXC-FC; Wed, 08 Dec 2021 22:53:22 -0400
Date:   Wed, 8 Dec 2021 22:53:22 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     akpm@linux-foundation.org, Felix.Kuehling@amd.com,
        linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Alex Sierra <alex.sierra@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, willy@infradead.org
Subject: Re: [PATCH v2 03/11] mm/gup: migrate PIN_LONGTERM dev coherent pages
 to system
Message-ID: <20211209025322.GE6467@ziepe.ca>
References: <20211206185251.20646-1-alex.sierra@amd.com>
 <2858338.J0npWUQLIM@nvdebian>
 <20211208135345.GC6467@ziepe.ca>
 <117075453.Ddeq1f3ylz@nvdebian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <117075453.Ddeq1f3ylz@nvdebian>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 09, 2021 at 12:45:24PM +1100, Alistair Popple wrote:
> On Thursday, 9 December 2021 12:53:45 AM AEDT Jason Gunthorpe wrote:
> > > I think a similar problem exists for device private fault handling as well and
> > > it has been on my list of things to fix for a while. I think the solution is to
> > > call try_get_page(), except it doesn't work with device pages due to the whole
> > > refcount thing. That issue is blocking a fair bit of work now so I've started
> > > looking into it.
> > 
> > Where is this?
>  
> Nothing posted yet. I've been going through the mailing list and the old
> thread[1] to get an understanding of what is left to do. If you have any
> suggestions they would be welcome.

Oh, that

Joao's series here is the first step:

https://lore.kernel.org/linux-mm/20211202204422.26777-1-joao.m.martins@oracle.com/

I already sent a patch to remove the DRM usage of PUD/PMD -
0d979509539e ("drm/ttm: remove ttm_bo_vm_insert_huge()")

Next, someone needs to change FSDAX to have a folio covering the
ZONE_DEVICE pages before it installs a PUD or PMD. I don't know
anything about FS's to know how to do this at all.

Thus all PUD/PMD entries will point at a head page or larger of a
compound. This is important because all the existing machinery for THP
assumes 1 PUD/PMD means 1 struct page to manipulate.

Then, consolidate all the duplicated code that runs when a page is
removed from a PTE/PMD/PUD etc into a function. Figure out why the
duplications are different to make them the same (I have some rough
patches for this step)

Start with PUD and have zap on PUD call the consolidated function and
make vmf_insert_pfn_pud_prot() accept a struct page not pfn and incr
the refcount. PUD is easy because there is no THP

Then do the same to PMD without breaking the THP code

Then make the PTE also incr the refcount on insert and zap

Exterminate vma_is_special_huge() along the way, there is no such
thing as a special huge VMA without a pud/pmd_special flag so all
things installed here must be struct page and not special.

Then the patches that are already posted are applicable and we can
kill the refcount == 1 stuff. No 0 ref count pages installed in page
tables.

Once all of that is done it is fairly straightforward to remove
pud/pmd/pte_devmap entirely and the pgmap stuff from gup.c

Jason
