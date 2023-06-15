Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE218EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 20:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjFOUuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjFOUt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 16:49:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04815123
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 13:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686862151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hKMjMj3FplZLOT+91I/4pBUGTAnLqLsMd/PZxjoHeJI=;
        b=CPNvQkFjHEuxsvDhh3WSwtVKYxwps2xe+Els5GhRvXqp1Bd54Lbu5Oa3LW/zAanctxL/qL
        njFR7XI7Xbb5jgK3810ZbjP/oXfVi/o9ecfJUrqb6OrEF6BbZBtq6hYEFHIzQSGoF5GIWC
        rbJ6H7XMLNbuV2FGxKPch4+VDVa+YRY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-d09s-grfO32S0EhLoCW68g-1; Thu, 15 Jun 2023 16:49:01 -0400
X-MC-Unique: d09s-grfO32S0EhLoCW68g-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3fdd37ded0dso19571cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 13:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686862141; x=1689454141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKMjMj3FplZLOT+91I/4pBUGTAnLqLsMd/PZxjoHeJI=;
        b=dIqUlo8Y6g15GjMcDolnceefj56+J23AMlqo+Pu8MYY0AAGo04m2170mXjiZQI0D3H
         vpUJ09Mr4PWmy4LUzhO5R+JA2GHGHoYrr2SAc34FV1TRh56NGNzBJtsKIEfF/sqmJXv/
         NMDwQXXyWEWxQPLRVa5AMbIa88AjtxusvqTC++hFnExFu9mtCWhrZSdRxSSYr6k/xgxH
         7X1zkHqv3ZP4MaQ113NV847n6BUfTE3GmKvnJrHSqJIdrDK9pzGTGKCzgirCymQKj/Ys
         rK0hGPTQTKdT8DVhNnZIMtuYrXNZRg4eKIZcky9J2uhDR8TXcmboxOuRULiQpYoZgsXc
         BO7Q==
X-Gm-Message-State: AC+VfDwIwFaH9eCCfKfnwA5WqJbC8HfdustNIRaccRjl0giGFzJ7N6FT
        P41lwZG7FQlp9H7GEaCWxMGy/yfG+MsAJhD5ugcK09U/YeCJUKwlldYhtmltQNdutpedgCiq7g9
        jaryzW5zX3o3Ch1eZZwzS
X-Received: by 2002:a05:6214:411c:b0:62d:f62b:907 with SMTP id kc28-20020a056214411c00b0062df62b0907mr205919qvb.0.1686862140903;
        Thu, 15 Jun 2023 13:49:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ67Q0T7UNcg441S5K48ufQ95OaInqX07S7iw3hjgHEcSdnXpq3izlYE7fKD1k9BhKtWSVJMmA==
X-Received: by 2002:a05:6214:411c:b0:62d:f62b:907 with SMTP id kc28-20020a056214411c00b0062df62b0907mr205893qvb.0.1686862140601;
        Thu, 15 Jun 2023 13:49:00 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id d24-20020a05620a159800b0074a6c29df4dsm1117082qkk.119.2023.06.15.13.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 13:48:59 -0700 (PDT)
Date:   Thu, 15 Jun 2023 16:48:58 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com,
        david@redhat.com, Felix.Kuehling@amd.com, linux-mm@kvack.org,
        rcampbell@nvidia.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, hch@lst.de, jglisse@redhat.com,
        apopple@nvidia.com, akpm@linux-foundation.org
Subject: Re: [PATCH v9 02/14] mm: move page zone helpers from mm.h to mmzone.h
Message-ID: <ZIt5Oho3enLFs+sv@x1n>
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-3-alex.sierra@amd.com>
 <ZItneGX+sqg7WApF@x1n>
 <ZItxXny9kRDq/ryf@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZItxXny9kRDq/ryf@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 09:15:26PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 15, 2023 at 03:33:12PM -0400, Peter Xu wrote:
> > My question is whether page_zonenum() is ready for taking all kinds of tail
> > pages?
> > 
> > Zone device tail pages all look fine, per memmap_init_zone_device().  The
> > question was other kinds of usual compound pages, like either thp or
> > hugetlb.  IIUC page->flags can be uninitialized for those tail pages.
> 
> I don't think that's true.  It's my understanding that page->flags is
> initialised for all pages in memmap at boot / hotplug / delayed-init
> time.  So you can check things like zone, node, etc on literally any
> page.  Contrariwise, those flags are not available in tail pages for
> use by the entity that has allocated a compound page / large folio.

Oh so the zone mask is special.  Fair enough.

> 
> Also, I don't believe zone device pages support compound allocation.
> I think they're always allocated as order-0.

Totally not familiar with zone device pages, but memmap_init_zone_device()
has pfns_per_compound which can be >1.  From there, memmap_init_compound()
does go ahead and setup pages as compound ones.

Thanks!

-- 
Peter Xu

