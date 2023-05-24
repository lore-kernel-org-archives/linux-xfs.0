Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A697EC77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 21:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjEXV5C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 17:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjEXV5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 17:57:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BCCD3
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 14:57:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-25374c9be49so694566a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 14:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684965420; x=1687557420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PAhC/flunH4mhtUx9WkifybqdgbT+jLIDs5rKRqBH18=;
        b=VcANevIbUge33+JiwrVldMPsDVseKzleSpEoGVXvCtvf59KvdrxkNaG3LuTkHdW4Jk
         bifOJhE2t54HMCgFf22CN2SG1cVz5SG5Lko5jtDAvmJP1YtUNTibOJe5TrnwIpvIOFYR
         dOrd/xuRTa+VnYbxbX7Rn0MbebnB6yrfeiMEBHHLsoKYVoaHG7M7CsH56LaK0Gh7rdBq
         C2unCUg13w37PapsE/+jP/rfI9e9ejFvHv85XK6ohMG1yFOAxI5zmjatNWwb/cCXOFso
         h/YeuYHyIZlpMyxTKJUzb+DpHWDl8D7Slzl1NiYD68IRDEkqt8JInDTOFbEVdcrm4ai5
         6/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684965420; x=1687557420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAhC/flunH4mhtUx9WkifybqdgbT+jLIDs5rKRqBH18=;
        b=P7hqjwV4581n9wdJ0AJn7PN8GWQlH3Cj0sp62Hl8AXJ5kciXa9pnKGwZGEG6q99+L1
         0v6mZSJ9Wnfm2wHqpHm9oo6qQbL8x8ZZ5OZ1aMKtSAU+Kk2crU57M/AIkqwmTQtPE+9v
         Rh6bk0KEOJdfI9u2X7pT7+mkTSSUB3VlS/QL7+ZTrMf3YvjgQu2p3AW8sD+ufgewukPj
         ooiFGlNmAxyfpG38PrfxS7kCC8g9dL7lkUZrHGZIx6KN+UYOK5jS1PwLV3OAS7r2rAVP
         j5r652ZTVNLU/ma0dVwtIyqbWsr5W9Rz+pm1lYICmKiJtlzkPXQe/kGd57jUZ7O9LMXM
         dAGA==
X-Gm-Message-State: AC+VfDyaa822R5QUjSOCO+eXundSM7oVeMYrE9QG4rdnqLLf7BAcLuDA
        BR3Phb6OZR5FLJXac5goltXRBg==
X-Google-Smtp-Source: ACHHUZ5QRESsHt/p5Vp49+LOpaxi0xAHAvojh3fT62UGmVDu+zceNYswQcWGKavnizqXEm1VGKl/5w==
X-Received: by 2002:a17:90b:46d1:b0:247:529f:92d7 with SMTP id jx17-20020a17090b46d100b00247529f92d7mr19482622pjb.8.1684965420233;
        Wed, 24 May 2023 14:57:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a018800b0024e41f23a2dsm1954764pjc.3.2023.05.24.14.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 14:56:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1wTY-003UIE-1M;
        Thu, 25 May 2023 07:56:56 +1000
Date:   Thu, 25 May 2023 07:56:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] Mitigate a vmap lock contention
Message-ID: <ZG6IKE7yNEkJhge+@dread.disaster.area>
References: <20230522110849.2921-1-urezki@gmail.com>
 <ZGyqiaRnMJPFhxR6@debian-BULLSEYE-live-builder-AMD64>
 <ZGzX3vRMlGHIcYCe@pc636>
 <ZG0AE9mjHkRZIGmr@debian-BULLSEYE-live-builder-AMD64>
 <ZG3d1FUXiCk3QL3D@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG3d1FUXiCk3QL3D@pc636>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 11:50:12AM +0200, Uladzislau Rezki wrote:
> On Wed, May 24, 2023 at 03:04:28AM +0900, Hyeonggon Yoo wrote:
> > On Tue, May 23, 2023 at 05:12:30PM +0200, Uladzislau Rezki wrote:
> > And I would like to ask some side questions:
> > 
> > 1. Is vm_[un]map_ram() API still worth with this patchset?
> > 
> It is up to community to decide. As i see XFS needs it also. Maybe in
> the future it can be removed(who knows). If the vmalloc code itself can
> deliver such performance as vm_map* APIs.

vm_map* APIs cannot be replaced with vmalloc, they cover a very
different use case.  i.e.  vmalloc allocates mapped memory,
vm_map_ram() maps allocated memory....

> vm_map_ram() and friends interface was added because of vmalloc drawbacks.

No. vm_map*() were scalability improvements added in 2009 to replace
on vmap() and vunmap() to avoid global lock contention in the vmap
allocator that XFS had been working around for years with it's own
internal vmap cache....

commit 95f8e302c04c0b0c6de35ab399a5551605eeb006
Author: Nicholas Piggin <npiggin@gmail.com>
Date:   Tue Jan 6 14:43:09 2009 +1100

    [XFS] use scalable vmap API
    
    Implement XFS's large buffer support with the new vmap APIs. See the vmap
    rewrite (db64fe02) for some numbers. The biggest improvement that comes from
    using the new APIs is avoiding the global KVA allocation lock on every call.
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Reviewed-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

vmap/vunmap() themselves were introduce in 2.5.32 (2002) and before
that XFS was using remap_page_array() and vfree() in exactly the
same way it uses vm_map_ram() and vm_unmap_ram() today....

XFS has a long, long history of causing virtual memory allocator
scalability and contention problems. As you can see, this isn't our
first rodeo...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
