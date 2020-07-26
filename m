Return-Path: <SRS0=7j32=BF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2918C433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 22:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D65C2053B
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jul 2020 22:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="JkDdmLMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgGZWwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jul 2020 18:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZWwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jul 2020 18:52:04 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70EDC0619D5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jul 2020 15:52:04 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di5so6604208qvb.11
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jul 2020 15:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8qxqp4Cra7c8Q17ZGNold8rkyaZiozPWBwMAyhGj2zo=;
        b=JkDdmLMlOOUeQhUCCC15e+gkl4e2eabFhCb9ynbxSm34RgDUqt6M37JmbF9hvf/noi
         fiFoU3kOcsHOhNWXL74Ui2bXI3vyGhKCRSw9Msvo+e4uuTvycKoym9Lrcs1SiiWKhQcb
         cuL/ajKCgjMdxo28TW2jfxoifsW/74Pnvjv5+gT1hggLnSYYtgEzIFjz6VNEMMGgp4jx
         u+YJcX54ih5WlXdreWOiBX7ylgibmQ6QnmdGd2fqoIBXQYAmx6gVcqaa915e3Vsmhp3x
         LMRhA8A+HoUvA5BsBW/hxJ5UB2PRENXf9ouMF1/xOHDoV/wQpvueF2EdJg23BOyuqG2l
         Wt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8qxqp4Cra7c8Q17ZGNold8rkyaZiozPWBwMAyhGj2zo=;
        b=jXTGSSExFNpabPifSysmypUHoIX8i4WoJItBfq2dPTnq63FbHc7bDuDXCArPWz1jQd
         6WudMg+XC+OTnawHFieZ5DnuCLJ3/M0T9H7s7zkclOyYLj7/gwgKoxx/or0JlOQ8Ha8a
         rzMjoWEuf332ZkoYnHUE/njFRMOJc3XKz8iTx8QIdqXK3uPoFIZl/s5JBsC+X7nUCnYF
         BrfgYXhPMOnz1WrNWAZGcL5qXPzNiy1mdpVPCBewV7BZBUyppm3dYfhv/iJmjrLYGqMm
         eQO9rEwLy9QcTnV8YjqznRoYj3TXmObTPbtvO1QPxkzib6qXB+v+1RpwN1FjDlA1K+5P
         IK/Q==
X-Gm-Message-State: AOAM532sjSxPDX0VA2qj1vnvVqmyl7wUeFtjQcLJsrnY9ywRBpZ7iG3x
        CcqET53Bi7E6+CGa/Er7fxpJNg==
X-Google-Smtp-Source: ABdhPJxtX6CIU9klIDmZxKuPl98KVTqY07BMK/VxQByZcrYhNr3TrR1gvudNaJwU7iLZffa5iyqWPA==
X-Received: by 2002:a05:6214:11f3:: with SMTP id e19mr9636442qvu.220.1595803923650;
        Sun, 26 Jul 2020 15:52:03 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id p17sm2043556qtn.15.2020.07.26.15.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 15:52:02 -0700 (PDT)
Date:   Sun, 26 Jul 2020 18:51:54 -0400
From:   Qian Cai <cai@lca.pw>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: WARN_ON_ONCE(1) in iomap_dio_actor()
Message-ID: <20200726225154.GA929@lca.pw>
References: <20200619211750.GA1027@lca.pw>
 <20200620001747.GC8681@bombadil.infradead.org>
 <20200724182431.GA4871@lca.pw>
 <20200726152412.GA26614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726152412.GA26614@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 26, 2020 at 04:24:12PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 24, 2020 at 02:24:32PM -0400, Qian Cai wrote:
> > On Fri, Jun 19, 2020 at 05:17:47PM -0700, Matthew Wilcox wrote:
> > > On Fri, Jun 19, 2020 at 05:17:50PM -0400, Qian Cai wrote:
> > > > Running a syscall fuzzer by a normal user could trigger this,
> > > > 
> > > > [55649.329999][T515839] WARNING: CPU: 6 PID: 515839 at fs/iomap/direct-io.c:391 iomap_dio_actor+0x29c/0x420
> > > ...
> > > > 371 static loff_t
> > > > 372 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
> > > > 373                 void *data, struct iomap *iomap, struct iomap *srcmap)
> > > > 374 {
> > > > 375         struct iomap_dio *dio = data;
> > > > 376
> > > > 377         switch (iomap->type) {
> > > > 378         case IOMAP_HOLE:
> > > > 379                 if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
> > > > 380                         return -EIO;
> > > > 381                 return iomap_dio_hole_actor(length, dio);
> > > > 382         case IOMAP_UNWRITTEN:
> > > > 383                 if (!(dio->flags & IOMAP_DIO_WRITE))
> > > > 384                         return iomap_dio_hole_actor(length, dio);
> > > > 385                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> > > > 386         case IOMAP_MAPPED:
> > > > 387                 return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> > > > 388         case IOMAP_INLINE:
> > > > 389                 return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
> > > > 390         default:
> > > > 391                 WARN_ON_ONCE(1);
> > > > 392                 return -EIO;
> > > > 393         }
> > > > 394 }
> > > > 
> > > > Could that be iomap->type == IOMAP_DELALLOC ? Looking throught the logs,
> > > > it contains a few pread64() calls until this happens,
> > > 
> > > It _shouldn't_ be able to happen.  XFS writes back ranges which exist
> > > in the page cache upon seeing an O_DIRECT I/O.  So it's not supposed to
> > > be possible for there to be an extent which is waiting for the contents
> > > of the page cache to be written back.
> > 
> > Okay, it is IOMAP_DELALLOC. We have,
> 
> Can you share the fuzzer?  If we end up with delalloc space here we
> probably need to fix a bug in the cache invalidation code.

This is just a wrapper of the trinity fuzzer.

# git clone https://gitlab.com/cailca/linux-mm
# cd linux-mm; make
# ./random -x 0-100 -f

https://gitlab.com/cailca/linux-mm/-/blob/master/random.c#L1383
