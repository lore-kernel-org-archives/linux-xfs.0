Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBB0C5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B64821D7B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 08:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbfKGIoL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:44:11 -0500
Received: from verein.lst.de ([213.95.11.211]:55791 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfKGIoL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Nov 2019 03:44:11 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4983468B05; Thu,  7 Nov 2019 09:44:09 +0100 (CET)
Date:   Thu, 7 Nov 2019 09:44:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Fix overflow in iomap_page_mkwrite
Message-ID: <20191107084409.GB9895@lst.de>
References: <20191106190400.20969-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106190400.20969-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 08:04:00PM +0100, Andreas Gruenbacher wrote:
> On architectures where ssize_t is wider than pgoff_t, the expression
> ((page->index + 1) << PAGE_SHIFT) can overflow.  Rewrite to use the page
> offset, which we already compute here anyway.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks good except for the ssize_t vs loff_t in the changelog:

Reviewed-by: Christoph Hellwig <hch@lst.de>
