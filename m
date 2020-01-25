Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F61C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F1E120708
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tyO9oQ0q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgAYXXB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:23:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAYXXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LKebuwzsGJzhRojV/yLLfuJjyqdhEqnFW5xUrIQmIoo=; b=tyO9oQ0q+VAac+8Qxew7ttGs4
        BAkDKYNBP8jXlPe4E68tPn9Gr0TQZpCf4VCZEh22fiWqsQf8qN9XCgyYM5G41eBdHTeV0svEuZHuh
        I/N2Ntb27VSoeLZnbBrWrm5dolGI63LU3ep8hg2RB1XZkSf+H4RuzfIwlzipV0rYfh28qbOKd8dah
        nBV8cxnx5d4LQLjE4b9YNw/UKW0AKKeLRXEVjCqBbnZCNuXn/3IhgbTdj/WdlYQpDygxtKAJdG1Xu
        w8vyYVHnMgyAUrP4ZQFHD/mojmq5pQAluzmIy3z5cmRHtDn/njbyZoFw2m+yPlHXOVxU0QTYZFF0P
        dboQIh1SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUlX-00087x-4M; Sat, 25 Jan 2020 23:22:59 +0000
Date:   Sat, 25 Jan 2020 15:22:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/29] xfs: merge xfs_attr_remove into xfs_attr_set
Message-ID: <20200125232259.GA30917@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-3-hch@lst.de>
 <20200121172853.GC8247@magnolia>
 <52723c8f-1634-424c-e1b6-d3195304fc15@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52723c8f-1634-424c-e1b6-d3195304fc15@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 09:17:15PM -0700, Allison Collins wrote:

[full quote deleted, please follow proper mail netiquette]

> > (The first thing my brain thought was, "ENOATTR on a set operation
> > suggests to me that something's seriously broken in the attr code; why
> > would you mask it?")
> > 
> > --D
> 
> Would either of you mind if I were to pick up this patch and make a mini set
> that resolves some of the overlap between our sets?  I'll fix the nits here.
> Let me know, thanks!

I'd rather resend the whole thing - it fixes various issues with the
attr flags handling and removes lots of codes.  I'll try to do so today,
but Darrick can decide if he just wants to pick parts if that makes life
easier.
