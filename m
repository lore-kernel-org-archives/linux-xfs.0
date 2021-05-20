Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4761BC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 05:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17541611BE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 05:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhETFY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 01:24:59 -0400
Received: from verein.lst.de ([213.95.11.211]:40714 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETFY6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 01:24:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C424267373; Thu, 20 May 2021 07:23:35 +0200 (CEST)
Date:   Thu, 20 May 2021 07:23:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: cleanup _xfs_buf_get_pages
Message-ID: <20210520052335.GB21165@lst.de>
References: <20210519190900.320044-1-hch@lst.de> <20210519190900.320044-5-hch@lst.de> <20210519224028.GD664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519224028.GD664593@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 08:40:28AM +1000, Dave Chinner wrote:
> This will not apply (and break) the bulk alloc patch I sent out - we
> have to ensure that the b_pages array is always zeroed before we
> call the bulk alloc function, hence I moved the memset() in this
> function to be unconditional. I almost cleaned up this function in
> that patchset....

The buffer is freshly allocated here using kmem_cache_zalloc, so
b_pages can't be set, b_page_array is already zeroed from
kmem_cache_zalloc, and the separate b_pages allocation is swithced
to use kmem_zalloc.  I thought the commit log covers this, but maybe
I need to improve it?
