Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1D3C433EA
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B97E20823
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 06:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qGC+uEJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgEVG4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 02:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgEVG4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 02:56:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0643C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 23:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v+QVN0bTgHHdd1jjci03syNbdHBJT586oZ8guQ4U2Ds=; b=qGC+uEJZnqoept67FLgm2th4/v
        ft0p6xAAFqfCz/2ocNh4xWcYRH3T5EqPBZ9WIsFpyHPg4OGFoOJpfxrCqAMsg/Ke/O2QkMrboIa1M
        OcSaFjBOm1tx9YnzJwda8wNRJNM/xlN+aPfgVlXCyhVoZo6TjI/+TjBRa9lDjMZA3Qw9NAMlEEsxx
        Jmyh8eBLB0/bZ+YEwyGd52ntk27qAw7a6KcvGnryv8HEOurdzJHHbBDSFW5xhmfyHDgQ3eE/wQ3qU
        fNTX/xxuTthgX60UC6gE/VmzBipZuVzdj2fS+VJ6BtTdk3yhmuwDTO8EL2AP5Uk+3WRDgrBP6Tf6t
        ke/q9lCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc1bu-0005Qw-IF; Fri, 22 May 2020 06:56:50 +0000
Date:   Thu, 21 May 2020 23:56:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200522065650.GA11266@infradead.org>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
 <159011598984.76931.15076402801787913960.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011598984.76931.15076402801787913960.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're estimating a new speculative preallocation length for an
> extending write, we should walk backwards through the extent list to
> determine the number of number of blocks that are physically and
> logically contiguous with the write offset, and use that as an input to
> the preallocation size computation.
> 
> This way, preallocation length is truly measured by the effectiveness of
> the allocator in giving us contiguous allocations without being
> influenced by the state of a given extent.  This fixes both the problem
> where ZERO_RANGE within an EOF can reduce preallocation, and prevents
> the unnecessary shrinkage of preallocation when delalloc extents are
> turned into unwritten extents.
> 
> This was found as a regression in xfs/014 after changing delalloc writes
> to create unwritten extents during writeback.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

A minor nitpick, though:

> +	struct xfs_iext_cursor	ncur = *icur; /* struct copy */
>
> +	struct xfs_bmbt_irec	prev, got;

The comment is pretty pointless, as the struct copy is obviously form
the syntax (and we do it for the xfs_iext_cursor structure in quite a
few other places).

Also please don't add empty lines between the variable declarations.
