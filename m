Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249DEC2D0A7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D97A3206DB
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DAfGwv7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732057AbgIHQhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732026AbgIHQhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:37:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C1CC08E834
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u5kWnmWmGZr1wjgB7MtNXDAW5bssYyYRwnXJm0hgP24=; b=DAfGwv7q6XBQMecAzziDjYqksK
        BstXjH/eu/hu4Vze4ioKH2oFWM7a4pnqA2FC3uj0tgGHCWifRsLihYfBhoUl1Rc0skvqz/WQy5lKj
        XoJkuWMaykXM1knj+JNP0FTr4F9Ny35Wpul4Wc81g8e3C27SGtQFFWJgOwu8enjXCynL4lZQ0EzRc
        6C668H/26siAbmUoClO79SHQuDLnaKfFw3PyyfdV00s/814hAZcrfWwH/6kS8IgZa5Q/K/rYrj7+K
        A8fPP6UksPxPHXVmF2Ub+Dcxv9Mhb5J3lcEMHwFaQTHfJ9hXDrS0YGIV4d4AOpvlS/T7UPF/C1tvi
        AnpA+m+Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFeht-0001tW-7W; Tue, 08 Sep 2020 14:35:01 +0000
Date:   Tue, 8 Sep 2020 15:34:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] man: install all manpages that redirect to another
 manpage
Message-ID: <20200908143449.GB6039@infradead.org>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950109644.567664.3395622067779955144.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950109644.567664.3395622067779955144.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:51:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Some of the ioctl manpages do not contain any information other than a
> pointer to a different manpage.  These aren't picked up by the install
> scripts, so fix them so that they do.

While the makefile code looks like black magic it works here, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

:)
