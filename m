Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC929C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 13:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9094160FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 13:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhHLNWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 09:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbhHLNS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 09:18:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F46C0A2361;
        Thu, 12 Aug 2021 06:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X08L51alQnMVg9KdOufAeE0dndlgeltagFK6gEJRxVg=; b=vBoRdjaza7VwRltgGgMfqlUoaB
        dU69jidYLQMzF/Zi7S9rqXehNpZ2OGefHQrnZmjjm99qdKz81kbSpApq8HnvfydWFASxXcmt38CKM
        mFsrIEed6vXOAa2Mofy5u6QiWKuKyvi5iYyyFl3n3gxO9sTvH94O+yvhRZNsmOt16HXRPQ7tmDDQm
        z5TjuPD2geu5D6wWfx4EUUWfFLKmyHO84wwVbEwDrbIfguWrY/aez5sfMoTQQNxJvci2CEeMRotyU
        TDsrZztFiRQZrMV1IQIQSPsF5iYLbEJFGWCc1zG6cPReSWc5FdzSjkkgHiVHoSrinjF4KyQMG0yI6
        qwbdTSzA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEAZ1-00Easv-HL; Thu, 12 Aug 2021 13:16:25 +0000
Date:   Thu, 12 Aug 2021 14:16:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 8/8] iomap: Add writethrough for O_SYNC
Message-ID: <YRUfE5GH7LbyBnSM@infradead.org>
References: <20210811024647.3067739-1-willy@infradead.org>
 <20210811024647.3067739-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811024647.3067739-9-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 03:46:47AM +0100, Matthew Wilcox (Oracle) wrote:
> For O_SYNC writes, if the filesystem has already allocated blocks for
> the range, we can avoid marking the page as dirty and skip straight to
> marking the page as writeback.

So this just optimizes O_SYNC overwrites.  How common are those for
bufered I/O?  I know databases use them a lot with direct I/O, but for
buffere I/O this seems like an odd I/O pattern.
