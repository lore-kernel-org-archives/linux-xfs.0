Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F30C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 08:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC8423107
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 08:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbhAFIre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 03:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726740AbhAFIre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 03:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609922768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h4B8kH6ze+E5PoMixXcia7NZlNRqi70d7MWvzMT8C7I=;
        b=f/tbG2y6RLzBLZVEdVwVLRDSQ+sDuzfxW5oo7V5ap3NsL/laMJ4jAt8riPBqkGHzyY7DJJ
        gewBf9CxChIF2JVyzdpSZ6SNuKoaXP8pedAeUkOtrC/vbCzM+Pqtu4Y6rll1vzCof/CcRb
        pJatIWu8N8mlQwie8B8t6/T9X4O7dTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-S-sSwl_sMvybwBrg6vzwUQ-1; Wed, 06 Jan 2021 03:46:04 -0500
X-MC-Unique: S-sSwl_sMvybwBrg6vzwUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0E6D10054FF;
        Wed,  6 Jan 2021 08:46:02 +0000 (UTC)
Received: from T590 (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8022D6A8FB;
        Wed,  6 Jan 2021 08:45:53 +0000 (UTC)
Date:   Wed, 6 Jan 2021 16:45:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: block_dev: compute nr_vecs hint for improving
 writeback bvecs allocation
Message-ID: <20210106084548.GA3845805@T590>
References: <20210105132647.3818503-1-ming.lei@redhat.com>
 <20210105183938.GA3878@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105183938.GA3878@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 05, 2021 at 07:39:38PM +0100, Christoph Hellwig wrote:
> At least for iomap I think this is the wrong approach.  Between the
> iomap and writeback_control we know the maximum size of the writeback
> request and can just use that.

I think writeback_control can tell us nothing about max pages in single
bio:

- wbc->nr_to_write controls how many pages to writeback, this pages
  usually don't belong to same bio. Also this number is often much
  bigger than BIO_MAX_PAGES.

- wbc->range_start/range_end is similar too, which is often much more
  bigger than BIO_MAX_PAGES.

Also page/blocks_in_page can be mapped to different extent too, which is
only available when wpc->ops->map_blocks() is returned, which looks not
different with mpage_writepages(), in which bio is allocated with
BIO_MAX_PAGES vecs too.

Or you mean we can use iomap->length for this purpose? But iomap->length
still is still too big in case of xfs.

-- 
Ming

