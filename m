Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D87C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 17:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5324922200
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 17:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hid3+8Vu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgJNR0g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgJNR0g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 13:26:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FECDC061755;
        Wed, 14 Oct 2020 10:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wZo7ZkSSpcEOkwiGEswMZXQPiQFGCWMDlHQwEWZTg+g=; b=Hid3+8VuqwReQUUypNu3kZeRe2
        Kh2KAmXxKY9Ur8nD/slUpFfahtVHNvwKhZdE3S5k7mf0fCXYvZ6ZI1rbbYDJhD1DJH+YMdOS27CEn
        cS6ALVl8MxmDkVlWkBRCt16Q8QFwmAZXLmKs7hb2+QBs5Zb1OU1sBuVaXnXORj7m4tnxDGryqLWRR
        /qbjCcKQ+zTqUuSu968Cc6Pt8vBxgdBjE78qVUsrM7zOfljDPz5hTFWvIOnSWsyxniwL89WQJLzBC
        7CLrKfQKHqoLWw/hm24cq12IcO/GnTC5j5s+mi1CzN6slefAFm+vRZvpzdbBnaWlnn/DW/BwDRUf4
        ORjZoMvg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSkXq-0004pT-Vr; Wed, 14 Oct 2020 17:26:35 +0000
Date:   Wed, 14 Oct 2020 18:26:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 05/14] iomap: Support THPs in invalidatepage
Message-ID: <20201014172634.GP20115@casper.infradead.org>
References: <20201014030357.21898-1-willy@infradead.org>
 <20201014030357.21898-6-willy@infradead.org>
 <20201014163347.GI9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014163347.GI9832@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 09:33:47AM -0700, Darrick J. Wong wrote:
> > @@ -1415,7 +1420,6 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
> >  			 */
> >  			if (wpc->ops->discard_page)
> >  				wpc->ops->discard_page(page);
> > -			ClearPageUptodate(page);
> 
> Er, I don't get it -- why do we now leave the page up to date after
> writeback fails?

The page is still uptodate -- every byte in this page is at least as new
as the corresponding bytes on disk.
