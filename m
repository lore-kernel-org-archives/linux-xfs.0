Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD834C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6D32072B
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FdO5Vf7w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYRmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:42:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDADC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2GO6kZGgS/mdBvz1mmDnClmeg95zvmeE9bPNxFjaNpM=; b=FdO5Vf7wnhLXAk/BOXRjQsOfAH
        lpu0ElF4uvMnG1jg0Ni5thpGrGDyt0obNki2tHqEVPoEfrrJXrQ/3bFgc10zYCB9uyqWooo5/pIS5
        lBhqLrplYanNZtjlWUw5uRha6dBxDwXKbXzJNDweE01f2CkKtYwgiySGDZ51HKP6DJfrmTZlDwIxc
        RCK6SirBEbwV6LkwxJhx5aUewAYC5zu6AFwewOu2V2OXZ9mdDCbdFVo8r63l/u3y0k3XAEiIP8Bm7
        v6P16l6+ATLuGfI4EJwmPbozhsujk8zO8RyxAoW59JjTNMKRfGfo1UtDTXkpLzUYMz3UJSchJ8g6B
        n7A2DaWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOoc-00070r-H0; Sat, 25 Apr 2020 17:42:10 +0000
Date:   Sat, 25 Apr 2020 10:42:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/19] xfs: complain when we don't recognize the log item
 type
Message-ID: <20200425174210.GA16663@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752116938.2140829.6588657626837150802.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752116938.2140829.6588657626837150802.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:06:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're sorting recovered log items ahead of recovering them and
> encounter a log item of unknown type, actually print the type code when
> we're rejecting the whole transaction to aid in debugging.

The subject seems wrong - we already complain, we are just not very
specific what we complain about as you mention in the actual commit log.

With a fixed subject:

Reviewed-by: Christoph Hellwig <hch@lst.de>
