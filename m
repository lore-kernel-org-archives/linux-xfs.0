Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F12C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF44864DF4
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhA1JaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbhA1J1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:27:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D3BC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LCUUVAd5BXBrsof93MaYxpLbgfdEOyphTEdhCEYHNkk=; b=cOJ19H0BNIQC3o7Cn8j5eXk65H
        0+FJeyXhFvK0RAM+0yHUEdnMGBHNpCOsyIEI1xCraypEFBrMZ7qW20tker35hpSY2R7MK1EERcyqE
        1lu96usZv9fPptpKs4AV4TGdQEWaaDBrmOqZgI6HQOc00WLhpei/CImzfMtwO+j+YYmSrk2M381Q0
        4uDzpkY8SO0ITUz7e8E3VV9Vf2I7kzg+Cqm9HyEsMPVf58FgGXvfRy5dSTRvSf0bz+tR80za/U7K0
        mL+MJDMjGYmOGVkw2i5uh2y0sDYyf0r7KqiUTLz0iYz2s/w8Z8Yle9pBiclZqlV9XmoODKxPkeoJO
        /yHUg8BQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53ZZ-008G72-SY; Thu, 28 Jan 2021 09:26:42 +0000
Date:   Thu, 28 Jan 2021 09:26:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210128092641.GB1967319@infradead.org>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
 <161181380328.1525026.14172897140148764735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181380328.1525026.14172897140148764735.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:03:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a fs modification (creation, file write, reflink, etc.) is unable to
> reserve enough space to handle the modification, try clearing whatever
> space the filesystem might have been hanging onto in the hopes of
> speeding up the filesystem.  The flushing behavior will become
> particularly important when we add deferred inode inactivation because
> that will increase the amount of space that isn't actively tied to user
> data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
