Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80DAC7EE2F
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 22:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjFLWtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 18:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjFLWtL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 18:49:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F535134
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 15:49:10 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b3ce6607cbso14145605ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 15:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686610150; x=1689202150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yMmxc/ZlzSp2pSayA1Jf1ORJAaDDiWOvtHQDYBNVV8M=;
        b=NH3KQ5JfGCKVpwqPaAEgYXMxvNFw5MkhqRqv7qrZCuIPXEElqQsUUnR5gbea6hySqt
         uUdx5wCCaElTMw0wi9fMb/R4D9iwEt7ivJRqlLcBYfspx/rc2suctrnU1X+iAVnuuUSa
         NeJKwayhxt8MfmXwSOf6opiuvlro2pYjcOARrb5DZ4Gath9jpIKRwU7/mhObrpSxnNz3
         KA11fLu9Miu0dXi15GGqv6sXHOCPflKscboXmmb2EYLUfLlb8UwsWDrQlqaFyHFs78Kz
         aRXRSLoi/OfgaqOMMukpt0HKkmQBltzIRtsu74VQEoS2fzbQ2+NPLT9HqTA42fS716YZ
         xn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686610150; x=1689202150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMmxc/ZlzSp2pSayA1Jf1ORJAaDDiWOvtHQDYBNVV8M=;
        b=kfqC6z6vw4+rM1dunDt2bxW4Gy8hyDBkF96uEOQrTCdkxaHrFQRDKiAIi0qdH7WlW7
         MTbq2ny0PFtSv1zbT4sKhozij2ig681Y4KDO943uxpyH4LIjcQFutkSmz3HlcKXpItzf
         2Vyk5XdIoappGaoH1K0+Tho6TUEs6a8Y6VLb1gXtara3R6+1z/pxMxOSVz1w/SreZazD
         7drLpZfU9+/ta0rBx8gbM90K4WL4GhKetw9qvrNZhnmmnuNRhQXlfKsYNJJexQIumzBb
         vmYt6KYt72zTUBER895OrZI7tJSqHr7+5pdtMJRq0zbVesgJ46gi8C8jbklm4kTiFBMD
         Mk6A==
X-Gm-Message-State: AC+VfDzBHwSA0HJIRh+0/l28vIcXsLvCSoagzdOHHEGvEE5y0ZUOO+SI
        xtjhhAHe8pAmJrHOawL0N8mfwg==
X-Google-Smtp-Source: ACHHUZ6TSeaogH4KYTW1IoJN8v9NiL+QRZJAZ96mx033PX6idn2fqyo+u1Ja4kGseUdUrRBTdYpvWw==
X-Received: by 2002:a17:902:b008:b0:1b3:bd59:8c9 with SMTP id o8-20020a170902b00800b001b3bd5908c9mr5957005plr.43.1686610149884;
        Mon, 12 Jun 2023 15:49:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id jo23-20020a170903055700b001993a1fce7bsm8738946plb.196.2023.06.12.15.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:49:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8qLR-00B3Dh-1L;
        Tue, 13 Jun 2023 08:49:05 +1000
Date:   Tue, 13 Jun 2023 08:49:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 6/8] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZIeg4Uak9meY1tZ7@dread.disaster.area>
References: <20230612203910.724378-1-willy@infradead.org>
 <20230612203910.724378-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612203910.724378-7-willy@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 09:39:08PM +0100, Matthew Wilcox (Oracle) wrote:
> Allow callers of __filemap_get_folio() to specify a preferred folio
> order in the FGP flags.  This is only honoured in the FGP_CREATE path;
> if there is already a folio in the page cache that covers the index,
> we will return it, no matter what its order is.  No create-around is
> attempted; we will only create folios which start at the specified index.
> Unmodified callers will continue to allocate order 0 folios.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
.....
> -		/* Init accessed so avoid atomic mark_page_accessed later */
> -		if (fgp_flags & FGP_ACCESSED)
> -			__folio_set_referenced(folio);
> +		if (!mapping_large_folio_support(mapping))
> +			order = 0;
> +		if (order > MAX_PAGECACHE_ORDER)
> +			order = MAX_PAGECACHE_ORDER;
> +		/* If we're not aligned, allocate a smaller folio */
> +		if (index & ((1UL << order) - 1))
> +			order = __ffs(index);

If I read this right, if we pass in an unaligned index, we won't get
the size of the folio we ask for?

e.g. if we want an order-4 folio (64kB) because we have a 64kB block
size in the filesystem, then we have to pass in an index that
order-4 aligned, yes?

I ask this, because the later iomap code that asks for large folios
only passes in "pos >> PAGE_SHIFT" so it looks to me like it won't
allocate large folios for anything other than large folio aligned
writes, even if we need them.

What am I missing?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
