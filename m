Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D6BC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEDDB21835
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sD7U0Be7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAWWgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:36:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWWgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:36:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tQdvFvk69GjY0bgAUw1uldAawf1YhoYBfjd6CRyJVLA=; b=sD7U0Be7R6DxV817kII7pZlBI
        Kb04RRtgV6Q+t+NMQASdkuEdqGJr6sWjCYyoyDy0u7jHjnTrqvkgHt4zyNtlTAjZmdzheGKDzj5av
        Kv5DZQLPnnOo34EQ9qEvzOpFxldzMaFx73YMlcRy+IBYqZNjY8JpKvlfv4QIoiAQft6+Q+raasvtV
        X33EXI7AiP98CQREaxXhjy9pwf8DfyJ6Ksuita9PwY5aR8ddQwF83gos0EJZ98ykR0yyBKZCxP/xu
        QHU/SLwlrfq+q4JvUi9711ze36BNbeph+aXL0f5GHYt8BCsxpVTt0qSOGnMTTRQ3a9TXaD8jTkHQ9
        7xQZO8esA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul5k-0003N4-S1; Thu, 23 Jan 2020 22:36:48 +0000
Date:   Thu, 23 Jan 2020 14:36:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 09/29] xfs: turn xfs_da_args.value into a void pointer
Message-ID: <20200123223648.GD2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-10-hch@lst.de>
 <20200121180742.GI8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121180742.GI8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 10:07:42AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 14, 2020 at 09:10:31AM +0100, Christoph Hellwig wrote:
> > The xattr values are blobs and should not be typed.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me wonders if it's worth using a union for filetype vs. value/valuelen
> to save a few padding bytes, but that's another patch...

If we want to go down that route it might make sense to have an
xfs_attr_args and xfs_dir2_args, which both embedd the da_args.  But not
for now..

