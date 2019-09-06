Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46008C00307
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 05:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E0EA2081B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 05:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfIFFzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 01:55:00 -0400
Received: from verein.lst.de ([213.95.11.211]:54436 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbfIFFzA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 01:55:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E178968B20; Fri,  6 Sep 2019 07:54:55 +0200 (CEST)
Date:   Fri, 6 Sep 2019 07:54:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 04/15] btrfs: Add a simple buffered iomap write
Message-ID: <20190906055455.GA1830@lst.de>
References: <20190905150650.21089-1-rgoldwyn@suse.de> <20190905150650.21089-5-rgoldwyn@suse.de> <20190905162344.GA22450@lst.de> <20190905204210.eb3gadoux3ih353q@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190905204210.eb3gadoux3ih353q@fiona>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:42:10PM -0500, Goldwyn Rodrigues wrote:
> > Thіs looks really strange.  Can you explain me why you need the
> > manual dirtying and SetPageUptodate, and an additional page refcount
> > here?
> 
> It was a part btrfs code which is carried forward. Yes, we don't need
> the page dirtying and uptodate since iomap does it for us.

But even the get_page seems very odd to me.  It needs a detailed
comment at least.
