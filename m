Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563AFC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286D6206D5
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 07:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IUH8JL+2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgEQHfc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 03:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgEQHfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 03:35:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D94DC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 00:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jGj6qbzqBIqEZ7MvHrrPVlAjnS/qatcVmLlZQT1Tk3w=; b=IUH8JL+2b4T6muV1XkEb2vKTCM
        4BmZFWDtFjoOpas1QpPQbXkw/QFJuvo3yUJX1Vww7UvcuVRbPIpQI0K+CzH6mNP5zPC4YPkuyPPUe
        3O0zn3LJ7sTx99+SE0bdw02LwECyNvhU2VYfU8mN0ksNpOdO96Y4yxzR/Myiv32/1a1g+3V6hmd2q
        U4IBVv7dSbfyYtKBVlD282yPE9AireGGfIfPpwb2GjjpOng1lXD+i/5GsMaDAySyYl70Ybk7l7TF0
        ohg9zEsYUBS/Evo9uuFmItwcc99DEYdzYLWY+ny6YkaI8PZcjn+7UepKsqtryuyQpzEMLkb8zXeOp
        V2Q3uDCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaDpc-0005LK-2h; Sun, 17 May 2020 07:35:32 +0000
Date:   Sun, 17 May 2020 00:35:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't allow SWAPEXT if we'd screw up quota
 accounting
Message-ID: <20200517073532.GB32627@infradead.org>
References: <20200514205442.GK6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514205442.GK6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 01:54:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the old SWAPEXT ioctl doesn't know how to adjust quota ids,
> bail out of the ids don't match and quotas are enabled.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
