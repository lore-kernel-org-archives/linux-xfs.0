Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07C0C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E29020771
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 11:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRd7/vcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCYLYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:24:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58559 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbgCYLYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 07:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5u3ybkOspfPpY6FJOGM+swY/jhE3hoTb/3OK3rkxwgw=;
        b=gRd7/vcnZCwZ7uYdLLE2rsWmRXRsNXbHrSwyGpBbAn+q4xf889qCRKlZLjUtNsxVt6HZSC
        EQtVJYcIsk0dLIuhJJLn++y+7byDVN+JZBUHSLToQU14MY2EG/XI+n9Usjf/zBavPgW98a
        pkxwu2dTY2doG481xMC0Y6rYYzv+tOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-sYnglbxuOzCh3NQRIyIahg-1; Wed, 25 Mar 2020 07:24:20 -0400
X-MC-Unique: sYnglbxuOzCh3NQRIyIahg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F39D13F5;
        Wed, 25 Mar 2020 11:24:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CCD45C1A2;
        Wed, 25 Mar 2020 11:24:19 +0000 (UTC)
Date:   Wed, 25 Mar 2020 07:24:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200325112417.GA10922@bfoster>
References: <20200324165700.7575-1-bfoster@redhat.com>
 <20200324232424.GC10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324232424.GC10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 10:24:24AM +1100, Dave Chinner wrote:
> On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> > If the bio_add_page() call fails, we proceed to write out a
> > partially constructed log buffer. This corrupts the physical log
> > such that log recovery is not possible. Worse, persistent
> > occurrences of this error eventually lead to a BUG_ON() failure in
> > bio_split() as iclogs wrap the end of the physical log, which
> > triggers log recovery on subsequent mount.
> 
> I'm a little unclear on how this can happen - the iclogbuf can only
> be 256kB - 64 pages - and we always allocation a bio with enough
> bvecs to hold 64 pages. And the ic_data buffer we are adding to the
> bio is also statically allocated so I'm left to wonder exactly how
> this is failing.
> 
> i.e. this looks like code that shouldn't ever fail, yet it
> apparently is, and I have no idea what is causing that failure...
> 

It shouldn't fail in current upstream. The problem occurred on a large
page (64k) system without commit 59bb47985c1d ("mm, sl[aou]b: guarantee
natural alignment for kmalloc(power-of-two)"). The large page config
means default sized log buffers (32k) allocate out of slab and slab
allocs are not naturally aligned due to the lack of the aforementioned
commit (plus additional mm debug options, such as slub debug, kasan).
IOW, the 32k slab looks like this:

kmalloc-32k           75     75  33792   15    8 : tunables    0    0    0 : slabdata      5      5      0

Note the 33k object size. This means that 32k slab allocations can start
at a non-32k aligned physical offset in a page. So for example if we
allocate a 32k log buffer that lands at physical offset 48k of the
underlying page, xlog_map_iclog_data() will attempt to attach 2 physical
pages (16k from each) to the bio. Meanwhile the bio was originally
allocated and initialized based on a bvec count of
howmany(log->l_iclog_size, PAGE_SIZE), which assumes a 32k log buffer
only requires a single bvec.

The primary fix for this problem was to include the slab alignment
patch. That essentially changes the object size in the above example
from 33k to 64k for reasons described in its commit log. This error
handling patch was simply based on the observation that if the
bio_add_page() call from XFS fails, for whatever reason, we fall over
rather ungracefully.

Brian

> That said, shutting down on failure is the right thing to do, so the
> code looks good. I just want to know how the bio_add_page() failure
> is occurring.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

