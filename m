Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466D5C433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FFC020679
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXMvEJ2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgEVG5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 02:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgEVG5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 02:57:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B63C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 23:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=21G6Jwt9UUF11a4ck7Z4i3WpxkIhIDUUYVMyZKLM03E=; b=sXMvEJ2HfvBZHFde++Wit3x5QY
        ls1iT/BLVV+zw11IjjJegLLr+INux1TQfoMLai7kOP4wH93ManM+aZATC64wx2a5CLgOWnfAlamb+
        jZieXoXlE+EfMvjfCTR4/UEuQqcjNqSkwcSTHvcAKKdNWd6vQY2XovUMSWPJvTDlm63wQ4N+/I/kP
        Dzq127pnSB6AnKxY7Il44uiNAw7lq36eSfZwM1DJ4Zj5gzIPUyWbJHtvm7wuAB9rXwXkq0/hlXyFE
        ZXDU8QZfLtvVSWhxMapzHlg9VXI2N0giLWtiRxFj0RNQu/tbOwUgZEFomLyJ9Uqq1Rfxke3Y73YKd
        7ptdeOgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc1cD-0005SD-Ai; Fri, 22 May 2020 06:57:09 +0000
Date:   Thu, 21 May 2020 23:57:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 3/4] xfs: refactor xfs_iomap_prealloc_size
Message-ID: <20200522065709.GB11266@infradead.org>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011599650.76931.9345570053700795571.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011599650.76931.9345570053700795571.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_iomap_prealloc_size to be the function that dynamically
> computes the per-file preallocation size by moving the allocsize= case
> to the caller.  Break up the huge comment preceding the function to
> annotate the relevant parts of the code, and remove the impossible
> check_writeio case.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
