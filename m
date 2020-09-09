Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ED1C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19602223D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 15:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov-name.20150623.gappssmtp.com header.i=@shutemov-name.20150623.gappssmtp.com header.b="Jt6eZsRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgIIPQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbgIIL5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 07:57:52 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DFBC06179F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2020 04:57:43 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v23so3186809ljd.1
        for <linux-xfs@vger.kernel.org>; Wed, 09 Sep 2020 04:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fZrqJCuzFIeGDFGe2HFXkbJZzJaJVwqjIS4lH3Qm+G8=;
        b=Jt6eZsRdBFyPKxzyVDuTg6Ppr6gCpbwhIOK358Bj4Rx9mVj6oG1GI0FhHSFsMHteIf
         YKmXt3zdcMgly/fXkgvyQaC49zW/BD4erA2QGTIT/qBQF9X2BDoeqFTbvivBbYnR/1NW
         U8sl07vi++uvCZdrveauCjCfnrvyurkzguNZVkkYIURUf4mGr24UgtzxD9x9va4n1g4T
         NUUpyMc2BwL8lbV02efX3PI6vRzKoZGYfmZpy8fumpIcz/Z/B8K3Ab5Kj7Z5B5Ky+XNg
         218YBI1uAQW+s0ZUPhKM5MksbSFIPcNMpztf3Ou2vTyszGIQMWJjQJMYykkNy7IOMwqj
         PYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fZrqJCuzFIeGDFGe2HFXkbJZzJaJVwqjIS4lH3Qm+G8=;
        b=Wkp9hHmO4ekRPxcRzBaxW7k4A8tZ26B4iJB2ku1EX7OjTcOwuxtKbxHRQoCooP1AF8
         FnunknzN++QrB2DgUOOg6/5CdVo9wDeZgjyXYYM1qV865GQS5hD0QGHHhUph/Oprvf7K
         6azRs6APzBdHLFtXaYvzSVqnG3rd9RwtnMgS/VE5ecrSjj/PXucHSAZk37UJNhZdTpX+
         QHxi9c8L8gEoJTKLklEui27EUjMitaNPVcsR9R3yFBs6jW1/zl8u8K0/Ul7SqLQEOTgO
         RTVP0U1sbLniU8bDFNhtlKD91SzFzNFmj5LK1/99zs4ioFi/sgnzPbCe1ZMSSaC+26FZ
         VyIA==
X-Gm-Message-State: AOAM5300t7uf7AgiomVTW0kCFq8FyPAVY3VI3jFmDASDan62edSSDhyH
        QwtKtyUFB7qTsXzZHfhazeeodQ==
X-Google-Smtp-Source: ABdhPJxJzexKjswpA3xRhq/Krsalubx7gZ3mg4368Y5XZat/QN1QRVQxFGy0Y4nYke9hkXms2rcGhQ==
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr1779252ljr.2.1599652662324;
        Wed, 09 Sep 2020 04:57:42 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e8sm685782lja.93.2020.09.09.04.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 04:57:41 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id A7E0E1036AE; Wed,  9 Sep 2020 14:57:46 +0300 (+03)
Date:   Wed, 9 Sep 2020 14:57:46 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com,
        david@fromorbit.com, yukuai3@huawei.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Splitting an iomap_page
Message-ID: <20200909115746.6xhfdizp3nnopcfd@box>
References: <20200821144021.GV17456@casper.infradead.org>
 <20200904033724.GH14765@casper.infradead.org>
 <20200907113324.2uixo4u5elveoysf@box>
 <20200908114328.GE27537@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908114328.GE27537@casper.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 08, 2020 at 12:43:28PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 07, 2020 at 02:33:24PM +0300, Kirill A. Shutemov wrote:
> > On Fri, Sep 04, 2020 at 04:37:24AM +0100, Matthew Wilcox wrote:
> > > Kirill, do I have the handling of split_huge_page() failure correct?
> > > It seems reasonable to me -- unlock the page and drop the reference,
> > > hoping that somebody else will not have a reference to the page by the
> > > next time we try to split it.  Or they will split it for us.  There's a
> > > livelock opportunity here, but I'm not sure it's worse than the one in
> > > a holepunch scenario.
> > 
> > The worst case scenario is when the page is referenced (directly or
> > indirectly) by the caller. It this case we would end up with endless loop.
> > I'm not sure how we can guarantee that this will never happen.
> 
> I don't see a way for that to happen at the moment.  We're pretty
> careful not to take references on multiple pages at once in these paths.
> I've fixed the truncate paths to only take one reference per THP too.
> 
> I was thinking that if livelock becomes a problem, we could (ab)use the
> THP destructor mechanism somewhat like this:
> 
> Add
> 	[TRANSHUGE_PAGE_SPLIT] = split_transhuge_page,
> to the compound_page_dtors array.
> 
> New function split_huge_page_wait() which, if !can_split_huge_page()
> first checks if the dtor is already set to TRANSHUGE_PAGE_SPLIT.  If so,
> it returns to its caller, reporting failure (so that it will put its
> reference to the page).  Then it sets the dtor to TRANSHUGE_PAGE_SPLIT
> and sets page refcount to 1.  It goes to sleep on the page.

The refcount has to be reduced by one, not set to one. Otherwise the page
will get split while somebody holds a pin. But willnot work if two
callsites use split_huge_page_wait(). Emm?..

> split_transhuge_page() first has to check if the refcount went to 0
> due to mapcount being reduced.  If so, it resets the refcount to 1 and
> returns to the caller.  If not, it freezes the page and wakes the task
> above which is sleeping in split_huge_page_wait().

What happens if there's still several GUP references to the page. We must
not split the page in this case.

Maybe I don't follow your idea. I donno.

> It's complicated and I don't love it.  But it might solve livelock, should
> we need to do it.  It wouldn't prevent us from an indefinite wait if the
> caller of split_huge_page_wait() has more than one reference to this page.
> That's better than a livelock though.

-- 
 Kirill A. Shutemov
