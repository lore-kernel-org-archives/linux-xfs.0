Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D806EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8428E64FC3
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 13:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhCKNKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhCKNJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 08:09:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1AEC061574
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 05:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lrb4+zakXEJN34pFAY5p3i+AXVAm7zHY42cBoKlrm98=; b=uuIJVdyQ/7XbUN8I3Hif8BgV4M
        NgvIsAyck7tlKJnyM+gBf8NPk/E4ffObALDFh3Ks8CD0fVRsXNZVc3T1QaFkSd66fjMdoYyKqPArd
        +SGo4ZvxpZ7s7jcIylQnTH4LZk9GlPVSMs4BZYjHVPSkZP6w6zN8IFXnNT6SMMHmV1ucNdCOk4Oqo
        q6nK/s3toMSv9MO/ejEM7oliqPEqlFZk7BF6aWdPZXkhouZBCZ97fUmqpqTcNKex6Bsh6Vob6zpOi
        /QeAailwXWqkKDOJyrwx5BL07wjg3gKxYP5mohKOZsuf1oFUJ/pOJGRytsBA4VBiEwavWPeoCDTd2
        LcCpqQqQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKL4D-007L7w-FG; Thu, 11 Mar 2021 13:09:32 +0000
Date:   Thu, 11 Mar 2021 13:09:29 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210311130929.GI1742851@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543195167.1947934.16237799936089844524.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543195167.1947934.16237799936089844524.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 07:05:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the part of _free_eofblocks that decides if it's really going
> to truncate post-EOF blocks into a separate helper function.  The
> upcoming deferred inode inactivation patch requires us to be able to
> decide this prior to actual inactivation.  No functionality changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
