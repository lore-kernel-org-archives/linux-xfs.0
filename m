Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56616C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F755227C3
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbhAXJe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbhAXJeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:34:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F4C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2XKc/hTy91SyHG1wqUGVQmt2Uzl2nTS9w+ccTCj7Fz0=; b=OkKCTcuVBmgH9h5vSZHfnRJAek
        F5lmXsMiHP9aDUk+nocM6hcrzqj5xpNsMbB4zCHLOhjyZGOqtIOOyJGNTbH4Zfi70kyGc+svTzlPY
        LPthvJ9r0ZPxWj10yhV0GRIcXT3850kykwTIqBN8w7WtfiKklwSxo9eo1zPoMvfKidVSEjbOMg0C2
        4Rk8QGBjncbVhP4Ppnt7MsyVXvkR5kwXPv65UnkBa4mCA0hTocH5Su+gwy/ZGgjUhQqusqhFnS20p
        354r2D6toupUAK13MzhA7xuPgVzoDcreBH29A4lCbv3nhpgcN6Gs1uJCE+S3bq8kYBBt+FNfjIut2
        EdrFmcUg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3bli-002oa5-0L; Sun, 24 Jan 2021 09:33:24 +0000
Date:   Sun, 24 Jan 2021 09:33:13 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 3/4] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <20210124093313.GA670331@infradead.org>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <161142791177.2170981.5671264062040255172.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142791177.2170981.5671264062040255172.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:51:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a couple of convenience wrappers for creating and deleting quota
> block reservations against future changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
