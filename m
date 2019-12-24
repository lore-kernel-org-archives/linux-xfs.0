Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D46C3F68F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855BD20706
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lOehshYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfLXI34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:29:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfLXI34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NRHbd3XoGZWDAjYhEJb47mY1glRRN7q+dydie6XZyXw=; b=lOehshYNlHz5T5nl3Ojlw0LkZ
        5+xwTyEY4ocg7S2rIzJW0GcDq0gRI7h/wJPDzAKPBkEI7N2YG4p9SmGRDfsbr828C5fKYLotMHHPo
        BMcT5kAA2A5G+0qHI6eGmnQCDQRgJdK27PtJLcgPigOuZjPhN+I8gPbt4mE8WJnDmJkjPOd1nZ7Xy
        l6FSdDHE+CuTN9t4UoQEgsbPB/SH2bzAjIQMt/qDCkCJA/3RxxPgB42/ikO/5SW9bN/WRQtQZD7Xb
        4c7dGsh3FFdyzk0BTN5yqMhz6RyMe4LjHVervHIoljNdxGedZKQ0FY4239tLacZGlna/kxeI2gtzR
        5XcCbbhLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfZi-0005cO-2B; Tue, 24 Dec 2019 08:29:54 +0000
Date:   Tue, 24 Dec 2019 00:29:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: make resync with the userspace libxfs easier
Message-ID: <20191224082954.GA20650@infradead.org>
References: <20191217023535.GA12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217023535.GA12765@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 06:35:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prepare to resync the userspace libxfs with the kernel libxfs.  There
> were a few things I missed -- a couple of static inline directory
> functions that have to be exported for xfs_repair; a couple of directory
> naming functions that make porting much easier if they're /not/ static
> inline; and a u16 usage that should have been uint16_t.
> 
> None of these things are bugs in their own right; this just makes
> porting xfsprogs easier.

Instead of exporting random low-level helpers can you please look
into refactoring repair to not require such low level access.  E.g.
the put_ino helper seems to be mostly used for convert short form
directories from and to the 8 byte inode format, for which we already
have kernel helpers in a slighty different form.

I'm also kinda pissed that this was rushed into mainline after -rc2
despite not fixing anything in the kernel.  That is not how the
development cycle is supposed to work.
