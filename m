Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3456AC2D0E2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EB12395C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFqotzxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIXR3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727555AbgIXR3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600968553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uOFRmlux1Q9wWSOyOrju/L0ylnL8q5CD+U+8dCkSiL8=;
        b=XFqotzxZlToT4lRQiRLF9Huts/CcaIQI9hVkJJpq93yOvRt55H7iCxdkohQordLlZjKlT8
        6N6y4NUWWKHn00A1+DlfoUUxONCsvqLMJ1CNM9Vv52a/p5MS0qDqFXj75yS3esA27i3uKg
        weYGL04DkFdqZxBio042K6kYHp3ipSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-9lA6ish4MVaQRGWqUcLISg-1; Thu, 24 Sep 2020 13:27:00 -0400
X-MC-Unique: 9lA6ish4MVaQRGWqUcLISg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9099802EA5;
        Thu, 24 Sep 2020 17:26:58 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 647257B7A0;
        Thu, 24 Sep 2020 17:26:55 +0000 (UTC)
Date:   Thu, 24 Sep 2020 13:26:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Qian Cai <cai@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
Message-ID: <20200924172653.GC2603692@bfoster>
References: <20200924125608.31231-1-willy@infradead.org>
 <20200924131235.GA2603692@bfoster>
 <20200924135900.GV32101@casper.infradead.org>
 <20200924151259.GB2603692@bfoster>
 <20200924152211.GX32101@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924152211.GX32101@casper.infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 04:22:11PM +0100, Matthew Wilcox wrote:
> On Thu, Sep 24, 2020 at 11:12:59AM -0400, Brian Foster wrote:
> > On Thu, Sep 24, 2020 at 02:59:00PM +0100, Matthew Wilcox wrote:
> > > On Thu, Sep 24, 2020 at 09:12:35AM -0400, Brian Foster wrote:
> > > > On Thu, Sep 24, 2020 at 01:56:08PM +0100, Matthew Wilcox (Oracle) wrote:
> > > > > For filesystems with block size < page size, we need to set all the
> > > > > per-block uptodate bits if the page was already uptodate at the time
> > > > > we create the per-block metadata.  This can happen if the page is
> > > > > invalidated (eg by a write to drop_caches) but ultimately not removed
> > > > > from the page cache.
> > > > > 
> > > > > This is a data corruption issue as page writeback skips blocks which
> > > > > are marked !uptodate.
> > > > 
> > > > Thanks. Based on my testing of clearing PageUptodate here I suspect this
> > > > will similarly prevent the problem, but I'll give this a test
> > > > nonetheless. 
> > > > 
> > > > I am a little curious why we'd prefer to fill the iop here rather than
> > > > just clear the page state if the iop data has been released. If the page
> > > > is partially uptodate, then we end up having to re-read the page
> > > > anyways, right? OTOH, I guess this behavior is more consistent with page
> > > > size == block size filesystems where iop wouldn't exist and we just go
> > > > by page state, so perhaps that makes more sense.
> > > 
> > > Well, it's _true_ ... the PageUptodate bit means that every byte in this
> > > page is at least as new as every byte on storage.  There's no need to
> > > re-read it, which is what we'll do if we ClearPageUptodate.
> > 
> > Yes, of course. I'm just noting the inconsistent behavior between a full
> > and partially uptodate page.
> 
> Heh, well, we have no way of knowing.  We literally just threw away
> the information about which blocks are uptodate.  So the best we can
> do is work with the single bit we have.  We do know that there are no
> dirty blocks left on the page at this point (... maybe we should add a
> VM_BUG_ON(!PageUptodate && PageDirty)).
> 

Right..

> Something we could do is summarise the block uptodate information in
> the 32/64 bits of page_private without setting PagePrivate.  That would
> cause us to still allocate an iop so we can track reads/writes, but we
> might be able to avoid a few reads.
> 
> But I don't think it's worth it.  Partially uptodate pages are not what
> we should be optimising for; we should try to get & keep pages uptodate.
> After all, it's a page cache ;-)
> 

Fair enough. I was thinking about whether we could ensure the page is
released if releasepage() effectively invalidated the page content (or
avoid the release if we know the mapping won't be removed), but that
appears to be nontrivial given the refcount interdependencies between
page private and removing the mapping. I.e., the private data can hold a
reference on the page and remove_mapping() wants to assume that the
caller and page cache hold the last references on the page.

Brian

