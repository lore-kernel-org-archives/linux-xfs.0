Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438C5C7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 01:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjFMBaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjFMBaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 21:30:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4383C170C
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 18:30:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-66577752f05so1453072b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 18:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686619817; x=1689211817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uytqQvisQYHjxOHA4vjUFzrt/GwbMg4VQA4FTS7AAMY=;
        b=BcFs2lv0zGN4Mb471XTP36FDHFI9vXzrrFms42vl4qjX64pQCdcf0vUomhhaTaBXHZ
         MeLguwcGa++fRRI/l1CB8eZGOVRu7WZPlWtGL3OlW7vH+mj1zp7bIyP/lIvuGiH5bJuO
         TWj72dOO4t4bhe+iY06sSrgmzw73sHlBcYHAtscQWOy7rB0eSj0ukPHmteu+KvUWWe6f
         CcylXlaAZf9/Nxr06pPbPP/JKSbvJafFBSIbDLvio6VfFucPyypHOI6FYEQLdiUZwoZq
         a84igTds7TJ1rSTXXAF1OIMYO4vevo0w004wx3m4r1McpUHEDf6ejgHLit1CUPOIBoGH
         N17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686619817; x=1689211817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uytqQvisQYHjxOHA4vjUFzrt/GwbMg4VQA4FTS7AAMY=;
        b=BFNKF4jZdgYGzaqcyUuc2/K6+9j+jJp8ZsirtLNDq8r1Ad498mW1c8jPcQ7wvjmcEB
         aObmh2rmk0ndxcyDn9D36t88YzQQZsD985puYpl3sOrCpa0vpFvj8TICn67EP3CvvYXp
         9YnwCLzV65a7mCLnadW7lOkqcJASQhMX3BWbjx4am86xpRlgaiHYgheh0OkNrTWpqIM3
         KomWpChasjVZhoi1OetZAy+UPL5Nca9ThwpKkAKtxwIE+j42nMTTxxZT+k449WxMpiq8
         FYTktT5ZqtO+bePA3oYM2RidCBm2P9ws5GipmharNywJkLN06nst5cUO2uPbNCDiTYAZ
         tClQ==
X-Gm-Message-State: AC+VfDyVZyocZ0Qlg/ZbTctfUzsVejHiApMIQrWfC1WsHl7+ueTrx8NP
        93CbLPo8Bi4OuLWl9qrMH/RObTQEP37lony8gSg=
X-Google-Smtp-Source: ACHHUZ7IWLXUEJoW+cQmVh45QhQmtdI40L0coelq4Mfa1Yn8gUuJHmMASVvnasfeD/Si+qbpNp6Tgw==
X-Received: by 2002:aa7:8889:0:b0:64d:1451:8233 with SMTP id z9-20020aa78889000000b0064d14518233mr13309716pfe.21.1686619816691;
        Mon, 12 Jun 2023 18:30:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id l19-20020a62be13000000b0066145d63b1asm7489917pff.138.2023.06.12.18.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 18:30:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8srN-00B62r-0o;
        Tue, 13 Jun 2023 11:30:13 +1000
Date:   Tue, 13 Jun 2023 11:30:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 6/8] filemap: Allow __filemap_get_folio to allocate
 large folios
Message-ID: <ZIfGpWYNA1yd5K/l@dread.disaster.area>
References: <20230612203910.724378-1-willy@infradead.org>
 <20230612203910.724378-7-willy@infradead.org>
 <ZIeg4Uak9meY1tZ7@dread.disaster.area>
 <ZIe7i4kklXphsfu0@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIe7i4kklXphsfu0@casper.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2023 at 01:42:51AM +0100, Matthew Wilcox wrote:
> On Tue, Jun 13, 2023 at 08:49:05AM +1000, Dave Chinner wrote:
> > On Mon, Jun 12, 2023 at 09:39:08PM +0100, Matthew Wilcox (Oracle) wrote:
> > > Allow callers of __filemap_get_folio() to specify a preferred folio
> > > order in the FGP flags.  This is only honoured in the FGP_CREATE path;
> > > if there is already a folio in the page cache that covers the index,
> > > we will return it, no matter what its order is.  No create-around is
> > > attempted; we will only create folios which start at the specified index.
> > > Unmodified callers will continue to allocate order 0 folios.
> > .....
> > > -		/* Init accessed so avoid atomic mark_page_accessed later */
> > > -		if (fgp_flags & FGP_ACCESSED)
> > > -			__folio_set_referenced(folio);
> > > +		if (!mapping_large_folio_support(mapping))
> > > +			order = 0;
> > > +		if (order > MAX_PAGECACHE_ORDER)
> > > +			order = MAX_PAGECACHE_ORDER;
> > > +		/* If we're not aligned, allocate a smaller folio */
> > > +		if (index & ((1UL << order) - 1))
> > > +			order = __ffs(index);
> > 
> > If I read this right, if we pass in an unaligned index, we won't get
> > the size of the folio we ask for?
> 
> Right.  That's implied by (but perhaps not obvious from) the changelog.
> Folios are always naturally aligned in the file, so an order-4 folio
> has to start at a multiple of 16.  If the index you pass in is not
> a multiple of 16, we can't create an order-4 folio without starting
> at an earlier index.
> 
> For a 4kB block size filesystem, that's what we want.  Applications
> _generally_ don't write backwards, so creating an order-4 folio is just
> wasting memory.
> 
> > e.g. if we want an order-4 folio (64kB) because we have a 64kB block
> > size in the filesystem, then we have to pass in an index that
> > order-4 aligned, yes?
> > 
> > I ask this, because the later iomap code that asks for large folios
> > only passes in "pos >> PAGE_SHIFT" so it looks to me like it won't
> > allocate large folios for anything other than large folio aligned
> > writes, even if we need them.
> > 
> > What am I missing?
> 
> Perhaps what you're missing is that this isn't trying to solve the
> problem of supporting a bs > ps filesystem?

No, that's not what I'm asking about. I know there's other changes
needed to enforce minimum folio size/alignment for bs > ps.

What I'm asking about is when someone does a 16kB write at offset
12kB, they won't get a large folio allocated at all, right? Even
though the write is large enough to enable it?

Indeed, if we do a 1MB write at offset 4KB, we'll get 4kB at 4KB, 8KB
and 12kB (because we can't do order-1 folios), then order-2 at 16KB,
order-3 at 32kB, and so on until we hit offset 1MB where we will do
an order-0 folio allocation again (because the remaining length is
4KB). The next 1MB write will then follow the same pattern, right?

I think this ends up being sub-optimal and fairly non-obvious
non-obvious behaviour from the iomap side of the fence which is
clearly asking for high-order folios to be allocated. i.e. a small
amount of allocate-around to naturally align large folios when the
page cache is otherwise empty would make a big difference to the
efficiency of non-large-folio-aligned sequential writes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
