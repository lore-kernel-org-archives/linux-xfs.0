Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74EE4C2D0E2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 13:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136D22311B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 13:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilZrTZqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgIXNMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 09:12:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727704AbgIXNMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 09:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600953166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9EQR2I1NMFT5nFyNTeWXnehjcHK4LcH2sOKMD1jaXa0=;
        b=ilZrTZqhi/lK5uqR5vh9R4JZIR+yp6PL3ABHwSRJ1JL+IPPiZVJX9nDNKDIQFoo/ChH5Fl
        DBgaERMcJz3/ESihUj9k+8JmbcPU/XMJyp4kgREWnQdVIO0EKIngLeZvyPKqoFSfKujfM3
        e6Efv8offxrpq2rC4Jbf654xSFbHmeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-jaL_vyGwOSutEBeLMYF3lw-1; Thu, 24 Sep 2020 09:12:42 -0400
X-MC-Unique: jaL_vyGwOSutEBeLMYF3lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD405100747A;
        Thu, 24 Sep 2020 13:12:40 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AB8D5C1DC;
        Thu, 24 Sep 2020 13:12:36 +0000 (UTC)
Date:   Thu, 24 Sep 2020 09:12:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Qian Cai <cai@redhat.com>
Subject: Re: [PATCH] iomap: Set all uptodate bits for an Uptodate page
Message-ID: <20200924131235.GA2603692@bfoster>
References: <20200924125608.31231-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924125608.31231-1-willy@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 01:56:08PM +0100, Matthew Wilcox (Oracle) wrote:
> For filesystems with block size < page size, we need to set all the
> per-block uptodate bits if the page was already uptodate at the time
> we create the per-block metadata.  This can happen if the page is
> invalidated (eg by a write to drop_caches) but ultimately not removed
> from the page cache.
> 
> This is a data corruption issue as page writeback skips blocks which
> are marked !uptodate.
> 
> Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reported-by: Qian Cai <cai@redhat.com>
> Cc: Brian Foster <bfoster@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8b6cca7e34e4..8180061b9e16 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -60,6 +60,8 @@ iomap_page_create(struct inode *inode, struct page *page)
>  	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
>  			GFP_NOFS | __GFP_NOFAIL);
>  	spin_lock_init(&iop->uptodate_lock);
> +	if (PageUptodate(page))
> +		bitmap_fill(iop->uptodate, nr_blocks);

Thanks. Based on my testing of clearing PageUptodate here I suspect this
will similarly prevent the problem, but I'll give this a test
nonetheless. 

I am a little curious why we'd prefer to fill the iop here rather than
just clear the page state if the iop data has been released. If the page
is partially uptodate, then we end up having to re-read the page
anyways, right? OTOH, I guess this behavior is more consistent with page
size == block size filesystems where iop wouldn't exist and we just go
by page state, so perhaps that makes more sense.

Brian

>  	attach_page_private(page, iop);
>  	return iop;
>  }
> -- 
> 2.28.0
> 

