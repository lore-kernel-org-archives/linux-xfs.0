Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6868EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 08:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbiLNINI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 03:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLNIMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 03:12:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B514725E7
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 00:12:16 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q71so1468374pgq.8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 00:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZJrEQllm//cEBpd6Ownxchy/LqJjVabroro+MRnz3Y=;
        b=FWKoID1R9sAFzv+msfzk2xBsdhldtMQ0/grUSM41gYDoLnKlU6Pmd+CKtLTCdFW/B8
         ioKqqe67nk+9r9CKthk2GUxAFjZB8vDiboIvmp83chqxP8PQkazwdQPFLnhk/Q5y2vm8
         GhHpWgvci9jZMk4Tg8fJhL1lpZ3TD3UShQlytWdin+cDqFcX7r3msW3w89UMMPA4dfXd
         5vtR/sy3dZNs30vyOytXE0265ArMkBUQ0+UBKwxBdEqyY6NMxR9XBYXhI34cM7fWattS
         bK5BU94YF02WbwQrJ7u4jQtmogmGaGD9mEyzuExqlzIkhWvERJTt4saJmoZhaUiS7V8o
         w5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZJrEQllm//cEBpd6Ownxchy/LqJjVabroro+MRnz3Y=;
        b=Un7t2P+/ImuiGil0mfhEa2MvimqjIe71z9IZVOOTK5BS2OeV2Zma8K4exXDvlBCe2A
         ugt24wYoufI5m8dqp0pfg67kkNqR8ym+KjNVRfZwGot8Qyp/tGYz06J/tSZV4RSLj6sZ
         LZnmsrT53/B8E6fU1N4CFDT4/KoDDG0X21POLdDouz/pWr6Bj2GvXGBCqScdBfNjFFJR
         Qtr9hatwJV5w07VD6pV+32067QQwqSpqT95jC7Lg0SgXpmYxB0HtFb4atvBvSAYYnBPx
         iZoMeJ74K0JgxyfKYlE1WbXvaIH0sjWhHt5CgO30A07/gqiAvsH2TqdHPgO2P00BltWO
         F/pQ==
X-Gm-Message-State: ANoB5pm+PBGzm9byKnjGT3Q9zIq7nRWfV793CSNQbbzVxJmP8nt8OCm2
        ck788/LM/JjKT7U//OqPPGVylQ==
X-Google-Smtp-Source: AA0mqf6eZgXwaabP0OLXsli10FO2txKn0USU/6nzxGQS/WqisC0MdjZOIJYfZ06kv3hY0twbLBC0dQ==
X-Received: by 2002:aa7:804a:0:b0:566:94d0:8c83 with SMTP id y10-20020aa7804a000000b0056694d08c83mr22484377pfm.7.1671005536225;
        Wed, 14 Dec 2022 00:12:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id 69-20020a621648000000b0057630286100sm8852462pfw.164.2022.12.14.00.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 00:12:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5Ms8-008GnZ-O5; Wed, 14 Dec 2022 19:12:12 +1100
Date:   Wed, 14 Dec 2022 19:12:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] pagemap: add mapping_clear_large_folios()
 wrapper
Message-ID: <20221214081212.GK3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-3-aalbersh@redhat.com>
 <Y5i8igBLu+6OQt8H@casper.infradead.org>
 <Y5jTosRngrhzPoge@sol.localdomain>
 <20221213211010.GX3600936@dread.disaster.area>
 <Y5lym4fJK+9u2cxe@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5lym4fJK+9u2cxe@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 10:52:11PM -0800, Eric Biggers wrote:
> On Wed, Dec 14, 2022 at 08:10:10AM +1100, Dave Chinner wrote:
> > On Tue, Dec 13, 2022 at 11:33:54AM -0800, Eric Biggers wrote:
> > > On Tue, Dec 13, 2022 at 05:55:22PM +0000, Matthew Wilcox wrote:
> > > > I'm happy to work with you to add support for large folios to verity.
> > > > It hasn't been high priority for me, but I'm now working on folio support
> > > > for bufferhead filesystems and this would probably fit in.
> > > 
> > > I'd be very interested to know what else is needed after commit 98dc08bae678
> > > ("fsverity: stop using PG_error to track error status") which is upstream now,
> > > and
> > > https://lore.kernel.org/linux-fsdevel/20221028224539.171818-1-ebiggers@kernel.org/T/#u
> > > ("fsverity: support for non-4K pages") which is planned for 6.3.
> > 
> > Did you change the bio interfaces to iterate a bvec full of
> > variable sized folios, or does it still expect a bio to only have
> > PAGE_SIZE pages attached to it?
> > 
> 
> You can take a look at fsverity_verify_bio() with
> https://lore.kernel.org/r/20221028224539.171818-2-ebiggers@kernel.org applied.
> It uses bio_for_each_segment_all() to iterate through the bio's segments.  For
> each segment, it verifies each data block in the segment, assuming bv_len and
> bv_offset are multiples of the Merkle tree block size.  The file position of
> each data block is computed as '(page->index << PAGE_SHIFT) + bv_offset'.

Right, that still has the issue that it thinks each segment is a
struct page, whereas the iomap code is putting a struct folio that
contains a contiguous multipage folio into each segment. 

> I suppose the issue is going to be that only the first page of a folio actually
> has an index.  Using bio_for_each_folio_all() would avoid this problem, I think?

Yes, using bio_for_each_folio_all() is large folio aware. But then
you'll have to also pass the folio through the verification chain
for getting data offsets into the folio, etc.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
