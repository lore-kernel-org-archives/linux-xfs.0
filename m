Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736CFC35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D89D20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ggBxk5ax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgAYXTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:19:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k/UU/GrC6qMb4IiqTAQx/OB0cU9MatCe/miZ3KcmsgM=; b=ggBxk5ax9smH2yYYPu/R+Cocg
        vqfnI7lQCaLVPHiPmjBPC4ct5HvPZrjYvONPoWi5eYjmVqedx+xmqltB+8zDrEQ/4dZ1Fa8pLoGmZ
        FQqffSgldKQTnq4OQy/iu+EQCnLjKzoVhredfWiRjRHc984j6pNuwNLkqD2peY7+cg3OXko05Pk/x
        zP6IsPs9lWv7gTuffDmLEf/l40CGAUg000kNW/uwcyygAm+gtkXrb++7wjoaE7YFoYD+7S4I/OwYw
        tQx9oOnzbUqVxaXaYuIIRaENMMT5tP7VjhaHTC7JDgZL9BkryjYJXXk42q+v1BKY/EwCETz7rS+0m
        Or+DJstkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUi7-0006oa-Eo; Sat, 25 Jan 2020 23:19:27 +0000
Date:   Sat, 25 Jan 2020 15:19:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs_repair: fix totally broken unit conversion in
 directory invalidation
Message-ID: <20200125231927.GL15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982504329.2765410.10475555316974599797.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982504329.2765410.10475555316974599797.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 23, 2020 at 04:17:23PM -0800, Darrick J. Wong wrote:
> Fix all this stupidity by adding a for loop macro to take care of these
> details for us so that everyone can iterate all logical directory blocks
> (xfs_dir2_db_t) that start within a given bmbt record.

No more magic macro in here (thankfully).  But the rest looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
