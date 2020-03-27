Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A1FC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD69020714
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 09:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tfsfhAEN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgC0JIB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:08:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgC0JIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 05:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IN6FqGZOnc4PkJFZYpthnGMtnq9LVIGgFSrcbY5sP2Q=; b=tfsfhAENiC5tfp3Op3k7m2jwMJ
        ZHpascFWW8tAxTQwJ0IW/q8r2np6weKseYwTzdLVFBS1m0lddJYyFm2/FO3DdjdN3dYb8De/8ixQd
        bLGsCUVjZjPHUuldo60hH0aETopf8cD/9yfkQsSu3t+EMPHT+sXxdHi+CLpgPZwaeiZWUKrC+eg0z
        D/xbzcHaxKDLYL1BhwdZuJhNEMeGPkE7kXiDx3DGrF8a2HWNVKPuIqtjbwRrJmZFLSBwLz1htEN5v
        NmpX0PYjV/hostglwIwDh81ymkjGeETBmTQgHkBlZ5abNxf0le5pkHBu9S6ymwpk2d2EiYQg+EQTt
        u1rl7iww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHky8-0005Fg-UZ; Fri, 27 Mar 2020 09:08:00 +0000
Date:   Fri, 27 Mar 2020 02:08:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't flush the entire filesystem when a buffered
 write runs out of space
Message-ID: <20200327090800.GC14052@infradead.org>
References: <20200327014558.GG29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327014558.GG29339@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, independ of the discussion what to flush, using
filemap_fdatawait_keep_errors is a very obvious and important bug fix.
Can you split that out and apply it with a Fixes tag so that it gets
backported ASAP?
