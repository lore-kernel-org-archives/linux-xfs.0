Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41ACAC43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 19:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02ADE20714
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 19:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="En38RmC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbgDATUi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 15:20:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55108 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732219AbgDATUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 15:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XzKWVZ8XpH0VItgIc/EYZRpe2d3wjhBKBBCXSpbjH3c=; b=En38RmC3LBNnhv/BGBPjyyn0a0
        5yAAG0QVPBUH+mvEG73EOI55UFhphX332+sV7RXzlty4JCh06o9WR0GTw4jS//Ojt0J4+whF9ZepJ
        NWiWYD66qSx13dKz9e13UrckXCOlh4/kmBi1tGbP2vtaLkvzEUuHM+40hjXNSrNhYDtQUbaUc3CK6
        rnv5QTjdilgnpUjLD6Tjb1FQJveQuX4dhZGxtS1UupUowmwBeyGWLdJKdzqs6PgQc7NlZ7VSJ9yqy
        IXxDSaMrdAeBP3LDVf+ZrnGCKH3nWDk9ltn0g2v32ff6l4KcG2EglHWUJS2UxpJaNgRA73Iocttju
        j62x7slQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJiuk-0005ER-9L; Wed, 01 Apr 2020 19:20:38 +0000
Date:   Wed, 1 Apr 2020 12:20:38 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Add iomap_iter API
Message-ID: <20200401192038.GJ21484@bombadil.infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
 <20200401152522.20737-2-willy@infradead.org>
 <20200401154248.GA2813@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401154248.GA2813@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 08:42:48AM -0700, Christoph Hellwig wrote:
> OTOH the len argument / return value seems like something that would
> seems useful in the iter structure.  That would require renaming the
> current len to something like total_len..

Ah, I remembered why I didn't do it that way.  For more complicated
users (eg readahead ...), we want to be able to pass an errno here.
Then iomap_iter() will call ops->iomap_end() and return the errno
you passed in, and we can terminate the loop.

